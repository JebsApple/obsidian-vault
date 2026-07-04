---
tags:
  - project/devops-lab-orchestrator
  - type/experiment
  - status/todo
---

# Experimento Comparativo

**Objetivo:** Demostrar que agente + self-healing > script rigido
**Deadline:** 15 de agosto de 2026
**Impacto:** DECISIVO para aceptacion del paper

## Diseno

| Grupo | Tratamiento | Reparacion |
|-------|-------------|-----------|
| A | Script bash vanilla | Sin reparacion |
| B | Agente con loop de healing | Allowlist 6 acciones |

## Metricas

- **Success Rate:** % de labs levantados (meta: >85%)
- **Time-to-Ready:** Min desde spec a deployment (meta: <10 min)
- **SUS Score:** System Usability Scale (meta: >70)

## Fault Injection (5-8 escenarios)

- [ ] Port conflict
- [ ] Missing env var
- [ ] Invalid image tag
- [ ] Resource limit exceeded
- [ ] Health check misconfiguration
- [ ] Network conflict
- [ ] Volume mount error
- [ ] Permission denied

## Herramientas

- `eval/fault_injector.py` -- inyeccion de fallos
- `eval/metrics_collector.py` -- recoleccion de metricas
