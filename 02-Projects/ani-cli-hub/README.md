---
tags:
  - project/active
  - proyecto/ani-cli-hub
  - linux/terminal
  - anime
status: active
repo: https://github.com/JebsApple/ani-cli-hub
local: ~/proyectos/ani-cli-hub
created: 2026-07-16
---

# ani-cli-hub — hub personal de anime en terminal

Fork de [ani-cli-mx](https://github.com/Gildedboy/ani-cli-mx) (fork de [ani-cli](https://github.com/pystardust/ani-cli)) convertido en hub personal: catálogo visual, favoritos, watchlist, notificaciones — todo en la terminal.

## Qué hace

- **Hub con tabs** (`anime`): `1 Catálogo · 2 Recientes · 3 Favoritos · 4 Lista · 5 Semana` — número salta directo, Tab cicla
- **Catálogo grid**: tarjetas con portada real (kitty graphics protocol), scroll continuo por región, responsive en vivo (SIGWINCH)
- **Recientes**: últimos episodios con thumbnail de video — Enter reproduce directo
- **Episodios con miniaturas** por capítulo + marca `★ último visto`
- **f/w en cualquier tarjeta**: favorito (♥) / ciclo pendiente→viendo→completado
- **Notificaciones**: timer systemd 30min avisa episodios nuevos de lo seguido

## Comandos

| Alias | Flag | Qué |
|---|---|---|
| `anime` | `--browse` | hub completo (tab Catálogo) |
| `anime-new` | `--recent` | hub en tab Recientes |
| `anime-favs` | `--favs` | hub en tab Favoritos |
| `anime-list` | `--watchlist` | hub en tab Lista |
| `anime-week` | `--schedule` | horario semanal por día |
| `anime-cont` | `--continue` | seguir del historial |

## Arquitectura (lo no-obvio)

- **Un solo archivo**: `ani-cli-mx-core` (~3400 líneas bash). Instalado en `/usr/lib/ani-cli-mx/`; fuente en `~/proyectos/ani-cli-hub/`. Deploy = `sudo cp` + `bash -n` antes.
- **`show_card_grid`**: renderer genérico de grid (data TSV `img\tl1\tl2\tpayload`). Imágenes como **unicode placeholders** de kitty → son celdas de texto → scrollean con `CSI S/T` (scroll real de región, no repaint). `--scale-up` llena el box.
- **`_cg_geom` top-level** (dynamic scoping) → testeable sin TUI. `CG_COLS/CG_ROWS` inyectan tamaño. Clamps: tarjeta siempre cabe; ≥2 filas si hay espacio.
- **Hooks del grid**: `CG_ON_KEY` (teclas f/w → nueva línea 2), `CG_TABS`/`CG_TAB_ACTIVE` (barra de tabs, retorna `TAB:n`).
- **Fuentes**: jkanime primario, animeav1 fallback, allanime último (animeflv de capa caída 2026-07). Ids SIEMPRE prefijados (`jkanime:slug`) — sin prefijo `episodes_list` adivina por título y falla con puntuación.
- **Caché** `~/.cache/ani-cli-mx/`: catalog.tsv (6h) + recent.tsv (30min) + thumbs/epthumbs inmutables. Warm start 0.4s (frío ~10s). Fallback a caché viejo si la red cae.
- **Estado** `~/.local/state/ani-cli-mx/`: ani-favs, ani-watchlist, ani-hsts (historial upstream).

## Verificación (harness propio, diseño Fable)

`t/verify.sh` — correr tras CUALQUIER cambio al grid:
1. **geom.sh**: 3192 combos de invariantes matemáticos (sin render)
2. **decode_grid.py**: oráculo — decodifica los placeholders unicode (posición/tamaño exactos de cada imagen SIN ver píxeles) y valida encaje/márgenes/rectángulos. Tabla de diacríticos auto-derivada de icat (`calibrate.sh`).
3. **e2e.sh**: tmux driver — navegación, scroll, resize, payload, salida limpia

Cazó en producción: doble-quoting de `{}` en fzf, IFS con `\t` literal, texto fantasma (falta de padding), tarjeta más alta que ventana, `grep -v | mv` roto con archivo de 1 línea.

## Lecciones clave

- **fzf envuelve `{}` en comillas simples** — nunca ponerle comillas propias; usar `{4}` + `--delimiter '\t'` + `--with-shell 'sh -c'`
- **kitty unicode placeholders** = imágenes que scrollean como texto; decodificables para testing estructural sin screenshots
- **`$0` al sourcear = bash** → state dir equivocado; exportar `ANI_CLI_STATE_NAME`
- **`rm` de un archivo con fd abierto** por redirección → escrituras van al inode huérfano
- **icat sin `--scale-up` no agranda** — imágenes chicas flotan en el marco

## Pendientes / ideas

- [ ] Paleta caelestia en el grid (colores dinámicos del scheme)
- [ ] Vista "continuar viendo" como tab (hoy es `anime-cont` fzf clásico)
- [ ] Precarga de thumbs de episodios en background al hover
