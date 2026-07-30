<!-- fold(tema="tl2edit", lineas=262, leer_si="haciendo QA en TL2EDIT") -->
---
title: QA Report — feat/sets-de-series
created: 2026-07-27
updated: 2026-07-27
status: draft
tags:
  - tl2edit
  - qa
  - audit
  - feat/sets-de-series
related:
  - "[[plan-v2-auditoria]]"
  - "[[tl2edit-blueprint]]"
---

# QA Report — feat/sets-de-series

> Auditoría integral de la rama `feat/sets-de-series` del repo `TL2EDIT`.
> 86 commits, 94 archivos, +9,210 / -1,251 líneas.
> Branch point: 2026-07-27, HEAD: `0adf445`

---

## Resumen ejecutivo

| Severidad | Cantidad | Estado |
|-----------|----------|--------|
| Crítico | 0 | — |
| Alto | 2 | Pendiente |
| Medio | 5 | Pendiente |
| Bajo | 3 | Pendiente |
| Mejora | 3 | Opcional |

**Veredicto:** La rama es funcionalmente sólida. No hay bugs críticos que impidan merge. Hay 2 problemas altos que conviene resolver antes de merge y 5 medios que deberían resolverse pronto. El código generalmente sigue el estilo del proyecto y las decisiones de arquitectura son correctas. 566 tests (386 client + 180 server) pasando.

---

## Hallazgos por categoría

### A. Bugs funcionales

#### A1. 🔴 [ALTO] Depuración `tesseract.js` huérfana en `package.json`

- **Archivo:** `package.json` (dependencias), `server/stitchEngine.ts:22-23`, `server/stitch.ts:43-44`
- **Problema:** El provider tesseract fue eliminado (`server/tesseract.ts`, `tesseract.test.ts`) pero `tesseract.js@5.1.1` sigue como dependencia. Dos comentarios en stitchEngine.ts y stitch.ts lo mencionan pero no lo importan.
- **Impacto:** Dependencia innecesaria infla el bundle (~15MB), genera confusión sobre qué providers están activos, y puede causar problemas de seguridad si no se actualiza.
- **Fix:** `npm uninstall tesseract.js` + eliminar los dos comentarios referenciándolo.
- **Prioridad:** Alto — es limpieza obligatoria antes de merge.

#### A2. 🔴 [ALTO] `snapshotPages` comparte referencias de `boundingBox`

- **Archivo:** `useUndoRedo.ts:14`
- **Código:** `return pages.map(p => ({ ...p, blocks: p.blocks.map(b => ({ ...b })) }))`
- **Problema:** `boundingBox` es un objeto anidado dentro de cada block. La copia superficial (`{...b}`) significa que el `boundingBox` del snapshot comparte referencia con el block original. Si alguna operación muta `boundingBox` in-place (no las hay ahora, pero no está protegido), el undo/redo corrompería datos.
- **Impacto:** Bajo en la práctica actual (React patterns no mutan in-place), pero es una bomba de tiempo. Cualquier refactor futuro que asigne `block.boundingBox.x = ...` directamente corrompería snapshots anteriores.
- **Fix:** Copia profunda del `boundingBox` en el map: `{ ...b, boundingBox: b.boundingBox ? { ...b.boundingBox } : undefined }`
- **Prioridad:** Alto — previene corrupción silenciosa futura.

### B. UX y diseño

#### B1. 🟡 [MEDIO] StitchModal usa 31 inline styles mezclados con design system

- **Archivo:** `StitchModal.tsx` (365 líneas)
- **Problema:** Mezcla `className` (usa `dialog-backdrop`, `card`, `btn`) con 31 inline styles para layout. CropDialog (nuevo) usa solo 2 inline styles + CSS classes. StitchModal es inconsistente con el patrón del resto del proyecto.
- **Impacto:** Mantenibilidad — difícil de cambiar layout sin tocar JSX. No es un bug pero dificulta refactor futuro.
- **Fix:** Mover inline styles a CSS classes en un archivo dedicado o Tailwind. No urgente pero debería hacerse antes de que más componentes sigan el patrón incorrecto.
- **Prioridad:** Medio — mejora de consistencia.

#### B2. 🟡 [MEDIO] Sin indicador de progreso para batches de OCR

- **Archivo:** `useOcrWithProgress.ts`, `useOcrWithProgressUltra.ts`
- **Problema:** El OCR ahora procesa en chunks de 50 bloques con timeouts de 90s por batch. Pero el usuario solo ve "Procesando..." sin saber cuántos batches quedan ni cuánto falta.
- **Impacto:** Para escaneos grandes (200+ bloques), el usuario puede creer que la app colgó cuando en realidad está procesando el batch 2 de 4.
- **Fix:** Mostrar "Procesando lote 1/4..." o una barra de progreso simple.
- **Prioridad:** Medio — afecta percepción de estabilidad.

#### B3. 🟡 [MEDIO] Sin timeout global en pipeline de escaneo completo

- **Archivo:** `useOcrWithProgress.ts`, `useOcrWithProgressUltra.ts`
- **Problema:** Cada batch tiene timeout de 90s, pero no hay timeout global. Un escaneo con 10 batches podría tardar 15+ minutos si todos los batches están en el límite.
- **Impacto:** La app puede parecer colgada durante periodos largos sin forma de cancelar.
- **Fix:** Agregar un timeout global (ej: 5 minutos) o un botón de cancelación visible.
- **Prioridad:** Medio — previene sesiones largas sin feedback.

#### B4. 🟡 [MEDIO] Font catalog UI inconsistente con series sets

- **Archivo:** `FontLibraryPanel.tsx`, `SeriesSetsPanel.tsx`
- **Problema:** FontLibraryPanel muestra fonts del catálogo global pero no hay flujo claro para que el usuario asigne una font del catálogo a un series set específico. El link entre ambos panesles es confuso.
- **Impacto:** El usuario puede cargar fonts al catálogo pero no ver cómo aplicarlas a sus series.
- **Fix:** Agregar un botón "Usar en serie X" o un dropdown de series dentro de FontLibraryPanel.
- **Prioridad:** Medio — afecta usabilidad del feature principal.

#### B5. 🟡 [MEDIO] CropDialog no muestra proporción actual

- **Archivo:** `CropDialog.tsx`
- **Problema:** Al abrir CropDialog para una imagen de bloque, no se muestra la proporción actual del bbox ni la relación de aspecto de la imagen original. El usuario tiene que adivinar.
- **Impacto:** Harder to get precise crops, especially for stickers/memes where aspect ratio matters.
- **Fix:** Mostrar dimensiones originales y ratio actual en el header del dialog.
- **Prioridad:** Medio — mejora la experiencia de crop.

### C. Seguridad

#### C1. 🟢 [BAJO] `as any` cast en `exportDocx.ts`

- **Archivo:** `exportDocx.ts:71,95` (2 instancias)
- **Código:** `type: type as any` — `dataUrlToUint8Array` retorna `type: string` (ej: `"png"`) pero `ImageRun` espera un union type específico.
- **Problema:** Type assertion que oculta posibles errores de tipo. Funciona porque el string coincide con los valores válidos, pero no está validado en compile-time.
- **Impacto:** Si la librería docx cambia su API o el MIME mapping, el `as any` ocultaría el error.
- **Fix:** Tipar el retorno de `dataUrlToUint8Array` como `{ buffer: Uint8Array; type: "png" | "jpeg" | "gif" | "bmp" }` y validar el MIME antes de retornar.
- **Prioridad:** Bajo — funciona, pero es deuda técnica.

#### C2. 🟢 [BAJO] `console.warn` en server (~10 instancias)

- **Archivo:** `server/**/*.ts`
- **Problema:** ~10 `console.warn` en server/ para situaciones operacionales (fallback a libretranslate, errores de telemetry, auto-save failures, provider fallback). Solo 1 `console.log` en `server.ts:1485` (startup). No hay debug noise pero tampoco hay logging estructurado.
- **Impacto:** En producción, los warnings se pierden en logs sin estructura. No es un problema de seguridad pero dificulta debugging.
- **Fix:** Considerar logging estructurado (JSON) para producción. No urgente.
- **Prioridad:** Bajo — mejora observabilidad.

### D. Performance

#### D1. 🟡 [MEDIO] Undo/redo deep-copies el array completo de páginas

- **Archivo:** `useUndoRedo.ts`
- **Problema:** Cada snapshot copia todas las páginas y todos sus bloques. Con 50 páginas × 20 bloques = 1000 objetos por snapshot, 50 snapshots = 50,000 objetos en memoria.
- **Impacto:** Actualmente no es problema (las apps de scanlation típicamente tienen <50 páginas). Pero si alguien trabaja con series largas (100+ páginas), la memoria crece rápido.
- **Fix:** Podría usarse un estructura tipo immutable.js o tree-based para copias incrementales. No urgente.
- **Prioridad:** Medio — escala pero no actualmente.

#### D2. 🟢 [BAJO] IndexedDB keepStore sin compacción

- **Archivo:** `keepStore.ts`
- **Problema:** Las imágenes en la galería Keep se acumulan sin límite ni compacción. Cada imagen se almacena como blob completo.
- **Impacto:** Con uso extenso, IndexedDB puede crecer significativamente.
- **Fix:** Agregar un límite de imágenes o política de auto-limpieza (LRU).
- **Prioridad:** Bajo — edge case de uso prolongado.

### E. Mantenibilidad

#### E1. 🟢 [BAJO] `fontFile.test.ts` hardcodea paths relativos

- **Archivo:** `fontFile.test.ts`
- **Problema:** Usa `__fixtures__/fonts` generados por `generate-fonts.mjs`. Si los fixtures no se generan, los tests fallan con error confuso.
- **Impacto:** CI puede fallar si no se ejecuta el script de generación antes de los tests.
- **Fix:** Agregar un `beforeAll` que verifique que los fixtures existan, o generarlos automáticamente.
- **Prioridad:** Bajo — CI robustez.

#### E2. 🟠 [MEJORA] No hay documentación del feature de Series Sets

- **Archivo:** —
- **Problema:** El feature más grande de la rama (Series Sets + Font System) no tiene documentación de usuario ni de desarrollador.
- **Impacto:** Difícil para nuevos contribuidores entender el sistema, y para usuarios aprovechar todo el potencial.
- **Fix:** Agregar README o sección en el blueprint que explique: qué son los series sets, cómo configurarlos, cómo funciona el font system, y cómo extenderlo.
- **Prioridad:** Mejora — no bloquea merge pero sí adopción.

#### E3. 🟠 [MEJORA] No hay tests end-to-end para el flujo de stitching

- **Archivo:** `stitchEngine.ts`, `stitch.ts`
- **Problema:** Solo hay unit tests para las funciones puras. No hay test del flujo completo: Drive → download → extract → detect → stitch → upload.
- **Impacto:** Regresiones en el flujo completo pasarían desapercibidas.
- **Fix:** Agregar al menos un test de integración que mockee Drive y verifique el flujo E2E.
- **Prioridad:** Mejora — previene regresiones.

#### E4. 🟠 [MEJORA] No hay test para undo/redo con boundingBox compartido

- **Archivo:** `useUndoRedo.ts`, test existente
- **Problema:** El test de undo/redo verifica que el estado se restaura correctamente, pero no verifica que las referencias de `boundingBox` sean independientes.
- **Impacto:** No detectaría el bug potencial descrito en A2.
- **Fix:** Agregar test que muta un boundingBox después de un snapshot y verifica que el snapshot anterior no se afecta.
- **Prioridad:** Mejora — previene el bug de A2.

---

## Resumen de archivos revisados

| Archivo | Líneas | Veredicto |
|---------|--------|-----------|
| `seriesSets.ts` | ~400 | ✅ Limpio, sin problemas |
| `useSeriesSets.ts` | ~200 | ✅ Limpio |
| `SeriesSetsPanel.tsx` | ~500 | ✅ Completo, algo largo |
| `SeriesCharactersSection.tsx` | ~300 | ✅ Limpio |
| `SeriesContextSection.tsx` | ~200 | ✅ Limpio |
| `fontCatalog.ts` | ~300 | ✅ Limpio |
| `FontLibraryPanel.tsx` | ~350 | ⚠️ UX confusa con series sets |
| `fontFile.ts` | ~150 | ✅ Binary parsing correcto |
| `stitchEngine.ts` | ~300 | ✅ Puerto sólido del Python |
| `stitch.ts` | ~500 | ✅ Completo, comments menores |
| `StitchModal.tsx` | ~365 | ⚠️ Inline styles mixtos |
| `consent.ts` | ~100 | ✅ Limpio |
| `sanitize.ts` | ~200 | ✅ Exhaustivo |
| `client.ts` | ~150 | ✅ Limpio |
| `useUndoRedo.ts` | ~100 | ⚠️ BoundingBox shared ref |
| `useImageClipboard.ts` | ~200 | ✅ Limpio |
| `keepStore.ts` | ~150 | ✅ Limpio, sin límites |
| `imageBlockGeometry.ts` | ~100 | ✅ Correcto |
| `useBlockTypes.ts` | ~200 | ✅ Font resolution funciona |
| `convertToGoogleDoc.ts` | ~100 | ✅ Limpio |
| `exportDocx.ts` | ~200 | ⚠️ 2x `as any` en ImageRun type |
| `prompt.ts` (server) | ~300 | ✅ Series injection correcta |
| `server.ts` | ~800 | ✅ Endpoints bien integrados |
| `useOcrWithProgress.ts` | ~300 | ⚠️ Sin progreso visible |
| `useOcrWithProgressUltra.ts` | ~400 | ⚠️ Sin progreso visible |
| `CropDialog.tsx` | ~200 | ✅ Limpio, 2 inline styles |
| `ReportProblemDialog.tsx` | ~150 | ✅ Limpio |
| `telemetry/consent.test.ts` | ~88 | ✅ Exhaustivo |
| `telemetry/sanitize.test.ts` | ~223 | ✅ Exhaustivo |
| `seriesSets.test.ts` | ~157 | ✅ Exhaustivo |
| `fontCatalog.test.ts` | ~123 | ✅ Usa fixtures reales |
| `fontFile.test.ts` | ~74 | ⚠️ Depende de fixtures generados |
| `imageBlockGeometry.test.ts` | ~69 | ✅ Exhaustivo |
| `localDetector.test.ts` | ~68 | ✅ Correcto |
| `prompt.test.ts` | ~100 | ✅ Correcto, 1x `as any` |
| `ocr/prompt.test.ts` | ~150 | ✅ SFX guidance testada |
| `geminiFallback.test.ts` | ~80 | ✅ Correcto |
| `translateWithFallback.test.ts` | ~200 | ✅ Actualizado |
| `blockGeometry.test.ts` | ~100 | ✅ Precision testada |

---

## Checklist pre-merge

- [ ] Eliminar `tesseract.js` de `package.json` y comments referenciándolo
- [ ] Corregir `snapshotPages` para copiar `boundingBox` independientemente
- [ ] Agregar indicador de progreso para batches de OCR
- [ ] Revisar inline styles en StitchModal (al menos documentar la deuda)
- [ ] Verificar que todos los tests pasan sin warnings
- [ ] Probar flujo completo: series set → font assignment → render en canvas
- [ ] Probar undo/redo con operaciones de boundingBox
- [ ] Probar stitching end-to-end con Drive images

---

## Test coverage

| Área | Tests | Cobertura |
|------|-------|-----------|
| Series Sets | 157 líneas | ✅ Exhaustiva |
| Font Catalog | 123 líneas | ✅ Con fixtures reales |
| Font Parser | 74 líneas | ✅ Binario real |
| Telemetry consent | 88 líneas | ✅ Lifecycle completo |
| Telemetry sanitize | 223 líneas | ✅ Exhaustiva |
| Image block geometry | 69 líneas | ✅ Bbox + aspect ratio |
| OCR prompts | 150+ líneas | ✅ SFX + series |
| Gemini fallback | 80 líneas | ✅ Dynamic chain |
| Translate fallback | 200 líneas | ✅ Provider cleanup |
| Block geometry | 100 líneas | ✅ Precision |
| Undo/Redo | Exists | ⚠️ Sin test de ref sharing |
| Stitching | Unit only | ⚠️ Sin E2E test |

**Total: 566 tests, 30 archivos, todos pasando.**

---

## Conclusión

La rama `feat/sets-de-series` es un feature grande pero bien ejecutado. La arquitectura es correcta, los tests son sólidos, y no hay bugs críticos. Los 2 hallazgos altos (tesseract huérfana y boundingBox shared ref) son fáciles de arreglar. Los medios son mejoras de UX que no bloquean funcionamiento.

**Recomendación:** Merge con los 2 fixes altos. Los medios pueden resolverse en follow-up.

---

*Creado: 2026-07-27 | Última actualización: 2026-07-27 (verificación independiente)*
