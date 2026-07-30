<!-- fold(tema="manga-de-weones", lineas=166, leer_si="trabajando en manga-de-weones") -->
---
tags: [proyecto/manga-de-weones, blueprint, planning]
created: "2026-07-24"
---

# Blueprint: Manga de Weones

## Contexto

Sitio personal para publicar manga traducido al chileno. Requisitos del encargo:

1. **Full gratuito** para partir, con escalabilidad a pagar por partes cuando crezca.
2. Posibilidad de **ads y/o donaciones**.
3. Es proyecto personal — un solo dev, sin equipo, sin presupuesto inicial.

El diferenciador no es técnico, es editorial: **traducción al chileno**, no al español neutro. Eso define el tono del sitio completo (UI incluida) y es lo único que no puede copiar un competidor con más recursos.

Este blueprint aprovecha directamente la investigación de infraestructura hecha sobre raventard.xyz en julio 2026 — pipeline de imágenes, límites de Cloudflare, protección anti-hotlink y costos reales de CDN.

---

## Restricción de diseño que define la monetización

Hay que resolver esto **antes** de escribir la primera línea, porque cambia la arquitectura de la parte de plata (no la del sitio):

Publicar manga traducido sin licencia del titular es infracción de copyright. Eso no impide construir la plataforma — es software legítimo y sirve igual para obra propia, licenciada, dominio público o webcomics Creative Commons. Pero **sí choca de frente con el requisito de ads/donaciones**:

- **AdSense rechaza o sanciona sitios con contenido no licenciado.** No es teoría: es exactamente lo que le pasó a raventard hace poco (amonestación activa). Google lee la página, no la infraestructura — cambiar de host no lo evita.
- **Ko-fi, Patreon y Buy Me a Coffee** prohíben en sus términos monetizar contenido infractor. Las cuentas se cierran con el saldo dentro.
- **Los procesadores de pago** (Stripe, PayPal, MercadoPago) cierran cuentas por reclamos DMCA reiterados.
- El riesgo cae sobre el **dominio y la cuenta personal**, no sobre un anónimo.

**Consecuencia práctica para el diseño:** la plataforma se construye agnóstica del contenido (Fases 0-3, idénticas en cualquier escenario), y la Fase 4 (monetización) se define según qué se publique:

| Escenario de contenido | Ads | Donaciones | Riesgo |
|---|---|---|---|
| Obra propia / de amigos dibujantes | Sí | Sí | Nulo |
| Licenciada o Creative Commons | Sí | Sí | Nulo |
| Dominio público (obra antigua) | Sí | Sí | Nulo |
| Scanlation sin licencia | No viable | No viable (bloqueo de cuenta) | Alto: DMCA al dominio |

Si el objetivo es que el proyecto genere ingresos, el camino que funciona es **contenido propio o licenciado**. Hay obra chilena independiente y autores buscando plataforma — y ahí el ángulo "traducido/hecho en chileno" es una ventaja real, no un problema legal.

---

## Stack: Cloudflare completo

Todo el stack en un solo proveedor, todo con free tier usable de verdad y escalado por unidad (sin saltos de plan de $0 a $20).

| Capa | Servicio | Free tier | Al escalar |
|---|---|---|---|
| Hosting web | **Cloudflare Pages** | Bandwidth **ilimitado**, 500 builds/mes | Gratis igual |
| Imágenes | **Cloudflare R2** | 10 GB, egreso **$0 para siempre** | $0,015/GB-mes, egreso sigue $0 |
| Base de datos | **Cloudflare D1** (SQLite) | 5 GB, 5M lecturas/mes | Por uso |
| API / panel | **Cloudflare Workers** | 100.000 req/día | $5/mes por 10M req |
| Auth admin | **Cloudflare Access** | Hasta 50 usuarios | Gratis para este caso |
| Framework | **Astro** + Tailwind | — | — |

### Por qué esta combinación y no otra

**Pages sobre Vercel/Netlify:** los dos competidores topan en 100 GB/mes de bandwidth en free tier. Un sitio de manga es *puro* bandwidth — se revienta ese límite con un capítulo popular. Pages no tiene tope.

**R2 sobre Backblaze B2 + Bunny** (la opción que evaluamos para raventard): B2+Bunny es correcta cuando ya hay 100 GB históricos y tráfico grande, pero para partir de cero R2 gana claro. El egreso en R2 es **$0 siempre**, mientras Bunny cobra **$0,035–0,045/GB en Latinoamérica** (el precio de $0,01 es solo Norteamérica/Europa). Con audiencia chilena, eso es la diferencia entre pagar $0 y pagar por cada lector.

**R2 y el temor a que Cloudflare bloquee el dominio:** la restricción histórica de la sección 2.8 de sus términos apunta a usar el *proxy CDN gratis* para servir media desde orígenes externos. R2 es producto propio de Cloudflare diseñado justamente para servir objetos — es el camino soportado, no una artimaña.

**D1 sobre Supabase:** Supabase free pausa el proyecto tras una semana sin actividad, lo que en un sitio de tráfico irregular significa que el primer visitante del día se come el arranque en frío. D1 no pausa y vive en el mismo runtime que los Workers.

### Costo proyectado real

- **Fase 0-3 (catálogo chico, <10 GB):** $0/mes. Solo el dominio (~$10/año).
- **Al llegar a 100 GB de contenido:** ~$1,35/mes de almacenamiento. Bandwidth sigue en $0 sin importar cuántos lectores haya.
- **Punto donde algo cuesta de verdad:** cuando el panel de subida supere 100k requests/día en Workers (muy lejos para un sitio personal).

---

## Fases

### Fase 0: Scaffold y deploy
- **Objetivo:** sitio vacío en producción con dominio propio y deploy automático desde `main`.
- **Archivos:**
  - `package.json`, `astro.config.mjs` — proyecto Astro con Tailwind
  - `src/layouts/Base.astro` — layout con nav y footer
  - `src/pages/index.astro` — portada placeholder
  - `wrangler.toml` — bindings de R2 y D1
- **Verificación:** push a `main` publica solo en Cloudflare Pages y el sitio carga en el dominio.
- **Por qué primero:** tener el pipeline de deploy funcionando desde el día uno evita descubrir problemas de build cuando ya hay código encima.

### Fase 1: Lector
- **Objetivo:** leer un capítulo completo desde R2, con navegación entre capítulos.
- **Archivos:**
  - `src/pages/[serie]/index.astro` — ficha de serie + lista de capítulos
  - `src/pages/[serie]/[cap].astro` — lector (scroll vertical, estilo webtoon)
  - `src/lib/db.ts` — queries a D1 (series, capítulos, páginas)
  - `schema.sql` — tablas `series`, `chapters`, `pages`
- **Decisión clave — estructura de rutas en R2:** `/{serie-slug}/{cap}/{001.webp}`. **Es la única decisión irreversible del proyecto**: estas URLs quedan grabadas en la base para siempre y renombrarlas después obliga a migrar datos.
- **Verificación:** un capítulo subido a mano se lee completo, en orden, en móvil y escritorio.

### Fase 2: Pipeline de subida
- **Objetivo:** subir un capítulo sin tocar la base ni R2 a mano.
- **Archivos:**
  - `worker/upload.ts` — endpoint de subida (mismo origen que el panel → sin CORS)
  - `worker/process.ts` — conversión WebP + corte de tiras largas
  - `src/pages/admin/upload.astro` — panel drag & drop, detrás de Cloudflare Access
- **Reglas del pipeline (heredadas de la investigación de raventard):**
  - Convertir a **WebP q80** — ~30% menos peso, punto dulce para línea y tramas de manga (bajo q70 aparecen artefactos en los bordes de tinta).
  - **Cortar toda imagen sobre 16.383 px** de alto — límite duro del formato WebP, y los webtoons se exportan como tira única de 20.000+ px. Cortar automático, nunca rechazar: rechazar traslada trabajo manual al humano en cada capítulo.
  - **Natural sort** de nombres de archivo — si se ordena alfabético queda `1, 10, 11, 2` y las páginas salen desordenadas. Es el bug clásico de estas herramientas.
  - **Subida en chunks** si los archivos superan ~50 MB — mantiene cada request lejos del límite de 100 MB de Cloudflare y la hace reanudable.
- **Verificación:** arrastrar un ZIP de capítulo lo deja publicado y leíble, sin pasos manuales.

### Fase 3: UX de lectura
- **Objetivo:** que se sienta un sitio y no una carpeta de imágenes.
- **Archivos:**
  - `src/components/Reader.astro` — precarga de la página siguiente, modo oscuro
  - `src/lib/progress.ts` — progreso de lectura en `localStorage` (sin cuentas de usuario)
  - `src/pages/buscar.astro` — búsqueda en el catálogo
- **Decisión:** nada de login en esta fase. Favoritos y progreso en `localStorage` cubren el 90% del valor con el 5% del trabajo. Cuentas solo si aparece una razón concreta.
- **Verificación:** cerrar y reabrir el navegador conserva el progreso; el catálogo se busca sin recargar.

### Fase 4: Sostenibilidad (decidida 2026-07-24)

**Decisión tomada: el sitio se lanza sin ads. Solo donaciones voluntarias, con encuadre de costos.**

- **Objetivo:** que el sitio cubra sus propios gastos (dominio + almacenamiento), no que genere lucro.

**Por qué sin ads:**
1. Las sanciones de AdSense son **a nivel de cuenta**, atadas a identidad y datos de pago — no a dominio. Un ban sigue a la persona a proyectos futuros. Arriesgar la cuenta de Google acá compromete [[TL2EDIT]], que es el proyecto con potencial real de ingresos. Intercambio malo.
2. Los ads son **hostiles al producto**. Los intersticiales al cambiar de página son la razón número uno de abandono en lectores de manga. Un lector limpio y rápido es diferenciador real.
3. **No hay presión de costos** que obligue a monetizar: con Pages + R2 el bandwidth es gratis y el gasto total ronda los $10/año de dominio.

**Vías de donación, en orden:**
- **MercadoPago / Khipu / transferencia directa** — sin filtro editorial de contenido, y son los métodos que la audiencia chilena ya usa.
- **Ko-fi y Patreon quedan descartados**: sus términos prohíben monetizar contenido no licenciado y cierran cuentas con el saldo dentro.
- **Patrocinio directo del nicho** (tiendas de manga/anime chilenas) — se negocia sin intermediario, mejor CPM que ads programáticos porque el público está segmentado.

**Encuadre público:** "ayúdanos a pagar el hosting", con meta mensual visible y costos reales publicados. Costos, no suscripción. Es honesto y es como funciona el espacio.

**Puerta que queda abierta:** si más adelante se suma una sección de obra original chilena (con acuerdo de los autores), *esa* sección sí es monetizable con AdSense sin riesgo, porque el contenido es limpio. Sería la vía de crecimiento, no un parche.

- **Archivos:**
  - `src/pages/apoyar.astro` — página de donación con costos y meta transparentes
  - `src/components/DonateBanner.astro` — banner discreto, nunca intersticial ni sobre el lector
- **Verificación:** las donaciones de un mes cubren dominio + almacenamiento.
- **Lo que esto NO resuelve:** las donaciones no son escudo legal. Un DMCA puede llegar igual al dominio o al host. Cambia quién puede sancionar (se sale del alcance de Google), no la naturaleza del contenido.

---

## Dependencias entre fases

```
Fase 0 (deploy) → Fase 1 (lector) → Fase 2 (subida) → Fase 3 (UX) → Fase 4 (donaciones)
```

Ninguna fase queda bloqueada por decisiones pendientes: la vía de sostenibilidad ya está resuelta (donaciones, sin ads), así que las cinco fases se pueden construir seguidas.

## Rollback

Cada fase es un branch que se mergea a `main` solo cuando el deploy de preview funciona. Cloudflare Pages guarda todos los deploys anteriores: volver atrás es un clic, no un `git revert`.

## Anti-objetivos (lo que este proyecto NO va a hacer)

- **No** cuentas de usuario en las primeras fases — `localStorage` alcanza.
- **No** app móvil — PWA si acaso, mucho después.
- **No** sistema de comentarios propio — si se necesita, Discord.
- **No** panel de administración genérico — solo lo que el flujo de subida requiere.
