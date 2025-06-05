% Esta función genera una animación de un punto moviéndose verticalmente
% sobre una imagen de fondo, y la guarda como un archivo de video.
function animar_con_fondo(zm, imagen, nombre_video)
    % zm: vector con posiciones del objeto
    % imagen: nombre del archivo de imagen de fondo (png)
    % nombre_video: nombre del video de salida (mp4)

    % Rango físico que usaste para graficar tu imagen
    x_range = [-6, 6];
    z_range = [-6, 6];

    % Crear objeto de video
    writerObj = VideoWriter(nombre_video, 'MPEG-4'); 
    writerObj.FrameRate = 30; % Puedes bajarlo para hacer la animación más lenta
    open(writerObj);

    % Cargar imagen
    img = imread(imagen);

    % Crear una figura para la animación
    figure(100); clf;

    % Mostrar la imagen de fondo en el rango definido
    imagesc(x_range, z_range, flipud(img)); % Imagen de fondo
    % Asegura que el eje Z crezca hacia arriba
    axis xy;
   % Permite superponer gráficos sobre la imagen
    hold on;

    % Etiquetas y título del gráfico
    xlabel('x (m)');
    ylabel('z (m)');
    title('Trayectoria sobre campo magnético');

    % Simular trayectoria punto a punto
    for i = 1:length(zm)
        cla;
        
        % Redibujar fondo
        imagesc(x_range, z_range, flipud(img)); 
        axis xy;
        hold on;
        
        % Dibujar el punto en la posición actual de la trayectoria 
        scatter(0, zm(i), 100, 'r', 'filled');
        
        % Fijar límites del gráfico
        xlim(x_range);
        ylim(z_range);
       
        % Capturar el cuadro actual de la figura
        frame = getframe(gcf);
        % Escribir ese cuadro en el video
        writeVideo(writerObj, frame);
    end

    % Cerrar el archivo de video
    close(writerObj);
    disp(['Video guardado como ', nombre_video]);
end