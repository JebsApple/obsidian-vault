# Ponytail Audit — MiNegocio
**Fecha:** 2026-06-19 | **Scope:** Backend Go + Frontend Vue.js | **Modo:** full

> "Makes your AI agent think like the laziest senior dev in the room. The best code is the code you never wrote."

---

## Backend Go

`delete` **`var magicBytes`** — declarado pero nunca leído. `DetectImageMIME` reimplementa la lógica inline sin usarlo. Eliminar el bloque (líneas 12-20).
`/home/icin/minegocio-backend/middleware/upload.go`

`delete` **`RegisterRequest` y `TokenResponse`** — structs definidas en models sin ningún handler ni ruta que las use. Código especulativo para un registro que no existe. Eliminar ambas.
`/home/icin/minegocio-backend/models/models.go`

`delete` **`router.HandleFunc("/api/login", ...)`** — alias sin propósito para `/api/auth/login`. El frontend ya usa la ruta nueva. Eliminar línea 21 de routes y actualizar tests.
`/home/icin/minegocio-backend/routes/routes.go`

`delete` **`productRepo *repository.ProductoRepository`** en `VentaService` — inyectado pero `s.productRepo` nunca se accede. El stock se maneja vía `ventaRepo.GetStockForUpdate`. Eliminar campo y parámetro de `NewVentaService`.
`/home/icin/minegocio-backend/service/venta_service.go`

`yagni` **Interfaces decorativas** — `VentaRepositoryI` en `service/interfaces.go` y `VentaServiceI`/`InventarioHandler` en `handler/interfaces.go` no se usan como tipo: los handlers declaran structs concretas. `AuthHandler` y `ProductoHandler` sí usan interfaces → inconsistencia. Adoptar interfaces en todos o eliminar las que no se usan.
`/home/icin/minegocio-backend/service/interfaces.go`, `handler/interfaces.go`, `handler/inventario_handler.go`, `handler/venta_handler.go`

`shrink` **`GenerateToken` y `GenerateRefreshToken`** — funciones idénticas excepto por la duración. Colapsar en `func generateToken(userID int, nombre, rol string, exp time.Duration)` y llamar desde ambas.
`/home/icin/minegocio-backend/config/jwt.go`

---

## Frontend Vue.js

`delete` **`HelloWorld.vue`** — scaffold de vue-cli, no importado en ningún lugar. 58 líneas muertas.
`/home/icin/minegocio-frontend/src/components/HelloWorld.vue`

`delete` **`authGuard.js`** — no importado en ningún archivo. El guard ya está reimplementado inline en `router/index.js` (líneas 73-84).
`/home/icin/minegocio-frontend/src/middleware/authGuard.js`

`delete` **`axios.js`** — instancia axios con interceptores no importada en ningún componente ni en `main.js`. Todo el proyecto usa `fetch` nativo. Eliminar archivo **y** dependencia `axios` de `package.json`.
`/home/icin/minegocio-frontend/src/plugins/axios.js`

`delete` **`ventasService.getVenta(id)`** — llama a `GET /api/ventas/:id` que no existe en el backend. Lanzaría 404 en runtime. Eliminar el método.
`/home/icin/minegocio-frontend/src/services/ventasService.js`

`delete` **`ContactoPage.vue` + `contacto.css`** — página placeholder con solo un `<h1>`, sin funcionalidad. CSS contiene una sola regla subconjunto de otros estilos. Eliminar vista, ruta y CSS (o dejarlo claro como placeholder).
`/home/icin/minegocio-frontend/src/views/ContactoPage.vue`, `src/styles/contacto.css`

`shrink` **`App.vue.cerrarSesion`** — reimplementa `localStorage.removeItem('token') + removeItem('refresh_token')` duplicando `authService.logout()`. Reemplazar cuerpo con `import { logout } from './services/authService'`.
`/home/icin/minegocio-frontend/src/App.vue`

`shrink` **Umbral de stock duplicado con inconsistencia** — lógica `stock===0 → agotado / stock<=N → bajo` en 3 lugares con umbrales distintos: `ProductosPage.vue` <=4, `InventarioPage.vue` <=4, `GaleriaProductos.vue` <=10. Extraer a `src/utils/stockStatus.js` y unificar umbral.
`ProductosPage.vue`, `InventarioPage.vue`, `src/components/GaleriaProductos.vue`

`native` **`authHeaders()` duplicado** — función idéntica en `productosService.js` y `ventasService.js`. Extraer a `src/utils/authHeaders.js` o usar un `apiClient` compartido.
`/home/icin/minegocio-frontend/src/services/productosService.js`, `ventasService.js`

---

## Resumen

| Categoría | Detalle |
|---|---|
| Archivos eliminables | 4 (`HelloWorld.vue`, `authGuard.js`, `axios.js`, `contacto.css`) |
| Dependencias npm removibles | 1 (`axios`) |
| Líneas muertas backend | ~25 |
| Líneas muertas frontend | ~100 |
| Inconsistencia de negocio | Umbral de stock <=4 vs <=10 en 3 componentes |

### Hallazgo arquitectónico principal
`AuthHandler` y `ProductoHandler` reciben interfaces (testeables). `VentaHandler` e `InventarioHandler` reciben structs concretas (no testeables). Inconsistencia a resolver en una sola dirección antes del próximo sprint.

---

*Nada de esto bloquea la presentación. Son tareas de limpieza post-demo.*
