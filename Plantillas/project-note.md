---
tipo: proyecto
estado: activo
creado: {{date}}
tags: [project/active]
proyecto: ""
deadline: ""
repo: ""
team: []
---

# {{title}}

## Objetivo


## Stack / Tecnologias


## Sesiones

```dataview
LIST
FROM "02-Projects/{{title}}"
WHERE tipo = "sesion"
SORT creado DESC
```

## Decisiones

```dataview
TABLE creado, estado
FROM "02-Projects/{{title}}"
WHERE tipo = "decision"
SORT creado DESC
```

## Links

- [[MOCs/index|← Volver al inicio]]
