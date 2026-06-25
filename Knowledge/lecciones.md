---
tags: [concepto, aprendizaje]
---

# Lecciones Aprendidas

Registra aquí errores y soluciones para no repetirlos.

## Formato
- **Problema:** Breve descripción
- **Solución:** Cómo se resolvió
- **Causa raíz:** Por qué ocurrió

## Regla fija — Ramas en español
Todas las ramas se nombran en **español**. Nada de inglés (no `readmes`, `testing`, `dashboard`). Nomenclatura estricta: `SPRINT-HUXX-TXX-descripcion-breve` o `SLT-descripcion`. Confirmar con el usuario antes de renombrar ramas que no creaste tú mismo.

## Historial
- [2026-06-17] Mihon+Suwayomi sync: celular probablemente estaba en datos móviles (5G) al fallar pruebas de red local — siempre desactivar datos al testear IPs locales
- [2026-06-17] Para diagnosticar conectividad local: `python3 -m http.server 8888` en PC, abrir `http://IP:8888` desde celular con WiFi y sin datos móviles
- [2026-06-17] Suwayomi en CachyOS corre como servicio nativo (no Docker), escucha en `*:4567`, usuario `suwayomi`
- [2026-06-18] Configurado servidor MCP obsidian-mcp para opencode y Claude Code
- [2026-06-18] Instalado mcp-fetch-server (web fetching ligero)
- [2026-06-18] Instalado github MCP server (desactivado por defecto para ahorrar tokens)
- [2026-06-18] Creado AGENTS.md con auto-logging y división de trabajo OpenCode/ClaudeCode
- [2026-06-18] Instalado opencode-mcp — Claude Code puede delegarme tareas via MCP
- [2026-06-18] Push masivo a Gitea: MiNegocio-backend (main con rebase + conflictos), MiNegocio-backend-Busqueda (repo+rama creados), MiNegocio-backend-imagenes (repo+main creados), MiNegocio-database (main), MiNegocio-frontend (S2-HU04-Frontend-Galeria + S2-STL-Frontend-Redesign)
- [2026-06-18] Token Gitea en `token gitea.md` del vault. Usado para pushear via `http://TOKEN@192.168.50.28:3000/VHerrera/...git`
- [2026-06-18] Conflicto en rebase de MiNegocio-backend: producto_handler.go, main.go, producto_service.go (S2-HU04 vs tests). Resuelto combinando ambos cambios y tabs normailzados con gofmt
- [2026-06-17] Creada nota Knowledge/opencode.md documentando el role de opencode en el vault
- [2026-06-17] Cambiado obsidian-mcp de `npx -y obsidian-mcp` a `node path/to/main.js` para evitar latencia de npx
- [2026-06-18] Sincronización del vault: git + systemd timer (auto-push/pull c/30 min) + plugin Obsidian Git (c/10 min desde la UI)
- [2026-06-18] Comando `vault-sync` (alias `vsync`) — sync manual sin gastar tokens. Solo usa Claude + opencode si hay conflictos de merge
- [2026-06-18] Instalado plugin Automatic Linker — convierte texto en wikilinks automáticamente al guardar, sin AI
- [2026-06-18] Creada carpeta Research/ — notas de investigación sobre MCP, Tailscale, CachyOS, self-hosting, manga sync
- [2026-06-18] Gitea: repos separados MiNegocio-backend-Busqueda, MiNegocio-backend-imagenes y alo eliminados. Su contenido se pusheó como ramas de MiNegocio-backend (S2-HU04-API-Busqueda y S2-HU04-API-Imagenes) antes de borrarlos
- [2026-06-18] Smoke test DEV: 3 bloqueantes encontrados — contenedor backend desactualizado (Jun 15, no tiene S2-HU04), feat/inventario-endpoints sin mergear + ruta no registrada en routes.go, frontend caído. Veredicto: NO LISTO. Plan documentado en Projects/MiNegocio - Merge a Main.md
- [2026-06-18] Reestructuración completa de MiNegocio: 3 repos (frontend, backend, database) con git init local. Zips extraídos en /home/apuru/minegocio/. Pendiente push a Gitea.
- [2026-06-18] Login usa texto plano contra password_hash — migrado a bcrypt (golang.org/x/crypto). Requiere regenerar hash en DB seed.
- [2026-06-18] stock_status se agregó como columna VARCHAR a productos (migration 001_add_stock_status.sql). Default 'sin_clasificar'. Backend model actualizado con StockStatus + queries INSERT/UPDATE/SELECT. Antes solo existía en frontend.
- [2026-06-18] DnD en KanbanBoard: usar `event.dataTransfer.set/getData('application/json', ...)` en vez de estado interno del componente, para que drag desde sidebar (fuera del KanbanBoard) funcione correctamente.
- [2026-06-18] Al integrar bcrypt: el password_hash en DB debe ser el hash, no el texto plano. Para seed: generar con `bcrypt.GenerateFromPassword([]byte("1234"), bcrypt.DefaultCost)`.
- [2026-06-18] ventasService.js no incluía header Authorization — corregido. Todas las llamadas API protegidas deben llevar Bearer token.
- [2026-06-18] Al borrar CSS huérfanos (carritocompras.css), verificar imports en componentes. CarritoCompras.vue importaba el archivo eliminado y rompía el build.
- [2026-06-18] LoginPage.vue con toggle Login/Registro: mantener el mismo padding/margins que base.css define; no duplicar estilos de botones en CSS de página.
- [2026-06-18] AuthHandler mock necesita Register() para que handler tests compilen al agregar registro de usuarios.
- [2026-06-18] La tabla registro_ventas ya existía en la BD pero con esquema distinto (id en vez de id_venta, sin FK, sin CHECK). Recreada para coincidir con venta_repository.go que espera id_venta, FK a productos/usuarios, y CHECK en precio_producto y cantidad.
- [2026-06-18] nginx sites-available debe tener symlink en sites-enabled para activarse; minegocio-dev no estaba enabled
- [2026-06-18] ALL: `Scan()` en PostgreSQL con NULL en campos string requiere `COALESCE(col, '')` o el Scan falla silenciosamente
- [2026-06-18] Gitea API push via SSH requiere remote `git@gitea:user/repo.git`; HTTP requiere interactive auth o token en URL
- [2026-06-18] Puertos originales: DEV=8080 PROD=8000 con nginx reverse proxy. Docker cambió a 3000/8081. nginx config tiene minegocio-dev que apunta a 8080→3000 correctamente
- [2026-06-18] Investigación foto celular → `capture="environment"` en `<input type="file">` es lo mínimo. Para PC+celular como cámara externa: DroidCam/Iriun + getUserMedia. Docs en Research/foto-celular-minegocio.md
- [2026-06-18] Investigación sync Obsidian+MCP multi-máquina → Syncthing para sync LAN + Git para backup. MCP configs sincronizados via vault. Docs en Research/sync-obsidian-mcp-multi-maquina.md
- [2026-06-20] Hyprland 0.55 en CachyOS requiere config Lua (.lua) — `.conf` deprecated
- [2026-06-20] Dispatchers en Hyprland 0.55: `hl.dsp.focus({ workspace = N })`, `hl.dsp.layout("preselect right")`, `hl.dsp.window.resize({ x = -N, y = 0, relative = true })` — layout() toma UN solo string
- [2026-06-20] 3 columnas iguales en dwindle: abrir con `preselect right` en cadena, luego resize -320px en win1 izquierda
- [2026-06-20] Audio HDMI distorsionado → cambiar perfil de `hdmi-surround71` a `hdmi-stereo` con `pavucontrol` o `wpctl`
- [2026-06-20] SDDM funciona como DM para Hyprland; plasmalogin oculta sesión Hyprland
- [2026-06-20] `~/.npm-global/bin` en PATH para opencode
- [2026-06-20] Screenshots en Hyprland: `grim` (captura) + `wl-copy` (portapapeles). `spectacle` no funciona bien con `-b` (background)
- [2026-06-20] Mouse buttons: `mouse:275` y `mouse:276` para botones laterales. Si no funcionan, probar otros números (277/278). Sin modificador ni `mod +`
- [2026-06-20] Paste+Enter: `wl-paste | wtype -` y luego `wtype -k Return`. `wtype` simula tecleo en Wayland
- [2026-06-20] Dwindle equalize: `splitratio 1` para splits 50/50, `splitratio 0.5` para 3 columnas iguales
- [2026-06-20] Show desktop: toggle entre workspace actual y 99 (vacío) guardando estado en `/tmp/`
- [2026-06-20] Ctrl+Shift+letra NO funciona en Hyprland 0.55 (bug conocido, binds se registran en `hyprctl binds` pero no ejecutan). Solución: usar Alt+Shift en vez de Ctrl+Shift.
- [2026-06-20] Webcam Realtek 0bda:5855 (Hy FHD5350) falla con error -71 (EPROTO) constantemente. Fix: `options uvcvideo quirks=0x100` en modprobe.d + udev rule para deshabilitar autosuspend USB.
- [2026-06-20] Sesiones SDDM: elegir "Hyprland" (sin paréntesis). "(direct)" y "(uwsm-managed)" son variantes que no se usan.
- [2026-06-20] hyprpaper falla con "Monitor X has no target" si no matchea outputs correctamente. Solución: usar `wallpaper = eDP-1,/path` en vez de comodín.
- [2026-06-20] Wiki Hyprland: `https://wiki.hypr.land/` — versionada, elegir tag release (no "latest git"). v0.55 usa Lua.
- [2026-06-20] Marca de agua "read the wiki" en esquina: es branding de Hyprland (versión + link). Se oculta con `hl.config({ misc = { disable_hyprland_logo = true } })` pero necesita `hyprctl reload config` o reinicio para aplicar.
- [2026-06-20] hyprpaper socket en `$XDG_RUNTIME_DIR/hypr/INSTANCE/.hyprpaper.sock`. Si hyprpaper está colgado (PID viejo), `hyprctl hyprpaper` falla. Solución: `killall hyprpaper && hyprpaper -c ~/.config/hypr/hyprpaper.conf &`
- [2026-06-20] hyprctl hyprpaper comandos útiles: `listactive` (ver wallpapers activos), `preload`, `wallpaper monitor,path`. Si falla con "invalid request", reiniciar hyprpaper.
- [2026-06-20] Regla ponytail: la config Lua en Hyprland 0.55 no requiere `.conf` ni `.lua` — Hyprland busca `hyprland.lua` automáticamente. Renombrar `.conf` a `.bak` para evitar confusión.

## 2026-06-18 — Sesión 3: Auth reactivo + redundancia nav

### localStorage no es reactivo en Vue
`computed: { isLoggedIn() { return !!localStorage.getItem("token") } }` NO se re-evaluaba después del login porque `localStorage` no es una dependencia reactiva. Solución: usar `reactive({})` de Vue 3 como store compartido, y que el store sincronice bidireccionalmente con `localStorage`.

### Auth guard en router
`router.beforeEach` con `meta: { requiresAuth: true }` en las rutas protegidas. Si no está autenticado, redirige a `/login?redirect=/ruta-original`.

### SideBar y NavBar duplicados
Los 3 links centrales del NavBar (Inventario, Análisis, Productos) eran redundantes con el SideBar, que ya tiene navegación más completa (Ventas, submenú de Productos). Se eliminaron los links del NavBar — ahora solo muestra logo + menú de usuario.

### Store auth (src/store/auth.js)
- `reactive()` para reactividad
- `setAuth(token, user)` → actualiza store + localStorage
- `clearAuth()` → limpia store + localStorage
- Servicios siguen usando `localStorage.getItem('token')` directo (store persiste en localStorage)

## 2026-06-18 — Sesión 4: Registro usuarios + separación DEV/PROD

### User registration endpoint
- Crear endpoint: repository.Create + service.Register + handler.Register + route
- `RegisterRequest` ya existía en models pero no se usaba
- Validar duplicados con `GetByNombre()` y errores con `errors.New()`
- Toda la cadena: handler → service → repository

### docker cp con Go binary
- El contenedor corre el binario en `/app/main` (según Dockerfile `CMD ["./main"]`)
- Copiar a `/app/minegocio-backend` no funciona — hay que copiar a `/app/main`
- **Mejor:** construir dentro del contenedor con `docker exec backend sh -c "cd /app && go build -o main ."` — evita problemas de glibc vs musl (host=glibc, alpine=musl)

### Separación DEV/PROD completa
- DEV: nginx 8080 → frontend `/var/www/dev/frontend/` → API proxy localhost:3000 → `cliente_dev`
- PROD: nginx 80 → frontend `/var/www/prod/frontend/` → API proxy localhost:3001 → `cliente_prod`
- Backend PROD corre como contenedor separado `backend-prod` con `DB_NAME=cliente_prod`
- JWT_SECRET debe ser diferente entre entornos
- PROD DB necesitó crear tablas manualmente (solo tenía usuarios)

### Gitea SSH vs HTTP
- SSH remote `git@gitea:user/repo.git` funciona sin contraseña
- HTTP remote `http://192.168.50.28:3000/user/repo.git` requiere token en URL o auth interactiva
- `git push gitea branch` funciona con SSH; origin (HTTP) requiere token

- [2026-06-20] XDG dirs en español: PICTURES=`~/Imágenes/`, Capturas=`~/Imágenes/Capturas de pantalla/`. Usar `xdg-user-dir PICTURES` en scripts en vez de hardcodear `~/Pictures/`.
- [2026-06-20] En Hyprland .conf: `bindr` = key release, útil para hold-to-show (abrir al presionar, cerrar al soltar)
- [2026-06-21] GtkLayerShell (gtk-layer-shell 0.10.1) disponible en CachyOS. Permite crear ventanas layer-shell desde Python: `GtkLayerShell.init_for_window(win)`, `set_keyboard_mode(EXCLUSIVE)` para capturar teclado, `set_layer(TOP)` para overlay. La ventana flota nativamente, sin window rules, sin togglefloating.
- [2026-06-21] GtkLayerShell.KeyboardMode.EXCLUSIVE captura teclado completamente (como wofi). Ideal para popups con búsqueda.
- [2026-06-20] Python GTK3 para popup flotante en Hyprland: `GtkLayerShell.init_for_window()` es la solución correcta. Avoid `set_type_hint()` + togglefloating (window rules rotas en 0.55). Avoid wofi --dmenu (no tiene control fino de UI).

- [2026-06-21] grimblast lock file en `$XDG_RUNTIME_DIR/grimblast.lock` — si el proceso no termina, el lock impide nuevas capturas. Solución: `rm -f $XDG_RUNTIME_DIR/grimblast.lock` antes de llamar grimblast.
- [2026-06-21] `hyprctl notify` no muestra notificaciones con `vfr=true` (default). Workaround: incluir `fontsize:20` en el mensaje fuerza renderizado.
- [2026-06-21] `notify-send` bloquea si no hay notification daemon. Siempre background (`&`) o con timeout.
- [2026-06-21] Window rules (`windowrule=`, `windowrulev2=`) rotas en Hyprland 0.55 .conf parser. Para flotar ventanas: `hyprctl dispatch togglefloating` por script o `set_type_hint()` en GTK.
- [2026-06-21] `yad --picture` para preview de screenshot, pero se abre como ventana tiled. Pendiente: lograr que flote sin window rules.
- [2026-06-21] **AudioSource** (gdzx/audiosource): app F-Droid + script Python (6KB). ADB forward del mic del celular → PulseAudio/PipeWire. No necesita módulos kernel ni virtual sinks. Instalar APK desde F-Droid, script en `~/.local/bin/audiosource`.
- [2026-06-21] **AVream** (Kacoze/avream): celular como webcam+mic sin app dedicada. v1.0.11, activo (Mar 2026). No necesita app en el celular (usa ADB+scrcpy). GTK4/libadwaita, UI en español. Requiere `android-tools` (adb). En CachyOS con Hyprland funciona bien el mic (PipeWire), cámara requiere v4l2loopback que puede fallar con kernel custom.
- [2026-06-21] **CachyOsTools** (XetalEngine): gestor completo en Qt6 (paquetes, servicios, tweaks, backup, red, logs). Compilar con CMake. Binario en `/usr/local/bin/CachyOsTools`. No requiere instalación, solo `cmake .. -DCMAKE_BUILD_TYPE=Release && make`.
- [2026-06-21] **Better Control** (better-ecosystem/better-control): panel GTK3 moderno para Hyprland/GNOME/KDE. En AUR como `better-control-git`. Comandos: `control` (GUI), `betterctl` (update/uninstall). Probado en Hyprland, respeta dark/light theme.
- [2026-06-21] **qpwgraph** (`pacman -S qpwgraph`): visualizador de grafos PipeWire, útil para depurar rutas de audio y conectar virtual sinks manualmente.
- [2026-06-21] `audiosource volume 200%` — el volumen del micrófono desde celular suele ser bajo, necesita amplificación >100%.
- [2026-06-21] PipeWire virtual mic permanente: config en `~/.config/pipewire/pipewire.conf.d/10-virtual-mic.conf` con módulo loopback. Temporal: `pw-loopback --capture-props='media.class=Audio/Source ...'`.
- [2026-06-21] `control -L es` abre Better Control en español. El flag `-L` + código de idioma (es/en/pt) cambia el idioma de la UI.
- [2026-06-21] CachyOsTools se compila con `cmake .. -DCMAKE_BUILD_TYPE=Release && make`. No necesita `make install` — el binario está en el build dir. Se copió a `/usr/local/bin/CachyOsTools`.
- [2026-06-21] Waybar: los módulos `pulseaudio`, `network`, `battery`, `clock`, `bluetooth`, `custom/brightness`, `custom/power` tienen `on-click` apuntando a `control` (Better Control). Audio click izquierdo → `control -V`, derecho → `pavucontrol`. Brillo usa scroll up/down con `brightnessctl`.
- [2026-06-21] Waybar bluetooth module necesita `bluez` corriendo. Formato: `` (off), ` {device}` (connected). `on-click` → `control -b`.
- [2026-06-21] Waybar CSS: transiciones CSS (`transition: all 0.2s ease`) para hover en todos los módulos. Workspaces activos con `background: rgba(...)`. No usar `@keyframes` — el parser CSS de Waybar (GTK) falla con animaciones.
- [2026-06-21] Waybar no soporta `@keyframes` animations en su parser CSS (GTK CSS). Para efectos de parpadeo, usar cambio de color directo.

- [2026-06-21] `hypr-player` creado: mini reproductor GTK3 flotante (esquina inferior-derecha). Polling cada 500ms con `playerctl`, album art vía Thread+urlopen, controles (play/pause/prev/next/seek/vol), cierre con ESC o ✕, singleton via PID file.
- [2026-06-22] Documentación de sesión en `Projects/HyprPlayer-Audit.md` — auditoría completa con checklist de requerimientos, bugs conocidos, simplificaciones deliberadas y comandos de verificación.
- [2026-06-21] `wl-gammarelay` registra D-Bus name `rs.wl-gammarelay`, object path `/`, interface `rs.wl.gammarelay`, propiedades `Brightness` (double) y `Temperature` (uint16). `busctl` requiere `--user` para session bus. `dbus-send` siempre funciona.
- [2026-06-21] Waybar `mpris` module: nativo, sin exec, formato `{player_icon} {title}`, player-icons por nombre. `on-click` → `playerctl play-pause`, scroll → volumen.
- [2026-06-21] brightness-focused: script que detecta monitor enfocado via `hyprctl monitors -j | jq`, usa `brightnessctl` para eDP-1, `ddcutil` fallback para externos (falla si DDC/CI no soportado).
- [2026-06-21] **hyprsunset (custom build con PR #87 + IPC extendido)**: solución real para brillo per-monitor en HDMI sin DDC/CI. Usa `hyprland-ctm-control-v1` de Hyprland (per-output CTM). Comando IPC: `hyprctl hyprsunset gamma_output HDMI-A-1 0.5` (o `identity` para remover). Build desde fork con PR #87, modificado para aceptar `gamma_output` dinámico y usar `identity=true` para dimming puro sin cambio de temperatura de color.
- [2026-06-21] **PR #87** (eam/hyprsunset) agrega per-output config pero solo estática. Se extendió con `gamma_output` IPC para control dinámico desde waybar. `SOutputOverride` movido a public para acceso desde IPC.
- [2026-06-21] **brightness-cursor**: reemplaza brightness-focused. Detecta monitor vía coordenadas del cursor (no workspace enfocado). eDP-1 usa `brightnessctl` (hardware), HDMI-A-1 usa `hyprctl hyprsunset gamma_output` (gamma per-output). Estado persistido en `~/.local/state/brightness-hdmi`.
- [2026-06-22] **grim -T captura window content** con `stableId` (no `address`). `grim -t ppm` es 4x más rápido que PNG (~25ms vs 140ms por frame). Usado para capturar ventana de browser sin overlay del mini-player.
- [2026-06-22] **hypr-player v4**: migración a `GDK_BACKEND=x11` + `Gtk.Socket` para embeber `mpv --vo=x11 --wid=<XID>`. Elimina captura con grim (muy lento). En su lugar, `yt-dlp -g` extrae stream URL de YouTube y mpv lo reproduce directo en el socket. `--no-audio` para no duplicar audio del browser.
- [2026-06-22] **mpv --wid NO funciona en Wayland nativo** — crea su propia ventana separada. Necesita `--vo=x11` para forzar X11 VO y embederse correctamente en un socket XWayland.
- [2026-06-22] **yt-dlp -g** devuelve 2 líneas (video + audio). Siempre usar `.split("\n")[0]` para tomar solo la primera URL.
- [2026-06-22] **Waybar GTK3 no soporta `max-width` en CSS** — propiedad inválida (error en log). Para módulos colapsables (icono visible, texto oculto), usar `font-size: 0px` en estado base: el texto hereda font-size 0 y ocupa 0px de ancho. En hover, `font-size: 13px` revela el texto y desplaza los módulos adyacentes. El span del icono debe usar `font_size='10pt'` (absoluto Pango) para que el icono sea siempre visible aunque el widget tenga font-size 0.
- [2026-06-22] **Pango markup `font_size='10'` sin unidad = 10/1024 de punto ≈ 0.01pt (invisible)**. Siempre usar `font_size='10pt'` (con sufijo `pt`) para 10 puntos reales. Sin el sufijo, el icono no se renderiza.
- [2026-06-22] **Avoid `subprocess.run` en callbacks de GTK** — bloquea el main loop. Usar `threading.Thread` para tareas largas (yt-dlp, descarga de imágenes).
- [2026-06-22] **Race condition en _ensure_mpv**: si `update()` se llama cada 500ms y yt-dlp tarda 5s, se lanzan múltiples threads. Solución: flag `self.mpv_pending` que impide lanzar un segundo thread mientras el primero corre.
- [2026-06-22] **position_window vs drag**: timer cada 200ms llama `win.move()` que pelea con `begin_move_drag`. Solución: skip `position_window` si `self.dragging`.
- [2026-06-22] **Revealer animation resize** confunde a mpv embebido (X11 child window recibe resize events intermedios). Solución: `set_transition_duration(0)` — instántaneo.
- [2026-06-22] **mpv IPC**: `--input-ipc-server=/tmp/hypr-mpv-{pid}.sock` + socket Unix desde Python. Comandos: `set_property time-pos` (seek), `set_property pause`, `add time-pos` (flechas).
- [2026-06-22] **Iconos por player** en hypr-player: detectar via `playerctl -l` + `xesam:url`. YouTube →  + video embebido, Spotify →  + album art, etc.
- [2026-06-21] `wl-gammarelay` reemplazado por hyprsunset. wl-gammarelay usa `wlr-gamma-control-v1` (global, todos los outputs afectados). hyprsunset usa `hyprland-ctm-control-v1` (per-output con CTM matrix). Servicio systemd deshabilitado.

- [2026-06-22] **`python-mpv` con `vo="x11"` y `wid=str(xid)`** funciona para video embebido en Gtk.Socket (GTK3). `GDK_BACKEND=x11` obligatorio (sin él `get_id()` falla).
- [2026-06-22] **`playerctl --player=<name>` no tiene comando `volume`** — para controlar volumen con mpv embebido, usar `self.mpv.volume = v` directamente sin pasar por playerctl.
- [2026-06-22] **Gtk.Revealer + GLib.timeout_add** para auto-ocultar controles tras inactividad. `SLIDE_UP` con `transition_duration(200)`. Mostrar en `motion-notify-event`, ocultar tras 5s sin movimiento.
- [2026-06-22] **VLC y xesam:url**: pasar la URL directa a mpv (sin yt-dlp). Solo YouTube pasa por `yt-dlp -g`.
- [2026-06-22] **Separar playerctl en 3 daemons** (mpris-yt, mpris-music, mpris-vlc) permite marquee ticker independiente por módulo. Cada daemon es continuo (no interval) con loop que actualiza cada 500ms y mueve el texto 6 chars/segundo.
- [2026-06-22] **css font-size 0 + font_size='10pt' en Pango markup** para ocultar texto de módulo sin ocultar el icono. El span del icono usa tamaño absoluto Pango, el texto hereda font-size 0 del widget.
- [2026-06-22] **VLC no setea xesam:title** — fallback a `os.path.basename(urllib.parse.unquote(xesam:url))` para extraer nombre de archivo.

## 2026-06-23 — Audio cleanup + hypr-player v7

- [2026-06-23] **`playerctl position` sí devuelve posición real del video YouTube** via `plasma-browser-integration` MPRIS bridge. No hace falta mpv paralelo para sync — `playerctl position <seg>` seek también llega al browser.
- [2026-06-23] **mpv subprocess paralelo (yt-dlp stream) no sincroniza con el browser** — si el usuario seekea en el browser, mpv sigue en la posición anterior. Para control real del browser, usar MPRIS puro.
- [2026-06-23] **`snd_aloop` (ALSA loopback)** se carga via `/etc/modules-load.d/snd-aloop.conf`. Eliminar el archivo + `rmmod snd_aloop` es suficiente para quitarlo permanentemente. No afecta audio real.
- [2026-06-23] **WirePlumber default-nodes** persiste en `~/.local/state/wireplumber/default-nodes`. Si apunta a un dispositivo eliminado (`snd_aloop`), el audio vuelve al loopback en cada reinicio. Limpiar manualmente con `wpctl set-default <id>` + editar el state file.
- [2026-06-23] **WirePlumber `api.acp.auto-profile = true`** en `~/.config/wireplumber/wireplumber.conf.d/50-audio-defaults.conf` hace que el card profile correcto (`analog-stereo+input`) se seleccione automáticamente en cada boot, sin necesidad de `pactl set-card-profile` manual.
- [2026-06-23] **Cairo `LinearGradient` en GTK3**: `import cairo` (pycairo, incluido con PyGObject). `cr` en callbacks `draw` ya es `cairo.Context`. Usar `cairo.LinearGradient(x0,y0,x1,y1)` + `add_color_stop_rgba`.
- [2026-06-23] **`Gtk.DrawingArea` para arte con esquinas redondeadas**: hacer clip Cairo antes de pintar el pixbuf. `cr.arc()` + `cr.clip()` + `Gdk.cairo_set_source_pixbuf()`. Más confiable que CSS `border-radius` que no clipea widgets hijos.
- [2026-06-23] **Cover-fill en Cairo**: `scale = max(W/pw, H/ph)` → centra con `x = (W-nw)/2, y = (H-nh)/2`. `Pixbuf.scale_simple(nw, nh, BILINEAR)` antes de `set_source_pixbuf`.

## 2026-06-23 — SLT-Control-de-Versiones

### Ramas
- `SLT-control-de-versiones` creada en frontend, backend y database (desde main)
- Esquema: `3.0.0` (sprint.feature.hotfix)
- Nota en `Projects/MiNegocio/SLT-Control-de-Versiones.md`
- No bloquea, hacer antes del primer merge a main

## 2026-06-23 — HU01-T05: Limpieza código muerto + reorganización Gitea

### Nomenclatura de ramas
- Ramas renombradas de `feature/huXX-tXX-*` a `S3-HUXX-TXX-*` en español:
  - `feature/hu01-t11-readmes` → `S3-HU01-T11-documentacion`
  - `feature/hu02-t01-navbar-sidebar` → `S3-HU02-T01-navegacion-barra-lateral`
  - `feature/hu02-t02-kanban` → `S3-HU02-T02-tablero-kanban`
  - `feature/hu02-t03-dashboard` → `S3-HU02-T03-panel-principal`
  - `feature/hu02-t04-testing` → `S3-HU02-T04-pruebas`
  - El resto se mantuvieron igual (ya en español)

### Gitea: limpieza de ramas S2
- Las ramas S2 viejas se respaldaron como `archive/` tags antes de eliminar, para no perder trabajo.
- Desde `main` se crearon `develop` + 8 ramas S3: `S3-HU01-T05-limpieza` a `S3-HU02-T05-validaciones`.

### HU01-T05: código eliminado
- `HelloWorld.vue` (componente por defecto de Vue CLI)
- `src/middleware/authGuard.js` (no importado en router)
- `src/plugins/axios.js` (proyecto usa fetch nativo, no axios)
- NavBar: placeholders "Perfil" y "Configuración" eliminados
- SideBar: prop `isLoggedIn` eliminada (no se usaba internamente)

### authService.logout() unificado
- `authService.js` ya existía en Gitea con `logout()`. Se importó en NavBar, SideBar y App.vue en vez de manipular localStorage inline.

### stockStatus.js creado
- `src/utils/stockStatus.js` con `STOCK_BAJO = 4` y `getStockStatus(stock)` → `agotado|bajo|normal|exceso`.

### Componentes integrados desde local
- NavBar, SideBar, LogoSVG → `feature/hu02-t01-navbar-sidebar`
- KanbanBoard → `feature/hu02-t02-kanban`

## 2026-06-18 — Sesión 5: Documentación de código para exposición
### Notas por integrante en Obsidian
Se actualizaron/crearon 4 notas en `Projects/MiNegocio/` con explicación capa-por-capa del código actual post-revert:
- **Ignacio Varela.md** — Ventas (S2-HU02): handler/service/repository ventas + POS frontend
- **Gabriel Flores.md** — JWT (S2-HU03): auth middleware, jwt config, login/refresh/sesiones
- **Nicolás Valdés.md** — Barcode + Inventario (S2-HU01): escáner en FormularioProducto + inventario_view
- **Victor Herrera.md** — Imágenes (S2-HU04): upload middleware (magic bytes), galería, DB schema

Cada nota incluye: flujo capa-por-capa, tabla de keywords para responder al profe ("¿dónde va función X?"), y cambios del post-revert.

### Código extraído a ~/Downloads
`~/Downloads/minegocio-frontend/` y `~/Downloads/minegocio-backend/` con el estado post-commit `898137e` y `19bbc55` respectivamente.

## 2026-06-23 — Waybar hover roto + hypr-player a layer-shell + limpieza

### El hover de Waybar dejó de expandir los módulos → daemon muerto
- **Causa raíz:** `waybar-hover-daemon.service` tenía `BindsTo=waybar.service`. `BindsTo` **detiene** el daemon cuando waybar para, pero **NO lo rearranca** cuando waybar vuelve. Al hacer `waybar-reload` (killall + systemctl start), el daemon quedó muerto y el state file `~/.local/state/waybar-hover-group` clavado en "0" → los módulos nunca expanden.
- **Fix:** quitar `BindsTo`/`PartOf` y hacer el daemon **independiente** (`WantedBy=default.target`, `Restart=always`, `After=waybar.service`). El daemon ya es self-healing: relee `pidof waybar` y `hyprctl layers` en cada ciclo, así que sobrevive a cualquier reinicio de waybar sin quedar huérfano. El `BindsTo` era una optimización prematura que causó justo la caída.
- **Lección:** para un daemon auxiliar que solo escribe un state file y señaliza a waybar, NO atarlo al ciclo de vida de waybar; hacerlo independiente y resiliente.
- **Test del mecanismo (sin tocar el cursor):** `echo "1" > ~/.local/state/waybar-hover-group; <script>` → debe emitir ícono+texto+`"class":"expanded"`. `echo "0"` → solo ícono.

### Hyprland 0.55: `hyprctl dispatch` interpreta los argumentos como Lua
- `hyprctl dispatch togglefloating address:0x...` → `error: hl.dispatch(togglefloating address:0x...): ')' expected near 'address'`. El IPC envuelve los args en `hl.dispatch(...)` y los parsea como Lua → los selectores clásicos (`address:`, `title:`, `exact X Y,...`) son sintaxis inválida.
- Incluso `togglefloating` pelado falla: `hl.dispatch: expected a dispatcher (e.g. hl.dsp.window.close())`. La API es `hl.dsp.<ns>.<dispatcher>(...)` con tablas Lua, pero el nombre exacto del dispatcher de floating no es `toggleFloating`/`togglefloating` (ambos → nil).
- **Conclusión:** `hyprctl dispatch movewindowpixel exact ... ,title:...` y `windowrulev2 = float,...` son **poco fiables/rotos en 0.55**. No depender de ellos para flotar/posicionar ventanas desde scripts.

### Solución correcta para flotar GTK en Hyprland 0.55: GtkLayerShell
- `gi.require_version("GtkLayerShell","0.1")` + `GtkLayerShell.init_for_window(win)` **antes** de `show_all()`. Flota nativamente, sin window rules ni dispatch.
- Anclar a **dos bordes adyacentes** (BOTTOM+RIGHT) + `set_margin` → la ventana conserva su tamaño de contenido y se pega a la esquina (réplica de un snap-to-corner). Anclar a bordes opuestos la estiraría.
- `set_keyboard_mode(ON_DEMAND)` → teclas (ESC/Space/←/→/C) funcionan al hacer foco con clic, sin robar el teclado global (eso sería EXCLUSIVE).
- `set_monitor(gdk_monitor)` para elegir monitor; mapear cursor→GdkMonitor con `Gdk.Display.get_monitor_at_point(x,y)` usando `hyprctl cursorpos -j`.
- **Requiere backend Wayland nativo** (`GDK_BACKEND=wayland`). GtkLayerShell NO funciona bajo XWayland. hypr-player tenía `GDK_BACKEND=x11` como residuo de las versiones con mpv `--wid`; v8 (MPRIS puro) no lo necesita.
- La superficie aparece en `hyprctl layers` con su `namespace` (no en `hyprctl clients`). Estilizar con `layerrule = blur, hypr-player` (no `windowrulev2`).

### hypr-player v8 — 3 bugs encontrados con subagentes de testing
1. **Parsing de args:** solo aceptaba `--player=yt` (con `=`). El config de Waybar usa `--player music`/`--player vlc` (con espacio) → clicar esos módulos abría el player de YouTube. Fix: aceptar ambas formas.
2. **Singleton hacía "replace", no "toggle-off":** el 2º lanzamiento mataba al 1º pero abría uno nuevo → nunca cerraba. Fix: si hay instancia viva (`os.kill(pid,0)`), mandarle SIGTERM y `sys.exit(0)` sin abrir ventana. Ahora clic abre / clic cierra.
3. **No flotaba** (window rules rotas en 0.55) → resuelto con GtkLayerShell (arriba).

### Limpieza de ~/.local/bin y ~/.config/waybar
- Eliminados daemons MPRIS huérfanos (reemplazados por los 3 split mpris-yt/music/vlc): `mpris` (daemon único viejo), `mpris-scroll`, `mpris-waybar`. Verificado sin referencias en config/hypr/systemd antes de borrar.
- Eliminado `hypr-toast.bak` (el real existe) y 4 `.bak` sueltos en `~/.config/waybar/` (estados ya archivados en `bak/` con fecha).
- Snapshot del estado funcional en `~/.config/waybar/bak/20260623-working/` (config + style + scripts) y `hypr-player.pre-layershell` por si hay que revertir.
- **Nota multimonitor:** con 2 monitores, Waybar lanza 2 instancias de cada daemon mpris (1 por barra). Es correcto/inherente, no fuga.

## 2026-06-24 — Lock Super+Esc, doble-waybar y footguns de testing

### Super+Esc cerraba la sesión en vez de bloquear
- **Causa:** `hyprland.lua:181` tenía `hl.bind(mainMod .. " + Escape", hl.dsp.exit())` → `hl.dsp.exit()` **cierra Hyprland entero** (pierdes TODAS las ventanas y workspaces). No es un lock.
- **Fix:** `hl.dsp.exec_cmd("sh -c 'pidof hyprlock || hyprlock'")` (el `pidof` evita doble hyprlock). Para SALIR de Hyprland queda wlogout (módulo power de waybar).
- **OJO config activa:** la fuente de verdad es **`hyprland.lua`**, NO `hyprland.conf`. Confirmar con `hyprctl binds` (dispatchers `__lua N`). Los `.conf`, `monitors.lua`/`monitors.conf`, `workspaces.lua`/`workspaces.conf` (de nwg-displays) están **huérfanos**: `hyprland.lua` no los hace `require`. Editar el `.conf` no hace NADA.

### ⚠️ NUNCA lanzar/matar hyprlock en la sesión viva para "probar"
- El protocolo Wayland `ext-session-lock` mantiene la pantalla **bloqueada si el locker se cae** (diseño de seguridad). Si lanzas `hyprlock` y lo matas con `timeout`/`pkill`, muere sin liberar el lock → Hyprland muestra "el locker crasheó, recupera por TTY" → pantalla negra, hay que ir a un TTY (Ctrl+Alt+F2).
- **Validar la config de hyprlock por inspección, no lanzándolo.** Editar `hyprlock.conf` NO requiere reload de Hyprland (hyprlock lee su config al arrancar). Recuperación de emergencia: Ctrl+Alt+F2 → login → `pkill hyprlock` / `loginctl unlock-session`.

### hyprlock 0.9.5 — opciones removidas/movidas del config viejo
- Inválidas en `general`: `disable_loading_bar`, `grace` (ahora CLI `--grace`), `no_fade_in`, `no_fade_out`.
- Inválidas en `input-field`: `fail_timeout`, `fail_transition`.
- Las opciones desconocidas se loguean como error en cada lanzamiento; limpiarlas. El parser de hyprlock es el oráculo de qué es válido.

### waybar se arrancaba DOS veces → barras dobles + daemons mpris x2
- **Causa:** waybar lo lanzaban a la vez el autostart de Hyprland (`hl.exec_cmd("waybar")` en `hl.on("hyprland.start")`) **y** `waybar.service` (systemd). Al re-loguear ambos ganaron → 4 superficies (2 apiladas por monitor) y 12 daemons mpris.
- **Fix:** quitar `hl.exec_cmd("waybar")` del `.lua`; dejar systemd como único lanzador (tiene `Restart=always` y el hover-daemon depende de su orden). Limpieza runtime: `systemctl --user stop waybar` + `pkill -x waybar` + matar mpris huérfanos + `start`.
- **Footgun de pkill:** `pkill -f "bin/mpris-yt"` **mata el propio shell** (su cmdline contiene ese texto). Matar daemons solo si `comm==python3`: `for pid in $(pgrep -f /mpris-); do [ "$(ps -o comm= -p $pid)" = python3 ] && kill $pid; done`. Mismo cuidado al contar con `pgrep -cf`.

### Workspaces persistentes (en la config ACTIVA `hyprland.lua`)
- `for i=1,10 do hl.workspace_rule({ workspace = tostring(i), persistent = true }) end` → 10 workspaces que siempre existen y NO se pierden al hotplug de HDMI. Sin `monitor` = sin reasignar (cada uno vive donde se abra; Hyprland reubica al desconectar).
- Verificar: `hyprctl workspacerules -j` (debe listar 10 con `persistent=true`).
- **Validar Lua ANTES de `hyprctl reload`:** `luac -p hyprland.lua` (parse-only, no ejecuta). El reload re-corre el top-level pero NO re-dispara `hl.on("hyprland.start")`, así que no relanza apps de autostart.

### 4 módulos nuevos de Waybar (2026-06-24)
- **Izquierda (icono fijo, sin hover-expand):** `idle_inhibitor` (nativo waybar, eye/eye-slash) + `custom/dnd` (script `dnd`, dunstctl pause, bell/bell-slash). DND refresca instantáneo con `signal:4` + on-click `dunstctl set-paused toggle; pkill -RTMIN+4 waybar`.
- **Derecha (hover-expand, leen el state file):** `custom/resources` (script `resources`: CPU% por delta de /proc/stat + RAM% de /proc/meminfo + temp de `x86_pkg_temp`; color adaptativo) + `custom/updates` (script `updates`: `checkupdates`+`paru -Qua`, **cacheado** en `~/.cache/waybar-updates` con MAXAGE para no martillar en cada hover/signal).
- **Regla izquierda vs derecha:** los módulos icon-only van a la izquierda; el sistema hover-expand solo vive en la mitad derecha de la barra (el daemon escribe el state file global). Solo glyphs Nerd Font, sin emojis.
- **Bug `grep -c` + `|| echo 0`:** `grep -c .` imprime `0` Y sale con código 1 cuando no hay coincidencias → el `|| echo 0` añade OTRO `0` → `"0\n0"` → error aritmético. Usar `grep -c .` solo (ya imprime 0), con `${var:-0}` de respaldo.

### MPRIS idle state: FG_EMPTY definido pero no usado
- **Problema:** los 3 daemons mpris (yt/music/vlc) definían `FG_EMPTY` pero cuando no hay ningún player activo emitían `"text": ""` → iconos **invisibles**. El color gris dim (`#585b70`) existía como variable pero nunca se asignaba a la salida.
- **Causa raíz:** `if not meta:` → `print(json.dumps({"text": ""}))` en vez de mostrar el icono en color dim.
- **Fix:** cambiar idle output a `f"<span foreground='{FG_EMPTY}' …>{ICON}</span>"`. Ahora los 3 iconos siempre se ven; se iluminan al detectar un player activo.
- **Daemon startup:** también se fijó `zones = get_waybar_zones()` inmediato en vez de esperar 2s.

### Aún pendiente / deuda
- **Config muerta:** `hyprland.conf`, `monitors.conf/.lua`, `workspaces.conf/.lua` (de nwg-displays) están huérfanos — la activa es `hyprland.lua` y no los hace `require`. **[Resuelto 2026-06-25]** `hyprland.conf` movido a `orphans/hyprland.conf.20260625` para evitar confusión. Quedan vacíos en la raíz `monitors.conf`/`workspaces.conf` (0 bytes, inofensivos). **OJO:** nwg-displays guarda en hyprlang `.conf` → sus cambios de monitores NO se aplican; configurar monitores en `hl.monitor{}` dentro del `.lua`.

## Zen Browser — disparar Picture-in-Picture (PiP) desde fuera (2026-06-25)
- **Objetivo:** activar la ventana flotante de video de Zen desde Waybar y un atajo global.
- **Hallazgo 1:** Zen (Firefox release) **bloquea extensiones sin firmar** — `xpinstall.signatures.required` no se puede desactivar en builds release (limitación upstream Gecko). Solo carga temporal vía `about:debugging` (se borra al reiniciar). → Extensión propia permanente = inviable.
- **Hallazgo 2:** No hace falta extensión. Firefox/Zen trae **atajo nativo de PiP: `Ctrl+Shift+]`** (Linux). Lanza/cierra el video más relevante de la página.
- **El truco:** PiP no tiene disparador externo (ni D-Bus/MPRIS/CLI) y `requestPictureInPicture()` exige *user gesture*. Una pulsación real con `wtype` SÍ cuenta como gesto → enfocar Zen (`class:zen`) e inyectar el atajo.
- **Implementación:** script `~/.local/bin/zen-pip-toggle` (focuswindow zen + poll hasta que Zen tenga foco + `wtype -M ctrl -M shift -k bracketright -m shift -m ctrl`). Lo llaman el bind `SUPER+P` y el `on-click` de `custom/mpris-yt`.
- **¡Editar `hyprland.lua`, NO `.conf`!** (ver deuda «Config muerta» arriba y línea 272). Primera vez edité `hyprland.conf` → `SUPER+P` seguía haciendo `pseudo`. La activa es `hyprland.lua` (`configProvider: lua`). API Lua: `hl.bind`, `hl.dsp.exec_cmd`, `hl.window_rule({...})`, `hl.on("hyprland.start",...)`. Headers en `/usr/include/hyprland/src/config/lua/`.
- **Floating:** el PiP salía en mosaico → `hl.window_rule({ match={title="Picture-in-Picture"}, float=true, pin=true })` en `hyprland.lua`. `pin` = visible en todos los workspaces.
- **toggle-reload al arranque:** estaba solo en el `.conf` ignorado → no corría. Añadido al autostart Lua con `hl.exec_cmd("sh -c 'sleep 5 && toggle-reload'")` (delay porque waybar aún no está lista).
- **`wtype`** sube su propio keymap → funciona pese al layout `latam` (confirmado: el PiP abrió en la prueba). Caveat: disparar desde otro workspace enfoca Zen y cambia de workspace (limitación Wayland).

## Conciencia de monitores en Hyprland — helper + escala fraccionaria GTK3 (2026-06-25)
- **No es un "driver".** Driver = kernel↔hardware. Lo que se necesita para que scripts/ventanas "lean los monitores" es leer la IPC de Hyprland: `hyprctl monitors -j` (name, width, height, scale, x, y, focused) y `hyprctl cursorpos -j`. El tamaño LÓGICO de un monitor = `width / scale` (no el `width` físico).
- **Helper reutilizable:** `~/.local/bin/hypr-active-monitor` → JSON del monitor bajo el cursor (fallback focused) con `w_log`/`h_log` y flag `internal` (`^(eDP|LVDS|DSI)`). Lo usan el brillo unificado y (idea) cualquier futuro script.
- **GTK3 + escala fraccionaria = ventanas gigantes.** GTK3 NO soporta scale fraccionario (1.5). En eDP a scale 1.5, una ventana GTK3 (p.ej. hypr-player layer-shell) se renderiza agrandada; en un monitor a scale 1.0 sale bien. **Fix:** exportar `GDK_SCALE=1` antes de importar Gtk → GTK renderiza 1× y Hyprland aplica el scale uniformemente (queda algo menos nítido en HiDPI, aceptable).
- **Superficie layer-shell ≠ ventana:** no se puede mover/redimensionar con dispatchers de ventana (`SUPER+click-derecho` = resize no le aplica). Por eso hypr-player "no se podía achicar". El tamaño se controla en el código (WIN_W), ahora proporcional al ancho lógico del monitor (~30 %, 300–420px).
- **Brillo:** hay dos backends — eDP = `brightnessctl` (hardware real); externo/HDMI = `hyprctl hyprsunset gamma_output` (gamma software, state file en `~/.local/state/brightness-<name>`). El módulo `brightness` unifica ambos según el monitor activo.

## Brillo HDMI no cambiaba — hyprsunset.service colgado de graphical-session.target (2026-06-25)
- **Síntoma:** scroll de brillo en el monitor externo no hacía nada (el state file `~/.local/state/brightness-<name>` SÍ se actualizaba → engañoso).
- **Causa raíz:** `hyprsunset` (que aplica el gamma por output vía `hyprctl hyprsunset gamma_output <name> <val>`) NO estaba corriendo. Su `~/.config/systemd/user/hyprsunset.service` estaba `enabled` pero con `WantedBy=graphical-session.target`, y ese target **no se activa** en esta sesión Hyprland (sin uwsm). El comando fallaba (`Couldn't connect to .hyprsunset.sock`) pero con `2>/dev/null` no se veía, y el `echo "$n" > state` corría igual.
- **Fix:** en el `.service` → `WantedBy=default.target` (igual que waybar y waybar-hover-daemon, que SÍ arrancan), quitar `PartOf=graphical-session.target`; `systemctl --user daemon-reload && reenable && start`.
- **Regla:** en esta sesión Hyprland, los servicios user que deban arrancar al login van con `WantedBy=default.target`, NO `graphical-session.target`.
- **Verificar daemon vivo:** `pgrep -x hyprsunset` y `hyprctl hyprsunset gamma_output <mon> 0.5` debe devolver `ok` (no error de socket).

## Audio: cambiar salida = perfil de tarjeta, no solo sink (2026-06-25)
- **Clave:** en este laptop hay UNA tarjeta (HDA Intel PCH). Integrado y HDMI son **perfiles distintos de la misma tarjeta**, así que solo existe UN sink a la vez. Cambiar de salida NO es solo `set-default-sink`:
  - **Integrado (altavoces):** `pactl set-card-profile <card> output:analog-stereo+input:analog-stereo` + `set-sink-port <sink> analog-output-speaker`.
  - **Audífonos (jack):** mismo perfil analógico + puerto `analog-output-headphones` (el puerto solo está `available` si hay algo enchufado).
  - **HDMI:** `set-card-profile <card> output:hdmi-stereo+input:analog-stereo`.
  - **Bluetooth/USB:** sink aparte (aparece al conectar) → `set-default-sink`.
- Preferir el perfil con `+input:analog-stereo` para conservar el micrófono. Tras conmutar: `set-default-sink` + mover streams (`pactl move-sink-input <id> <sink>`); PipeWire suele moverlos solo igual.
- Detectar salida activa: `pactl get-default-sink` (`.hdmi`/`.analog` en el nombre) + `Active Port` de `pactl list sinks`.
- Live updates de un panel: hilo con `pactl subscribe` → `GLib.idle_add(refresh)` (debounce 200ms).
- Nuevo panel: `~/.local/bin/hypr-audio` (GTK3 layer-shell, clic-derecho en el módulo de volumen). Reusa andamiaje de `hypr-player` (paleta, singleton-toggle por PID, GtkLayerShell).
- **Gotcha:** `pkill -f 'patrón'` se auto-mata si el patrón aparece en la línea de comando del propio shell (exit 144). Matar por PID file o `ps -eo pid,args | awk '/[p]atrón/'` (clase de char evita el self-match).
