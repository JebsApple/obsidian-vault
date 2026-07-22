---
aliases: [scantracker-lanzamiento-google, plan-aprobacion-google-scantracker]
tags: [project, plan, seo, google-oauth, launch]
created: 2026-07-20
status: draft
related: [[scan-tracker-web-blueprint]], [[README]]
---

# Scan Tracker Web — Plan de Lanzamiento con Aprobación de Google

## Contexto

Auditoría generada con el plugin [claude-seo-ai](https://github.com/Hainrixz/claude-seo-ai) (instalado 2026-07-20, marketplace `Hainrixz/claude-seo-ai`) vía subagente Opus, más investigación directa del proceso de verificación OAuth de Google. Sitio live: `https://scantracker.rweb.site/` (custom domain sobre GitHub Pages, `github.io` hace 301).

**Dos bloqueos independientes para "lanzar con aprobación de Google":**

1. **Verificación OAuth** — el bloqueo real y urgente. Sin esto, cualquier usuario fuera de tu lista de "test users" ve un aviso de "app no verificada" y no puede loguearse con Google. Esto es lo que impide que el equipo de scanlation crezca más allá de quien agregues manualmente.
2. **SEO/indexación en Google Search** — que el sitio aparezca en resultados de búsqueda. Menos crítico para una tool de nicho con login, pero pedido explícitamente.

---

## Parte 1 — Verificación OAuth de Google (prioridad alta)

### Diagnóstico actual

- `src/repositories/auth.js`: usa Google Identity Services con `client_id` público (`DEFAULT_CLIENT_ID`).
- Scopes solicitados: `spreadsheets` (sensible), `userinfo.email` (no sensible), `drive.metadata.readonly` (sensible — solo lista metadata de "Compartidos conmigo", nunca contenido).
- **Ninguno de estos scopes es "restringido"** (restricted) — eso es clave: `drive.metadata.readonly` ≠ `drive.readonly`. No dispara auditoría CASA (auditoría de seguridad paga de terceros, semanas/meses de proceso).
- Ruta de verificación aplicable: **sensitive scope verification**, la más liviana de las dos.
- Estado actual: app en modo "Testing" con test users agregados manualmente (según README del proyecto) → confirma que nunca se completó la verificación.

### Pasos concretos (Google Cloud Console)

1. **Homepage pública verificable**: Google exige una home page en un dominio verificado que describa la función de la app y enlace ToS + política de privacidad. `scantracker.rweb.site/` ya cumple el dominio; falta que la home tenga texto descriptivo visible (ver hallazgo #6 de la Parte 2 — se resuelven juntos).
2. **Verificar el dominio** `rweb.site` en [Google Search Console](https://search.google.com/search-console) (Search Console) y vincularlo en la pantalla de consentimiento OAuth de Cloud Console (Configuración → Información de la app → Dominios autorizados).
3. **Política de privacidad visible**: `privacy.html` ya existe pero está escondida en un dropdown "Más". Sacarla a un footer siempre visible (mismo fix que pide SEO).
4. **Pantalla de consentimiento OAuth → completar todos los campos**: nombre de la app, logo, email de soporte, dominio autorizado, link a privacy policy y ToS (falta ToS — crear uno corto, puede ser una sección de `privacy.html` o página separada).
5. **Justificación de scopes**: en Cloud Console → OAuth consent screen → Scopes, Google pide una justificación por escrito de por qué necesitas cada scope sensible. Preparar 2-3 líneas por scope:
   - `spreadsheets`: "sincronizar filas de progreso de traducción directamente en el Google Sheet del usuario, sin backend propio."
   - `drive.metadata.readonly`: "listar únicamente nombre/ID de Sheets compartidos con el usuario para que elija cuál vincular — nunca se lee contenido de archivos."
   - `userinfo.email`: "identificar al usuario para filtrar 'Mis tareas' por alias."
6. **Video demo**: grabar un video corto (2-3 min) mostrando el flujo completo: pantalla de login → consent screen de Google con el branding real de la app → uso de cada scope (vincular un Sheet, ver "Mis tareas"). Subir a YouTube (puede ser "no listado", no necesita ser público).
7. **Enviar a verificación** desde Cloud Console → OAuth consent screen → "Publish app" → "Submit for verification". Tiempo estimado de Google: días a ~2 semanas para scopes sensibles (sin CASA).
8. **Mientras se revisa**: mantener la app en modo "Testing" con test users, sin cambios funcionales que rompan lo ya validado.

### Riesgo a evitar

No agregar scopes nuevos (p.ej. Drive completo) sin necesidad — cada scope adicional sensible/restringido reinicia o complica la revisión. Si en el futuro se necesita leer contenido de Sheets no compartidos explícitamente, evaluar `drive.file` (no sensible, scope por archivo) antes que `drive.readonly`.

---

## Parte 2 — SEO técnico + indexación (prioridad media)

Scores auditoría: **Search SEO ~48/100 (F, roza D)** · **AI Visibility/GEO ~30/100 (F)**. Esperable para una app de nicho con login — no necesita SEO agresivo, sí indexación básica correcta.

### Checklist priorizada (impacto/esfuerzo)

- [ ] **Activar "Enforce HTTPS"** en GitHub Pages → Settings → Pages (hoy `http://` no redirige).
- [ ] **`meta description`** en `index.html` `<head>` — describir la app en ~150 caracteres.
- [ ] **`<link rel="canonical">`** self-referencial a `https://scantracker.rweb.site/` (evita duplicado con `github.io`).
- [ ] **Open Graph + Twitter Cards** (`og:title`, `og:description`, `og:image`, `og:url`, `og:type=website`, `twitter:card=summary`) — hoy compartir el link en Discord se ve vacío.
- [ ] **`robots.txt`** en la raíz del repo, con línea `Sitemap:`.
- [ ] **`sitemap.xml`** en la raíz, con `/` y `/privacy.html`.
- [ ] **Contenido estático visible sin JS**: agregar un `<h1>` real + párrafo de 2-3 líneas describiendo la app en el `index.html` (hoy el HTML crudo solo trae un `<h3>Series</h3>` y el overlay de login — invisible para crawlers).
- [ ] **JSON-LD `WebApplication`** (name, description, applicationCategory, `offers` gratis, url).
- [ ] **Política de privacidad a footer visible** (comparte fix con Parte 1, paso 3).
- [ ] `<title>` más descriptivo: "Scan Tracker — Gestor de progreso para equipos de scanlation".
- [ ] Opcional/bajo impacto: `llms.txt`.

### Después del checklist técnico

1. Verificar dominio `scantracker.rweb.site` en Google Search Console (mismo paso que Parte 1.2 — se comparte).
2. Enviar `sitemap.xml` desde Search Console.
3. Usar "Inspeccionar URL" → "Solicitar indexación" para forzar el primer rastreo (dominios nuevos tipo `.site` pueden tardar semanas sin este empujón).

---

## Orden de ejecución recomendado

1. Footer con privacy policy visible + `<h1>`/párrafo estático + meta description + canonical + OG/Twitter + JSON-LD (un solo PR, toca `index.html`).
2. `robots.txt` + `sitemap.xml` + Enforce HTTPS.
3. Completar pantalla de consentimiento OAuth en Cloud Console (branding, dominio, ToS, justificación de scopes) — usa el mismo contenido del paso 1.
4. Verificar dominio en Search Console, enviar sitemap, solicitar indexación.
5. Grabar video demo y enviar a verificación OAuth de Google.
6. Esperar revisión de Google (días-semanas) manteniendo test users activos mientras tanto.

## Referencias

- [Sensitive scope verification — Google for Developers](https://developers.google.com/identity/protocols/oauth2/production-readiness/sensitive-scope-verification)
- [Restricted scope verification — Google for Developers](https://developers.google.com/identity/protocols/oauth2/production-readiness/restricted-scope-verification)
- [OAuth 2.0 Policies — Google for Developers](https://developers.google.com/identity/protocols/oauth2/policies)
- Auditoría completa (raw): ver output del subagente Opus, 2026-07-20 — resumida arriba.
