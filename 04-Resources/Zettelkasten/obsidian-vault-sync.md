---
created: 2026-07-11
tags:
  - tipo/zettel
  - tech/obsidian
aliases:
  - vault sync
  - obsidian git
---

# Sincronización del vault: git + systemd timer + plugin Obsidian Git

## Lo que aprendí
Combinación de 3 capas para sync del vault: git push/pull manual (`vsync`), systemd timer cada 5 min (auto-commit + push), y plugin Obsidian Git cada 10 min desde la UI. `vsync` es para sync manual sin gastar tokens de AI. Solo usar Claude/opencode si hay conflictos de merge.

## Contexto
2026-06-18. Se configuró la sincronización automática del vault entre máquinas.

## Aplicación
Para sincronizar Obsidian entre dispositivos: capas de redundancia (manual + timer + plugin). Mantener un alias de sync rápido para uso diario.

## Conexiones
- [[opencode-sandbox-mcp]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
