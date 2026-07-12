---
tags:
  - ingenieria-software
  - requerimientos
  - agile
aliases:
  - user-stories
  - INVEST
created: 2026-07-10
up: "[[MOC/ingenieria-software]]"
---

# Historias de Usuario (User Stories)

Formato ágil para expresar requerimientos desde la perspectiva del usuario.

## Formato Estándar

```
Como [rol/usuario],
quiero [funcionalidad],
para [beneficio/valor].
```

**Ejemplo:**
> Como estudiante, quiero buscar libros por título, para encontrar rápidamente lo que necesito.

## Criterios de Aceptación

Cada historia debe tener condiciones verificables de "listo":
- **Dado** [contexto], **Cuando** [acción], **Entonces** [resultado]
- Ejemplo: Dado que estoy en la página de búsqueda, cuando escribo "Cien Años", entonces aparecen libros con ese título

## Criterios INVEST

Las buenas historias deben ser:

| Criterio | Significado | Ejemplo de violación |
|----------|-------------|---------------------|
| **I**ndependiente | No depende de otras | "Usar el módulo de pagos que aún no existe" |
| **N**egotiable | Abierta a discusión | Especificación rígida tipo contrato |
| **V**aluable | Aporta valor al usuario | Feature interna sin beneficio visible |
| **E**stimable | Se puede estimar | "Hacer el sistema rápido" |
| **S**mall | Caben en un sprint | Migración de toda la base de datos |
| **T**estable | Se puede verificar | "Mejorar la experiencia" |

## Tamaño Apropiado

- **Epics** → historias grandes que necesitan descomposición
- **Historias** → trabajables en un sprint (1-2 semanas)
- **Sub-historias** → tareas individuales (horas a 1-2 días)

```
Épica: Gestionar catálogo de libros
├── Historia: Agregar libro nuevo
├── Historia: Editar información de libro
├── Historia: Eliminar libro
└── Historia: Buscar libros por criterios
```

## En el Contexto Scrum

1. Product Owner crea y prioriza historias en el **Product Backlog**
2. En **Sprint Planning**, el equipo selecciona historias para el sprint
3. Equipo descompone en tareas técnicas
4. En **Sprint Review**, se demuestra el incremento funcionando

## Ver También
- [[scrum]] — historias en el contexto Scrum
- [[requerimientos]] — clasificación RF/RNF que las historias representan
- [[moscow]] — priorización de historias
- [[comunicacion-requerimientos]] — cómo obtener historias de stakeholders
