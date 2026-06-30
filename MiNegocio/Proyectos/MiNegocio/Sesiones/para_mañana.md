# Plan para mañana — S3-HU02-T16

## Bug 1 — Stock no se actualiza tras compra

**Causa raíz:** `CarritoCompras.vue` solo emite `update-items, []` tras venta exitosa, pero no refetchea los resultados de búsqueda. `VentasPage.vue` mantiene stocks viejos en `resultados[]`.

**Solución:** `CarritoCompras` emite `@venta-completada` con IDs de productos vendidos. `VentasPage` escucha y refetchea `buscarProductos()`.

**Archivos:** `CarritoCompras.vue`, `VentasPage.vue`

---

## Bug 2 — Sin scanner de código de barras en búsqueda POS/Inventario

**Causa raíz:** `FormularioProducto.vue` tiene input scanner dedicado, pero `VentasPage.vue` e `InventarioPage.vue` solo tienen input genérico `placeholder="Buscar producto por nombre..."`.

**Solución:** Agregar segundo input tipo scanner (como registro) con estilo verde + `@keyup.enter` a `VentasPage` e `InventarioPage`.

**Archivos:** `VentasPage.vue`, `InventarioPage.vue`

---

## Bug 3 — Productos "fantasma" en inventario vs productos

**Diagnóstico:** `inventario_view` es consistente con tabla `productos`. Ambos endpoints filtran `activo=true`. No hay datos huérfanos. El culpable más probable es `LIMIT=12` en `ProductosRegistrados.vue` — con 15 productos en dev, 3 quedan en página 2 y el usuario no los ve.

**Solución:** Aumentar LIMIT de 12 a 100.

**Archivo:** `ProductosRegistrados.vue`

---

## Bug 4 — QA + Bug Hunting

Pruebas sistemáticas en dev (:8080):

| Área | Pruebas |
|------|---------|
| CRUD productos | Descripciones ultra largas, caracteres especiales, precios negativos, códigos no numéricos, duplicados |
| Compra/Venta | Doble click rápido en confirmar, stock exacto al límite, múltiples productos iguales, carrito con stock=0 |
| Inventario | Actualizar stock a valores extremos, verificar estado Normal/Bajo/Agotado |
| Autenticación | Sin token, token expirado, rutas protegidas |
| Consola | Errores JS, respuestas API inesperadas, 404s, CORS |
| Imágenes | Productos sin imagen, URL rota, formatos no soportados |

---

## Commits propuestos

Rama: `S3-HU02-T16-stock-scanner-qa`

1. `fix: refrescar stock en busqueda tras compra`
2. `feat: escaner codigo barras en busqueda POS e inventario`
3. `fix: aumentar limite paginacion productos`
4. Según bugs encontrados en QA
