---
name: "Software Engineering Concepts"
description: "Use when referencing UML diagrams, agile practices, clean code principles, or software quality fundamentals. Triggers: UML, diagramas de clases, clean code, XP, Scrum, automatización de pruebas, DevOps, manifiesto ágil. Skip if the topic is purely implementation-level code without design context."
user-invocable: false
---

# Software Engineering Concepts

## Domain
Zettelkasten of foundational software engineering theory — UML diagram types, agile methodologies, quality practices, and design principles. Primarily referenced by academic and planning contexts.

## Core Concepts
- **UML Diagram Family**: Actividades, Clases, Despliegue, Paquetes, Secuencia, Casos de Uso — form the complete system views. Actividades for workflows, Clases for structure, Secuencia for interactions, Despliegue for infrastructure, Paquetes for module boundaries, Casos de Uso for requirements.
- **Quality/Clean Code/Risk Triad**: Calidad de Software ↔ Código Limpio ↔ Gestión de Riesgos are interrelated practices. Clean code reduces defects; quality metrics catch risks early.
- **Agile Practices**: XP → Scrum → Manifiesto Ágil. XP emphasizes automation and pair programming; Scrum adds sprint cadence; the manifesto values individuals over processes.
- **Requirements Pipeline**: Requerimientos → Historias de Usuario → Plantilla ERS → Comunicación de Requerimientos. Each layer adds specificity.
- **SOLID**: Referenced by multiple nodes as the bridge between clean code and architectural quality.

## Key Relationships
- Automatización de Pruebas → conceptually_related_to → DevOps (CI/CD feeds testing, testing gates deployment)
- XP → references → Scrum (XP is a subset; Scrum provides framework, XP provides engineering practices)
- Diagrama de Clases → conceptually_related_to → Diagrama de Secuencia → conceptually_related_to → Diagrama de Actividades (design → interaction → flow)
- DevOps → references → SonarQube, Modelos de Desarrollo (tooling and methodology)
- MOC Ingeniería de Software is the hub node — every concept references it

## Mental Models
- **UML as Views, Not One Diagram**: Each diagram type shows a different facet of the same system. Use the right view for the right audience (stakeholders → Casos de Uso; developers → Clases/Secuencia; ops → Despliegue).
- **Quality is a Spectrum, Not a Gate**: Automation + clean code + risk management form a continuous feedback loop, not a pass/fail checkpoint.
- **Agile ≠ No Documentation**: ERS templates and user stories ARE documentation — lightweight, just-enough, actionable.

## When NOT to use
- Skip for implementation-level debugging (use project-specific nodes instead)
- Skip for UI/UX component design (community 12 covers that)
- Skip for Linux desktop configuration (community 14)
