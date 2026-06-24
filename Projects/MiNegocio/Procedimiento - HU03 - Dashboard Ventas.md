---
tags: [proyecto/minegocio, sprint-3, procedimiento, hu03]
---

# Procedimiento — HU03: Dashboard Ventas

## S3-HU03-T01: Endpoints de estadísticas de ventas `[backend]` `[database]`
**Asignado:** Ignacio | **Fechas:** 23 jun → 28 jun

### ¿Qué estamos haciendo y por qué?

Vamos a crear la **API de estadísticas** para el dashboard de ventas. Tres endpoints que el frontend usará para mostrar tarjetas y gráficos.

### Endpoints

#### `GET /api/ventas/stats`

Devuelve un resumen numérico del día y del mes:
- Ventas hoy, total hoy, ventas del mes, total del mes, ticket promedio, producto más vendido
- Usa `CURRENT_DATE`, `DATE_TRUNC`, `COALESCE` en las consultas
- El producto más vendido requiere JOIN con `venta_items`

#### `GET /api/ventas/top-productos?limite=10&desde=&hasta=`

Productos más vendidos en un rango de fechas:
- JOIN `registro_ventas` → `venta_items` → `productos`
- GROUP BY producto, ORDER BY total unidades DESC
- Parámetros: `limite` (default 10), `desde`, `hasta`

#### `GET /api/ventas/tendencias?meses=12`

Ventas agrupadas por mes para ver evolución:
- `SELECT DATE_TRUNC('month', fecha_venta), COUNT(*), SUM(total)`
- Calcular variación porcentual vs mes anterior (con `LAG()` en SQL o en Go)

#### Consideraciones

- Los 3 endpoints requieren JWT
- Validar parámetros (responder 400 si faltan o son inválidos)
- Si no hay datos, devolver valores en cero, no error

---

## S3-HU03-T02: SQL agrupación ventas por período `[backend]` `[database]`
**Asignado:** Ignacio | **Fechas:** 28 jun → 2 jul

### ¿Qué estamos haciendo y por qué?

Implementar las **consultas SQL** en el repositorio y definir las **estructuras de datos** donde se guardan los resultados.

### Pasos

1. En `repository/venta_repository.go`:
   - `GetStats()` — stats del día y del mes
   - `GetTopProductos(limite, desde, hasta)` — top productos con JOIN
   - `GetTendencias(meses)` — ventas por mes con variación

2. En `models/models.go`, crear structs:
   - `VentaStats { VentasHoy, TotalHoy, VentasMes, TotalMes, TicketPromedio, ProductoTop }`
   - `TopProducto { Nombre, CodigoBarras, TotalUnidades, TotalVenta, Porcentaje }`
   - `TendenciaMes { Mes, Anio, TotalVentas, CantidadVentas, VariacionPorcentual }`

---

## S3-HU03-T03: Componentes de gráficos frontend `[frontend]`
**Asignado:** Ignacio | **Fechas:** 2 jul → 6 jul

### ¿Qué estamos haciendo y por qué?

Crear 3 componentes visuales para mostrar las estadísticas. Sin librerías externas — SVG y CSS puro.

### Componentes

#### `ResumenStats.vue`
4 cards: ventas hoy, ventas mes, ticket promedio, producto más vendido.
Props: `{stats, loading, error}`.

#### `TopProductos.vue`
Tabla con barras horizontales proporcionales al % de cada producto.
Props: `{productos, loading, error}`.

#### `TendenciaVentas.vue`
Gráfico de línea SVG con ejes X (meses) e Y (montos) y polyline conectando puntos.
Props: `{tendencias, loading, error}`.

---

## S3-HU03-T04: Página Dashboard Ventas `[frontend]`
**Asignado:** Ignacio | **Fechas:** 6 jul → 8 jul

### ¿Qué estamos haciendo y por qué?

Unir los 3 componentes en una sola página con selectores de fecha para filtrar.

### Pasos

1. Layout: fila de `ResumenStats`, debajo `TendenciaVentas` a lo ancho, al final `TopProductos`.

2. Selector desde/hasta (`<input type="date">`) que recarga los 3 endpoints.

3. Estados: loading (spinner/skeleton), error (mensaje visible), empty ("sin datos en este período").

4. Ruta `/dashboard-ventas` con `meta: { requiresAuth: true }`.

5. Llamadas con fetch nativo + auth headers.

---

## S3-HU03-T05: Reportes PDF y Excel descargables `[backend]` `[frontend]`
**Asignado:** Gabriel | **Fechas:** 2 jul → 8 jul

### ¿Qué estamos haciendo y por qué?

Los usuarios necesitan **descargar reportes** de ventas para presentarlos o analizarlos fuera del sistema. Endpoint que genera PDF y Excel.

### Pasos

1. Endpoint `GET /api/reportes/ventas?formato=pdf|xlsx&desde=&hasta=`.

2. Consultar ventas del período con totales y top productos.

3. **PDF:** generar HTML con tabla y convertir con `wkhtmltopdf` (ya instalado en servidor).

4. **XLSX:** usar librería `excelize` (agregar a go.mod). Columnas: fecha, producto, cantidad, total.

5. Response con `Content-Disposition: attachment` para forzar descarga.

6. Frontend: botón en `VentasPage.vue` que llame al endpoint.

---

## Referencias

- [[Sprint 3 - Plan de Trabajo]]
- [[Deuda Técnica]]
