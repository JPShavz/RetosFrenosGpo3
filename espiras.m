% Esta función genera la geometría de múltiples espiras circulares con corriente
% y calcula los vectores de corriente asociados. También grafica las espiras en 3D.
function [Px,Py,Pz,dx,dy,dz] = espiras(nl,N,R,sz)
    % nl: número de espiras (capas en el eje z)
    % N: número de segmentos por espira (resolución angular)
    % R: radio de cada espira
    % sz: separación entre espiras (no se usa en este código, se sobrescribe a 1)

    % Ángulo entre segmentos
    dtheta = 2*pi/N;
    % Vector de ángulos que define los puntos de la espira
    ang = 0:dtheta:(2*pi-dtheta);

    sz=1; % Fijar separación entre espiras en 1 
    s=1; % Índice inicial para almacenar datos en los vectores

    for i = 1:nl
        % Coordenadas X e Y de la espira i
        Px(s:s+N-1) = R*cos(ang);
        Py(s:s+N-1) = R*sin(ang);
        
        % Coordenada Z constante para todos los puntos de la espira i
        Pz(s:s+N-1) = -nl/2*sz+(i-1)*sz;
    
         % Componentes del vector de corriente (tangente al círculo)
        dx(s:s+N-1) = -Py(s:s+N-1)*dtheta;
        dy(s:s+N-1) = Px(s:s+N-1)*dtheta;
        
        % Avanzamos el índice para la siguiente espira
        s=s+N;
    end

    % No hay componente de corriente en z (espiras planas)
    dz = zeros(1, N*nl);

    % Gráfica de las espiras y sus vectores de corriente
    figure(1)
    quiver3(Px,Py,Pz,dx,dy,dz,0.5,'-r','LineWidth',2)
    view(-34,33)
    xlabel('x'); ylabel('y');zlabel('z')
    title('Corriente de espiras')
    axis equal
    
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
        