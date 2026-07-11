---
created: 2026-07-11
tags:
  - tipo/zettel
  - tech/hyprland
aliases:
  - hyprland lua
  - config lua
---

# Hyprland 0.55+ usa config Lua, no .conf

## Lo que aprendí
Hyprland 0.55 en CachyOS requiere config en Lua (`.lua`). El `.conf` es deprecated. Hyprland busca automáticamente `hyprland.lua`. Los archivos `.conf`, `monitors.conf/.lua`, `workspaces.conf/.lua` quedan huérfanos si no se hacen `require` desde el `.lua`. Editar el `.conf` no hace nada.

## Contexto
2026-06-20 en CachyOS. Se perdía tiempo editando archivos que no eran la config activa.

## Aplicación
Al configurar Hyprland 0.55+: verificar `hyprctl binds` para confirmar qué config está activa. La fuente de verdad es el archivo que Hyprland carga (`.lua`). Si hay duda: `luac -p hyprland.lua` para validar syntax.

## Conexiones
- [[hyprland-dispatchers-argumentos-lua]]
- [[hyprland-flotar-gtk-layershell]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
