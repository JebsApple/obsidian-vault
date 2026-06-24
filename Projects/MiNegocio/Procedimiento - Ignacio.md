---
tags: [proyecto/minegocio, sprint-3, procedimiento, ignacio]
---

# Procedimiento — Ignacio

## S3-HU01-T05: Limpieza — parte Ignacio `[backend]` `[frontend]`
**Fechas:** 23 jun → 27 jun

1. En `src/services/ventasService.js`, eliminar método `getVenta(id)` (llama a endpoint que no existe en backend).
2. Eliminar `src/views/ContactoPage.vue` y `src/styles/contacto.css`.
3. En `service/venta_service.go`, eliminar campo `productRepo *repository.ProductoRepository` y su asignación en `NewVentaService` (nunca se usa).
4. Extraer `authHeaders()` duplicado: crear `src/utils/authHeaders.js` con la función y reemplazar en `productosService.js` y `ventasService.js`.

## S3-HU01-T06: Control de acceso — parte Ignacio `[backend]` `[frontend]` `[bugfix]`
**Fechas:** 27 jun → 2 jul

1. En `CarritoCompras.vue`, reemplazar `id_vendedor: 1` por `JSON.parse(localStorage.getItem('usuario')).id`.
2. No hardcodear — si no hay usuario en localStorage, mostrar error o redirigir a login.
3. Cuando Gabriel implemente `RequireRole`, verificar que `id_vendedor` en `venta_handler.go` coincida con el token.

## S3-HU01-T08: EndPoints documentados `[backend]`
**Fechas:** 5 jul → 8 jul

1. Listar todos los endpoints del backend desde `routes/routes.go`.
2. Por cada uno: método, ruta, parámetros (query/body/headers), ejemplo request, ejemplo response (200/400/401/404/500), si requiere JWT.
3. Incluir tabla de códigos de error del sistema.
4. Mapa de URLs: dev=`http://192.168.50.25:8080`, prod=`http://192.168.50.25:8000`, backend directo=`http://192.168.50.25:3001`.
5. Generar PDF con el documento.

## S3-HU03-T01: Endpoints de estadísticas de ventas `[backend]` `[database]`
**Fechas:** 23 jun → 28 jun

1. Crear `GET /api/ventas/stats`:
   - Consultar ventas del día: `SELECT COUNT(*), COALESCE(SUM(total),0) FROM registro_ventas WHERE DATE(fecha_venta) = CURRENT_DATE`.
   - Consultar ventas del mes: igual con `DATE_TRUNC('month', fecha_venta) = DATE_TRUNC('month', CURRENT_DATE)`.
   - Ticket promedio: `AVG(total)` del mes.
   - Producto más vendido: JOIN con venta_items, GROUP BY, ORDER BY SUM(cantidad) LIMIT 1.
2. Crear `GET /api/ventas/top-productos?limite=10&desde=&hasta=`:
   - JOIN registro_ventas → venta_items → productos.
   - Filtrar por rango de fechas, GROUP BY producto, ORDER BY total unidades DESC.
3. Crear `GET /api/ventas/tendencias?meses=12`:
   - `SELECT DATE_TRUNC('month', fecha_venta) as mes, COUNT(*) as cantidad, SUM(total) as total`.
   - Calcular variación % con LAG o en Go.
4. Todos requieren JWT. Manejar errores: 400 si faltan params, 401 si token inválido.

## S3-HU03-T02: SQL agrupación ventas por período `[backend]` `[database]`
**Fechas:** 28 jun → 2 jul

1. En `repository/venta_repository.go`, implementar consultas SQL:
   - `GetStats(dia, mes)` — stats del día y del mes actual.
   - `GetTopProductos(limite, desde, hasta)` — top productos con JOIN.
   - `GetTendencias(meses)` — ventas agrupadas por mes con variación.
2. Las consultas deben escanear a structs nuevas en `models/models.go`:
   - `VentaStats { VentasHoy, TotalHoy, VentasMes, TotalMes, TicketPromedio, ProductoTop }`.
   - `TopProducto { Nombre, CodigoBarras, TotalUnidades, TotalVenta, Porcentaje }`.
   - `TendenciaMes { Mes, Anio, TotalVentas, CantidadVentas, VariacionPorcentual }`.

## S3-HU03-T03: Componentes de gráficos frontend `[frontend]`
**Fechas:** 2 jul → 6 jul

1. `ResumenStats.vue` — 4 cards: ventas hoy, ventas mes, ticket promedio, producto top. Props: `{stats, loading, error}`.
2. `TopProductos.vue` — tabla con barras horizontales proporcionales al %. Props: `{productos, loading, error}`.
3. `TendenciaVentas.vue` — gráfico de línea SVG. Props: `{tendencias, loading, error}`.
4. Sin librerías externas. SVG inline para gráfico de línea. CSS grid/flexbox nativo.

## S3-HU03-T04: Página Dashboard Ventas `[frontend]`
**Fechas:** 6 jul → 8 jul

1. Crear `src/views/DashboardVentas.vue` con layout: ResumenStats (fila 4 cards), TendenciaVentas (ancho completo), TopProductos (tabla).
2. Selector de fechas (input date desde/hasta) que recarga los 3 endpoints.
3. Llamadas con fetch + auth headers + errores semánticos.
4. Estados: loading (skeleton/spinner), error (mensaje visible), empty ("sin datos en este período").
5. Ruta `/dashboard-ventas` con `meta.requiresAuth`.

---

## Referencias

- [[Sprint 3 - Plan de Trabajo]]
- [[Deuda Técnica]]
