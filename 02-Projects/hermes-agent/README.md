---
aliases: [hermes, hermes-agent]
tags: [project, proyecto/hermes, ia, agentes]
created: 2026-07-10
status: pendiente
deadline: ""
---

# Hermes Agent

**Objetivo:** Instalar y configurar Hermes Agent (Nous Research, MIT) como runtime autónomo de agentes IA con memoria persistente, skills auto-mejorables, y conexión a Telegram.

**Stack:** Python, SQLite + FTS5, Gemini API + Groq (gratis)

**Repos:**
- Upstream: https://github.com/nousresearch/hermes-agent
- Local: `~/.hermes/`

---

## Estado

| Fase | Estado |
|------|--------|
| Fase 1: Local ($0) | 📋 Pendiente |
| Fase 2a: Hosting Oracle Cloud | 📋 Pendiente |

## Stack gratuito

| Componente | Proveedor | Costo |
|------------|-----------|-------|
| LLM primario | Google Gemini API | Gratis (1,500 req/día) |
| LLM fallback | Groq | Gratis (14,400 req/día) |
| Messenger | Telegram Bot | Gratis |
| Hosting Fase 2a | Oracle Cloud Free Tier | Gratis |

## Links

- [[hermes-agent-plan|Plan de instalación completo]]
- [[MOCs/index|← Projects Index]]
