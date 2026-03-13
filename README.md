# Mini ERP ACME

Sistema de base de datos relacional en **MySQL 8+** para la gestión de operaciones básicas de un ERP: terceros, clientes, proveedores, productos, inventario, compras, ventas, devoluciones y reportes mensuales.

* * *

# Autores

Santiago Centeno

Santiago Gallo

Jeison Cristancho

Julian Santamaria

Kevin Pico

* * *

## Tabla de contenido

* [Descripción](#descripción)
* [Objetivos del proyecto](#objetivos-del-proyecto)
* [Características principales](#características-principales)
* [Tecnologías utilizadas](#tecnologías-utilizadas)
* [Estructura funcional](#estructura-funcional)
* [Modelo de datos](#modelo-de-datos)
* [Procedimientos almacenados](#procedimientos-almacenados)
* [Triggers](#triggers)
* [Vistas](#vistas)
* [Eventos programados](#eventos-programados)

* * *

## Descripción

`mini_erp_acme` es un esquema de base de datos diseñado para soportar un sistema ERP de pequeña escala. Su propósito es centralizar y automatizar procesos administrativos y comerciales comunes, tales como:

* gestión de terceros
* administración de clientes, proveedores y asesores
* control de productos y categorías
* registro de compras y ventas
* devoluciones de compra y venta
* control de inventario por movimientos
* generación de reportes mensuales de ventas

El proyecto está orientado a fines académicos, prácticos o como base para una futura aplicación empresarial.

* * *

## Objetivos del proyecto

* Diseñar una base de datos relacional consistente y escalable.
* Modelar operaciones reales de compra, venta e inventario.
* Implementar lógica de negocio desde MySQL usando:
  * procedimientos almacenados
  * triggers
  * vistas
  * eventos programados
* Facilitar la generación de reportes de gestión comercial.
* Garantizar integridad referencial y validaciones básicas a nivel de base de datos.

* * *

## Características principales

* Base de datos en **MySQL 8+**
* Uso de **InnoDB** para integridad transaccional
* Soporte para terceros naturales y jurídicos
* CRUD mediante procedimientos almacenados
* Registro transaccional de ventas con `JSON`
* Validación automática de stock antes de vender
* Movimientos de inventario generados automáticamente por triggers
* Devoluciones con control de cantidades acumuladas
* Vistas para consultas operativas
* Evento mensual para generación de consolidado de ventas por asesor

* * *

## Tecnologías utilizadas

* **MySQL 8.0 o superior**
* **SQL / PL MySQL**
* `utf8mb4`
* `utf8mb4_unicode_ci`
* `JSON`
* `JSON_TABLE`
* `TRIGGER`
* `EVENT`
* `PROCEDURE`

* * *

## Estructura funcional

### 1. Parametrización

Tablas para configuración general del sistema:

* `tipos_identificacion`
* `ciudades`
* `sedes`
* `bodegas`
* `medios_pago`
* `categorias`
* `politicas_descuento`

### 2. Gestión de terceros

Modelo base para personas y empresas:

* `terceros`
* `personas_naturales`
* `personas_juridicas`

Especializaciones del tercero:

* `clientes`
* `proveedores`
* `asesores`

### 3. Productos e inventario

Gestión de catálogo y stock:

* `productos`
* `proveedor_producto`
* `movimiento_inventario`

### 4. Compras

Registro de compras y devoluciones a proveedor:

* `factura_compra`
* `detalle_factura_compra`
* `devolucion_compra`
* `detalle_devolucion_compra`

### 5. Ventas

Registro de ventas y devoluciones de cliente:

* `factura_venta`
* `detalle_factura_venta`
* `devolucion_venta`
* `detalle_devolucion_venta`

### 6. Reportería

Persistencia y consulta de indicadores:

* `reporte_mensual_ventas_asesor`
* `vw_inventario_disponible`
* `vw_ventas_por_asesor`

* * *

## Modelo de datos

La base de datos sigue una estructura modular:

### Entidades maestras

Tablas de apoyo para parametrización y configuración.

### Entidades de terceros

Separa la entidad general `terceros` de sus especializaciones naturales y jurídicas.

### Entidades comerciales

Clientes, proveedores y asesores se derivan de terceros.

### Entidades transaccionales

Permiten registrar compras, ventas, devoluciones y detalles asociados.

### Entidades de control

La tabla `movimiento_inventario` permite calcular el stock disponible con base en entradas y salidas históricas.

### Entidades analíticas

Se soportan reportes mediante una tabla consolidada, vistas y consultas SQL.

* * *

## Procedimientos almacenados

### CRUD de categorías

* `sp_categoria_insertar`
* `sp_categoria_actualizar`
* `sp_categoria_eliminar`
* `sp_categoria_obtener`
* `sp_categoria_listar`

### CRUD de productos

* `sp_producto_insertar`
* `sp_producto_actualizar`
* `sp_producto_eliminar`
* `sp_producto_obtener`
* `sp_producto_listar`

### CRUD de clientes

* `sp_cliente_insertar`
* `sp_cliente_actualizar`
* `sp_cliente_eliminar`
* `sp_cliente_obtener`
* `sp_cliente_listar`

### CRUD de proveedores

* `sp_proveedor_insertar`
* `sp_proveedor_actualizar`
* `sp_proveedor_eliminar`
* `sp_proveedor_obtener`
* `sp_proveedor_listar`

### CRUD de factura de venta

* `sp_factura_venta_insertar_cabecera`
* `sp_factura_venta_actualizar_cabecera`
* `sp_factura_venta_anular`
* `sp_factura_venta_obtener`
* `sp_factura_venta_listar`

### Procedimientos especiales

* `sp_registrar_factura_venta`Registra una factura de venta completa usando una transacción y un arreglo JSON con los detalles.
  
* `sp_generar_reporte_mensual_ventas_asesor`Consolida la información mensual de ventas por asesor.
  

* * *

## Triggers

### Compras

* `trg_ai_detalle_factura_compra_mov_inv`Inserta automáticamente un movimiento de inventario de tipo `COMPRA`.

### Ventas

* `trg_bi_detalle_factura_venta_validar_stock`Verifica que exista stock suficiente antes de registrar una venta.
  
* `trg_ai_detalle_factura_venta_mov_inv`Inserta automáticamente un movimiento de inventario de tipo `VENTA`.
  

### Devoluciones de compra

* `trg_bi_detalle_devolucion_compra_validar_cantidad`Evita devolver más unidades de las compradas.
  
* `trg_ai_detalle_devolucion_compra_mov_inv`Inserta movimiento de inventario tipo `DEVOLUCION_COMPRA`.
  

### Devoluciones de venta

* `trg_bi_detalle_devolucion_venta_validar_cantidad`Evita devolver más unidades de las vendidas.
  
* `trg_ai_detalle_devolucion_venta_mov_inv`Inserta movimiento de inventario tipo `DEVOLUCION_VENTA`.
  

* * *

## Vistas

### `vw_inventario_disponible`

Consulta el stock disponible por producto y bodega.

### `vw_ventas_por_asesor`

Muestra ventas agregadas por asesor, año y mes, incluyendo:

* cantidad de facturas
* unidades vendidas
* total bruto
* total IVA
* total general

* * *

## Eventos programados

### `ev_generar_reporte_mensual_ventas_asesor`

Evento mensual encargado de ejecutar automáticamente el procedimiento de reporte del mes anterior
