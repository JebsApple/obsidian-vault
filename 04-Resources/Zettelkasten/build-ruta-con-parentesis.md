---
created: 2026-07-11
tags:
  - tipo/zettel
  - proyecto/minegocio
  - tech/frontend
aliases:
  - build path
  - copy-webpack-plugin
  - paréntesis en ruta
---

# Build de Vue CLI falla con paréntesis/espacios en la ruta

## Lo que aprendí
`copy-webpack-plugin` (de vue-cli) usa un glob para EXCLUIR `index.html` al copiar `public/`. Si la carpeta tiene paréntesis `()` o espacios, el glob se rompe y copia `public/index.html` a `dist/` choca con `html-webpack-plugin`. Solución: compilar siempre desde una ruta SIN caracteres especiales.

## Contexto
2026-06-27 en MiNegocio. La carpeta `minegocio-frontend (1)` (sufijo del gestor de archivos al duplicar) causaba el error.

## Aplicación
Compilar Vue CLI siempre desde rutas sin paréntesis, espacios ni caracteres especiales. Si un build falla "de la nada", verificar la ruta primero.

## Conexiones
- [[iconos-tabler-invisibles]]
- [[css-huerfanos-import-roto]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
