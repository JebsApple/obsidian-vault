# Kanban Board — Scan Tracker Web

> Copiar este tablero a tu sistema de gestión (Obsidian, Notion, Trello, etc.)

---

## 📋 Pendiente

### Sprint 0 — Fundación
- [x] Leer y analizar `scan-tracker-desktop/src/main/resources/scan-tracker.html` `P0` `sprint-0`
- [x] Crear repo `scan-tracker-web/` en GitHub `P0` `sprint-0` — https://github.com/JebsApple/scan-tracker-web
- [x] Scaffold: estructura de proyecto (index.html, src/, docs/) `P0` `sprint-0`
- [x] Definir contrato de columnas del sheet `P0` `sprint-0` — ahora autodetectado por serie, ver commit 81ac47c
- [x] Wireframes: dashboard, tabla de capítulos, vista "mis pendientes" `P0` `sprint-0`

### Sprint 1 — Auth + Sync
- [x] Integrar Google Identity Services (token client, scope spreadsheets + userinfo.email) `P0` `sprint-1`
- [x] Portar `readSheet` de Java → fetch REST `P0` `sprint-1`
- [x] Portar `writeCell`/`appendRow` de Java → fetch REST `P0` `sprint-1`
- [x] Pull básico: cargar sheet → mostrar en tabla `P0` `sprint-1`
- [x] Push básico: editar celda → actualizar sheet `P0` `sprint-1`
- [x] localStorage como cache (último estado conocido) `P0` `sprint-1`

### Sprint 3 — Pulido + Deploy (MVP)
- [x] Responsive mínimo para que no se rompa en pantalla chica `P0` `sprint-3`
- [x] Error handling: 403, 404, rate limits con feedback claro `P0` `sprint-3`
- [x] Deploy a GitHub Pages `P0` `sprint-3` — https://jebsapple.github.io/scan-tracker-web/
- [ ] Testing personal: usar la app 1 semana en vez de Drive `P0` `sprint-3` — pendiente de uso real
- [ ] **ENTREGABLE MVP** `P0` `sprint-3`

### P1 — Post-MVP
- [ ] Notificaciones push a celular (Service Worker + Web Push) `P1` `sprint-4+`
- [x] Filtros avanzados (etapa, urgencia) `P1` `sprint-4+` — filtro "por fecha" descartado, no hay dato de fecha por capítulo
- [x] Historial personal de actividad `P1` `sprint-4+`

### P2 — Futuro
- [ ] Multi-usuario seguro (batch escrituras, conflictos, autoría) `P2` `backlog`
- [ ] Deploy público para todo el equipo `P2` `backlog`
- [ ] Guía de onboarding (1 link, sin instalación) `P2` `backlog`
- [x] Detectar automáticamente Sheets en "Compartidos conmigo" (Drive API) y mostrar desplegable para elegir, en vez de pegar URL a mano `P2` `backlog` — hecho 2026-07-14, requiere habilitar Drive API + scope drive.metadata.readonly en Google Cloud Console (ver README)
- [x] Soportar Sheets con múltiples hojas/pestañas: desplegable para elegir cuál usar, no solo vía `#gid=` en la URL `P2` `backlog` — hecho 2026-07-14, requiere sesión de Google iniciada (hojas privadas)
- [x] Logging de errores como práctica estándar (no debug temporal): capturar fallos de sync/API en un buffer persistente inspeccionable/exportable, reemplazando el `scantrackerDebug()` temporal actual una vez confirmada la causa raíz del bug de "Mis tareas" `P2` `backlog` — hecho 2026-07-14, "Registro de errores" dentro del Dashboard, exportable a .txt
- [ ] Rediseño visual / animaciones — inspirarse en las animaciones del repo MiNegocio (frontend Vue), usar skills `ui-ux-pro-max`/`frontend-design`/`design` cuando se aborde. No urgente, explícitamente para más adelante `P2` `backlog` — agregado 2026-07-13

---

## 🔧 En Progreso

*Vacío al inicio*

---

## 👀 En Revisión

- [ ] PR #1 — App Android (Capacitor) con notificaciones en background — SonarCloud verde (0 issues, quality gate OK), listo para merge manual. Al mergear, GitHub Pages se actualiza solo. APK regenerado con el código final en `~/Datos/apks/ScanTracker-debug.apk` (2026-07-17)

---

## ✅ Hecho

### Sprint 2 — Filtrado + Notificaciones + Dashboard
- [x] Filtrar capítulos por mi nombre (detectar en columnas `*_who`) `P0` `sprint-2`
- [x] Notificación Web cuando mi nombre aparece en una celda (polling) `P0` `sprint-2`
- [x] Vista "Mis pendientes": solo lo que debo trabajar `P0` `sprint-2`
- [x] Urgencia visual: capítulos con prioridad alta destacados `P0` `sprint-2`
- [x] Dashboard: series activas, progreso general, quick stats `P0` `sprint-2`

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
| Sprint 0 | 5 | 5 | 0 | 0 |
| Sprint 1 | 6 | 6 | 0 | 0 |
| Sprint 2 | 5 | 5 | 0 | 0 |
| Sprint 3 | 5 | 3 | 0 | 2 |
| P1 | 3 | 2 | 0 | 1 |
| P2 | 7 | 2 | 0 | 5 |
| **Total** | **31** | **23** | **0** | **8** |

---

*Generado con project-planner skill — 2026-07-12*
