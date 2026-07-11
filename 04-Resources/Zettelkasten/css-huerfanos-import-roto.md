---
created: 2026-07-11
tags:
  - tipo/zettel
  - proyecto/minegocio
  - tech/frontend
aliases:
  - CSS huérfano
  - import eliminado
---

# Al borrar CSS, verificar imports en componentes

## Lo que aprendí
Al eliminar un archivo CSS huérfano (como `carritocompras.css`), siempre verificar si algún componente lo importa. `CarritoCompras.vue` importaba el archivo eliminado y rompía el build. La solución es limpiar el import antes de borrar el archivo.

## Contexto
2026-06-18 en MiNegocio. Se limpiaron archivos CSS sin verificar dependencias de imports.

## Aplicación
Antes de borrar cualquier archivo: hacer `grep -r "nombre-del-archivo" src/` para ver si hay imports. Si los hay, eliminar los imports primero.

## Conexiones
- [[iconos-tabler-invisibles]]
- [[build-ruta-con-parentesis]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
