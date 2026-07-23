---
aliases: [tl2edit-plan-v2, tl2edit-auditoria]
tags: [project, plan, comics, translation, ocr, audit]
created: 2026-07-23
updated: 2026-07-23 (split-hooks + Drive fix + PSD folder)
status: activo
related: [[tl2edit-blueprint]], [[plan-lanzamiento-google]]
---

# TL2EDIT — Plan v2 (Auditoría 2026-07-23)

## Resumen Ejecutivo

Auditoría completa del proyecto TL2EDIT. Cubre: estado actual, comparativa con competidores, problemas de ingeniería, UX/UI, estándares de la industria, monetización, y qué falta para producto público.

**Repo**: [JebsApple/TL2EDIT](https://github.com/JebsApple/TL2EDIT) → **PRIVADO**
**Copia local**: `~/proyectos/TL2EDIT`
**Stack**: React 19 + Vite + Tailwind v4 + Express + TypeScript
**Estado**: 209 commits, 2 semanas activo, 38 PRs mergeados
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

### 1.2 Arreglar errores TypeScript activos

- `src/hooks/useComicEditor.ts(223,79)`: Property 'window' does not exist on type 'DetectorProgress'
- `src/hooks/useComicEditor.ts(223,87)`: Property 'totalWindows' does not exist on type 'DetectorProgress'
- `src/lib/localDetector.test.ts`: test vacío (evaluar si es por cambio incompleto o feature abandonada)

### 1.3 Mover archivos binarios del repo

- `eng.traineddata` (5MB) → GitHub Releases
- `kor.traineddata` (2MB) → GitHub Releases
- Actualizar `localDetector.ts` para descargar on-demand con fallback

---

## Fase 2: Features Críticas (Sin esto no hay producto profesional)

### 2.1 Undo/Redo

**Por qué es crítico**: Sin esto, un error del usuario borra trabajo hecho. En cualquier editor de texto es básico.

**Implementación**:
- `useReducer` con history stack (máximo 50 pasos)
- Atajos: `Ctrl+Z` / `Ctrl+Shift+Z`
- Scope: texto, movimiento de bloques, tipos, delete, resize
- Botones visibles en toolbar
- Historial visible en panel lateral (opcional)

**Ramas**: `feature/undo-redo`

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

### 2.3 Purgar proveedores que no funcionan

**Estado actual de proveedores**:

| Proveedor | OCR | Traducción | Estado |
|---|---|---|---|
| Gemini | ✅ Funciona bien | ✅ Funciona bien | **MANTENER** |
| OpenRouter | ⚠️ Modelos inconsistentes | ✅ Funciona | **MANTENER** (filtrar modelos) |
| Tesseract | ❌ No detecta globos | ❌ No traduce | **ELIMINAR de OCR** |
| Local detector | ⚠️ Depende del modelo ONNX | ❌ No traduce | **MANTENER** (sin key) |
| Google Translate | ❌ API no oficial (`client=gtx`) | ⚠️ Puede bloquearse | **ELIMINAR** |
| LibreTranslate | ❌ | ⚠️ Calidad variable | **MANTENER** (sin key) |
| MyMemory | ❌ | ⚠️ Calidad baja | **ELIMINAR** |
| Lingva | ❌ | ⚠️ Inestable | **ELIMINAR** |
| DeepL | ❌ | ✅ Excelente | **MANTENER** (requiere key) |

**Plan de purga**:
1. Eliminar Google Translate, MyMemory, Lingva de `src/config/providers.ts`
2. Eliminar archivos: `server/providers/translation/google.ts`, `mymemory.ts`, `lingva.ts`
3. Eliminar Tesseract de OCR_PROVIDERS (mantener solo local detector + Gemini + OpenRouter)
4. Filtrar modelos OpenRouter: solo los que son vision models para OCR
5. Actualizar SettingsPanel para mostrar solo proveedores activos
6. Actualizar fallback chain: Gemini → OpenRouter → LibreTranslate

### 2.4 Reemplazar Google Translate no oficial

- Eliminar `client=gtx` de `server/providers/translation/google.ts`
- Usar `@vitalets/google-translate-api` (wrapper community, funciona)
- O simplemente eliminar Google Translate y usar LibreTranslate como fallback gratis

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

La rama `refactor/app-hook-and-batch-errors` fue **mergeada** como PR #19 (commit `2753d5e`). Los fixes de batch y error handling ya están en `main`. La rama se quedó atrás porque `main` continuó con features nuevas (rotación Canva-style, fixes de resize, etc.).

**Recomendación**: Descartar la rama. Los cambios útiles ya están en main. El refactor incremental (Fase 1.1) se hace sobre main directamente.

---

## Ramas a crear

| Rama | Fase | Dependencia |
|---|---|---|
| ~~`refactor/split-hooks`~~ ✅ | 1.1 | Ninguna |
| ~~`fix/google-drive-session`~~ ✅ | Bugfix | split-hooks |
| ~~`feat/psd-text-folder`~~ ✅ | Feature | Ninguna |
| `fix/typescript-errors` | 1.2 | Ninguna |
| `chore/move-binaries` | 1.3 | Ninguna |
| `feature/undo-redo` | 2.1 | 1.1 (necesita hooks separados) |
| `feature/redraw-ai` | 2.2 | Ninguna |
| `chore/purge-providers` | 2.3 | Ninguna |
| `feature/loading-skeletons` | 3.1 | Ninguna |
| `feature/bulk-translate` | 3.2 | 1.1 |
| `feature/responsive` | 3.3 | Ninguna |
| `fix/error-handling` | 4.1 | 1.1 |
| `test/critical-paths` | 4.2 | 1.1 |
| `test/provider-quality` | 4.4 | Ninguna |
| `chore/rate-limiting` | 4.3 | Ninguna |
| `feature/i18n` | 5.1 | Ninguna |
| `docs/landing-page` | 5.2 | Ninguna |
| `docs/changelog` | 5.3 | Ninguna |
| `legal/tos` | 5.4 | Ninguna |

---

## Orden de ejecución (con sub-agentes en paralelo)

### Semana 1
- ~~**Agente A**: `refactor/split-hooks` (Fase 1.1)~~ ✅ COMPLETADO
- ~~**Fix ad-hoc**: `fix/google-drive-session` (Drive session fix)~~ ✅ COMPLETADO
- ~~**Fix ad-hoc**: `feat/psd-text-folder` (PSD text folder)~~ ✅ COMPLETADO
- **Agente B**: `fix/typescript-errors` + `chore/move-binaries` (Fases 1.2 + 1.3)
- **Agente C**: `chore/purge-providers` + `test/provider-quality` (Fases 2.3 + 4.4)

### Semana 2
- **Agente A**: `feature/undo-redo` (Fase 2.1) — requiere 1.1 completado
- **Agente B**: `feature/redraw-ai` (Fase 2.2)
- **Agente C**: `fix/error-handling` + `chore/rate-limiting` (Fases 4.1 + 4.3)

### Semana 3
- **Agente A**: `feature/loading-skeletons` + `feature/bulk-translate` (Fases 3.1 + 3.2)
- **Agente B**: `feature/responsive` (Fase 3.3)
- **Agente C**: `test/critical-paths` (Fase 4.2)

### Semana 4
- **Agente A**: `feature/i18n` (Fase 5.1)
- **Agente B**: `docs/landing-page` + `docs/changelog` (Fases 5.2 + 5.3)
- **Agente C**: `legal/tos` (Fase 5.4)

---

## Riesgos identificados

| Riesgo | Probabilidad | Impacto | Mitigación |
|---|---|---|---|
| `useComicEditor` rompe durante refactor | Alta | Crítico | Tests antes de cada extracción |
| Google bloquea API no oficial | Media | Alto | Eliminar, usar LibreTranslate |
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

### 2026-07-23 — Google Drive session fix
- **Rama**: `fix/google-drive-session` → mergeada a `main` (PR #47)
- **Problema**: `savePageImages()` duplicaba base64 en IndexedDB para páginas con `driveFileId`
- **Solución**: omitir base64 cuando existe `driveFileId`, hidratar al restaurar sesión
- **Archivos**: `sessionStore.ts`, `useSessionPersistence.ts`, `App.tsx`
- **Verificación**: TypeScript compila, 171 tests pasan

### 2026-07-23 — Capas de texto en carpeta PSD
- **Rama**: `feat/psd-text-folder` → mergeada a `main` (PR #48)
- **Cambio**: todas las capas de texto van dentro de una carpeta `📁 Capas de Texto` en el PSD/PSB exportado
- **Beneficio**: el editor puede ocultar/mostrar todas las traducciones de un click
- **Archivo**: `psdExport.ts` (+8/-3)
- **Verificación**: TypeScript compila, 171 tests pasan

### Siguiente
- Fase 1.2 (TypeScript errors) + 1.3 (mover binarios)
- Fase 2.1 (undo/redo) — ya tiene hooks separados como dependencia completada
