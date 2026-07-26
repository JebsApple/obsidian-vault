---
tags: [proyecto/manga-de-weones, kanban, tracker]
created: "2026-07-24"
updated: "2026-07-26"
---

# Kanban: Manga de Weones

## 🔴 Bloqueado (decisión pendiente)

- [ ] **Habilitar R2 en el dashboard de Cloudflare** — bloquea `wrangler r2 bucket create` y por lo tanto el deploy. Manual, pide método de pago aunque el tier sea gratis. Guía dejada en el chat de la sesión 2026-07-26.
- [ ] **Elegir y registrar dominio** — bloquea el deploy público (se decidió no salir con `.pages.dev` mientras tanto).

## 📋 Por hacer — Deploy

- [ ] Crear bucket R2 una vez habilitado (`wrangler r2 bucket create manga-de-weones`)
- [ ] Crear proyecto Cloudflare Pages y conectarlo al repo para deploy automático desde `main`
- [ ] Configurar `ADMIN_PASSWORD` como secret de producción (`wrangler pages secret put`), no como var en `wrangler.toml`
- [ ] Apuntar dominio y verificar HTTPS

## 📋 Por hacer — Fase 3 (UX)

- [ ] Precarga de la página siguiente en el lector
- [ ] Progreso de lectura en `localStorage`
- [ ] Favoritos sin cuenta de usuario
- [ ] Búsqueda en el catálogo
- [ ] Modo oscuro

## ⏸️ En pausa — Fase 4 (Sostenibilidad / monetización)

Decisión del usuario (2026-07-26): dejar de lado por ahora, foco en publicar gratis.

- [ ] Página `apoyar.astro` con costos reales y meta mensual visible
- [ ] MercadoPago o Khipu como método de donación (no Ko-fi ni Patreon: sus términos lo prohíben)
- [ ] Banner discreto — nunca intersticial ni encima del lector
- [ ] Explorar patrocinio directo de tiendas de manga/anime chilenas

## ✅ Hecho

- [x] Investigar stack gratuito con escalado por unidad (2026-07-24)
- [x] Verificar free tiers reales de Cloudflare Pages/R2/D1/Workers (2026-07-24)
- [x] Comparar R2 vs Backblaze B2 + Bunny para audiencia chilena (2026-07-24)
- [x] Crear repo privado [JebsApple/manga-de-weones](https://github.com/JebsApple/manga-de-weones) (2026-07-24)
- [x] Blueprint con fases, stack y análisis de monetización (2026-07-24)
- [x] Scaffold Astro + Tailwind + Cloudflare adapter (2026-07-24/25)
- [x] Esquema D1 (`series`, `chapters`, `pages`) y creación de la base real en Cloudflare (2026-07-26)
- [x] Layout base, ficha de serie, lector webtoon y paginado, navegación anterior/siguiente (2026-07-24/25)
- [x] Fijada estructura de rutas en R2: `/{serie}/{cap}/{orden}.webp`
- [x] Panel admin: login, crear serie, crear/reemplazar capítulo (2026-07-26)
- [x] Subida de páginas: conversión a WebP q80 y corte automático >16.383px en el navegador, natural sort (2026-07-26)
- [x] Fix: migración de `Astro.locals.runtime.env` (removido en Astro v6) a `import { env } from 'cloudflare:workers'` (2026-07-26)
- [x] Probado end-to-end en local: login → crear serie → subir capítulo → se lee en el lector (2026-07-26)

## Simplificaciones conocidas (MVP, revisar después)

- Subida en una sola request — sin chunking todavía para archivos >50 MB (poco probable con WebP q80, pero no está implementado).
- Reemplazo de capítulo es directo, sin pantalla de confirmación mostrando conteo de páginas.
- Auth del panel es una contraseña compartida en cookie, no Cloudflare Access — migrar cuando haya dominio propio.
