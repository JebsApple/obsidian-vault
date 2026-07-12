---
tags:
  - moc/proyectos
---

# Proyectos

## Activos
```dataview
TABLE deadline as "Fecha limite", file.folder as "Ubicacion", status
FROM "02-Projects"
WHERE status = "activo"
SORT deadline ASC
```

## En planeacion
```dataview
TABLE created as "Creado", file.folder as "Ubicacion", status
FROM "02-Projects"
WHERE status = "draft"
SORT created DESC
```

## En espera
```dataview
TABLE file.folder as "Ubicacion", status
FROM "02-Projects"
WHERE status = "pausado"
SORT file.name ASC
```

## Archivados
```dataview
LIST
FROM "05-Archive"
WHERE contains(tags, "proyecto")
SORT file.name DESC
```
