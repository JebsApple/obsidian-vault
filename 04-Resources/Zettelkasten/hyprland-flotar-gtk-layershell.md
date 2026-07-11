---
created: 2026-07-11
tags:
  - tipo/zettel
  - tech/hyprland
aliases:
  - GtkLayerShell
  - flotar ventana
  - layer-shell
---

# GtkLayerShell: la forma correcta de flotar GTK en Hyprland 0.55

## Lo que aprendí
Window rules (`windowrulev2`) y `hyprctl dispatch togglefloating` están rotos en Hyprland 0.55. La solución correcta para ventanas GTK es GtkLayerShell: `GtkLayerShell.init_for_window(win)` antes de `show_all()`. Flota nativamente, sin window rules. Anclar a dos bordes adyacentes (BOTTOM+RIGHT) + `set_margin` para snap-to-corner. Requiere backend Wayland nativo (`GDK_BACKEND=wayland`).

## Contexto
2026-06-21 y 2026-06-23 en Hyprland. hypr-player necesitaba ser flotante y no había forma confiable de lograrlo.

## Aplicación
Para cualquier ventana GTK que necesite flotar en Hyprland 0.55: usar GtkLayerShell en vez de window rules. La superficie aparece en `hyprctl layers` (no en `hyprctl clients`). Estilizar con `layerrule`.

## Conexiones
- [[hyprland-dispatchers-argumentos-lua]]
- [[hyprland-config-lua]]
- [[waybar-css-hover-per-module]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
