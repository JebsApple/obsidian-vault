---
aliases: [tl2edit-plan-v2, tl2edit-auditoria]
tags: [project, plan, comics, translation, ocr, audit]
created: 2026-07-23
updated: 2026-07-23
status: activo
related: [[tl2edit-blueprint]], [[plan-lanzamiento-google]]
---

# TL2EDIT — Plan v2 (Auditoría 2026-07-23)

## Resumen Ejecutivo

Auditoría completa del proyecto TL2EDIT. Cubre: estado actual, comparativa con competidores, problemas de ingeniería, UX/UI, estándares de la industria, monetización, y qué falta para producto público.

**Repo**: [JebsApple/TL2EDIT](https://github.com/JebsApple/TL2EDIT)
**Copia local**: `~/proyectos/TL2EDIT`
**Stack**: React 19 + Vite + Tailwind v4 + Express + TypeScript
**Estado**: 209 commits, 2 semanas activo, 38 PRs mergeados

---

## Fase 1: Cimientos (Sin esto nada funciona)

### 1.1 Refactorizar `useComicEditor` (869 líneas → 5 hooks)

**El problema**: Un solo hook maneja TODO: estado del editor, llamadas a APIs, exportación, drag and drop, pestañas, seccionado, procesamiento. Cada cambio nuevo puede romper algo que ya funcionaba.

**La solución**: Dividir en 5 hooks especializados:

| Hook nuevo | Responsabilidad | Líneas estimadas |
|---|---|---|
| `usePageManager` | Estado de páginas, tabs, reorder, close, sort | ~150 |
| `useBlockEditor` | Selección, drag, resize, tipos, agrupación, undo/redo | ~200 |
| `useExport` | PSD/PSB/DOCX, modal, progress, batch ZIP | ~150 |
| `useSectioning` | Webtoon cuts, queue, auto-cuts | ~80 |
| `useProcessing` | OCR, translate, phase, stager, abort controllers | ~180 |

**Orden de extracción**:
1. `usePageManager` (menos dependencias, base para los demás)
2. `useSectioning` (aislado, solo depende de pageManager)
3. `useProcessing` (depende de pageManager + sectioning)
4. `useExport` (depende de pageManager + blocks)
5. `useBlockEditor` (el más complejo, depende de todo)

**Criterio de éxito**: Cada hook se puede testear independientemente. `useComicEditor` queda como orquestador delgado (~100 líneas).

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

### 2.2 Inpainting (el feature #1 que falta)

**El problema**: Todos los competidores serios (Koharu, KomaKun, manga-image-translator, PSImera) tienen inpainting. TL2EDIT exporta PSD editable pero no limpia el texto original. Para uso profesional, el usuario tiene que ir a Photoshop a borrar manualmente.

**Opciones evaluadas**:

| Opción | Pros | Contras | Costo |
|---|---|---|---|
| **LaMa via API** | La mejor quality, BYOK compatible | Requiere API key (Replicate) | ~$0.01/página |
| **Canvas API local** | Gratis, sin dependencias | Quality baja, artefactos | $0 |
| **OpenCV.js** | Funcional, gratis | Peso (~8MB WASM), lento | $0 |
| **Inpainting manual** | El usuario pinta区域 | No es automático | $0 |

**Recomendación dada tu presupuesto**: Empezar con **inpainting manual** (el usuario pinta la区域 que quiere limpiar, se rellena con color de fondo). Es gratis, funciona, y cubre el 80% del caso de uso. LaMa via API se agrega después como premium.

**Implementación**:
- Modo "pintar" en el canvas (brush tool)
- Selector de tamaño de pincel
- Color de fondo: automático (sample de bordes) o manual
- Preview antes de aplicar
- Toggle por bloque (no todas las páginas necesitan limpieza)
- Export PSD incluye la capa "cleaned" separada

**Ramas**: `feature/inpainting`

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

### 5.4 Legal / ToS

- Página de privacidad/ToS
- Aclarar que API keys no se almacenan server-side
- Disclaimer: "Herramienta de traducción. El usuario es responsable del uso del contenido traducido."
- Esto mitiga el riesgo legal de traducción no autorizada

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

---

## Estado del PR #35 (refactor)

La rama `refactor/app-hook-and-batch-errors` está **desactualizada** — es ancestro de `main`, significa que `main` se movió adelante con features nuevas (rotación, fixes) y el refactor se quedó atrás.

**Diferencia neta**: 845 inserciones, 70,178 eliminaciones. El refactor eliminó:
- Google Drive integration (archivos completos)
- NSpell orthography
- Replacements system
- Select component personalizado
- Varios hooks y utilidades

**Recomendación**: No mergear este refactor tal cual. mejor hacer el refactor incremental (Fase 1.1) sobre `main` actual, extrayendo hooks uno por uno. El refactor viejo eliminaba features que podrían ser útiles después.

---

## Ramas a crear

| Rama | Fase | Dependencia |
|---|---|---|
| `refactor/split-hooks` | 1.1 | Ninguna |
| `fix/typescript-errors` | 1.2 | Ninguna |
| `chore/move-binaries` | 1.3 | Ninguna |
| `feature/undo-redo` | 2.1 | 1.1 (necesita hooks separados) |
| `feature/inpainting` | 2.2 | Ninguna |
| `chore/purge-providers` | 2.3 | Ninguna |
| `feature/loading-skeletons` | 3.1 | Ninguna |
| `feature/bulk-translate` | 3.2 | 1.1 |
| `feature/responsive` | 3.3 | Ninguna |
| `fix/error-handling` | 4.1 | 1.1 |
| `test/critical-paths` | 4.2 | 1.1 |
| `chore/rate-limiting` | 4.3 | Ninguna |
| `feature/i18n` | 5.1 | Ninguna |
| `docs/landing-page` | 5.2 | Ninguna |
| `docs/changelog` | 5.3 | Ninguna |
| `legal/tos` | 5.4 | Ninguna |

---

## Orden de ejecución (con sub-agentes en paralelo)

### Semana 1
- **Agente A**: `refactor/split-hooks` (Fase 1.1) — el más crítico
- **Agente B**: `fix/typescript-errors` + `chore/move-binaries` (Fases 1.2 + 1.3)
- **Agente C**: `chore/purge-providers` (Fase 2.3)

### Semana 2
- **Agente A**: `feature/undo-redo` (Fase 2.1) — requiere 1.1 completado
- **Agente B**: `feature/inpainting` (Fase 2.2)
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
| Sin inpainting, usuarios serios se van | Alta | Crítico | Inpainting manual como MVP |
| Legal: traducción no autorizada | Media | Alto | ToS + disclaimer |
| Render free tier: 512MB RAM insuficiente | Baja | Medio | Monitorear, upgrade si es necesario |
| PR #35 conflictos de merge | Alta | Bajo | No mergear, hacer refactor incremental |

---

## Referencias

- [[tl2edit-blueprint]] — Plan original del proyecto
- [[plan-lanzamiento-google]] — Plan SEO/landing
- Auditoría completa: 2026-07-23 (esta sesión)
- Competidores analizados: Koharu, KomaKun, manga-image-translator, PSImera, OCR-Cleaner, AutoScanlate-AI, FrankYomik
