---
tags: [proyecto/manga-de-weones, project-card]
created: "2026-07-24"
status: fase-0
---

# Manga de Weones

Lector de manga con traducciones al **chileno** (no español neutro — ese es el diferenciador).

## Estado

**Fase 0 — Scaffold.** Repo creado, sin deploy todavía.

- **Repo**: [JebsApple/manga-de-weones](https://github.com/JebsApple/manga-de-weones) (privado)
- **Local**: `~/proyectos/manga-de-weones`
- **Deploy**: pendiente (Cloudflare Pages)

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

## Lo que hay que decidir antes de escribir código

1. **Contenido**: ¿obra original/propia, licenciada, dominio público, o scanlation? Define si la monetización es viable (ver blueprint, sección Monetización).
2. **Dominio**: nombre y registrar. Afecta las URLs de R2 que quedan grabadas en la DB.
3. **Estructura de rutas del bucket** — única decisión irreversible del proyecto.
