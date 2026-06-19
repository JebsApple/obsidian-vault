---
tags: [investigacion, obsidian, sync, mcp, multi-maquina]
---

# Sync Obsidian + MCPs entre máquinas

> Cómo mantener el vault sincronizado y los MCP servers disponibles en todas las máquinas del equipo.

---

## Obsidian Sync — opciones

### 1. Git + Obsidian Git plugin (actual — funcional)

**Setup actual:** vault en GitHub, plugin Obsidian Git hace commit cada 10 min y push cada 30 min. systemd timer como respaldo. Alias `vsync` para sync manual.

**Problemas conocidos:**
- Conflictos de merge si dos máquinas editan el mismo archivo simultáneamente
- iOS requiere Working Copy o SyncTrain (no hay plugin Git nativo)
- No es sync en tiempo real

### 2. Syncthing (recomendado multi-máquina local)

Peer-to-peer, sin servidor central. Ideal para máquinas en la misma LAN.

**Setup:**
```bash
# Instalar (Linux)
sudo pacman -S syncthing

# Iniciar
systemctl --user enable --now syncthing

# UI en http://localhost:8384
```

**Ventajas:** Tiempo real, sin servidor, FOSS, funciona en Android (Syncthing-Fork), iOS (SyncTrain).
**Desventaja:** No hay historial de versiones (combinar con Git para backup).

**Recomendación:** Syncthing para sync diario + Git como backup/versiones. Corren en paralelo sin conflicto (.stfolder en .gitignore, .git en .stignore).

### 3. Obsidian Sync (oficial, paga)

$4/mes. Sincronización en tiempo real, historial de 12 meses, cifrado E2EE, sin setup técnico.

**Ventaja:** Funciona en todas las plataformas (incluyendo iOS) sin configuración.
**Desventaja:** $$$, no tienes control de los datos.

### 4. Self-hosted LiveSync (CouchDB)

Plugin `obsidian-livesync` + CouchDB en servidor propio. Sync en tiempo real estilo Google Docs.

**Setup:** Docker con CouchDB + configurar plugin en cada instancia de Obsidian.
**Ventaja:** Tiempo real, self-hosted, gratis.
**Desventaja:** Setup más complejo, requiere servidor siempre encendido.

### 5. Tailscale + carpeta compartida

Tailscale crea una VPN punto-a-punto. Luego se puede usar Syncthing sobre Tailscale (para máquinas que no están en la misma LAN física), o compartir carpeta via NFS/SMB sobre Tailscale.

**Ventaja:** Funciona entre máquinas en distintas redes (no requiere LAN local).
**Setup:** Tailscale en cada máquina (`sudo pacman -S tailscale`, `sudo tailscale up`), luego Syncthing configurado para usar la IP de Tailscale.

---

## MCPs — distribución entre máquinas

### Problema

Cada máquina tiene su propia configuración de MCP servers (en `~/.config/opencode/opencode.jsonc` o `~/.claude/settings.json`). Si agregas un MCP server nuevo en una máquina, no aparece en las otras.

### Opción 1: Sincronizar configs via Git (simplista)

Agregar los archivos de configuración al vault o a un dotfiles repo:
```
~/.config/opencode/opencode.jsonc → vault/Configs/opencode.jsonc
~/.claude/settings.json           → vault/Configs/claude.json
```

**Script de deploy:** `sync-mcp.sh` que copia los archivos desde el vault a sus ubicaciones.

```bash
#!/bin/bash
cp ~/obsidian-vault/Configs/opencode.jsonc ~/.config/opencode/opencode.jsonc
cp ~/obsidian-vault/Configs/claude.json ~/.claude/settings.json
echo "MCP configs actualizados. Reinicia opencode/claude."
```

**Ventaja:** Simple, el vault es el source of truth.
**Desventaja:** Manual, fácil de desincronizar.

### Opción 2: MCP server remoto con Tailscale

Ejecutar MCP servers en una máquina "servidor" y consumirlos desde las otras vía HTTP/SSE (Streamable HTTP).

**Arquitectura:**
```
Máquina A (servidor MCP)     Máquina B (cliente)
  ┌─────────────────┐         ┌──────────────────┐
  │  GitHub MCP      │◄─HTTP──│  opencode/Claude  │
  │  PostgreSQL MCP  │   via   │  ── usa tools     │
  │  Filesystem MCP  │Tailscale│  remotamente      │
  └─────────────────┘         └──────────────────┘
```

**En el servidor MCP:** cada server se expone con `--transport sse` o se usa `mcp-gateway`.
**En el cliente:** se configura con `type: "remote"` y la URL `http://tailscale-ip:PORT`.

```jsonc
// opencode.jsonc en cliente
{
  "mcp": {
    "github": {
      "type": "remote",
      "url": "http://100.x.y.z:3100"
    }
  }
}
```

**Ventaja:** Los MCP servers se configuran una sola vez.
**Desventaja:** Latencia de red, dependencia del servidor central, tokens viajan por red.

### Opción 3: Tailscale Serve + MCP Gateway

Usar `tailscale serve` para exponer MCP servers HTTP/SSE a la tailnet. Todas las máquinas de la tailnet pueden consumirlos.

```bash
# En servidor MCP
tailscale serve --https 8443 / localhost:3100
```

Luego desde cualquier máquina en Tailscale: `http://servidor.tailnet-name.ts.net:8443`

### Opción 4: Configs dentro del vault + script idempotente

Guardar en `vault/Configs/` los archivos de configuración y un script `deploy-configs.sh` que:
1. Crea symlinks o copia archivos a los paths correctos de cada máquina
2. Detecta qué herramientas están instaladas (opencode, claude, cursor, etc.) y configura solo las relevantes

```bash
#!/bin/bash
VAULT="$HOME/obsidian-vault"
CONFIG="$VAULT/Configs"

# opencode
if command -v opencode &>/dev/null; then
  mkdir -p ~/.config/opencode
  cp "$CONFIG/opencode.jsonc" ~/.config/opencode/opencode.jsonc
fi

# Claude Code
if command -v claude &>/dev/null; then
  mkdir -p ~/.claude
  cp "$CONFIG/claude-settings.json" ~/.claude/settings.json
fi

echo "Configs desplegados en $(hostname)"
```

## Recomendación general

**Obsidian:** mantener Git como está (backup+versiones) + agregar Syncthing para sync en tiempo real entre máquinas del equipo (LAN o via Tailscale). `.stignore` para excluir `.git/` y `.obsidian/workspace.json`.

**MCPs:** sincronizar configs via vault (Opción 4) es el punto óptimo — simple, sin infraestructura extra, el vault ya está sincronizado. Si el equipo crece a 3+ máquinas, migrar a MCP servers remotos via Tailscale (Opción 3).

## Links
- [Syncthing](https://syncthing.net/)
- [Obsidian LiveSync](https://github.com/vrtmrz/obsidian-livesync)
- [Tailscale](https://tailscale.com/)
- [OpenCode MCP docs](https://opencode.ai/en/docs/mcp-servers)
- [MCP specs — Streamable HTTP](https://spec.modelcontextprotocol.io/)
