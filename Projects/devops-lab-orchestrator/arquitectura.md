---
tags:
  - project/devops-lab-orchestrator
  - type/architecture
  - status/active
---

# Arquitectura del Sistema

## Decisión Central (ADR-002)

**Deterministic Jinja2 Templates + Constrained LLM Repair**

- Jinja2 templates -> configuraciones deterministas
- Agente IA **nunca genera freely** compose files
- Allowlist de **6 acciones permitidas**:
  1. Increase resource limits
  2. Add missing environment variables
  3. Fix port conflicts
  4. Correct image tags
  5. Adjust health check parameters
  6. Reset networking configuration

## Stack

| Capa | Tecnologia |
|------|-----------|
| Especificacion | YAML/JSON + JSON Schema |
| Modelos | Pydantic |
| Templates | Jinja2 |
| Backend | FastAPI + Python |
| Orquestacion | Docker Compose |
| Agente IA | OpenHands |
| LLM Runtime | Ollama (local, sin API key) |
| Contenedores | Gitea, Jenkins, SonarQube, Nginx |
| Frontend | React (stubbed) |
| Testing | pytest |
| CI/CD | GitHub Actions + gitleaks |

## Estructura del Monorepo (36 archivos)

```
devops-lab-orchestrator/
  CLAUDE.md
  docs/          (ARCHITECTURE.md, ADR-001 al 005)
  schema/        (lab-spec.json, pydantic_models.py)
  templates/     (gitea/jenkins/sonarqube compose + nginx.conf)
  backend/       (main.py, orchestrator.py, agent_handler.py, healing_engine.py)
  frontend/      (App.jsx + components/)
  tests/         (test_schema.py, test_templates.py, test_orchestrator.py)
  eval/          (fault_injector.py, metrics_collector.py)
  paper/         (articulo_es.md, references.bib)
  ci/            (.github/workflows/ci.yml)
```

## Principios No-Negociables

1. **Determinismo:** Jinja2 templates, no LLM generation
2. **Observabilidad:** Logs completos + decisiones
3. **Constrainedness:** Allowlist explicito
4. **Reproducibilidad:** Docker Compose + seeds
5. **Educativo:** Ensena DevOps + IA integracion
