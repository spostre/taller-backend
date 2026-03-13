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


--7) PRODUCTOS

-- Crear Producto
DROP PROCEDURE IF EXISTS crear_producto $$
CREATE PROCEDURE crear_producto(
    IN p_codigo VARCHAR(30),
    IN p_nombre VARCHAR(120),
    IN p_descripcion VARCHAR(255),
    IN p_id_categoria INT,
    IN p_iva DECIMAL(5,2),
    IN p_utilidad DECIMAL(7,2),
    IN p_garantia_empresa INT,
    IN p_garantia_proveedor INT,
    IN p_estado VARCHAR(10)
)
BEGIN
    INSERT INTO productos(
        codigo, nombre, descripcion, id_categoria, iva_porcentaje,
        porcentaje_utilidad, meses_garantia_empresa, meses_garantia_proveedor, estado
    )
    VALUES(
        p_codigo, p_nombre, p_descripcion, p_id_categoria, p_iva,
        p_utilidad, p_garantia_empresa, p_garantia_proveedor, p_estado
    );
END $$

-- Ver Productos
DROP PROCEDURE IF EXISTS listar_productos $$
CREATE PROCEDURE listar_productos()
BEGIN
    SELECT p.id_producto, p.codigo, p.nombre, p.descripcion,
           c.nombre AS categoria,
           p.iva_porcentaje, p.porcentaje_utilidad,
           p.meses_garantia_empresa, p.meses_garantia_proveedor, p.estado
    FROM productos p
    INNER JOIN categorias c ON p.id_categoria = c.id_categoria
    ORDER BY p.nombre;
END $$

-- Buscar Producto
DROP PROCEDURE IF EXISTS buscar_producto $$
CREATE PROCEDURE buscar_producto(
    IN p_id INT
)
BEGIN
    SELECT *
    FROM productos
    WHERE id_producto = p_id;
END $$

-- Editar Producto
DROP PROCEDURE IF EXISTS editar_producto $$
CREATE PROCEDURE editar_producto(
    IN p_id INT,
    IN p_codigo VARCHAR(30),
    IN p_nombre VARCHAR(120),
    IN p_descripcion VARCHAR(255),
    IN p_id_categoria INT,
    IN p_iva DECIMAL(5,2),
    IN p_utilidad DECIMAL(7,2),
    IN p_garantia_empresa INT,
    IN p_garantia_proveedor INT,
    IN p_estado VARCHAR(10)
)
BEGIN
    UPDATE productos
    SET codigo = p_codigo,
        nombre = p_nombre,
        descripcion = p_descripcion,
        id_categoria = p_id_categoria,
        iva_porcentaje = p_iva,
        porcentaje_utilidad = p_utilidad,
        meses_garantia_empresa = p_garantia_empresa,
        meses_garantia_proveedor = p_garantia_proveedor,
        estado = p_estado
    WHERE id_producto = p_id;
END $$

-- Eliminar Producto (Cambiar estado a INACTIVO)
DROP PROCEDURE IF EXISTS eliminar_producto $$
CREATE PROCEDURE eliminar_producto(
    IN p_id INT
)
BEGIN
    UPDATE productos
    SET estado = 'INACTIVO'
    WHERE id_producto = p_id;
END $$


  -- 8) POLITICAS DE DESCUENTO

-- Crear Politica de Descuento
DROP PROCEDURE IF EXISTS crear_politica_descuento $$
CREATE PROCEDURE crear_politica_descuento(
    IN p_nombre VARCHAR(100),
    IN p_tipo VARCHAR(20),
    IN p_porcentaje DECIMAL(7,2),
    IN p_valor_fijo DECIMAL(14,2),
    IN p_monto_minimo DECIMAL(14,2),
    IN p_estado VARCHAR(10)
)
BEGIN
    INSERT INTO politicas_descuento(nombre, tipo, porcentaje, valor_fijo, monto_minimo_venta, estado)
    VALUES(p_nombre, p_tipo, p_porcentaje, p_valor_fijo, p_monto_minimo, p_estado);
END $$

-- Ver Politicas de Descuento
DROP PROCEDURE IF EXISTS listar_politicas_descuento $$
CREATE PROCEDURE listar_politicas_descuento()
BEGIN
    SELECT *
    FROM politicas_descuento
    ORDER BY nombre;
END $$

-- Buscar Politica de Descuento
DROP PROCEDURE IF EXISTS buscar_politica_descuento $$
CREATE PROCEDURE buscar_politica_descuento(
    IN p_id INT
)
BEGIN
    SELECT *
    FROM politicas_descuento
    WHERE id_politica_descuento = p_id;
END $$

-- Editar Politica de Descuento
DROP PROCEDURE IF EXISTS editar_politica_descuento $$
CREATE PROCEDURE editar_politica_descuento(
    IN p_id INT,
    IN p_nombre VARCHAR(100),
    IN p_tipo VARCHAR(20),
    IN p_porcentaje DECIMAL(7,2),
    IN p_valor_fijo DECIMAL(14,2),
    IN p_monto_minimo DECIMAL(14,2),
    IN p_estado VARCHAR(10)
)
BEGIN
    UPDATE politicas_descuento
    SET nombre = p_nombre,
        tipo = p_tipo,
        porcentaje = p_porcentaje,
        valor_fijo = p_valor_fijo,
        monto_minimo_venta = p_monto_minimo,
        estado = p_estado
    WHERE id_politica_descuento = p_id;
END $$

-- Eliminar Politica de Descuento (Cambiar estado a INACTIVO)
DROP PROCEDURE IF EXISTS eliminar_politica_descuento $$
CREATE PROCEDURE eliminar_politica_descuento(
    IN p_id INT
)
BEGIN
    UPDATE politicas_descuento
    SET estado = 'INACTIVO'
    WHERE id_politica_descuento = p_id;
END $$