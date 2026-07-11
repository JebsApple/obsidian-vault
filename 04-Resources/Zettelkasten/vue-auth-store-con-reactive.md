---
created: 2026-07-11
tags:
  - tipo/zettel
  - proyecto/minegocio
  - tech/vue
aliases:
  - auth store
  - reactive store
---

# Auth store con reactive() en Vue 3

## Lo que aprendí
Para manejar autenticación reactiva en Vue 3, crear un `auth.js` exportando `reactive({})` con `setAuth(token, user)` y `clearAuth()`. Esto sincroniza el store con `localStorage` y cualquier componente puede inyectar el store para leer estado auth. Los servicios siguen usando `localStorage` directo para el token.

## Contexto
Sesión 3 de MiNegocio (2026-06-18). Se necesitaba un store global de auth que disparara re-render de componentes al hacer login/logout, sin Pinia ni Vuex.

## Aplicación
Para apps Vue 3 pequeñas/m medianas sin store framework: un `reactive({})` exportado desde un módulo sirve como store global. Para apps más grandes, considera Pinia.

## Conexiones
- [[vue-localstorage-no-es-reactivo]]
- [[no-duplicar-datos-jwt-en-localstorage]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
