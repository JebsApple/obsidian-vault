---
tags: [proyecto/minegocio, integrante, ignacio, ventas]
---

# Ignacio Varela — S2-HU02: Punto de Venta (Ventas API + POS)

## Tasks del S2-Post-STL-Revert-Plan

- **Backend:** Portar `venta_handler.go`, `venta_service.go`, `venta_repository.go` a la estructura post-revert.
- **Frontend:** Mantener su POS (`VentasPage.vue` + `CarritoCompras.vue` + `ventasService.js`).

---

## Arquitectura general (para estudiar)

El backend está en capas. Cuando el profe pregunte "¿a dónde va esta función?", la respuesta es una de estas 5:

```
HTTP Request
  → routes.go          (define qué URL → qué handler)
    → middleware/       (filtros: JWT, upload — interceptan antes del handler)
      → handler/        (recibe HTTP, parsea JSON, valida, llama al service)
        → service/      (lógica de negocio — en este proyecto es mayormente passthrough)
          → repository/  (SQL queries a PostgreSQL)
            → models/    (structs con tags JSON)

Respuesta JSON ← el camino inverso
```

**Regla de oro:** Handler nunca toca la BD. Repository nunca ve HTTP. Service orquesta.

---

## Tu Feature: Ventas (Backend)

### Flujo completo POST /api/ventas

```
VentasPage.vue (click "Confirmar Venta")
  → ventasService.registrarVenta(items)     → fetch POST /api/ventas
    → routes.go (protected subrouter)        → AuthMiddleware (JWT)
      → VentaHandler.RegistrarVenta()        → parsea JSON, valida items
        → ventaService.Registrar(items, 0)   → passthrough
          → ventaRepository.Insert(items)    → SQL transacción:
               INSERT INTO registro_ventas + UPDATE stock
```

### Rutas (routes.go:47-48)

```go
protected.HandleFunc("/ventas", ventaHandler.RegistrarVenta).Methods("POST")
protected.HandleFunc("/ventas", ventaHandler.GetVentas).Methods("GET")
```

Ambas protegidas con JWT (subrouter `/api` tiene `AuthMiddleware`).

### Handler (`handler/venta_handler.go`)

| Método | Qué hace | Cómo responder si el profe pregunta |
|--------|----------|--------------------------------------|
| `RegistrarVenta` | Decodifica `VentaRequest` del body → valida que items tengan `cantidad > 0` y `producto_id > 0` → llama `service.Registrar` → responde 201 con `{status:"ok", id}` | "El handler recibe la request HTTP, parsea el JSON, valida campos obligatorios, y delega al service" |
| `GetVentas` | Llama `service.GetAll()` → responde JSON con lista | "Obtiene todas las ventas, las devuelve como JSON" |

### Service (`service/venta_service.go`)

Passthrough puro. No tiene lógica de negocio. Solo llama al repository. Si el profe pregunta por qué existe: "Mantiene la arquitectura en capas uniforme; si en el futuro hay reglas de negocio (calcular impuestos, validar crédito), van aquí."

### Repository (`repository/venta_repository.go`)

Aquí está la lógica real:

- **Insert:** Usa una **transacción SQL**. Por cada item: `INSERT INTO registro_ventas (id_producto, precio_producto, cantidad, id_vendedor)` + `UPDATE productos SET stock = stock - $1 WHERE id=$2 AND stock >= $1`. Si stock insuficiente, el UPDATE no afecta filas y se hace rollback.
- **GetAll:** `SELECT ... FROM registro_ventas LEFT JOIN productos ON ... ORDER BY fecha DESC LIMIT 100`

### Models usados (`models/models.go`)

```go
VentaItemReq   { ProductoID, Cantidad, PrecioUnitario }
VentaRequest   { Items []VentaItemReq }
VentaItem      { IDVenta, ProductoID, ProductoNombre, PrecioProducto, Cantidad, FechaVenta, IDVendedor }
VentaResponse  { Status, ID }
```

---

## Tu Feature: Frontend POS

### VentasPage.vue — ruta `/ventas`

```javascript
mounted() → cargarProductos()
  → productosService.buscarProductos({q, limit:20, offset, orden:'nombre'})
  → pinta grid de cards con imagen, precio, stock
  → click en card → agregarAlCarrito(p) → push a this.carrito
  → CarritoCompras componente maneja cantidades y confirma venta
```

Layout: panel izquierdo (grid productos) + panel derecho (CarritoCompras, 400px). Responsive: 1 columna en < 900px.

### CarritoCompras.vue

Props: `items`. Botón "Confirmar Venta" → `ventasService.registrarVenta(items)` → emite `venta-completada`.

### ventasService.js

```javascript
registrarVenta(items) → fetch POST /api/ventas con Bearer token
getVentas()           → fetch GET /api/ventas con Bearer token
```

Lee token de `localStorage`. Usa `API_BASE` desde `config/api.js`.

### Dependencias

**NO tiene axios.** Usa `fetch()` nativo. **NO** hay auth guards en router — cualquiera puede navegar a `/ventas`.

---

## Keywords para la exposición

| Pregunta del profe | Respuesta |
|---|---|
| ¿Dónde se valida que los items tengan cantidad > 0? | En el handler `venta_handler.go:34-45` |
| ¿Dónde se descuenta el stock al vender? | En el repository `venta_repository.go`, dentro de la transacción SQL |
| ¿El service hace algo o solo pasa datos? | En ventas es passthrough — la lógica está en el repository (SQL transaccional) |
| ¿Cómo llega la petición del frontend al backend? | `VentasPage.vue` → `ventasService.js` → `fetch POST /api/ventas` → nginx → `routes.go` → middleware → handler |

---

## Post-Revert: qué cambió

- Se eliminaron NavBar/SideBar/KanbanBoard/AnalisePage/InventarioPage del STL-redesign
- Tu POS quedó intacto
- LoginPage ahora guarda token en localStorage (antes no)
- Las rutas protegidas ahora usan `AuthMiddleware` via subrouter
