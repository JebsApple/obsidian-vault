---
tags: [proyecto/minegocio, integrante, nicolas, inventario, barcode]
---

# Nicolás Valdés — S2-HU01: Código de Barras + Inventario

## Tasks del S2-Post-STL-Revert-Plan

- **Inventario API:** Endpoints GET `/api/inventario` (backend Go) — se conservó post-revert.
- **Código de barras:** Lector en `FormularioProducto.vue` (frontend) — se conservó.
- **Base de datos:** Migraciones SQL, vista `inventario_view`.

---

## Arquitectura general (capas — para el profe)

```
routes.go           → "direcciona la URL al handler"
middleware/         → "filtros: JWT, validación de archivos"
handler/            → "recibe HTTP, parsea parámetros, responde JSON"
service/            → "lógica de negocio (acá casi no hay, es passthrough)"
repository/         → "queries SQL a PostgreSQL"
models/             → "structs con tags JSON"
```

---

## Feature A: Inventario API (Backend)

### Flujo GET /api/inventario

```
Vue (InventarioPage.vue) → fetch GET /api/inventario
  → routes.go:44 → protected subrouter → AuthMiddleware
    → inventarioHandler.GetInventario (handler/inventario_handler.go:22)
      → inventarioService.GetAll (service/inventario_service.go:16)
        → inventarioRepository.GetAll (repository/inventario_repository.go:17)
          → SELECT v.id, v.nombre, v.stock, v.estado
            FROM inventario_view v
            INNER JOIN productos p ON v.id = p.id
            WHERE p.activo = true ORDER BY v.id ASC
```

### Handler (`handler/inventario_handler.go`)

```go
type InventarioHandler struct {
    inventarioService *service.InventarioService  // ← usa tipo concreto, NO interfaz
}

GetInventario(w, r) → llama service.GetAll() → responde JSON array
PatchStock(w, r)    → decodifica ActualizarStockReq, valida stock >= 0, actualiza
```

⚠️ **Dato para el profe:** InventarioHandler usa tipo concreto (`*service.InventarioService`) en vez de interfaz, a diferencia de los demás handlers. Esto es una inconsistencia arquitectónica.

### Service (`service/inventario_service.go`)

Passthrough puro. `GetAll()` → repo. `UpdateStock()` → repo. Sin lógica de negocio.

### Repository (`repository/inventario_repository.go`)

```go
GetAll()      → SELECT ... FROM inventario_view v JOIN productos p ON v.id=p.id WHERE p.activo=true
UpdateStock() → UPDATE productos SET stock=$1 WHERE id=$2 AND activo=true
```

Usa `inventario_view` — una SQL VIEW que Victor creó (ver [[Victor Herrera]]).

### Ruta

```go
protected.HandleFunc("/inventario", inventarioHandler.GetInventario).Methods("GET")
// PatchStock NO TIENE RUTA asignada (código muerto)
```

---

## Feature B: Código de Barras (Frontend)

### ¿Dónde está?

En `FormularioProducto.vue` (`src/components/FormularioProducto.vue`).

### Cómo funciona

```
[Escáner USB/HID] → escribe dígitos + Enter en el input
  → input @keyup.enter="procesarEscaneo"
    → valida que sea solo dígitos
    → busca en this.productos si el código ya existe
      └→ Sí existe → carga producto en modo edición
      └→ No existe → limpia formulario, mantiene código escaneado listo para completar datos
```

El escáner es tratado como un teclado externo. No tiene librería ni API especial. Solo escucha `keyup.enter` en un `<input>` con estilo diferenciado (borde azul + fondo verde).

### Flujo de creación de producto con código de barras

```
FormularioProducto.vue
  → input escanea código → procesarEscaneo()
  → usuario llena nombre, precios, stock
  → submit → fetch POST /api/productos
    → routes.go → AuthMiddleware → CreateProducto handler
      → productoService.Create → productoRepository.Insert
        → INSERT INTO productos (nombre, codigo_barras, ...) RETURNING id
```

### Dependencias

- No hay librería de escaneo — usa eventos nativos del DOM
- `FormularioProducto.vue` es usado por `ProductosPage.vue` (ruta `/productos`)

---

## Feature C: Búsqueda de Productos (compartido)

### `BuscadorProductos.vue`

Componente reutilizable con:
- Input de búsqueda con debounce 400ms
- Filtros: precio min/max, stock status, orden
- Emite evento `@buscar` con objeto de filtros al padre

### `productosService.buscarProductos(params)`

```javascript
→ fetch GET /api/productos/buscar?q=...&precio_min=...&precio_max=...&stock_status=...&orden=...&limit=12&offset=...
  → BuscarProductos handler (producto_handler.go:39)
    → construye BuscarParams a partir de query params
    → productoService.BuscarProductos(params)
      → productoRepository.BuscarProductos(params)
        → SELECT con ILIKE dinámico, price range, stock filter, ordering, pagination, total count
```

---

## Base de Datos

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

### Migraciones

- `registro_ventas/sprint2_create_registro_ventas.sql` — tabla `registro_ventas` con FK a `productos` y `usuarios`
- `registro_sesiones/sprint2_create_registro_sesiones` — tabla `registro_sesiones`
- Índice UNIQUE en `codigo_barras` de `productos`

---

## Keywords para la exposición

| Pregunta del profe | Respuesta |
|---|---|
| ¿Dónde se procesa el escaneo de código de barras? | En `FormularioProducto.vue`, método `procesarEscaneo()` |
| ¿El escáner necesita driver o librería especial? | No, es un HID que emula teclado. Solo escucha `keyup.enter` |
| ¿Dónde se calcula el estado del inventario? | En la SQL VIEW `inventario_view`, con un `CASE WHEN` sobre stock |
| ¿El inventario usa interfaz o tipo concreto? | Usa tipo concreto — inconsistencia arquitectónica |
| ¿Dónde está la ruta de inventario? | `routes.go:44` — protegida con JWT |
| ¿Cómo se busca un producto por código de barras? | `productosService.buscarProductos({q: codigo})` → backend hace ILIKE sobre nombre y codigo_barras |

---

## Post-Revert: qué cambió

- `InventarioPage.vue` y `KanbanBoard.vue` del STL-redesign se eliminaron (pospuestos a S3)
- El endpoint GET `/api/inventario` se conservó (estaba en `origin/main`)
- El escáner de barras en `FormularioProducto.vue` se conservó (era parte de S2-HU01)
- `PatchStock` quedó sin ruta (handler existe pero no se usa)
