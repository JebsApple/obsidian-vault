---
created: 2026-07-11
tags:
  - tipo/zettel
  - tech/waybar
aliases:
  - Pango font_size
  - icono invisible
---

# Pango font_size sin unidad = 0.01pt (invisible)

## Lo que aprendí
`font_size='10'` sin sufijo en Pango markup equivale a 10/1024 de punto ≈ 0.01pt (invisible). Siempre usar `font_size='10pt'` (con sufijo `pt`) para 10 puntos reales. Sin el sufijo, el icono no se renderiza.

## Contexto
2026-06-22 en hypr-player. Los iconos del player no aparecían en el widget de Waybar.

## Aplicación
Al usar Pango markup (`<span font_size='...'>`) en scripts de Waybar: siempre incluir la unidad `pt` en el tamaño. Verificar con `pango-view` si hay dudas.

## Conexiones
- [[waybar-mprios-idle-iconos]]
- [[waybar-css-hover-per-module]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
