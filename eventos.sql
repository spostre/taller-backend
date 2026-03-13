DELIMITER $$

CREATE EVENT ev_generar_reporte_mensual_ventas_asesor
ON SCHEDULE EVERY 1 MONTH
STARTS '2026-04-01 00:00:00'
DO
BEGIN
    CALL sp_generar_reporte_mensual_ventas_asesor(
        YEAR(CURRENT_DATE - INTERVAL 1 MONTH),
        MONTH(CURRENT_DATE - INTERVAL 1 MONTH)
    );
END $$

DELIMITER ;

-- =========================================================
-- 15. VISTAS
-- =========================================================

CREATE OR REPLACE VIEW vw_inventario_disponible AS
SELECT
    b.id_bodega,
    b.codigo AS codigo_bodega,
    b.nombre AS bodega,
    p.id_producto,
    p.codigo AS codigo_producto,
    p.nombre AS producto,
    COALESCE(SUM(
        CASE
            WHEN mi.tipo_movimiento IN ('COMPRA', 'DEVOLUCION_VENTA', 'AJUSTE_ENTRADA') THEN mi.cantidad
            WHEN mi.tipo_movimiento IN ('VENTA', 'DEVOLUCION_COMPRA', 'AJUSTE_SALIDA') THEN -mi.cantidad
            ELSE 0
        END
    ), 0) AS stock_disponible
FROM productos p
CROSS JOIN bodegas b
LEFT JOIN movimiento_inventario mi
    ON mi.id_producto = p.id_producto
   AND mi.id_bodega = b.id_bodega
GROUP BY
    b.id_bodega, b.codigo, b.nombre,
    p.id_producto, p.codigo, p.nombre;

CREATE OR REPLACE VIEW vw_ventas_por_asesor AS
SELECT
    YEAR(fv.fecha) AS anio,
    MONTH(fv.fecha) AS mes,
    a.id_asesor,
    CONCAT(pn.nombres, ' ', pn.apellidos) AS asesor,
    COUNT(DISTINCT fv.id_factura_venta) AS cantidad_facturas,
    SUM(dfv.cantidad) AS unidades_vendidas,
    SUM(dfv.cantidad * dfv.valor_unitario) AS total_bruto,
    SUM((dfv.cantidad * dfv.valor_unitario) * (dfv.iva_porcentaje / 100)) AS total_iva,
    SUM((dfv.cantidad * dfv.valor_unitario) * (1 + (dfv.iva_porcentaje / 100))) AS total_general
FROM factura_venta fv
INNER JOIN detalle_factura_venta dfv
    ON dfv.id_factura_venta = fv.id_factura_venta
INNER JOIN asesores a
    ON a.id_asesor = fv.id_asesor
INNER JOIN personas_naturales pn
    ON pn.id_tercero = a.id_tercero
WHERE fv.estado <> 'ANULADA'
GROUP BY YEAR(fv.fecha), MONTH(fv.fecha), a.id_asesor, CONCAT(pn.nombres, ' ', pn.apellidos);