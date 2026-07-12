---
title: Hermes Agent — Plan de Instalación
tags: [proyecto, proyecto/hermes, ia, agentes, plan]
created: 2026-07-10
status: pendiente
---

# Hermes Agent — Plan de Instalación

## Qué es
Hermes Agent es un runtime autónomo de agentes IA por Nous Research (MIT). No es un chatbot — es un sistema que ejecuta agentes persistentes en tu infraestructura.

**Repo:** https://github.com/nousresearch/hermes-agent

### Features clave
- Memoria persistente (SQLite + FTS5)
- Skills auto-mejorables
- 15+ plataformas (Telegram, Discord, Slack, WhatsApp, Signal, etc.)
- 6 sandboxes (local, Docker, SSH, Modal, Daytona, Singularity)
- Multi-modelo
- Cron integrado
- Sub-agentes

---

## Stack gratuito seleccionado

| Componente | Proveedor | Costo |
|------------|-----------|-------|
| LLM primario | Google Gemini API | Gratis (1,500 req/día) |
| LLM fallback | Groq | Gratis (14,400 req/día) |
| Subagente coding | Claude Code CLI (Pro) | Ya incluido en suscripción |
| Messenger | Telegram Bot | Gratis |
| Hosting Fase 2a | Oracle Cloud Free Tier | Gratis (ARM 2 OCPU, 12GB RAM) |
| Backend Fase 2a | Modal | Gratis ($30 crédito/mes) |

---

## Fase 1: Local ($0)

### 1. Instalar Hermes Agent
```bash
git clone https://github.com/nousresearch/hermes-agent.git
cd hermes-agent
# Seguir instrucciones del README para setup
```

### 2. Configurar LLMs gratuitos
```bash
# ~/.hermes/.env
GOOGLE_API_KEY=tu_key_aqui
GROQ_API_KEY=tu_key_aqui
```

```yaml
# ~/.hermes/config.yaml
model:
  provider: google
  name: gemini-2.5-flash
  fallback:
    provider: groq
    name: llama-3.3-70b-versatile
```

### 3. Instalar hermes-code-bridge (subagente Claude Code)
```bash
git clone https://github.com/xaycruz/hermes-code-bridge.git
```

### 4. Conectar Telegram
1. Crear bot con @BotFather
2. Obtener token
3. Configurar en `~/.hermes/config.yaml`:
```yaml
channels:
  telegram:
    bot_token: tu_token_aqui
```

### 5. Primer uso
- Enviar mensajes desde Telegram
- Dejar que aprenda patrones y cree skills
- Probar subagente Claude Code

---

## Fase 2a: Hosting gratis ($0/mes)

### Oracle Cloud Free Tier
- ARM: 2 OCPU + 12GB RAM (siempre gratis)

### Modal (backend serverless)
- Se activa solo cuando hay tareas, se duerme en idle (~$0)

---

## Fase 2b: Futuro
- Home PC o Raspberry Pi
- Cloudflare Tunnel para acceso externo

---

## Costo total

| Fase | Costo mensual |
|------|---------------|
| Fase 1 | $0 (solo Pro $20 que ya se paga) |
| Fase 2a | $0 |
| Fase 2b | $0 |

---

## Referencia rápida

- **Config principal:** `~/.hermes/config.yaml`
- **API keys:** `~/.hermes/.env`
- **Memoria:** SQLite local
- **Skills:** Se auto-crean con uso

---

*Última actualización: 2026-07-10*
