--1.  actualizar_meta. 
--Permite actualizar la información de una meta existente: descripción, fecha de inicio, fecha de fin y 
--estado de la meta.
-- Solo se aceptan valores como: por realizar, en progreso, completada, dada de baja. 

CREATE OR REPLACE FUNCTION actualizar_meta(
    p_id_meta INT,
    p_descripcion VARCHAR(255),
    p_fecha_fin DATE,
    p_estado VARCHAR(20)
) RETURNS BOOLEAN AS $$
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

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Ejemplo de uso:
SELECT actualizar_meta(10, 'Correr por 30 dias', '2024-12-31', 'en progreso');
select * from metas;

--2. Registrar progreso por meta. Actualiza al información de uan meta existente. 
--Porcentaje, fecha de actualización y comentarios.
CREATE OR REPLACE FUNCTION registrar_progreso_meta(
    p_id_meta INT,
    p_progreso_porcentaje DECIMAL(5, 2),
    p_fecha_actualizacion DATE,
    p_comentarios VARCHAR(255)
) RETURNS BOOLEAN AS $$
BEGIN
    -- Validar si la meta existe
    IF NOT EXISTS (SELECT 1 FROM Metas WHERE id_meta = p_id_meta) THEN
        RAISE EXCEPTION 'La meta con ID % no existe.', p_id_meta;
    END IF;

    -- Insertar registro de progreso
    INSERT INTO Progreso_Metas (id_meta, progreso_porcentaje, fecha_actualizacion, comentarios)
    VALUES (p_id_meta, p_progreso_porcentaje, p_fecha_actualizacion, p_comentarios);

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Ejemplo de uso:
SELECT registrar_progreso_meta(10, 100.00, '2024-12-07', 'Primeros pasos completados');

select * from progreso_metas;

--3. Actualizar el estado por progreso.
--Actualiza automáticamente el estado de una meta según el porcentaje de progreso acumulado. 

CREATE OR REPLACE FUNCTION actualizar_estado_por_progreso(
    p_id_meta INT
) RETURNS VARCHAR(20) AS $$
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

    -- Imprimir progreso acumulado para depuración
    RAISE NOTICE 'Progreso total acumulado para la meta %: %', p_id_meta, progreso_total;

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

    -- Imprimir nuevo estado para depuración
    RAISE NOTICE 'Nuevo estado para la meta %: %', p_id_meta, nuevo_estado;

    -- Retornar el nuevo estado
    RETURN nuevo_estado;
END;
$$ LANGUAGE plpgsql;




SELECT actualizar_estado_por_progreso(10);

select * from progreso_metas;

select * from metas;

select * from usuarios;









