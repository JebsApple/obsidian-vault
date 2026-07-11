---
tags: [proyecto/minegocio, sprint-3, s3-hu02, frontend, errores, bug, revision-diseno]
fecha: 2026-06-26
tipo: registro-errores
rama-revisada: S3-HU02-T01-navegacion-barra-lateral
entorno-capturas: http://192.168.50.25:8082 (deploy)
---

# Errores Frontend a corregir — MiNegocio (revisión 2026-06-26)

Revisión visual del cliente sobre el deploy `192.168.50.25:8082` + auditoría de
código en la rama `S3-HU02-T01-navegacion-barra-lateral`.

> [!important] Hallazgo transversal
> **El build desplegado en `:8082` está DESACTUALIZADO respecto a la rama de
> gitea.** Varias capturas muestran código viejo (tabla simple de inventario,
> nombre "Usuario" hardcodeado). En la rama actual ya están implementados: el
> tablero Kanban con panel lateral drag&drop (`KanbanBoard.vue` +
> `InventarioPage.vue`) y el guardado de `nombre` en `localStorage` al hacer
> login. **Primer paso de cualquier corrección: rebuild + redeploy del frontend.**

---

## Resumen de errores

| # | Error reportado | Tipo | Estado en rama actual | Acción |
|---|-----------------|------|----------------------|--------|
| 1 | Favicon es el logo de Vue, no el del kiosko MiNegocio | Bug real | Sin corregir | Crear favicon desde SVG kiosko |
| 2 | Menú lateral "gris hasta la mitad" | Bug responsive | Sin corregir | Arreglar layout móvil (≤768px) |
| 3 | Imágenes de productos no cargan (rotas) | Bug infra (nginx) | Sin corregir | Proxiar `/uploads/` en nginx |
| 4 | Inventario y Productos no coinciden / muchos de prueba | Datos + deploy viejo | Parcial | Redeploy + limpiar datos de prueba |
| 5 | Inventario debe tener panel desplegable + drag&drop por ubicación | Feature | Implementado (parcial) | Redeploy + añadir columnas configurables |
| 6 | "Usuario" no muestra el nombre real (admin) | Bug | Corregido en rama | Redeploy + re-login |

---

## Detalle y procedimiento de corrección

### 1. Favicon / icono de pestaña
- **Síntoma:** la pestaña del navegador muestra la "V" de Vue.
- **Causa:** `public/index.html` usa `<link rel="icon" href="<%= BASE_URL %>favicon.ico">`
  apuntando al `favicon.ico` por defecto de Vue CLI.
- **Fix:** ya existe un SVG del kiosko en `SideBar.vue` (`.kiosko-svg`). Exportarlo
  a `public/favicon.svg` (o `.ico` 32×32) y reemplazar:
  ```html
  <link rel="icon" type="image/svg+xml" href="<%= BASE_URL %>favicon.svg">
  ```
  Reemplazar también `src/assets/logo.png` / `public/favicon.ico` si se quiere `.ico`.
- **Archivos:** `public/index.html`, `public/favicon.*`.

### 2. Menú lateral "gris hasta la mitad"
- **Síntoma:** en ventana angosta el sidebar gris ocupa solo la parte superior y
  debajo queda blanco.
- **Causa:** `App.vue` tiene `@media (max-width: 768px) { .app-layout { flex-direction: column } }`.
  Con la ventana angosta (la captura es ~295px) el sidebar se apila ARRIBA del
  `main-content` blanco, sin tratamiento móvil (no hay hamburguesa, no colapsa).
  El `.sidebar { height: 100% }` solo cubre su contenido, no el viewport.
- **Fix:** definir comportamiento móvil real: o bien sidebar fijo a ancho completo
  con scroll, o convertirlo en drawer colapsable con botón hamburguesa. Como
  mínimo, en ≤768px que el sidebar no quede con fondo a media altura
  (`min-height: 100%` o mover el `background` al contenedor).
- **Archivos:** `src/App.vue` (bloque `@media`), `src/components/SideBar.vue`.

### 3. Imágenes de productos no cargan (rotas)
- **Síntoma:** "awa" muestra imagen rota; otros "Sin imagen".
- **Causa raíz (infra):** el backend guarda `imagen_url` como ruta **relativa**
  `/uploads/productos/<archivo>` (ver `handler/producto_handler.go:217`) y sirve
  los archivos con un FileServer en `:3000` (`main.go:49`). El frontend lo usa
  directo en `<img :src="p.imagen_url">`. **nginx solo proxia `/api/` al backend,
  NO `/uploads/`** → la imagen se pide al host del frontend (`:8082`) y da 404.
- **Fix (elegir uno):**
  1. **nginx (recomendado):** añadir `location /uploads/ { proxy_pass http://localhost:3001; }`
     (prod) / `:3000` (dev) en la config de nginx del servidor `192.168.50.25`.
  2. **Frontend:** prefijar `imagen_url` con el `API_BASE` al construir el `src`.
- **Verificación:** `curl -I http://192.168.50.25:8000/uploads/productos/<archivo>` debe dar 200.
- **Archivos:** config nginx del server (no en repo) y/o `GaleriaProductos.vue`,
  `KanbanBoard.vue`, `InventarioPage.vue` (los 3 usan `imagen_url` directo).
- **Nota datos:** además muchos productos simplemente no tienen imagen subida.

### 4. Inventario vs Productos Registrados no coinciden
- **Síntoma:** Productos Registrados muestra 2, Inventario muchos (de prueba).
- **Causa:** la captura de Inventario es del **build viejo** (tabla "Stock de
  productos" desde `inventario_view`). La rama actual usa
  `productosService.getProductos()` para el Kanban — misma fuente que el catálogo.
  Tras redeploy ambos leen los mismos productos. Los productos "Test", "awa",
  "Producto Test CRUD", etc. son **datos de prueba** en la BD.
- **Fix:** (a) redeploy; (b) limpiar datos de prueba en `productos` (tarea de BD,
  coordinar con Victor); dejar solo productos reales.

### 5. Inventario: panel desplegable + drag&drop por ubicación
- **Estado:** la rama ya tiene `InventarioPage.vue` con `<aside class="sidebar">`
  buscable + `draggable`, y `KanbanBoard.vue` con columnas drop-zone. **Falta tras
  redeploy** para que el cliente lo vea.
- **Gap vs lo pedido:** las columnas actuales son por **estado de stock**
  (`sin_clasificar`, `stock_normal`, `stock_bajo`, `agotado`), NO por **ubicación
  física** (bodega, vitrina, fuera de stock) ni configurables por el admin.
- **Fix / feature nueva:**
  - Cambiar el modelo: añadir campo `ubicacion` (o reusar `stock_status`) con
    valores de ubicación; columnas Kanban = ubicaciones.
  - Hacer `statuses` en `KanbanBoard.vue` configurable (prop / cargado de BD) en
    vez de array hardcodeado (líneas 75-81), para permitir columnas que cree el
    admin (bodega, vitrina, fuera de stock, + custom).
  - Requiere soporte backend: columna nueva en `productos` o tabla de ubicaciones,
    y que `actualizarProducto` persista el cambio (el `PUT` ya envía `stock_status`).
- **Archivos:** `KanbanBoard.vue`, `InventarioPage.vue`, backend
  (`producto_repository.go`, `models.go`, schema SQL).

### 6. Nombre de usuario muestra "Usuario" en vez del real
- **Síntoma:** el área inferior del sidebar dice "Usuario".
- **Causa:** `SideBar.vue` lee `localStorage.getItem('usuario')` → `parsed.nombre`.
  El backend SÍ devuelve `nombre` en el login (`auth_service.go:65`,
  `models.TokenResponse.Nombre`) y la `LoginPage.vue` actual SÍ guarda
  `{nombre,email,rol}`. El "Usuario" de la captura viene de una sesión iniciada
  con el **build viejo** (que no guardaba `usuario`) → `localStorage.usuario` vacío.
- **Fix:** redeploy + cerrar sesión + volver a iniciar sesión. Verificar que el
  registro del admin tenga `nombre` no vacío en la tabla `usuarios`.
- **Archivos:** ninguno en rama (ya correcto); validar dato en BD.

---

## Procedimiento de corrección sugerido (orden)

1. **Redeploy del frontend** con la rama actual (resuelve #4, #5-base, #6).
   ```bash
   cd ~/minegocio/S3-HU02-Rediseno-Frontend && npm run build
   # en server 192.168.50.25: cp -r dist/* /var/www/prod/frontend/
   ```
2. **nginx `/uploads/`** → proxy al backend (resuelve #3). Recargar nginx.
3. **Favicon** del kiosko (#1).
4. **Layout móvil** del sidebar (#2).
5. **Feature columnas por ubicación configurables** (#5 gap) — requiere backend.
6. **Limpieza de datos de prueba** en BD (#4) — coordinar con Victor.
7. Re-login para verificar nombre (#6).

---

## Referencias
- [[MiNegocio - Deploy Prod]] — procedimiento de despliegue (nginx proxia solo `/api/`)
- [[Reporte-proc-front-2026-06-27]] — base frontend S3-HU02
- [[Sprint 3 - Plan de Trabajo]]
- [[Victor Herrera]] — imágenes/galería/DB · [[Nicolás Valdés]] — inventario
