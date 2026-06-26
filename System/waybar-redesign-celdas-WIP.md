---
tags: [hyprland, waybar, lua, wayland, zen, picture-in-picture, redesign, WIP, playbook, scripting]
created: 2026-06-26
aliases: [Waybar celdas, rediseño módulos waybar, waybar hover celdas, SUPER+SHIFT+B toggle]
status: in-progress
---

# Waybar — rediseño "celdas" + fix PiP (TAREA EN CURSO)

> **HANDOFF para continuar.** Sesión cortada por límite de uso (2026-06-26).
> Esta nota tiene TODO lo necesario para retomar sin re-explorar.
> Relacionado: [[waybar-hyprland]] · [[hyprland-lua-dispatch-y-zen-pip]] · [[hyprland-lua-config]] · [[lecciones]]

## 0. Qué pidió el usuario (2 entregables)

1. **Rediseñar los módulos interactivos de la Waybar** (grupo derecho) con un
   sistema de **distribución por celdas** moderno, estable, sin layout shift,
   estilo Claude AI. Requisitos exactos del usuario:
   - El **reloj central NUNCA se mueve** (restricción dura).
   - La barra se divide en 2 mitades; la **mitad derecha** se reparte en **N celdas
     iguales** (N = nº de módulos de estado). Cada celda tiene su icono **centrado**,
     con margen virtual a ambos lados; la separación se mide **entre celdas, no entre iconos**.
   - Al hover de un módulo: **el icono NO se mueve**, solo aparece el texto, que
     nace desde el icono y ocupa el espacio libre. Prioridad de crecimiento:
     (a) espacio libre de su propia celda → (b) margen reservado de la celda
     siguiente → (c) empujar levemente solo al módulo siguiente (nunca a los demás).
   - Texto muy largo → **marquee/rotativo** (como ya hace hypr-player), sin romper layout.
   - Animaciones suaves estilo Claude AI; espaciado **proporcional al viewport**
     (resolución-independiente), no px absolutos.
   - **Refinamiento clave del usuario**: *"la celda del módulo debe ser independiente
     del botón en sí"* → celda (contenedor ancho fijo) y botón (píldora con icono/texto)
     son DOS capas distintas.
   - **Toggle `SUPER+SHIFT+B`** entre la config actual (classic) y el rediseño (claude).
     La actual queda intacta como fallback. (Ojo: `SUPER+CTRL+B` es el toggle
     modern/legacy existente; `ALT+SHIFT+B` es float-toggle. `SUPER+SHIFT+B` está LIBRE.)

2. **Arreglar el PiP de Zen** que sale en **mosaico** en vez de flotante con tamaño
   prudente. (Ver §3 — ya casi resuelto.)

## 1. Decisión de arquitectura (YA TOMADA)

**Enfoque A — Waybar nativo** (no widget GTK propio). Razones: bajo riesgo,
toggleable, reusa daemon+scripts, reloj ya inmóvil por `gtk_box_set_center_widget`.
Limitación aceptada: el empuje progresivo al vecino es difícil en el box-model GTK;
se aproxima con **celdas de ancho fijo + marquee**. El usuario lo aprobó CON el
refinamiento "celda ≠ botón".

**Cómo se logra "celda ≠ botón" en Waybar:** envolver cada módulo en un `group`
(la CELDA: `min-width` fijo, fondo transparente, define separación + zona hover) con
el módulo dentro (el BOTÓN: `#custom-xxx`, fondo/píldora, border-radius, icono+texto).
Dos niveles estilizables: `#nombre-grupo` (celda) y `#custom-xxx` (botón).
El botón crece dentro de la celda de ancho fijo → **sin reflow, reloj inmóvil**.

**Hover por módulo (no global):** las celdas son ancho-fijo y tilean la mitad
derecha → posiciones DETERMINISTAS. El daemon mapea `cursor_x → índice de celda`
y escribe el módulo bajo el cursor en un state file. Layout: `modules-right =
[ grupo-celdas..., tray ]`, tray con ancho fijo (min-width) anclado al borde
derecho; band_right = bar_x + bar_w − margin − tray_w; cell i (0=más a la derecha)
ocupa `[band_right−(i+1)·cell_w, band_right−i·cell_w]`. El generador escribe
`cell_w`, orden y `tray_w` a un JSON que lee el daemon → daemon genérico.

## 2. ESTADO de cada subtarea (tasks #1–#7)

- **#1 Fix PiP** — CASI HECHO. Regla `float+pin` ya añadida a `hyprland.lua` (§3).
  Falta: (opcional) regla `size/move` y **recargar Hyprland** para activar.
- **#2 Generador de celdas** — NO EMPEZADO. Script `waybar-cells-gen`:
  lee `hyprctl monitors -j` (ancho del monitor activo), N módulos y orden,
  calcula `cell_w = (ancho/2)/N`, escribe `~/.local/state/waybar-cells.json`
  `{order:[...], cell_w, tray_w, monitor_w}` + un CSS generado con `min-width:cell_w`
  por celda (p.ej. `~/.config/waybar/cells.generated.css` importado por style.claude.css).
- **#3 Daemon hover por celda** — NO EMPEZADO. Nuevo `waybar-cells-daemon` (NO tocar
  el `waybar-hover-daemon` global que usa el modo legacy). Reusar la lógica de
  `get_waybar_zones()`/`get_cursor()` del daemon actual (leído abajo). Mapear
  cursor→celda y escribir nombre de módulo en `~/.local/state/waybar-hover-cell`.
  Refrescar con `SIGRTMIN+1` (mismo mecanismo).
- **#4 config.claude + style.claude.css** — NO EMPEZADO. `group` por celda + tray
  ancho fijo. CSS: decoupling celda/botón, `transition` suave en `min-width`/`padding`
  (GTK CSS soporta transitions → ahí están las animaciones "Claude AI"), clases de
  marquee, icono anclado (probar `padding-left` fijo / left-align del label).
- **#5 Scripts de render** — NO EMPEZADO. Por módulo: leer `waybar-hover-cell`,
  emitir icono / icono+texto / marquee. **Reusar la lógica char-scroll de
  `~/.local/bin/mpris-yt`** (WIDTH, FPS=20, CHARS_PER_SEC=6, buffer repetido,
  `build_ticker`) — ya documentada y probada. Solo el módulo bajo el cursor revela texto.
- **#6 Toggle SUPER+SHIFT+B** — NO EMPEZADO. Script `toggle-waybar-design` (espejo de
  `toggle-waybar-mode`, ver patrón abajo) que copia el set classic↔claude, arranca el
  daemon correcto y reinicia waybar. Bind en `hyprland.lua`:
  `hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("/home/apuru/.local/bin/toggle-waybar-design"))`.
- **#7 Verificar en vivo** — NO EMPEZADO. Validar: waybar arranca, toggle va y viene,
  reloj no se mueve, hover por celda mapea bien (ajustar cell_w/inset), marquee corre,
  PiP flota. Captura con `grim` para inspeccionar (hover es transitorio).

## 3. Fix PiP — estado exacto

YA EDITADO en `/home/apuru/.config/hypr/hyprland.lua` (sección WINDOW RULES nueva,
antes de KEYBINDINGS). Regla activa (idéntica al backup que funcionaba):

```lua
hl.window_rule({
    name  = "zen-pip-float",
    match = { title = "Picture-in-Picture" },
    float = true,
    pin   = true,
})
```

**Para ACTIVARLO**: `hyprctl reload` (o relogin). Esto solo arregla el "sale en
mosaico". El tamaño por defecto del PiP de Firefox/Zen ya es razonable una vez flota.

**Pendiente opcional (size/move):** dejé un TODO en el .lua. `size` y `move` SÍ son
efectos válidos (`/usr/include/hyprland/src/config/lua/bindings/LuaBindingsInternal.hpp`
líneas 59–60: `WINDOW_RULE_EFFECT_MOVE/SIZE`, tipo `CLuaConfigExpressionVec2`).
Falta confirmar la **forma del literal**: el ejemplo oficial (`Emergency.hpp`) usa
STRING → `move = "20 monitor_h-120"`, `float = true`. Probar:
```lua
hl.window_rule({ name="zen-pip-size", match={title="Picture-in-Picture"},
                 size = "30% 30%", move = "68% 67%" })
```
y recargar; si rompe la config, usar px/expresiones en vez de `%`. NO dejar sin
verificar (un literal malo rompe el reload entero).

Verificar PiP: `hyprctl clients -j | jq -r '.[]|select(.title|test("Picture-in-Picture";"i"))|"\(.floating) \(.pinned) \(.at) \(.size)"'`

## 4. Inventario del sistema actual (para no re-explorar)

**Modo activo:** legacy (daemon global). Toggle modern/legacy: `toggle-waybar-mode`.

**`modules-right` (legacy, orden actual):**
`custom/pulseaudio, custom/brightness, custom/resources, custom/updates,
custom/network, custom/bluetooth, custom/mpris-yt, custom/mpris-music,
custom/mpris-vlc, custom/battery, tray`
(modern los invierte). `modules-center = [custom/clock]` (GTK lo ancla → inmóvil
si tiene ancho fijo; el CSS modern ya le pone `min-width:200px`).

**Daemon global** `~/.local/bin/waybar-hover-daemon` (Python, 100 líneas): obtiene
rect de la barra por monitor vía `hyprctl layers -j` (namespace=="waybar", margin=15),
cursor vía `hyprctl cursorpos`; escribe "1"/"0" en `~/.local/state/waybar-hover-group`;
refresca con `SIGRTMIN+1` (`pidof waybar`); hysteresis LEAVE_DELAY_S=0.5; poll 20Hz.
**REUSAR sus funciones `get_waybar_zones()`, `get_cursor()`, `inside()`, `signal_waybar()`
para el nuevo `waybar-cells-daemon`.**

**Marquee ya existente (2 sabores REUTILIZABLES):**
- **char-scroll** en `~/.local/bin/mpris-yt|music|vlc`: WIDTH=29, FPS=20,
  CHARS_PER_SEC=6, FRAMES_PER_CHAR=3, `build_ticker(t)=" "+t+"  •  "`, buffer
  `scroll*max(3, WIDTH//len+3)`, scrollea solo si `hover AND len(full)>WIDTH`.
  → ESTE es el fácil de reusar en scripts de celdas.
- **pixel-scroll Cairo suave** clase `MarqueeLabel` en `~/.local/bin/hypr-player`
  (MARQUEE_PX=0.9/16ms≈56px/s, pausa MARQUEE_PAUSE=70 ticks en bordes, fade rails 22px).
  → solo si algún día se va a Enfoque B (widget GTK).

**Scripts render existentes (patrón a imitar):** colapsado emite
`{"text":"<span foreground='#hex' font_size='10pt'>ICON</span>","tooltip":...}`,
expandido `{"text":"<span ...>ICON</span> TEXTO","class":"expanded"}`. Legacy lee
`waybar-hover-group=="1"`; modern lee `waybar-hover-module==<nombre>`. El rediseño
leerá `waybar-hover-cell==<nombre>`.

**Patrón toggle (espejar en `toggle-waybar-design`):** ver `~/.local/bin/toggle-waybar-mode`
— copia `config.<modo>`→`config`, `style.<modo>.css`→`style.css`, scripts del set
a `~/.local/bin/`, `echo modo > state`, `systemctl --user restart <daemon>`,
`killall -q waybar; sleep 0.3; waybar &`.

**Colores (Catppuccin Mocha):** pulseaudio #a6e3a1, battery #fab387, network #89b4fa,
bluetooth #89dceb, mpris-yt/music #cba6f7, mpris-vlc #fab387, clock #b4befe.

## 5. Archivos clave

| Archivo | Rol |
|---------|-----|
| `~/.config/waybar/config` (legacy activo) · `config.legacy` · `config.modern` | configs |
| `~/.config/waybar/style.css` · `style.legacy.css` · `style.modern.css` | CSS |
| `~/.config/waybar/legacy-scripts/` · `modern-scripts/` | scripts por modo |
| `~/.local/bin/waybar-hover-daemon` | daemon global (NO tocar) |
| `~/.local/bin/toggle-waybar-mode` | toggle modern/legacy (patrón a imitar) |
| `~/.local/bin/mpris-{yt,music,vlc}` | marquee char-scroll a reusar |
| `~/.local/bin/hypr-player` | MarqueeLabel Cairo (ref Enfoque B) |
| `~/.config/hypr/hyprland.lua` | YA editado: WINDOW RULES (PiP) |
| `~/.config/systemd/user/waybar-hover-daemon.service` | unit del daemon |

**Archivos NUEVOS a crear (rediseño):** `~/.local/bin/waybar-cells-gen`,
`~/.local/bin/waybar-cells-daemon`, `~/.config/waybar/config.claude`,
`~/.config/waybar/style.claude.css`, `~/.config/waybar/claude-scripts/`,
`~/.local/bin/toggle-waybar-design`, `~/.config/systemd/user/waybar-cells-daemon.service`,
state: `~/.local/state/waybar-hover-cell`, `~/.local/state/waybar-cells.json`,
`~/.local/state/waybar-design` (classic/claude).

## 6. Backup de esta sesión (restaurar si algo se rompe)

`~/.config/waybar/bak/20260625-2357-redesign/` — incluye waybar/{config,styles,scripts},
bin/{waybar-hover-daemon,toggle-waybar-mode,hypr-player,zen-pip-toggle,mpris-*},
systemd/, hypr/hyprland.lua (PRE-edición PiP).
Backup previo del .lua con la regla PiP: `~/.config/hypr/bak/hyprland.lua.20260625-2125`.

## 7. Caveats (de [[hyprland-lua-dispatch-y-zen-pip]] y esta sesión)

- Config Hyprland es **Lua** (`hyprland.lua`); editar `.conf` no hace nada. `hyprctl
  dispatch <X>` evalúa `<X>` como Lua. (Ver [[hyprland-lua-config]].)
- **sudo NO funciona** desde la Bash tool del agente; pedir al usuario que corra `! cmd`.
- `wtype` NO dispara keybinds del compositor → un bind solo se valida pulsándolo físico.
- El "modern" mode lee `waybar-hover-module` PERO el daemon global actual solo escribe
  `waybar-hover-group` → el per-module del modern probablemente no funciona hoy; por eso
  el rediseño usa su PROPIO daemon de celdas.
- Empuje progresivo real al vecino + icono 100% clavado = solo con Enfoque B (Cairo).
  En Enfoque A se aproxima (icono se recentra dentro de su celda; cero reflow global).

## 8. Próximo paso inmediato al retomar

1. `hyprctl reload` y verificar PiP flota (cerrar tarea #1).
2. Implementar #2 (generador) → #3 (daemon celdas) → #4 (config/CSS) → #5 (scripts)
   → #6 (toggle+bind) → #7 (verificar). Construir el set `claude` SIN tocar el
   set activo (toggle lo activa) para mantener bajo riesgo.
