---
tags: [project/ani-cli-hub, tracking, ani-dev]
status: active
source_plan: "[[ani-dev-navigation-library-plan]]"
branch: feature/hub-tabs-library-playback
updated: 2026-07-17
---

# ani-dev — Seguimiento

- [x] Fase 1 — Wrapper y estado aislado de `ani-dev`
- [x] Fase 2 — Semana integrada con sub-tabs
- [x] Fase 3 — Biblioteca con categorías CRUD (commit 31411ab)
  - CRUD UI: fzf-based add/rename/move/delete with confirmation
  - Assignment: `w` toggles assign/unassign to current category in Biblioteca
  - Sub-tabs: categories shown as tabs inside Biblioteca
  - Config: `~/.cache/ani-dev/lib-categories.txt` + `lib-assignments.txt`
- [x] Fase 4 — Rendimiento y estabilidad visual
  - Async prefetch de thumbnails (batch=4)
  - Render thumbs reducidos (420px) via magick/ffmpeg
  - Empty state manejado sin crash
- [x] Tabs + Descargas + Search (commit 304d0bc)
  - Tab navigation: highlight-only con Enter para activar
  - Episode inline actions: Reproducir/Descargar dentro de la tarjeta
  - Tab Descargas: muestra archivos descargados, abre con vlc
  - Download manager: cola con max 5 simultáneas, colores diferenciados
  - Search bar: `/` para buscar en catálogo, Esc para limpiar
  - Fix: arrow keys en episode grid (ESC byte collision)
- [x] Fix: header label hardcodeado "catálogo" en Favoritos y Biblioteca (commit 47bcecb) — deployado a `/usr/lib/ani-cli-mx/ani-cli-mx-core`
- [x] Fix crítico: loops de lectura (`show_card_grid`, `select_episode_grid`) no cortaban cuando `/dev/tty` moría (sesión/terminal cerrada) — proceso quedaba zombie escribiendo error a máxima velocidad, llenó `/tmp` (tmpfs 3.8G) en minutos varias veces durante debug. Fix: detección por reloj real (no por `-e /dev/tty`, que siempre existe como nodo aunque el open falle con ENXIO) + `select_episode_grid` con contador de fallos de stdin. Commit 7c587a8.
- [x] Fix: `_cg_apply_search()` no recalculaba `vrows` tras filtrar — header mostraba "fila X/Y" con Y del catálogo sin filtrar. Mismo commit 7c587a8.
- [x] Búsqueda remota: `/` cae a `search_anime` (jkanime/animeav1/allanime) cuando el filtro local del catálogo da 0 resultados. Reutiliza `nth` (selector clásico). Gateado con `CG_REMOTE_SEARCH` — activo en Catálogo/Favoritos/Biblioteca/Recientes/Semana, desactivado en Descargas. Verificado en vivo (Cowboy Bebop → 2 resultados AnimeAV1 → 26 episodios). Commit 1c09694.
- [ ] Fase 5 — Diseño futuro de reproducción embebida
