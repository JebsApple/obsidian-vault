---
created: 2026-07-11
tags:
  - tipo/zettel
  - proyecto/minegocio
  - tech/vue
aliases:
  - router guard
  - beforeEach
---

# Auth guard en router con meta.requiresAuth

## Lo que aprendí
Usar `router.beforeEach` con `meta: { requiresAuth: true }` en rutas protegidas. Si el usuario no está autenticado, redirigir a `/login?redirect=/ruta-original` para que después del login vuelva a donde estaba.

## Contexto
Sesión 3 de MiNegocio (2026-06-18). Se implementó el sistema de rutas con vue-router@4 y se necesitaba proteger rutas que requieren login.

## Aplicación
Siempre configurar el auth guard antes de crear las rutas protegidas. El query param `redirect` es un patrón estándar que mejora la UX.

## Conexiones
- [[vue-auth-store-con-reactive]]
- [[vue-localstorage-no-es-reactivo]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
