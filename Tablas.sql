DROP DATABASE IF EXISTS mini_erp_acme;
CREATE DATABASE mini_erp_acme
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE mini_erp_acme;

CREATE TABLE tipos_identificacion (
    id_tipo_identificacion INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(10) NOT NULL UNIQUE,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(150)
) ENGINE=InnoDB;

CREATE TABLE ciudades (
    id_ciudad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    departamento VARCHAR(80) NOT NULL,
    UNIQUE(nombre, departamento)
) ENGINE=InnoDB;

CREATE TABLE sedes (
    id_sede INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(10) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(150),
    id_ciudad INT NOT NULL,
    telefono VARCHAR(20),
    estado ENUM('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
    FOREIGN KEY (id_ciudad) REFERENCES ciudades(id_ciudad)
) ENGINE=InnoDB;

CREATE TABLE bodegas (
    id_bodega INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(10) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(150),
    id_sede INT NOT NULL,
    estado ENUM('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
    FOREIGN KEY (id_sede) REFERENCES sedes(id_sede)
) ENGINE=InnoDB;

CREATE TABLE medios_pago (
    id_medio_pago INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(150),
    estado ENUM('ACTIVO','INACTIVO') DEFAULT 'ACTIVO'
) ENGINE=InnoDB;

CREATE TABLE terceros (
    id_tercero INT AUTO_INCREMENT PRIMARY KEY,
    tipo_tercero ENUM('NATURAL','JURIDICO') NOT NULL,
    direccion VARCHAR(150),
    id_ciudad INT NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(120),
    estado ENUM('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
    FOREIGN KEY (id_ciudad) REFERENCES ciudades(id_ciudad)
) ENGINE=InnoDB;

CREATE TABLE personas_naturales (
    id_tercero INT PRIMARY KEY,
    id_tipo_identificacion INT NOT NULL,
    numero_identificacion VARCHAR(30) NOT NULL UNIQUE,
    nombres VARCHAR(80) NOT NULL,
    apellidos VARCHAR(80) NOT NULL,
    genero ENUM('MASCULINO','FEMENINO','OTRO','NO_ESPECIFICA'),
    FOREIGN KEY (id_tercero) REFERENCES terceros(id_tercero),
    FOREIGN KEY (id_tipo_identificacion) REFERENCES tipos_identificacion(id_tipo_identificacion)
) ENGINE=InnoDB;

CREATE TABLE personas_juridicas (
    id_tercero INT PRIMARY KEY,
    id_tipo_identificacion INT NOT NULL,
    numero_identificacion VARCHAR(30) NOT NULL UNIQUE,
    razon_social VARCHAR(120) NOT NULL UNIQUE,
    FOREIGN KEY (id_tercero) REFERENCES terceros(id_tercero),
    FOREIGN KEY (id_tipo_identificacion) REFERENCES tipos_identificacion(id_tipo_identificacion)
) ENGINE=InnoDB;

CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    id_tercero INT NOT NULL UNIQUE,
    FOREIGN KEY (id_tercero) REFERENCES terceros(id_tercero)
) ENGINE=InnoDB;

CREATE TABLE proveedores (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    id_tercero INT NOT NULL UNIQUE,
    FOREIGN KEY (id_tercero) REFERENCES terceros(id_tercero)
) ENGINE=InnoDB;

CREATE TABLE asesores (
    id_asesor INT AUTO_INCREMENT PRIMARY KEY,
    id_tercero INT NOT NULL UNIQUE,
    FOREIGN KEY (id_tercero) REFERENCES personas_naturales(id_tercero)
) ENGINE=InnoDB;

CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(80) NOT NULL UNIQUE,
    descripcion VARCHAR(150),
    estado ENUM('ACTIVO','INACTIVO') DEFAULT 'ACTIVO'
) ENGINE=InnoDB;

CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(30) NOT NULL UNIQUE,
    nombre VARCHAR(120) NOT NULL,
    descripcion VARCHAR(255),
    id_categoria INT NOT NULL,
    iva_porcentaje DECIMAL(5,2) NOT NULL,
    porcentaje_utilidad DECIMAL(7,2) DEFAULT 0.00,
    meses_garantia_empresa INT DEFAULT 3,
    meses_garantia_proveedor INT DEFAULT 12,
    estado ENUM('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
) ENGINE=InnoDB;

CREATE TABLE proveedor_producto (
    id_proveedor INT NOT NULL,
    id_producto INT NOT NULL,
    referencia_proveedor VARCHAR(50),
    precio_base DECIMAL(14,2),
    PRIMARY KEY(id_proveedor,id_producto),
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
) ENGINE=InnoDB;

CREATE TABLE movimiento_inventario (
    id_movimiento INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL,
    id_bodega INT NOT NULL,
    tipo_movimiento ENUM(
        'COMPRA',
        'VENTA',
        'DEVOLUCION_COMPRA',
        'DEVOLUCION_VENTA',
        'AJUSTE_ENTRADA',
        'AJUSTE_SALIDA'
    ) NOT NULL,
    referencia_documento VARCHAR(30) NOT NULL,
    detalle_referencia VARCHAR(50),
    fecha_movimiento DATETIME NOT NULL,
    cantidad INT NOT NULL,
    observacion VARCHAR(255),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    FOREIGN KEY (id_bodega) REFERENCES bodegas(id_bodega)
) ENGINE=InnoDB;

CREATE TABLE factura_compra (
    id_factura_compra INT AUTO_INCREMENT PRIMARY KEY,
    numero_factura VARCHAR(30) NOT NULL UNIQUE,
    fecha DATE NOT NULL,
    id_proveedor INT NOT NULL,
    id_medio_pago INT NOT NULL,
    observaciones VARCHAR(255),
    estado ENUM('BORRADOR','CONFIRMADA','ANULADA') DEFAULT 'CONFIRMADA',
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor),
    FOREIGN KEY (id_medio_pago) REFERENCES medios_pago(id_medio_pago)
) ENGINE=InnoDB;

CREATE TABLE detalle_factura_compra (
    id_detalle_factura_compra INT AUTO_INCREMENT PRIMARY KEY,
    id_factura_compra INT NOT NULL,
    item INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    valor_unitario DECIMAL(14,2) NOT NULL,
    iva_porcentaje DECIMAL(5,2) NOT NULL,
    id_bodega INT NOT NULL,
    UNIQUE(id_factura_compra,item),
    FOREIGN KEY (id_factura_compra) REFERENCES factura_compra(id_factura_compra),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    FOREIGN KEY (id_bodega) REFERENCES bodegas(id_bodega)
) ENGINE=InnoDB;

CREATE TABLE devolucion_compra (
    id_devolucion_compra INT AUTO_INCREMENT PRIMARY KEY,
    numero_devolucion VARCHAR(30) NOT NULL UNIQUE,
    fecha DATE NOT NULL,
    id_factura_compra INT NOT NULL,
    motivo VARCHAR(255) NOT NULL,
    estado ENUM('BORRADOR','CONFIRMADA','ANULADA') DEFAULT 'CONFIRMADA',
    FOREIGN KEY (id_factura_compra) REFERENCES factura_compra(id_factura_compra)
) ENGINE=InnoDB;

CREATE TABLE detalle_devolucion_compra (
    id_detalle_devolucion_compra INT AUTO_INCREMENT PRIMARY KEY,
    id_devolucion_compra INT NOT NULL,
    item INT NOT NULL,
    id_detalle_factura_compra INT NOT NULL,
    cantidad INT NOT NULL,
    UNIQUE(id_devolucion_compra,item),
    FOREIGN KEY (id_devolucion_compra) REFERENCES devolucion_compra(id_devolucion_compra),
    FOREIGN KEY (id_detalle_factura_compra) REFERENCES detalle_factura_compra(id_detalle_factura_compra)
) ENGINE=InnoDB;

CREATE TABLE politicas_descuento (
    id_politica_descuento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    tipo ENUM('PORCENTAJE','VALOR_FIJO','MANUAL') NOT NULL,
    porcentaje DECIMAL(7,2),
    valor_fijo DECIMAL(14,2),
    monto_minimo_venta DECIMAL(14,2),
    estado ENUM('ACTIVO','INACTIVO') DEFAULT 'ACTIVO'
) ENGINE=InnoDB;

CREATE TABLE factura_venta (
    id_factura_venta INT AUTO_INCREMENT PRIMARY KEY,
    numero_factura VARCHAR(30) NOT NULL UNIQUE,
    fecha DATE NOT NULL,
    id_cliente INT NOT NULL,
    id_asesor INT NOT NULL,
    id_medio_pago INT NOT NULL,
    id_politica_descuento INT,
    observaciones VARCHAR(255),
    estado ENUM('BORRADOR','CONFIRMADA','ANULADA') DEFAULT 'CONFIRMADA',
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_asesor) REFERENCES asesores(id_asesor),
    FOREIGN KEY (id_medio_pago) REFERENCES medios_pago(id_medio_pago),
    FOREIGN KEY (id_politica_descuento) REFERENCES politicas_descuento(id_politica_descuento)
) ENGINE=InnoDB;

CREATE TABLE detalle_factura_venta (
    id_detalle_factura_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_factura_venta INT NOT NULL,
    item INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    valor_unitario DECIMAL(14,2) NOT NULL,
    iva_porcentaje DECIMAL(5,2) NOT NULL,
    id_bodega INT NOT NULL,
    UNIQUE(id_factura_venta,item),
    FOREIGN KEY (id_factura_venta) REFERENCES factura_venta(id_factura_venta),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    FOREIGN KEY (id_bodega) REFERENCES bodegas(id_bodega)
) ENGINE=InnoDB;

CREATE TABLE devolucion_venta (
    id_devolucion_venta INT AUTO_INCREMENT PRIMARY KEY,
    numero_devolucion VARCHAR(30) NOT NULL UNIQUE,
    fecha DATE NOT NULL,
    id_factura_venta INT NOT NULL,
    motivo VARCHAR(255) NOT NULL,
    estado ENUM('BORRADOR','CONFIRMADA','ANULADA') DEFAULT 'CONFIRMADA',
    FOREIGN KEY (id_factura_venta) REFERENCES factura_venta(id_factura_venta)
) ENGINE=InnoDB;

CREATE TABLE detalle_devolucion_venta (
    id_detalle_devolucion_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_devolucion_venta INT NOT NULL,
    item INT NOT NULL,
    id_detalle_factura_venta INT NOT NULL,
    cantidad INT NOT NULL,
    UNIQUE(id_devolucion_venta,item),
    FOREIGN KEY (id_devolucion_venta) REFERENCES devolucion_venta(id_devolucion_venta),
    FOREIGN KEY (id_detalle_factura_venta) REFERENCES detalle_factura_venta(id_detalle_factura_venta)
) ENGINE=InnoDB;
