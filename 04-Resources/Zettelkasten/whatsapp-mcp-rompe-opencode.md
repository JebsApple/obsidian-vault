---
created: 2026-07-11
tags:
  - tipo/zettel
  - tech/opencode
aliases:
  - WhatsApp MCP crash
  - MCP rompe opencode
---

# MCP mal configurado puede impedir que opencode arranque

## Lo que aprendí
Si un MCP server Python falla al arrancar (uv no en PATH, dependencias faltantes), opencode no carga y no hay forma de deshabilitar el MCP desde la UI. Solución: editar `opencode.json` manualmente para remover el entry. Prevenir: usar `opencode-sandbox` para probar MCPs antes de agregarlos a producción.

## Contexto
2026-07-07. El MCP de WhatsApp (`verygoodplugins/whatsapp-mcp`) rompió opencode al reiniciar.

## Aplicación
Siempre probar MCPs en sandbox antes de agregarlos a la config. Tener un plan de recuperación (editar json manualmente) si opencode no arranca.

## Conexiones
- [[opencode-sandbox-mcp]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
