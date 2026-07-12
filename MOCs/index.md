---
aliases: [home, inicio]
tags:
  - moc/root
---

# Mapa de Contenido

## Captura rapida
> [[00-Inbox]]

## Notas diarias
```dataview
TABLE file.cday as "Creado", length(file.inlinks) as "Links"
FROM "01-Daily"
SORT file.name DESC
LIMIT 10
```

## Proyectos activos
```dataview
TABLE status, deadline, file.folder as "Ubicacion"
FROM "02-Projects"
WHERE tags AND contains(tags, "project")
SORT status ASC, deadline ASC
```

> Dashboard completo: [[02-Projects/_index|Projects Dashboard]]

## Areas
- [[Linux]] — Configuracion, Hyprland, waybar, audio
- [[Herramientas-IA]] — OpenCode, Claude, MCP, ECC
- [[Personal]] — Apps, Packet Tracer, notas varias

## Recursos
```dataview
TABLE tags, file.folder as "Tipo"
FROM "04-Resources"
SORT file.name ASC
```

## Archivo
```dataview
LIST
FROM "05-Archive"
SORT file.name DESC
```
