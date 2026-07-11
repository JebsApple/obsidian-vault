---
tags:
  - moc/ia
---

# Herramientas IA

## Configuracion
```dataview
TABLE file.name as "Nota", tags
FROM "03-Areas/Herramientas-IA"
SORT file.name ASC
```

## Zettelkasten
```dataview
TABLE file.name as "Nota", tags
FROM "04-Resources/Zettelkasten"
WHERE contains(tags, "ia") OR contains(tags, "claude") OR contains(tags, "opencode")
SORT file.name ASC
```
