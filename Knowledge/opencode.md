---
tags: [opencode, configuracion, mcp]
---

# opencode en este vault

opencode es un asistente de terminal tipo Claude Code pero open-source. Usa el mismo servidor MCP (`obsidian-mcp`) para leer y escribir en este vault.

## Cómo interactúa opencode con el vault

- **Lee** notas via MCP para mantener contexto entre sesiones
- **Escribe** en `Knowledge/lecciones.md` cuando aprende algo nuevo
- **Crea notas** en `Knowledge/` o `Projects/` según lo que se necesite

## Configuración local

opencode está disponible en esta máquina (Linux). Su configuración con los MCP servers está en `~/.config/opencode/opencode.jsonc`.

## Diferencia con Claude Code

| Aspecto | opencode | Claude Code |
|---------|----------|-------------|
| Licencia | Apache 2.0 | Propietaria |
| Costo | Gratuito vía API keys propias | Por suscripción |
| CLI | `opencode` | `claude` |
| MCP | Misma interfaz | Misma interfaz |
