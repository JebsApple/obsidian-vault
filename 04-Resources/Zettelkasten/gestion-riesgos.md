---
tags:
  - ingenieria-software
  - gestion
  - riesgos
aliases:
  - risk-management
created: 2026-07-10
up: "[[MOC/ingenieria-software]]"
---

# Gestión de Riesgos en Proyectos

Identificar, evaluar y mitigar riesgos antes de que se conviertan en problemas.

## Ciclo de Gestión de Riesgos

```
Identificar → Analizar → Planificar → Monitorear
      ↑                                      ↓
      ←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←
```

### 1. Identificación
- Brainstorming con el equipo
- Checklist de riesgos comunes (ver tabla en [[calidad-software]])
- Análisis de supuestos y dependencias

### 2. Análisis (Probabilidad × Impacto)

| | Impacto Bajo | Impacto Medio | Impacto Alto |
|---|---|---|---|
| **Prob. Alta** | Monitorear | Mitigar | Mitigar/Urgente |
| **Prob. Media** | Aceptar | Monitorear | Mitigar |
| **Prob. Baja** | Aceptar | Aceptar | Monitorear |

### 3. Estrategias de Respuesta

| Estrategia | Cuándo usar | Ejemplo |
|-----------|-------------|---------|
| **Evitar** | Eliminar la causa raíz | Cambiar tecnología riesgosa |
| **Mitigar** | Reducir probabilidad o impacto | Prototipos tempranos |
| **Transferir** | Externalizar el riesgo | Contratar especialista |
| **Aceptar** | Riesgo bajo o inevitable | Buffer de tiempo |

### 4. Monitoreo
- Revisión periódica en standups/sprints
- Registro de cambios en el register de riesgos
- Activar planes de contingencia cuando sea necesario

## Modelo Espiral y Riesgos

El [[modelos-desarrollo|Modelo Espiral]] integra gestión de riesgos en cada iteración:
1. Determinar objetivos → identificar riesgos
2. Evaluar alternativas → prototipos reducen incertidumbre
3. Desarrollar y verificar → mitigar riesgos restantes
4. Planificar siguiente iteración

## Lección del Incidente Panama

En el [[calidad-software#Incidente de Radioterapia Panama (1985-1986)|incidente de radioterapia Panama]], la ausencia de gestión de riesgos llevó a fatalities.
- **Riesgo no identificado:** software sin validación adecuada
- **Sin mitigación:** no había testing formal ni auditorías
- **Lección:** en dominios críticos, identificar riesgos es responsabilidad ética

## Ver También
- [[calidad-software]] — tipos de riesgo y COCOMO
- [[scrum]] — gestión de riesgos en sprints
- [[modelos-desarrollo]] — modelos que integran riesgos
