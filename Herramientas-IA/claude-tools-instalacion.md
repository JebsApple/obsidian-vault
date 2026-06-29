---
tags: [claude, devtools, instalacion, mcp, ai, servidor]
fecha: 2026-06-28
actualizado: 2026-06-29
---

# Instalación de herramientas para Claude Code

Guía para instalar las herramientas que complementan Claude Code en un servidor Linux.
Preparada para el servidor de la universidad (Debian/Ubuntu/cualquier distro con apt o pacman).

---

## Requisitos previos

> **IMPORTANTE (lección 2026-06-29):** `claude-mem` necesita **Node 20.12+** (NO v18). Con Node 18 falla con
> `SyntaxError: ... 'node:util' does not provide an export named 'styleText'`. Instalar Node 20 con nvm (sin sudo).

```bash
# Verificar que tenés lo necesario
node --version   # necesita v20.12+ (claude-mem). v18 NO sirve
npm --version
python3 --version  # necesita 3.10+
unzip -v         # requerido por el instalador de Bun (ver abajo)
```

### Node 20 con nvm (sin sudo, no pisa el Node del sistema)

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.bashrc
nvm install 20
nvm alias default 20
node -v   # v20.x
```

> Abrir Claude Code SIEMPRE con Node 20 activo (`nvm use 20`), sino los hooks de claude-mem fallan.

### unzip (lo pide el instalador de Bun)

```bash
sudo apt install -y unzip
```

Si no tenés `uv` (gestor de paquetes Python moderno):

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc  # o ~/.zshrc si usás zsh
```

---

## 1. headroom-ai — Compresión de contexto (60-95% menos tokens)

Reduce el tamaño de lo que Claude recibe como input. Útil para proyectos grandes o cuando se mandan muchos archivos de golpe.

```bash
uv tool install "headroom-ai[all]"
```

Verificar instalación:

```bash
headroom doctor
```

Wrapear Claude Code para que headroom actúe automáticamente:

```bash
headroom wrap claude
```

Para desactivarlo:

```bash
headroom unwrap claude
```

Comandos útiles:

```bash
headroom perf          # ver cuánto está comprimiendo
headroom dashboard     # dashboard en tiempo real
headroom update        # actualizar headroom
```

> **Nota:** Si el servidor tiene poca RAM, headroom puede instalarse sin el extra `[ml]` para evitar cargar modelos locales:
> ```bash
> uv tool install "headroom-ai[proxy,mcp,code]"
> ```

---

## 2. claude-mem — Memoria persistente entre sesiones

Captura observaciones de las sesiones y las inyecta automáticamente en sesiones futuras. Resuelve el problema de Claude "olvidando" contexto al reconectar.

```bash
nvm use 20          # OBLIGATORIO: con Node 18 falla
npx claude-mem install
```

> **Dos requisitos que el instalador exige (lección 2026-06-29):**
> 1. **Node 20.12+** activo (`nvm use 20`), sino aborta con error de `styleText`.
> 2. **Bun** instalado, sino aborta con `bun-missing-after-install`. Instalar Bun ANTES:
>    ```bash
>    sudo apt install -y unzip          # Bun lo necesita
>    curl -fsSL https://bun.sh/install | bash
>    source ~/.bashrc
>    bun --version
>    ```

**Preguntas del instalador (qué elegir):**
- **Runtime provider** → **Worker** (local, single-user, estable). NO elegir *Server (beta)* salvo que quieras
  backend compartido por un equipo con API keys (REST V1, team-ready storage).
- **Plan** → **Subscription plan** (NO "API key").

Verificar:

```bash
npx claude-mem --version
```

La UI web queda disponible en `http://localhost:37777` cuando está activo.

Buscar en memoria desde Claude:

```
search(query="autenticación JWT", type="bugfix", limit=10)
get_observations(ids=[123, 456])
```

Para que algo no quede guardado en memoria, envolverlo en tags `<private>`:

```
<private>
esto no se guarda
</private>
```

---

## 3. ui-ux-pro-max — Skill de diseño UI/UX para Claude

Agrega 67 estilos, 161 paletas, 57 combinaciones tipográficas y reglas de diseño para que Claude genere interfaces de calidad en lugar de templates genéricos.

```bash
npm install -g ui-ux-pro-max-cli
uipro init --ai claude --global
```

Esto instala el skill en `~/.claude/skills/`.

Verificar instalación:

```bash
uipro versions
```

Actualizar:

```bash
uipro update
```

Uso — simplemente pedirle a Claude lo que necesitás:

```
"Construí una landing page para un SaaS de inventario"
"Creá un dashboard con tema oscuro para el sistema de ventas"
"Diseñá un formulario de registro con glassmorphism"
```

Comandos avanzados (generación de design system):

```bash
# Genera sistema de diseño para tu tipo de proyecto
python3 ~/.claude/skills/ui-ux-pro-max/scripts/search.py "SaaS inventario" --design-system -p "MiNegocio"

# Guarda el resultado en design-system/MASTER.md
python3 ~/.claude/skills/ui-ux-pro-max/scripts/search.py "SaaS inventario" --design-system --persist -p "MiNegocio"
```

---

## 4. n8n-mcp — MCP server para n8n (automatización de workflows)

Permite que Claude acceda a documentación de 2.063 nodos de n8n y pueda construir/validar workflows.

Agregar como MCP server (modo solo documentación, sin instancia n8n):

```bash
claude mcp add n8n-mcp npx n8n-mcp \
  -e MCP_MODE=stdio \
  -e LOG_LEVEL=error \
  -e DISABLE_CONSOLE_OUTPUT=true
```

Si tenés una instancia n8n corriendo, agregar también las credenciales:

```bash
claude mcp add n8n-mcp npx n8n-mcp \
  -e MCP_MODE=stdio \
  -e LOG_LEVEL=error \
  -e DISABLE_CONSOLE_OUTPUT=true \
  -e N8N_API_URL=http://localhost:5678 \
  -e N8N_API_KEY=tu-api-key-aqui
```

Verificar que quedó registrado:

```bash
claude mcp list
```

Herramientas disponibles desde Claude después de agregarlo:

```
search_nodes({query: 'slack'})
get_node({nodeType: 'n8n-nodes-base.httpRequest'})
validate_workflow(workflowObject)
search_templates({query: 'webhook'})
```

> **Advertencia:** Nunca usar Claude para editar workflows de producción directamente. Siempre copiar primero y probar en desarrollo.

---

## Orden de instalación recomendado

```
1. uv                  → prerequisito para headroom
2. headroom-ai[all]    → compresión de contexto
3. claude-mem          → memoria entre sesiones
4. ui-ux-pro-max-cli   → skill de diseño (global)
5. n8n-mcp             → MCP server (solo si usás n8n)
```

---

---

## Instalación en el servidor (192.168.50.25)

Usar los scripts preparados en la máquina local. Evitan reinstalar todo desde cero copiando el bundle de headroom directamente.

### Scripts disponibles (en `~/` de la máquina local)

| Script                           | Dónde corre | Qué hace                                                                   |
| -------------------------------- | ----------- | -------------------------------------------------------------------------- |
| `bundle-for-server.sh`           | Local       | Empaqueta uv + headroom y los copia al server vía scp                      |
| `install-claude-tools-server.sh` | Server      | Instala todo (headroom desde bundle, ui-ux-pro-max, n8n-mcp, shell config) |

### Pasos

**En la máquina local:**

```bash
%% bash ~/bundle-for-server.sh %%
```

Esto empaqueta headroom, lo copia al server junto con el script de instalación, y muestra qué correr después.

**En el server (SSH):**

```bash
ssh icin@192.168.50.25
bash ~/install-claude-tools-server.sh
```

**claude-mem — paso manual (en el server):**

Este tool no se puede automatizar porque pide seleccionar el plan interactivamente.

```bash
npx claude-mem install
# Cuando pregunte → elegir "Subscription plan" (NO "API key")
```

**Activar cambios en la sesión actual:**

```bash
source ~/.bashrc
headroom proxy &
headroom doctor
```

### Qué hace el script automáticamente

1. Extrae uv + headroom del bundle (evita re-descargar 500MB de dependencias)
2. Instala ui-ux-pro-max globalmente (`~/.claude/skills/`)
3. Registra n8n-mcp como MCP server en Claude
4. Agrega al `.bashrc`:
   - `PATH` con `~/.local/bin`
   - `ANTHROPIC_BASE_URL=http://127.0.0.1:8787`
   - Autostart del proxy headroom al abrir shell

### Notas

- Si el server usa **zsh** en vez de bash, editar la línea `SHELL_RC` en el script antes de correrlo
- Si el server **no tiene Node.js**, instalar antes: `sudo apt install nodejs npm` (Debian/Ubuntu)
- El bundle de headroom funciona solo si ambas máquinas son **x86_64 Linux**

---

## Lecciones de la instalación real (2026-06-29, server 192.168.50.25)

Resumen de los tropiezos reales al instalar en el server `ubuntuserver6` y cómo se resolvieron.

### 1. Node 18 → no sirve para claude-mem
Síntoma: `SyntaxError: ... 'node:util' does not provide an export named 'styleText'`.
Fix: Node 20 vía nvm (sin sudo). Correr Claude siempre con `nvm use 20`.

### 2. claude-mem necesita Bun + unzip
Síntoma: `Installation Aborted: bun-missing-after-install`, y al instalar Bun: `error: unzip is required`.
Fix: `sudo apt install -y unzip` → `curl -fsSL https://bun.sh/install | bash`.

### 3. claude-mem: elegir Worker, no Server (beta)
Worker = local single-user (lo correcto). Server (beta) = backend de equipo con API keys.

### 4. El bundle de headroom (2,85 GB) NO entra en este disco
El server tiene solo **24 GB** y vive casi lleno. El bundle + extraerlo necesita ~6 GB libres.
Solución: **olvidarse del bundle**, instalar headroom directo y **liviano** (sin modelos ML):
```bash
uv tool install "headroom-ai[proxy,mcp,code]"   # NO [all] en este server
```

### 5. ⚠️ DISCO LLENO = LAG GENERAL (causa raíz de muchos fallos)
El disco al 95-96% provocaba **terminal lenta y fallos intermitentes de los MCP** (ej. obsidian-mcp
con `npx` no podía escribir su caché y se caía). NO es por ser server compartido: el otro usuario
(`deployequipo6`) usa ~4 KB. El grueso es de `icin`, sobre todo el **build cache de Docker** (llegó a 3,8 GB
de tanto compilar el backend Go) y `~/.npm/_npx` (~1,7 GB cada vez que se usa `npx n8n-mcp`).

**Limpieza segura (correr de vez en cuando):**
```bash
docker builder prune -af            # build cache Docker (el grande)
docker image prune -f               # imágenes dangling
npm cache clean --force; rm -rf ~/.npm/_npx
go clean -cache                     # cache de build Go (regenera)
sudo apt clean && sudo apt autoremove -y
sudo journalctl --vacuum-size=50M
```
Pasó de 96% (1,1 GB libre) a **72% (6,3 GB libre)** y la terminal volvió a ser veloz.

**NUNCA sin confirmar:** `docker volume prune` (volúmenes pueden tener datos de PostgreSQL),
ni borrar contenedores corriendo (`minegocio-backend`, `minegocio-backend-dev`).

### 6. n8n-mcp se re-descarga con npx
`claude mcp add n8n-mcp npx n8n-mcp ...` funciona, pero cada arranque baja ~1,7 GB a `~/.npm/_npx`.
Si se usa seguido, instalar global (`npm i -g n8n-mcp`) o limpiar `~/.npm/_npx` después.

### 7. obsidian-mcp fallaba por el disco
Mismo motivo que el punto 5: `npx -y obsidian-mcp` no podía escribir caché con el disco lleno.
Con espacio libre conecta bien. Para robustez, fijar a la versión global ya instalada (`npm i -g obsidian-mcp`)
y cambiar el comando en `~/.claude.json` de `npx`/`-y obsidian-mcp` a `obsidian-mcp` directo.

---

## Post-instalación: adaptación para opencode (2026-06-29)

### claude-mem → systemd + plugin opencode

```bash
# Worker como servicio systemd user
~/.config/systemd/user/claude-mem.service
  → ExecStart: bun worker-service.cjs --daemon
  → Puerto: 37777

# Plugin opencode registrado
~/.config/opencode/plugins/claude-mem.js
  → hooks: session.start, user.prompt.submit, tool.execute.after
  → tool: claude_mem_search
```

### headroom-ai → opencode-dcp (plugin)

headroom-ai no funciona con opencode (es wrapper del CLI `claude`).
Alternativa: `@tarquinen/opencode-dcp` (context pruning plugin).

```bash
npm install --prefix ~/.config/opencode @tarquinen/opencode-dcp
```

### n8n-mcp → Dagu (workflow engine con MCP)

Alternativa más liviana que n8n: single binary Go, zero dependencias, MCP nativo.

```bash
# Instalación
curl -fsSL https://github.com/dagucloud/dagu/releases/download/v2.8.3/dagu_2.8.3_linux_amd64.tar.gz ...
mv dagu ~/.local/bin/

# systemd service
~/.config/systemd/user/dagu.service
  → Puerto: 8090
  → MCP endpoint: http://127.0.0.1:8090/mcp
```

### MCPs agregados 2026-06-29 (sesión 2)

| MCP | Paquete | Propósito | Estrellas |
|-----|---------|-----------|-----------|
| **context7** | `@upstash/context7-mcp` | Docs oficiales de librerías | — |
| **postgres** | `@modelcontextprotocol/server-postgres` | Consultas SQL a DB minegocio | deprecated |
| **github** | `ghcr.io/github/github-mcp-server` (Docker) | Issues, PRs, code search, Actions | 31k⭐ |
| **playwright** | `@playwright/mcp` | Browser automation (click, snapshot, network) | 34k⭐ |

### Plugins opencode agregados 2026-06-29

| Plugin | Función |
|--------|---------|
| `@prevalentware/opencode-goal-plugin` | `/goal` — tareas autónomas multi-turno |
| `opencode-wakatime` | Time tracking metrics |
| `opencode-vibeguard` | Redacta secrets antes de enviar al LLM |
| `opencode-notificator` | Notificaciones desktop |
| `opencode-websearch-cited` | Web search con citas |
| `@plannotator/opencode` | Plan review interactivo |

### Estado actual opencode

```jsonc
"plugin": [
  "ponytail.mjs",                       // voz lazy
  "claude-mem.js",                      // memoria persistente
  "@tarquinen/opencode-dcp",            // context pruning
  "@plannotator/opencode",              // plan review
  "opencode-wakatime",                  // time tracking
  "opencode-vibeguard",                 // secret redaction
  "opencode-notificator",               // desktop notifications
  "opencode-websearch-cited",           // web search
  "@prevalentware/opencode-goal-plugin" // goal mode
],
"mcp": {
  "obsidian": {},     // vault
  "dagu": {},         // workflows
  "context7": {},     // docs librerías
  "postgres": {},     // DB minegocio
  "github": {},       // GitHub API (needs GITHUB_PERSONAL_ACCESS_TOKEN)
  "playwright": {}    // browser automation
}
```

### Lecciones
- `@ngotrnghia1811/opencode-headroom` tiene dependencias nativas pesadas (prebuild-install) que pueden no compilar o colgar el install.
- DCP hace lo mismo (context pruning) sin dependencias nativas.
- Dagu con `auth.mode: none` + `127.0.0.1` es seguro para uso local.
- claude-mem worker necesita `--daemon` para systemd, sino el proceso se muere al forkear.
- Playwright MCP necesita Chromium descargado (114MB) + sudo para system deps.
- GitHub MCP necesita `export GITHUB_PERSONAL_ACCESS_TOKEN=ghp_xxx` en el shell.
- DCP + claude-mem + magic-context **pueden coexistir** pero se pisan: DCP y magic-context ambos prunean contexto, claude-mem y magic-context ambos guardan memoria. Mejor elegir un stack (DCP+claude-mem probados, o magic-context solo como reemplazo).
- Los plugins no gastan tokens extra salvo que inyecten contenido en prompts. DCP reduce tokens.

---

## Archivado / Pendiente

### LightRAG
Sistema de RAG con grafo de conocimiento. Útil para proyectos con cientos de documentos.
Requiere bastante RAM (mínimo 8 GB libres recomendados).

```bash
# Instalación Docker cuando corresponda
git clone https://github.com/HKUDS/LightRAG.git
cd LightRAG
cp env.example .env
# editar .env con API key del LLM a usar
docker compose up
# UI disponible en http://localhost:9621
```
