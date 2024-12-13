--1.  actualizar_meta. 
--Permite actualizar la información de una meta existente: descripción, fecha de inicio, fecha de fin y 
--estado de la meta.
-- Solo se aceptan valores como: por realizar, en progreso, completada, dada de baja. 

-- Procedimiento almacenado para actualizar una meta existente
CREATE OR REPLACE PROCEDURE actualizar_meta(
    p_id_meta INT,
    p_descripcion VARCHAR(255),
    p_fecha_fin DATE,
    p_estado VARCHAR(20)
)
AS $$
BEGIN
    -- Validar si la meta existe
    IF NOT EXISTS (SELECT 1 FROM Metas WHERE id_meta = p_id_meta) THEN
        RAISE EXCEPTION 'La meta con ID % no existe.', p_id_meta;
    END IF;

    -- Convertir el estado a minúsculas
    p_estado := LOWER(p_estado);

    -- Validar que el estado esté entre los valores permitidos
    IF p_estado NOT IN ('por realizar', 'en progreso', 'completada', 'dada de baja') THEN
        RAISE EXCEPTION 'Estado inválido: %. Los valores permitidos son: por realizar, en progreso, completada, dada de baja', p_estado;
    END IF;

    -- Actualizar meta
    UPDATE Metas
    SET descripcion = p_descripcion,
        fechaFin = p_fecha_fin,
        estado = p_estado
    WHERE id_meta = p_id_meta;

    RAISE NOTICE 'Meta con ID % actualizada correctamente.', p_id_meta;
END;
$$ LANGUAGE plpgsql;



-- Ejemplo de uso:
CALL actualizar_meta(10, 'Correr por 30 días', '2024-12-31', 'en progreso');
SELECT * FROM Metas;

--2. Registrar progreso por meta. Actualiza al información de uan meta existente. 
--Porcentaje, fecha de actualización y comentarios.
-- Procedimiento almacenado para registrar el progreso de una meta
CREATE OR REPLACE PROCEDURE registrar_progreso_meta(
    p_id_meta INT,
    p_progreso_porcentaje DECIMAL(5, 2),
    p_fecha_actualizacion DATE,
    p_comentarios VARCHAR(255)
)
AS $$
BEGIN
    -- Validar si la meta existe
    IF NOT EXISTS (SELECT 1 FROM Metas WHERE id_meta = p_id_meta) THEN
        RAISE EXCEPTION 'La meta con ID % no existe.', p_id_meta;
    END IF;

    -- Insertar registro de progreso
    INSERT INTO Progreso_Metas (id_meta, progreso_porcentaje, fecha_actualizacion, comentarios)
    VALUES (p_id_meta, p_progreso_porcentaje, p_fecha_actualizacion, p_comentarios);

    RAISE NOTICE 'Progreso registrado para la meta con ID %.', p_id_meta;
END;
$$ LANGUAGE plpgsql;

-- Ejemplo de uso:
CALL registrar_progreso_meta(10, 100.00, '2024-12-07', 'Primeros pasos completados');
SELECT * FROM Progreso_Metas;


--3. Actualizar el estado por progreso.
--Actualiza automáticamente el estado de una meta según el porcentaje de progreso acumulado. 

-- Procedimiento almacenado para actualizar el estado de la meta basado en el progreso
CREATE OR REPLACE PROCEDURE actualizar_estado_por_progreso(
    p_id_meta INT
)
AS $$
DECLARE
    progreso_total DECIMAL(5, 2); -- Variable para acumular el progreso
    nuevo_estado VARCHAR(20);    -- Nuevo estado a asignar
BEGIN
    -- Validar si la meta existe
    IF NOT EXISTS (SELECT 1 FROM Metas WHERE id_meta = p_id_meta) THEN
        RAISE EXCEPTION 'La meta con ID % no existe.', p_id_meta;
    END IF;

    -- Calcular el progreso acumulado
    SELECT COALESCE(SUM(progreso_porcentaje), 0) INTO progreso_total
    FROM Progreso_Metas
    WHERE id_meta = p_id_meta;

    -- Determinar el nuevo estado según las condiciones
    IF progreso_total >= 100 THEN
        nuevo_estado := 'completada'; -- Si el progreso es 100 o más
    ELSE
        IF progreso_total > 0 AND progreso_total < 100 THEN
            nuevo_estado := 'en progreso'; -- Si el progreso está entre 0 y 100
        ELSE
            nuevo_estado := 'por realizar'; -- Si el progreso es 0
        END IF;
    END IF;

    -- Actualizar el estado en la tabla Metas
    UPDATE Metas
    SET estado = nuevo_estado
    WHERE id_meta = p_id_meta;

    RAISE NOTICE 'Nuevo estado para la meta con ID %: %', p_id_meta, nuevo_estado;
END;
$$ LANGUAGE plpgsql;


--Ejemplo de uso:
CALL actualizar_estado_por_progreso(10);

SELECT * FROM Progreso_Metas;

SELECT * FROM Metas;


-- 4. Eliminar meta. 
-- Elimina una meta si está "dada de baja" o "completada"
CREATE OR REPLACE PROCEDURE eliminar_meta_condicional(
    _id_meta INT
)
AS $$
DECLARE
    meta_estado VARCHAR(20);  -- Variable para almacenar el estado de la meta
BEGIN
    -- Validar si la meta existe
    IF NOT EXISTS (SELECT 1 FROM Metas WHERE id_meta = _id_meta) THEN
        RAISE EXCEPTION 'La meta con ID % no existe.', _id_meta;
    END IF;

    -- Obtener el estado de la meta
    SELECT estado INTO meta_estado
    FROM Metas
    WHERE id_meta = _id_meta;

    -- Verificar si el estado es "dada de baja" o "completada"
    IF meta_estado IN ('dada de baja', 'completada') THEN
        -- Eliminar la meta
        DELETE FROM Metas WHERE id_meta = _id_meta;
        RAISE NOTICE 'La meta con ID % ha sido eliminada correctamente.', _id_meta;
    ELSE
        -- Si el estado no es permitido, lanzar una excepción
        RAISE EXCEPTION 'No se puede eliminar la meta con ID % porque su estado es %.', _id_meta, meta_estado;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Ejmplo de uso:
CALL eliminar_meta_condicional(3);


SELECT * FROM Metas WHERE id_meta = 10;

SELECT * FROM Metas;




