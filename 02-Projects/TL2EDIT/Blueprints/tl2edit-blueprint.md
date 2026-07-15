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

## Convención de ramas

`S{sprint}-HU{hu}-{descripción}` (sin `T{tarea}`, ver
`~/.claude/projects/-home-apuru/memory/feedback-git-naming-authorship.md`).
Ramas ya pusheadas antes del cambio de convención (`HU02-feature-...`) no se
renombran retroactivo.

## Backlog priorizado

### P0 — Cerrar HU02
- [ ] Revisar y mergear PR #1
- [ ] Probar con página real de cómic, comparar calidad entre proveedores

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
