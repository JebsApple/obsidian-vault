---
tags:
  - project/devops-lab-orchestrator
  - type/workflow
  - status/active
---

# Ideas: Usar Claude en el Proyecto

## 1. Generar codigo del backend
Pedirle a Claude que implemente los endpoints de FastAPI, el orquestador, o el healing engine. Ej: "Implementa el loop de retry en healing_engine.py con max 5 intentos y logging".

## 2. Escribir tests
Claude puede generar tests pytest para cada modulo. Ej: "Crea test para agent_handler.py que verifique que solo usa acciones del allowlist".

## 3. Redaccion academica
Claude ayuda a redactar secciones del paper, revisar gramatica, formatear referencias IEEE, y traducir abstract al ingles.

## 4. Depuracion y troubleshooting
Pegale un error de Docker Compose y que Claude diagnostique la causa y proponga un fix dentro del allowlist.

## 5. Generar escenarios de fault injection
Claude puede crear variantes de escenarios de fallo para el experimento comparativo.

## 6. Documentacion tecnica
Generar ADRs, ARCHITECTURE.md, y documentacion de API desde el codigo existente.

## 7. Review de codigo
Claude revisa PRs en el repo para detectar bugs, violaciones al allowlist, o falta de tests.

## 8. Automatizar con el agente OpenHands
El healing engine del proyecto llama a Ollama (local). Claude Code (aqui) es para desarrollo; el agente del proyecto en runtime usa OpenHands + Ollama. Son capas separadas.

### Flujo recomendado por fase

- **M3 (API):** Claude genera endpoints, schemas, validacion
- **M4 (Agente):** Claude escribe el handler + healing loop; el agente runtime usa Ollama
- **M5 (Eval):** Claude genera fault injectors y metrics collectors
- **Paper:** Claude redacta secciones, revisa citas, formatea
