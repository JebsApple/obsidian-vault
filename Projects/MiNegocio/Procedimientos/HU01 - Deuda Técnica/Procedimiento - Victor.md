---
tags: [proyecto/minegocio, sprint-3, procedimiento, victor, hu01]
---

# Procedimiento — Victor — HU01: Deuda Técnica

Tus tareas ordenadas por fecha de inicio. Empezá de arriba a abajo.

---

## 1. S3-HU01-T05: Limpieza de código muerto (parte Victor) `[backend]` `[frontend]`
**Fechas:** 23 jun → 27 jun

### ¿Qué estamos haciendo y por qué?

Quedaron archivos que no se usan, variables declaradas pero nunca referenciadas, y CSS duplicado en varios archivos. Vamos a limpiar todo.

### Pasos

1. **Eliminar HelloWorld.vue.** Es el componente por defecto de `vue create` que solo dice "Welcome to Your Vue.js App". Ya tenemos componentes propios. Borrá `src/components/HelloWorld.vue`.

2. **Eliminar variable no usada.** En `middleware/upload.go` hay una variable global `var magicBytes` declarada pero nunca usada (la detección MIME está inline en `DetectImageMIME`). Borrala.

3. **Unificar CSS.** Los estilos de botones y badges están en dos lugares: dentro de `GaleriaProductos.vue` (con `scoped`, solo funciona ahí) y en `src/styles/productos.css`. Mové los estilos comunes a `productos.css` así se cambian en un solo lugar.

4. **Crear utilidad de estado de stock.** Hoy en `ProductosPage.vue`, `InventarioPage.vue` y `GaleriaProductos.vue` hay lógica repetida para decidir si el stock es bajo/normal/agotado. Además el umbral "bajo" a veces es 4, a veces 5. Creá `src/utils/stockStatus.js`:
   - `STOCK_BAJO = 4` (constante)
   - `getStockStatus(stock)` que devuelva: `"agotado"` si es 0, `"bajo"` si <= 4, `"normal"` si <= 20, `"exceso"` si > 20
   Reemplazá la lógica inline de cada componente con un `import`. Si después cambia el umbral, se cambia en un solo lugar.

5. **Centralizar cerrarSesion.** En `App.vue`, probablemente hay `localStorage.removeItem('token')` y `localStorage.removeItem('usuario')` repetidos. Reemplazalos por un llamado a `import { logout } from './services/authService'`. Si no existe la función, creala ahí.

---

## 2. S3-HU01-T10: Quitar comentarios en inglés del código `[backend]` `[frontend]`
**Fechas:** 23 jun → 27 jun

### ¿Qué estamos haciendo y por qué?

Hay comentarios en inglés y líneas de código comentadas que deberían haberse borrado. El criterio: si el código se explica solo, el comentario sobra. Los comentarios útiles deben estar en español porque es el idioma del equipo.

### Pasos

1. **Recorrer todo el código** (frontend + backend) archivo por archivo.

2. Buscar:
   - Comentarios en inglés → traducir a español
   - Comentarios que repiten lo obvio (ej: `// suma dos números` arriba de `a + b`) → eliminar
   - Líneas comentadas (ej: `//import "time"` en `usuario_repository.go`) → eliminar

3. **Criterio ponytail:** el comentario vale cuando explica el **por qué** de algo (ej: "multiplicamos por 1.19 porque el IVA es 19%"), no cuando dice el **qué** (el código ya lo muestra).

4. Revisá los hallazgos de la auditoría [[PonytailAudit-2026-06-19]] que identificaron varios casos.

---

## 3. S3-HU01-T11: Reparar READMEs del proyecto `[backend]` `[frontend]`
**Fechas:** 27 jun → 30 jun

### ¿Qué estamos haciendo y por qué?

Los README son la **puerta de entrada** al proyecto. Cualquiera que llegue al repositorio (el profesor, un nuevo dev) los lee primero. Los actuales están desactualizados e inconsistentes.

### Frontend README

Incluir: descripción, stack (Vue 3, vue-router, fetch nativo), dev (`npm install` + `npm run serve`), prod (`npm run build` + copiar `dist/` a nginx), URLs de ambientes.

### Backend README

Incluir: descripción, stack (Go, gorilla/mux, PostgreSQL, bcrypt, JWT), variables de entorno (`DB_PASSWORD`, `JWT_SECRET`), dev (`go run .` con variables seteadas), prod (Docker build + run), URLs.

### Resolver inconsistencia

El README actual menciona nginx pero el deploy usa Docker. Elegí Docker como método oficial. Aclará que nginx sirve el frontend y el backend corre en Docker separado.
