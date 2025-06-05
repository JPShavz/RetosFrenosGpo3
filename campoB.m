% Esta función calcula el campo magnético B (especialmente Bz) generado por
    % un conjunto de segmentos de corriente en una malla 3D.
function [Bz,z] = campoB(ds,km,Px, Py, Pz, dx, dy, nl, N, rw, plot_option)
    % ds: paso de malla (resolución espacial)
    % km: constante km = μ₀/4π
    % Px, Py, Pz: coordenadas de los segmentos de corriente
    % dx, dy: componentes del vector corriente
    % nl: número de espiras
    % N: número de segmentos por espira
    % rw: parámetro de regularización (evita singularidades)
    % plot_option: 
    % Verdadero = grafica campo en XZ
    % also = calcula gradiente

    % Definir la malla de puntos de evaluación del campo
    x = -5:ds:5; 
    y = x; 
    z = x;

    % Si se quiere graficar el campo: usar malla amplia en X y Z
    if plot_option
        x=z;
        y=z;
    % Si no se quiere graficar: usar una malla  
    % más pequeña y precisa alrededor del eje
    else
        x=-0.1:0.01:0.1;
        y=-0.1:0.01:0.1;
    end

    % Obtener dimensiones de la malla
    Lx = length(x); Ly = length(y); Lz = length(z);
     % Inicializar matrices de componentes del campo magnético
    dBx = zeros(Lx, Ly, Lz,'single'); dBy = dBx; dBz = dBx;
    
    % Calcular el campo magnético total en cada punto de la malla
    for i = 1:Lx
        for j = 1:Ly
            for k = 1:Lz
                for l = 1:nl*N
                    % Vector desde el segmento de corriente l
                    % hasta el punto (i,j,k)
                    rx = x(i)-Px(l);
                    ry = y(j)-Py(l);
                    rz = z(k)-Pz(l);
                    
                    % Distancia cúbica regularizada
                    r = sqrt(rx^2+ry^2+rz^2+rw^2);
                    r3 = r^3;
    
                    % Cálculo de la contribución diferencial de B
                    dBx(i,j,k) = dBx(i,j,k)+km*dy(l)*rz/r3;
                    dBy(i,j,k) = dBy(i,j,k)+km*dx(l)*rz/r3;
                    dBz(i,j,k) = dBz(i,j,k)+km*(dx(l)*ry-dy(l)*rx)/r3;
    
                end
            end
        end
    end
   
    % Modo de visualización del campo magnético en plano XZ 
    if plot_option 
        % Magnitud total del campo
        Bmag = sqrt(dBx.^2+dBy.^2+dBz.^2);
       
        % Tomar una "rebanada" en el centro del eje Y
        centery = round(Ly/2);
        Bx_xz = squeeze(dBx(:,centery,:));
        Bz_xz = squeeze(dBz(:,centery,:));
        Bxz = squeeze(Bmag(:,centery,:));
        
        % Visualizar magnitud del campo y líneas de flujo en el plano XZ
        figure(2);
        hold on;
        pcolor(x,y,(Bxz').^(1/3)); shading interp; colormap jet; colorbar;
        
        % Líneas de flujo del campo (streamslice)
        h1 = streamslice(x,z,Bx_xz',Bz_xz',3);
        set(h1,'Color',[0.8 1 0.9]);
        exportgraphics(figure(2) , 'campo_magnetico.png','Resolution', 300);
        Bz=1;

    % Modo de análisis: se extrae el perfil de Bz y su gradiente 
    else
        % Obtener la línea central en X=0, Y=0 para Bz
        idx_x = ceil(Lx/2);
        idx_y = ceil(Ly/2);
        Bz = squeeze(dBz(idx_x, idx_y,:));

        % Calcular gradiente del campo
        dBz_dz_profile = diff(Bz)./diff(z);
        z_mid=z(1:end-1) + diff(z)/2;
        
        % Graficar el gradiente del campo magnético
        figure
        plot(z_mid,dBz_dz_profile, 'r-','LineWidth',2)
        xlabel('z'); ylabel('dBz/dz')
        title('Gradiente del campo magnético de Bz')
   end
end