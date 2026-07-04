---
tags:
  - project/devops-lab-orchestrator
  - type/adr
  - status/active
---

# ADR-002: Allowlist de Acciones del Agente

**Contexto:** El agente IA debe reparar fallos de deployment pero no puede generar configuracion libremente (riesgo de alucinacion, configuraciones invalidas).

**Decision:** Allowlist explicito de 6 acciones permitidas:

1. `increase_resource_limits` -- Aumentar CPU/memoria
2. `add_missing_env_vars` -- Agregar variables de entorno faltantes
3. `fix_port_conflicts` -- Cambiar puertos en conflicto
4. `correct_image_tags` -- Corregir tags de imagenes Docker
5. `adjust_health_checks` -- Ajustar parametros de health check
6. `reset_networking` -- Resetear configuracion de red

**Consecuencia:** El agente diagnostica libremente pero solo ejecuta estas 6 acciones. Esto hace cientificamente defendible la contribucion.

**Estado:** Aceptado.
