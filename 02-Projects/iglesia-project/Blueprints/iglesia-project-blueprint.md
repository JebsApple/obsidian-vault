---
aliases: [iglesia-project, iglesia-web, jesus-reigns]
tags: [project, church, web, community]
created: 2026-07-12
status: draft
---

# Iglesia Project — Plan Completo (v1, post-entrevista)

## Contexto

Iglesia "Jesus Reigns Under Worship" necesita presencia web completa. Actualmente solo tiene redes sociales (Facebook, Instagram, WhatsApp, YouTube) con poca actividad. El sitio debe ser mantenible por una persona no técnica y funcionar principalmente en celular.

**Objetivo:** Web moderna, minimalista y familiar que sirva como hub central de información y comunicación de la iglesia.

---

## Entrevista — Resumen

| Dominio | Respuesta clave |
|---------|----------------|
| **Estado actual** | Solo redes sociales, sin web existente |
| **Mantenimiento** | Persona no técnica de la iglesia |
| **Features sí o sí** | Horarios, avisos, contactos + Google Maps, buzón de oración, galería |
| **Features futuras** | Radio 24/7, streaming de misas, sermón en video |
| **Tráfico** | ~100 visitas/mes, iglesia pequeña |
| **Interactividad** | Mínima, sin chat ni inscripción (escalabilidad sí) |
| **CMS** | CRUD para publicaciones, contenido estático cambiante esporádicamente |
| **Frecuencia** | ~1 evento grande cada 2-3 semanas |
| **Dominio** | No propio aún, invertir si la web queda bien |
| **Hosting** | Preferencia gratis, pero podría alojarse en computador de la iglesia |
| **Social** | Facebook, Instagram, WhatsApp, YouTube |
| **Responsive** | Sí, más celular que PC |
| **Estilo** | Moderno, accesible, familiar. Celeste, blanco, negro, detalles dorados/amarillos (trigo). Nubes, trigo, minimalismo. Logo: león con corona (implementar después) |
| **Out of scope** | No tienda. App Luciernaga independiente |
| **Éxito** | Contacto + ubicación en Maps, foro/avisos, buzón de oración |

---

## Arquitectura de Features — Priorizado

### P0 — MVP (Core)
| Feature | Descripción |
|---------|-------------|
| Página principal | Hero con nombre, horarios, ubicación con Google Maps embebido |
| Contacto | Dirección, teléfono, email, redes sociales vinculadas |
| Horarios | Misa, reuniones, actividades (texto estático editable) |
| Avisos/Anuncios | CRUD simple: publicar/editar/eliminar avisos (con fecha, título, contenido) |
| Buzón de oración | Formulario que envía peticiones (email o storage) |
| Galería | Upload y visualización de fotos (ámbitos, eventos) |
| Responsive | Mobile-first, que funcione bien en celular |

### P1 — Post-MVP
| Feature | Descripción |
|---------|-------------|
| Sermones en video | Embed de YouTube o subida directa |
| Radio 24/7 | Player de audio streaming (puede ser YouTube en vivo o stream propio) |
| Eventos | Calendario con próximos eventos (CRUD) |
| Redes sociales | Feed de Instagram/Facebook embebido |

### P2 — Futuro
| Feature | Descripción |
|---------|-------------|
| Streaming en vivo | Integración con YouTube Live u otra plataforma |
| Inscripciones | Formulario de inscripción a eventos/retiros |
| Multi-idioma | Español/Inglés si la congregación lo requiere |

---

## Stack Técnico

| Capa | Tecnología | Razón |
|------|-----------|-------|
| Framework | **Astro** | Static-first, islands de interactividad, SEO excelente, JSX |
| UI | **Tailwind CSS** | Utility-first, rápido de diseñar, responsive fácil |
| CMS | **Decap CMS** (ex Netlify CMS) | CRUD visual para no-técnicos, Markdown en repo |
| Hosting | **GitHub Pages** → **Vercel/Netlify** (gratis) | Escalar cuando se necesite forms/APIs |
| Formularios | **Netlify Forms** o **Formspree** (gratis tier) | Para buzón de oración sin backend |
| Galería | **Cloudinary** (gratis tier) | Upload y optimización de imágenes |
| Video | **YouTube embed** | Gratis, sin storage propio |
| Radio | **YouTube Live** o **Azuracast** (self-hosted) | Escalabilidad a radio 24/7 |
| Maps | **Google Maps embed** | Ubicación de la iglesia |

---

## Hosting — Opciones Comparadas

| Opción | Costo | Pros | Contras |
|--------|-------|------|---------|
| **GitHub Pages** | Gratis | Simple, CI/CD automático | Sin forms nativos, sin server-side |
| **Vercel** | Gratis (hobby) | Forms, edge functions, deploy automático | Límites en bandwidth |
| **Netlify** | Gratis | Forms incluidos, CMS integrado | Límites en form submissions |
| **Computador iglesia** | Electricidad | Control total | Necesita dominio, SSL, uptime, mantenimiento técnico |
| **Vercel + dominio propio** | ~$10-15/año dominio | Profesional, escalable | Costo mínimo |

**Recomendación:** Vercel (gratis) como base, con opción de migrar a computador de la iglesia si se necesita radio 24/7 o streaming propio.

---

## Knowledge Audit

| Knowledge | Source | Confidence |
|-----------|--------|------------|
| Astro | Training data | High |
| Tailwind CSS | Training data | High |
| Decap CMS | Training data | Medium |
| Google Maps embed | Training data | High |
| Netlify Forms / Formspree | Training data | High |
| YouTube embed API | Training data | High |
| Cloudinary | Training data | Medium |

### Bloqueos identificados
- **Logo de la iglesia** — el usuario lo implementará después, no bloquea
- **Contenido real** — necesito datos de ejemplo para placeholders (horarios, avisos)
- **Decap CMS setup** — requiere Git Gateway o GitHub repo privado

---

## Sprint Plan

### Sprint 0 — Fundación (1 semana)
- [ ] Crear repo `iglesia-project/` en GitHub
- [ ] Scaffold: `npm create astro@latest` + Tailwind
- [ ] Definir estructura de páginas: index, horarios, contacto, galería, avisos, buzón
- [ ] Wireframes: mobile-first, secciones principales
- [ ] Definir paleta de colores: celeste, blanco, negro, dorado/trigo

### Sprint 1 — Core Layout + Contacto (2 semanas)
- [ ] Layout base: header (nombre + nav), footer (redes), responsive
- [ ] Hero section: nombre de la iglesia, horarios destacados, CTA
- [ ] Sección contacto: dirección, teléfono, email, Google Maps embebido
- [ ] Links a redes sociales (Facebook, Instagram, WhatsApp, YouTube)
- [ ] SEO básico: meta tags, Open Graph, sitemap

### Sprint 2 — Contenido + CMS (2 semanas)
- [ ] Integrar Decap CMS para CRUD de avisos/anuncios
- [ ] Página de horarios (contenido editable por CMS)
- [ ] Galería de fotos (Cloudinary upload + visualización)
- [ ] Buzón de oración (Netlify Forms → email de notificación)

### Sprint 3 — Pulido + Deploy (1 semana)
- [ ] Estilos finales: tipografía, espaciados, transiciones suaves
- [ ] Lazy loading de imágenes
- [ ] Deploy a Vercel/Netlify
- [ ] Testing en celular real
- [ ] Documentación para la persona que mantendrá el CMS
- [ ] **ENTREGABLE MVP**

### Sprint 4+ — P1 Features
- Sermones en video (YouTube embed playlist)
- Radio 24/7 (YouTube Live o Azuracast)
- Calendario de eventos (CRUD en CMS)
- Feed de redes sociales embebido

---

## Estilo Visual — Paleta

| Elemento | Color | Uso |
|----------|-------|-----|
| **Primary** | Celeste `#87CEEB` o similar | Botones, links, acentos |
| **Background** | Blanco `#FFFFFF` | Fondos principales |
| **Text** | Negro `#1A1A1A` | Texto principal |
| **Accent** | Dorado/Trigo `#D4AF37` | Detalles, bordes, iconos decorativos |
| **Secondary** | Gris claro `#F5F5F5` | Fondos alternos, cards |

**Imágenes decorativas:** nubes sutiles, trigo como elemento gráfico, minimalismo extremo.

---

## Decisiones Pendientes
1. ¿Hosting final: Vercel (gratis) o computador de la iglesia?
2. ¿Dominio propio desde el inicio o esperar a que la web esté lista?
3. ¿El buzón de oración envía email o se almacena en una base de datos?
4. ¿La galería es solo fotos o también necesita álbumes por evento?

---

## Criterio de Aprobación
- [ ] Entrevista completada con todas las respuestas
- [ ] Knowledge audit sin bloqueos críticos
- [ ] Sprint plan con dependencias claras
- [ ] Out of scope definido explícitamente
- [ ] Usuario aprueba el plan

---

*Generado con plan-interview skill — 2026-07-12*
