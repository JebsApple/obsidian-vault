---
created: 2026-07-11
tags:
  - tipo/zettel
  - proyecto/minegocio
  - tech/vue
aliases:
  - localStorage reactivo
---

# localStorage no es reactivo en Vue

## Lo que aprendí
`localStorage` no es una dependencia reactiva de Vue — un `computed` que lee `localStorage.getItem("token")` no se re-evalúa cuando el valor cambia. La solución es usar `reactive({})` de Vue 3 como store compartido y sincronizar bidireccionalmente con `localStorage`. Los servicios pueden seguir usando `localStorage.getItem()` directo porque el store siempre persiste ahí.

## Contexto
Sesión 3 del proyecto MiNegocio (2026-06-18). Se implementaba el auth flow y el login no actualizaba la UI porque el `computed` no detectaba el cambio en localStorage.

## Aplicación
Cuando necesites estado reactivo que persista entre recargas de página en Vue 3, usa `reactive()` como capa intermedia. Nunca confíes en `localStorage` como fuente reactiva directamente.

## Conexiones
- [[vue-auth-store-con-reactive]]
- [[no-duplicar-datos-jwt-en-localstorage]]
- [[jwt-auth-guard-router]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
