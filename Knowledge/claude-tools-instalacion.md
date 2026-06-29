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

```bash
# Verificar que tenés lo necesario
node --version   # necesita v18+
npm --version
python3 --version  # necesita 3.10+
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
npx claude-mem install
```

Si falla el npx directo, instalar Node 20+ primero y reintentar.

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
