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
GROUP BY YEAR(fv.fecha), MONTH(fv.fecha), a.id_asesor, CONCAT(pn.nombres, ' ', pn.apellidos)
ORDER BY anio DESC, mes DESC, total_general DESC;



-- Reporte mensual de ventas por producto
SELECT
    YEAR(fv.fecha) AS anio,
    MONTH(fv.fecha) AS mes,
    p.id_producto,
    p.codigo,
    p.nombre AS producto,
    SUM(dfv.cantidad) AS unidades_vendidas,
    SUM(dfv.cantidad * dfv.valor_unitario) AS total_bruto,
    SUM((dfv.cantidad * dfv.valor_unitario) * (dfv.iva_porcentaje / 100)) AS total_iva,
    SUM((dfv.cantidad * dfv.valor_unitario) * (1 + (dfv.iva_porcentaje / 100))) AS total_general
FROM factura_venta fv
INNER JOIN detalle_factura_venta dfv
    ON dfv.id_factura_venta = fv.id_factura_venta
INNER JOIN productos p
    ON p.id_producto = dfv.id_producto
WHERE fv.estado <> 'ANULADA'
GROUP BY YEAR(fv.fecha), MONTH(fv.fecha), p.id_producto, p.codigo, p.nombre
ORDER BY anio DESC, mes DESC, unidades_vendidas DESC;



-- Reporte de rotacion de productos
SELECT
    p.id_producto,
    p.codigo,
    p.nombre AS producto,
    SUM(dfv.cantidad) AS total_unidades_vendidas,
    COUNT(DISTINCT fv.id_factura_venta) AS veces_facturado,
    SUM(dfv.cantidad * dfv.valor_unitario) AS total_bruto_vendido
FROM detalle_factura_venta dfv
INNER JOIN factura_venta fv
    ON fv.id_factura_venta = dfv.id_factura_venta
INNER JOIN productos p
    ON p.id_producto = dfv.id_producto
WHERE fv.estado <> 'ANULADA'
GROUP BY p.id_producto, p.codigo, p.nombre
ORDER BY total_unidades_vendidas DESC, total_bruto_vendido DESC;



-- Reporte de inventario disponible por producto y bodega
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
    p.id_producto, p.codigo, p.nombre
HAVING stock_disponible <> 0
ORDER BY p.nombre, b.nombre;