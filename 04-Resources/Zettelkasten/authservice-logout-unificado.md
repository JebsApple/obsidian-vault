---
created: 2026-07-11
tags:
  - tipo/zettel
  - proyecto/minegocio
  - tech/vue
aliases:
  - authService logout
---

# AuthService.logout() unificado en vez de manipular localStorage

## Lo que aprendí
Si `authService.js` ya tiene `logout()`, importarlo en NavBar, SideBar y App.vue en vez de manipular `localStorage` inline en cada componente. Centralizar la lógica de cierre de sesión en un solo lugar.

## Contexto
2026-06-18 en MiNegocio, durante la limpieza de código muerto (HU01-T05).

## Aplicación
Siempre centralizar operaciones de auth (login, logout, refresh) en un servicio. Nunca manipular localStorage directamente desde componentes para estado auth.

## Conexiones
- [[vue-auth-store-con-reactive]]
- [[vue-localstorage-no-es-reactivo]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
