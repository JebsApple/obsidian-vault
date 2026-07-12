# Kanban Board — Iglesia Project

> Copiar este tablero a tu sistema de gestión (Obsidian, Notion, Trello, etc.)

---

## 📋 Pendiente

### Sprint 0 — Fundación ✅ COMPLETO 2026-07-12
- [x] Crear repo `iglesia-project/` local (`~/proyectos/iglesia-project/`, sin remote aún) `P0` `sprint-0`
- [x] Scaffold: Astro + Tailwind v4 (config CSS-first vía `@theme` en `src/styles/global.css`) `P0` `sprint-0`
- [x] Definir estructura de páginas: index, horarios, contacto, galería, avisos, oración `P0` `sprint-0`
- [x] Wireframes: `docs/wireframes.md`, mobile-first, 6 secciones `P0` `sprint-0`
- [x] Definir paleta de colores: celeste/blanco/negro/dorado/gris como tokens semánticos `P0` `sprint-0`

Nota: Tailwind v4 no usa `tailwind.config.mjs` — tokens viven en `@theme` block. `Layout.astro` agregado (no estaba en plan original) como base compartida para nav/footer de Sprint 1.

### Sprint 1 — Core Layout + Contacto
- [ ] Layout base: header (nombre + nav), footer (redes), responsive `P0` `sprint-1`
- [ ] Hero section: nombre de la iglesia, horarios destacados, CTA `P0` `sprint-1`
- [ ] Sección contacto: dirección, teléfono, email, Google Maps embebido `P0` `sprint-1`
- [ ] Links a redes sociales (Facebook, Instagram, WhatsApp, YouTube) `P0` `sprint-1`
- [ ] SEO básico: meta tags, Open Graph, sitemap `P0` `sprint-1`

### Sprint 2 — Contenido + CMS
- [ ] Integrar Decap CMS para CRUD de avisos/anuncios `P0` `sprint-2`
- [ ] Página de horarios (contenido editable por CMS) `P0` `sprint-2`
- [ ] Galería de fotos (Cloudinary upload + visualización) `P0` `sprint-2`
- [ ] Buzón de oración (Netlify Forms → email de notificación) `P0` `sprint-2`

### Sprint 3 — Pulido + Deploy (MVP)
- [ ] Estilos finales: tipografía, espaciados, transiciones suaves `P0` `sprint-3`
- [ ] Lazy loading de imágenes `P0` `sprint-3`
- [ ] Deploy a Vercel/Netlify `P0` `sprint-3`
- [ ] Testing en celular real `P0` `sprint-3`
- [ ] Documentación para la persona que mantendrá el CMS `P0` `sprint-3`
- [ ] **ENTREGABLE MVP** `P0` `sprint-3`

### P1 — Post-MVP
- [ ] Sermones en video (YouTube embed playlist) `P1` `sprint-4+`
- [ ] Radio 24/7 (YouTube Live o Azuracast) `P1` `sprint-4+`
- [ ] Calendario de eventos (CRUD en CMS) `P1` `sprint-4+`
- [ ] Feed de redes sociales embebido `P1` `sprint-4+`

### P2 — Futuro
- [ ] Streaming en vivo (YouTube Live u otra plataforma) `P2` `backlog`
- [ ] Inscripciones a eventos/retiros (formularios) `P2` `backlog`
- [ ] Multi-idioma (Español/Inglés) `P2` `backlog`
- [ ] Dominio propio (comprar y configurar) `P2` `backlog`

---

## 🔧 En Progreso

*Vacío al inicio*

---

## 👀 En Revisión

*Vacío al inicio*

---

## ✅ Hecho

*Vacío al inicio*

---

## Labels

| Label | Color | Uso |
|-------|-------|-----|
| `P0` | 🔴 Rojo | MVP — obligatorio |
| `P1` | 🟡 Amarillo | Post-MVP — importante |
| `P2` | 🟢 Verde | Futuro — nice-to-have |
| `feature` | 🔵 Azul | Nueva funcionalidad |
| `bug` | 🟠 Naranja | Corrección |
| `tech-debt` | ⚫ Gris | Deuda técnica |
| `docs` | 🟣 Púrpura | Documentación |
| `sprint-0` | — | Sprint 0 — Fundación |
| `sprint-1` | — | Sprint 1 — Core Layout |
| `sprint-2` | — | Sprint 2 — Contenido + CMS |
| `sprint-3` | — | Sprint 3 — MVP |
| `sprint-4+` | — | Sprints futuros |
| `backlog` | — | Backlog general |

---

## Dependencias

| Card | Depende de | Notas |
|------|-----------|-------|
| Crear repo | — | Sin dependencias |
| Scaffold Astro | Crear repo | Necesita repo existente |
| Definir estructura páginas | Scaffold | Estructura base definida |
| Wireframes | Definir estructura | Necesita saber qué páginas habrá |
| Definir paleta colores | — | Decisión de diseño, sin blockers |
| Layout base | Scaffold + Definir paleta | Requiere estructura y estilos |
| Hero section | Layout base | Extiende el layout |
| Sección contacto | Layout base | Componente del layout |
| Links redes | Layout base | Componente del footer |
| SEO básico | Layout base | Meta tags en el head |
| Integrar Decap CMS | Layout base | CMS sobre estructura existente |
| Página horarios | Decap CMS | Contenido editable vía CMS |
| Galería fotos | Layout base + Cloudinary | Upload y visualización |
| Buzón oración | Netlify Forms | Formulario con notificación |
| Estilos finales | Todo el P0 | Pulido visual al final |
| Lazy loading | Galería fotos | Optimización de imágenes |
| Deploy | Estilos + Lazy loading | Último paso antes de MVP |
| Testing celular real | Deploy | Verificar en dispositivo |
| Documentación CMS | Testing | Para el mantenedor |

---

## Métricas de Progreso

| Sprint | Total | Hecho | En Progreso | Pendiente |
|--------|-------|-------|-------------|-----------|
| Sprint 0 | 5 | 0 | 0 | 5 |
| Sprint 1 | 5 | 0 | 0 | 5 |
| Sprint 2 | 4 | 0 | 0 | 4 |
| Sprint 3 | 6 | 0 | 0 | 6 |
| P1 | 4 | 0 | 0 | 4 |
| P2 | 4 | 0 | 0 | 4 |
| **Total** | **28** | **0** | **0** | **28** |

---

*Generado con project-planner skill — 2026-07-12*
