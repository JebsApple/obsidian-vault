---
tags: [proyecto/minegocio, sprint-3, procedimiento, gabriel, hu03]
---

# Procedimiento — Gabriel — HU03: Dashboard Ventas

Tus tareas ordenadas por fecha de inicio. Empezá de arriba a abajo.

---

## 1. S3-HU03-T05: Reportes PDF y Excel descargables `[backend]` `[frontend]`
**Fechas:** 2 jul → 8 jul

### ¿Qué estamos haciendo y por qué?

Los usuarios necesitan **descargar reportes** de ventas para presentarlos, archivarlos o analizarlos fuera del sistema. Vamos a crear un endpoint que genere archivos PDF y Excel con los datos de ventas en un período.

### Pasos

1. **Crear el endpoint.** `GET /api/reportes/ventas?formato=pdf|xlsx&desde=2026-06-01&hasta=2026-06-23`. El parámetro `formato` define si devolvemos PDF o Excel.

2. **Consultar datos.** El handler debe:
   - Obtener las ventas del período desde la DB
   - Calcular totales (suma de montos, cantidad de ventas)
   - Obtener el top de productos vendidos

3. **Generar PDF.** La opción más simple: crear un HTML con una tabla bien formateada y convertirlo a PDF con `wkhtmltopdf` (debería estar instalado en el servidor). Si no está, buscá una librería Go que genere PDF.

4. **Generar Excel (XLSX).** Usá la librería `excelize` (agregala a `go.mod` con `go get`). Creá una hoja con columnas: Fecha, Producto, Cantidad, Precio Unitario, Total.

5. **Forzar descarga.** En la respuesta HTTP:
   - `Content-Type: application/pdf` o `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`
   - `Content-Disposition: attachment; filename="reporte-ventas-2026-06.pdf"`
   Así el navegador descarga el archivo en vez de mostrarlo.

6. **Botón en frontend.** En `VentasPage.vue`, agregá un botón "Descargar reporte" que llame al endpoint. Podés usar un `<a>` con el href apuntando al endpoint (con fechas y token en header).
