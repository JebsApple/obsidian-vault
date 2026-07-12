---
kanban-plugin: board
tags: [kanban, sprint]
created: 2026-07-11
sprint: "2"
status: pendiente
---

# Sprint 2 — Polish + TypeR Export

> **Objetivo:** Pulir UI/UX + exportar script .docx compatible con TypeR para Photoshop.
> **Entregable:** Design system consistente + export DOCX con tipos de globo y orden configurable.
> **Dependencias nuevas:** `docx` (npm, para generación de .docx).

%% kanban:settings
{"kanban-plugin":"board","list-collapse":[false,false,false,false]}
%%

## Pendiente
- [ ] 📝 8B: Componentes unificados → Sonnet → `src/components/ui/`
  - Button, Input, Badge, Modal reutilizables
  - tokens.css: colores zinc/emerald, spacing x4, typography
- [ ] 📝 8C: Interacciones y transiciones → Haiku → múltiples
  - Hover glow, active scale, panel slide-in, skeleton loaders
  - Drag blocks smooth, snap to grid opcional
- [ ] 📝 9A: Panel de botones tipo de globo → Sonnet → `types.ts`, `BalloonTypeBar.tsx`
  - 13 tipos configurables con botones (no dropdown)
  - Auto-detección de símbolos desde prefijo (manual > auto)
  - Toggle "Asignar símbolos con IA"
  - Badge con símbolo en canvas overlay
- [ ] 📝 9B: Reordenamiento de bloques → Sonnet → `BlockListPanel.tsx`
  - Drag & drop para controlar orden del script
  - Números de orden visibles en canvas
- [ ] 📝 9C: Backend generador .docx → Sonnet → `server/export/docx.ts`
  - Dep: `docx` npm package
  - Formato: `[order] (tipo)\n\ntexto` con símbolos por tipo
  - Regla del guión: `-` solo en primera frase tras cambio de fuente
  - Endpoint: `POST /api/export/docx`
- [ ] 📝 9D: Panel exportación + preview → Haiku → `DocxExportPanel.tsx`
  - Preview del script formateado antes de exportar
  - Título del capítulo, opciones (incluir original, coordenadas)
- [ ] 📝 9E: Config de símbolos por usuario → Haiku → `settings.ts`, `SettingsPanel.tsx`
  - Tabla editable con símbolo por tipo de globo
  - Preview actualiza en tiempo real

## En Progreso


## Review


## Hecho ✅
- [x] Gate: tsc --noEmit + npm run build

---

### Sprint 2 — Checklist de aceptación
- [ ] Design system: todos los componentes usan tokens
- [ ] Transiciones en hover, active, panel transitions
- [ ] Selector de tipo de globo por bloque con badges
- [ ] Drag & drop para reordenar bloques
- [ ] Export .docx con formato correcto por tipo
- [ ] Preview del script antes de exportar
- [ ] Símbolos configurables por usuario
- [ ] .docx compatible con TypeR multi-bubble paste
- [ ] `npm run build` sin errores
