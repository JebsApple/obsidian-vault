# Kanban Board — Hermes Agent

> Copiar este tablero a tu sistema de gestión (Obsidian, Notion, Trello, etc.)

---

## 📋 Pendiente

### Fase 1 — Core Agent
- [ ] Definir arquitectura del agente (autónomo vs on-demand) `P0` `fase-1`
- [ ] Integración con LLM (GPT-4, Claude, local) `P0` `fase-1`
- [ ] Sistema de memoria (corto y largo plazo) `P0` `fase-1`
- [ ] Tool use: ejecutar comandos, leer archivos, navegar web `P0` `fase-1`
- [ ] Loop de razonamiento: observar → pensar → actuar `P0` `fase-1`

### Fase 2 — Capacidades
- [ ] Búsqueda web integrada `P0` `fase-2`
- [ ] Análisis de código fuente `P0` `fase-2`
- [ ] Generación de contenido (texto, código) `P0` `fase-2`
- [ ] Gestión de tareas (CRUD) `P1` `fase-2`
- [ ] Integración con calendario/email `P1` `fase-2`

### Fase 3 — UI/UX
- [ ] Interfaz de chat (web o desktop) `P0` `fase-3`
- [ ] Historial de conversaciones `P0` `fase-3`
- [ ] Configuración de personalidad/modelo `P1` `fase-3`
- [ ] Modo voz (STT/TTS) `P2` `fase-3`

### P1 — Post-MVP
- [ ] Multi-agente (Hermes coordina otros agentes) `P1` `post-mvp`
- [ ] Plugins/extensiones `P1` `post-mvp`
- [ ] API pública `P1` `post-mvp`

### P2 — Futuro
- [ ] App móvil `P2` `backlog`
- [ ] Integración con dispositivos IoT `P2` `backlog`
- [ ] Aprendizaje continuo (fine-tuning local) `P2` `backlog`

---

## 🔧 En Progreso

*Vacío al inicio*

---

## 👀 En Revisión

*Vacío al inicio*

---

## ✅ Hecho

*Vacío al inicio*

---

## Labels

| Label | Color | Uso |
|-------|-------|-----|
| `P0` | 🔴 Rojo | MVP — obligatorio |
| `P1` | 🟡 Amarillo | Post-MVP — importante |
| `P2` | 🟢 Verde | Futuro — nice-to-have |
| `feature` | 🔵 Azul | Nueva funcionalidad |
| `bug` | 🟠 Naranja | Corrección |
| `tech-debt` | ⚫ Gris | Deuda técnica |
| `docs` | 🟣 Púrpura | Documentación |
| `fase-1` | — | Fase 1 — Core Agent |
| `fase-2` | — | Fase 2 — Capacidades |
| `fase-3` | — | Fase 3 — UI/UX |
| `post-mvp` | — | Post-MVP |
| `backlog` | — | Backlog general |

---

## Dependencias

| Card | Depende de | Notas |
|------|-----------|-------|
| Arquitectura agente | — | Decisión de diseño inicial |
| Integración LLM | Arquitectura | Requiere arquitectura definida |
| Sistema memoria | Integración LLM | Agente necesita recordar |
| Tool use | Integración LLM | LLM necesita herramientas |
| Loop razonamiento | Tool use + Memoria | Ciclo completo del agente |
| Búsqueda web | Tool use | Una de las herramientas |
| Análisis código | Tool use | Otra herramienta |
| Generación contenido | Integración LLM | Capacidad básica del LLM |
| Gestión tareas | Tool use | Herramienta específica |
| Integración calendario | Tool use | Herramienta externa |
| Interfaz chat | Loop razonamiento | UI para interactuar |
| Historial chat | Interfaz chat | Persistencia de conversaciones |
| Configuración | Interfaz chat | Personalización |
| Modo voz | Interfaz chat | Feature avanzada |

---

## Métricas de Progreso

| Sprint | Total | Hecho | En Progreso | Pendiente |
|--------|-------|-------|-------------|-----------|
| Fase 1 | 5 | 0 | 0 | 5 |
| Fase 2 | 5 | 0 | 0 | 5 |
| Fase 3 | 4 | 0 | 0 | 4 |
| P1 | 3 | 0 | 0 | 3 |
| P2 | 3 | 0 | 0 | 3 |
| **Total** | **20** | **0** | **0** | **20** |

---

*Generado con project-planner skill — 2026-07-12*
