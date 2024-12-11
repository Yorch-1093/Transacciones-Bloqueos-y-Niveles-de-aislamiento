
--1. Agrega un nuevo consejo 
CREATE OR REPLACE PROCEDURE agregar_consejo(
    p_texto TEXT,
    p_id_usuario INT
)
AS $$
BEGIN
    -- Validar que el usuario exista
    IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE id_usuario = p_id_usuario) THEN
        RAISE EXCEPTION 'El usuario con ID % no existe.', p_id_usuario;
    END IF;

    -- Insertar el nuevo consejo
    INSERT INTO Consejos (texto, id_usuario, createdAt, updatedAt)
    VALUES (p_texto, p_id_usuario, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

    RAISE NOTICE 'Consejo agregado exitosamente.';
END;
$$ LANGUAGE plpgsql;


CALL agregar_consejo('No dejes para mañana lo que puedes hacer hoy.', 1);
select*from consejos;


--2. Actualiza un consejo 
CREATE OR REPLACE PROCEDURE actualizar_consejo(
    p_id_consejo INT,
    p_nuevo_texto TEXT
)
AS $$
BEGIN
    -- Validar que el consejo exista
    IF NOT EXISTS (SELECT 1 FROM Consejos WHERE id_consejo = p_id_consejo) THEN
        RAISE EXCEPTION 'El consejo con ID % no existe.', p_id_consejo;
    END IF;

    -- Actualizar el texto del consejo
    UPDATE Consejos
    SET texto = p_nuevo_texto,
        updatedAt = CURRENT_TIMESTAMP
    WHERE id_consejo = p_id_consejo;

    RAISE NOTICE 'Consejo actualizado exitosamente.';
END;
$$ LANGUAGE plpgsql;

CALL actualizar_consejo(2, 'El esfuerzo siempre tiene recompensa.');
select*from consejos;

--3. Elimina un consejo 
CREATE OR REPLACE PROCEDURE eliminar_consejo(
    p_id_consejo INT
)
AS $$
BEGIN
    -- Validar que el consejo exista
    IF NOT EXISTS (SELECT 1 FROM Consejos WHERE id_consejo = p_id_consejo) THEN
        RAISE EXCEPTION 'El consejo con ID % no existe.', p_id_consejo;
    END IF;

    -- Eliminar el consejo
    DELETE FROM Consejos
    WHERE id_consejo = p_id_consejo;

    RAISE NOTICE 'Consejo eliminado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Ejemplo de uso:
CALL eliminar_consejo(2);

--4.Consultar un consejo 

CREATE OR REPLACE PROCEDURE consultar_consejos_usuario(
    p_id_usuario INT
)
AS $$
DECLARE
    rec RECORD;
BEGIN
    -- Validar que el usuario exista
    IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE id_usuario = p_id_usuario) THEN
        RAISE EXCEPTION 'El usuario con ID % no existe.', p_id_usuario;
    END IF;

    -- Mostrar los consejos del usuario
    RAISE NOTICE 'Consejos del usuario %:', p_id_usuario;

    FOR rec IN
        SELECT id_consejo, texto, createdAt, updatedAt
        FROM Consejos
        WHERE id_usuario = p_id_usuario
    LOOP
        RAISE NOTICE 'ID: %, Texto: %, Creado: %, Actualizado: %', 
                     rec.id_consejo, rec.texto, rec.createdAt, rec.updatedAt;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CALL consultar_consejos_usuario(2);


--5. Obtener un consejos recientes

CREATE OR REPLACE FUNCTION obtener_consejos_recientes(
    _fecha_inicio TIMESTAMP
)
RETURNS TABLE(
    id_consejo INT, 
    texto VARCHAR(1000),  
    id_usuario INT, 
    createdAt TIMESTAMP, 
    updatedAt TIMESTAMP
) AS $$
BEGIN
    -- Devolver los consejos desde la fecha proporcionada
    RETURN QUERY
    SELECT c.id_consejo, c.texto, c.id_usuario, c.createdAt, c.updatedAt
    FROM Consejos c
    WHERE c.createdAt >= _fecha_inicio
    ORDER BY c.createdAt DESC;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM obtener_consejos_recientes('2024-12-01 00:00:00');






