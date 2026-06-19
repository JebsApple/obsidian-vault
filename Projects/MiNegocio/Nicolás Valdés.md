---
tags: [proyecto/minegocio, integrante, nicolas, backend, inventario, database]
---

# Nicolás Valdés — Inventario API + Database Build

## Responsabilidad

Endpoints de inventario (backend Go), vista de inventario en base de datos, y proceso de entrega de artefactos del proyecto.

## Arquitectura (flujo inventario)

```
Vue.js (InventarioPage.vue)
  → GET /api/inventario
    → Nginx → localhost:3000
      → routes.go → inventario_handler.GetInventario
        → inventario_service.GetAll (delega directo al repo)
          → inventario_repository.GetAll
            → SELECT ... FROM inventario_view WHERE activo = true
              → PostgreSQL ejecuta la VIEW (CASE WHEN stock...)
```

## Archivos a su cargo

### `handler/inventario_handler.go`

**Línea por línea:**

1. `type InventarioHandler struct` — struct con referencia a `InventarioService`.
2. `NewInventarioHandler(is)` — constructor (inyección de dependencias).
3. `GetInventario(w, r)`:
   - Setea Content-Type: application/json
   - Llama `h.inventarioService.GetAll()` → lista de productos con stock y estado
   - Si error → 500 con mensaje JSON
   - Si ok → `json.NewEncoder(w).Encode(lista)`
4. `PatchStock(w, r)`:
   - Extrae `{id}` de la URL con `mux.Vars(r)`
   - Decodifica `ActualizarStockReq{Stock}` del body
   - Valida stock >= 0
   - Llama `inventarioService.UpdateStock(id, req.Stock)`
   - Responde con `{status:"ok", mensaje:"Stock actualizado"}`

### `service/inventario_service.go`

Capa de servicio que delega directamente al repositorio. `GetAll()` → `repo.GetAll()`, `UpdateStock()` → `repo.UpdateStock()`. Capa delgada que existe para mantener la arquitectura en capas uniforme, aunque actualmente no añade lógica de negocio extra.

### `repository/inventario_repository.go`

**Línea por línea:**

1. `GetAll()`:
   - Query: `SELECT v.id, v.nombre, v.stock, v.estado FROM inventario_view v INNER JOIN productos p ON v.id = p.id WHERE p.activo = true ORDER BY v.id ASC`
   - Usa la `inventario_view` (creada por Victor) que calcula el estado del stock
   - Filtra solo productos activos (soft delete)
   - Itera rows con `rows.Next()` escaneando cada fila a `InventarioProducto{ID, Nombre, Stock, Estado}`
   - Retorna slice de productos

2. `UpdateStock(id, stock)`:
   - `UPDATE productos SET stock = $1 WHERE id = $2 AND activo = true`
   - Actualiza stock de un producto específico

### `inventario_view.sql`

Script SQL que crea la vista `inventario_view` (compartido con Victor — colaboración). Ver [[Victor Herrera#inventario_view.sql]].

### Database build (`backup_server.sql`)

Scripts de carga inicial de la base de datos (`postgres/backup_server.sql`). Nicolás subió los archivos SQL iniciales al repositorio y creó el proceso de entrega de artefactos.

## Cómo explicar el flujo al exponer

> "Cuando el usuario entra a Inventario, el frontend llama `GET /api/inventario`. El backend recibe la petición en `routes.go` que la dirige al `InventarioHandler.GetInventario()`. Este handler pide los datos al `InventarioService`, que se los pide al `InventarioRepository`. El repositorio ejecuta `SELECT * FROM inventario_view WHERE activo = true`. La vista `inventario_view` calcula el estado (Normal/Bajo/Agotado) según el stock. Los resultados vuelven como JSON al frontend, que los muestra en una tabla con colores según el estado."

## Proceso de Entrega (Gitea)

Commit `7ccdc16 "🛠️ Proceso de Entrega y Carga de Artefactos (Gitea)"` en database. Nicolás creó el flujo de entrega: subir archivos SQL a Gitea para que el equipo pueda descargarlos y ejecutarlos en sus entornos locales.
