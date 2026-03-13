DELIMITER $$

CREATE TRIGGER trg_ai_detalle_factura_compra_mov_inv
AFTER INSERT ON detalle_factura_compra
FOR EACH ROW
BEGIN
    DECLARE v_numero_factura VARCHAR(30);
    DECLARE v_fecha DATE;

    SELECT numero_factura, fecha
      INTO v_numero_factura, v_fecha
    FROM factura_compra
    WHERE id_factura_compra = NEW.id_factura_compra;

    INSERT INTO movimiento_inventario(
        id_producto, id_bodega, tipo_movimiento,
        referencia_documento, detalle_referencia, fecha_movimiento,
        cantidad, observacion
    )
    VALUES (
        NEW.id_producto,
        NEW.id_bodega,
        'COMPRA',
        v_numero_factura,
        CONCAT('ITEM ', NEW.item),
        CONCAT(v_fecha, ' 00:00:00'),
        NEW.cantidad,
        'Movimiento generado automaticamente por detalle de factura de compra'
    );
END $$

CREATE TRIGGER trg_bi_detalle_factura_venta_validar_stock
BEFORE INSERT ON detalle_factura_venta
FOR EACH ROW
BEGIN
    DECLARE v_stock_disponible INT;

    SELECT COALESCE(SUM(
        CASE
            WHEN tipo_movimiento IN ('COMPRA', 'DEVOLUCION_VENTA', 'AJUSTE_ENTRADA') THEN cantidad
            WHEN tipo_movimiento IN ('VENTA', 'DEVOLUCION_COMPRA', 'AJUSTE_SALIDA') THEN -cantidad
            ELSE 0
        END
    ), 0)
    INTO v_stock_disponible
    FROM movimiento_inventario
    WHERE id_producto = NEW.id_producto
      AND id_bodega = NEW.id_bodega;

    IF NEW.cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cantidad vendida debe ser mayor que cero';
    END IF;

    IF v_stock_disponible < NEW.cantidad THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock insuficiente para registrar la venta';
    END IF;
END $$

CREATE TRIGGER trg_ai_detalle_factura_venta_mov_inv
AFTER INSERT ON detalle_factura_venta
FOR EACH ROW
BEGIN
    DECLARE v_numero_factura VARCHAR(30);
    DECLARE v_fecha DATE;

    SELECT numero_factura, fecha
      INTO v_numero_factura, v_fecha
    FROM factura_venta
    WHERE id_factura_venta = NEW.id_factura_venta;

    INSERT INTO movimiento_inventario(
        id_producto, id_bodega, tipo_movimiento,
        referencia_documento, detalle_referencia, fecha_movimiento,
        cantidad, observacion
    )
    VALUES (
        NEW.id_producto,
        NEW.id_bodega,
        'VENTA',
        v_numero_factura,
        CONCAT('ITEM ', NEW.item),
        CONCAT(v_fecha, ' 00:00:00'),
        NEW.cantidad,
        'Movimiento generado automaticamente por detalle de factura de venta'
    );
END $$

CREATE TRIGGER trg_bi_detalle_devolucion_compra_validar_cantidad
BEFORE INSERT ON detalle_devolucion_compra
FOR EACH ROW
BEGIN
    DECLARE v_cantidad_comprada INT;
    DECLARE v_devuelto_acumulado INT;

    SELECT cantidad
      INTO v_cantidad_comprada
    FROM detalle_factura_compra
    WHERE id_detalle_factura_compra = NEW.id_detalle_factura_compra;

    SELECT COALESCE(SUM(cantidad), 0)
      INTO v_devuelto_acumulado
    FROM detalle_devolucion_compra
    WHERE id_detalle_factura_compra = NEW.id_detalle_factura_compra;

    IF NEW.cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cantidad a devolver en compra debe ser mayor que cero';
    END IF;

    IF (v_devuelto_acumulado + NEW.cantidad) > v_cantidad_comprada THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La devolucion de compra excede la cantidad comprada';
    END IF;
END $$

CREATE TRIGGER trg_ai_detalle_devolucion_compra_mov_inv
AFTER INSERT ON detalle_devolucion_compra
FOR EACH ROW
BEGIN
    DECLARE v_numero_devolucion VARCHAR(30);
    DECLARE v_fecha DATE;
    DECLARE v_id_producto INT;
    DECLARE v_id_bodega INT;

    SELECT dc.numero_devolucion, dc.fecha, dfc.id_producto, dfc.id_bodega
      INTO v_numero_devolucion, v_fecha, v_id_producto, v_id_bodega
    FROM devolucion_compra dc
    INNER JOIN detalle_factura_compra dfc
        ON dfc.id_detalle_factura_compra = NEW.id_detalle_factura_compra
    WHERE dc.id_devolucion_compra = NEW.id_devolucion_compra;

    INSERT INTO movimiento_inventario(
        id_producto, id_bodega, tipo_movimiento,
        referencia_documento, detalle_referencia, fecha_movimiento,
        cantidad, observacion
    )
    VALUES (
        v_id_producto,
        v_id_bodega,
        'DEVOLUCION_COMPRA',
        v_numero_devolucion,
        CONCAT('ITEM ', NEW.item),
        CONCAT(v_fecha, ' 00:00:00'),
        NEW.cantidad,
        'Movimiento generado automaticamente por devolucion de compra'
    );
END $$

CREATE TRIGGER trg_bi_detalle_devolucion_venta_validar_cantidad
BEFORE INSERT ON detalle_devolucion_venta
FOR EACH ROW
BEGIN
    DECLARE v_cantidad_vendida INT;
    DECLARE v_devuelto_acumulado INT;

    SELECT cantidad
      INTO v_cantidad_vendida
    FROM detalle_factura_venta
    WHERE id_detalle_factura_venta = NEW.id_detalle_factura_venta;

    SELECT COALESCE(SUM(cantidad), 0)
      INTO v_devuelto_acumulado
    FROM detalle_devolucion_venta
    WHERE id_detalle_factura_venta = NEW.id_detalle_factura_venta;

    IF NEW.cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cantidad a devolver en venta debe ser mayor que cero';
    END IF;

    IF (v_devuelto_acumulado + NEW.cantidad) > v_cantidad_vendida THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La devolucion de venta excede la cantidad vendida';
    END IF;
END $$

CREATE TRIGGER trg_ai_detalle_devolucion_venta_mov_inv
AFTER INSERT ON detalle_devolucion_venta
FOR EACH ROW
BEGIN
    DECLARE v_numero_devolucion VARCHAR(30);
    DECLARE v_fecha DATE;
    DECLARE v_id_producto INT;
    DECLARE v_id_bodega INT;

    SELECT dv.numero_devolucion, dv.fecha, dfv.id_producto, dfv.id_bodega
      INTO v_numero_devolucion, v_fecha, v_id_producto, v_id_bodega
    FROM devolucion_venta dv
    INNER JOIN detalle_factura_venta dfv
        ON dfv.id_detalle_factura_venta = NEW.id_detalle_factura_venta
    WHERE dv.id_devolucion_venta = NEW.id_devolucion_venta;

    INSERT INTO movimiento_inventario(
        id_producto, id_bodega, tipo_movimiento,
        referencia_documento, detalle_referencia, fecha_movimiento,
        cantidad, observacion
    )
    VALUES (
        v_id_producto,
        v_id_bodega,
        'DEVOLUCION_VENTA',
        v_numero_devolucion,
        CONCAT('ITEM ', NEW.item),
        CONCAT(v_fecha, ' 00:00:00'),
        NEW.cantidad,
        'Movimiento generado automaticamente por devolucion de venta'
    );
END $$

DELIMITER ;


--  VALIDAR PERSONA NATURAL

-- Este trigger se asegura de que al insertar una persona natural, el tercero asociado exista y sea del tipo NATURAL.
DROP TRIGGER IF EXISTS tr_validar_persona_natural_bi $$
CREATE TRIGGER tr_validar_persona_natural_bi
BEFORE INSERT ON personas_naturales
FOR EACH ROW
BEGIN
    DECLARE v_tipo VARCHAR(20);

    SELECT tipo_tercero
    INTO v_tipo
    FROM terceros
    WHERE id_tercero = NEW.id_tercero;

    IF v_tipo IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El tercero no existe en la tabla terceros';
    END IF;

    IF v_tipo <> 'NATURAL' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El tercero debe ser de tipo NATURAL';
    END IF;
END $$