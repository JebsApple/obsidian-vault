---
tags: [blueprint, planning, proyecto/refactor]
created: 2026-07-14
---

# Blueprint: Refactor CLAUDE.md + Nomenclatura GitHub

## Contexto

CLAUDE.md de opencode creció a 289 líneas monolíticas. Meta: 120 líneas con import refs (`@path`), contenido temático movido a `rules/`, `guides/`, `projects/`. Además: propuesta de nomenclatura consistente para los 12 repos GitHub (jebsapple).

## Fases

### Fase 1: Diseño y slim
- **Objetivo:** estructura de archivos definida y CLAUDE.md reducido.
- **Archivos a crear/modificar:**
  - Mapa de `rules/`, `guides/`, `projects/` (diseño, Opus)
  - `~/.config/opencode/CLAUDE.md` — 289→120 líneas con referencias `@path`
- **Verificación:** opencode arranca sin errores de config; contenido no perdido (diff temático).

### Fase 2: Archivos temáticos + nomenclatura
- **Objetivo:** contenido movido a archivos por tema; propuesta de renombres GitHub.
- **Archivos a crear/modificar:**
  - `rules/*.md`, `guides/*.md`, `CLAUDE.minegocio.md`
  - Documento de propuesta: renombres + plan de migración (12 repos)
- **Verificación:** cada regla vive en UN archivo (single-source); renombres solo con confirmación del usuario.

### Fase 3: Coherencia
- **Objetivo:** validar imports y referencias cruzadas.
- **Verificación:** grep de refs `@path` → todos los archivos existen; sin reglas duplicadas.

## Dependencias entre Fases

```
Fase 1 → Fase 2 → Fase 3
```

## Rollback Strategy

Backup de `~/.config/opencode/` antes de tocar (`backup-opencode-config`); restaurar con `restore-opencode-config`.
