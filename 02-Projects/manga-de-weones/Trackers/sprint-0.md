---
tags: [proyecto/manga-de-weones, sprint, tracker]
created: "2026-07-24"
sprint: 0
estado: activo
---

# Sprint 0 — Scaffold y deploy

**Objetivo:** sitio vacío en producción, con deploy automático funcionando. Nada de features todavía.

**Criterio de cierre:** hacer push a `main` publica solo, y el sitio carga en el dominio con HTTPS.

## Tareas

| # | Tarea | Estado | Nota |
|---|---|---|---|
| 1 | Repo privado en GitHub | ✅ | [JebsApple/manga-de-weones](https://github.com/JebsApple/manga-de-weones) |
| 2 | Blueprint y kanban en vault | ✅ | — |
| 3 | Cuenta Cloudflare + activar R2 y D1 | ⬜ | R2 pide tarjeta aunque el tier sea gratis |
| 4 | Scaffold Astro + Tailwind | ⬜ | `~/proyectos/manga-de-weones` |
| 5 | Layout base (nav, footer, tono chileno) | ⬜ | La UI también va en chileno, es el diferenciador |
| 6 | Conectar repo a Cloudflare Pages | ⬜ | Deploy automático desde `main` |
| 7 | Elegir y registrar dominio | ⬜ | Bloquea la tarea 8 |
| 8 | Apuntar dominio + verificar HTTPS | ⬜ | Depende de 6 y 7 |

## Decisiones tomadas en este sprint

- **Stack Cloudflare completo** en vez de Vercel/Netlify: son los únicos con bandwidth ilimitado en free tier, y un sitio de manga es puro bandwidth.
- **R2 en vez de B2 + Bunny**: el egreso en R2 es $0 para siempre; Bunny cobra $0,035–0,045/GB en Latinoamérica. Con audiencia chilena, la diferencia es pagar algo versus pagar nada.
- **Sin cuentas de usuario** en las primeras fases: `localStorage` cubre favoritos y progreso.

- **Sostenibilidad sin ads**: solo donaciones voluntarias con encuadre de costos. Las sanciones de AdSense son a nivel de cuenta y seguirían a [[TL2EDIT]], que es el proyecto con potencial real de ingresos. Además los intersticiales son la causa número uno de abandono en lectores de manga, así que sacarlos mejora el producto.

## Decisiones pendientes

- **Estructura de rutas en R2.** Hay que fijarla en la Fase 1 antes de subir el primer capítulo: es lo único irreversible del proyecto.
- **Dominio.** Bloquea el cierre del sprint (tarea 8).

## Lecciones

_(Se llenan al cerrar el sprint.)_
