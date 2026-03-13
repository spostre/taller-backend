-- SEGURIDAD DEL SISTEMA
CREATE ROLE administrador;
CREATE ROLE asesor_comercial;
CREATE ROLE coordinador_ventas;
CREATE ROLE auxiliar_ventas;
CREATE ROLE coordinador_inventario;
CREATE ROLE auxiliar_inventario;
CREATE ROLE coordinador_compras;
CREATE ROLE auxiliar_compras;

-- PERMISOS ADMINISTRADOR
GRANT ALL PRIVILEGES ON mini_erp_acme.* TO administrador;

-- PERMISOS ASESOR COMERCIAL (FACTURACION)
GRANT SELECT ON mini_erp_acme.productos TO asesor_comercial;
GRANT SELECT ON mini_erp_acme.clientes TO asesor_comercial;
GRANT SELECT, INSERT ON mini_erp_acme.factura_venta TO asesor_comercial;
GRANT SELECT, INSERT ON mini_erp_acme.detalle_factura_venta TO asesor_comercial;

-- PERMISOS COORDINADOR DE VENTAS
GRANT SELECT, INSERT, UPDATE ON mini_erp_acme.clientes TO coordinador_ventas;
GRANT SELECT ON mini_erp_acme.factura_venta TO coordinador_ventas;
GRANT SELECT ON mini_erp_acme.detalle_factura_venta TO coordinador_ventas;
GRANT SELECT, INSERT, UPDATE ON mini_erp_acme.devoluciones_venta TO coordinador_ventas;

-- PERMISOS AUXILIAR DE VENTAS
GRANT SELECT, INSERT ON mini_erp_acme.clientes TO auxiliar_ventas;
GRANT SELECT, INSERT ON mini_erp_acme.factura_venta TO auxiliar_ventas;
GRANT SELECT, INSERT ON mini_erp_acme.detalle_factura_venta TO auxiliar_ventas;
GRANT INSERT ON mini_erp_acme.devoluciones_venta TO auxiliar_ventas;


-- PERMISOS COORDINADOR INVENTARIO
GRANT SELECT, INSERT, UPDATE ON mini_erp_acme.movimiento_inventario TO coordinador_inventario;
GRANT SELECT ON mini_erp_acme.productos TO coordinador_inventario;
GRANT SELECT ON mini_erp_acme.categorias TO coordinador_inventario;

-- PERMISOS AUXILIAR INVENTARIO
-- (productos y categorias)
GRANT SELECT, INSERT, UPDATE ON mini_erp_acme.productos TO auxiliar_inventario;
GRANT SELECT, INSERT, UPDATE ON mini_erp_acme.categorias TO auxiliar_inventario;


-- PERMISOS COORDINADOR COMPRAS
GRANT SELECT ON mini_erp_acme.proveedores TO coordinador_compras;
GRANT SELECT ON mini_erp_acme.factura_compra TO coordinador_compras;
GRANT SELECT ON mini_erp_acme.detalle_factura_compra TO coordinador_compras;
GRANT SELECT, INSERT, UPDATE ON mini_erp_acme.devoluciones_compra TO coordinador_compras;

-- PERMISOS AUXILIAR COMPRAS
-- (registra facturas compra y devoluciones)
GRANT SELECT, INSERT ON mini_erp_acme.factura_compra TO auxiliar_compras;
GRANT SELECT, INSERT ON mini_erp_acme.detalle_factura_compra TO auxiliar_compras;
GRANT INSERT ON mini_erp_acme.devoluciones_compra TO auxiliar_compras;

-- CREACION DE USUARIOS
CREATE USER admin_erp IDENTIFIED BY 'Admin123!';
CREATE USER asesor1 IDENTIFIED BY 'Venta123!';
CREATE USER coord_ventas IDENTIFIED BY 'Ventas123!';
CREATE USER aux_ventas IDENTIFIED BY 'VentasAux123!';
CREATE USER coord_inventario IDENTIFIED BY 'Inv123!';
CREATE USER aux_inventario IDENTIFIED BY 'InvAux123!';
CREATE USER coord_compras IDENTIFIED BY 'Compras123!';
CREATE USER aux_compras IDENTIFIED BY 'ComprasAux123!';


-- ASIGNACION DE ROLES
GRANT administrador TO admin_erp;
GRANT asesor_comercial TO asesor1;
GRANT coordinador_ventas TO coord_ventas;
GRANT auxiliar_ventas TO aux_ventas;
GRANT coordinador_inventario TO coord_inventario;
GRANT auxiliar_inventario TO aux_inventario;
GRANT coordinador_compras TO coord_compras;
GRANT auxiliar_compras TO aux_compras;

-- ACTIVAR ROLES POR DEFECTO
SET DEFAULT ROLE ALL TO
admin_erp,
asesor1,
coord_ventas,
aux_ventas,
coord_inventario,
aux_inventario,
coord_compras,
aux_compras;