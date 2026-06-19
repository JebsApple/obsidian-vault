---
tags: [proyecto/minegocio, documentacion, S2-HU04]
---

# S2-HU04 — Explicación del Código Línea a Línea

## 📦 Frontend — Rama `S2-HU04-Frontend-Galeria`

### `src/services/productosService.js`
Capa de comunicación con el backend:

| Línea | Explicación |
|---|---|
| 1 | `API_BASE = ''` — Base URL vacía, usa el mismo origen (proxy en dev o mismo dominio en prod) |
| 3-5 | `authHeaders()` — Función que obtiene el token JWT del `localStorage` y lo mete en el header `Authorization: Bearer <token>`, más `Content-Type: application/json` |
| 8-15 | **`getProductos()`** — GET a `/api/productos` autenticado, retorna JSON con todos los productos activos |
| 17-31 | **`buscarProductos(params)`** — Construye una query string dinámica (`q`, `precio_min`, `precio_max`, `stock_status`, `orden`, `limit`, `offset`) y hace GET a `/api/productos/buscar`. Los filtros vacíos se omiten para no mandar basura |
| 34-44 | **`uploadImagen(id, file)`** — POST con `FormData` al endpoint `/api/productos/{id}/imagen`. **No** usa `Content-Type` porque el navegador lo pone automático con el boundary del multipart |
| 47-53 | **`deleteImagen(id)`** — DELETE a `/api/productos/{id}/imagen` para borrar la imagen de un producto |

---

### `src/components/GaleriaProductos.vue`
La cuadrícula visual de productos (el core de la HU04):

| Línea | Explicación |
|---|---|
| 2-4 | **Estados**: muestra "Cargando..." mientras carga, "No se encontraron productos" si la lista está vacía |
| 5-37 | **`v-for` grid**: Itera `productos` y por cada uno pinta una `card` |
| 7-9 | **Imagen**: Si `p.imagen_url` existe, muestra `<img>`, si no, un placeholder gris "Sin imagen" |
| 12-19 | **Info**: Nombre, categoría (o "—"), precio formateado y badge de stock con color dinámico |
| 22-33 | **Acciones**: 4 botones — editar (emite `editar`), eliminar (emite `eliminar`), cambiar imagen (abre input file oculto), y eliminar imagen (emite `delete-imagen`). El input file está oculto y solo acepta `image/jpeg,image/png,image/webp` |
| 59-63 | **`formatPrecio`**: Toma un número y lo convierte a formato chileno (`$1.234`) |
| 65-70 | **`stockClass`**: Retorna clase CSS según stock: 0 → `stock-agotado`, ≤10 → `stock-bajo`, sino vacío |
| 72-75 | **`stockLabel`**: Texto legible del stock |
| 78-81 | **`abrirImagen(id)`**: Simula click en el input file correspondiente al producto |
| 83-88 | **`onArchivoSeleccionado`**: Toma el archivo seleccionado, emite `upload-imagen` con el id y el file, luego limpia el input |
| 108-112 | **CSS Grid**: 4 columnas, gap de 16px |
| 114-125 | **Card**: Sombra suave, hover con sombra más pronunciada |
| 127-147 | **Imagen**: 160px de alto, `object-fit: cover`. Placeholder centrado en gris |
| 170-198 | **Stock badges**: Verde para normal, naranja para bajo, rojo para agotado |
| 228-238 | **Responsive**: 2 columnas en tablet, 1 en móvil |

---

### `src/components/BuscadorProductos.vue`
Barra de búsqueda + filtros:

| Línea | Explicación |
|---|---|
| 4-11 | Input de texto con ícono de lupa. V-model en `texto`, dispara `onTextoInput` al escribir |
| 14-42 | **Filtros**: Precio mínimo/máximo (number), estado de stock (select: Todos/Sin stock/Bajo/Normal), ordenamiento (select: Nombre, Precio menor/mayor, Stock menor/mayor) |
| 64-68 | **`onTextoInput`**: Debounce de 400ms — espera que el usuario deje de escribir antes de buscar |
| 71-78 | **`emitir`**: Emite evento `buscar` con todos los filtros como objeto |

---

### `src/views/ProductosRegistrados.vue`
Vista que orquesta el buscador + galería + paginación:

| Línea | Explicación |
|---|---|
| 8-17 | Renderiza `BuscadorProductos` y `GaleriaProductos`, conectando eventos: `@buscar`, `@editar`, `@eliminar`, `@upload-imagen`, `@delete-imagen` |
| 19-27 | **Paginación**: Botones "Anterior/Siguiente" con número de página y total |
| 70-90 | **`cargar()`**: Toma `filtros` + `limit=12` + `offset` calculado, llama a `buscarProductos`. Si falla, hace fallback a `getProductos()` (sin filtros) |
| 92-96 | **`onBuscar`**: Recibe filtros, resetea a página 1 y recarga |
| 103-105 | **`editarProducto`**: Redirige a `/productos?editar=id` para editar |
| 107-121 | **`eliminarProducto`**: Confirm, DELETE, recarga |
| 123-138 | **`subirImagen`/`eliminarImagen`**: Llama al service, luego recarga |

---

### `src/views/ProductosPage.vue`
Página de gestión (CRUD completo con escáner de código de barras):

| Línea | Explicación |
|---|---|
| 6-8 | Botón toggle para mostrar/ocultar formulario |
| 11-12 | Título dinámico: "Editar producto" o "Nuevo producto" |
| 22-32 | **Input de código de barras**: Estilo destacado (borde azul, fondo verde). `@keyup.enter` → `procesarEscaneo` — esto simula el escáner que manda Enter al final |
| 247-297 | **`procesarEscaneo()`**: Corazón de la HU04 — 1) Limpia espacios, 2) Valida que sea solo dígitos, 3) Busca si el código ya existe en la lista local. Si existe → muestra alerta naranja y pre-rellena el formulario para editar. Si no existe → alerta verde y limpia campos dejando solo el código |
| 198-205 | **`gananciaEstimada`**: Computed que calcula precio_venta - precio_compra |
| 299-314 | **`cargarProductos()`**: GET a `/api/productos` |
| 332-387 | **`guardarProducto()`**: POST (nuevo) o PUT (editar). Si hay imagen pendiente, la sube después de guardar el producto. Muestra mensajes de éxito/error |
| 389-403 | **`eliminarProducto()`**: DELETE con confirm |
| 405-423 | **`editarProducto()`**: Pre-rellena formulario con datos del producto y hace scroll arriba |

---

### `src/views/LoginPage.vue`
Autenticación básica:

| Línea | Explicación |
|---|---|
| 53-67 | POST a `/api/login` con `{user, pass}`. Guarda el token en `localStorage` |
| 76 | Redirige a `/servicios` tras login exitoso |

---

### `src/router/index.js`
Define las rutas: `/` (home), `/login`, `/servicios`, `/contacto`, `/productos`, `/productos-registrados` (galería), `/ventas` usando `vue-router` con `createWebHistory`.

---

## 📦 Backend — Rama `S2-HU04-API-Busqueda`

### `routes/routes.go`

| Línea | Explicación |
|---|---|
| 17-18 | Crea router con `gorilla/mux`, aplica middleware CORS global |
| 20-21 | **Ruta pública**: `POST /api/login` |
| 24-26 | Subrouter con prefijo `/api`, protegido con `AuthMiddleware` |
| 28 | **`GET /api/productos/buscar`** → `productoHandler.BuscarProductos` — **nueva ruta de la HU04** |
| 29 | **`GET /api/productos`** → `productoHandler.GetProductos` |

---

### `handler/producto_handler.go`

| Línea | Explicación |
|---|---|
| 14-16 | `NewProductoHandler`: Constructor que recibe el service |
| 18-28 | **`GetProductos`**: Consulta todos los productos activos y los devuelve como JSON |
| 30-85 | **`BuscarProductos`**: Parsea query params (`q`, `precio_min`, `precio_max`, `stock_status`, `orden`, `limit`, `offset`). Valida rangos (limit entre 1-100, offset ≥ 0). Llama al service y devuelve `{status, total, limit, offset, productos}` |

---

### `service/producto_service.go`
Capa intermedia: `GetAllActive()` y `BuscarProductos()` delegan directamente al repositorio.

---

### `repository/producto_repository.go`

| Línea | Explicación |
|---|---|
| 11-20 | `BuscarParams` struct con todos los filtros posibles |
| 30-43 | **`GetAllActive`**: `SELECT ... WHERE activo = true ORDER BY nombre` |
| 45-110 | **`BuscarProductos`**: Construye dinámicamente la cláusula `WHERE` con **parámetros posicionales** (`$1`, `$2`, ...). Soporta: búsqueda por texto (`ILIKE` en nombre y código), filtro por precio min/max, filtro por stock (sin_stock=0, bajo=1-10, normal>10). Ordenamiento dinámico. Primero cuenta total (sin paginación), luego trae resultados con `LIMIT/OFFSET` |

---

## 📦 Backend — Rama `S2-HU04-API-Imagenes`

### `middleware/upload.go`

| Línea | Explicación |
|---|---|
| 13 | `maxUploadSize = 5 << 20` = 5MB |
| 16-25 | **Magic bytes**: Tabla de firmas de archivo para detectar formato real (JPEG, PNG, WebP) |
| 28-43 | **`DetectImageMIME`**: Lee los primeros bytes y compara con las firmas conocidas. WebP requiere chequeo extra (RIFF header + WEBP en offset 8) |
| 46-56 | **`MIMEToExt`**: Convierte MIME → extensión |
| 59-118 | **`UploadMiddleware`**: 1) Parsea multipart con límite de 5MB. 2) Obtiene el campo `"imagen"`. 3) Lee con `LimitReader` para detectar si excede. 4) Valida tipo por magic bytes. 5) Guarda datos validados en `r.MultipartForm.Value["_validatedMIME"]` y `_validatedBytes` para que el handler los reutilice sin releer el archivo |

---

### `handler/producto_handler.go` (imágenes)

| Línea | Explicación |
|---|---|
| 38-98 | **`UploadProductoImagen`**: 1) Obtiene ID de la URL. 2) Recupera MIME y bytes validados por el middleware. 3) Crea directorio `uploads/productos/`. 4) Genera nombre único con `UUID`. 5) Guarda archivo en disco. 6) Actualiza `imagen_url` en BD con `service.UpdateImagenURL`. 7) Si falla BD, borra el archivo (rollback manual). 8) Retorna `{status:"ok", imagen_url}"` |
| 100-145 | **`DeleteProductoImagen`**: 1) Obtiene ID. 2) Busca producto con `service.GetByID`. 3) Si tiene imagen, borra el archivo físico con `os.Remove`. 4) Limpia `imagen_url` en BD con `service.ClearImagenURL` |

---

### `routes/routes.go` (imágenes)

| Línea | Explicación |
|---|---|
| 19-20 | **`POST /api/productos/{id:[0-9]+}/imagen`** → pasa por `UploadMiddleware` y luego `UploadProductoImagen` |
| 21 | **`DELETE /api/productos/{id:[0-9]+}/imagen`** → `DeleteProductoImagen` |

---

### `main.go`

| Línea | Explicación |
|---|---|
| 18-24 | Conexión a PostgreSQL via `config.ConnectDB()` |
| 27-33 | Inicializa repositorios, servicios, handlers |
| 35-37 | Configura rutas |
| 39-41 | Crea `uploads/productos/` y sirve archivos estáticos con `http.FileServer` en `/uploads/` |
| 43-44 | Inicia servidor en puerto 3000 |

### `repository/producto_repository.go` (imágenes)
Agrega 3 métodos respecto a la versión de búsqueda:
- **`GetByID(id)`**: Trae un producto por su ID, con `COALESCE` para manejar nulos en campos opcionales
- **`UpdateImagenURL(id, url)`**: `UPDATE productos SET imagen_url = $1 WHERE id = $2`
- **`ClearImagenURL(id)`**: `UPDATE productos SET imagen_url = NULL WHERE id = $1`

---

## 📦 Database — `inventario_view.sql`
Vista SQL para la HU03 (inventario), independiente pero usada junto con S2-HU04. Calcula el estado del stock: Normal (≥5), Bajo (1-4), Agotado (0).

---

## 🌐 Flujo completo S2-HU04

```
Usuario ve galería en /productos-registrados
  → ProductosRegistrados.vue monta BuscadorProductos + GaleriaProductos
  → BuscadorProductos emite @buscar con filtros
  → ProductosRegistrados.cargar() llama a productosService.buscarProductos(params)
  → productosService hace GET /api/productos/buscar?q=...&precio_min=...
  → Backend busca en PostgreSQL con ILIKE, filtros, orden y paginación
  → GaleriaProductos renderiza las cards con imagen, precio, stock badge

Usuario sube imagen desde galería o formulario
  → Se dispara uploadImagen(id, file)
  → POST /api/productos/{id}/imagen con FormData
  → UploadMiddleware valida tamaño (5MB) y formato (JPEG/PNG/WebP) por magic bytes
  → UploadProductoImagen guarda en disco y actualiza BD

Usuario escanea código de barras en /productos
  → procesarEscaneo() valida dígitos, detecta duplicado, pre-rellena formulario
```
