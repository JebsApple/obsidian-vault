---
tags:
  - ingenieria-software
  - ux
  - diseno
  - garrett
aliases:
  - user-experience
  - 5-planes
created: 2026-07-10
up: "[[MOC/ingenieria-software]]"
---

# Diseño de Experiencia de Usuario (UX)

Cómo diseñar interfaces centradas en el usuario.

## Definición

> "La experiencia de usuario es todo lo que el usuario experimenta al interactuar con el producto." — Donald Norman

> "Para producir tecnología que se adapte a los seres humanos, es necesario estudiar a éstos. Pero en la actualidad tendemos a estudiar sólo a la primera. Es tiempo de que esta tendencia se revierta, es el momento de que la tecnología se adapte a las personas." — Donald Norman

UX ≠ UI: UX es la experiencia completa, UI es la capa visual.

Las **reglas doradas** son principios de diseño. Los **mecanismos de interacción** (botones, menús, formularios, iconos, ventanas) son los componentes de UI que implementan esas reglas. Ejemplo: la regla "el conductor debe saber la velocidad" se implementa con un velocímetro.

## Los 5 Planos de Garrett

```
┌─────────────────────────────────────────┐
│  5. Superficie (Surface)                │ ← qué ve el usuario
├─────────────────────────────────────────┤
│  4. Esqueleto (Skeleton)                │ ← layout, navegación
├─────────────────────────────────────────┤
│  3. Estructura (Structure)              │ ← organización del contenido
├─────────────────────────────────────────┤
│  2. Alcance (Scope)                     │ ← funcionalidades
├─────────────────────────────────────────┤
│  1. Estrategia (Strategy)               │ ← necesidades del usuario + objetivos negocio
└─────────────────────────────────────────┘
```

1. **Estrategia:** necesidades del usuario + objetivos del negocio. Preguntas clave: ¿Qué quiere lograr la empresa? ¿Qué necesitan los usuarios? Fuentes: entrevistas, encuestas, objetivos del producto.
2. **Alcance:** funcionalidades y contenido. Preguntas clave: ¿Qué características se incluirán? ¿Qué contenido es necesario? Fuentes: requerimientos funcionales, historias de usuario, especificaciones de contenido.
3. **Estructura:** cómo se organiza la información y cómo interactúa el usuario. Preguntas clave: ¿Cómo se navega el sistema? ¿Qué ocurre cuando el usuario interactúa? Fuentes: mapas de sitio, diagramas de flujo, modelos de interacción.
4. **Esqueleto:** wireframes, diseño de navegación, layout. Herramientas: Figma, Balsamiq, Adobe XD. Entregables: prototipos baja fidelidad, esquemas de UI.
5. **Superficie:** apariencia visual — colores, tipografía, iconografía. Entregables: mockups visuales, prototipos navegables, guías de estilo.

## Características de Buen UX

| Característica | Significado |
|----------------|-------------|
| **Usable** | Fácil de aprender y usar |
| **Útil** | Resuelve un problema real |
| **Agradable** | Placentero de usar |
| **Inclusivo** | Accesible a todos los usuarios |

## Interacción

Mecanismos de interacción:
- Click/tap, scroll, swipe
- Formularios, dropdowns
- Drag and drop
- Atajos de teclado
- Gestos (mobile)

## Ver También
- [[heuristica-nielsen]] — 10 heurísticas de Nielsen
- [[diagrama-uso]] — modelado de actores y casos de uso
- [[atributos-calidad-software]] — usabilidad como atributo de calidad
