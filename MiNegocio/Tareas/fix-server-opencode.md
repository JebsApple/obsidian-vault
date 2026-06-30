---
tags:
  - servidor
  - opencode
  - pending
---
# Fix OpenCode en servidor (192.168.50.25)

Problemas detectados en `reporte-install-open-server.md`:

### 1. Sacar notificator (no existe en npm)

```bash
cd ~/.config/opencode
sed -i '/"opencode-notificator"/d' opencode.jsonc
```

### 2. GitHub MCP sin token — agregar wrapper

El ambiente del server no tiene `GITHUB_PERSONAL_ACCESS_TOKEN`. Solución: wrapper script que llama `gh auth token`.

```bash
mkdir -p ~/.local/bin

cat > ~/.local/bin/github-mcp-wrapper << 'EOF'
#!/bin/bash
export GITHUB_PERSONAL_ACCESS_TOKEN=$(gh auth token)
exec docker run --rm -i -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server
EOF

chmod +x ~/.local/bin/github-mcp-wrapper
```

Luego en `~/.config/opencode/opencode.jsonc` cambiar el comando del GitHub MCP de:

```jsonc
"command": "docker",
"args": ["run", "--rm", "-i", "-e", "GITHUB_PERSONAL_ACCESS_TOKEN", "ghcr.io/github/github-mcp-server"]
```

a:

```jsonc
"command": ["/home/icin/.local/bin/github-mcp-wrapper"]
```

Si `gh` no está instalado:

```bash
sudo pacman -S github-cli
gh auth login --web
```

### 3. Falta Ponytail plugin

```bash
mkdir -p ~/ponytail/.opencode/plugins

cat > ~/ponytail/.opencode/plugins/ponytail.mjs << 'PONYT'
export default {
  name: "ponytail",
  description: "Lazy senior dev mode - enforce YAGNI, stdlib first, shortest correct diff",
  hooks: {
    before_task: async (api) => {
      const messages = api.getMessages?.() ?? [];
      const last = messages?.[messages.length - 1]?.content ?? "";
      if (/ponytail|pony/i.test(last)) return { context: "PONYTAIL=lite" };
      return {};
    }
  }
};
PONYT
```

Agregar al array `plugins` en `opencode.jsonc`:

```jsonc
"/home/icin/ponytail/.opencode/plugins/ponytail.mjs"
```

### 4. Sacar Playwright del server (innecesario en headless)

En `opencode.jsonc`, eliminar la entrada `puppeteer-preview` (o el Playwright MCP) del objeto `mcpServers`.

---

**Prioridad:** 2-3-1-4 (GitHub MCP es lo más importante, Ponytail segundo, limpieza después).
