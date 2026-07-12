---
tags:
  - ingenieria-software
  - uml
  - diagramas
  - actividades
aliases:
  - activity-diagram
  - flujos
created: 2026-07-10
up: "[[MOC/ingenieria-software]]"
---

# Diagrama de Actividades UML

Modela flujos de trabajo y procesos como una secuencia de actividades.

## Elementos

| Elemento | Notación | Significado |
|----------|----------|------------|
| Nodo inicial | Círculo negro ● | Inicio del flujo |
| Nodo final | Círculo negro con borde ◉ | Fin del flujo |
| Actividad | Rectángulo redondeado | Acción o tarea |
| Decisión/Ramificación | Rombo ◇ | Punto de bifurcación (condición) |
| Unión | Barra ─┼─ | Sincronizar flujos paralelos |
| Merge | Rombo ◇ | Unir caminos alternativos |

## Ejemplos Comunes

### 1. Registro de Usuario
```
● → [Llenar formulario] → ◇→ [¿Datos válidos?]
                              ├─ Sí → [Crear cuenta] → [Enviar email] → ◉
                              └─ No → [Mostrar error] → (volver a llenar)
```

### 2. Compra Online
```
● → [Seleccionar productos] → [Agregar al carrito] → [Ir a checkout]
→ ◇→ [¿Pago online?]
    ├─ Sí → [Procesar pago] → ◇→ [¿Aprobado?]
    │                            ├─ Sí → [Confirmar pedido] → [Entregar] → ◉
    │                            └─ No → [Notificar fallo] → ◉
    └─ No → [Pago contra entrega] → [Entregar] → ◉
```

### 3. Solicitud de Vacaciones
```
● → [Enviar solicitud] → [Revisar jefe] → ◇→ ¿Aprobado?
    ├─ Sí → [Actualizar calendario] → [Notificar RRHH] → ◉
    └─ No → [Notificar rechazo] → ◉
```

### Otros Ejemplos del Curso
- Inscripción a cursos
- Devolución de producto
- Publicación en blog
- Envío de email con adjunto
- Proceso de pago
- Examen en línea
- Cita médica

## Patrones Comunes

| Patrón | Uso |
|--------|-----|
| **Secuencia** | Actividades una tras otra |
| **Bifurcación** | Un flujo se divide según condición |
| **Paralelismo** | Barras de sincronización para tareas simultáneas |
| **Loop** | Flecha que vuelve atrás (retry, validación) |

## Ver También
- [[diagrama-secuencia]] — interacciones entre objetos (más detallado)
- [[diagrama-uso]] — qué hace el sistema (vista externa)
- [[diagrama-clases]] — estructura estática
- [[devops]] — el pipeline CI/CD es esencialmente un diagrama de actividades
