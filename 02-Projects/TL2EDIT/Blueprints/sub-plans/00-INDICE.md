# Índice de Sub-Plans TL2EDIT

> **Estado**: Todos los sub-plans han sido auditados por agente externo.
> **Errores corregidos**: F1.6 obsoleto, E3.1 incompleto, orden de dependencias.

---

## Orden de Ejecución

```
RAMA 1: foundation
┌──────────────────────────────────────────────────────────────┐
│ 1. F1.1  Fix header scroll  (Sub-agente A)                   │
│ 2. F1.2  Telemetría per-unit  (Sub-agente B)                 │
│ 3. F1.3  Fixes UI  (Sub-agente C)                            │
│ 4. F1.4  Scroll root StitchModal  (Sub-agente A, tras F1.1) │
│ 5. F1.5  Sistema de apodos  (Sub-agente D)                   │
│                                                              │
│ ⚠️ F1.6 está OBSOLETO (reemplazado por 2.1.1)               │
└──────────────────────────────────────────────────────────────┘
        │ merge a main
        ▼
RAMA 2: drive-features
┌──────────────────────────────────────────────────────────────┐
│ 6. 2.1.1  Nuevo formato DOCX  (usa apodos de F1.5)          │
│ 7. 2.1.2-4  Unificar botones Exportar                        │
│ 8. 2.2  Series block types  (independiente)                  │
│ 9. 2.3  Drive hardening  (CREA driveFetchWithRetry)          │
│                                                              │
│ Dependencia: 2.3 DEBE ir antes que E3.1                      │
└──────────────────────────────────────────────────────────────┘
        │ merge a main
        ▼
RAMA 3: engine-polish
┌──────────────────────────────────────────────────────────────┐
│ 10. E3.1  Refactor exports  (USA driveFetchWithRetry de 2.3) │
│ 11. E3.2  Telemetría fixes                                   │
│                                                              │
│ Dependencia: E3.1 DEBE ir después de 2.3                     │
└──────────────────────────────────────────────────────────────┘
        │ merge a main
        ▼
    ✅ COMPLETADO
```

---

## Sub-Plans por Rama

### Rama 1: Foundation (6 activos, 1 obsoleto)

| # | Sub-Plan | Archivo | Agente | Depende de |
|---|----------|---------|--------|------------|
| 1 | Fix header scroll | `F1.1-fix-header-scroll.md` | A | — |
| 2 | Telemetría per-unit | `F1.2-telemetria-per-unit.md` | B | — |
| 3 | Fixes UI | `F1.3-fixes-ui.md` | C | — |
| 4 | Scroll root StitchModal | `F1.4-scroll-root-stitchmodal.md` | A (tras F1.1) | F1.1 |
| 5 | Sistema de apodos | `F1.5-nicknames-system.md` | D | — |
| ~~6~~ | ~~Apodos en export~~ | ~~F1.6-nicknames-in-export.md~~ | — | ~~OBSOLETO~~ |

### Rama 2: Drive Features (4 activos)

| # | Sub-Plan | Archivo | Depende de |
|---|----------|---------|------------|
| 6 | Nuevo formato DOCX | `2.1.1-nuevo-formato-docx.md` | F1.5 |
| 7 | Unificar botones Exportar | `2.1.2-2.1.4-unificar-botones-export.md` | 2.1.1 |
| 8 | Series block types | `2.2-series-blocktypes.md` | — |
| 9 | Drive hardening | `2.3-drive-hardening.md` | — |

### Rama 3: Engine Polish (2 activos)

| # | Sub-Plan | Archivo | Depende de |
|---|----------|---------|------------|
| 10 | Refactor exports | `E3.1-refactor-exports.md` | **2.3** |
| 11 | Telemetría fixes | `E3.2-telemetry-fixes.md` | — |

---

## Mapa de Cambios por Archivo

| Archivo | Qué sub-plan lo toca |
|---------|---------------------|
| `src/App.tsx` | F1.1, 2.1.2-4, 2.2, E3.2 |
| `src/types.ts` | F1.5, 2.2 |
| `src/lib/exportDocx.ts` | **2.1.1** (reescritura completa) |
| `src/lib/googleDrive.ts` | 2.3, E3.1 (refactor a drive/) |
| `src/index.css` | F1.3, E3.2 |
| `src/hooks/useExport.ts` | F1.5 (nicknames param), 2.1.2-4 |
| `src/hooks/useComicEditor.ts` | F1.5, 2.1.2-4 |
| `src/hooks/useNicknames.ts` | **F1.5** (CREAR) |
| `src/hooks/useSeries.ts` | **2.2** (CREAR) |
| `src/components/NicknamesPanel.tsx` | **F1.5** (CREAR) |
| `src/components/SeriesPanel.tsx` | **2.2** (CREAR) |
| `src/components/Select.tsx` | F1.1 |
| `src/components/SpellCheckedTextarea.tsx` | F1.1 |
| `src/components/StitchModal.tsx` | F1.4 |
| `src/components/SidebarTextBlocks.tsx` | 2.2 |
| `src/components/BlockTypesPanel.tsx` | 2.2 |
| `src/components/DriveFolderPicker.tsx` | E3.2 |
| `scripts/telemetria.mjs` | F1.2 |
| `src/lib/drive/api.ts` | **E3.1** (CREAR) |
| `src/lib/drive/folders.ts` | **E3.1** (CREAR) |
| `src/lib/drive/naming.ts` | **E3.1** (CREAR) |
| `src/lib/drive/types.ts` | **E3.1** (CREAR) |
| `server/telemetry/store.ts` | F1.2 (solo verificación) |

---

## Archivos PROHIBIDOS de tocar

| Archivo | Motivo |
|---------|--------|
| `server/stitchEngine.ts` | Stitch no se modifica |
| `server/stitch.ts` | Stitch no se modifica |
| `src/components/StitchModal.tsx` | Solo fix scroll (F1.4), nada más |
| `src/hooks/useSessionPersistence.ts` | Ya funciona |
| `src/components/DriveSessionModal.tsx` | Ya funciona |
| `server/lib/googleAuth.ts` | Backend auth, no tocar |
