USE mini_erp_acme;

-- 1. tipos_identificacion
INSERT INTO tipos_identificacion (codigo, nombre, descripcion) VALUES
('CC', 'Cédula de Ciudadanía', 'Documento para colombianos mayores de 18 años'),
('NIT', 'Número de Identificación Tributaria', 'Documento para empresas e independientes');

-- 2. ciudades
INSERT INTO ciudades (nombre, departamento) VALUES
('Bogotá', 'Cundinamarca'),
('Medellín', 'Antioquia');

-- 3. sedes
INSERT INTO sedes (codigo, nombre, direccion, id_ciudad, telefono) VALUES
('S01', 'Sede Principal Norte', 'Calle 100 # 15-20', 1, '6015555555');

-- 4. bodegas
INSERT INTO bodegas (codigo, nombre, descripcion, id_sede) VALUES
('B01', 'Bodega Central', 'Bodega principal de almacenamiento', 1);

-- 5. medios_pago
INSERT INTO medios_pago (codigo, nombre, descripcion) VALUES
('EFE', 'Efectivo', 'Pago en moneda fisica'),
('TC', 'Tarjeta de Crédito', 'Pago mediante tarjeta de credito');

-- 6. terceros
INSERT INTO terceros (tipo_tercero, direccion, id_ciudad, telefono, email) VALUES
('JURIDICO', 'Carrera 50 # 30-40', 2, '6043333333', 'contacto@tecnoproveedor.com'),
('NATURAL', 'Calle 10 # 5-12', 1, '3001234567', 'juan.perez@email.com'),
('NATURAL', 'Avenida 15 # 100-20', 1, '3109876543', 'asesor.maria@acme.com');

-- 7. personas_naturales
INSERT INTO personas_naturales (id_tercero, id_tipo_identificacion, numero_identificacion, nombres, apellidos, genero) VALUES
(2, 1, '1020304050', 'Juan', 'Pérez', 'MASCULINO'),
(3, 1, '5040302010', 'Maria', 'Gomez', 'FEMENINO');

-- 8. personas_juridicas
INSERT INTO personas_juridicas (id_tercero, id_tipo_identificacion, numero_identificacion, razon_social) VALUES
(1, 2, '900123456-1', 'Tecnología Proveedor SAS');

-- 9. clientes
INSERT INTO clientes (id_tercero) VALUES (2);

-- 10. proveedores
INSERT INTO proveedores (id_tercero) VALUES (1);

-- 11. asesores
INSERT INTO asesores (id_tercero) VALUES (3);

-- 12. categorias
INSERT INTO categorias (codigo, nombre, descripcion) VALUES
('COMP', 'Computadores', 'Computadores de escritorio y portatiles'),
('PERI', 'Perifericos', 'Teclados, mouses, monitores');

-- 13. productos
INSERT INTO productos (codigo, nombre, descripcion, id_categoria, iva_porcentaje, porcentaje_utilidad, meses_garantia_empresa, meses_garantia_proveedor) VALUES
('P001', 'Portátil Gamer XTREME', 'Portatil core i7, 16GB RAM, 1TB SSD', 1, 19.00, 30.00, 6, 12),
('P002', 'Mouse Inalámbrico PRO', 'Mouse ergonomico 1600 DPI', 2, 19.00, 50.00, 3, 6);

-- 14. proveedor_producto
INSERT INTO proveedor_producto (id_proveedor, id_producto, referencia_proveedor, precio_base) VALUES
(1, 1, 'REF-LT-01', 2000000.00),
(1, 2, 'REF-MS-05', 50000.00);

-- 15. factura_compra
INSERT INTO factura_compra (numero_factura, fecha, id_proveedor, id_medio_pago, estado) VALUES
('FC-001', '2024-01-10', 1, 1, 'CONFIRMADA');

-- 16. detalle_factura_compra
INSERT INTO detalle_factura_compra (id_factura_compra, item, id_producto, cantidad, valor_unitario, iva_porcentaje, id_bodega) VALUES
(1, 1, 1, 10, 2000000.00, 19.00, 1),
(1, 2, 2, 50, 50000.00, 19.00, 1);

-- 17. movimiento_inventario (Compras)
INSERT INTO movimiento_inventario (id_producto, id_bodega, tipo_movimiento, referencia_documento, fecha_movimiento, cantidad) VALUES
(1, 1, 'COMPRA', 'FC-001', '2024-01-10 10:00:00', 10),
(2, 1, 'COMPRA', 'FC-001', '2024-01-10 10:00:00', 50);

-- 18. devolucion_compra
INSERT INTO devolucion_compra (numero_devolucion, fecha, id_factura_compra, motivo, estado) VALUES
('DC-001', '2024-01-15', 1, 'Un portátil llegó con pantalla rota', 'CONFIRMADA');

-- 19. detalle_devolucion_compra
INSERT INTO detalle_devolucion_compra (id_devolucion_compra, item, id_detalle_factura_compra, cantidad) VALUES
(1, 1, 1, 1);

-- 20. movimiento_inventario (Devolución compra)
INSERT INTO movimiento_inventario (id_producto, id_bodega, tipo_movimiento, referencia_documento, fecha_movimiento, cantidad) VALUES
(1, 1, 'DEVOLUCION_COMPRA', 'DC-001', '2024-01-15 11:00:00', 1);

-- 21. politicas_descuento
INSERT INTO politicas_descuento (nombre, tipo, porcentaje, monto_minimo_venta) VALUES
('Descuento Febrero 10%', 'PORCENTAJE', 10.00, 1000000.00);

-- 22. factura_venta
INSERT INTO factura_venta (numero_factura, fecha, id_cliente, id_asesor, id_medio_pago, id_politica_descuento, estado) VALUES
('FV-001', '2024-02-05', 1, 1, 2, 1, 'CONFIRMADA');

-- 23. detalle_factura_venta (Precios basados en la funcion: Portatil ~3,094,000 | Mouse ~89,250)
INSERT INTO detalle_factura_venta (id_factura_venta, item, id_producto, cantidad, valor_unitario, iva_porcentaje, id_bodega) VALUES
(1, 1, 1, 2, 2600000.00, 19.00, 1),
(1, 2, 2, 3, 75000.00, 19.00, 1);

-- 24. movimiento_inventario (Ventas)
INSERT INTO movimiento_inventario (id_producto, id_bodega, tipo_movimiento, referencia_documento, fecha_movimiento, cantidad) VALUES
(1, 1, 'VENTA', 'FV-001', '2024-02-05 14:00:00', 2),
(2, 1, 'VENTA', 'FV-001', '2024-02-05 14:00:00', 3);

-- 25. devolucion_venta
INSERT INTO devolucion_venta (numero_devolucion, fecha, id_factura_venta, motivo, estado) VALUES
('DV-001', '2024-02-06', 1, 'Cliente se arrepintió de 1 mouse', 'CONFIRMADA');

-- 26. detalle_devolucion_venta
INSERT INTO detalle_devolucion_venta (id_devolucion_venta, item, id_detalle_factura_venta, cantidad) VALUES
(1, 1, 2, 1);

-- 27. movimiento_inventario (Devolución venta)
INSERT INTO movimiento_inventario (id_producto, id_bodega, tipo_movimiento, referencia_documento, fecha_movimiento, cantidad) VALUES
(2, 1, 'DEVOLUCION_VENTA', 'DV-001', '2024-02-06 09:00:00', 1);


-- CONSULTAS DE PRUEBA
SELECT '--- RESULTADOS DE FUNCIONES ---' AS Info;

SELECT fn_precio_venta_sugerido(1) AS 'Precio Sugerido Portatiles (Esperado: 3094000.00)';
SELECT fn_precio_venta_sugerido(2) AS 'Precio Sugerido Mouse (Esperado: 89250.00)';

SELECT fn_calcular_stock(1, 1) AS 'Stock Portatil (Compra 10 - Dev_Comp 1 - Venta 2 = 7)';
SELECT fn_calcular_stock(2, 1) AS 'Stock Mouse (Compra 50 - Venta 3 + Dev_Vent 1 = 48)';

SELECT fn_total_factura_compra(1) AS 'Total Fac. Compra 1 ((10*2M)*1.19 + (50*50k)*1.19 = 26775000.00)';
SELECT fn_valor_devolucion_compra(1) AS 'Valor Dev. Compra (1 Portatil = 2M * 1.19 = 2380000.00)';

SELECT fn_calcular_descuento_venta(1) AS 'Descuento Venta (10% de subtotal 5425000 = 542500.00)';
SELECT fn_total_factura_venta(1) AS 'Total Fac. Venta (Total_con_iva 6455750 - Desc 542500 = 5913250.00)';

SELECT fn_valor_devolucion_venta(1) AS 'Valor Dev. Venta (1 Mouse = 75000 * 1.19 = 89250.00)';
