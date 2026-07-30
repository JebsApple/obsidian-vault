# Plan de Re-implementación TL2EDIT — 3 Ramas (Menor a Mayor Complejidad)

> Estado base: **main = post-revert #88 = commit a5dbd30 (PR #80 merged)**
> Objetivo: Re-implementar PRs #81–#87 con modificaciones acordadas, **sin romper** export, Drive, ni stitch.
> Estrategia: 3 ramas secuenciales, cada una con tramos paralelizables por sub-agentes.
> Stitch: NO se modifica (solo si cambio 100% seguro).

---

## Arquitectura de Ramas

```
main (PR #80)
  │
  ├─► rama/foundation       ← BAJA-MEDIA  (independiente, sin tocar export/Drive/stitch)
  │       │
  │       └─► rama/drive-features    ← MEDIA-ALTA (depende de foundation estable)
  │               │
  │               └─► rama/engine-polish  ← MUY ALTA (depende de drive-features estable)
  │
  └─► (merge squash a main tras validación de cada rama)
```

---

## Rama 1: `rama/foundation` — Telemetría, UI Fixes y Apodos
**Dificultad: BAJA-MEDIA** | **Esfuerzo: 4–8h** | **Riesgo: NULO para export/Drive/stitch**

### Tramos Paralelizables (sub-agentes)

| Tramo | Archivos | Descripción | Agente |
|-------|----------|-------------|--------|
| **F1.1** | `src/hooks/useAnclarScrollRaiz.ts` (nuevo), `src/App.tsx`, `src/components/Select.tsx`, `src/components/SpellCheckedTextarea.tsx` | **Fix header scroll** (PR #82). Hook que ancla scroll root a 0 en evento `scroll`. `preventScroll: true` en 3 `focus()`. | Sub-agente A |
| **F1.2** | `server/telemetry/store.ts`, `scripts/telemetria.mjs` | **Verificar telemetría per-unit** (PR #80). Confirmar que `costo_por_unidad` (mediana de cocientes) ya funciona en main. Si falta, implementar. | Sub-agente B |
| **F1.3** | `src/index.css`, `src/components/Toast.tsx` | **Fixes UI puros #86**: scrollbar-corner transparente, Firefox `scrollbar-color`, Toast sin `calc(100%-32px)`. | Sub-agente C |
| **F1.4** | `src/hooks/useAnclarScrollRaiz.ts`, `src/components/StitchModal.tsx` | **Scroll root en fase captura** (#86 Tanda 2.3). Extender hook para cubrir fase de captura de StitchModal. | Sub-agente A (después F1.1) |
| **F1.5** | `src/types.ts`, `src/hooks/useNicknames.ts` (nuevo), `src/components/NicknamesPanel.tsx` (nuevo) | **Sistema de apodos**: `NicknameRule` con `nickname`, `originalPattern`, `translatedPattern`. Hook con store módulo. Panel con 3 campos. | Sub-agente D |
| **F1.6** | `src/lib/exportDocx.ts`, `src/lib/exportTxt.ts` | **Integrar apodos en exportación**: función `applyNicknames()` que reemplaza en original y traducido antes de escribir cada párrafo. | Sub-agente D (después F1.5) |

### Criterios de Merge a main
- [ ] `npm run build` pasa
- [ ] `npm test` pasa
- [ ] Header no se desplaza al hacer focus en inputs
- [ ] Telemetría muestra `c/unidad` en reporte
- [ ] Panel de apodos funcional (3 campos)
- [ ] Apodos se aplican en exportación DOCX

---

## Rama 2: `rama/drive-features` — Exportación, Series, Drive Hardening
**Dificultad: MEDIA-ALTA** | **Esfuerzo: 20–35h** | **Riesgo: MEDIO (toca Drive API y export)**

> **BASE**: `rama/foundation` merged a main

### Paso 2.1: `formato-exportacion` — Nuevo formato DOCX + Unificación UI
**4–6h** | Archivos: `src/lib/exportDocx.ts`, `src/App.tsx`, `src/hooks/useExport.ts`, `src/hooks/useComicEditor.ts`

#### Formato nuevo de exportación DOCX

```
-diálogo

()pensamiento

**grito

[imagen: sticker.png]         ← bloque imagen, insertado como imagen (ImageRun)

-diálogo siguiente
```

**Cambios en `exportDocx.ts`**:
- **Cada bloque = su propio párrafo**: eliminar lógica de `groupId` que unía bloques en una misma línea
- **Línea en blanco entre bloque y bloque**: `spacing: { after: 200 }` en cada párrafo
- **Sin separación entre páginas**: todo el texto corrido en una sola sección, sin reset por página (eliminar `buildPageParagraphs`, todo directo en `buildDocxBlobMulti`)
- **Imágenes se mantienen**: bloque tipo `imagen` se exporta con `ImageRun` (igual que ahora)
- **Apodos**: aplicar `applyNicknames()` al texto aprobado antes de escribir
- **Google Docs**: se queda igual (el DOCX se sube con `convert: true`)

| Sub-tramo | Archivos | Descripción |
|-----------|----------|-------------|
| **2.1.1** | `src/lib/exportDocx.ts` | Re-escribir `buildDocxBlobMulti`: cada bloque su párrafo, sin separación páginas, imágenes con ImageRun, apodos integrados |
| **2.1.2** | `src/App.tsx` | Unificar botones: eliminar DOCX + GDOCS separados, crear un solo **Exportar** con hover (Descargar DOCX / Google Docs). PSD se queda igual |
| **2.1.3** | `src/hooks/useExport.ts` | Ajustar `handleExportDocxMulti` y `handleExportGoogleDocs` para nuevo flujo. Eliminar `buildDocxBlob` (solo multi) |
| **2.1.4** | `src/hooks/useComicEditor.ts` | Ajustar exports exportados |

### Paso 2.2: `series-blocktypes` — Series con tipos de bloque propios
**6–8h** | Archivos: `src/types.ts`, `src/hooks/useSeries.ts` (nuevo), `src/components/SeriesPanel.tsx` (nuevo), `src/App.tsx`, `src/components/SidebarTextBlocks.tsx`, `src/components/BlockTypesPanel.tsx`

| Sub-tramo | Archivos | Descripción |
|-----------|----------|-------------|
| **2.2.1** | `src/types.ts` | Agregar `Series`, `SeriesBlockTypeOverride`. Extender `resolveBlockType()` con parámetro `seriesOverrides` |
| **2.2.2** | `src/hooks/useSeries.ts` (nuevo) | Hook con store módulo: `seriesList`, `currentSeries`, `setCurrentSeries`, CRUD |
| **2.2.3** | `src/components/SeriesPanel.tsx` (nuevo) | Selector de serie activa + editor de overrides por tipo de bloque |
| **2.2.4** | `src/App.tsx` | Integrar SeriesPanel en sidebar. Pasar serie activa a `resolveBlockType` |
| **2.2.5** | `src/components/SidebarTextBlocks.tsx`, `src/components/BlockTypesPanel.tsx` | Mostrar prefijos de la serie activa en lugar de los globales |

### Paso 2.3: `drive-hardening` — Exponential Backoff + URL Encoding
**3–5h** | Archivos: `src/lib/googleDrive.ts`

| Sub-tramo | Archivos | Descripción |
|-----------|----------|-------------|
| **2.3.1** | `src/lib/googleDrive.ts` | Envolver `driveFetch()` con `driveFetchWithRetry()`: reintenta con backoff exponencial (2s, 4s, 8s) en 429, 500, 503 |
| **2.3.2** | `src/lib/googleDrive.ts` | Auditar URL encoding: verificar que todas las queries usan `encodeURIComponent()`. En particular: `listDriveSessions`, `ensureSessionsFolder`, `ensureExportsFolder`, `listDriveFolder`, `createDriveFolder` |

### Criterios de Merge rama/drive-features → main
- [ ] DOCX exporta cada bloque en su propio párrafo con espacio entre ellos
- [ ] DOCX no separa por páginas (todo corrido)
- [ ] Imágenes aparecen insertadas en el DOCX
- [ ] Un solo botón "Exportar" con hover: "Descargar DOCX" y "Google Docs"
- [ ] Botón PSD igual que ahora
- [ ] Selector de serie activa en UI
- [ ] Override de serie cambia prefijo en sidebar y export
- [ ] `npm run build` + `npm test` pasan

---

## Rama 3: `rama/engine-polish` — Refactor Export + Telemetría Final
**Dificultad: MEDIA** | **Esfuerzo: 15–25h** | **Riesgo: MEDIO (refactor export)**

> **BASE**: `rama/drive-features` merged a main
> **Nota**: Stitch NO se toca en esta rama.

### Tramos Paralelizables

| Tramo | Archivos | Descripción | Prioridad |
|-------|----------|-------------|-----------|
| **E3.1** | `src/lib/googleDrive.ts`, `src/hooks/useExport.ts`, `src/utils/psdExport.ts` | **Refactor exports (PR #87)**. SOLO REFACTOR. Cero cambio de comportamiento. Separar googleDrive.ts en api.ts + folders.ts + naming.ts. | **ALTA** |
| **E3.2** | 14 archivos (ver #86) | **Telemetría 3.1.4 fixes**. Defectos P0-P1-P2 finales. | **ALTA** |

### Dependencias
```
E3.1 (refactor) ────┐
                     ├──► (independientes, paralelos)
E3.2 (telemetry) ────┘
```

### E3.1: Refactor Exports
**Archivos**: googleDrive.ts (469 líneas → separar en):

```
src/lib/drive/
├── api.ts          ← Solo HTTP calls (testeable con mocks)
├── folders.ts      ← Lógica de carpetas (ensureExportsFolder, ensureSessionsFolder)
├── naming.ts       ← Convenciones de nombres (baseFileName, sessionFileName)
└── types.ts        ← DriveSessionFile, DriveExportResult, etc.
```

- Neto: -230 líneas (objetivo)
- Validación: snapshot test del output binario PRE vs POST refactor

### E3.2: Telemetría 3.1.4 Fixes
14 defectos categorizados por severidad:

| Prioridad | Defectos | Estrategia |
|-----------|----------|------------|
| **P0** (bloqueante) | • Error 400 en Drive con `orderBy` (ya cubierto en 2.3.2)
• DOCX multi-página no separa correctamente (ya cubierto en 2.1.1)
• Tildes rotas en UI | **Test first** |
| **P1** (grave) | • Bloques imagen/nota no se renderizan
• Scroll-sidebar pierde posición al cambiar página
• Error silencioso en export cuando falta accessToken | **Surgical fix** |
| **P2** (molesto) | • DriveFolderPicker no refresca
• Telemetría: evento duplicado en cancelación
• UI: padding inconsistente en botones | **Batch commit** |

### Criterios de Merge
- [ ] Refactor: idempotente (mismo output binario pre/post)
- [ ] Tests de snapshot para refactor
- [ ] `npm run build` + `npm test` pasan
- [ ] Los 14 defectos tienen test que los reproduce

---

## Integración vertical de features entre ramas

| Feature | Foundation | Drive-Features | Engine-Polish |
|---------|-----------|----------------|---------------|
| Apodos | F1.5 (modelo + hook + UI) | — | — |
| Apodos en export | F1.6 (applyNicknames) | — | — |
| DOCX formato nuevo | — | 2.1.1 (re-escribir) | — |
| UI botones Exportar | — | 2.1.2 + 2.1.3 | — |
| Series blocktypes | — | 2.2 (completo) | — |
| Drive hardening | — | 2.3 (completo) | — |
| Refactor exports | — | — | E3.1 |
| Telemetría fixes | — | — | E3.2 |

---

## Resumen de Esfuerzo

| Rama | Esfuerzo (h) | Complejidad |
|------|--------------|-------------|
| foundation (con apodos) | 6–12 | BAJA-MEDIA |
| drive-features (export + series + drive) | 13–19 | MEDIA-ALTA |
| engine-polish (refactor + telemetry) | 15–25 | MEDIA |
| **TOTAL** | **34–56h** | ~1-2 semanas (1 dev senior) |

## Checklist de Seguridad (NO ROMPER)

| Área | Archivos intocables sin validación |
|------|-----------------------------------|
| **Export** | `exportDocx.ts` — solo tocar en 2.1.1 con test antes/después |
| **Drive** | `googleDrive.ts` — solo agregar, no cambiar firmas existentes hasta E3.1 |
| **Stitch** | `stitchEngine.ts`, `stitch.ts`, `StitchModal.tsx` — **NO TOCAR NUNCA** |
| **Session** | `useSessionPersistence.ts`, `SESSION_FORMAT_VERSION` |
| **Telemetry** | `TELEMETRY_SCHEMA_VERSION`, sanitize, consent flow |

## Archivos a crear

| Rama | Archivo |
|------|---------|
| F1.5 | `src/hooks/useNicknames.ts` |
| F1.5 | `src/components/NicknamesPanel.tsx` |
| 2.2.2 | `src/hooks/useSeries.ts` |
| 2.2.3 | `src/components/SeriesPanel.tsx` |
| E3.1 | `src/lib/drive/api.ts` (desde googleDrive.ts) |
| E3.1 | `src/lib/drive/folders.ts` (desde googleDrive.ts) |
| E3.1 | `src/lib/drive/naming.ts` (desde googleDrive.ts) |
| E3.1 | `src/lib/drive/types.ts` (desde googleDrive.ts + types.ts) |

## Archivos a modificar

| Rama | Archivo | Cambio |
|------|---------|--------|
| F1.5 | `src/types.ts` | Agregar `NicknameRule` |
| F1.6 | `src/lib/exportDocx.ts` | Integrar `applyNicknames()` |
| 2.1.1 | `src/lib/exportDocx.ts` | Nuevo formato: cada bloque su párrafo, sin separación páginas |
| 2.1.2 | `src/App.tsx` | Unificar botones Exportar |
| 2.1.3 | `src/hooks/useExport.ts` | Ajustar handlers |
| 2.1.4 | `src/hooks/useComicEditor.ts` | Integrar apodos, adjustar exports |
| 2.2.1 | `src/types.ts` | Agregar `Series`, `SeriesBlockTypeOverride`. Extender `resolveBlockType()` |
| 2.2.4 | `src/App.tsx` | Integrar SeriesPanel |
| 2.2.5 | `src/components/SidebarTextBlocks.tsx` | Prefijos de serie activa |
| 2.2.5 | `src/components/BlockTypesPanel.tsx` | Prefijos de serie activa |
| 2.3 | `src/lib/googleDrive.ts` | Exponential backoff + URL encode audit |
| E3.1 | `src/lib/googleDrive.ts` | Separar en drive/ subdirectorio |
| E3.1 | `src/hooks/useExport.ts` | Actualizar imports |
| E3.1 | `src/utils/psdExport.ts` | Actualizar imports |
| E3.2 | Varios (14 archivos) | Telemetría fixes |

---

## Sub-Plans de Ejecución por Sub-Agente

Cada tramo del plan tiene un sub-plan detallado en `Blueprints/sub-plans/` con:
- Código exacto a escribir/modificar
- Skills a cargar
- Tests y verificación
- **Nota al ejecutor**: el código sugerido es una guía. El ejecutor puede criticarlo, mejorarlo, y debe preguntar si tiene dudas.
- **🥩 Grilling**: preguntas que resolver antes de empezar (aplicado con skill `grill-me`)

### Rama 1: Foundation

### Rama 1: Foundation
| Tramo | Sub-Plan | 
|-------|----------|
| F1.1 | `sub-plans/F1.1-fix-header-scroll.md` |
| F1.2 | `sub-plans/F1.2-telemetria-per-unit.md` |
| F1.3 | `sub-plans/F1.3-fixes-ui.md` |
| F1.4 | `sub-plans/F1.4-scroll-root-stitchmodal.md` |
| F1.5 | `sub-plans/F1.5-nicknames-system.md` |
| ~~F1.6~~ | ~~OBSOLETO (reemplazado por 2.1.1)~~ |

### Rama 2: Drive Features
| Tramo | Sub-Plan |
|-------|----------|
| 2.1.1 | `sub-plans/2.1.1-nuevo-formato-docx.md` |
| 2.1.2-4 | `sub-plans/2.1.2-2.1.4-unificar-botones-export.md` |
| 2.2 | `sub-plans/2.2-series-blocktypes.md` |
| 2.3 | `sub-plans/2.3-drive-hardening.md` |

### Rama 3: Engine Polish
| Tramo | Sub-Plan |
|-------|----------|
| E3.1 | `sub-plans/E3.1-refactor-exports.md` |
| E3.2 | `sub-plans/E3.2-telemetry-fixes.md` |

### Orden de ejecución auditado
Ver `sub-plans/00-INDICE.md` para el orden exacto con dependencias.
F1.6 está OBSOLETO. 2.3 debe ejecutarse antes que E3.1.

*Generado: 2026-07-30. Basado en análisis de PRs #80–#88 y modificaciones acordadas. Prioriza estabilidad sobre velocidad.*
