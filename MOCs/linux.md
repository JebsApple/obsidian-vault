---
tags:
  - moc/linux
---

# Linux

## Configuracion
```dataview
TABLE file.name as "Nota", tags
FROM "03-Areas/Linux"
SORT file.name ASC
```

## Notas tecnicas
```dataview
TABLE file.name as "Nota", tags
FROM "04-Resources/Zettelkasten"
WHERE contains(tags, "linux") OR contains(tags, "hyprland")
SORT file.name ASC
```
