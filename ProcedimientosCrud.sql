 -- 1) TIPOS DE IDENTIFICACION


-- Crear Identificacion
DELIMITER $$
DROP PROCEDURE IF EXISTS crear_tipo_identificacion $$
CREATE PROCEDURE crear_tipo_identificacion(
    IN p_codigo VARCHAR(10),
    IN p_nombre VARCHAR(50),
    IN p_descripcion VARCHAR(150)
)
BEGIN
    INSERT INTO tipos_identificacion(codigo, nombre, descripcion)
    VALUES(p_codigo, p_nombre, p_descripcion);
END $$

-- Ver tipos de Identificacion

DROP PROCEDURE IF EXISTS listar_tipos_identificacion $$
CREATE PROCEDURE listar_tipos_identificacion()
BEGIN
    SELECT *
    FROM tipos_identificacion
    ORDER BY nombre;
END $$


-- Buscar tipo Identificacion 

DROP PROCEDURE IF EXISTS buscar_tipo_identificacion $$
CREATE PROCEDURE buscar_tipo_identificacion(
    IN p_id INT
)
BEGIN
    SELECT *
    FROM tipos_identificacion
    WHERE id_tipo_identificacion = p_id;
END $$

-- Editar tipo Identificacion

DROP PROCEDURE IF EXISTS editar_tipo_identificacion $$
CREATE PROCEDURE editar_tipo_identificacion(
    IN p_id INT,
    IN p_codigo VARCHAR(10),
    IN p_nombre VARCHAR(50),
    IN p_descripcion VARCHAR(150)
)
BEGIN
    UPDATE tipos_identificacion
    SET codigo = p_codigo,
        nombre = p_nombre,
        descripcion = p_descripcion
    WHERE id_tipo_identificacion = p_id;
END $$

-- Eliminar tipo Identificacion

DROP PROCEDURE IF EXISTS eliminar_tipo_identificacion $$
CREATE PROCEDURE eliminar_tipo_identificacion(
    IN p_id INT
)
BEGIN
    DELETE FROM tipos_identificacion
    WHERE id_tipo_identificacion = p_id;
END $$