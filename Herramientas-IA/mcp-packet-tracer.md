---
tags: [mcp, packet-tracer, cisco, herramientas-ia]
---

# MCP: Cisco Packet Tracer

## Server

- Repo local: `/home/apuru/packet-tracer-mcp`
- Framework: Bun 1.3.14
- Puerto bridge: `:54321`
- 57 tools

## Config

### OpenCode (`~/.config/opencode/opencode.jsonc`)

```json
{
  "mcpServers": {
    "packet-tracer": {
      "type": "local",
      "command": "/home/apuru/.bun/bin/bun",
      "args": ["run", "/home/apuru/packet-tracer-mcp/src/index.ts", "--stdio"]
    }
  }
}
```

### Claude Code (`~/.claude/settings.json`)

```json
{
  "mcpServers": {
    "packet-tracer": {
      "command": "/home/apuru/.bun/bin/bun",
      "args": ["run", "/home/apuru/packet-tracer-mcp/src/index.ts", "--stdio"]
    }
  }
}
```

## Requisito

Packet Tracer 9.0 debe estar ejecutándose con la extensión `mcp-bridge.pts` cargada:

1. Abrir PT
2. `Extensions → Scripting → Configure PT Script Modules`
3. Verificar que `mcp-bridge.pts` esté agregado y marcado **On Startup**
4. Ruta: `/home/apuru/packet-tracer-mcp/extension/dist/mcp-bridge.pts`

Bridge escucha en `ws://127.0.0.1:54321`.

## Uso

El server se conecta automáticamente al iniciar. Si PT está abierto con la extensión, responde con topología en vivo.

Flujo recomendado:
1. `pt_bridge_status` — verificar conexión
2. `pt_query_topology` — ver qué hay en el canvas
3. `pt_plan_review` — planificar antes de escribir
4. `pt_add_device`, `pt_create_link`, etc.
