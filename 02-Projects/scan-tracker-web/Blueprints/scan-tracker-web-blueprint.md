---
aliases: [scan-tracker-web-blueprint]
tags: [project, plan, scanlation, web-app]
created: 2026-07-12
status: draft
---

# Scan Tracker Web — Plan Completo (v2, post-entrevista)

## Contexto

Ver [[README|README.md]] para objetivo y decisión de pivote. Este documento es la versión revisada post-entrevista de requirements (plan-interview, 2026-07-12).

**Objetivo:** Web app que reemplaze Google Drive como fuente principal de tracking de capítulos de scanlation. El usuario no debería tener que entrar a Drive hoja por hoja.

**Criterio de éxito:** que le funcione al usuario. Uso externo queda en segundo plano.

---

## Entrevista — Resumen

| Dominio | Respuesta clave |
|---------|----------------|
| **Alcance** | 10-20 personas por serie, PC-focused, acceso por serie |
| **Frecuencia** | Actualización al terminar cada tarea |
| **Sync** | Necesaria con internet; recordatorios/urgentes pueden ser offline |
| **Features clave** | Sync fluido con Sheets, filtrar capítulos propios, notificaciones al ser designado, dashboard de series |
| **Out of scope** | No chat, no pagos, no lectura de capítulos, no funciones innecesarias |
| **Éxito personal** | App se convierte en fuente principal, no Drive |
| **Código existente** | HTML/JS en `scan-tracker-desktop` (~80% reutilizable), Java descartada |

---

## Arquitectura de Features — Priorizado

### P0 — MVP (funcional para el usuario)
| Feature | Descripción |
|---------|-------------|
| Auth Google | Login con Google Identity Services (token implícito) |
| Sync con Sheets | Pull/push bidireccional, lectura y escritura |
| Filtrar "mis capítulos" | Por nombre en columnas `*_who` (desplegables del sheet) |
| Notificación de designación | Cuando aparece mi nombre en una celda `*_who`, recibo aviso |
| Dashboard de series | Vista general: series activas, progreso, urgencia |
| Responsividad PC | Layout optimizado para desktop, mínimo responsive |

### P1 — Post-MVP
| Feature | Descripción |
|---------|-------------|
| Notificaciones push (celular) | Conexión a celular via calendar/push para recordatorios urgentes |
| Filtros avanzados | Por etapa (trad/limp/typ/corr/sube), por urgencia, por fecha |
| Historial personal | Qué hice yo, cuándo, cuánto tardé |

### P2 — Futuro
| Feature | Descripción |
|---------|-------------|
| Multi-usuario seguro | Batch de escrituras, detección de conflictos, autoría por etapa |
| Deploy público | GitHub Pages o similar para que el equipo acceda sin instalación |
| Guía de onboarding | 1 link, sin instalación |

---

## Stack Técnico

| Capa | Tecnología | Razón |
|------|-----------|-------|
| Frontend | **HTML/JS vanilla** (port del código existente) | Ya existe, ~80% reutilizable |
| Auth | **Google Identity Services** (token client) | Sin backend, directo en browser |
| API | **Google Sheets API v4 REST** | Mismo contrato que el plugin |
| Storage | **localStorage** como cache | Offline para estado local |
| Deploy | **GitHub Pages** (estático) | Gratis, sin backend |
| Notificaciones | **Web Notifications API** + **Service Worker** | Para alerts de designación |

---

## Knowledge Audit

| Knowledge | Source | Confidence |
|-----------|--------|------------|
| HTML/JS vanilla | Training data | High |
| Google Identity Services (GIS) | Training data | High |
| Google Sheets API v4 REST | Training data + plugin existente | High |
| Web Notifications API | Training data | High |
| Service Workers | Training data | Medium |
| Código existente scan-tracker.html | Local repo | High |

### Bloqueos identificados
- **Código existente no revisado** — necesito leer `scan-tracker.html` para entender qué portar
- **GitHub Pages** — deploy estático, sin backend. ¿Sirve para notificaciones push? Necesito verificar

---

## Sprint Plan

### Sprint 0 — Fundación (1 semana)
- [ ] Leer y analizar `scan-tracker-desktop/src/main/resources/scan-tracker.html`
- [ ] Crear repo `scan-tracker-web/` en GitHub
- [ ] Scaffold: estructura de proyecto (index.html, src/, docs/)
- [ ] Definir contrato de columnas del sheet (mismo que plugin)
- [ ] Wireframes: dashboard, tabla de capítulos, vista "mis pendientes"

### Sprint 1 — Auth + Sync (2 semanas)
- [ ] Integrar Google Identity Services (token client, scope `spreadsheets` + `userinfo.email`)
- [ ] Portar `readSheet` de Java → fetch REST
- [ ] Portar `writeCell`/`appendRow` de Java → fetch REST
- [ ] Pull básico: cargar sheet → mostrar en tabla
- [ ] Push básico: editar celda → actualizar sheet
- [ ] localStorage como cache (último estado conocido)

### Sprint 2 — Filtrado + Notificaciones (2 semanas)
- [ ] Filtrar capítulos por mi nombre (detectar en columnas `*_who`)
- [ ] Notificación Web cuando mi nombre aparece en una celda (polling o push)
- [ ] Vista "Mis pendientes": solo lo que debo trabajar
- [ ] Urgencia visual: capítulos con prioridad alta destacados
- [ ] Dashboard: series activas, progreso general, quick stats

### Sprint 3 — Pulido + Deploy (1 semana)
- [ ] Responsive mínimo para que no se rompa en pantalla chica
- [ ] Error handling: 403, 404, rate limits con feedback claro
- [ ] Deploy a GitHub Pages
- [ ] Testing personal: usar la app 1 semana en vez de Drive
- [ ] **ENTREGABLE MVP**

### Sprint 4+ — P1 Features
- Notificaciones push a celular (via Service Worker + Web Push)
- Filtros avanzados (etapa, urgencia, fecha)
- Historial personal de actividad

---

## Decisiones Pendientes
1. ¿Qué parte del HTML existente se conserva tal cual y qué se reescribe?
2. ¿Web Notifications API suficiente o necesitamos Firebase Cloud Messaging para push real?
3. ¿Cómo manejar que el sheet tiene desplegables (validación de datos)? La app debe leer los valores posibles

---

## Criterio de Aprobación
- [ ] Entrevista completada con todas las respuestas
- [ ] Knowledge audit sin bloqueos críticos
- [ ] Sprint plan con dependencias claras
- [ ] Out of scope definido explícitamente
- [ ] Usuario aprueba el plan

---

*Generado con plan-interview skill — 2026-07-12*
