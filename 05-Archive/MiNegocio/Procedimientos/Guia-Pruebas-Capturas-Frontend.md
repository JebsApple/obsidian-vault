---
tags: [proyecto/minegocio, testing, frontend, guia, screenshots, qa]
updated: 2026-07-07
---

# Guía de Pruebas + Capturas — Frontend MiNegocio

Guía para testear manualmente el frontend y tomar capturas de evidencia para producción.

---

## Preparación

```bash
# 1. Backend corriendo
cd /home/icin/minegocio-backend && go run main.go

# 2. Frontend en dev (hot-reload)
cd /home/icin/minegocio-frontend && npm run serve

# 3. Abrir en browser
# http://localhost:8082 (dev server)
# o http://192.168.50.25:8080 (nginx dev)
```

### Credenciales de prueba

| Usuario | Contraseña | Rol |
|---------|------------|-----|
| administrador | 1234 | admin |
| usuario | 1234 | vendedor |

---

## Pruebas por Ruta

### 1. Login (`/login`)

| # | Prueba | Resultado esperado | Captura |
|---|--------|-------------------|---------|
| 1.1 | Cargar `/login` sin token | Formulario de login visible, logo MiNegocio, campos email y contraseña, botón "Ingresar" | `01-login-vacio.png` |
| 1.2 | Login con admin correcto | Redirige a `/servicios`. SideBar visible con todas las opciones (Productos, Ventas, Inventario, Admin Usuarios, etc.) | `02-login-admin-exitoso.png` |
| 1.3 | Login con usuario vendedor | Redirige a `/servicios`. SideBar visible SIN opción Admin Usuarios. | `03-login-vendedor-exitoso.png` |
| 1.4 | Login con credenciales inválidas | Mensaje de error visible. No redirige. | `04-login-fallido.png` |
| 1.5 | Cerrar sesión | Redirige a `/login`. Token eliminado. | `05-login-cerrar-sesion.png` |

### 2. SideBar / Navegación (`/servicios`)

| # | Prueba | Resultado esperado | Captura |
|---|--------|-------------------|---------|
| 2.1 | SideBar expandido (256px) | Iconos + texto visible, avatar con inicial, nombre de usuario | `06-sidebar-expandido.png` |
| 2.2 | Colapsar SideBar (80px) | Solo iconos visibles, tooltips al hover | `07-sidebar-colapsado.png` |
| 2.3 | Navegar a cada ruta desde SideBar | Cada click carga la vista correcta sin errores | — |
| 2.4 | Rutas protegidas sin token | Redirige a `/login?redirect=...` | `08-redirect-auth.png` |

### 3. Dashboard / Analisis (`/`)

| # | Prueba | Resultado esperado | Captura |
|---|--------|-------------------|---------|
| 3.1 | Vista sin login | Landing page con info del negocio, sin datos sensibles | `09-dashboard-landing.png` |
| 3.2 | Vista con login | KPIs visibles: productos totales, ventas del día, stock bajo | `10-dashboard-kpis.png` |

### 4. Productos (`/productos`)

| # | Prueba | Resultado esperado | Captura |
|---|--------|-------------------|---------|
| 4.1 | Listar productos | Galería con tarjetas de producto (imagen, nombre, precio, stock) | `11-productos-galeria.png` |
| 4.2 | Buscar productos | Filtro por nombre/precio/stock funciona. Resultados se actualizan. | `12-productos-buscar.png` |
| 4.3 | Crear producto | Formulario completo. Campos: nombre, precio_venta, precio_sin_iva (automático), stock, categoría, proveedor, imagen. | `13-productos-crear.png` |
| 4.4 | Editar producto | Formulario precargado. Guardar cambios. | `14-productos-editar.png` |
| 4.5 | Subir imagen producto | Cropper.js se abre. Recortar y guardar. | `15-productos-imagen-subir.png` |
| 4.6 | Eliminar producto (soft delete) | Confirmación con AppModal. Producto desaparece de galería. | `16-productos-eliminar.png` |

### 5. Ventas / POS (`/ventas`)

| # | Prueba | Resultado esperado | Captura |
|---|--------|-------------------|---------|
| 5.1 | Buscar productos para vender | Resultados aparecen al escribir. | `17-ventas-buscar.png` |
| 5.2 | Agregar producto al carrito | Aparece en lista con cantidad, precio_unitario, subtotal | `18-ventas-carrito.png` |
| 5.3 | Modificar cantidad en carrito | Subtotal se actualiza. | — |
| 5.4 | Registrar venta | AppModal de confirmación. Stock descuenta. | `19-ventas-registrar.png` |
| 5.5 | Carrito vacío | Botón "Registrar venta" deshabilitado. Mensaje "Carrito vacío". | `20-ventas-carrito-vacio.png` |

### 6. Inventario / Kanban (`/inventario`)

| # | Prueba | Resultado esperado | Captura |
|---|--------|-------------------|---------|
| 6.1 | Vista Kanban | Columnas por ubicación física (Bodega, Vitrina, Sin clasificar). Tarjetas con producto + stock + badge de estado. | `21-kanban-columnas.png` |
| 6.2 | Arrastrar tarjeta entre columnas | Cambia ubicación. PATCH se envía al backend. | `22-kanban-drag.gif` (animado) |
| 6.3 | Crear nueva ubicación | Nueva columna aparece. | `23-kanban-nueva-ubicacion.png` |
| 6.4 | Vista tabla Stock | Tabla con todos los productos, stock editable, columna ubicación. | `24-inventario-tabla.png` |
| 6.5 | Editar stock desde tabla | PATCH se envía. Badge de estado se actualiza. | — |

### 7. Registro de Ventas (`/registro-ventas`)

| # | Prueba | Resultado esperado | Captura |
|---|--------|-------------------|---------|
| 7.1 | Listar historial | Tabla con fecha, productos, total. | `25-registro-ventas.png` |
| 7.2 | Filtrar por fecha | (Si existe) Rango de fechas funciona. | — |

### 8. Admin Usuarios (`/admin/usuarios`) — Solo admin

| # | Prueba | Resultado esperado | Captura |
|---|--------|-------------------|---------|
| 8.1 | Acceder como admin | Lista de usuarios con roles. | `26-admin-usuarios.png` |
| 8.2 | Acceder como vendedor | Redirige a `/servicios` o muestra 403. | — |
| 8.3 | Crear/editar usuario | (Cuando implementado) | — |

### 9. Servicios (`/servicios`)

| # | Prueba | Resultado esperado | Captura |
|---|--------|-------------------|---------|
| 9.1 | Menú de servicios | Cards con icono + nombre + descripción corta. Enlaces a cada sección. | `27-servicios-menu.png` |

### 10. Contacto (`/contacto`)

| # | Prueba | Resultado esperado | Captura |
|---|--------|-------------------|---------|
| 10.1 | Cargar página | Información de contacto, formulario (si existe). | `28-contacto.png` |

---

## Pruebas Generales

| # | Prueba | Resultado esperado |
|---|--------|-------------------|
| G.1 | Responsive ≤768px | SideBar se convierte en navegación horizontal. Cards se apilan. |
| G.2 | AppModal funciona global | Alert/confirm del navegador reemplazados por modal MiNegocio. |
| G.3 | Refrescar página con sesión activa | No redirige a login. Sesión persiste (JWT en localStorage). |
| G.4 | Token expirado | Redirige a login. Mensaje "Sesión expirada". |
| G.5 | Carga de imágenes lentas | Placeholder/imagen por defecto mientras carga. |
| G.6 | 404 - Ruta inexistente | Página 404 o redirección a `/`. |

---

## Checklist Screenshots para Producción

Crear carpeta `screenshots/` y tomar capturas. Lista mínima para evidencia:

- [ ] `01-login-vacio.png` — Login page
- [ ] `02-login-admin-exitoso.png` — Dashboard con sesión admin
- [ ] `03-sidebar-expandido.png` — SideBar expandido
- [ ] `04-sidebar-colapsado.png` — SideBar colapsado
- [ ] `05-productos-galeria.png` — Galería de productos
- [ ] `06-productos-crear.png` — Formulario de producto
- [ ] `07-ventas-carrito.png` — POS con carrito lleno
- [ ] `08-ventas-registrar.png` — Confirmación de venta
- [ ] `09-kanban-columnas.png` — Kanban con ubicaciones
- [ ] `10-inventario-tabla.png` — Tabla de stock
- [ ] `11-registro-ventas.png` — Historial de ventas
- [ ] `12-servicios-menu.png` — Menú de servicios
- [ ] `13-admin-usuarios.png` — Admin usuarios
- [ ] `14-responsive-mobile.png` — Vista mobile

---

## Cómo tomar capturas

### Linux (Hyprland/Wayland)
```bash
# Captura de pantalla completa
grim -t png ~/screenshots/01-login-vacio.png

# Captura de ventana específica (click en la ventana)
grim -g "$(slurp)" -t png ~/screenshots/02-login-admin-exitoso.png
```

### Desde el navegador (DevTools)
1. F12 → DevTools
2. Ctrl+Shift+P → "Capture screenshot" (viewport)
3. Ctrl+Shift+P → "Capture full size screenshot" (full page)
4. Guardar en `~/screenshots/`

---

## Post-merge a Producción

- [ ] Smoke test completo en :8000 (producción)
- [ ] Login funciona
- [ ] CRUD productos OK
- [ ] Ventas se registran OK
- [ ] Inventario/Kanban OK
- [ ] Registro ventas OK
- [ ] Admin usuarios OK
- [ ] Imágenes se cargan (proxy nginx)
- [ ] Sin errores 404/500 en consola
- [ ] Capturas de pantalla actualizadas
