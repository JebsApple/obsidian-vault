---
tags:
  - ingenieria-software
  - calidad
  - atributos
aliases:
  - quality-attributes
  - non-functional-requirements
created: 2026-07-10
up: "[[MOC/ingenieria-software]]"
---

# Atributos de Calidad del Software

Propiedades no funcionales que definen qué tan "bueno" es un sistema.

## Atributos Principales

### Mantenibilidad
- Facilidad para corregir defectos o agregar funcionalidad
- Depende de: claridad del código, modularidad, documentación
- Medir: tiempo promedio para implementar un cambio

### Confiabilidad (Fiabilidad)
- Capacidad de operar sin fallos bajo condiciones específicas
- Medir: MTBF (Mean Time Between Failures), tasa de defectos
- Incluye: tolerancia a fallos, recuperación automática

### Eficiencia (Rendimiento)
- Uso óptimo de recursos (CPU, memoria, red, disco)
- Medir: tiempo de respuesta, throughput, utilization
- Técnicas: profiling, caching, lazy loading

### Aceptabilidad (Usabilidad)
- Fácil de aprender, eficiente de usar, satisfactoria
- Medir: tiempo de tarea, tasa de error, satisfacción del usuario
- Incluye: accesibilidad, diseño de interacción

### Seguridad
- Protección contra accesos no autorizados
- CIA: Confidentiality, Integrity, Availability
- Medir: vulnerabilidades, tiempo de respuesta a incidentes

### Portabilidad
- Capacidad de funcionar en diferentes entornos
- Medir: esfuerzo para migrar a nueva plataforma

### Escalabilidad
- Capacidad de manejar crecimiento (usuarios, datos, carga)
- Medir: rendimiento bajo carga incremental

## Tabla Resumen

| Atributo | Qué mide | Métrica típica |
|----------|---------|----------------|
| Mantenibilidad | Facilidad de cambio | Tiempo por cambio |
| Confiabilidad | Ausencia de fallos | MTBF, tasa defectos |
| Eficiencia | Uso de recursos | Latencia, throughput |
| Aceptabilidad | Facilidad de uso | Tiempo de tarea |
| Seguridad | Protección | Vulnerabilidades |
| Portabilidad | Múltiples plataformas | Esfuerzo de migración |
| Escalabilidad | Crecimiento | Rendimiento bajo carga |

## Trade-offs

Los atributos frecuentemente **compiten**:
- Seguridad ↑ → Eficiencia ↓ (cifrado tiene costo)
- Escalabilidad ↑ → Mantenibilidad ↓ (distribuido es más complejo)
- Portabilidad ↑ → Eficiencia ↓ (abstracciones tienen overhead)

## Ver También
- [[ingenieria-software-fundamentos]] — las 4 capas incluyen calidad
- [[calidad-software]] — marcos de calidad (Garvin, COCOMO)
- [[requerimientos]] — los RNF son estos atributos expresados como requisitos
- [[SOLID]] — principios que mejoran mantenibilidad
