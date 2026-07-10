---
tags: [proyecto/minegocio, sesion, checkpoint, preprod, handoff]
updated: 2026-07-10
---

# HANDOFF a opencode — cuota de Claude Code agotada 2026-07-10

Continuación de [[Sesion-2026-07-10-auditoria-preprod-checkpoint]]. Esa nota tiene el contexto completo de la primera mitad de la sesión (24 fixes, infraestructura Air/nginx, etc). Esta nota cubre **todo lo que pasó después** de ese checkpoint, que aún no estaba documentado cuando se cortó la cuota.

## ⚠️ ACCIÓN INMEDIATA REQUERIDA — Inventario.vue quedó a medio editar

**Archivo:** `/home/icin/minegocio-frontend/src/views/Inventario.vue`

Se modificó `cargar()` para que `this.items` incluya productos **activos e inactivos** (para poder verlos/reactivarlos en la tabla Stock), pero **falta filtrar el Kanban para que solo reciba productos activos**. Ahora mismo:

```
:productos="itemsFiltrados"   <!-- linea ~23, dentro de <KanbanBoard> -->
```

Esto va a hacer que **productos inactivos/eliminados aparezcan en el tablero Kanban**, lo cual está mal (el Kanban es solo para inventario activo).

**Fix pendiente:** cambiar a algo como:
```html
:productos="itemsFiltrados.filter(i => i.activo !== false)"
```
o crear un computed `itemsActivosFiltrados` separado y usarlo ahí. Después de este fix, faltan agregar los métodos `eliminarProducto(item)` y `reactivarProducto(id)` en el bloque `methods` de Inventario.vue (llaman a `productosService.deleteProducto(id)` / `productosService.reactivarProducto(id)` seguido de `await this.cargar()`), con el mismo patrón de confirmación diferenciada que se usó en `Productos.vue` (ver ese archivo como referencia, método `eliminarProducto` ahí ya está completo y es el patrón a copiar). Los botones ya están en el template (líneas agregadas con `@click="reactivarProducto(item.id)"` y `@click="eliminarProducto(item)"`), solo faltan los métodos.

**Después de eso:** correr `npx vitest run` y `npm run build` en `/home/icin/minegocio-frontend`, y redesplegar: `npm run build && rsync -a --delete dist/ /var/www/dev/frontend/`.

## Estado de los 3 repos — NADA de esto está commiteado

```
=== frontend (sin commitear) ===
 M package-lock.json
 M package.json                          <- chart.js, vue-chartjs, jspdf, jspdf-autotable, xlsx agregados
 M src/__tests__/Analisis.test.js
 M src/components/NavegacionMini.vue
 M src/services/productosService.js
 M src/styles/productos.css
 M src/views/Analisis.vue
 M src/views/Inventario.vue               <- A MEDIO EDITAR, ver arriba
 M src/views/Productos.vue

=== backend (sin commitear) ===
 M .gitignore
 M Jenkinsfile                            <- LOG_FILE + volumen /app/logs agregado para prod
 M handler/interfaces.go
 M handler/producto_handler.go
 M handler/producto_handler_test.go
 M handler/venta_handler.go               <- FIX CRITICO: id_vendedor ahora viene del JWT
 M middleware/auth_middleware.go          <- FIX CRITICO: ahora guarda user_id/rol en el contexto
 M repository/producto_repository.go
 M routes/routes.go
 M service/interfaces.go
 M service/producto_service.go
 M service/producto_service_test.go

=== database: limpio, todo commiteado en commits WIP previos (ver checkpoint anterior) ===
```

Los últimos commits reales (antes de todo este trabajo sin commitear) son los del checkpoint anterior:
- frontend: `bb04c8d`
- backend: `d3ab34b`
- database: `a64d428`

**Antes de commitear el backend**, correr: `cd /home/icin/minegocio-backend && go build ./... && go vet ./... && JWT_SECRET=ci-test-secret go test ./...` — al cierre de la sesión estaba **todo verde**.

**El frontend NO se pudo testear/buildear después de los últimos cambios de Inventario.vue** porque se cortó la cuota en medio de la edición. Completar el fix del Kanban primero (arriba), después correr tests/build.

## Qué se hizo en esta segunda mitad de la sesión (después del checkpoint anterior)

Todo esto vino de un mensaje largo del usuario con varios pedidos encadenados. En orden:

### 1. Bug: no se veía el ícono de Proveedores al colapsar la sidebar
**Causa real:** cuando la sidebar colapsa, el nav completo se oculta (`v-show`) y aparece un componente aparte, `NavegacionMini.vue`, que tiene su propia lista de iconos — no había sido actualizado cuando se agregó Proveedores a `SideBar.vue`. Se agregó el link a Proveedores ahí, se quitó el placeholder "Sesiones" que también estaba duplicado ahí (el usuario ya había pedido sacarlo de SideBar.vue en la ronda anterior, pero se me había pasado este archivo), y se le agregó `capitalizar()` al nombre de usuario que faltaba también. **Completado y committeable.**

### 2. Bug real: "error al guardar item de venta" al registrar una venta
**Causa raíz (grave):** `middleware/auth_middleware.go` **validaba el JWT pero nunca guardaba las claims (user_id, rol) en el contexto de la request**. `handler/venta_handler.go` confiaba en `id_vendedor` que venía del **body JSON** del frontend — pero el frontend nunca mandaba ese campo, así que llegaba como `0`, y `0` no es un usuario válido → violación de foreign key `registro_ventas_id_vendedor_fkey`.

**Fix:** el middleware ahora hace `context.WithValue` con `user_id` y `rol` extraídos del JWT (mismo patrón que ya usaba `RequestIDKey` en `middleware/logger.go`), con helpers `GetUserID(ctx)` / `GetUserRol(ctx)` en `middleware/auth_middleware.go`. `venta_handler.go` ahora usa `middleware.GetUserID(r.Context())` en vez de confiar en el body. **Este es el fix más importante de toda la sesión — sin él, ninguna venta se puede registrar.** Verificado con `go build`/`go vet`/`go test`, todo verde. **No probado end-to-end en el navegador** (no hubo tiempo).

### 3. Rúbrica de Sprint 3 — se leyó desde GitHub
El usuario pidió revisar `gh api repos/jebsapple/obsidian-vault/contents/MiNegocio/Rubrica_Sprint_3.md` (repo externo en GitHub, **no es el vault local**). Esa rúbrica reveló que "Dashboard + Exportación PDF + Exportación Excel" son **12 puntos evaluables**, no "trabajo opcional de otro integrante" como se había asumido antes en el checkpoint anterior. También reveló que falta **"Log persistente en archivo"** (3 pts) — el backend solo logueaba a stdout.

**Hallazgo extra de la rúbrica, no resuelto:** "Compilación y construcción automática Front/Back: ejecutar con un usuario diferente a `icin` (el root del servidor)" — 10 pts. El `Jenkinsfile` actual usa `PROD_USER = 'icin'`. Esto requiere crear un usuario de sistema nuevo en el server con permisos propios — **no se tocó, es una tarea de infraestructura más grande, hay que decidir con el usuario si se aborda**.

### 4. Logging persistente a archivo — RESUELTO
El código para esto **ya existía** en `config/logger.go` (variable `LOG_FILE`, usa `io.MultiWriter` para escribir a consola Y archivo) — solo faltaba setear la variable de entorno. Se hizo:
- Contenedor dev recreado con `-e LOG_FILE=/app/logs/backend-dev.log`, mapeado a `/home/icin/minegocio-backend/logs/` en el host (confirmado funcionando, hay líneas en el archivo).
- `Jenkinsfile` actualizado para prod: `LOG_FILE=/app/logs/backend-prod.log` + volumen `-v /home/icin/minegocio-backend-logs:/app/logs`. **Esto no se probó en producción real, solo se editó el Jenkinsfile.**
- `.gitignore` del backend: se agregó `logs/`.

### 5. Dashboard con gráficos reales — RESUELTO (Analisis.vue reescrito)
Se instalaron `chart.js`, `vue-chartjs`, `jspdf`, `jspdf-autotable`, `xlsx` (ver `package.json`). `src/views/Analisis.vue` quedó con:
- Producto más vendido (calculado client-side desde `ventasService.getVentas()`)
- Gráfico de barras "Ventas por Mes" (últimos 6 meses)
- Gráfico de barras "Ventas por Vendedor" (cruza `id_vendedor` con `usuariosService.getUsuarios()` para mostrar nombres)
- Se corrigió un bug de paso: "Últimas Ventas" usaba campos que no existían (`venta.id`/`venta.monto`/`venta.fecha` en vez de `venta.id_venta`/`precio_producto*cantidad`/`venta.fecha_venta`) — estaba silenciosamente vacío antes.
- Botones "Exportar PDF" (jsPDF + autoTable, tabla completa de ventas) y "Exportar Excel" (xlsx, hoja "Ventas") reemplazan el botón deshabilitado viejo ("TAREA IGNACIO").
- Todo client-side, **no se creó ningún endpoint backend nuevo de estadísticas** (se descartó esa idea por tiempo — se calcula todo en el frontend a partir de los endpoints ya existentes: `/api/productos`, `/api/ventas`, `/api/usuarios`).
- Test actualizado (`Analisis.test.js`) para los 2 botones de export en vez de 1 deshabilitado.
- **Bundle creció bastante** (chart.js + xlsx + jspdf son pesados): de ~500KB a ~1.49MB total. Aceptable para un proyecto de curso, pero si sobra tiempo valdría la pena lazy-load de estas librerías (import dinámico) ya que Analisis.vue no es la ruta más visitada.
- 80/80 tests pasaban en el último build verificado (antes de tocar Inventario.vue).

### 6. Soft-delete + reactivar aplicado también a Productos — RESUELTO (backend + Productos.vue)
El usuario pidió que el mismo patrón de "activo→inactivo con botón reactivar, inactivo→borrado definitivo" que ya se había hecho para usuarios/proveedores se aplique también a productos.

**Backend** (verificado con tests, todo verde):
- `repository/producto_repository.go`: `GetAllIncluyendoInactivos()`, `Reactivate(id)`, `HardDelete(id)` nuevos.
- `service/producto_service.go`: `SoftDeleteProducto(id)` ahora es "inteligente" (mira `GetByID` primero, decide soft o hard), + `Reactivate(id)`, `GetAllIncluyendoInactivos()`.
- `handler/producto_handler.go`: `GetProductos` acepta `?incluir_inactivos=true`; nuevo handler `ReactivarProducto`.
- `routes.go`: nueva ruta `PATCH /api/productos/{id}/reactivar`.
- **Ojo con HardDelete de productos:** `registro_ventas.id_producto` es `NOT NULL REFERENCES productos(id)` **sin** `ON DELETE`, o sea default `RESTRICT`. Si un producto tiene ventas registradas, el hard-delete va a fallar con un error de FK (no se agregó manejo especial para esto, el error crudo de Postgres se propaga como mensaje — igual que el resto del código existente, es el patrón establecido, pero convendría dar un mensaje más amigable tipo "no se puede eliminar, tiene ventas asociadas").

**Frontend — Productos.vue (panel-productos): COMPLETO.**
- `cargarTabla()` ahora pide `productosService.getProductos(true)`.
- Tabla "Registrados" tiene columna Estado + botón Reactivar (ícono `ti-rotate`) cuando `!p.activo`.
- `eliminarProducto(id)` tiene el mismo texto de confirmación diferenciado (desactivar vs. eliminar definitivo) que usuarios/proveedores, usando `$modal.confirm()`.
- Estilos `.btn-icon--ok` y `.row-disabled` agregados a `src/styles/productos.css` (compartido, así que Inventario.vue los hereda gratis cuando se complete).

**Frontend — Inventario.vue (panel-inventario): A MEDIO HACER, ver sección de arriba.** La tabla Stock ya tiene las columnas/botones en el template, `cargar()` ya trae los productos inactivos, pero falta:
1. Filtrar el Kanban para que NO reciba inactivos (bug activo ahora mismo).
2. Agregar los métodos `eliminarProducto(item)` / `reactivarProducto(id)` (no existen todavía en el `methods` de Inventario.vue).

### 7. NavegacionMini coherente con SideBar — RESUELTO
Además del fix de Proveedores (punto 1), se agregó `HABILITAR_WIP` a la condición `esAdmin` de `NavegacionMini.vue` para que se comporte igual que `SideBar.vue` (antes solo chequeaba rol admin, sin mirar el flag WIP).

### 8. Animación vista-switch/vista-tab — RESUELTO
En `src/styles/productos.css`, la transición de color del texto de las pestañas (`.vista-tab`, `.vista-tab-badge`) usaba `0.25s ease` mientras que el fondo rojo deslizante (`.vista-switch::before`) usa `0.42s cubic-bezier(0.16,1,0.3,1)` (variable `--vt-ease`). Esto hacía que el texto cambiara de color ANTES de que el rojo llegara debajo. Se sincronizaron ambas transiciones a `0.42s var(--vt-ease)`.

## Lo que NO se alcanzó a hacer (pedido explícitamente por el usuario, sigue pendiente)

1. **Terminar Inventario.vue** (ver arriba, es lo más urgente).
2. **Commitear** todo lo de esta sesión en los 3 repos (backend primero, correr tests antes).
3. **Carpeta de pruebas QA manuales con capturas** para las 5 HU de Sprint 3 — el usuario pidió convertir el archivo de pruebas existente (buscar algo como "Guia-Pruebas-Capturas" en el vault, mencionado en `Procedimientos/`) en una **carpeta** con instrucciones paso a paso, una por HU, para pruebas manuales de QA. **No se empezó nada de esto.**
4. **SonarQube backend** — sigue sin hacer (tarea C-bis original, ver checkpoint anterior).
5. **Usuario `icin` en Jenkins** (hallazgo de la rúbrica, punto 3 arriba) — 10 puntos de la rúbrica, requiere trabajo de infraestructura no trivial. Decidir con el usuario si se aborda.
6. **Verificar en el navegador** (no se pudo probar en vivo por límites de tiempo/cuota):
   - Que el registro de venta ahora funcione de verdad (el fix del punto 2 es sólido a nivel de código y tests, pero no se hizo la prueba manual real).
   - Los gráficos del dashboard con datos reales.
   - Exportar PDF/Excel.
   - El ícono de Proveedores en la sidebar colapsada.
   - La animación de vista-switch sincronizada.
   - Reactivar/eliminar productos desde Productos.vue.

## Cómo retomar (para opencode)

1. Editar `/home/icin/minegocio-frontend/src/views/Inventario.vue`:
   - Buscar `:productos="itemsFiltrados"` (línea ~23) y cambiar a `:productos="itemsFiltrados.filter(i => i.activo !== false)"`.
   - Agregar en `methods:` (copiar el patrón de `Productos.vue`, método `eliminarProducto`):
     ```js
     async eliminarProducto(item) {
       const mensaje = item.activo
         ? '¿Desactivar este producto? Podrás reactivarlo luego.'
         : 'Este producto ya está inactivo. Esta acción lo eliminará definitivamente y no se puede deshacer. ¿Continuar?'
       if (!await this.$modal.confirm(mensaje)) return
       try {
         await productosService.deleteProducto(item.id)
         await this.cargar()
       } catch (e) {
         await this.$modal.alert(e.message || 'Error al eliminar el producto.')
       }
     },
     async reactivarProducto(id) {
       try {
         await productosService.reactivarProducto(id)
         await this.cargar()
       } catch (e) {
         await this.$modal.alert(e.message || 'Error al reactivar el producto.')
       }
     }
     ```
   - `productosService` ya está importado en ese archivo (se usa arriba).
2. `cd /home/icin/minegocio-frontend && npx vitest run && npm run build`
3. `cd /home/icin/minegocio-backend && go build ./... && go vet ./... && JWT_SECRET=ci-test-secret go test ./...`
4. Si todo pasa, commitear los 3 repos (backend, frontend — database ya estaba limpio), en rama `dev` local, **sin pushear a Gitea** (regla de la sesión, ver checkpoint anterior).
5. Redesplegar: `rsync -a --delete /home/icin/minegocio-frontend/dist/ /var/www/dev/frontend/`. Verificar que `minegocio-backend-dev` (contenedor con Air) siga corriendo: `docker ps`. Si no, reconstruir según instrucciones del checkpoint anterior.
6. Seguir con la carpeta de QA (punto 3 de pendientes) y lo demás según orden de prioridad que decida el usuario.
