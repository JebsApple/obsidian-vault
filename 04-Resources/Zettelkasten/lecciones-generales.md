---
created: 2026-07-11
tags:
  - tipo/zettel
  - tipo/moc
  - proyecto/minegocio
---

# Lecciones generales — MiNegocio

Índice de notas atómicas extraídas de `05-Archive/MiNegocio/Conocimiento/lecciones.md`.

## Vue.js / Frontend
- [[vue-localstorage-no-es-reactivo]] — localStorage no es reactivo, usar reactive()
- [[vue-auth-store-con-reactive]] — Auth store con reactive() en Vue 3
- [[jwt-auth-guard-router]] — Auth guard con meta.requiresAuth
- [[navbar-sidebar-no-duplicar]] — SideBar y NavBar no deben duplicar navegación
- [[authservice-logout-unificado]] — Centralizar logout en authService
- [[iconos-tabler-invisibles]] — Falta cargar la webfont de iconos
- [[build-ruta-con-parentesis]] — Build falla con paréntesis/espacios en ruta
- [[css-huerfanos-import-roto]] — Borrar CSS sin verificar imports rompe el build
- [[no-duplicar-datos-jwt-en-localstorage]] — No duplicar en localStorage lo que ya está en el JWT (si existe como nota separada)

## Backend / Go
- [[go-register-endpoint-cadena]] — Cadena handler → service → repository
- [[go-scan-null-coalesce]] — Scan() con NULL en PostgreSQL: COALESCE o sql.Null*
- [[bcrypt-hash-en-seed]] — Generar hash real en seed, no placeholder
- [[login-texto-plano-migrar-bcrypt]] — Migrar login de texto plano a bcrypt
- [[tabla-schema-mismatch]] — Verificar schema existente contra el esperado

## Base de datos
- [[go-scan-null-coalesce]]
- [[tabla-schema-mismatch]]
- [[bcrypt-hash-en-seed]]

## DevOps / Deploy
- [[docker-build-go-compilar-dentro]] — Compilar Go dentro del contenedor Docker
- [[dev-prod-separacion]] — Separación completa DEV/PROD
- [[nginx-symlink-sites-enabled]] — nginx necesita symlink en sites-enabled
- [[nginx-proxy-uploads-imagenes]] — Proxear /uploads/ al backend
- [[git-ramas-en-espanol]] — Nomenclatura de ramas en español
- [[gitea-ssh-vs-http]] — SSH funciona sin contraseña, HTTP requiere token

## Hyprland
- [[hyprland-config-lua]] — Config en Lua, no .conf
- [[hyprland-dispatchers-argumentos-lua]] — Dispatchers interpretan args como Lua
- [[hyprland-flotar-gtk-layershell]] — GtkLayerShell para ventanas flotantes
- [[gtk3-escala-fraccionaria-gdk-scale]] — GTK3 + escala fraccionaria: GDK_SCALE=1
- [[hyprland-monitor-helper-escala]] — Leer monitores via IPC, helper reutilizable
- [[hyprlock-no-lanzar-en-sesion]] — Nunca lanzar hyprlock para probar
- [[systemd-wantedby-default-target]] — Servicios user: WantedBy=default.target
- [[brillo-hdmi-hyprsunset-service]] — Verificar daemon vivo antes de debuggear script
- [[zen-pip-wtype-gesto]] — wtype simula user gesture para PiP

## Waybar
- [[waybar-css-hover-per-module]] — Hover per-module con daemon
- [[waybar-daemon-life-cycle]] — Daemon independiente, no atar a waybar
- [[waybar-mprios-idle-iconos]] — Mostrar icono dim en idle state
- [[waybar-pango-font-size-pt]] — font_size sin unidad = invisible
- [[waybar-double-start-problema]] — No lanzar waybar desde dos orígenes

## Audio / PipeWire
- [[audio-cambiar-perfil-tarjeta]] — Cambiar salida = perfil de tarjeta
- [[pipewire-default-nodes-limpiar]] — Limpiar default-nodes de dispositivos eliminados
- [[mic-virtual-pipewire-loopback]] — Micrófono virtual con PipeWire loopback

## MCP / Tooling
- [[opencode-sandbox-mcp]] — Sandbox para probar MCPs
- [[whatsapp-mcp-rompe-opencode]] — MCP mal configurado impide arrancar opencode
- [[obsidian-vault-sync]] — Sync del vault: git + timer + plugin

## Terminal TUI / ani-cli-hub
- [[fzf-placeholder-quoting]] — fzf envuelve {} en comillas simples: nunca comillas propias; usar {n} + --delimiter
- [[kitty-unicode-placeholders]] — imágenes como celdas de texto: scrollean con CSI S/T y son decodificables para tests
- [[bash-source-cero-trampa]] — $0 al sourcear = nombre del shell; state dirs por $0 necesitan env override
- [[rm-fd-abierto-inode-huerfano]] — rm de archivo con fd abierto por redirección: escrituras van a inode sin nombre
