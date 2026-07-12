---
created: 2026-07-12
tags:
  - referencia/claude
  - referencia/opencode
  - referencia/plugins
  - referencia/skills
  - referencia/guia
---

# Instalación Completa — Plugins, Skills y Herramientas

Guía unificada de todo lo descubierto y configurado en la sesión del 2026-07-12.

---

## 1. Fable Skills (ya instalados)

**Ubicación:** `~/.claude/skills/fable-*/`

| Skill | Propósito |
|-------|-----------|
| `fable-chequeo-seguridad` | Auditoría de seguridad del código |
| `fable-arranque` | Arranque rápido de proyectos |
| `fable-plan` | Planificación de sprints/proyectos |
| `fable-abogado-del-diablo` | Revisión adversarial de decisiones |
| `fable-fixer` | Reparación de bugs y problemas |

**No requiere instalación adicional.** Ya están en el sistema.

---

## 2. Superpowers

**Qué hace:** Piloto automático para código — subagentes, TDD, debugging, brainstorming visual, skills discovery.

### Instalar en OpenCode

Agregar a `~/.config/opencode/opencode.json` en el array `plugin`:

```json
{
  "plugin": [
    "superpowers@git+https://github.com/obra/superpowers.git"
  ]
}
```

Reiniciar opencode. Verificar con: "Tell me about your superpowers"

### Instalar en Claude Code

```bash
/plugin install superpowers@claude-plugins-official
```

### Uso

Desde opencode: `use skill tool to list skills`
Desde Claude Code: los skills se cargan automáticamente o con `/skill`

---

## 3. Memoria Persistente (claude-mem / opencode-mem)

**Qué hace:** Recuerda contexto entre sesiones — decisiones, patrones, preferencias del proyecto.

### Instalar en OpenCode (opencode-mem)

```json
{
  "plugin": ["opencode-mem"]
}
```

Reiniciar opencode. Crea SQLite local en `~/.opencode-mem/`.

**Configuración del provider de auto-capture** (recomendado: usar el provider ya autenticado en opencode):

```json
{
  "opencodeProvider": "anthropic",
  "opencodeModel": "claude-haiku-4-5-20251001"
}
```

**Comandos útiles:**
- `/mem-search <query>` — buscar en memoria
- `/mem-save <texto>` — guardar un hecho
- `/mem-status` — estado de la memoria

### Instalar en Claude Code (claude-mem)

```bash
/plugin install claude-mem@thedotmack
```

**Requiere worker corriendo:** `~/.claude-mem/worker start`
Puerto: 37777

---

## 4. Claude Automation Recommender

**Qué hace:** Analiza tu código y recomienda automatizaciones (CI/CD, hooks, testing).

### Instalar en Claude Code

```bash
/plugin install claude-code-setup@claude-plugins-official
```

### Equivalente en OpenCode

No hay equivalente directo. Alternativas útiles:
- **Dynamic Context Pruning** — reduce tokens podando contexto obsoleto
- **Envsitter Guard** — protege archivos `.env` de ediciones accidentales

Para instalar DCP en OpenCode:
```json
{
  "plugin": ["opencode-dynamic-context-pruning"]
}
```

---

## 5. Otros Plugins Útiles para OpenCode

| Plugin | Propósito | Instalación |
|--------|-----------|-------------|
| `opencode-mem` | Memoria persistente | `"plugin": ["opencode-mem"]` |
| `opencode-dynamic-context-pruning` | Ahorro de tokens | `"plugin": ["opencode-dynamic-context-pruning"]` |
| `opencode-notify` | Notificaciones OS al terminar tareas | `"plugin": ["opencode-notify"]` |
| `superpowers` | Subagentes + skills | `"plugin": ["superpowers@git+https://github.com/obra/superpowers.git"]` |

---

## 6. MCPs Ya Configurados (opencode)

Verificados en `~/.config/opencode/opencode.json`:

| MCP | Estado | Propósito |
|-----|--------|-----------|
| obsidian | ✅ | Leer/escribir vault |
| dagu | ✅ | DAG workflows |
| context7 | ✅ | Docs de librerías |
| github | ✅ | Operaciones GitHub |
| playwright | ✅ | Browser automation |
| packet-tracer | ✅ | Cisco PT |
| postgres | ⏸️ | Deshabilitado |

---

## 7. Referencia Rápida

**Archivos en el vault:**
- `~/Vault/04-Resources/Referencia/fragmento-de-fable.md` — 5 manuales Fable
- `~/Vault/04-Resources/Referencia/fable-skills-prompts.md` — Skills + prompts
- `~/Vault/04-Resources/Referencia/claude-ecosistema-descubrir.md` — Catálogo completo del ecosistema
- `~/Vault/04-Resources/Referencia/instalacion-completa-plugins-skills.md` — Este archivo

**Skills Fable:** `~/.claude/skills/fable-*/`
**Plugins OpenCode:** `~/.config/opencode/opencode.json` → `"plugin": [...]`
**Plugins Claude Code:** `/plugin install <name>@<source>`

---

## Changelog

| Fecha | Cambio |
|-------|--------|
| 2026-07-12 | Creación inicial — Fable skills, Superpowers, mem, automation |
