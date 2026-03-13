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


-- 2) CIUDADES

-- Crear Ciudad

DROP PROCEDURE IF EXISTS crear_ciudad $$
CREATE PROCEDURE crear_ciudad(
    IN p_nombre VARCHAR(80),
    IN p_departamento VARCHAR(80)
)
BEGIN
    INSERT INTO ciudades(nombre, departamento)
    VALUES(p_nombre, p_departamento);
END $$

-- Ver ciudades

DROP PROCEDURE IF EXISTS listar_ciudades $$
CREATE PROCEDURE listar_ciudades()
BEGIN
    SELECT *
    FROM ciudades
    ORDER BY departamento, nombre;
END $$

DROP PROCEDURE IF EXISTS buscar_ciudad $$
CREATE PROCEDURE buscar_ciudad(
    IN p_id INT
)
BEGIN
    SELECT *
    FROM ciudades
    WHERE id_ciudad = p_id;
END $$

-- Editar Ciudad

DROP PROCEDURE IF EXISTS editar_ciudad $$
CREATE PROCEDURE editar_ciudad(
    IN p_id INT,
    IN p_nombre VARCHAR(80),
    IN p_departamento VARCHAR(80)
)
BEGIN
    UPDATE ciudades
    SET nombre = p_nombre,
        departamento = p_departamento
    WHERE id_ciudad = p_id;
END $$


-- Eliminar Ciudad
DROP PROCEDURE IF EXISTS eliminar_ciudad $$
CREATE PROCEDURE eliminar_ciudad(
    IN p_id INT
)
BEGIN
    DELETE FROM ciudades
    WHERE id_ciudad = p_id;
END $$


