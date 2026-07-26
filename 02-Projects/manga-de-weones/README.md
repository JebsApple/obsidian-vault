---
tags: [proyecto/manga-de-weones, project-card]
created: "2026-07-24"
updated: "2026-07-26"
status: fase-2
---

# Manga de Weones

Lector de manga con traducciones al **chileno** (no español neutro — ese es el diferenciador).

## Estado

**Fase 2 — Subida.** Lector completo y panel de administración funcionando en local contra D1/R2 reales. Monetización (Fase 4) en pausa por decisión del usuario — foco en dejar la página arriba gratis.

- **Repo**: [JebsApple/manga-de-weones](https://github.com/JebsApple/manga-de-weones) (privado)
- **Local**: `~/proyectos/manga-de-weones`
- **D1**: creada y con schema aplicado (`manga-de-weones`, cuenta `mnznpremium756@gmail.com`)
- **R2**: bloqueado — falta habilitarlo manualmente en el dashboard de Cloudflare (pide método de pago aunque el tier sea gratis)
- **Deploy público**: pendiente — a la espera de que se defina un dominio propio (se decidió no salir con el subdominio `.pages.dev` gratis)

## Decisión de stack en una línea

Todo Cloudflare: **Pages** (bandwidth ilimitado gratis) + **R2** (10 GB gratis, egreso $0 para siempre) + **D1** (5 GB) + **Workers** (100k req/día). Empieza en $0 real y escala pagando por unidad, sin saltos de plan.

## Documentos

- [[manga-de-weones-blueprint]] — fases, stack, decisiones y costos
- [[manga-de-weones-kanban]] — tablero de tareas
- [[sprint-0]] — sprint activo

## Relación con otros proyectos

- **[[scan-tracker-web]]** — mismo dominio (scanlation). Scan Tracker organiza el *trabajo*; esto publica el *resultado*. A futuro podrían compartir contrato de datos.
- **[[TL2EDIT]]** / **[[traductor-comics-psd]]** — producen los PSD traducidos que alimentan este sitio. Pipeline natural: TL2EDIT → export → subida a Manga de Weones.
- **Investigación raventard.xyz** (julio 2026) — de ahí salen las decisiones de pipeline de imágenes: WebP q80, corte a 16.383 px, subida en chunks, anti-hotlink.

## Lo que falta para salir en línea

1. **Habilitar R2** en el dashboard de Cloudflare (manual, pide tarjeta).
2. **Elegir y registrar dominio** — bloquea el deploy público a Cloudflare Pages.
3. **Contenido real**: qué serie(s) publicar primero.

## Decisión de rutas del bucket (ya tomada, no se toca)

`/{serie-slug}/{capitulo}/{orden}.webp` — ver `claveDePagina()` en `src/lib/media.ts`.
