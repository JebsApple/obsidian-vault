---
tags: [proyecto/minegocio, integrante, ignacio, frontend]
---

# Ignacio Varela — Frontend Vue.js 3

## Responsabilidad

Estructura completa del frontend: App.vue, router, vistas principales, componentes reutilizables, estilos CSS.

## Arquitectura (flujo de una interacción)

```
App.vue (layout + nav global)
  → router/index.js (carga la vista según la URL)
    → views/*.vue (página completa con template + script + style)
      → components/*.vue (componentes reutilizables dentro de vistas)
        → services/*.js (fetch a API backend)
          → Nginx proxy (/api/ → localhost:3000)
            → Backend Go
```

## Archivos a su cargo

### `src/App.vue`

**Template — línea por línea:**

1. `<header class="topbar">` — barra superior roja `#d60000` con logo, nav y botón login/logout.
2. `<router-link to="/" class="logo">MiNegocio.cl</router-link>` — logo que redirige a home.
3. `<nav class="nav-links">` — navegación central. Condicional: si hay token muestra todos los enlaces (Productos, Galería, Ventas, Inventario, Registro Ventas), si no solo "Inicio".
4. `v-if="!token"` para Login, `v-else` para "Salir" (cierra sesión limpiando localStorage y redirigiendo).
5. `<router-view />` — punto de entrada de las vistas cargadas por el router.

**Script:**

1. `computed: { token() }` — reactivo: cada vez que `localStorage.getItem('token')` cambia, Vue lo detecta y re-renderiza el nav.
2. `cerrarSesion()` — elimina token y refresh_token del localStorage, redirige a `/login`.

**Style — puntos clave:**
- `* { margin:0; padding:0; box-sizing:border-box }` — reset CSS básico.
- `.topbar` — flexbox con `justify-content: space-between`, fondo `#d60000`.
- `.nav-links` — flex `flex:1` centrado con `justify-content: center`.
- `.login-btn` — botón blanco con texto rojo, destacado sobre el fondo rojo.
- `.content` — padding 30px, min-height 70vh.

### `src/router/index.js`

**Línea por línea:**

1. `import { createRouter, createWebHistory }` — WebHistory = URLs sin `#` (ej: `/productos` en vez de `/#/productos`). Requiere que el servidor web (nginx) siempre sirva el index.html para rutas desconocidas.
2. `import { getToken, isTokenExpired }` — funciones de `authService.js` para verificar sesión.
3. **Array `routes`** — define 9 rutas con su componente, nombre, y opcionalmente `meta: { requiresAuth: true }`.
4. `createRouter({ history: createWebHistory(), routes })` — crea la instancia.
5. **`router.beforeEach((to, from, next) => ...)`** — guard de navegación: antes de cada ruta, si requiere auth y no hay token válido, redirige a `/login`.

### `src/views/HomePage.vue`

**Línea por línea:**

1. `mounted()` — al cargar la página, si hay token redirige a `/servicios`, si no redirige a `/login`.
2. Template: si no hay token, muestra mensaje "Bienvenido" con link a Login. Si hay token, muestra dashboard con enlaces.

### `src/views/LoginPage.vue`

**Línea por línea:**

1. `<form @submit.prevent="login">` — evita el refresh del formulario.
2. `v-model="user"` y `v-model="pass"` — binding bidireccional a los datos del componente.
3. `async login()`:
   - `fetch('/api/login', { method:'POST', body: JSON.stringify({user,pass}) })` — llama al backend
   - Si response.ok: guarda `data.token` en localStorage, redirige a `/servicios`
   - Si no: muestra error "Usuario o contraseña incorrectos"
   - Si hay error de red: muestra "Error conectando al servidor"

### `src/views/ServiciosPage.vue`

Dashboard con botones-card para cada sección: Productos, Galería, Punto de Venta, Inventario, Registro Ventas. Cada card es un `<router-link>` con ícono y nombre.

### `src/views/ProductosPage.vue`

**Línea por línea:**

1. `data()` — estado: `mostrarFormulario` (toggle), `productoEditando` (producto seleccionado), `productos` (lista desde API).
2. `mounted()` → `cargarProductos()` — fetch GET /api/productos con token en header.
3. `conmutarFormulario()` — toggle del formulario de crear/editar.
4. `editarProducto(p)` — carga datos del producto en el formulario y hace scroll al inicio.
5. `async eliminarProducto(id)` — confirm() → DELETE /api/productos/{id} → filtra localmente.
6. Template: tabla con columnas (nombre con imagen, categoría, marca, stock con badge de color, precios, ganancia, código de barras, acciones editar/eliminar).

### `src/views/ProductosRegistrados.vue`

Usa los componentes `BuscadorProductos` y `GaleriaProductos`. Maneja la búsqueda con filtros, paginación, y subida/eliminación de imágenes.

### `src/components/FormularioProducto.vue`

**Componente destacado — 426 líneas.** Puntos clave:

1. **Props:** `producto` (para editar) y `productos` (lista para detectar duplicados por código de barras).
2. **Drag & drop de imágenes:** usa eventos HTML5 nativos `@dragover.prevent`, `@drop.prevent`, `@change` en input file. Valida tipo MIME y tamaño ≤ 5MB.
3. **Escáner de código de barras:** input con `@keyup.enter="procesarEscaneo"`. Al presionar Enter, valida que sea solo dígitos, busca si ya existe en la lista, y si existe carga sus datos para editar. Si no existe, limpia el formulario para crear nuevo producto con ese código.
4. **Ganancia estimada:** computed property que calcula `precio_venta - precio_compra` en tiempo real.
5. **Guardado:** POST/PUT a `/api/productos` según sea creación o edición, y si hay imagen pendiente la sube después con `productosService.uploadImagen()`.

### `src/components/GaleriaProductos.vue`

Grid de cards (4 columnas → 2 → 1 responsive) mostrando imagen, nombre, categoría, precio, stock badge. Botones para editar, eliminar, cambiar imagen. Método `formatPrecio()` con `toLocaleString('es-CL')`.

### `src/components/BuscadorProductos.vue`

Input de búsqueda con debounce (400ms) + filtros (precio min/max, stock status, orden). Emite evento `buscar` con el objeto de filtros al componente padre.

### Archivos CSS (`src/styles/`)

6 archivos: `productos.css`, `login.css`, `servicios.css`, `home.css`, `contacto.css`, `carritocompras.css`. Cada vista importa su CSS correspondiente con `@import`.

## Colaboradores

- **LaManzana:** Separó estilos en capas y centralizó.
- **IgVml:** Creó la página de Ventas original y ajustes de estilo.
- **GFlores:** Cambios solicitados desde Taiga.
