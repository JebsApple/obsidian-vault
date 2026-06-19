---
tags: [proyecto/minegocio, integrante, victor, imagenes, galeria]
---

# Victor Herrera — S2-HU04: Carga de Imágenes + Galería

## Tasks del S2-Post-STL-Revert-Plan

- **Backend:** Portar `middleware/upload.go` (validación MIME por magic bytes), endpoints de imagen en `producto_handler.go` (Upload/Delete), servicio y repositorio de imagen.
- **Frontend:** Conservar `FormularioProducto.vue` (drag & drop), `GaleriaProductos.vue`, `ProductosPage.vue`, `ProductosRegistrados.vue`.
- **Base de datos:** Schema principal (tablas `usuarios`, `productos`), vista `inventario_view`.

---

## Arquitectura general (capas — para el profe)

```
routes.go           → empareja URL + método con handler
middleware/         → intercepta antes del handler (JWT, subida de archivos)
handler/            → recibe request HTTP, parsea, responde JSON
service/            → lógica de negocio (acá es passthrough la mayoría)
repository/         → SQL queries
models/             → structs de datos compartidas
```

Para imágenes en particular:

```
UploadMiddleware (middleware/upload.go)
  → valida tamaño ≤ 5MB y formato JPG/PNG/WebP (por magic bytes, no extensión)
  → almacena datos validados en r.MultipartForm.Value
    → ProductoHandler.UploadProductoImagen (handler/producto_handler.go:182)
      → lee datos validados del middleware
      → genera UUID, escribe archivo en uploads/productos/
      → productoService.UpdateImagenURL(id, url)
        → productoRepository.UpdateImagenURL(id, url)
          → UPDATE productos SET imagen_url=$1 WHERE id=$2
```

---

## Feature A: Carga de Imágenes (Backend)

### Middleware (`middleware/upload.go`)

**Es la capa que intercepta ANTES del handler.** El profe puede preguntar "¿qué ventaja tiene validar en middleware vs handler?" → Separación de responsabilidades: el middleware se encarga de validar el archivo, el handler solo de procesarlo.

```go
UploadMiddleware(next http.Handler) http.Handler
  → ParseMultipartForm (max 5MB)
  → Lee campo "imagen" del form
  → DetectImageMIME(data) → magic bytes:
       JPEG: 0xFF 0xD8 0xFF
       PNG:  0x89 0x50 0x4E 0x47
       WebP: "RIFF" + offset 8: "WEBP"
  → Si no es válido → 400 "Formato no permitido"
  → Si es válido → guarda datos en r.MultipartForm.Value
    → llama next.ServeHTTP(w, r)
```

### Handler — UploadProductoImagen (`producto_handler.go:182`)

```go
UploadProductoImagen(w, r)
  → extrae {id} de la URL
  → recupera datos validados del middleware (MIME + bytes)
  → MIMEToExt(mime) → "jpg" | "png" | "webp"
  → os.MkdirAll("uploads/productos", 0755)
  → uuid.New() → nombre único → os.WriteFile
  → productoService.UpdateImagenURL(id, "/uploads/productos/uuid.ext")
  → Si falla la BD → borra el archivo (rollback manual)
```

### Handler — DeleteProductoImagen (`producto_handler.go:244`)

```go
DeleteProductoImagen(w, r)
  → extrae {id}
  → productoService.GetByID(id) → obtiene imagenURL actual
  → os.Remove(physicalPath) → borra archivo físico
  → productoService.ClearImagenURL(id) → UPDATE SET imagen_url=NULL
```

### Ruta (routes.go:38-41)

```go
protected.Handle("/productos/{id:[0-9]+}/imagen",
    middleware.UploadMiddleware(http.HandlerFunc(productoHandler.UploadProductoImagen)),
).Methods("POST")
//                                ↑ doble middleware: AuthMiddleware (del subrouter) + UploadMiddleware
```

### Servicio y Repositorio

```go
// service/producto_service.go — passthrough
UpdateImagenURL(id, url) → repo.UpdateImagenURL(id, url)
ClearImagenURL(id)       → repo.ClearImagenURL(id)

// repository/producto_repository.go
UpdateImagenURL(id, url)  → UPDATE productos SET imagen_url=$1 WHERE id=$2 AND activo=true
ClearImagenURL(id)        → UPDATE productos SET imagen_url=NULL WHERE id=$1 AND activo=true
```

---

## Feature B: Galería + Productos (Frontend)

### GaleriaProductos.vue

Grid responsivo (4 → 2 → 1 columna) de cards de producto con:
- Imagen (o placeholder 📷 si no tiene)
- Nombre, categoría, precio (formateado CLP con `toLocaleString('es-CL')`)
- Badge de stock (con color según nivel)
- Botones: editar, eliminar, cambiar imagen

```javascript
props: [productos]
emits: @editar, @eliminar, @upload-imagen, @delete-imagen
```

Usado por `ProductosPage.vue` y `ProductosRegistrados.vue`.

### ProductosPage.vue — ruta `/productos`

Dos tabs:
1. **Registrar**: tabla con todos los productos + `FormularioProducto` para crear/editar
2. **Galería**: `BuscadorProductos` + `GaleriaProductos` con paginación (12/page)

```javascript
mounted → cargarProductos() → fetch GET /api/productos
crear/editar → FormularioProducto → POST/PUT /api/productos
subir imagen → productosService.uploadImagen(id, file) → POST /api/productos/{id}/imagen
```

### ProductosRegistrados.vue — ruta `/productos-registrados`

Galería standalone con buscador y filtros. Editar redirige a `/productos?editar=:id`.

### FormularioProducto.vue

Componente de 426 líneas. Integra:
- Formulario CRUD (nombre, código barras, precios, stock, categoría, marca)
- **Drag & drop de imágenes** (eventos HTML5 nativos: `@dragover.prevent`, `@drop.prevent`)
- **Escáner de código de barras** (input + `@keyup.enter`)
- Validación: tipo MIME, tamaño ≤ 5MB
- Cálculo de ganancia estimada en tiempo real
- En edición: carga datos existentes, permite reemplazar imagen

```javascript
@drop.prevent="manejarDrop"  → valida archivo → previsualiza
guardarProducto() → POST/PUT producto → si hay imagen pendiente → uploadImagen()
```

---

## Feature C: Base de Datos

### Tabla productos

```sql
CREATE TABLE productos (
    id              SERIAL PRIMARY KEY,
    nombre          VARCHAR(255) NOT NULL,
    codigo_barras   VARCHAR(100) UNIQUE,    -- nullable, para escáner
    precio_compra   INTEGER CHECK (>=0),
    precio_venta    INTEGER CHECK (>=0),
    stock           INTEGER DEFAULT 0 CHECK (>=0),
    imagen_url      TEXT,                    -- ruta relativa /uploads/productos/uuid.ext
    descripcion     TEXT,
    categoria       VARCHAR(100),
    marca           VARCHAR(100),
    fecha_ingreso   TIMESTAMP DEFAULT NOW(),
    id_usuario      INTEGER REFERENCES usuarios(id) ON DELETE SET NULL,
    activo          BOOLEAN DEFAULT TRUE     -- soft delete
);
```

### Vista inventario_view

```sql
CREATE OR REPLACE VIEW inventario_view AS
SELECT id, nombre, stock,
    CASE WHEN stock >= 5 THEN 'Normal'
         WHEN stock BETWEEN 1 AND 4 THEN 'Bajo'
         ELSE 'Agotado'
    END AS estado
FROM productos;
```

### Migraciones de S2

- `registro_ventas/sprint2_create_registro_ventas.sql` (colaboración con Ignacio)
- `registro_sesiones/sprint2_create_registro_sesiones` (colaboración con Gabriel)
- Índice UNIQUE en `codigo_barras`

---

## Keywords para la exposición

| Pregunta del profe | Respuesta |
|---|---|
| ¿Dónde se valida el formato de la imagen? | En `middleware/upload.go`, con `DetectImageMIME()` que lee magic bytes |
| ¿Por qué usan magic bytes y no la extensión? | Por seguridad — la extensión se puede falsear, los bytes no |
| ¿Cuánto pesa máximo una imagen? | 5MB, definido en `maxUploadSize` en `middleware/upload.go` |
| ¿Dónde se guarda el archivo físico? | En `uploads/productos/uuid.ext` — manejado por `ProductoHandler.UploadProductoImagen` |
| ¿Cómo se sirven las imágenes al frontend? | `main.go:49`: `router.PathPrefix("/uploads/").Handler(http.StripPrefix("/uploads/", http.FileServer(http.Dir("./uploads/"))))` |
| ¿Qué formato de imágenes soportan? | JPEG, PNG, WebP |
| ¿Dónde está el drag & drop? | En `FormularioProducto.vue`, eventos nativos HTML5 `@dragover.prevent` y `@drop.prevent` |
| ¿Qué pasa si la BD falla después de guardar el archivo? | El handler borra el archivo (`os.Remove`) como rollback manual |

---

## Post-Revert: qué cambió

- El STL-redesign (NavBar, SideBar, base.css, variables.css) se eliminó
- `FormularioProducto.vue` (con drag & drop + barcode) se conservó vía cherry-pick del commit `b7501b4`
- `GaleriaProductos.vue` se conservó
- Login tiene su propio CSS (`login.css`) sin depender de `base.css`/`variables.css`
- Los estilos ahora son scoped en cada componente o imports directos
