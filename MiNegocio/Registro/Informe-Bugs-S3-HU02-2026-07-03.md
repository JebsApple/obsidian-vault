---
tags:
  - sprint3
  - bugs
  - frontend
updated: 2026-07-03
---

# Informe de bugs S3-HU02 — Auditoría 2026-07-03

Alcance: rama `S3-HU02` frontend completa (89 commits, 71 archivos vs main) + backend/db `S3-HU02-T15-iva-proveedores` (handlers ubicaciones, IVA, búsqueda). ESLint limpio; 93/93 tests verdes al cierre.

## Bugs encontrados y corregidos (hotfixes en Gitea, rama `S3-HU02`)

### 1. `6df1114` — Drop externo rompía el tablero 🔴
- **Síntoma:** arrastrar texto, un link o una imagen desde otra app/pestaña y soltarlo sobre una columna del Kanban lanzaba una excepción no manejada (`JSON.parse` sobre datos arbitrarios). Además, al arrastrar una card desde su imagen, el navegador podía iniciar el drag nativo de la imagen (URL en vez del producto).
- **Fix:** `handleDrop` ahora envuelve el parse en try/catch, valida que el payload sea un objeto con `id`, y la imagen de la card lleva `draggable="false"`.
- **Tests:** 2 regresiones nuevas (drop no-JSON no lanza; JSON sin `id` se ignora).

### 2. `dec1528` — Kanban no responsive en móvil/tablet 🟠
- **Síntoma:** el `grid-template-columns` inline (calculado en JS para la columna fantasma) anulaba los media queries de 1100px y 768px: eran CSS muerto. En móvil el tablero forzaba todas las columnas + la fantasma en una sola fila aplastada.
- **Fix:** el cálculo JS ahora se pasa como variable CSS (`--kanban-cols`) y la regla base hace `grid-template-columns: var(--kanban-cols)`; los media queries vuelven a ganar. En ≤768px las columnas se apilan (máx 320px de alto cada una, scroll propio); en ≤1100px van a 2 columnas.
- **Test:** regresión que verifica que `gridStyle` expone la variable y no el grid inline.
- Nota: este bug era **preexistente** al rediseño (el riel lateral tenía el mismo patrón), el rediseño lo heredó.

### 3. `1602bea` — Sidebar se reabría solo al hacer scroll en móvil 🟠
- **Síntoma:** `actualizarBreakpoint` forzaba el sidebar expandido en **cada** evento `resize` con pantalla "ancha". En móvil el scroll dispara `resize` (barra de URL de Chrome/Safari), así que el sidebar colapsado se reabría solo al scrollear. En desktop, cualquier resize deshacía el colapso manual.
- **Fix:** solo auto-expande al **cruzar** el umbral de angosto→ancho (flag `eraAncha`).
- **Tests:** 2 regresiones nuevas.

## Revisado y SIN problemas
- **Backend `PatchUbicacion`/`RenameUbicacion`**: validación de nombre (1-40), protege "Sin clasificar", rename transaccional con cascada a productos, conflicto 409 por UNIQUE. Correcto.
- **`/api/productos/buscar`**: `limit` con cap servidor en 100 (compatible con el modal nuevo), query parametrizada (sin inyección), COALESCE anti-fantasmas. Correcto.
- **IVA 19% (T15)**: neto = `round(venta/1.19)`, IVA = venta − neto; payload manda `precio_sin_iva` e `id_proveedor` como número o null. Correcto.
- **Ventas (escáner)**: limpieza sincrónica de la barra antes del await (anti-concatenación de lecturas), foco devuelto, stock validado. Correcto.
- **FormularioProducto `validarArchivo`**: valida 5MB y tipos JPG/PNG/WebP correctamente (falsa alarma inicial mía por lectura parcial).
- **App.vue / flag WIP / router**: listeners con cleanup, redirecciones prod correctas.

## Observaciones (no corregidas, a decidir)
1. **`vue.config.js` sin commitear**: alguien cambió el puerto del devServer de 8082 → **8080 en el working tree** (no lo commiteé porque no es mío). Ojo: 8080 **choca con el nginx de dev**. Si fue sin querer, revertir con `git checkout -- vue.config.js`.
2. **`npm run deploy-dev`** hace `cp -r dist/*` sin borrar bundles viejos: `/var/www/dev/frontend` acumula archivos hasheados obsoletos. Inofensivo, pero conviene migrarlo a `rsync --delete` como hace Jenkins.
3. **SideBar**: la prop `colapsado`, el emit `toggle-colapso` y el computed `colapsadoFinal` quedaron muertos tras integrar el header (App.vue ya no los usa). Limpieza cosmética pendiente.
4. **Umbrales de stock**: el borde de alerta de la card usa ≤4 (util compartido) y el badge usa ≤10 (según el plan de rediseño). Conviven a propósito, pero convendría unificar criterio a futuro.

## Estado final
- 93/93 tests, build prod y dev OK, desplegado a dev (nginx :8080).
- Hotfixes pusheados a `gitea/S3-HU02`. Nada tocó `main` ni se crearon ramas.
