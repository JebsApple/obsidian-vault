---
tags:
  - ingenieria-software
  - calidad
  - metricas
aliases:
  - Garvin
  - COCOMO
  - costo-calidad
created: 2026-07-10
up: "[[MOC/ingenieria-software]]"
---

# Calidad de Software

Marco conceptual para entender y gestionar la calidad desde diseño hasta mantenimiento.

## 5 Vistas de la Calidad (Garvin)

1. **Transcendental** — calidad como excelencia (difícil de medir)
2. **Basada en producto** — características medibles del software
3. **Basada en usuario** — satisfacción del usuario final
4. **Basada en proceso** — calidad del proceso de desarrollo
5. **Basada en valor** — relación costo/calidad

## Calidad de Diseño vs Calidad de Conformidad

| Aspecto | Diseño | Conformidad |
|---------|--------|-------------|
| Qué mide | Qué tan bien está especificado | Qué tan bien cumple la especificación |
| Ejemplo | Requiere ≥99% uptime | Logra 99.2% uptime |
| Evaluar | En diseño/planificación | Durante testing |

## Costo de la Calidad (COQ)

| Tipo | Pre-requiere | Detecta |
|------|-------------|---------|
| **Prevención** | Capacitación, estándares, reviews | Antes de que exista defectos |
| **Evaluación** | Testing, auditorías, inspecciones | Defectos existentes |
| **Fallo interno** | Rework, debugging, scrap | Defectos antes de release |
| **Fallo externo** | Soporte, warranty, reputación | Defectos en producción |

**Regla:** gastar más en prevención reduce exponencialmente los costos de fallo externo.

## Modelo COCOMO

Modelo de estimación de esfuerzo basado en tamaño (LOC/KLOC):
```
Esfuerzo = a × (KLOC)^b × Factores
Tiempo de desarrollo = c × (Esfuerzo)^d
```
- `a`, `b`, `c`, `d` varían según complejidad (orgánico, semi-acoplado, acoplado)
- Factores correctivos: capacidad del equipo, complejidad del producto, restricciones

## Tipos de Riesgo

| Categoría | Ejemplo |
|-----------|---------|
| **Personal** | Rotación de equipo, falta de skills |
| **Técnico** | Tecnología no probada, integración |
| **Planificación** | Estimaciones optimistas, dependencias |
| **Financiero** | Presupuesto insuficiente, cambios de costo |
| **Requerimientos** | Ambigüedad, scope creep |
| **Calidad** | Defectos críticos en producción |

## Incidente de Radioterapia Panama (1985-1986)

Caso de estudio clásico: software de control de radiación causó la muerte de 5 pacientes.
- **Causa raíz:** diseño deficiente, falta de validación, ausencia de testing formal
- **Lección:** la calidad del software en dominios críticos salva vidas

## Ver También
- [[codigo-limpio]] — prácticas de calidad en código
- [[SOLID]] — principios de diseño
- [[gestion-riesgos]] — gestión de riesgos en proyectos
- [[automatizacion-pruebas]] — testing como garantía de calidad
