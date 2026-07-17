---
aliases: [tl2edit-blueprint]
tags: [project, plan, comics, translation, ocr]
created: 2026-07-13
status: activo
---

# TL2EDIT — Plan

## Contexto

Traductor de cómics a PSD editable. Detecta globos de texto, transcribe y
traduce el diálogo, exporta `.psd` con capas editables para Photoshop.
Repo: [JebsApple/TL2EDIT](https://github.com/JebsApple/TL2EDIT) (público).

## Stack

| Capa | Tecnología |
|------|-----------|
| Frontend | React 19 + Vite + Tailwind v4 |
| Backend | Express + TypeScript (`tsx`) |
| OCR | Gemini, OpenRouter (vision), Tesseract.js (local, sin key) |
| Traducción | Gemini, OpenRouter, DeepL, LibreTranslate (sin key) |
| Export | `ag-psd` (PSD), `jszip` (batch) |
| Tests | Vitest |

## Estado actual (2026-07-13)

Sistema multi-proveedor de OCR/traducción completo (HU02):
- Modo AI (detección automática) + modo manual (dibujar recuadro)
- OCR manual por región recortada
- Edición inline de bloques en canvas (doble-click)
- `/api/providers/status` real, wireado en 3 badges de UI (antes placeholders)
- Fix de modelos free de OpenRouter (IDs verificados) + timeout 120s
- Suite Vitest (38 tests) para lógica pura crítica

PR abierto: [#1](https://github.com/JebsApple/TL2EDIT/pull/1)
(`HU02-feature-sistema-multiproveedor` → `main`), pendiente de revisión/merge.

### Rediseño frontend Nocturne (2026-07-17)

Handoff de Claude Design (`TL2EDIT Editor.dc.html`) implementado en
`feature/nocturne-editor-redesign`, PR [#2](https://github.com/JebsApple/TL2EDIT/pull/2)
(base `main`, **no** sobre HU02 — ver conflicto abajo):
- Sistema visual Nocturne completo (tokens + clases en `index.css`, acento violeta)
- Editor de un solo lienzo: toolbar de modo (IA/manual), edición inline con doble-click,
  zoom, diálogo "Proveedores"
- Export TXT nuevo
- `/api/providers/status` y `/api/ocr-region` (versión propia, solo Gemini — más simple
  que el sistema multiproveedor de HU02)
- Panel avanzado por globo conservado bajo "Ajustes avanzados"

⚠️ **Conflicto con PR #1**: ambos PRs tocan `server.ts` y la lógica de modo manual/proveedores,
pero PR #1 (HU02) ya implementó `/api/providers/status` con soporte multiproveedor real
(OpenRouter, DeepL, Tesseract.js) — el `/api/providers/status` de PR #2 es una versión
más simple (solo Gemini). Antes de mergear ambos hay que decidir cuál lógica de backend
queda y reaplicar el rediseño visual de PR #2 sobre la base de HU02, no al revés.

## Convención de ramas

`S{sprint}-HU{hu}-{descripción}` (sin `T{tarea}`, ver
`~/.claude/projects/-home-apuru/memory/feedback-git-naming-authorship.md`).
Ramas ya pusheadas antes del cambio de convención (`HU02-feature-...`) no se
renombran retroactivo.

## Backlog priorizado

### P0 — Cerrar HU02 y resolver conflicto con rediseño visual
- [ ] Revisar y mergear PR #1
- [ ] Probar con página real de cómic, comparar calidad entre proveedores
- [ ] Decidir orden de merge entre PR #1 (HU02, backend multiproveedor) y PR #2
      (rediseño Nocturne) — probablemente mergear #1 primero y reaplicar el
      CSS/layout de #2 sobre esa base para no perder el sistema multiproveedor

### P1 — Próximo bloque (candidatos, sin priorizar aún)
- [ ] Exportación batch con progreso visual (ya existe `jszip`, falta UI de progreso)
- [ ] Métricas reales de calidad OCR: comparar transcripción del proveedor vs
      corrección manual del usuario, alimentar `capabilities.quality` (hoy
      estático) con datos de uso real
- [ ] Guía de uso ampliada con más casos de error documentados

### P2 — Futuro
- [ ] Multi-idioma de UI (hoy solo español)
- [ ] Historial de páginas procesadas (similar a scan-tracker-web)

## Decisiones pendientes
1. ¿Merge de PR #1 directo a `main`, o esperar testing manual con cómic real primero?
2. Métricas de calidad OCR: ¿vale la pena el esfuerzo de tracking, o es
   sobre-ingeniería para un proyecto de uso personal/pequeño grupo?

---

*Generado 2026-07-13, primera vez que TL2EDIT tiene blueprint en el vault.*
