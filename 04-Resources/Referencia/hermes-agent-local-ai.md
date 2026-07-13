---
tags:
  - ai/local
  - hermes
  - ollama
  - Referencia
created: 2026-07-12
---

# Hermes Agent + Local AI

## Hermes Agent

- Open-source coding agent de NousResearch
- 182K+ GitHub stars, MIT license
- Ejecuta código, navega archivos, busca en web
- Usa model context protocol (MCP) para herramientas
- Corre 100% local con Ollama o llama.cpp

## Hardware mínimo

| Tier | RAM | Modelos | Uso |
|------|-----|---------|-----|
| Mínimo | 8GB | 3B models | Tareas simples |
| Recomendado | 16GB+ | 7-14B | Uso general |
| Ideal | 32GB+ | 27B+ | Coding profundo |

## Mejores modelos locales (2026)

| Modelo | Params | Mejor para |
|--------|--------|------------|
| Qwen 2.5-Coder 32B | 32B | Coding, profundo |
| Gemma 4 | 12B | Efficiency, balance |
| Llama 3 | 8B | Mínimo viable |
| Hermes 3 |多样化 | General purpose |

## Setup rápido

```bash
# 1. Instalar Ollama
curl -fsSL https://ollama.com/install.sh | sh

# 2. Pull modelo
ollama pull qwen2.5-coder:32b

# 3. Verificar
ollama run qwen2.5-coder:32b

# 4. Open WebUI (frontend chat)
docker run -d -p 3000:8080 \
  -v ollama:/root/.ollama \
  ghcr.io/open-webui/open-webui:main
```

## Arquitectura híbrida

```
Tareas privadas → Hermes + Ollama (local)
Tareas difíciles → API fallback (Claude/GPT)
Routing → Config en hermes config file
```

## vLLM (GPU server)

- Para serving de alto throughput
- Tensor parallelism en múltiples GPUs
- API compatible con OpenAI
