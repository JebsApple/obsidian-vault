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
- [x] Pase de calidad "versión final" (commit 575cd3c) — usuario reportó "la interfaz falla bastante":
  - **Crítico**: grid de episodios leía teclas de stdin (pipe agotado de la lista de eps) — EOF caía en la rama Enter y abrir cualquier anime auto-reproducía el ep 1. La interactividad del grid nunca había funcionado de verdad. Fix: leer de `/dev/tty`, sin `stty raw`, EOF nunca es Enter.
  - Latencia episodios: paginación ajax jkanime en paralelo (batch 8) + cache `eplists/` TTL 30min. One Piece: 54s → 11s frío → 0.2s cacheado. Thumbs: solo primera página bloquea, resto background acotado (~3 páginas), resolución lazy al pintar.
  - Tarjetas en blanco: `thumb_display_path` devolvía ruta del render reducido inexistente. Harness pasó de decodificar 0 imágenes a 12/12.
  - Búsqueda: repintado completo por tecla → solo header con conteo en vivo, un pintado al confirmar.
  - Nav: Descargas vacío ya no rebota a Catálogo (empty state en tab); `CG_TAB_SEL` sucio ya no roba el Enter del grid.
  - Métricas: arranque 624ms (cache caliente), harness completo verde.
- [ ] Fase 5 — Diseño futuro de reproducción embebida
