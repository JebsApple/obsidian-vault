---
tags: [hyprland, lua, wayland, zen, picture-in-picture, waybar, playbook, scripting]
created: 2026-06-25
aliases: [Zen PiP desde script, hl.dsp.focus, dispatch lua hyprland]
---

# Hyprland (config provider Lua) + PiP de Zen desde scripts

> **Playbook reutilizable.** Cómo controlar ventanas de Hyprland desde un script
> externo cuando la config es **Lua** (`hyprland.lua`), y cómo disparar el
> Picture-in-Picture nativo de Zen/Firefox sin extensiones. Pensado para que un
> agente (opencode/Claude) replique la lógica en tareas similares.
> Relacionado: [[hyprland-setup]] · [[waybar-hyprland]] · [[lecciones]] · [[hyprland-lua-config]]

## TL;DR (lo accionable)

1. Con `configProvider: lua`, **`hyprctl dispatch <X>` evalúa `<X>` como Lua**
   (`hl.dispatch(<X>)`). La sintaxis clásica `focuswindow class:zen` revienta con
   `')' expected near 'class'` y **falla en silencio** si rediriges stderr.
2. Para **enfocar una ventana** desde un script:
   `hyprctl dispatch 'hl.dsp.focus({ window = "address:0x..." })'`
3. Para **disparar el PiP de Zen**: enfocar la ventana del video → inyectar
   `Ctrl+Shift+]` con `wtype` (cuenta como *user gesture*, requisito de
   `requestPictureInPicture()`). El float/pin lo da una `window_rule`.
4. **`wtype` NO dispara keybinds del compositor** → un keybind solo se prueba
   pulsándolo físicamente.

---

## 1. La trampa: `hyprctl dispatch` bajo provider Lua

Esta máquina usa la config Lua nativa (`~/.config/hypr/hyprland.lua`,
`configProvider: lua`). Editar el `.conf` no tiene efecto (ver [[hyprland-lua-config]]).
Efecto colateral poco documentado: **el subcomando `dispatch` de `hyprctl` cambia
de semántica** — ya no recibe la sintaxis clásica de dispatcher, sino una
**expresión Lua** que se envuelve en `hl.dispatch(...)`.

```bash
# ❌ clásico — FALLA en provider Lua
hyprctl dispatch focuswindow class:zen
#   error: return hl.dispatch(focuswindow class:zen):1: ')' expected near 'class'
#   → Note: dispatch in lua is a shorthand for hl.dispatch(...)

# ✅ Lua
hyprctl dispatch 'hl.dsp.focus({ window = "class:zen" })'
```

Si tu script tenía `... >/dev/null 2>&1`, el error se traga y **el focus nunca
ocurre**: cualquier `wtype` posterior aterriza en la ventana equivocada. Este fue
el bug exacto que rompió `zen-pip-toggle`. Mismo patrón que rompió el
posicionamiento de `hypr-player` (ver [[HyprPlayer-Audit]]).

## 2. La API Lua de dispatchers (`hl.dsp`)

`hl.dsp` es una tabla **curada**, NO un mapeo 1:1 de los dispatchers clásicos.
Claves de nivel superior observadas (Hyprland con Lua, jun 2026):

| `hl.dsp.*` | Qué es |
|-----------|--------|
| `exec_cmd` | exec (lanzar comando) |
| `exec_raw` | exec sin shell wrapping |
| `focus` | **enfocar / mover foco** |
| `send_key_state` | inyectar estado de tecla |
| `window` | subtabla: `close`(killactive), `float`(togglefloating), `fullscreen`, `alter_zorder`, … |

`hl.dsp.focus` espera **una tabla** con UNA de estas claves:
`direction | monitor | window | urgent_or_last | last`.

```lua
hl.dsp.focus({ window = "address:0x558595a522e0" })  -- por dirección (recomendado)
hl.dsp.focus({ window = "class:zen" })               -- por clase (primera que matchee)
hl.dsp.focus({ direction = "left" })                 -- mover foco
```

Desde un script externo se invoca envolviendo solo el dispatcher (hyprctl ya añade
`hl.dispatch(...)`):

```bash
hyprctl dispatch "hl.dsp.focus({ window = \"address:$addr\" })"
```

### Truco: inspeccionar la API Lua en runtime

Los headers (`/usr/include/hyprland/src/config/lua/`) solo listan *window-rule
effects*, no los nombres de dispatcher. Para enumerar cualquier tabla `hl.*` en
vivo, abusa de `error()` (su mensaje se imprime verbatim por hyprctl):

```bash
# claves de hl.dsp
hyprctl dispatch 'error("K="..table.concat((function() local t={} for k in pairs(hl.dsp) do t[#t+1]=k end table.sort(t) return t end)(),","))'

# averiguar la firma de un dispatcher: llámalo mal y lee el error
hyprctl dispatch 'hl.dsp.focus()'
#   error: hl.focus: expected a table, e.g. { direction = "left" }
hyprctl dispatch 'hl.dsp.focus({ x = 1 })'
#   error: hl.focus: unrecognized arguments. Expected one of: direction, monitor, window, urgent_or_last, last
```

Este patrón (`error()` + provocar errores de tipo) es la forma más rápida de
descubrir la API Lua cuando no hay docs locales.

## 3. Disparar el PiP de Zen/Firefox sin extensión

Hechos clave:
- El PiP es **interno al browser**: no hay disparador externo (ni D-Bus, ni MPRIS,
  ni CLI), y `requestPictureInPicture()` exige *transient user activation*.
- Zen/Firefox trae **atajo nativo: `Ctrl+Shift+]`** (Linux) que togglea el PiP del
  video relevante del **window/tab enfocado**.
- Una pulsación real inyectada con **`wtype`** SÍ cuenta como gesto de usuario.
- Las extensiones sin firmar están bloqueadas en Zen release
  (`xpinstall.signatures.required` no se puede desactivar) → la ruta extensión es
  inviable; la ruta atajo+wtype es la buena.

Por tanto la receta es: **enfocar la ventana de Zen que reproduce el video** →
`wtype` el atajo. El keysym de `]` es `bracketright`:

```bash
wtype -M ctrl -M shift -k bracketright -m shift -m ctrl
```

### Elegir la ventana correcta (no "Library" ni el propio PiP)

Si hay varias ventanas de Zen, hay que enfocar la del video. Señal primaria: el
**título MPRIS** del player (Zen reporta como `firefox.instance_*`) suele ser
substring del título de la ventana del video.

```bash
title=$(playerctl -p "$p" metadata --format '{{title}}')   # p = firefox.instance_*
addr=$(jq -r --arg k "${title:0:18}" \
   '.[]|select(.class=="zen" and (.title|contains($k)))|.address' <<<"$clients")
```
Fallback: excluir títulos `Library|Settings|New Tab|Picture-in-Picture`.

### La window_rule (float + pin) en hyprland.lua

El PiP sale en mosaico por defecto → forzar flotante y *pin* (visible en todos los
workspaces):

```lua
hl.window_rule({
    name  = "zen-pip-float",
    match = { title = "Picture-in-Picture" },
    float = true,
    pin   = true,
})
```

### El keybind (hyprland.lua)

```lua
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("/home/apuru/.local/bin/zen-pip-toggle"))
```

## 4. Caveat de testing: `wtype` no dispara keybinds del compositor

Verificado en este equipo: inyectar `SUPER+P` (o `SUPER+V`) con
`wtype -M logo -P <k> -m logo` **no activa el bind** — el modificador del teclado
virtual no entra al matcher de binds de Hyprland. Consecuencias para un agente:
- **No puedes validar un keybind de Hyprland de forma sintética.** Hay que pulsarlo
  físicamente.
- Sí puedes validar sin teclado: (a) correr el script directo, (b) correr el
  comando exacto del `on-click`/`exec_cmd`, (c) confirmar el registro con
  `hyprctl binds -j`.

## 5. Script de referencia (`~/.local/bin/zen-pip-toggle`)

```bash
#!/usr/bin/env bash
# Toggle del PiP nativo de Zen/Firefox sobre el video que se reproduce.
set -uo pipefail
clients=$(hyprctl clients -j 2>/dev/null) || exit 0

# 1. ventana de Zen con el video activo (por título MPRIS)
addr=""
for p in $(playerctl -l 2>/dev/null | grep -iE 'firefox|zen' || true); do
    title=$(playerctl -p "$p" metadata --format '{{title}}' 2>/dev/null || true)
    [ -z "$title" ] && continue
    addr=$(jq -r --arg k "${title:0:18}" \
        '.[]|select(.class=="zen" and (.title|contains($k)))|.address' \
        <<<"$clients" 2>/dev/null | head -1)
    [ -n "$addr" ] && break
done
# fallback: zen window que no sea chrome-page ni el propio PiP
[ -z "$addr" ] && addr=$(jq -r \
   '.[]|select(.class=="zen" and ((.title|test("^(Library|Settings|New Tab|Picture-in-Picture)";"i"))|not))|.address' \
   <<<"$clients" | head -1)
[ -z "$addr" ] && addr=$(jq -r '.[]|select(.class=="zen")|.address' <<<"$clients" | head -1)
[ -z "$addr" ] && exit 0

# 2. enfocar (API Lua) y esperar foco real
hyprctl dispatch "hl.dsp.focus({ window = \"address:$addr\" })" >/dev/null 2>&1 || exit 0
for _ in $(seq 1 25); do
    [ "$(hyprctl activewindow -j 2>/dev/null | jq -r '.address // empty')" = "$addr" ] && break
    sleep 0.03
done

# 3. inyectar Ctrl+Shift+]
wtype -M ctrl -M shift -k bracketright -m shift -m ctrl
```

Lo llaman: el bind `SUPER+P` y el `on-click` del módulo `custom/mpris-yt` de Waybar.
Los otros módulos MPRIS no usan PiP: `custom/mpris-music` (♪) →
`hypr-player --player music`; `custom/mpris-vlc` (cono) → `hypr-player --player vlc`.

## 6. Comandos de verificación

```bash
# ¿abrió/cerró el PiP?
hyprctl clients -j | jq -r '.[]|select(.title|test("Picture-in-Picture";"i"))|"\(.floating) \(.pinned) \(.at) \(.size)"'

# ¿está registrado el bind? (modmask 64 = SUPER)
hyprctl binds -j | jq -r '.[]|select(.key=="P" and .modmask==64)|.dispatcher'

# ¿Zen expone MPRIS? (solo cuando hay media con MediaSession)
playerctl -l ; playerctl status

# probar el dispatcher de focus aislado
hyprctl dispatch 'hl.dsp.focus({ window = "class:zen" })'
```

## Dependencias

`hyprctl`, `jq`, `playerctl`, `wtype`. Layout del teclado es irrelevante: `wtype`
sube su propio keymap (probado con `latam`).

## Backups de esta sesión

- `~/.config/hypr/bak/hyprland.lua.20260625-2125`
- `~/.config/hypr/bak/zen-pip-toggle.20260625-2125`
