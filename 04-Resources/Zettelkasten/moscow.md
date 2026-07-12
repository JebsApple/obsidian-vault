---
tags:
  - ingenieria-software
  - requerimientos
  - moscow
aliases:
  - MoSCoW
  - priorizacion
created: 2026-07-10
up: "[[MOC/ingenieria-software]]"
---

# Método MoSCoW

Técnica de priorización de requerimientos ampliamente usada en agile.

## Las 4 Prioridades

### Must Have (debe tener)
- Requisito obligatorio para que el sistema funcione
- Sin esto → el proyecto **falla**
- Ejemplo: autenticación de usuarios, procesamiento de pagos

### Should Have (debería tener)
- Importante pero no crítico para el primer release
- Solución alternativa puede existir
- Ejemplo: notificaciones por email, dashboard de analytics

### Could Help (podría tener)
- Mejora la experiencia pero prescindible
- Primero en cortar si hay presión de tiempo
- Ejemplo: modo oscuro, exportar a PDF, atajos de teclado

### Won't Have (no esta vez)
- Explícitamente excluido del alcance actual
- Puede planificarse para futuras iteraciones
- Ejemplo: integración con IA, app móvil, multi-idioma

## Reglas de Uso

- **Nunca** tener solo "Must Have" — si todo es urgente nada es urgente
- Debe haber al menos un item en cada categoría (excepto Won't Have)
- **% aproximados:** Must ~60%, Should ~20%, Could ~15%, Won't ~5%
- Revisar en cada Sprint Planning con el Product Owner

## Combinación con Otros Métodos

| Método | Cuándo usarlo |
|--------|---------------|
| **MoSCoW** | Priorizar features del producto |
| **MoSCoW + [[historias-usuario]]** | Historias en Product Backlog |
| **MoSCoW + [[scrum#Sprint Planning]]** | Seleccionar qué entra al sprint |
| **MoSCoW + Impact/Esfuerzo** | Matriz de decisión visual |

## Ejemplo Práctico

Sistema de biblioteca ([[requerimientos]]):
- **Must:** búsqueda de libros, préstamo, devolución
- **Should:** reservas online, multas automáticas
- **Could:** recomendaciones, lector QR
- **Won't:** app móvil, préstamo inter-bibliotecas

## Ver También
- [[requerimientos]] — clasificación RF/RNF
- [[historias-usuario]] — formato ágil de requerimientos
- [[scrum]] — MoSCoW en el contexto Scrum
