---
created: 2026-07-11
tags:
  - tipo/zettel
  - tech/opencode
aliases:
  - opencode sandbox
  - MCP sandbox
---

# opencode-sandbox: probar MCPs sin romper la config

## Lo que aprendí
Un MCP server mal configurado puede impedir que opencode arranque (obligando a editar `opencode.json` manualmente con `nano`). Flujo seguro: `opencode-sandbox init` → `add` → `test` → `apply` (solo si test pasa). Backup automático antes de apply. Restaurar con `restore-opencode-config` si algo sale mal.

## Contexto
2026-07-07. El MCP de WhatsApp rompió opencode al reiniciar porque el server Python falló al arrancar.

## Aplicación
NUNCA modificar `opencode.json` directamente para MCPs experimentales. Usar sandbox siempre. Tener backup antes de apply.

## Conexiones
- [[whatsapp-mcp-rompe-opencode]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
