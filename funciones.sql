USE mini_erp_acme;

DELIMITER //

-- Calcular Subtotal Detalle Compra
CREATE FUNCTION fn_subtotal_detalle_compra(p_cantidad INT, p_valor_unitario DECIMAL(14,2))
RETURNS DECIMAL(14,2)
DETERMINISTIC
BEGIN
    RETURN p_cantidad * p_valor_unitario;
END //

-- Calcular IVA Detalle Compra
CREATE FUNCTION fn_iva_detalle_compra(p_cantidad INT, p_valor_unitario DECIMAL(14,2), p_iva_porcentaje DECIMAL(5,2))
RETURNS DECIMAL(14,2)
DETERMINISTIC
BEGIN
    RETURN (p_cantidad * p_valor_unitario) * (p_iva_porcentaje / 100);
END //

-- Calcular Total Detalle Compra
CREATE FUNCTION fn_total_detalle_compra(p_cantidad INT, p_valor_unitario DECIMAL(14,2), p_iva_porcentaje DECIMAL(5,2))
RETURNS DECIMAL(14,2)
DETERMINISTIC
BEGIN
    RETURN fn_subtotal_detalle_compra(p_cantidad, p_valor_unitario) + fn_iva_detalle_compra(p_cantidad, p_valor_unitario, p_iva_porcentaje);
END //

-- Calcular Valor Devolucion Compra
CREATE FUNCTION fn_valor_devolucion_compra(p_id_detalle_devolucion_compra INT)
RETURNS DECIMAL(14,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(14,2);
    
    SELECT fn_total_detalle_compra(ddc.cantidad, dfc.valor_unitario, dfc.iva_porcentaje) INTO v_total
    FROM detalle_devolucion_compra ddc
    JOIN detalle_factura_compra dfc ON ddc.id_detalle_factura_compra = dfc.id_detalle_factura_compra
    WHERE ddc.id_detalle_devolucion_compra = p_id_detalle_devolucion_compra;
    
    RETURN v_total;
END //

-- Calcular Total Factura Compra
CREATE FUNCTION fn_total_factura_compra(p_id_factura_compra INT)
RETURNS DECIMAL(14,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(14,2);
    
    SELECT IFNULL(SUM(fn_total_detalle_compra(cantidad, valor_unitario, iva_porcentaje)), 0) INTO v_total
    FROM detalle_factura_compra
    WHERE id_factura_compra = p_id_factura_compra;
    
    RETURN v_total;
END //

-- Calcular Stock Producto en Bodega
CREATE FUNCTION fn_calcular_stock(p_id_producto INT, p_id_bodega INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_stock INT;
    
    SELECT IFNULL(
        SUM(CASE 
            WHEN tipo_movimiento IN ('COMPRA', 'DEVOLUCION_VENTA', 'AJUSTE_ENTRADA') THEN cantidad
            WHEN tipo_movimiento IN ('VENTA', 'DEVOLUCION_COMPRA', 'AJUSTE_SALIDA') THEN -cantidad
            ELSE 0
        END), 0) INTO v_stock
    FROM movimiento_inventario
    WHERE id_producto = p_id_producto AND id_bodega = p_id_bodega;
    
    RETURN v_stock;
END //

-- Calcular Precio de Venta Sugerido
CREATE FUNCTION fn_precio_venta_sugerido(p_id_producto INT)
RETURNS DECIMAL(14,2)
READS SQL DATA
BEGIN
    DECLARE v_precio_base DECIMAL(14,2);
    DECLARE v_porcentaje_utilidad DECIMAL(7,2);
    DECLARE v_iva_porcentaje DECIMAL(5,2);
    DECLARE v_precio_sugerido DECIMAL(14,2);
    
    SELECT MIN(precio_base) INTO v_precio_base
    FROM proveedor_producto
    WHERE id_producto = p_id_producto;
    
    IF v_precio_base IS NULL THEN
        RETURN 0;
    END IF;
    
    SELECT porcentaje_utilidad, iva_porcentaje INTO v_porcentaje_utilidad, v_iva_porcentaje
    FROM productos
    WHERE id_producto = p_id_producto;
    
    SET v_precio_sugerido = v_precio_base * (1 + (v_porcentaje_utilidad / 100));
    SET v_precio_sugerido = v_precio_sugerido * (1 + (v_iva_porcentaje / 100));
    
    RETURN v_precio_sugerido;
END //

-- Calcular Descuento Factura Venta
CREATE FUNCTION fn_calcular_descuento_venta(p_id_factura_venta INT)
RETURNS DECIMAL(14,2)
READS SQL DATA
BEGIN
    DECLARE v_subtotal DECIMAL(14,2);
    DECLARE v_tipo_descuento VARCHAR(20);
    DECLARE v_porcentaje DECIMAL(7,2);
    DECLARE v_valor_fijo DECIMAL(14,2);
    DECLARE v_monto_minimo DECIMAL(14,2);
    DECLARE v_descuento DECIMAL(14,2) DEFAULT 0;
    
    SELECT IFNULL(SUM(fn_subtotal_detalle_compra(cantidad, valor_unitario)), 0) INTO v_subtotal
    FROM detalle_factura_venta
    WHERE id_factura_venta = p_id_factura_venta;
    
    SELECT pd.tipo, pd.porcentaje, pd.valor_fijo, pd.monto_minimo_venta 
    INTO v_tipo_descuento, v_porcentaje, v_valor_fijo, v_monto_minimo
    FROM factura_venta fv
    JOIN politicas_descuento pd ON fv.id_politica_descuento = pd.id_politica_descuento
    WHERE fv.id_factura_venta = p_id_factura_venta;
    
    IF v_tipo_descuento IS NOT NULL AND v_subtotal >= v_monto_minimo THEN
        IF v_tipo_descuento = 'PORCENTAJE' THEN
            SET v_descuento = v_subtotal * (v_porcentaje / 100);
        ELSEIF v_tipo_descuento = 'VALOR_FIJO' THEN
            SET v_descuento = v_valor_fijo;
        END IF;
    END IF;
    
    RETURN v_descuento;
END //

-- Calcular Total Factura Venta
CREATE FUNCTION fn_total_factura_venta(p_id_factura_venta INT)
RETURNS DECIMAL(14,2)
READS SQL DATA
BEGIN
    DECLARE v_total_sin_descuento DECIMAL(14,2);
    DECLARE v_descuento DECIMAL(14,2);
    
    SELECT IFNULL(SUM(fn_total_detalle_compra(cantidad, valor_unitario, iva_porcentaje)), 0) INTO v_total_sin_descuento
    FROM detalle_factura_venta
    WHERE id_factura_venta = p_id_factura_venta;
    
    SET v_descuento = fn_calcular_descuento_venta(p_id_factura_venta);
    
    RETURN v_total_sin_descuento - v_descuento;
END //

-- Calcular Valor Devolucion Venta
CREATE FUNCTION fn_valor_devolucion_venta(p_id_detalle_devolucion_venta INT)
RETURNS DECIMAL(14,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(14,2);
    
    SELECT fn_total_detalle_compra(ddv.cantidad, dfv.valor_unitario, dfv.iva_porcentaje) INTO v_total
    FROM detalle_devolucion_venta ddv
    JOIN detalle_factura_venta dfv ON ddv.id_detalle_factura_venta = dfv.id_detalle_factura_venta
    WHERE ddv.id_detalle_devolucion_venta = p_id_detalle_devolucion_venta;
    
    RETURN v_total;
END //

DELIMITER ;
