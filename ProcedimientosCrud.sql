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


--  3) SEDES


-- Crear Sede
DROP PROCEDURE IF EXISTS crear_sede $$
CREATE PROCEDURE crear_sede(
    IN p_codigo VARCHAR(10),
    IN p_nombre VARCHAR(100),
    IN p_direccion VARCHAR(150),
    IN p_id_ciudad INT,
    IN p_telefono VARCHAR(20),
    IN p_estado VARCHAR(10)
)
BEGIN
    INSERT INTO sedes(codigo, nombre, direccion, id_ciudad, telefono, estado)
    VALUES(p_codigo, p_nombre, p_direccion, p_id_ciudad, p_telefono, p_estado);
END $$


-- Ver Sedes
DROP PROCEDURE IF EXISTS listar_sedes $$
CREATE PROCEDURE listar_sedes()
BEGIN
    SELECT s.id_sede, s.codigo, s.nombre, s.direccion, s.telefono, s.estado,
           c.nombre AS ciudad, c.departamento
    FROM sedes s
    INNER JOIN ciudades c ON s.id_ciudad = c.id_ciudad
    ORDER BY s.nombre;
END $$

DROP PROCEDURE IF EXISTS buscar_sede $$
CREATE PROCEDURE buscar_sede(
    IN p_id INT
)
BEGIN
    SELECT *
    FROM sedes
    WHERE id_sede = p_id;
END $$

-- Editar Sede
DROP PROCEDURE IF EXISTS editar_sede $$
CREATE PROCEDURE editar_sede(
    IN p_id INT,
    IN p_codigo VARCHAR(10),
    IN p_nombre VARCHAR(100),
    IN p_direccion VARCHAR(150),
    IN p_id_ciudad INT,
    IN p_telefono VARCHAR(20),
    IN p_estado VARCHAR(10)
)
BEGIN
    UPDATE sedes
    SET codigo = p_codigo,
        nombre = p_nombre,
        direccion = p_direccion,
        id_ciudad = p_id_ciudad,
        telefono = p_telefono,
        estado = p_estado
    WHERE id_sede = p_id;
END $$


-- Eliminar Sede (Cambiar estado a INACTIVO)
DROP PROCEDURE IF EXISTS eliminar_sede $$
CREATE PROCEDURE eliminar_sede(
    IN p_id INT
)
BEGIN
    UPDATE sedes
    SET estado = 'INACTIVO'
    WHERE id_sede = p_id;
END $$


-- 4) BODEGAS

-- Crear Bodega
DROP PROCEDURE IF EXISTS crear_bodega $$
CREATE PROCEDURE crear_bodega(
    IN p_codigo VARCHAR(10),
    IN p_nombre VARCHAR(100),
    IN p_descripcion VARCHAR(150),
    IN p_id_sede INT,
    IN p_estado VARCHAR(10)
)
BEGIN
    INSERT INTO bodegas(codigo, nombre, descripcion, id_sede, estado)
    VALUES(p_codigo, p_nombre, p_descripcion, p_id_sede, p_estado);
END $$


-- Ver Bodegas
DROP PROCEDURE IF EXISTS listar_bodegas $$
CREATE PROCEDURE listar_bodegas()
BEGIN
    SELECT b.id_bodega, b.codigo, b.nombre, b.descripcion, b.estado,
           s.nombre AS sede
    FROM bodegas b
    INNER JOIN sedes s ON b.id_sede = s.id_sede
    ORDER BY b.nombre;
END $$

-- Buscar Bodega
DROP PROCEDURE IF EXISTS buscar_bodega $$
CREATE PROCEDURE buscar_bodega(
    IN p_id INT
)
BEGIN
    SELECT *
    FROM bodegas
    WHERE id_bodega = p_id;
END $$


-- Editar Bodega
DROP PROCEDURE IF EXISTS editar_bodega $$
CREATE PROCEDURE editar_bodega(
    IN p_id INT,
    IN p_codigo VARCHAR(10),
    IN p_nombre VARCHAR(100),
    IN p_descripcion VARCHAR(150),
    IN p_id_sede INT,
    IN p_estado VARCHAR(10)
)
BEGIN
    UPDATE bodegas
    SET codigo = p_codigo,
        nombre = p_nombre,
        descripcion = p_descripcion,
        id_sede = p_id_sede,
        estado = p_estado
    WHERE id_bodega = p_id;
END $$


-- Eliminar Bodega (Cambiar estado a INACTIVO)
DROP PROCEDURE IF EXISTS eliminar_bodega $$
CREATE PROCEDURE eliminar_bodega(
    IN p_id INT
)
BEGIN
    UPDATE bodegas
    SET estado = 'INACTIVO'
    WHERE id_bodega = p_id;
END $$


--  5) MEDIOS DE PAGO

-- Crear Medio de Pago
DROP PROCEDURE IF EXISTS crear_medio_pago $$
CREATE PROCEDURE crear_medio_pago(
    IN p_codigo VARCHAR(20),
    IN p_nombre VARCHAR(50),
    IN p_descripcion VARCHAR(150),
    IN p_estado VARCHAR(10)
)
BEGIN
    INSERT INTO medios_pago(codigo, nombre, descripcion, estado)
    VALUES(p_codigo, p_nombre, p_descripcion, p_estado);
END $$

-- Ver Medios de Pago
DROP PROCEDURE IF EXISTS listar_medios_pago $$
CREATE PROCEDURE listar_medios_pago()
BEGIN
    SELECT *
    FROM medios_pago
    ORDER BY nombre;
END $$

-- Buscar Medio de Pago
DROP PROCEDURE IF EXISTS buscar_medio_pago $$
CREATE PROCEDURE buscar_medio_pago(
    IN p_id INT
)
BEGIN
    SELECT *
    FROM medios_pago
    WHERE id_medio_pago = p_id;
END $$

-- Editar Medio de Pago
DROP PROCEDURE IF EXISTS editar_medio_pago $$
CREATE PROCEDURE editar_medio_pago(
    IN p_id INT,
    IN p_codigo VARCHAR(20),
    IN p_nombre VARCHAR(50),
    IN p_descripcion VARCHAR(150),
    IN p_estado VARCHAR(10)
)
BEGIN
    UPDATE medios_pago
    SET codigo = p_codigo,
        nombre = p_nombre,
        descripcion = p_descripcion,
        estado = p_estado
    WHERE id_medio_pago = p_id;
END $$


-- Eliminar Medio de Pago (Cambiar estado a INACTIVO)
DROP PROCEDURE IF EXISTS eliminar_medio_pago $$
CREATE PROCEDURE eliminar_medio_pago(
    IN p_id INT
)
BEGIN
    UPDATE medios_pago
    SET estado = 'INACTIVO'
    WHERE id_medio_pago = p_id;
END $$


-- 6) CATEGORIAS

-- Crear Categoria
DROP PROCEDURE IF EXISTS crear_categoria $$
CREATE PROCEDURE crear_categoria(
    IN p_codigo VARCHAR(20),
    IN p_nombre VARCHAR(80),
    IN p_descripcion VARCHAR(150),
    IN p_estado VARCHAR(10)
)
BEGIN
    INSERT INTO categorias(codigo, nombre, descripcion, estado)
    VALUES(p_codigo, p_nombre, p_descripcion, p_estado);
END $$

-- Ver Categorias
DROP PROCEDURE IF EXISTS listar_categorias $$
CREATE PROCEDURE listar_categorias()
BEGIN
    SELECT *
    FROM categorias
    ORDER BY nombre;
END $$

--  Buscar Categoria

DROP PROCEDURE IF EXISTS buscar_categoria $$
CREATE PROCEDURE buscar_categoria(
    IN p_id INT
)
BEGIN
    SELECT *
    FROM categorias
    WHERE id_categoria = p_id;
END $$

-- Editar Categoria

DROP PROCEDURE IF EXISTS editar_categoria $$
CREATE PROCEDURE editar_categoria(
    IN p_id INT,
    IN p_codigo VARCHAR(20),
    IN p_nombre VARCHAR(80),
    IN p_descripcion VARCHAR(150),
    IN p_estado VARCHAR(10)
)
BEGIN
    UPDATE categorias
    SET codigo = p_codigo,
        nombre = p_nombre,
        descripcion = p_descripcion,
        estado = p_estado
    WHERE id_categoria = p_id;
END $$

-- Eliminar Categoria (Cambiar estado a INACTIVO)

DROP PROCEDURE IF EXISTS eliminar_categoria $$
CREATE PROCEDURE eliminar_categoria(
    IN p_id INT
)
BEGIN
    UPDATE categorias
    SET estado = 'INACTIVO'
    WHERE id_categoria = p_id;
END $$
