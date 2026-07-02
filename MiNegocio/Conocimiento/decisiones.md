---
tags: [concepto, arquitectura]
---

# Decisiones Técnicas

Registra aquí decisiones importantes de arquitectura y por qué se tomaron.

## Formato
- **Fecha:** YYYY-MM-DD
- **Contexto:** ¿Qué problema resolvía?
- **Decisión:** ¿Qué se eligió?
- **Razón:** ¿Por qué?

## IVA 19% desglose visual con neto almacenado
- **Fecha:** 2026-07-02
- **Contexto:** S3-HU02-T15 — mostrar el IVA chileno en el formulario de productos sin cambiar cómo el negocio ingresa precios.
- **Decisión:** El precio de venta sigue siendo el precio final (IVA incluido). El neto se deriva (`precio_venta / 1.19`, redondeado a entero) y se almacena en `productos.precio_sin_iva`. El backend lo calcula si el cliente no lo envía (`precio_venta * 100 / 119`). Campo `id_proveedor` (*int, NULL = sin proveedor) preparado con tabla `proveedores` mínima; el CRUD completo es de Gabriel (S3-HU05).
- **Razón:** No obliga a re-ingresar precios ni romper el flujo actual; el desglose es informativo/contable. Almacenar el neto (en vez de calcularlo siempre) permite reportes SQL directos y históricos estables si el IVA cambia.

## Inventario consulta productos directo (sin inventario_view)
- **Fecha:** 2026-07-02
- **Contexto:** Productos fantasma: Inventario/Stock mostraba productos que no existían en Registrados.
- **Decisión:** `inventario_repository` consulta `productos` con el CASE de estado en SQL; el frontend de Inventario construye su lista desde `getProductos()` (misma fuente que Registrados). La vista queda solo por compatibilidad, recreada con `WHERE activo = true`.
- **Razón:** La definición de una vista vive en la DB y puede quedar desalineada del código (no se versiona junto al backend). Una sola fuente de verdad elimina la clase entera de bugs de desincronización entre pantallas.
