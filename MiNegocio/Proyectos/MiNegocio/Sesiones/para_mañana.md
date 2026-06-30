# Plan para mañana — S3-HU02-T16

> **EJECUTADO 2026-06-30** — Commits sobre la rama existente `S3-HU02` (local, sin push), formato `S3-HU02-BugFix-*`. Bugs reportados como issues en Gitea.
> - ✅ Bug 1 (issue #13) — `CarritoCompras.vue` emite `@venta-completada`; `Ventas.vue` refetchea `buscarProductos()`. Commit `db6bd44`.
> - ✅ Bug 2 (issue #14) — Input scanner verde con `@keyup.enter`: en `Ventas.vue` busca por código y agrega al carrito (valida stock>0); en `Inventario.vue` filtra la tabla de stock por código/nombre. Commits `db6bd44` (POS) y `ec78bfc` (inventario).
> - ✅ Mejora escaneo POS (issue #14) — al escanear, el producto pasa solo al carrito; el campo se limpia sincrónicamente (sin encadenar lecturas) y se reenfoca tras cada lectura y al entrar al POS, para disparar la pistola en serie sin clics. Commit `01b0541`.
> - ✅ Bug 3 (issue #15) — `Productos.vue`: `LIMIT 12 → 100`. Commit `6517e61`.
> - ⏳ Bug 4 (issue #16) — QA manual pendiente (requiere navegador en dev :8080, no disponible en este entorno).
> - Verificación: `lint` limpio, `vitest` 53/53 verde, `build` de producción OK.
> - Nombres reales del repo ≠ plan: `VentasPage→Ventas.vue`, `InventarioPage→Inventario.vue`, `ProductosRegistrados→Productos.vue`.
> - **Pendiente:** correr Bug 4 (QA) → merge a `dev` → testeo → merge a `main`.

---


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
