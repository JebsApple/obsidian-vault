---
tipo: sistema
creado: 2026-07-30
tags:
  - vault/contexto
---

# Contexto de Sesión

> Este archivo es el punto de reanudación entre sesiones de trabajo.
> Lo actualiza el agente al finalizar cada sesión.
> La PRIMERA sección es para humanos, las secciones con "@" son para agentes.

---

## Último proyecto trabajado

<!-- El agente actualiza esto al terminar sesión -->

- **Proyecto:**
- **Fecha última sesión:**
- **Estado actual:**

---

## Resumen de última sesión

<!-- 2-3 líneas que cualquiera pueda leer para saber qué pasó -->



---

## Próximos pasos

<!-- Lista concreta de lo que sigue. Priorizar por importancia. -->

1.

---

## Bloqueos actuales

<!-- Qué impide avanzar. Si no hay, dejar vacío. -->



---

## Tareas abiertas del vault

<!-- Tareas de mantenimiento del vault mismo, no de proyectos -->

- [ ]

---

<!-- ============================================================ -->
<!-- SECCIONES PARA AGENTES (las @ son instrucciones directas) -->
<!-- ============================================================ -->

### @session_state

```
proyecto_actual:
ultima_fecha:
modo: working | planning | review
ultimo_commit:
```

### @open_questions

<!-- Preguntas que quedaron sin resolver y necesitan respuesta antes de seguir -->



### @decisions_pending

<!-- Decisiones técnicas pendientes de resolver -->



### @context_cache

<!-- Seeds de búsqueda para que el agente reconstruya contexto rápido -->

```
buscar:
- 
```
