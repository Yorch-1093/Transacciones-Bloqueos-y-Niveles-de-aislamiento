--1. Actualizar Contenido Educativo
--Actualizar Contenido Educativo
CREATE OR REPLACE FUNCTION actualizar_contenido_educativo(
    p_id_usuario INT,
    p_nuevo_nombre VARCHAR(255)
) RETURNS BOOLEAN AS $$
BEGIN
    -- Verificar si el usuario existe
    IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE id_usuario = p_id_usuario) THEN
        RAISE EXCEPTION 'El usuario con ID % no existe.', p_id_usuario;
    END IF;

    -- Verificar si el contenido educativo relacionado existe
    IF EXISTS (SELECT 1 FROM Contenido_Educativo WHERE id_usuario = p_id_usuario AND categoria = 'salud fisica') THEN
        -- Actualizar el contenido educativo existente
        UPDATE Contenido_Educativo
        SET nombre = p_nuevo_nombre, updatedAt = CURRENT_TIMESTAMP
        WHERE id_usuario = p_id_usuario AND categoria = 'salud fisica';

        RAISE NOTICE 'El contenido educativo ha sido actualizado.';
    ELSE
        -- Insertar un nuevo contenido educativo si no existe
        INSERT INTO Contenido_Educativo (categoria, nombre, id_usuario)
        VALUES ('salud fisica', p_nuevo_nombre, p_id_usuario);

        RAISE NOTICE 'Se ha insertado un nuevo contenido educativo.';
    END IF;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

SELECT actualizar_contenido_educativo(1, 'Lagartijas');
SELECT * FROM Contenido_Educativo;

--2 Registrar Progreso de Contenido Educativo 
--Primero debemos crear la tabla Progreso_Contenido
CREATE TABLE Progreso_Contenido (
    id_progreso SERIAL PRIMARY KEY,              
    id_usuario INT NOT NULL,                      
    progreso_porcentaje DECIMAL(5, 2) NOT NULL,  
    comentarios VARCHAR(255),                    
    categoria VARCHAR(50) NOT NULL DEFAULT 'salud fisica',  
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) 
	
CREATE OR REPLACE FUNCTION registrar_progreso_contenido(
    p_id_usuario INT,
    p_progreso DECIMAL(5, 2),
    p_comentarios VARCHAR(255)
) RETURNS BOOLEAN AS $$
BEGIN
    -- Verificar si el contenido educativo existe para el usuario
    IF NOT EXISTS (SELECT 1 FROM Contenido_Educativo WHERE id_usuario = p_id_usuario AND categoria = 'salud fisica') THEN
        RAISE EXCEPTION 'No existe contenido educativo para el usuario % en la categoría salud fisica.', p_id_usuario;
    END IF;

    -- Insertar el progreso del contenido educativo
    INSERT INTO Progreso_Contenido (id_usuario, progreso_porcentaje, comentarios, categoria)
    VALUES (p_id_usuario, p_progreso, p_comentarios, 'salud fisica');

    RAISE NOTICE 'Se ha registrado el progreso del contenido educativo para el usuario %.', p_id_usuario;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

SELECT registrar_progreso_contenido(1, 50.00, 'Medio avance en los ejercicios');
SELECT * FROM Progreso_Contenido;

--3. Actualizar Estado de Contenido Educativo Según Progreso
CREATE OR REPLACE FUNCTION actualizar_estado_contenido(
    p_id_usuario INT
) RETURNS VARCHAR(20) AS $$
DECLARE
    progreso_total DECIMAL(5, 2);  -- Variable para almacenar el progreso total
    nuevo_estado VARCHAR(20);       -- Nuevo estado a asignar
BEGIN
    -- Verificar si el contenido educativo para el usuario existe
    IF NOT EXISTS (SELECT 1 FROM Contenido_Educativo WHERE id_usuario = p_id_usuario AND categoria = 'salud fisica') THEN
        RAISE EXCEPTION 'No existe contenido educativo para el usuario % en la categoría salud fisica.', p_id_usuario;
    END IF;

    -- Calcular el progreso acumulado para el contenido educativo del usuario
    SELECT COALESCE(SUM(progreso_porcentaje), 0) INTO progreso_total
    FROM Progreso_Contenido
    WHERE id_usuario = p_id_usuario AND categoria = 'salud fisica';

    -- Determinar el nuevo estado según el progreso
    IF progreso_total = 0 THEN
        nuevo_estado := 'por realizar';  -- Si el progreso es 0
    ELSIF progreso_total > 0 AND progreso_total < 100 THEN
        nuevo_estado := 'en progreso';   -- Si el progreso es menor que 100
    ELSE
        nuevo_estado := 'completada';    -- Si el progreso es 100 o más
    END IF;

    -- Actualizar el estado en la tabla Contenido_Educativo
    UPDATE Contenido_Educativo
    SET estado = nuevo_estado
    WHERE id_usuario = p_id_usuario AND categoria = 'salud fisica';

    -- Retornar el nuevo estado
    RETURN nuevo_estado;
END;
$$ LANGUAGE plpgsql;4

SELECT actualizar_contenido_educativo(2, 'Lagartijas');
SELECT * FROM Contenido_Educativo;
SELECT registrar_progreso_contenido(1, 50.00, 'Medio avance en los ejercicios');
SELECT * FROM Progreso_Contenido;
-- Llamar a la función para actualizar el estado según el progreso
SELECT actualizar_estado_contenido(2);
-- Verificar el estado actualizado en la tabla Contenido_Educativo
SELECT * FROM Contenido_Educativo WHERE id_usuario = 2;



