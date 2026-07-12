---

kanban-plugin: board
tags:
  - kanban
  - sprint
created: 2026-07-11
sprint: "1"
status: pendiente

---

## Sprint 1 — Core Interaction



## Pendiente

- [ ] 📝 8D: Keyboard shortcuts → Haiku → `useKeyboardShortcuts.ts`
	  - D=draw, V=select, Del=delete, Ctrl+Z=undo, Ctrl+E=export, Esc=deselect, Tab=next
- [ ] 📝 9A: Magic bytes verification → Haiku → `App.tsx`
	  - Verificar primeros bytes del archivo antes de aceptarlo (no confiar en `file.type`)
	  - JPEG: `FF D8 FF`, PNG: `89 50 4E 47 0D 0A 1A 0A`
	  - Rechazar archivo con error claro si los magic bytes no coinciden con el MIME declarado
- [ ] 📝 9B: Auto-compresor de imágenes grandes → Sonnet → `App.tsx`, `types.ts`, `psdExport.ts`
	  - Umbral: imágenes > 10MB se comprimen automáticamente para la vista
	  - Usar canvas API para redimensionar (max 2000px en el eje mayor) + quality 0.8
	  - Guardar `base64Data` (comprimida para vista) y `originalBase64Data` (original para PSD)
	  - PSD export usa SIEMPRE `originalBase64Data` — la resolución original no se toca
	  - Mostrar badge indicativo: "Comprimida para vista" cuando aplique


## En Progreso



## Review



## Hecho ✅

- [x] 6A: Canvas interaction layer (draw boxes) → Sonnet → `ComicCanvasView.tsx` — pointer events, DrawnRegion export, Escape cancela, min-size guard
- [x] 6B: Backend OCR selectivo por regiones → Sonnet → `server.ts`, `server/providers/ocr/crop.ts` — dep nueva `sharp`, crop server-side para todos los providers, `POST /api/ocr-regions`
- [x] 6C: Flujo draw→detect→edit → Sonnet → `App.tsx` — toggle "Dibujar regiones", handleDetectRegions
- [x] Manijas de resize/move en canvas (no estaba en el plan original, salió de feedback directo) → Sonnet → `ComicCanvasView.tsx`, `src/lib/blockGeometry.ts` — esquinas/bordes/cuerpo, solo estado local, sin red. Reemplaza el toggle "Dibujar regiones" fijo: ahora lo activa "Nuevo" en la sidebar.
- [x] Fix bug alto-riesgo: recuadros se desalineaban de la imagen al resize de ventana → posicionamiento pasó de pixels (ResizeObserver+state) a % CSS puro
- [x] 7A: Inline editing en canvas (doble-click) → Sonnet → `ComicCanvasView.tsx` — textarea sobre el bloque, Enter guarda, Esc cancela, Tab siguiente bloque. Verificado con Playwright.
- [x] 7B: Flujo 100% offline → Sonnet → `App.tsx`, `SidebarTextBlocks.tsx` — dibujar → escribir a mano (sin red) → exportar PSD (client-side, ag-psd). "Detectar y traducir" es opcional/semi-automático, no bloquea el flujo manual. `ManualBlockCreator.tsx` (formulario de coords numéricas) se eliminó, unificado en el flujo de dibujo.
- [x] 8A: Layout responsive → Sonnet → `App.tsx` — **diverge del spec original** (3 columnas fijas pages-izq/canvas-centro/editor-der): quedó filmstrip horizontal arriba + canvas/editor 2 columnas (8/4), que es lo que se construyó y probó en toda la sesión. Header con flex-wrap, `<main>` fluido sin max-width fijo (antes dejaba márgenes muertos en monitores grandes), `min-w-0` en columnas del grid. No se rearmó a 3 columnas — si se quiere ese layout exacto hay que decidirlo como tarea nueva, no estaba bloqueando nada.
- [x] Suite de tests (Vitest) → Sonnet → `server/lib/errors.ts`, `src/lib/blockGeometry.ts` + `*.test.ts` — 38 tests sobre lógica pura (mapProviderError, crop/normalizeRegion, buildOcrPrompt, tesseract helpers, computeBlockDrag). `npm test` corre la suite.
- [x] Gate: tsc --noEmit ✅ + npm run build ✅ + npm test ✅ (38/38)


## Sprint 1 — Checklist de aceptación

- [x] Click+drag dibuja cajas en la imagen
- [x] OCR solo lee dentro de las cajas dibujadas
- [x] Doble-click edita bloque inline
- [x] App funciona 100% sin API keys (modo manual: dibujar → escribir a mano → exportar, cero llamadas de red)
- [x] Layout responsive en 1920px, 1366px, móvil — no es literalmente "3 paneles" (ver nota en Hecho), pero fluido y sin overflow
- [ ] Keyboard shortcuts funcionan
- [x] `npm run build` sin errores




%% kanban:settings
```
{"kanban-plugin":"board"}
```
%%