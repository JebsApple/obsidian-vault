---
tags: [proyecto/minegocio, sprint-3, procedimiento, victor]
---

# Procedimiento — Victor

## S3-HU01-T05: Limpieza — parte Victor `[backend]` `[frontend]`
**Fechas:** 23 jun → 27 jun

1. Eliminar `src/components/HelloWorld.vue`.
2. En `middleware/upload.go`, eliminar variable `var magicBytes` (no se usa — la lógica está inline en `DetectImageMIME`).
3. Consolidar CSS duplicado: unificar estilos de botones/badges entre `GaleriaProductos.vue` (scoped) y `src/styles/productos.css`.
4. Crear `src/utils/stockStatus.js` con constante de umbral (`STOCK_BAJO = 4`) y función `getStockStatus(stock)` que devuelva "agotado", "bajo", "normal", "exceso". Usarla en `ProductosPage.vue`, `InventarioPage.vue` y `GaleriaProductos.vue` (reemplazar lógica inline actual).
5. En `App.vue`, método `cerrarSesion`: reemplazar `localStorage.removeItem(...)` duplicado por llamado a `import { logout } from './services/authService'`.

## S3-HU01-T10: Quitar comentarios en inglés del código `[backend]` `[frontend]`
**Fechas:** 23 jun → 27 jun

1. Recorrer todo el códigobase (frontend + backend).
2. Prioridad alta: comentarios en `models/models.go` que no aportan (ej: "model se usa para identificar las tablas de bd y como dto" → eliminar).
3. Código comentado: `//import "time"` en `repository/usuario_repository.go` → eliminar.
4. Comentarios en inglés → español o eliminar si son redundantes (criterio ponytail: si el código se explica solo, el comentario sobra).
5. Hallazgos de PonytailAudit: aplicar los mismos criterios.

## S3-HU01-T11: Reparar READMEs del proyecto `[backend]` `[frontend]`
**Fechas:** 27 jun → 30 jun

1. Reescribir `README.md` del frontend con: descripción, stack (Vue 3, vue-router, fetch nativo), instrucciones dev (`npm install`, `npm run serve`), prod (`npm run build`, copiar `dist/` a nginx), URLs de ambientes.
2. Reescribir `README.md` del backend con: descripción, stack (Go, gorilla/mux, PostgreSQL), instrucciones dev (variables de entorno, DB, `go run .`), prod (Docker build + run).
3. URLs de ambientes: prod=`http://192.168.50.25:8000`, dev=`http://192.168.50.25:8080`, backend directo=`http://192.168.50.25:3001`.
4. Corregir inconsistencia: README actual dice nginx pero el deploy usa Docker (documentar ambos o elegir Docker como oficial).

## S3-HU02-T01: NavBar y SideBar `[frontend]`
**Fechas:** 23 jun → 30 jun

1. Recuperar componentes del STL-redesign desde commits pasados: `NavBar.vue`, `SideBar.vue`, `LogoSVG.vue`.
2. Adaptar paleta: primario `#D60000`, fondo blanco, texto `#2C3E50`.
3. NavBar: logo SVG a la izquierda, nombre de usuario (desde localStorage), botón cerrar sesión.
4. SideBar colapsable: enlaces a Dashboard, Productos, Registrados, Ventas, Inventario.
5. Responsive: ocultar SideBar en <768px, mostrar solo menú hamburguesa.
6. Layout en `App.vue`: sidebar + contenido.

## S3-HU02-T02: KanbanBoard de Inventario `[frontend]` `[backend]`
**Fechas:** 30 jun → 4 jul

1. Recuperar `KanbanBoard.vue` del STL-redesign.
2. Columnas: Agotado (stock=0), Bajo (1-4), Normal (5+), Exceso (>20). Usar constante desde `utils/stockStatus.js`.
3. Cards: nombre, código de barras, thumbnail imagen, stock actual.
4. Drag & drop: al soltar en otra columna, calcular nuevo stock según umbral y llamar `PATCH /api/inventario/{id}/stock`.
5. Si la ruta PATCH no existe, crearla en `routes/routes.go` y `handler/inventario_handler.go`.

## S3-HU02-T03: Dashboard principal `[frontend]`
**Fechas:** 4 jul → 8 jul

1. Rediseñar `AnalisePage.vue`: cards con KPIs (total productos, ventas del día, stock bajo <=4, agotados).
2. Cada card: icono + color semántico (verde/amarillo/rojo según estado).
3. Últimas 5 ventas (tabla pequeña abajo).
4. Sin librerías externas: CSS grid/flexbox nativo.

## S3-HU02-T04: Testing frontend `[frontend]` `[test]`
**Fechas:** 5 jul → 8 jul

1. 1 test por componente recuperado (NavBar, SideBar, KanbanBoard): render básico + props.
2. 1 test de integración: flujo login → token en localStorage → redirección.
3. Usar Vitest (ya incluido con vue-cli). Tests en `src/__tests__/`.

---

## Referencias

- [[Sprint 3 - Plan de Trabajo]]
- [[PonytailAudit-2026-06-19]] — hallazgos de código muerto
- [[Rúbrica Evaluación]] — observaciones sobre READMEs y estilos
