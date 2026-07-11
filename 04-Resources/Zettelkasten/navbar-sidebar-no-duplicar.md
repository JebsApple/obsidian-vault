---
created: 2026-07-11
tags:
  - tipo/zettel
  - proyecto/minegocio
  - tech/vue
aliases:
  - navbar duplicado
  - sidebar redundante
---

# SideBar y NavBar no deben duplicar navegación

## Lo que aprendí
Si tienes SideBar y NavBar, definir claramente qué navega cada uno. En MiNegocio, los 3 links del NavBar (Inventario, Análisis, Productos) eran redundantes con el SideBar que ya tenía navegación más completa. La solución fue eliminar los links del NavBar — ahora solo muestra logo + menú de usuario.

## Contexto
Sesión 3 de MiNegocio (2026-06-18). Al tener ambos componentes de navegación, el usuario veía las mismas opciones en dos lugares.

## Aplicación
Al diseñar UI con múltiples barras de navegación: SideBar para navegación principal (funcional), NavBar para branding + acciones globales (usuario, notificaciones). Nunca duplicar los mismos links.

## Conexiones

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
