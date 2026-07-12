---
tags:
  - ingenieria-software
  - uml
  - diagramas
  - clases
aliases:
  - class-diagram
  - oop-modeling
created: 2026-07-10
up: "[[MOC/ingenieria-software]]"
---

# Diagrama de Clases UML

Modela la estructura estática del sistema: clases, atributos, métodos y relaciones.

## Notación de Clase

```
┌──────────────────────┐
│    NombreClase       │  ← nombre en negrita
├──────────────────────┤
│ - atributo: tipo     │  ← atributos
│ + metodo(arg): tipo  │  ← métodos
└──────────────────────┘
```

## Modificadores de Acceso

| Símbolo | Significado |
|---------|------------|
| `+` | Público |
| `-` | Privado |
| `#` | Protegido |
| `~` | Paquete (package) |

## Tipos de Relaciones

### 1. Asociación
Línea simple entre clases. Puede ser bidireccional.

```
[Persona] ————— [Libro]
```

### 2. Asociación Dirigida
Flecha muestra dirección del acceso.

```
[Persona] ————→ [Libro]
```

### 3. Herencia / Generalización
Línea con triángulo vacío apuntando al padre.

```
[Estudiante] ————▷ [Persona]
[Profesor]   ————▷ [Persona]
```

### 4. Agregación (◇ vacía)
Relación "tiene un" — el componente puede existir sin el todo.

```
[Equipo] ◇———— [Jugador]
```

### 5. Composición (◆ llena)
Relación "parte de" — el componente NO puede existir sin el todo.

```
[Casa] ◆———— [Habitacion]
```

### 6. Dependencia
Línea punteada con flecha. Una clase usa temporalmente a otra.

```
[Informe] - - - -→ [Impresora]
```

## Multiplicidad

| Notación | Significado |
|----------|------------|
| `1` | Exactamente uno |
| `0..1` | Cero o uno |
| `*` | Muchos |
| `0..*` | Cero o muchos |
| `1..*` | Uno o muchos |
| `m..n` | Entre m y n |

Ejemplo: `Persona` 1 ←——→ * `Libro` (una persona tiene muchos libros)

## Ejemplo: Sistema de Biblioteca

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│  Biblioteca  │◇◆──│    Sede      │────▷│   Libro     │
│              │     │              │     │             │
└─────────────┘     └──────────────┘     └─────────────┘
                                                │
                                           1..* │
                                                ▽
                                         ┌─────────────┐
                                         │   Ejemplar  │
                                         └─────────────┘
```

- Biblioteca **compone** Sedas (sin biblio no hay sede)
- Sede **agrega** Libros (catálogo compartido)
- Libro tiene 1+ Ejemplares (físicos)

## Ver También
- [[diagrama-uso]] — comportamiento externo
- [[diagrama-secuencia]] — interacciones en el tiempo
- [[diagrama-paquetes]] — organización de paquetes
- [[diagrama-actividades]] — flujos de trabajo
