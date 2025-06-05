% Simula y grafica la trayectoria vertical de un dipolo magnético 
% cayendo a través de una espira con campo Bz.
function zm = trayectoria(Bz,z,mag,m,zo,dt,vz,gamma)
    w = -m * 9.81;          % Peso del objeto (fuerza gravitacional)
    zm(1) = zo;             % Posición inicial del objeto con campo magnético
    zmfree(1) = zo;         % Posición inicial del objeto en caída libre
    vz(1) = 0.7;            % Velocidad inicial del objeto con campo magnético
    vzfree(1) = 0;          % Velocidad inicial en caída libre
    tt(1) = 0;              % Tiempo inicial
    cc = 1;                 % Contador de iteraciones
   
    % Bucle de simulación mientras el objeto no haya pasado z = -3
    while zm(cc) > -3
        % Pequeño incremento para derivada numérica
        delta = 0.005;

        % Aproximación numérica de la derivada de Bz respecto a z (central)
        Bz_forward = interp1(z, Bz, zm(cc) + delta, 'linear', 'extrap');
        Bz_backward = interp1(z, Bz, zm(cc) - delta, 'linear', 'extrap');
        dBz_dz = (Bz_forward - Bz_backward) / (2 * delta);
    
        Fm(cc) = -mag * dBz_dz;         % Fuerza magnética
        Ff = -gamma * vz(cc);           % Fuerza de fricción viscosa
        F(cc) = Fm(cc) + w + Ff;        % Fuerza total
        a = F(cc) / m;                  % Aceleración según segunda Ley de Newton

        % Posición y velocidad usando cinemática básica
        zm(cc+1) = zm(cc) + vz(cc)*dt + 0.5*a*dt^2;
        vz(cc+1) = vz(cc) + a*dt;
    
        % Simulación de la trayectoria en caída libre (solo gravedad)
        zmfree(cc+1) = zmfree(cc) + vzfree(cc)*dt + 0.5*(-9.81)*dt^2;
        vzfree(cc+1) = vzfree(cc) + (-9.81)*dt;
        
        % Versión con Runge-Kutta 4 para mayor precisión
        z_axis=z;
        [zm(cc+1),vz(cc+1)]=rk4_step(zm(cc), vz(cc), dt, @(z,v) a_func(z,v, Bz, z_axis, mag, gamma, m));

        % Avance del tiempo
        tt(cc+1) = tt(cc) + dt;
        cc = cc + 1;
    
        % Condición de paro si la velocidad es muy baja
        if abs(vz(cc)) < 1e-3
            break
        end
    end

     % Gráfica de la trayectoria
    figure(99)
    hold on
    % Trayectoria con espira cargada
    plot(tt,zm, 'r-', 'LineWidth',2)
    % Trayectoria sin campo (caída libre)
    plot(tt,zmfree,'b--','LineWidth',2)
    grid on 
    xlabel('Time(s)')
    ylabel('Z position (m)')
    title(' Posicion vs tiempo en un Dipolo magnetico callendo a traves de una espira cargada ')
    legend('Trayectoria con la espira cargada', 'Trayectoria de caida libre','Southwest')
    axis([0 max(tt) -6 6])
end


% Función para calcular aceleración total basada en posición y velocidad
function a=a_func(z, v, Bz, z_axis, mag, gamma, m)
    delta=0.005;
    Bz_forward=interp1(z_axis,Bz, z + delta, 'linear','extrap');
    Bz_backward=interp1(z_axis,Bz, z - delta, 'linear','extrap');
    dbz_dz=(Bz_forward-Bz_backward)/(2*delta);
  
    Fm = -mag * dbz_dz;         % Fuerza magnética
    Ff = -gamma * v;            % Fuerza de fricción
    F = Fm + Ff - m * 9.81;     % Fuerza total neta
    a = F / m;                  % Aceleración resultante
end


% Función para un paso del método de Runge-Kutta 4 para sistemas de 2 ecuaciones (z y v)
function [z_next, v_next]=rk4_step(z,v,dt, a_total)
    % k1: derivadas iniciales
    k1z=v;
    k1v=a_total(z,v);

    % k2: aproximación a la mitad del paso
    k2z=v +(dt/2)*k1v;
    k2v=a_total(z+(dt/2)*k1z,v+(dt/2)*k1v);

    % k3: otra estimación a mitad del paso
    k3z=v+(dt/2)*k2v;
    k3v=a_total(z+(dt/2)*k2z,v+(dt/2)*k2v);

    % k4: estimación al final del pas
    k4z=v+dt*k3v;
    k4v=a_total(z+(dt*k3z),v+(dt*k3v));

    % Combinación de todas las estimaciones
    z_next= z + (dt/6)*(k1z+2*k2z+2*k3z+k4z);
    v_next= v + (dt/6)*(k1v+2*k2v+2*k3v+k4v);
end