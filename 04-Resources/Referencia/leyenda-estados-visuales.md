---
created: 2026-07-11
tags:
  - tipo/referencia
  - moc/sistema
---

# Leyenda de estados visuales

## Indicadores de color (Conditional Marker)

| Color | Significado | Tag / Frontmatter |
|-------|-------------|-------------------|
| 🟢 Verde | Proyecto activo | `status: activo` |
| 🟠 Naranja | Pausado / necesita revisión | `status: pausado` o `#status/revision` |
| 🔴 Rojo | Obsoleto / candidato a eliminación | `#status/obsoleto` o `#status/eliminar` |
| 🟡 Amarillo | Borrador | `status: borrador` |
| 🔵 Azul | Tareas pendientes (tiene `- [ ]`) | automático |
| 🟢 Verde claro | Todas las tareas completadas | automático |
| ⬜ Gris | Archivado | `status: archivado` |

## Iconos (Iconic)

### Carpetas (icono Lucide + color)

| Carpeta | Icono | Color |
|---------|-------|-------|
| `00-Inbox` | inbox | azul |
| `01-Daily` | calendar-days | morado |
| `02-Projects` | rocket | verde |
| `03-Areas` | layers | naranja |
| `04-Resources` | book-open | índigo |
| `05-Archive` | archive | gris |
| `MOCs` | map | rosa |
| `Plantillas` | file-text | marrón |
| `Assets` | paperclip | teal |
| `Zettelkasten` | atom | azul |

### Notas (por tag)

| Tag | Icono | Color |
|-----|-------|-------|
| `#tipo/zettel` | atom | azul |
| `#tipo/diario` | calendar-days | morado |
| `#tipo/tarea` | check-square | naranja |
| `#tipo/capture` | zap | amarillo |
| `#tipo/sesion` | terminal | gris azulado |
| `#tipo/procedimiento` | list-checks | cyan |
| `#moc/*` | map | rosa |

### Proyectos (por frontmatter status)

| Status | Icono | Color |
|--------|-------|-------|
| `activo` | rocket | verde |
| `pausado` | pause | naranja |
| `archivado` | archive | gris |

## Cómo usar

### Agregar estado a un proyecto
```yaml
---
status: activo    # activo | pausado | archivado | borrador
---
```

### Marcar nota como obsoleta
Agregar tag `#status/obsolet` o `#status/eliminar` en frontmatter:
```yaml
---
tags:
  - status/obsoleto
---
```

### Revisión pendiente
```yaml
---
tags:
  - status/revision
---
```
