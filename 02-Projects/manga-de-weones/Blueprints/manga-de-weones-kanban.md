---
tags: [proyecto/manga-de-weones, kanban, tracker]
created: "2026-07-24"
---

# Kanban: Manga de Weones

## 🔴 Bloqueado (decisión pendiente)

- [ ] **Elegir y registrar dominio** — afecta las URLs de R2 que quedan grabadas en la DB.

## 📋 Por hacer — Fase 0 (Scaffold)

- [ ] Crear cuenta Cloudflare y activar R2 + D1 (tarjeta requerida para R2 aunque el tier sea gratis)
- [ ] `npm create astro@latest` con Tailwind en `~/proyectos/manga-de-weones`
- [ ] Layout base con nav y footer, tono chileno en los textos de UI
- [ ] Conectar repo a Cloudflare Pages (deploy automático desde `main`)
- [ ] `wrangler.toml` con bindings de R2 y D1
- [ ] Apuntar dominio y verificar HTTPS

## 📋 Por hacer — Fase 1 (Lector)

- [ ] Definir esquema D1: `series`, `chapters`, `pages` + `schema.sql`
- [ ] **Fijar estructura de rutas en R2** (`/{serie}/{cap}/{001.webp}`) — decisión irreversible
- [ ] Subir un capítulo a mano a R2 como caso de prueba
- [ ] Página de ficha de serie con lista de capítulos
- [ ] Lector con scroll vertical (estilo webtoon)
- [ ] Navegación anterior/siguiente entre capítulos
- [ ] Probar en móvil real, no solo en el responsive del navegador

## 📋 Por hacer — Fase 2 (Subida)

- [ ] Worker de subida en el mismo origen del panel (evita CORS por diseño)
- [ ] Conversión a WebP q80
- [ ] Corte automático de imágenes sobre 16.383 px
- [ ] Natural sort de nombres de archivo
- [ ] Panel drag & drop protegido con Cloudflare Access
- [ ] Confirmación al reemplazar un capítulo existente (mostrar conteo de páginas)
- [ ] Subida en chunks si aparecen archivos sobre 50 MB

## 📋 Por hacer — Fase 3 (UX)

- [ ] Precarga de la página siguiente en el lector
- [ ] Progreso de lectura en `localStorage`
- [ ] Favoritos sin cuenta de usuario
- [ ] Búsqueda en el catálogo
- [ ] Modo oscuro

## 📋 Por hacer — Fase 4 (Sostenibilidad)

Decidido: **sin ads, solo donaciones voluntarias con encuadre de costos.**

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
