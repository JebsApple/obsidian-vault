---
tags: [concepto, aprendizaje]
---

# Lecciones Aprendidas

Registra aquí errores y soluciones para no repetirlos.

## Formato
- **Problema:** Breve descripción
- **Solución:** Cómo se resolvió
- **Causa raíz:** Por qué ocurrió

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
- [2026-06-18] Instalado plugin Automatic Linker — convierte texto en `[[links]]` automáticamente al guardar, sin AI
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
