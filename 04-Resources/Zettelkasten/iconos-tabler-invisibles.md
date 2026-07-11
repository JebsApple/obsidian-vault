---
created: 2026-07-11
tags:
  - tipo/zettel
  - proyecto/minegocio
  - tech/frontend
aliases:
  - Tabler icons
  - webfont
---

# Iconos de librería invisible: falta cargar la webfont

## Lo que aprendí
Si usas clases de iconos (como `<i class="ti ti-shopping-cart">`) pero la webfont nunca se carga (ni en `index.html`, ni en `package.json`, ni en imports), los iconos son invisibles. Solución: agregar la dependencia + import en `main.js`. Ejemplo: `@tabler/icons-webfont` + `import '@tabler/icons-webfont/dist/tabler-icons.min.css'`.

## Contexto
2026-06-27 en MiNegocio. SideBar.vue y KanbanBoard.vue usaban 9 clases Tabler Icons pero la webfont no estaba cargada.

## Aplicación
Al integrar cualquier librería de iconos vía CSS classes: verificar que el paquete esté en `dependencies` (no solo `devDependencies`) y que haya un import que cargue el CSS/webfont. Contar los iconos usados y verificar que existen en la versión instalada.

## Conexiones
- [[build-ruta-con-parentesis]]
- [[css-huerfanos-import-roto]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
