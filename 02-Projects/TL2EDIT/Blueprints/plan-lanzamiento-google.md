---
aliases: [tl2edit-lanzamiento-google]
tags: [project, plan, seo, launch]
created: 2026-07-20
status: draft
related: [[tl2edit-blueprint]]
---

# TL2EDIT — Plan de Lanzamiento / Visibilidad en Google

## Contexto

Auditoría generada con el plugin [claude-seo-ai](https://github.com/Hainrixz/claude-seo-ai) (instalado 2026-07-20) vía subagente Opus. Sitio live: `https://tl2edit.onrender.com/` (Render, plan free). A diferencia de scantracker, TL2EDIT **no usa OAuth de Google para login** (es BYOK: cada usuario carga su propia API key de Gemini/OpenRouter/DeepL desde el navegador) — no hay bloqueo de verificación OAuth aquí. El único eje relevante es SEO/GEO técnico.

Scores auditoría: **Search SEO ~40/100 (F)** · **AI Visibility/GEO ~18/100 (F)**.

## Hallazgo raíz (domina ambos scores)

**CSR puro sin prerender/SSR.** El HTML servido (confirmado con `curl` live, 561 bytes) es solo `<div id="root"></div>` vacío — todo el contenido lo inyecta React en el cliente. Googlebot puede ejecutar JS (por eso Search no es 0), pero los crawlers de AI-search (OAI-SearchBot, Claude-SearchBot, PerplexityBot) no lo hacen → la página es **invisible** para citación en ChatGPT/Perplexity/etc. Resolver esto es el 70% del problema.

## Checklist priorizada

### Críticos
- [ ] **Prerender del landing**: usar `vite-plugin-prerender`, `react-snap`, o similar para que el HTML servido incluya el contenido real (no solo `<div id="root">`). Alternativa más simple: una landing estática separada (HTML plano) para `/` con CTA hacia la app real.
- [ ] **`robots.txt` real**: hoy el catch-all `server.ts:459-461` devuelve el shell SPA (200 HTML) para `/robots.txt` → soft-404. Agregar ruta explícita antes del catch-all.
- [ ] **`sitemap.xml` real**: mismo problema de soft-404. Agregar ruta explícita con la URL raíz.

### Altos
- [ ] **Meta description** en `index.html` (falta por completo).
- [ ] **Canonical** self-referencial HTTPS (`https://tl2edit.onrender.com/`).
- [ ] **Open Graph + Twitter Cards** (hoy no hay preview al compartir el link).
- [ ] **JSON-LD `SoftwareApplication`**: reutilizar la descripción ya escrita en `metadata.json:3`. Incluir `applicationCategory: "MultimediaApplication"`, `offers.price: 0`, `operatingSystem: "Web"`.

### Medios
- [ ] `<title>` más descriptivo: "TL2EDIT — Traduce cómics a PSD editable con OCR e IA" (hoy solo dice "TL2EDIT").
- [ ] Fijar `base: '/'` en `vite.config.ts` (hoy default `/TL2EDIT/`, se salva en Render por `BASE_URL=1` env var pero es frágil si cambia el deploy) o dejar de commitear `dist/`.
- [ ] `llms.txt` (bajo impacto, trivial dado que es un solo landing).

### Bajos
- [ ] `apple-touch-icon` + `og:image` (favicon hoy es solo emoji SVG inline).

### Verificar (no bloqueante, ya OK)
- [x] `lang`, viewport, HTTPS, favicon — correctos.

## Performance / CWV

Bundle pesado por `onnxruntime-web` + `tesseract.js` + WASM. Verificar que el OCR/ONNX no bloquee el critical path del landing (lazy-load, no cargar hasta que el usuario suba una imagen). No medido en lab (LCP/INP) — pendiente correr Lighthouse o PageSpeed Insights una vez esté el prerender.

## De "invisible" a "aprobado en Google"

1. Prerender + robots.txt + sitemap.xml + meta tags + JSON-LD (checklist arriba).
2. Dar de alta el dominio en **Google Search Console**, enviar sitemap, "Solicitar indexación".
3. **Políticas de contenido**: la app usa IA (Gemini/OpenRouter) para traducir contenido de terceros (cómics) — no hay problema de política de Google per se (no es contenido generado publicado por TL2EDIT, es una herramienta), pero conviene:
   - Bloquear en `robots.txt` las rutas `/api/*` (no indexables, son endpoints, no contenido).
   - Publicar una página breve de privacidad/ToS aclarando que las API keys del usuario no se almacenan server-side (ya está implícito en el README, falta como página pública — ayuda a E-E-A-T).

## Orden de ejecución recomendado

1. Prerender del landing (el cambio de mayor impacto, esfuerzo medio).
2. Meta tags (description, canonical, OG/Twitter, JSON-LD) — puede ir en el mismo PR que el prerender si el prerender ya te obliga a tocar el `<head>`.
3. `robots.txt` + `sitemap.xml` como rutas explícitas en `server.ts` antes del catch-all.
4. Alta en Search Console, envío de sitemap, solicitud de indexación.
5. Lighthouse/PageSpeed una vez el prerender esté en producción, para confirmar CWV.

## Referencias

- Auditoría completa (raw): ver output del subagente Opus, 2026-07-20 — resumida arriba.
- Metodología: skills del plugin `claude-seo-ai` en `~/.claude/plugins/cache/claude-seo-ai/claude-seo-ai/0.1.0/skills/`.
