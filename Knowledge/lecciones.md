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
