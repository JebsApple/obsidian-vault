---
tags:
  - ingenieria-software
  - uml
  - diagramas
  - paquetes
aliases:
  - package-diagram
  - modularizacion
created: 2026-07-10
up: "[[MOC/ingenieria-software]]"
---

# Diagrama de Paquetes UML

Modela la organización del código en módulos/paquetes y sus dependencias.

## Elementos

| Elemento | Notación | Significado |
|----------|----------|------------|
| **Paquete** | Rectángulo con pestaña | Contenedor lógico de elementos |
| **Dependencia** | `<<use>>` punteada | Un paquete usa a otro |
| **Generalización** | Herencia entre paquetes | Paquete hijo hereda del padre |

## Notación

```
┌─ Paquete ─────────┐
│                    │
│  Clase1            │
│  Clase2            │
│                    │
└────────────────────┘
```

## Ejemplo: Arquitectura en 3 Capas

```
┌─────────────────────┐
│  <<package>>        │
│  Presentación       │
│  - Vistas           │
│  - Controladores    │
└─────────┬───────────┘
          │ <<use>>
          ▽
┌─────────────────────┐
│  <<package>>        │
│  Lógica de Negocio  │
│  - Servicios        │
│  - Validaciones     │
└─────────┬───────────┘
          │ <<use>>
          ▽
┌─────────────────────┐
│  <<package>>        │
│  Acceso a Datos     │
│  - Repositorios     │
│  - Modelos          │
└─────────────────────┘
```

## Paquetes Anidados

```
┌─ Sistema ──────────────────────────────┐
│                                        │
│  ┌─ Frontend ──────┐ ┌─ Backend ─────┐ │
│  │  React          │ │  FastAPI      │ │
│  │  Componentes    │ │  Routes       │ │
│  └─────────────────┘ └───────────────┘ │
│                                        │
│  ┌─ Shared ────────┐                   │
│  │  Types          │                   │
│  │  Constants      │                   │
│  └─────────────────┘                   │
└────────────────────────────────────────┘
```

## Reglas

- Las dependencias deben ir **hacia abajo** (nunca circular)
- Un paquete no debe conocer detalles internos de otro
- Acoplamiento mínimo entre paquetes

## Ver También
- [[diagrama-clases]] — contenido de cada paquete
- [[diagrama-despliegue]] — distribución física de paquetes
- [[SOLID]] — SRP y DIP guían la modularización
