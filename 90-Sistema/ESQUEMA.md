---
tipo: sistema
version: 1.0
creado: 2026-07-30
---

# Esquema de Frontmatter

> Schema unificado para todas las notas del vault.
> Los valores son lower-case, sin espacios, usando guiones.

## Tipos de nota (`tipo`)

| Valor | Significado | Directorio |
|---|---|---|
| `proyecto` | Proyecto activo | `02-Projects/` |
| `area` | Área de responsabilidad | `03-Areas/` |
| `zettel` | Nota atómica Zettelkasten | `04-Resources/Zettelkasten/` |
| `recurso` | Guía/referencia externa | `04-Resources/Referencia/` |
| `ia` | Referencia de IA | `04-Resources/IA/` |
| `sesion` | Registro de sesión de trabajo | `02-Projects/<proyecto>/` |
| `diario` | Nota diaria | `01-Daily/` |
| `capture` | Captura rápida sin clasificar | `00-Inbox/` |
| `decision` | Decisión arquitectónica | `02-Projects/<proyecto>/` |
| `reporte` | Reporte/auditoría | `02-Projects/<proyecto>/` o `05-Archive/` |
| `sprint` | Plan de sprint | `02-Projects/<proyecto>/` |
| `procedimiento` | Procedimiento documentado | `05-Archive/<proyecto>/Procedimientos/` |
| `moc` | Mapa de contenido | `MOCs/` |
| `plantilla` | Template | `Plantillas/` |
| `sistema` | Infraestructura del vault | `90-Sistema/` |

## Estados (`estado`)

| Valor | Significado |
|---|---|
| `activo` | En curso |
| `pausado` | Detenido temporalmente |
| `completado` | Terminado |
| `archivado` | Ya no es relevante |
| `planificado` | Planificado, no iniciado |

## Campos comunes (toda nota)

```yaml
---
tipo: <valor-de-tabla>
creado: YYYY-MM-DD
tags: []
---
```

## Campos por tipo de nota

### proyecto
```yaml
---
tipo: proyecto
estado: activo | pausado | completado | archivado
creado: YYYY-MM-DD
tags: [project/active, <stack>]
proyecto: <nombre-corto>
deadline: YYYY-MM-DD
repo: <url-github>
team: [persona1, persona2]
---
```

### zettel (nota atómica)
```yaml
---
tipo: zettel
creado: YYYY-MM-DD
tags: []
aliases: []
fuentes: []
---
```

### sesion
```yaml
---
tipo: sesion
creado: YYYY-MM-DD
proyecto: <nombre-corto>
duracion: 2h | 3h | etc
tags: [sesion]
---
```

### decision
```yaml
---
tipo: decision
creado: YYYY-MM-DD
proyecto: <nombre-corto>
tags: [decision]
estado: vigente | reemplazada
reemplazada_por: <link a nueva decision>
---
```

### reporte
```yaml
---
tipo: reporte
creado: YYYY-MM-DD
proyecto: <nombre-corto>
tags: [reporte, auditoria]
alcance: <descripción breve>
---
```
