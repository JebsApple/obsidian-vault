---
tags:
  - ingenieria-software
  - codigo-limpio
  - principios
aliases:
  - DRY
  - KISS
  - YAGNI
created: 2026-07-10
up: "[[MOC/ingenieria-software]]"
---

# Principios de Código Limpio

Principios fundamentales para mantener código legible, mantenible y libre de malos olores.

## Principios Core

### DRY (Don't Repeat Yourself)
Cada pieza de conocimiento debe tener **una sola representación** en el sistema.
- Repetición → divergencia → bugs
- Aplicar extracción a funciones, módulos, clases

### KISS (Keep It Simple, Stupid)
La solución más simple que funciona es la correcta.
- Evitar sobre-ingeniería
- Si puedes explicarlo sin un diagrama, es simple enough

### YAGNI (You Aren't Gonna Need It)
No construir funcionalidad "por si acaso".
- Solo código que resuelve un requisito actual
- "Later" puede construirlo cuando sea necesario

### Rule of Three
Cuando un patrón aparece **3 veces**, refactorizar.
- Antes de 3 → duplicación aceptable
- En 3 → momento de abstraer

## Naming

- Nombres revelan intención
- Evitar codificaciones (nunca `x`, `data`, `temp`)
- Nombres largos > nombres ambiguos
- Clases: sustantivos. Métodos: verbos. Booleanos: prefijos `is/has/can`

## Funciones

- Deben hacer **una cosa**, hacerla bien, hacerla solo eso
- Máximo ~20 líneas
- Niveles de abstracción: no mezclar niveles en una función
- Guard Clauses: retornar temprano en vez de anidar `if/else`

```python
# Guard Clause (antes)
def process(user):
    if user is not None:
        if user.is_active:
            if user.has_permission:
                # lógica aquí
                pass

# Guard Clause (después)
def process(user):
    if user is None:
        return
    if not user.is_active:
        return
    if not user.has_permission:
        return
    # lógica limpia aquí
```

## Separación de Responsabilidades

Un módulo/clase debe tener **una razón para cambiar** (SRP de SOLID).

## Refactorización Continua

- Mejorar código existente sin cambiar comportamiento
- Eliminar malos olores: duplicación, funciones largas, nombres pobre
- Cada commit debe dejar el código un poco mejor

## Patrón Singleton

```python
class Singleton:
    _instance = None
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance
```

**Pros:** control estricto sobre una instancia, lazy initialization, namespace global.
**Contras:** testing dificulta (estado global), violación SRP, acoplamiento oculto.

## Ver También
- [[SOLID]] — los 5 principios OOP complementarios
- [[calidad-software]] — métricas de calidad
- [[extreme-programming]] — refactoring como práctica XP
