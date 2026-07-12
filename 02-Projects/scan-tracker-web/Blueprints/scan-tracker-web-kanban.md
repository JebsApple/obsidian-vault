# Kanban Board — Scan Tracker Web

> Copiar este tablero a tu sistema de gestión (Obsidian, Notion, Trello, etc.)

---

## 📋 Pendiente

### Sprint 0 — Fundación
- [ ] Leer y analizar `scan-tracker-desktop/src/main/resources/scan-tracker.html` `P0` `sprint-0`
- [ ] Crear repo `scan-tracker-web/` en GitHub `P0` `sprint-0`
- [ ] Scaffold: estructura de proyecto (index.html, src/, docs/) `P0` `sprint-0`
- [ ] Definir contrato de columnas del sheet `P0` `sprint-0`
- [ ] Wireframes: dashboard, tabla de capítulos, vista "mis pendientes" `P0` `sprint-0`

### Sprint 1 — Auth + Sync
- [ ] Integrar Google Identity Services (token client, scope spreadsheets + userinfo.email) `P0` `sprint-1`
- [ ] Portar `readSheet` de Java → fetch REST `P0` `sprint-1`
- [ ] Portar `writeCell`/`appendRow` de Java → fetch REST `P0` `sprint-1`
- [ ] Pull básico: cargar sheet → mostrar en tabla `P0` `sprint-1`
- [ ] Push básico: editar celda → actualizar sheet `P0` `sprint-1`
- [ ] localStorage como cache (último estado conocido) `P0` `sprint-1`

### Sprint 2 — Filtrado + Notificaciones + Dashboard
- [ ] Filtrar capítulos por mi nombre (detectar en columnas `*_who`) `P0` `sprint-2`
- [ ] Notificación Web cuando mi nombre aparece en una celda (polling) `P0` `sprint-2`
- [ ] Vista "Mis pendientes": solo lo que debo trabajar `P0` `sprint-2`
- [ ] Urgencia visual: capítulos con prioridad alta destacados `P0` `sprint-2`
- [ ] Dashboard: series activas, progreso general, quick stats `P0` `sprint-2`

### Sprint 3 — Pulido + Deploy (MVP)
- [ ] Responsive mínimo para que no se rompa en pantalla chica `P0` `sprint-3`
- [ ] Error handling: 403, 404, rate limits con feedback claro `P0` `sprint-3`
- [ ] Deploy a GitHub Pages `P0` `sprint-3`
- [ ] Testing personal: usar la app 1 semana en vez de Drive `P0` `sprint-3`
- [ ] **ENTREGABLE MVP** `P0` `sprint-3`

### P1 — Post-MVP
- [ ] Notificaciones push a celular (Service Worker + Web Push) `P1` `sprint-4+`
- [ ] Filtros avanzados (etapa, urgencia, fecha) `P1` `sprint-4+`
- [ ] Historial personal de actividad `P1` `sprint-4+`

### P2 — Futuro
- [ ] Multi-usuario seguro (batch escrituras, conflictos, autoría) `P2` `backlog`
- [ ] Deploy público para todo el equipo `P2` `backlog`
- [ ] Guía de onboarding (1 link, sin instalación) `P2` `backlog`

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
| `sprint-1` | — | Sprint 1 — Auth + Sync |
| `sprint-2` | — | Sprint 2 — Filtrado + Notificaciones |
| `sprint-3` | — | Sprint 3 — MVP |
| `sprint-4+` | — | Sprints futuros |
| `backlog` | — | Backlog general |

---

## Dependencias

| Card | Depende de | Notas |
|------|-----------|-------|
| Crear repo | — | Sin dependencias |
| Scaffold | Crear repo | Necesita repo existente |
| Definir contrato columnas | Leer HTML | Requiere análisis del código |
| Wireframes | Definir contrato | Necesita entender estructura de datos |
| Integrar GIS auth | Scaffold | Requiere estructura base |
| Portar readSheet | Integrar GIS auth | Necesita token para llamadas |
| Portar writeCell | Portar readSheet | Mismo patrón, extiende read |
| Pull básico | Portar readSheet | Requiere read funcional |
| Push básico | Portar writeCell | Requiere write funcional |
| localStorage | Pull básico | Cache del último estado |
| Filtrar por nombre | Pull básico | Requiere datos cargados |
| Notificación Web | Filtrar por nombre | Detecta cambios en mi nombre |
| Vista "Mis pendientes" | Filtrar por nombre | Filtrado ya funcionando |
| Urgencia visual | Pull básico | Datos de prioridad disponibles |
| Dashboard | Pull básico + Filtrar | Agrega stats de filtered data |
| Responsive | Todo el P0 | Pulido visual al final |
| Error handling | Todo el P0 | Manejo robusto de edges |
| Deploy | Responsive + Error handling | Último paso antes de MVP |

---

## Métricas de Progreso

| Sprint | Total | Hecho | En Progreso | Pendiente |
|--------|-------|-------|-------------|-----------|
| Sprint 0 | 5 | 0 | 0 | 5 |
| Sprint 1 | 6 | 0 | 0 | 6 |
| Sprint 2 | 5 | 0 | 0 | 5 |
| Sprint 3 | 5 | 0 | 0 | 5 |
| P1 | 3 | 0 | 0 | 3 |
| P2 | 3 | 0 | 0 | 3 |
| **Total** | **27** | **0** | **0** | **27** |

---

*Generado con project-planner skill — 2026-07-12*
