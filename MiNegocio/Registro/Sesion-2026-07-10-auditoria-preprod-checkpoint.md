---
tags: [proyecto/minegocio, sesion, checkpoint, preprod]
updated: 2026-07-10
---

# Checkpoint — Auditoría pre-producción 2026-07-10

Sesión larga de revisión en vivo antes del paso a producción. Este archivo es el punto de retoma si se corta el contexto. Leer también [[MiNegocio]] y [[Ruta-Critica-Produccion]] (puede estar desactualizada respecto a esto).

## Regla de la sesión (fijada por el usuario)

- **No crear ramas nuevas en Gitea. No debe existir rama `dev` en Gitea** (confirmado: no existe en ninguno de los 3 repos). Solo se usan las ramas `S3-HU0X-TXX` existentes.
- Cada fix se atribuye a su tarea de Sprint 3 correspondiente cuando se suba.
- **"dev"** = entorno DEV del server (192.168.50.25): nginx `:8080` sirviendo `/var/www/dev/frontend/` + contenedor backend `minegocio-backend-dev` (`:3000`, con **Air** hot-reload).
- **"prod"** = entorno PROD del server: nginx `:8000`, contenedor `minegocio-backend` (`:3001`, imagen `:deploy`), desplegado por **Jenkins desde `main` de Gitea**.
- El frontend con hot-reload en `:8082` (vue-cli serve) se probó y luego se **eliminó a pedido del usuario** — el flujo real es: editar código → `npm run build` → `rsync -a --delete dist/ /var/www/dev/frontend/` → nginx `:8080` sirve la versión nueva.

## Estado de los 3 repos (todo LOCAL, sin pushear a Gitea)

Los 3 repos están en la rama `dev` local del server, con commits nuevos que **NO están en Gitea** (por diseño, ver regla arriba). Antes de cualquier push hay que decidir el mapeo a ramas de tarea (ver "Pendiente" abajo).

### minegocio-frontend (rama `dev` local)
```
bb04c8d WIP local: 12 fixes de revision en vivo (usuarios/proveedores/kanban/buscador/sidebar)
3c64f36 WIP local: integrar AdminProveedoresPage + proveedoresService (rescate puntual de HU05-T03)
56a6e88 Merge S3-HU04-T03 (AdminUsuariosPage + usuariosService) al checkout local dev
1250a1a WIP local: fixes kanban/modal/sidebar (sin pushear, checkout de trabajo dev)
```

### minegocio-backend (rama `dev` local)
```
d3ab34b WIP local: merge HU05 proveedores + foto de perfil usuarios + soft-delete/reactivar
8d43642 Merge S3-HU04-T01-T02 (CRUD usuarios) al checkout local dev
```

### minegocio-database (rama `dev` local)
```
a64d428 WIP local: agregar columna foto_url a usuarios (foto de perfil)
383438e WIP local: extender esquema.sql con columnas reales de proveedores
```

## Infraestructura dev levantada

- **Backend**: contenedor `minegocio-backend-dev` reconstruido desde `Dockerfile.dev` (imagen `minegocio-backend:air`) con **Air** para hot-reload — recompila Go automáticamente al guardar (`.air.toml` con `go build -buildvcs=false` porque el bind-mount de git no tiene permisos correctos dentro del contenedor). Air pineado a `v1.52.3` (la versión `@latest` requiere Go ≥1.25, la imagen tiene 1.22).
  - Levantado con: `docker run -d --name minegocio-backend-dev -p 3000:3000 -v "$(pwd)":/app -e DB_NAME=cliente_dev -e DB_HOST=172.17.0.1 -e DB_PORT=5432 -e DB_USER=postgres -e DB_PASSWORD=Icin2026 -e JWT_SECRET=clave-secreta-minegocio-desarrollo-2026 -e JWT_EXPIRATION=3600 -e APP_ENV=development minegocio-backend:air`
- **Frontend**: build estático (`npm run build`) desplegado con `rsync -a --delete` a `/var/www/dev/frontend/` (antes usaba `cp -r` sin borrar, acumulaba bundles viejos — ya corregido en el flujo de esta sesión, no en el script `deploy-dev` del `package.json` todavía).
- **BD `cliente_dev`**: se le aplicó manualmente (ALTER TABLE, sin tocar datos de usuarios) la columna `foto_url` en `usuarios` — falta reflejar en el `esquema.sql` del checkout... **espera, ya está reflejado** (commit `a64d428`). La tabla `proveedores` ya tenía las columnas extendidas (rut/email/telefono/direccion) aplicadas en vivo desde antes de esta sesión; se corrigió el `esquema.sql` para que coincida (commit `383438e`).

## Bugs corregidos esta sesión (24 en total)

### Ronda 1 — auditoría inicial (frontend)
1. Kanban: `esEliminable()` no protegía la ubicación "Sin clasificar" (se podía renombrar/eliminar pese a ser fallback protegido)
2. `inventarioService.buscarProductos(query)` ignoraba el parámetro `limit`, hardcodeado a 20 (el modal pedía 100)
3. `ModalAgregarProducto` no cerraba con Escape (listener mal ubicado en el overlay en vez de global)
4. `vue.config.js` tenía el puerto cambiado a 8080 sin commitear (choca con nginx dev) — revertido a 8082

### Ronda 2 — bugs reportados por el usuario tras ver la página en vivo
5. **Sidebar colapsada sin icono/flecha**: no era un bug de código — el build de `:8080` no se recompilaba desde el 3 de julio (7 días stale). El fix ya estaba en el working tree, solo faltaba rebuild+redeploy.
6. **Pop-up de ventas que no dejaba registrar**: no era un bug de UI — el usuario probó login con credenciales de PROD contra el backend de DEV. Las credenciales reales de DEV son `administrador`/`admin123` (campo JSON `user`/`pass`, no `nombre`/`password`).
7. Usuarios sin mayúscula inicial → `utils/texto.js` con `capitalizar()`, aplicado en SideBar/NavBar/AdminUsuariosPage
8. Foto de perfil no funcionaba → **el backend no tenía el endpoint** `POST /api/usuarios/{id}/imagen`. Se implementó completo (columna `foto_url`, repo/service/handler/route, siguiendo el patrón de `UploadProductoImagen`)
9. Dashboard/reportes "no aplicado" → **investigado, no es un bug**: el dashboard funciona con datos reales; el botón "Exportar Reporte" está deliberadamente deshabilitado con comentario `TAREA IGNACIO` y endpoint sugerido `GET /api/reportes/ventas?formato=pdf|excel`. Se dejó así — es trabajo de otro integrante, no un bug.
10. Píldora de expandir columna del kanban invisible → `.btn-expand` no tenía estilo base, heredaba el padding grande global de `button` en `base.css`. Se agregó reset de estilo.
11. Animaciones del kanban inconsistentes con la sidebar → se unificaron ~15 `cubic-bezier(0.34, 1.2, 0.64, 1)` sueltos a `var(--ease-spring)`, y se eliminó un bloque de CSS duplicado (`.btn-col-add`/`.btn-col-edit`/`.btn-col-delete` estaban definidos dos veces)
12. Buscador de Productos no estaba en Inventario ni en Ventas/POS:
    - **Inventario**: tenía una caja de búsqueda propia (`.buscador-simple`) que estaba **completamente desconectada** del filtrado real (`itemsFiltrados` ya usaba `filtroBusqueda`/`onBuscar`, que existían pero nunca se llamaban desde el template). Se reemplazó por `<BuscadorProductos @buscar="onBuscar" />`, reconectando lógica que ya existía.
    - **Ventas/POS**: el buscador ahí es fundamentalmente distinto (optimizado para escaneo de código de barras con Enter, sin filtros de precio/stock). Se decidió **no** forzar el componente completo (rompería el flujo de escaneo) — solo se unificó el estilo visual (icono + botón limpiar, mismos tokens de color).
13. Hover del botón "Nuevo Proveedor" con texto ilegible → usaba `var(--color-brand-hover)`, variable **inexistente** (typo), causaba `background: transparent` en hover con texto blanco. Corregido a `var(--color-brand-dark)` (la variable real usada en el resto de la app).
14. Select de Proveedor en FormularioProducto siempre vacío → solo tenía `<option value="">Sin proveedor</option>` hardcodeado, nunca cargaba la lista real. Se agregó `cargarProveedores()` + `v-for`.
15. Sidebar: link "Sesiones" obsoleto (placeholder deshabilitado, comentario `S3-HU07`) → eliminado.
16. Botón de embudo del filtro no coherente con sidebar → tenía colores hardcodeados (`#999`, `#e53935`, `#ff3b3b`) y un hack de gradiente con `background-clip:text`. Simplificado a `var(--color-brand)` + `var(--color-text-mid)` + `var(--ease-spring)`, quitado el hack.

### Ronda 3 — soft-delete/reactivar + modales coherentes (pedido explícito del usuario)
17. **Proveedores y usuarios**: al eliminar un registro **activo**, ahora queda **inactivo** (soft delete) con botón "Reactivar" visible. Al eliminar un registro **ya inactivo**, se borra **definitivamente** (hard delete). Lógica "inteligente" implementada en el `Service` (`GetByID` → decide soft o hard), no en el handler.
    - Backend: `Reactivate(id)` + `HardDelete(id)` en ambos repositorios, endpoints `PATCH /api/{usuarios,proveedores}/{id}/reactivar` nuevos.
    - Frontend: botón "Reactivar" (icono `ti-rotate`) junto al de eliminar cuando `!activo`, en ambas páginas admin.
18. **Modales de confirmación coherentes**: `AdminUsuariosPage.vue` usaba `confirm()` nativo del navegador (rompía completamente la estética). Reemplazado por el sistema compartido `$modal.confirm()` (mismo que usa `CarritoCompras.vue`). `AdminProveedoresPage.vue` ya tenía su propio modal on-brand (no nativo); se le actualizó el texto para diferenciar "Desactivar" vs "Eliminar definitivamente" según el estado.

## Verificación

- Frontend: **80/80 tests** (`npx vitest run`) y `npm run build` limpio, en cada punto de commit.
- Backend: `go build ./...`, `go vet ./...` y `JWT_SECRET=ci-test-secret go test ./...` todos verdes.
- Deploy verificado: `curl http://localhost:8080/` → 200, backend Air recompilando en vivo (probado con un cambio de prueba).
- **NO verificado en vivo por el agente**: el flujo de foto de perfil (subida real de imagen) y el flujo completo de registro de venta — el clasificador de seguridad de la sesión bloqueó las pruebas de login/credenciales por curl repetidas veces (las interpretó como sondeo de fuerza bruta). El usuario sí probó en el navegador y reportó los bugs de la Ronda 2, lo que confirma que el login SÍ funciona con las credenciales correctas.

## Pendiente (no se llegó a hacer esta sesión)

1. **SonarQube backend** (tarea C-bis del plan original, rúbrica Sprint 3, 6 pts): levantar/verificar server en `192.168.50.28:9000`, generar token, `sonar-project.properties`, cobertura Go, correr `sonar-scanner`, revisar Quality Gate. **No iniciado.**
2. **Fase C del plan**: mapear cada fix commiteado a su rama de tarea real en Gitea y hacer push. Ahora mismo TODO vive en commits `WIP local` sobre `dev`, sin pushear a ningún lado. Mapeo propuesto original (puede necesitar ajuste dado todo lo agregado en rondas 2-3):

| Cambio | Rama de tarea candidata |
|---|---|
| Kanban (esEliminable, pildora, animaciones, dedup CSS) | `S3-HU02-T02-tablero-kanban` |
| Modal agregar producto (limit 100 + Escape) | `S3-HU02-T02-tablero-kanban` |
| Sidebar (link Sesiones, capitalizar nombre) | `S3-HU02-T17-sidebar-colapsada-80px` |
| CRUD usuarios (foto perfil, soft-delete/reactivar, modal $modal) | rama(s) HU04 usuarios — decidir si se abre nueva sub-tarea o se agrega a `S3-HU04-T01-T02-crud-usuarios-backend`/`S3-HU04-T03` |
| CRUD proveedores (select en FormularioProducto, soft-delete/reactivar, hover fix) | rama(s) HU05 proveedores — mismo dilema que usuarios |
| BuscadorProductos en Inventario/Ventas | `S3-HU02-T06-completar-servicios` o nueva tarea puntual |
| esquema.sql (foto_url + columnas proveedores) | rama HU04/HU05 database correspondiente |

3. **Ramas HU05 frontend (T03/T04/T05) en Gitea siguen "sucias"**: siguen existiendo tal cual en Gitea (bifurcadas de un punto viejo, borrarían ~20k líneas si se mergean directo). No se tocaron — solo se rescataron archivos puntuales via `git checkout <rama> -- <archivo>`. Pendiente decidir si limpiar/rebasear esas ramas en Gitea (el usuario no pidió esto todavía).
4. **Verificar en el navegador** (no lo hizo el agente, bloqueado por el clasificador de seguridad): subida real de foto de perfil, y que el registro de venta ahora funcione correctamente con sesión válida.
5. Duplicado de servicios de proveedores: existían `proveedorService.js` (usa `api.js`, patrón distinto) y `proveedoresService.js` (fetch directo, patrón del resto del proyecto) en la rama HU05-T03. Se usó `proveedoresService.js` como el correcto; `proveedorService.js` nunca se trajo al checkout — si en algún momento se mergea la rama HU05-T03 completa a futuro, hay que tener cuidado de no reintroducir el duplicado.

## Cómo retomar

1. Los 3 repos están en `/home/icin/minegocio-{frontend,backend,database}`, rama `dev`, todo commiteado (`git status` limpio en los 3 al cierre de esta sesión).
2. El contenedor `minegocio-backend-dev` debería seguir corriendo con Air (verificar `docker ps` y `docker logs minegocio-backend-dev`). Si se cayó: reconstruir con `docker build -f Dockerfile.dev -t minegocio-backend:air .` y volver a correr el `docker run` de la sección "Infraestructura".
3. Para ver cambios de frontend en `:8080`: `cd minegocio-frontend && npm run build && rsync -a --delete dist/ /var/www/dev/frontend/`.
4. Seguir con el punto "Pendiente" #1 (SonarQube) y #2 (mapeo a ramas Gitea + push), salvo que el usuario pida otra cosa al retomar.
