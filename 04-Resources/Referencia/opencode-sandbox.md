---
tags: [referencia/opencode, herramienta/sandbox]
---

# opencode-sandbox

Flujo para probar MCPs experimentales sin tocar producción.

```bash
opencode-sandbox init              # copia config actual como base
opencode-sandbox add <name> <cmd>  # agrega MCP al sandbox
opencode-sandbox test              # verifica que cada MCP arranque
opencode-sandbox diff              # compara sandbox vs produccion
opencode-sandbox apply             # promueve a produccion (auto-backup)
opencode-sandbox rm <name>         # elimina MCP del sandbox
```

## Scripts relacionados

| Comando | Descripción |
|---------|-------------|
| `backup-opencode-config` | Backup tar.gz con timestamp |
| `restore-opencode-config` | Menú interactivo para restaurar backups |

## Regla fija

- **NO** modificar `~/.config/opencode/opencode.json` directo para experimentos
- Usar sandbox siempre
- `backup-opencode-config` antes de `apply`
