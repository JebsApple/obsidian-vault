---
tags:
  - ingenieria-software
  - uml
  - diagramas
  - secuencia
aliases:
  - sequence-diagram
  - interacciones
created: 2026-07-10
up: "[[MOC/ingenieria-software]]"
---

# Diagrama de Secuencia UML

Modela interacciones entre objetos a lo largo del tiempo — qué mensajes se envían y en qué orden.

## Elementos

| Elemento | Notación | Significado |
|----------|----------|------------|
| Participante | Rectángulo | Objeto/clase que interviene |
| Línea de vida | Rectángulo punteado vertical | Existencia del objeto en el tiempo |
| Mensaje síncrono | Flecha sólida → | Llamada a método (espera respuesta) |
| Mensaje asíncrono | Flecha abierta → | Envío sin esperar |
| Retorno | Flecha punteada → | Respuesta al mensaje |
| Marco de fragmento | Rectángulo con operador | `alt`/`opt`/`loop` |

## Conceptos Clave

### Línea de Vida (Lifeline)
Cada objeto tiene una línea vertical que representa su existencia durante la interacción.

### Mensajes
```
[Cliente] ────→ [Servidor]: enviarRequest()
                 │
[Servidor] ────→ [BaseDatos]: consultar()
[BaseDatos] ────→ [Servidor]: resultado
                 │
[Servidor] ────→ [Cliente]: respuesta
```

### Operadores de Fragmento

| Operador | Significado |
|----------|------------|
| `alt` | Alternativa (if/else) |
| `opt` | Opcional (if sin else) |
| `loop` | Repetición (while/for) |
| `par` | Paralelo |
| `ref` | Referencia a otro diagrama |

```
alt [condición A]
    [Obj1] ──→ [Obj2]: metodoA()
else [condición B]
    [Obj1] ──→ [Obj3]: metodoB()
end
```

## Ejemplo: Login

```
[Usuario]     [Frontend]     [API]          [DB]
    │              │            │              │
    │──login()────→│            │              │
    │              │──verificar()──→│              │
    │              │            │──query()──────→│
    │              │            │←─resultado─────│
    │              │←─token─────│              │
    │←─exito──────│            │              │
```

## Ver También
- [[diagrama-clases]] — los objetos que interactúan
- [[diagrama-uso]] — qué casos de uso se secuencian
- [[diagrama-actividades]] — flujo de control más alto nivel
- [[diagrama-despliegue]] — dónde físicamente se ejecutan
