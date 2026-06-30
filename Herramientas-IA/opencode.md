---
tags: [opencode, configuracion, mcp]
---

# opencode en este vault

opencode es un asistente de terminal tipo Claude Code pero open-source. Usa el mismo servidor MCP (`obsidian-mcp`) para leer y escribir en este vault.

## Cómo interactúa opencode con el vault

- **Lee** notas via MCP para mantener contexto entre sesiones
- **Escribe** en `Knowledge/[[lecciones]].md` cuando aprende algo nuevo
- **Crea notas** en `Knowledge/` o `Projects/` según lo que se necesite

## Configuración local

opencode está disponible en esta máquina (Linux). Su configuración con los MCP servers está en `~/.config/opencode/opencode.jsonc`.

## Reglas inamovibles

### Nomenclatura de ramas (GitHub / Gitea)

Formato OBLIGATORIO: `S{sprint}-HU{hu}-T{tarea}-{descripcion-en-español}`

Ejemplos: `S3-HU02-T01-navegacion-barra-lateral`, `S2-HU03-T05-fix-jwt`

**Prohibido:** prefijos `feat/`, `fix/`, `chore/` u otros antes del nombre.

### Autoría

- Prohibido incluir co-autoría o atribución al asistente IA en commits o PRs.
- Todo el trabajo es única y estrictamente del usuario.

## Diferencia con Claude Code

| Aspecto | opencode | Claude Code |
|---------|----------|-------------|
| Licencia | Apache 2.0 | Propietaria |
| Costo | Gratuito vía API keys propias | Por suscripción |
| CLI | `opencode` | `claude` |
| MCP | Misma interfaz | Misma interfaz |
