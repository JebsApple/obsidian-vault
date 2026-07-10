---
tags: [minegocio, sprint3, guia-estudio, victor, hu02]
created: 2026-07-10
updated: 2026-07-10
---

# Guía de Explicación — Víctor Herrera — Rama `S3-HU02` (Gitea)

**Repo:** `minegocio-frontend` — rama `S3-HU02` en Gitea: http://192.168.50.28:3000/VHerrera/minegocio-frontend/src/branch/S3-HU02
**Código local:** `~/proyectos/minegocio` (rama `gitea/S3-HU02`) y copia en `~/MiNegocio3.1.0/minegocio-frontend`
**Idea central para el profesor:** rediseñé el frontend (Vue 3, Options API) — sidebar colapsable, kanban de inventario por ubicación física, buscador con filtros, foto de perfil con recorte — siguiendo el patrón **vista → service → API**, donde cada vista habla solo con un service que hace `fetch` con el JWT.

## Archivos trabajados en la rama S3-HU02

| Archivo | Qué es |
|---|---|
| `src/App.vue` | Layout raíz: decide NavBar vs SideBar, colapso, menú contextual, modal de foto |
| `src/components/SideBar.vue` | Navegación lateral con colapso, avatar, rol admin |
| `src/components/NavegacionMini.vue` | Barra de iconos que aparece cuando la sidebar está colapsada |
| `src/components/MenuContextualAvatar.vue` | Menú al hacer click en el avatar (cambiar foto / cerrar sesión) |
| `src/components/ModalFotoPerfil.vue` | Subida + recorte (Cropper.js) de la foto de perfil |
| `src/components/KanbanBoard.vue` | Tablero kanban con columnas dinámicas por ubicación, drag & drop |
| `src/components/BuscadorProductos.vue` | Buscador con debounce y filtro embudo |
| `src/views/Inventario.vue` | Vista padre del kanban: carga datos, maneja eventos, CRUD ubicaciones |
| `src/views/Ventas.vue` | POS: escáner de código de barras, agregar al carrito |
| `src/services/inventarioService.js` | Wrapper `fetch` de `/api/inventario` y `/api/ubicaciones` |
| `src/services/authService.js` | Login, JWT decodificado, refresh token, subida de foto |
| `src/__tests__/KanbanBoard.test.js` | Tests Vitest del kanban (columnas por ubicación, drag & drop) |

---

## 1. `src/services/inventarioService.js` (87 líneas — el más fácil de explicar completo)

- **L1** `const API_BASE = ''` — base vacía: las peticiones son relativas, nginx hace de proxy al backend Go.
- **L3-9** `authHeaders()` — lee el token JWT de `localStorage` y arma `Authorization: Bearer <token>` + `Content-Type: application/json`. **Toda petición pasa por aquí** — así ninguna vista repite lógica de auth.
- **L11-18** `getAll()` — `GET /api/inventario`; si `!res.ok` lanza `Error` (la vista lo captura y muestra el modal).
- **L20-28** `updateStock(id, stock)` — `PATCH /api/inventario/{id}` con body `{ stock }`.
- **L30-38** `updateUbicacion(id, ubicacion)` — mismo PATCH pero body `{ ubicacion }`. El backend usa punteros (`*int`, `*string`) para saber cuál campo vino.
- **L40-77** `getUbicaciones` / `createUbicacion` / `renameUbicacion` / `deleteUbicacion` — CRUD de las columnas del kanban contra `/api/ubicaciones`.
- **L79-86** `buscarProductos(query)` — `GET /api/productos/buscar?q=...&limit=20` con `encodeURIComponent` (evita romper la URL con caracteres especiales).

**Frase clave:** "cada método sigue el mismo patrón: fetch → chequear `res.ok` → lanzar Error o devolver JSON. La vista nunca ve `fetch`."

## 2. `src/services/authService.js` (107 líneas)

- **L5-18** `login(credentials)` — `POST /api/login`; si responde OK guarda `token` y `refresh_token` en `localStorage`.
- **L20-24** `logout()` — borra token, refresh y foto cacheada.
- **L30-38** `isTokenExpired(token)` — decodifica el JWT con `jwtDecode`, compara `exp * 1000` (el JWT usa segundos, JS milisegundos) contra `Date.now()`.
- **L40-49** `getUserFromToken()` — decodifica `user_id`, `nombre`, `rol` del token. **No hay store (Vuex/Pinia): el JWT es la única fuente de verdad de la sesión.**
- **L63-84** `refreshToken()` — si el access token venció, `POST /api/auth/refresh` con el refresh token; si falla, logout y redirección a `/login`.
- **L86-107** `uploadFotoPerfil(file)` — arma `FormData`, saca el `id` del propio JWT y sube a `/api/usuarios/{id}/imagen`; guarda la URL devuelta en `localStorage` para pintar el avatar sin decodificar el token cada vez.

## 3. `src/components/KanbanBoard.vue` (script L175-378)

- **L176-184** Constante `UBICACION_FALLBACK = 'Sin clasificar'` — columna protegida que recibe productos sin ubicación válida.
- **L189-202** `props`: recibe `productos` y `ubicaciones` desde el padre. **Componente "tonto": no hace fetch propio.**
- **L204-210** `emits`: `product-moved`, `agregar-ubicacion`, `eliminar-ubicacion`, `renombrar-ubicacion` — todo cambio real lo ejecuta el padre.
- **L224-230** computed `columnas` y `nombresColumnas` (un `Set` para búsqueda O(1)).
- **L235-238** `ubicacionDe(p)` — devuelve la ubicación del producto solo si existe como columna; si no, `null` (cae en "Sin clasificar", no se pierde).
- **L240-242** `getProductosPorUbicacion(nombre)` — filtra los productos de cada columna comparando texto.
- **L255-261** `handleDragStart` — serializa el producto a JSON dentro de `dataTransfer` (drag & drop HTML5 nativo, sin librería).
- **L281-301** `handleDrop` — deserializa con `try/catch` (hotfix: un drop externo con JSON inválido rompía el tablero), valida `producto.id`, ignora si cayó en la misma columna, y emite `product-moved` con `{ productId, nuevaUbicacion }`.
- **L303-305** `toggleExpand` — expande/contrae una columna para ver detalle de tarjetas.
- **L313-348** alta/renombrado de columnas: valida `nombre.trim()`, emite evento, el padre llama al service.
- **L350-361** `stockClass`/`badgeClass` — colores semánticos: 0 = agotado (rojo), ≤4 = bajo (amarillo), resto normal.

## 4. `src/views/Inventario.vue` (métodos L211-333)

- **L211-239** `cargar()` — `Promise.all` trae inventario y productos **en paralelo**, arma un `Map` por id (L218) y fusiona ambos en `this.items` con spread (`...item`, inmutable). `finally` apaga el spinner pase lo que pase.
- **L241-247** `cargarUbicaciones()` — llena las columnas del kanban; si falla, array vacío (no revienta la vista).
- **L265-281** `actualizarStock` y `onProductMoved` — llaman al service (PATCH) y recargan; error → `$modal.alert` (modal global, no `alert()` nativo).
- **L304-320** `agregarUbicacion` / `renombrarUbicacion` — crean/renombran columna vía service y recargan.
- **L322-333** `eliminarUbicacion` — **primero** `$modal.confirm` (L323), si el usuario acepta llama `deleteUbicacion`; el backend reubica los productos a "Sin clasificar" en transacción.

**Frase clave:** "el kanban emite eventos, la vista los traduce a llamadas al service, y siempre recarga desde el backend — el estado nunca se edita a mano en el cliente."

## 5. `src/App.vue` (230 líneas)

- **L2-16** template: `NavBar` solo sin sesión (L3), `SideBar` con sesión (L7); `NavegacionMini` aparece solo si la sidebar está colapsada (L9, con `<Transition>`).
- **L52-59** `provide()` — inyecta `$modal` (alert/confirm) a toda la app: cualquier vista hace `this.$modal.confirm(...)` sin importar nada.
- **L74-78** `isLoggedIn` — computed sobre el token: decide todo el layout.
- **L88-98** watchers: al cambiar de ruta relee el token (login/logout refresca la UI); al colapsar la sidebar espera 450ms (duración de la animación) antes de mostrar la mini-barra.
- **L102-107** `handleLogout` — limpia sesión, cierra menú, redirige a `/login`.

## 6. `src/views/Ventas.vue` (POS + escáner)

- **L67-70** al montar, autofoco en el input del escáner (`$refs` + `focus()`), porque una pistola lectora "tipea" el código y termina con Enter.
- **L93-118** `procesarEntrada()` — con Enter: limpia el input **sincrónicamente** (L96, para que el escáner no concatene dos lecturas), busca match exacto por `codigo_barras` (L101); si no hay, cae a búsqueda textual; valida `stock <= 0` con modal (L108-110) y agrega al carrito (L112).

## 7. `src/components/BuscadorProductos.vue`

- **L58-67** `data`: `debounceTimer` — al tipear se cancela el timer anterior y se agenda la búsqueda (L76-77), así no se dispara un fetch por cada tecla.
- **L88** emite `buscar` con el objeto de filtros; la vista padre decide qué hacer.
- Filtro "embudo" (T16): botón que muestra/oculta filtros, rojo activo / gris inactivo.

## 8. `src/components/ModalFotoPerfil.vue` + `MenuContextualAvatar.vue`

- **L79** `validarArchivo` — en cliente: tamaño ≤5MB y tipo JPEG/PNG (el backend revalida con magic bytes).
- **L99** crea `new Cropper(image, ...)` con aspecto 1:1 forzado.
- **L122-135** `confirmarCrop` — toma el canvas recortado, lo dibuja **sobre fondo blanco** (L133, porque un PNG transparente convertido a JPEG quedaría negro), `canvas.toBlob(..., 'image/jpeg', 0.9)` y llama `uploadFotoPerfil`. Al éxito emite `foto-actualizada` → `App.vue` refresca el avatar de la sidebar sin recargar la página.
- `MenuContextualAvatar` — menú posicionado en `x,y` del click, emite `cambiar-foto` / `cerrar-sesion` hacia `App.vue`.

## 9. `src/components/SideBar.vue` + `NavegacionMini.vue`

- **SideBar L127-135** computeds `usuarioNombre`, `usuarioInicial`, `esAdmin` — todo sale de `getUserFromToken()` (JWT); el link "Usuarios" solo se ve si `rol === 'admin'` (L56).
- **L75-77** avatar: muestra foto si hay URL cacheada, si no la inicial del nombre.
- Colapso: prop `colapsado` desde `App.vue`, animación spring (`cubic-bezier(0.34, 1.56, 0.64, 1)`) y stagger escalonado en los items.
- **NavegacionMini L3-17** — solo `router-link` con iconos Tabler + `title` (tooltip); repite el guard `v-if="esAdmin"` para Usuarios.

---

## Commits propios de la rama (para mostrar en Gitea)

```
031fbbf S3-HU02: fix build errors post-merge
a7ef0a6 S3-HU02-T17: menu contextual avatar, modal foto perfil, sidebar colapsada, Kanban expand
d50ca89 S3-HU02-T17: restaurar animacion iconos sidebar y fusionar buscador POS
5d0bb16 S3-HU02-T16: filtro embudo en BuscadorProductos
f62593e S3-HU02-T15: KanbanBoard con columnas dinamicas, expand pill, drag-drop
6df1114 S3-HU02-HOTFIX: JSON.parse protegido en handleDrop
dec1528 S3-HU02-HOTFIX: kanban responsive (grid inline anulaba media queries)
```

## Si el profesor pregunta…

1. **"¿Cómo sabe el frontend quién está logueado?"** — No hay store: decodifico el JWT con `jwt-decode` en `authService.getUserFromToken()` (L40-49) cada vez que lo necesito. El token vive en `localStorage`.
2. **"¿Cómo funciona el drag & drop?"** — HTML5 nativo: `dragstart` serializa el producto a JSON en `dataTransfer` (KanbanBoard L255-261), `drop` lo deserializa con try/catch y emite un evento; la vista padre hace el PATCH y recarga (Inventario L274-281).
3. **"¿Por qué el kanban no hace fetch?"** — Separación de responsabilidades: componente presentacional (props + emits), la vista orquesta, el service habla con la API. Facilita los tests (KanbanBoard.test.js le pasa props falsas sin backend).
4. **"¿Qué pasa si borro una columna con productos?"** — El backend los reubica a "Sin clasificar" en una transacción; en frontend esa columna es fallback protegido (`UBICACION_FALLBACK`, L178) y no se puede eliminar.
5. **"¿Por qué fondo blanco antes de subir la foto?"** — El recorte se exporta como JPEG, que no soporta transparencia; sin ese `fillRect` un PNG transparente saldría con fondo negro (ModalFotoPerfil L128-135).
