---
tags:
  - proyecto/whatsapp-bot
  - status/pendiente
---

# WhatsApp Remote Control — Plan

## Stack (100% local, sin APIs de pago)

| Componente | Estatus |
|-----------|---------|
| **Bridge WhatsApp** (verygoodplugins/whatsapp-mcp) | ✅ Instalado y vinculado |
| **MCP Server** (Python) | ✅ Instalado en OpenCode |
| **Ollama** (qwen2.5:3b) | ⏳ Instalado, falta descargar modelo |
| **faster-whisper** | ⏳ Pendiente instalar |
| **Bot server** (Python) | ⏳ Por escribir |

## Flujo

```
Usuario → WhatsApp (audio/texto)
  → Bridge (whatsapp-bridge)
    → Webhook (localhost:8769)
      → Bot server (Python)
        → Audio: Whisper (transcripción)
        → Texto → Ollama (qwen2.5:3b)
        → Respuesta → Bridge API (localhost:8080/api/send)
          → WhatsApp → Usuario
```

## Pendiente (próxima sesión)

1. Descargar modelo Ollama: `ollama pull qwen2.5:3b`
2. Escribir `~/.local/share/whatsapp-bot/server.py` (FastAPI)
3. Instalar faster-whisper en venv del bot
4. Configurar webhook del bridge (`WEBHOOK_URL`)
5. Crear systemd service `whatsapp-bot.service`
6. Probar: enviar audio → esperar → respuesta

## Notas

- Bridge corre como `whatsapp-mcp-bridge.service` (systemd user)
- Bridge API en `localhost:8080/api`, token en `store/.bridge-token`
- Webhook por defecto: `http://localhost:8769/whatsapp/webhook`
- Sin Claude API, sin OpenAI, sin GPU — todo CPU

## Historial

- **2026-07-07**: Instalado verygoodplugins/whatsapp-mcp, QR vinculado, MCP configurado en OpenCode
- **2026-07-07** (post-mortem): El MCP rompió opencode al reiniciar (server Python no arrancó). Se limpió bridge, servicio deshabilitado. Lección: usar `opencode-sandbox` para probar MCPs experimentales antes de aplicar a producción.
