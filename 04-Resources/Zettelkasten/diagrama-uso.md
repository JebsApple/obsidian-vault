---
tags:
  - ingenieria-software
  - uml
  - diagramas
  - uso
aliases:
  - use-case
  - actores
created: 2026-07-10
up: "[[MOC/ingenieria-software]]"
---

# Diagrama de Casos de Uso UML

Modela el comportamiento externo del sistema: quién hace qué con el sistema.

## Elementos

### Actores
- **Actor primario:** inicia la interacción (humano o sistema externo)
- **Actor secundario:** participa en el caso de uso
- **Actor de sistema:** otro sistema que interactúa
- Notación: silueta de palito 🧍

### Casos de Uso
- Acción que el sistema ofrece al actor
- Notación: óvalo con nombre

### Relaciones

| Tipo | Notación | Significado |
|------|----------|------------|
| **Asociación** | Línea sólida | Actor participa en caso de uso |
| **Generalización** | Flecha con triángulo | Actor/caso hijo hereda del padre |
| **Extiende** | `<<extend>>` punteado | Caso Opcional que se activa bajo condición |
| **Usa** | `<<include>>` punteado | Caso Requerido que siempre se ejecuta |

## Formato de Especificación

```
Nombre: [nombre del caso de uso]
Actor(es): [quién participa]
Precondición: [estado antes]
Postcondición: [estado después]
Flujo principal:
  1. [paso 1]
  2. [paso 2]
  ...
Flujos alternativos:
  X.1 [variante]
  X.2 [excepción]
```

## Ejemplo: Biblioteca

**Actores:** Estudiante, Bibliotecario, Sistema Externo (banco)

**Casos de uso:**
- Buscar Libro
- Pedir Libro Prestado
- Devolver Libro
- Pagar Multa
- Registrar Usuario

```
                    ┌─────────────────────────────┐
                    │      Sistema Biblioteca      │
                    │                             │
Estudiante ────────│─ Buscar Libro               │
    │               │─ Pedir Libro Prestado       │
    │               │─ Devolver Libro             │
    │               │─ Pagar Multa ←————<<include>>──── Pago Online
    │               │                             │     │
Bibliotecario ─────│─ Registrar Usuario          │     │
    │               │─ Gestionar Catálogo         │  <<extend>>
    │               │─ Registrar Préstamo         │  (si online)
                    │                             │
                    └─────────────────────────────┘
```

## Include vs Extend

| | `<<include>>` | `<<extend>>` |
|---|---|---|
| **Cuándo** | Siempre se ejecuta | Solo bajo condición |
| **Dirección** | Caso base → incluido | Extensión → caso base |
| **Ejemplo** | Pagar Multa incluye "Autenticar" | Pagar Multa extiende "si online" |

## Ver También
- [[diagrama-clases]] — estructura estática del sistema
- [[diagrama-secuencia]] — interacciones paso a paso
- [[plantilla-ers]] — los casos de uso van en el ERS
- [[requerimientos]] — los RF se modelan como casos de uso
