# Plan de Re-implementación TL2EDIT — 3 Ramas (Menor a Mayor Complejidad)

> Estado base: **main = post-revert #88 = commit a5dbd30 (PR #80 merged)**
> Objetivo: Re-implementar PRs #81–#87 **sin romper** export, Drive, ni stitch.
> Estrategia: 3 ramas secuenciales, cada una con tramos paralelizables por sub-agentes.

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

## Rama 1: `rama/foundation` — Telemetría y UI Fixes Aislados
**Dificultad: BAJA-MEDIA** | **Esfuerzo: 4–8h** | **Riesgo: NULO para export/Drive/stitch**

### Tramos Paralelizables (sub-agentes)

| Tramo | Archivos | Descripción | Agente |
|-------|----------|-------------|--------|
| **F1.1** | `src/hooks/useAnclarScrollRaiz.ts` (nuevo), `src/App.tsx`, `src/components/Select.tsx`, `src/components/SpellCheckedTextarea.tsx` | **Fix header scroll** (PR #82). Hook que ancla scroll root a 0 en evento `scroll`. `preventScroll: true` en 3 `focus()`. | Sub-agente A |
| **F1.2** | `server/telemetry/store.ts`, `scripts/telemetria.mjs` | **Verificar telemetría per-unit** (PR #80). Confirmar que `costo_por_unidad` (mediana de cocientes) ya funciona en main. Si falta, implementar. | Sub-agente B |
| **F1.3** | `src/index.css`, `src/components/Toast.tsx` (si existe), `src/lib/dragPreview.ts` (nuevo) | **Fixes UI puros #86**: scrollbar-corner transparente, Firefox `scrollbar-color`, Toast sin `calc(100%-32px)`, helper `dragPreview.ts` unificado. | Sub-agente C |
| **F1.4** | `src/hooks/useAnclarScrollRaiz.ts`, `src/components/StitchModal.tsx` | **Scroll root en fase captura** (#86 Tanda 2.3). Extender hook para cubrir fase de captura de StitchModal. | Sub-agente A (después F1.1) |

### Criterios de Merge a main
- [ ] `npm run build` pasa
- [ ] `npm test` pasa (236 tests)
- [ ] Header no se desplaza al hacer focus en inputs
- [ ] Telemetría muestra `c/unidad` en reporte

---

## Rama 2: `rama/drive-features` — Features Drive + Sesiones + UI Unificada
**Dificultad: MEDIA-ALTA** | **Esfuerzo: 20–35h** | **Riesgo: MEDIO (toca Drive API y export overwrite)**

> **BASE**: `rama/foundation` merged a main

### Paso 2.1: `sobrescribir-traduccion` (PR #81) — Export Overwrite
**3–5h** | Archivos: `src/lib/googleDrive.ts`, `src/hooks/useExport.ts`, `src/components/DriveFolderPicker.tsx`, `src/App.tsx` (ExportModal inline)

| Sub-tramo | Archivos | Descripción |
|-----------|----------|-------------|
| **2.1.1** | `src/lib/googleDrive.ts` | Añadir `listExportFilesInFolder()`, `overwriteExportFile()`, `uploadExportFile()` con multipart/related para Google Docs. |
| **2.1.2** | `src/components/DriveFolderPicker.tsx` | Selector lista traducciones existentes. Marca "mismo nombre". Botón cambia a "Sobrescribir X". |
| **2.1.3** | `src/hooks/useExport.ts` | Manejar `sobrescribirFileId` en `handleExportDocxMulti` / `handleExportGoogleDocs`. |
| **2.1.4** | `src/App.tsx` (ExportModal) | Integrar flujo overwrite. Confirmación destructiva visible. |

### Paso 2.2: `gestion-sesiones` (PR #83) — Sessions CRUD + Preview
**12–20h** | **EL FEATURE MÁS GRANDE** — 32 archivos tocados en original

| Sub-tramo | Archivos | Descripción |
|-----------|----------|-------------|
| **2.2.1** | `src/lib/googleDrive.ts` | Fix `orderBy=modifiedTime%20desc` (URL-encoded). |
| **2.2.2** | `src/components/DriveSessionModal.tsx` (nuevo/refactor) | Dos pestañas: **Guardar** / **Cargar**. Botones borrar/renombrar por fila. |
| **2.2.3** | `src/components/DriveSessionModal.tsx` | **Aviso restauración con preview**: miniaturas + contador globos traducidos. |
| **2.2.4** | `src/components/Modal.tsx` (nuevo), `src/components/Toast.tsx` (nuevo) | Componentes base. Modal accesible (ESC, click outside). Toast con `dismissible`. |
| **2.2.5** | `src/hooks/useSessionPersistence.ts`, `src/hooks/usePages.ts`, `src/hooks/useBlocks.ts` | Integración: `restore()` hidrata imágenes. `discard()` avisa. Auto-save 800ms. |
| **2.2.6** | `src/components/SidebarTextBlocks.tsx`, `src/components/WelcomeCard.tsx`, `src/components/StitchModal.tsx` | **Limpieza textos UI**: quitar guiones largos, corregir voseo. |

### Paso 2.3: `unificacion-interfaz` (PR #84) — Modal/Toast Único + Ctrl+V
**6–10h** | **DESPUÉS de 2.2** (unifica lo que 2.2 introdujo)

| Sub-tramo | Archivos | Descripción |
|-----------|----------|-------------|
| **2.3.1** | `src/components/Modal.tsx`, `src/components/Toast.tsx` | Unificar 5 modales + 3 toasts. Telemetry consent: `dismissible=false`. |
| **2.3.2** | `src/hooks/useClipboardPaste.ts` (nuevo) | `Ctrl+V` pega imágenes. Ignora foco en input/textarea. |
| **2.3.3** | 5 componentes modal | Migrar todos a Modal/Toast únicos. |
| **2.3.4** | `src/hooks/useAnclarScrollRaiz.ts`, `src/hooks/useKeyboardShortcuts.ts` | Scroll root en captura. Atajos teclado. |
| **2.3.5** | `src/index.css`, `src/nocturne.css` | Scrollbar-corner/resizer. Firefox `scrollbar-color`. |

### Criterios de Merge rama/drive-features → main
- [ ] Export overwrite: un archivo en Drive, no duplicados
- [ ] Sesiones: guardar/cargar/borrar/renombrar + preview miniaturas
- [ ] Modal/Toast únicos: 0 implementaciones duplicadas
- [ ] `Ctrl+V` funciona en canvas
- [ ] `npm run build` + `npm test` pasan

---

## Rama 3: `rama/engine-polish` — Engine Stitch + Refactor Export + Telemetría Final
**Dificultad: MUY ALTA** | **Esfuerzo: 25–45h** | **Riesgo: ALTO (engine central + refactor export)**

> **BASE**: `rama/drive-features` merged a main

### Tramos Paralelizables

| Tramo | Archivos | Descripción | Prioridad |
|-------|----------|-------------|-----------|
| **E3.1** | `server/stitchEngine.ts`, `server/stitch.ts`, `server/stitchEngine.test.ts`, `src/components/StitchModal.tsx` | **Stitch engine fix (PR #85)**. Reescritura: `sliceSearchBounds()` sobre alto total tira, `assertNoContentLost()`, preview endpoint, telemetría nueva. Validar con capítulo real 43 págs. | **MÁXIMA** |
| **E3.2** | 9 archivos export/Drive | **Refactor exports (PR #87)**. SOLO REFACTOR. Cero cambio de comportamiento. Neto: -230 líneas. | **ALTA** |
| **E3.3** | 27 archivos (ver #86) | **Telemetría 3.1.4 fixes**. 14 defectos P0-P1-P2 finales. | **ALTA** |

### Dependencias
```
E3.1 (stitch) ──────┐
                    ├──► E3.3 (telemetry fixes finales)
E3.2 (refactor) ────┘
```
E3.1 y E3.2 independientes → paralelos. E3.3 DEBE ser último.

### Criterios de Merge
- [ ] Stitch: 0 cortes forzados en capítulo real 43 págs
- [ ] Export: idempotente (mismo output binario pre/post)
- [ ] `npm run build` + `npm test` + `npm run test:server` pasan

---

## Resumen de Esfuerzo

| Rama | Esfuerzo (h) | Complejidad |
|------|--------------|-------------|
| foundation | 4–8 | BAJA-MEDIA |
| drive-features | 20–35 | MEDIA-ALTA |
| engine-polish | 25–45 | MUY ALTA |
| **TOTAL** | **49–88h** | ~2-3 semanas (1 dev senior) |

## Checklist de Seguridad (NO ROMPER)

| Área | Archivos intocables sin validación |
|------|-----------------------------------|
| **Export** | `exportDocx.ts`, `exportTxt.ts`, `useExport.ts` |
| **Drive** | `googleDrive.ts`, `useGoogleAuth.ts`, `server/lib/googleAuth.ts` |
| **Stitch** | `stitchEngine.ts`, `stitch.ts`, `StitchModal.tsx` |
| **Session** | `useSessionPersistence.ts`, `SESSION_FORMAT_VERSION` |
| **Telemetry** | `TELEMETRY_SCHEMA_VERSION`, sanitize, consent flow |

---

*Generado: 2026-07-30. Basado en análisis de PRs #80–#88. Prioriza estabilidad sobre velocidad.*
