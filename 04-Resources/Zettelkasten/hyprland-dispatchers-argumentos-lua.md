---
created: 2026-07-11
tags:
  - tipo/zettel
  - tech/hyprland
aliases:
  - dispatchers lua
  - dispatch roto
---

# Hyprland dispatchers interpretan argumentos como Lua en 0.55

## Lo que aprendí
`hyprctl dispatch togglefloating address:0x...` falla porque el IPC envuelve los args en `hl.dispatch(...)` y los parsea como Lua — selectores clásicos (`address:`, `title:`) son sintaxis inválida. Incluso `togglefloating` pelado falla. La API Lua correcta es `hl.dsp.focus({ window = "address:0x..." })` con tablas.

## Contexto
2026-06-23 y 2026-06-25 en Hyprland. Se descubrió al intentar hacer flotar hypr-player y al arreglar el focus de PiP.

## Aplicación
No depender de `hyprctl dispatch` con selectores de ventana en Hyprland 0.55+. Usar la API Lua directa o GtkLayerShell para ventanas GTK. Para inspeccionar la API: usar `error("K="..table.concat(...))` en dispatch.

## Conexiones
- [[hyprland-config-lua]]
- [[hyprland-flotar-gtk-layershell]]
- [[zen-pip-wtype-gesto]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
