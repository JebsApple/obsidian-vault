---
tags:
  - ingenieria-software
  - fundamentos
  - ieee
aliases:
  - software-engineering
  - capas-se
created: 2026-07-10
up: "[[MOC/ingenieria-software]]"
---

# Ingeniería de Software — Fundamentos

Definición, dominios y capas de la disciplina.

## Definición

**IEEE:** "Aplicación de un enfoque sistemático, disciplinado y cuantificable al desarrollo, operación y mantenimiento de software."

**Sommerville:** "Establecimiento y uso de principios de ingeniería para obtener software de manera económica, confiable y eficientemente."

## Dominios del Software

| Dominio | Ejemplo |
|---------|---------|
| Sistemas | OS, controladores, firmware |
| Aplicación | Apps de escritorio, móviles |
| Científico | Simulaciones, modelos numéricos |
| Integrado | Sistemas embebidos (automotriz, médico) |
| Línea de producto | Familias de software reutilizable |
| Web/Móviles | SPAs, apps nativas |
| IA/ML | Sistemas adaptativos, NLP |

## Software Legacy

Software que sigue en uso pero:
- Tecnología obsoleta
- Documentación incompleta
- Difícil de mantener
- Equipo original no disponible

## 4 Capas de la Ingeniería de Software

```
┌──────────────────────────┐
│  1. Calidad               │ ← meta transversal
├──────────────────────────┤
│  2. Proceso               │ ← cómo se organiza el trabajo
├──────────────────────────┤
│  3. Métodos               │ ← técnicas específicas
├──────────────────────────┤
│  4. Herramientas          │ ← soporte automatizado
└──────────────────────────┘
```

1. **Calidad:** Garantizar que el software cumple estándares
2. **Proceso:** Framework de actividades (comunicación, planificación, modelado, construcción, implementación)
3. **Métodos:** Técnicas para cada fase (diseño, testing, etc.)
4. **Herramientas:** IDEs, CI/CD, linters, testing tools

## Marco de Proceso

```
Comunicación → Planificación → Modelado → Construcción → Implementación
      ↑                                                        ↓
      ←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←
                    (iterativo — cada ciclo refina)
```

## Actividades Paraguas

Actividades que ocurren **durante todo** el proyecto:
- Gestión de cambios
- Aseguramiento de calidad
- Gestión de riesgos
- Configuración técnica
- Mediciones

## 7 Principios de Hooker

1. Simplificar y clarificar
2. Modularizar
3. Buscar reutilización
4. Abstraer
5. Usar notaciones estandarizadas
6. Documentar
7. Usar verificación formal cuando sea posible

## Ver También
- [[calidad-software]] — capa de calidad en detalle
- [[modelos-desarrollo]] — marcos de proceso
- [[scrum]] — proceso ágil popular
- [[atributos-calidad-software]] — atributos de calidad
