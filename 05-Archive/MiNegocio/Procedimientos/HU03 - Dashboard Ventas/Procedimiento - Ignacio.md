---
tags: [proyecto/minegocio, sprint-3, procedimiento, ignacio, hu03]
---

# Procedimiento — Ignacio — HU03: Dashboard Ventas

Tus tareas ordenadas por fecha de inicio. Empezá de arriba a abajo.

---

## 1. S3-HU03-T01: Endpoints de estadísticas de ventas `[backend]` `[database]`
**Fechas:** 23 jun → 28 jun

### ¿Qué estamos haciendo y por qué?

Vamos a crear la **API de estadísticas** para el dashboard de ventas. Tres endpoints que devuelven datos numéricos para mostrar como tarjetas y gráficos.

### Endpoints

#### `GET /api/ventas/stats`

Devuelve un resumen del día y del mes:
- Ventas hoy, total hoy, ventas del mes, total del mes, ticket promedio, producto más vendido
- Usá funciones de PostgreSQL: `CURRENT_DATE`, `DATE_TRUNC('month', ...)`, `COALESCE(SUM(...), 0)`
- El producto más vendido requiere JOIN con `venta_items`

#### `GET /api/ventas/top-productos?limite=10&desde=&hasta=`

Productos más vendidos en un rango de fechas:
- JOIN entre `registro_ventas`, `venta_items` y `productos`
- GROUP BY producto, ORDER BY total unidades DESC
- Parámetros: `limite` (default 10), `desde`, `hasta` (formato ISO)

#### `GET /api/ventas/tendencias?meses=12`

Ventas agrupadas por mes para ver evolución:
- `SELECT DATE_TRUNC('month', fecha_venta) as mes, COUNT(*) as cantidad, SUM(total) as total`
- Calculá la variación porcentual vs el mes anterior (con `LAG()` en SQL o en Go)

#### Consideraciones

- Los 3 endpoints requieren JWT
- Validá parámetros: si falta formato, respondé 400 con mensaje claro
- Si no hay datos, respondé con valores en cero, no con error

---

## 2. S3-HU03-T02: SQL agrupación ventas por período `[backend]` `[database]`
**Fechas:** 28 jun → 2 jul

### ¿Qué estamos haciendo y por qué?

Implementar las **consultas SQL** en el repositorio y definir las **estructuras de datos** (models) para los resultados. Es la capa que conecta la DB con el código Go.

### Pasos

1. En `repository/venta_repository.go`:
   - `GetStats()` — consultas de stats del día y del mes
   - `GetTopProductos(limite, desde, hasta)` — top productos con JOIN
   - `GetTendencias(meses)` — ventas por mes con variación

2. En `models/models.go`, crear structs:
   - `VentaStats { VentasHoy, TotalHoy, VentasMes, TotalMes, TicketPromedio, ProductoTop }`
   - `TopProducto { Nombre, CodigoBarras, TotalUnidades, TotalVenta, Porcentaje }`
   - `TendenciaMes { Mes, Anio, TotalVentas, CantidadVentas, VariacionPorcentual }`

---

## 3. S3-HU03-T03: Componentes de gráficos frontend `[frontend]`
**Fechas:** 2 jul → 6 jul

### ¿Qué estamos haciendo y por qué?

Crear 3 componentes visuales para el dashboard. Sin librerías externas — SVG y CSS puro.

### Componentes

#### `ResumenStats.vue`
4 tarjetas: ventas hoy, ventas mes, ticket promedio, producto más vendido.
Props: `{stats, loading, error}`.

#### `TopProductos.vue`
Tabla con barras horizontales proporcionales al % de cada producto.
Props: `{productos, loading, error}`.

#### `TendenciaVentas.vue`
Gráfico de línea SVG con eje Y (montos), eje X (meses) y polyline conectando puntos.
Props: `{tendencias, loading, error}`.

---

## 4. S3-HU03-T04: Página Dashboard Ventas `[frontend]`
**Fechas:** 6 jul → 8 jul

### ¿Qué estamos haciendo y por qué?

Unir los 3 componentes en una página con selectores de fecha para filtrar.

### Pasos

1. **Layout:** fila de `ResumenStats`, debajo `TendenciaVentas` a lo ancho, al final `TopProductos`.

2. **Selector de fechas:** dos `<input type="date">` (desde/hasta) que recarguen los 3 endpoints al cambiar.

3. **Estados:** loading (spinner o skeleton), error (mensaje visible en rojo), empty ("sin datos en este período").

4. **Ruta:** `/dashboard-ventas` con `meta: { requiresAuth: true }`.

5. **Llamadas API:** fetch nativo + auth headers + manejo de errores.
