---
aliases: [tl2edit-plan-v2, tl2edit-auditoria]
tags: [project, plan, comics, translation, ocr, audit]
created: 2026-07-23
updated: 2026-07-23 (sesión completa: 14 PRs, fases 1-2.3 + features extras)
status: activo
related: [[tl2edit-blueprint]], [[plan-lanzamiento-google]]
---

# TL2EDIT — Plan v2 (Auditoría 2026-07-23)

## Resumen Ejecutivo

Auditoría completa del proyecto TL2EDIT. Cubre: estado actual, comparativa con competidores, problemas de ingeniería, UX/UI, estándares de la industria, monetización, y qué falta para producto público.

**Repo**: [JebsApple/TL2EDIT](https://github.com/JebsApple/TL2EDIT) → **PRIVADO**
**Copia local**: `~/proyectos/TL2EDIT`
**Stack**: React 19 + Vite + Tailwind v4 + Express + TypeScript
**Estado**: 220+ commits, 2 semanas activo, 56+ PRs (14 creados hoy)
**Equipo**: JebsApple (desarrollador), LaManzana, Rodrinario
**Audiencia**: Uso personal + equipos scanlation → aspiración a estándar

---

## Fase 1: Cimientos (Sin esto nada funciona)

### 1.1 ~~Refactorizar `useComicEditor`~~ ✅ COMPLETADO (2026-07-23)

**Resultado**: `useComicEditor.ts`: 1011 → ~115 líneas. 5 hooks + 2 archivos utilitarios.

| Hook | Responsabilidad | Líneas |
|---|---|---|
| `usePages` | Estado de páginas, tabs, reorder, close, sort, sectioning | ~118 |
| `useDetection` | Detección de bocadillos (local + API) | ~198 |
| `useOCR` | OCR + traducción de bloques | ~342 |
| `useBlocks` | CRUD de bloques, tipos, agrupación, reorder | ~150 |
| `useExport` | PSD/DOCX/ZIP export, Google Drive | ~150 |

**Utilitarios**: `lib/editorHelpers.ts` (ApiError, mapServerBlock, emptyBlockAt), `lib/pageHelpers.ts` (extractTrailingNumber, sortPagesByName, baseFileName).

**Rama**: `refactor/split-hooks` mergeada a `main` (commit `4b9b2ac`). 149 tests pasan, 0 regresiones.

**Nota**: Los nombres difieren del plan original porque el refactoring real siguió las dependencias naturales del código, no las estimaciones previas.

### 1.2 ~~Arreglar errores TypeScript activos~~ ✅ COMPLETADO (2026-07-23)

- **Rama**: `fix/typescript-errors` → PR #49
- **Resultado**: TypeScript compila limpio (errores pre-existentes resueltos por split-hooks)
- **Tests agregados**: 6 unit tests para `localDetector.decodeBlocks` (reemplazó test vacío)
- **Verificación**: 177 tests pasan, 0 fallos

### 1.3 ~~Mover archivos binarios del repo~~ ✅ COMPLETADO (ya resuelto)

- `eng.traineddata` (5MB) y `kor.traineddata` (2MB) ya están en `.gitignore` (`*.traineddata`)
- Nunca fueron committeados al repo. No hay acción necesaria.

---

## Fase 2: Features Críticas (Sin esto no hay producto profesional)

### 2.1 ~~Undo/Redo~~ ✅ COMPLETADO (2026-07-23)

- **Rama**: `feat/undo-redo` → PR #50
- **Implementación**: hook `useUndoRedo.ts` — snapshot-based (max 50 pasos)
- **Cobertura**: todas las mutaciones (updatePage, setPages, reorderPage, sortPages, closePage, addPageFromData, handleFiles)
- **Atajos**: `Ctrl+Z` / `Ctrl+Shift+Z` / `Ctrl+Y`
- **UI**: botones en barra de estado junto al zoom
- **Verificación**: TypeScript compila, 177 tests pasan

### 2.2 Redraw IA (el feature #1 que falta)

**El problema**: Todos los competidores serios (Koharu, KomaKun, manga-image-translator, PSImera) tienen limpieza de texto. TL2EDIT exporta PSD editable pero no limpia el texto original. Para uso profesional, el usuario tiene que ir a Photoshop a borrar manualmente.

**Enfoque**: NO inpainting genérico. **Redraw asistido por IA** — el usuario marca un recuadro, y Gemini redibuja la región sin texto, preservando el arte original.

**Implementación**:
- Modo "redraw" activado por botón en el canvas
- El usuario selecciona el recuadro a limpiar
- Se envía la imagen recortada + prompt especial a Gemini Vision
- Gemini genera la versión sin texto
- Preview antes de aplicar
- Toggle por bloque (no todas las páginas necesitan limpieza)
- Export PSD incluye la capa "redrawn" separada

**Prompt para Gemini** (ejemplo):
```
Remove all text from this speech bubble image while preserving the original 
art style, colors, lines and background. Fill the text area with content 
that matches the surrounding artwork. Do not add new elements.
```

**Limitaciones conocidas**:
- Gemini puede cambiar el arte sutilmente (colores, líneas)
- No funciona bien con texto sobre arte complejo
- Calidad variable según el modelo usado

**Fallback**: Si Gemini falla o el usuario no tiene key, ofrecer borrado manual con herramienta de recorte de color de fondo.

**Ramas**: `feature/redraw-ai`

### 2.3 ~~Purgar proveedores que no funcionan~~ ✅ COMPLETADO (2026-07-23)

- **Rama**: `chore/purge-providers` → PR #51
- **Eliminados**: Google Translate (`client=gtx` no oficial), MyMemory, Lingva, Tesseract
- **Mantenidos**: Gemini, OpenRouter, DeepL, LibreTranslate (traducción); Detector local, Gemini, OpenRouter (OCR)
- **Default**: traducción cambió de `google` a `libretranslate`
- **Archivos eliminados**: `google.ts`, `mymemory.ts`, `lingva.ts`, `tesseract.ts` + tests
- **Líneas eliminadas**: -728
- **Fallback chain**: Gemini → OpenRouter → LibreTranslate
- **Verificación**: TypeScript compila, 161 tests pasan

### 2.4 ~~Reemplazar Google Translate no oficial~~ ✅ COMPLETADO (incluido en 2.3)

Eliminado completamente. LibreTranslate es el fallback gratis.

### 2.5 ~~Bloques NT inmunes a IA~~ ✅ COMPLETADO (2026-07-23)

- **Rama**: `feat/nt-immune` → PR #52
- Bloques con `blockType === 'nota'` saltan OCR, traducción y retranslate
- UI oculta botones de traducir/OCR para bloques NT
- **Verificación**: 171 tests pasan

### 2.6 ~~Fix nav 100dvh~~ ✅ COMPLETADO (2026-07-23, en PR #52)

- Nav se ocultaba detrás de la barra del navegador en móvil
- Fix: `100vh` → `100dvh` en App.tsx y ErrorBoundary.tsx

### 2.7 ~~Fix sesión local~~ ✅ COMPLETADO (2026-07-23)

- **Rama**: `fix/session-local-restore` → PR #53
- `savePageImages()` guardaba base64 vacío para páginas de Drive
- Fix: siempre guardar base64 en IndexedDB sin importar origen
- **Segundo fix** (en PR #55): eliminado check `existingKeys` que impedía actualizar entradas viejas

### 2.8 ~~Toasts fijos + Auto-save Drive~~ ✅ COMPLETADO (2026-07-23)

- **Rama**: `fix/notice-toast` → PR #55
- `globalNotice` y `globalError` convertidos de flex items a toasts fijos (position: fixed)
- Auto-dismiss: notice 4s, error 6s. Botón de cerrar manual.
- **Auto-save Drive**: `GoogleDriveControls.tsx` reescrito con auto-save cada 2s (debounce)
- Toggle `[()]` "Auto" en nav con CSS custom (`.toggle`, `.toggle-track`)
- Indicador visual: pulso morrado + "Guardando..."

### 2.9 ~~Adjuntar imagen a bloques NT~~ ✅ COMPLETADO (2026-07-23)

- **Rama**: `feat/nt-attach-image` → PR #54
- Nuevo campo `attachedImage?: string` en `TextBlock`
- Componente `CropDialog.tsx` con Cropper.js v1.6.2 (recorte libre)
- Botón "Adjuntar imagen" en sidebar para bloques NT seleccionados
- Thumbnail con botón de eliminar cuando imagen existe
- Export: imagen debajo del texto en PSD, ImageRun en DOCX

### 2.10 ~~Exportar a Google Docs~~ ✅ COMPLETADO (2026-07-23)

- **Rama**: `feat/nt-image-export` → PR #56
- `convertToGoogleDoc()` en `googleDrive.ts` (upload DOCX con convert:true)
- Botón "Google Docs" en menú de export DOCX (solo con Drive conectado)
- `DriveFolderPicker` para elegir destino en Drive
- Export modal con modo `gdocs`

### 2.11 ~~Capa de imagen (bloque imagen)~~ ✅ COMPLETADO (2026-07-23)

- **Rama**: `feat/image-layer` → PR #57
- Nuevo tipo de bloque `imagen` con `defaultPrefix: '[IMG]'`
- Botón "Insertar imagen" en sidebar (siempre visible)
- Recorte con CropDialog antes de insertar
- PSD: capa de imagen escalada al boundingBox
- DOCX: ImageRun inline con Uint8Array (fix de Buffer que no funciona en browser)
- Bloques imagen inmunes a IA (misma lógica que NT)

---

## Fase 3: UX Mejorada

### 3.1 Loading skeletons

- Reemplazar spinner genérico por skeletons por tipo de bloque
- Progress real con ETA basado en velocidad anterior
- Feedback visual durante OCR/translate

### 3.2 Bulk translate mejorado

- Botón "Traducir todas las páginas" (ya existe parcialmente)
- OCR + translate en un solo llamado (factible, el backend ya soporta)
- Progress global con cola de procesamiento
- Concurrencia configurable (1-3 páginas simultáneas)

### 3.3 Responsive básico

- Breakpoint mobile (768px)
- Sidebar colapsable
- Touch gestures para zoom/pan
- Bottom sheet en mobile para acciones principales

### 3.4 Atajos de teclado documentados

- Panel de ayuda con todos los atajos
- `?` abre el panel
- Atajos contextuales (modo edición vs modo selección)

---

## Fase 4: Calidad y Mantenibilidad

### 4.1 Error handling robusto

- Toast notifications (no alerts)
- Retry automático con backoff exponencial
- Error boundary por sección (no crash completo)
- Logging centralizado ( Sentry free tier o similar)

### 4.2 Tests críticos

- Unit tests para cada hook nuevo
- Integration tests para export PSD/DOCX
- E2E test para flujo completo (upload → detect → translate → export)
- Fix `localDetector.test.ts` (evaluar si el test roto es por cambio incompleto)

### 4.3 Rate limiting

- Middleware Express con `express-rate-limit`
- Límites por endpoint (OCR: 10/min, translate: 30/min)
- Headers `Retry-After` cuando se excede
- BYOK mitigador, pero rate limiting protege contra abuso

### 4.4 Tests de calidad de proveedores OpenRouter

**El problema**: Modelos OCR de OpenRouter son inconsistentes — algunos no son vision models y devuelven bloques vacíos.

**Implementación**:
- Suite de tests que verifica calidad OCR por modelo
- Dataset de prueba: 5 imágenes con texto conocido
- Métricas: detección de bloques, accuracy de transcripción, tiempo de respuesta
- Run automático en CI (no blocking, solo reporte)
- Filter automático: solo modelos que pasen el threshold se muestran en UI
- Re-ejecución periódica (semanal) para detectar modelos que cambian

**Ramas**: `test/provider-quality`

---

## Fase 5: Preparación para Público

### 5.1 i18n mínimo

- Inglés + español como base
- Usar `react-i18next` (ligero, maduro)
-archivos de traducción en `src/i18n/`
- Detección automática de idioma del navegador
- Scalable a más idiomas después

### 5.2 Landing page

- Página estática (no necesita backend)
- Features, screenshots, link a GitHub, link a la app
- Deploy en GitHub Pages (ya configurado)
- Prerender para SEO (ver `plan-lanzamiento-google.md`)

### 5.3 Changelog

- ARCHIVO `CHANGELOG.md` actualizado con cada release
- Formato Keep a Changelog
- Tags semánticos en git (v1.0.0, v1.1.0, etc.)

### 5.5 Deploy

- **Actual**: Render free tier (512MB RAM). Sin problemas reportados con pocos usuarios.
- **Plan**: Mantener Render free tier por ahora. Evaluar si hay problemas con más carga.
- **Alternativa gratis**: Railway ($5 crédito mensual), Fly.io (free tier), Vercel (serverless).
- **Auto-deploy**: GitHub Actions → Render (ya configurado)

### 5.4 Legal / ToS

- Página de privacidad/ToS
- Aclarar que API keys no se almacenan server-side
- Disclaimer: "Herramienta de traducción. El usuario es responsable del uso del contenido traducido."
- Esto mitiga el riesgo legal de traducción no autorizada
- **Decisión del repo**: Pasar a privado. No hay contribuciones externas que motivar.

---

## Fase 6: Nice-to-Have (Saltados)

### 6.1 Contexto跨页

- El LLM ve páginas anteriores para mantener personajes/tono
- PSImera ya lo hace con `LLM_CONTEXT_PAGES`
- Prioridad: media (diferenciador real)

### 6.2 MCP Server

- Koharu lo tiene. TL2EDIT podría tenerlo para automatización.
- Prioridad: baja (los usuarios manuales no lo necesitan)

### 6.3 Analytics

- Umami (self-hosted, gratis) o Plausible
- Trackear: páginas traducidas, proveedores usados, errores
- Prioridad: baja (sin users, no hay qué trackear)

### 6.4 Docker

- `Dockerfile` + `docker-compose.yml`
- Para self-hosting
- Prioridad: baja (Render free tier funciona por ahora)

### 6.5 OpenAPI/Swagger

- Documentación automática del backend
- Prioridad: baja (los usuarios no consumen la API directamente)

### 6.6 Redraw IA (última prioridad)

- Requiere paint/clean similar a Photoshop
- Gemini redraw con prompt especial
- Preview antes de aplicar
- Fallback manual
- Prioridad: muy baja (nice to have, no esencial)

---

## Estado del PR #35 (refactor)

Descartado. La rama `refactor/app-hook-and-batch-errors` fue mergeada como PR #19. Los bugs ya están en main. Rama stale, sin merge.

---

## Ramas a crear

| Rama | Fase | Estado | PR |
|---|---|---|---|
| ~~`refactor/split-hooks`~~ | 1.1 | ✅ Mergeada | — |
| ~~`fix/google-drive-session`~~ | Bugfix | ✅ Mergeada | #47 |
| ~~`feat/psd-text-folder`~~ | Feature | ✅ Mergeada | #48 |
| ~~`fix/typescript-errors`~~ | 1.2 | ✅ Mergeada | #49 |
| ~~`feat/undo-redo`~~ | 2.1 | ✅ Mergeada | #50 |
| ~~`chore/purge-providers`~~ | 2.3 | ✅ Mergeada | #51 |
| ~~`feat/nt-immune`~~ | 2.5 | ✅ Mergeada | #52 |
| ~~`fix/session-local-restore`~~ | 2.7 | ✅ Mergeada | #53 |
| ~~`feat/nt-attach-image`~~ | 2.9 | ✅ Mergeada | #54 |
| ~~`fix/notice-toast`~~ | 2.8 | ✅ Mergeada | #55 |
| ~~`feat/nt-image-export`~~ | 2.10 | ✅ Mergeada | #56 |
| ~~`feat/image-layer`~~ | 2.11 | ✅ Rebased, mergeable | #57 |
| `feature/redraw-ai` | 2.2 | Pendiente | — |
| `feature/loading-skeletons` | 3.1 | Pendiente | — |
| `feature/bulk-translate` | 3.2 | Pendiente | — |
| `feature/responsive` | 3.3 | Pendiente | — |
| `fix/error-handling` | 4.1 | Pendiente | — |
| `test/critical-paths` | 4.2 | Pendiente | — |
| `test/provider-quality` | 4.4 | Pendiente | — |
| `chore/rate-limiting` | 4.3 | Pendiente | — |
| `feature/i18n` | 5.1 | Pendiente | — |
| `docs/landing-page` | 5.2 | Pendiente | — |
| `docs/changelog` | 5.3 | Pendiente | — |
| `legal/tos` | 5.4 | Pendiente | — |

---

## Orden de ejecución

### Semana 1 (2026-07-23) — COMPLETADA

Todas las tareas de la semana completadas en una sola sesión de hyperfocus:

- ~~Fase 1.1: `refactor/split-hooks`~~ ✅ PR merged
- ~~Fase 1.2: `fix/typescript-errors`~~ ✅ PR #49
- ~~Fase 1.3: mover binarios~~ ✅ Ya resuelto (gitignored)
- ~~Fase 2.1: `feat/undo-redo`~~ ✅ PR #50
- ~~Fase 2.3: `chore/purge-providers`~~ ✅ PR #51
- ~~Fase 2.5: `feat/nt-immune`~~ ✅ PR #52
- ~~Fase 2.7: `fix/session-local-restore`~~ ✅ PR #53
- ~~Fase 2.8: `fix/notice-toast`~~ ✅ PR #55
- ~~Fase 2.9: `feat/nt-attach-image`~~ ✅ PR #54
- ~~Fase 2.10: `feat/nt-image-export`~~ ✅ PR #56
- ~~Fase 2.11: `feat/image-layer`~~ ✅ PR #57

### Semana 2 — Pendiente

- Fase 2.2: `feature/redraw-ai` (Redraw IA)
- Fase 4.1: `fix/error-handling`
- Fase 4.3: `chore/rate-limiting`

### Semana 3 — Pendiente

- Fase 3.1: `feature/loading-skeletons`
- Fase 3.2: `feature/bulk-translate`
- Fase 3.3: `feature/responsive`
- Fase 4.2: `test/critical-paths`

### Semana 4 — Pendiente

- Fase 5.1: `feature/i18n`
- Fase 5.2: `docs/landing-page`
- Fase 5.3: `docs/changelog`
- Fase 5.4: `legal/tos`

---

## Riesgos identificados

| Riesgo | Probabilidad | Impacto | Mitigación |
|---|---|---|---|
| `useComicEditor` rompe durante refactor | Alta | Crítico | Tests antes de cada extracción |
| Google bloquea API no oficial | ~~Media~~ | ~~Alto~~ | ✅ Eliminado (PR #51) |
| Legal: traducción no autorizada | Media | Alto | ToS + disclaimer (largoplazo) |
| Render free tier: 512MB RAM insuficiente | Baja | Medio | Monitorear, upgrade si es necesario |
| OpenRouter modelos inconsistentes | Alta | Bajo | Tests de calidad, filtro automático |
| Repo privado: sin community | Baja | Bajo | Asumido, no es prioridad |

---

## Referencias

- [[tl2edit-blueprint]] — Plan original del proyecto
- [[plan-lanzamiento-google]] — Plan SEO/landing
- Auditoría completa: 2026-07-23 (esta sesión)
- Competidores analizados: Koharu, KomaKun, manga-image-translator, PSImera, OCR-Cleaner, AutoScanlate-AI, FrankYomik

---

## Changelog

### 2026-07-23 — Split-hooks completado
- **Rama**: `refactor/split-hooks` → mergeada a `main` (commit `4b9b2ac`)
- **Resultado**: `useComicEditor.ts` de 1011 → ~115 líneas
- **Hooks creados**: usePages, useDetection, useOCR, useBlocks, useExport
- **Utilitarios**: editorHelpers.ts, pageHelpers.ts
- **Tests**: 149 pasan, 0 regresiones

### 2026-07-23 — Google Drive session fix (PR #47)
- `savePageImages()` duplicaba base64 en IndexedDB para páginas con `driveFileId`
- Fix: omitir base64 cuando existe `driveFileId`, hidratar al restaurar

### 2026-07-23 — Capas de texto en carpeta PSD (PR #48)
- Todas las capas de texto van dentro de carpeta `📁 Capas de Texto` en PSD/PSB

### 2026-07-23 — TypeScript errors + tests (PR #49)
- 6 unit tests para `localDetector.decodeBlocks` (reemplazó test vacío)
- TypeScript compila limpio

### 2026-07-23 — Undo/Redo (PR #50)
- Hook `useUndoRedo.ts` — snapshot-based (max 50 pasos)
- `Ctrl+Z` / `Ctrl+Shift+Z` / `Ctrl+Y` + botones en UI

### 2026-07-23 — Purgar proveedores (PR #51)
- Eliminados: Google Translate, MyMemory, Lingva, Tesseract (-728 líneas)
- Default traducción: `google` → `libretranslate`

### 2026-07-23 — NT immune + nav fix (PR #52)
- Bloques NT inmunes a OCR/traducción
- Nav fix: `100vh` → `100dvh`

### 2026-07-23 — Session local restore fix (PR #53)
- Siempre guardar base64 en IndexedDB sin importar origen Drive

### 2026-07-23 — NT image attach (PR #54)
- Campo `attachedImage` en TextBlock + CropDialog con Cropper.js
- Botón "Adjuntar imagen" en sidebar para bloques NT

### 2026-07-23 — Toasts + auto-save Drive (PR #55)
- Notices convertidos a toasts fijos (no empujan el nav)
- Auto-save a Drive cada 2s con toggle "Auto" en nav

### 2026-07-23 — NT image export + Google Docs (PR #56)
- PSD: imagen debajo del texto escalada al boundingBox
- DOCX: ImageRun con Uint8Array (fix Buffer en browser)
- Nuevo: exportar a Google Docs (convert:true via Drive API)

### 2026-07-23 — Image layer + Google Docs folder picker (PR #57)
- Nuevo tipo de bloque `imagen` con `[IMG]` prefix
- Botón "Insertar imagen" en sidebar
- Google Docs: DriveFolderPicker para elegir destino
- Rebased sobre main, conflictos resueltos, mergeable

---

## Siguiente paso

Merge PR #57 → Fase 2.2 (Redraw IA) o Fase 3.1 (Loading skeletons) según prioridad del usuario.
