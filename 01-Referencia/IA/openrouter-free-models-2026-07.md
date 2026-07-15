# Modelos Gratuitos OpenRouter — Guía Subagéntica

> Última actualización: 2026-07-14
> Fuente: `https://openrouter.ai/api/v1/models` (pricing.prompt == "0")
> Total: 22 modelos gratuitos

---

## Leyenda de capacidades

| Símbolo | Significado |
|---------|-------------|
| 🧠 | Reasoning (puede "pensar" antes de responder) |
| 🔧 | Tools (soporta function calling / tool use) |
| 👁️ | Vision (acepta imágenes) |
| 📐 | Structured Outputs (JSON schema enforcement) |
| 📏 | Context window en tokens |

---

## 🏆 Tier S — Los mejores para subagentes

### `qwen/qwen3-coder:free` — **CÓDIGO**
- **480B params (35B activos, MoE)** | 📏 1M tokens | 🔧 Tools
- 🏅 **#1 en coding**: 61.2% win rate en Design Arena code categories
- Ideal para: **agentes de código**, code review, generación de funciones
- Ejemplo: `openrouter/qwen/qwen3-coder:free`

### `nvidia/nemotron-3-ultra-550b-a55b:free` — **RAZONAMIENTO GENERAL**
- **550B params (55B activos, MoE)** | 📏 1M tokens | 🧠 🔧 📐
- 🏅 **Mejor intelligence index (37.8)**, coding 49.3, agentic 27.4
- Ideal para: **agentes de análisis**, planes complejos, arquitectura
- Ejemplo: `openrouter/nvidia/nemotron-3-ultra-550b-a55b:free`

### `tencent/hy3:free` — **TODO-ROUNDER**
- **295B params (21B activos, 192 expertos)** | 📏 262K | 🧠 🔧 📐
- Razonamiento configurable, agentic workflows
- Ideal para: **subagente general** que necesita equilibrio entre razonamiento y velocidad
- Ejemplo: `openrouter/tencent/hy3:free`

---

## 🥇 Tier A — Excelentes para tareas específicas

### `poolside/laguna-m.1:free` — **CÓDIGO (flagship)**
- 📏 262K | 🧠 🔧
- Flagship coding model de Poolside, optimizado para SE complejo
- Ideal para: **refactoring**, arquitectura de código, tareas de código largas

### `poolside/laguna-xs-2.1:free` — **CÓDIGO (light)**
- 33B (3B activos) | 📏 262K | 🧠 🔧
- Coding agent rápido y eficiente
- Ideal para: **tareas de código rápidas**, fixes simples, snippets

### `google/gemma-4-31b-it:free` — **VISIÓN + CÓDIGO**
- 30.7B dense | 📏 262K | 🧠 🔧 👁️
- Multimodal (texto + imágenes), reasoning mode
- Ideal para: **análisis de pantallazos**, UI review, código con contexto visual
- Ejemplo: `openrouter/google/gemma-4-31b-it:free`

### `cohere/north-mini-code:free` — **CÓDIGO (light)**
- 30B (3B activos, MoE) | 📏 256K | 🧠 🔧
- Coding index: 36.5
- Ideal para: **tareas de código ligeras**, donde no se necesita modelo grande

### `nvidia/nemotron-3-super-120b-a12b:free` — **ANÁLISIS**
- 120B (12B activos, MoE) | 📏 1M | 🧠 🔧 📐
- Coding index: 37.7, intelligence: 25.4
- Ideal para: **análisis de datos**, procesamiento de documentos largos (1M context)

---

## 🥈 Tier B — Buenos, con limitaciones

### `google/gemma-4-26b-a4b-it:free` — **VISIÓN (eficiente)**
- 25.2B (3.8B activos, MoE) | 📏 262K | 🧠 🔧 👁️ 📐
- Near-31B quality con costo computacional bajo
- Ideal para: **visión barata**, análisis de imágenes, cuando Gemma 4 31B esté ocupado

### `qwen/qwen3-next-80b-a3b-instruct:free` — **RAPIDO**
- 80B (3B activos) | 📏 262K | 🔧 📐
- Sin reasoning mode, respuestas estables
- Ideal para: **tareas simples y rápidas**, respuestas directas sin "pensar"

### `nvidia/nemotron-3-nano-30b-a3b:free` — **COMPACTO**
- 30B (3B activos) | 📏 256K | 🧠 🔧
- Intelligence: 14.2 (bajo)
- Ideal para: **subagente secundario**, tareas triviales donde no se desperdicia un modelo grande

### `nvidia/nemotron-nano-9b-v2:free` — **MINI**
- 9B | 📏 128K | 🧠 🔧 📐
- Ideal para: **el más barato/rápido**, tareas que cualquier modelo puede hacer

### `nvidia/nemotron-nano-12b-v2-vl:free` — **VISIÓN (mini)**
- 12B | 📏 128K | 🧠 🔧 👁️
- Hybrid Transformer-Mamba, video understanding
- Ideal para: **visión barata**, análisis de documentos/pantallazos ligero

### `nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free` — **MULTIMODAL**
- 30B (3B activos) | 📏 256K | 🧠 🔧 👁️
- Texto + imagen + video
- Ideal para: **subagente de percepción** en sistemas enterprise

### `meta-llama/llama-3.3-70b-instruct:free` — **GENERAL (legacy)**
- 70B | 📏 131K | 🔧
- Intelligence: 9.4 (bajo) — modelo viejo
- Ideal para: **fallback**, cuando los modelos más nuevos están saturados

### `openai/gpt-oss-20b:free` — **GENERAL (light)**
- 20B | 📏 131K | 🧠 🔧 📐
- Intelligence: 14.9 (bajo)
- Ideal para: **tareas triviales**, no recomendado como subagente principal

---

## ⚙️ Tier C — Casos especiales

### `openrouter/free` — **ROUTER ALEATORIO**
- 📏 200K | 🧠 🔧 👁️ 📐
- Selecciona un modelo gratuito al azar
- Ideal para: **testing**, o cuando no importa qué modelo responda

### `nousresearch/hermes-3-llama-3.1-405b:free` — **SIN TOOLS**
- 405B | 📏 131K | ❌ sin tools, ❌ sin reasoning
- Ideal para: **generación de texto puro**, brainstorming, NO para agentes

### `cognitivecomputations/dolphin-mistral-24b-venice-edition:free` — **UNCENSORED**
- 24B | 📏 32K | ❌ sin tools
- **Sin censura** — útil para contenido adulto o análisis sin restricciones
- Ideal para: **investigación sin filtros**, contenido que otros modelos rechazan

### `meta-llama/llama-3.2-3b-instruct:free` — **MICRO**
- 3B | 📏 131K | ❌ sin tools
- Ideal para: **clasificación**, tagging, tareas donde un modelo enorme es overkill

---

## 🎵 No-texto (no agentes)

| Modelo | Uso |
|--------|-----|
| `google/lyria-3-pro-preview` | Generación de canciones completas ($0.08/canción) |
| `google/lyria-3-clip-preview` | Clips de 30s ($0.04/clip) |
| `nvidia/nemotron-3.5-content-safety:free` | Guardrail/moderación de contenido |

---

## Recomendaciones por rol de subagente

| Rol | Modelo recomendado | Alternativa |
|-----|-------------------|-------------|
| **Code Agent** | `qwen/qwen3-coder:free` | `poolside/laguna-m.1:free` |
| **Architect/Planner** | `nvidia/nemotron-3-ultra-550b-a55b:free` | `tencent/hy3:free` |
| **Vision Agent** | `google/gemma-4-31b-it:free` | `nvidia/nemotron-nano-12b-v2-vl:free` |
| **Quick Fix Agent** | `poolside/laguna-xs-2.1:free` | `nvidia/nemotron-nano-9b-v2:free` |
| **Data Analyst** | `nvidia/nemotron-3-super-120b-a12b:free` | `nvidia/nemotron-3-ultra-550b-a55b:free` |
| **General Purpose** | `tencent/hy3:free` | `google/gemma-4-31b-it:free` |
| **Cheap/Fast** | `nvidia/nemotron-nano-9b-v2:free` | `meta-llama/llama-3.2-3b-instruct:free` |

---

## Notas de uso

- Los modelos gratuitos tienen **rate limits** (~10-20 req/min según modelo)
- `qwen/qwen3-coder:free` es **exceptional** — 480B params gratis con 61% win rate en código
- `nvidia/nemotron-3-ultra-550b-a55b:free` es el **más inteligente** de los gratuitos (intelligence_index: 37.8)
- Para vision barata: `google/gemma-4-26b-a4b-it:free` (3.8B activos = rápido)
- `openrouter/free` es útil para testing pero impredecible para producción
