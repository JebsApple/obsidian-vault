---
aliases: [scan-tracker-web, scan-tracker-equipo]
tags: [project, proyecto/scanlation, google-sheets, web-app]
created: 2026-07-12
status: activo
deadline: ""
---

# Scan Tracker Web — App para el equipo

**Objetivo:** Web app estática (sin instalación) para que el equipo de scanlation (traductor, limpiador, typesetter, corrector, subidor — gente no técnica) marque progreso de capítulos directo contra Google Sheets, desde el browser o el celular.

**Origen:** pivote de `JebsApple/scan-tracker-desktop` (idea original, JavaFX + WebView, GitHub, jun 2026, pausada). Se descontinúa la vía Java: requiere JDK+Maven, WebView obsoleto, cero distribuible a no-programadores. Se conserva el HTML/JS de la UI (483 líneas, ya funcional) y se reemplaza el backend Java por Google Identity Services (GIS) en el browser, reusando patrones de auth/Sheets API del [[blueprint|plugin de Obsidian]] (TypeScript).

**Stack:** HTML/JS estático (vainilla, portado de scan-tracker-desktop), Google Identity Services (OAuth implícito/token en browser), Google Sheets API v4 REST directo desde el cliente.

**Repos:**
- Original (pausado): `JebsApple/scan-tracker-desktop` (privado, GH)
- Nuevo: por crear — `~/proyectos/scan-tracker-web/`

**Relación con el plugin de Obsidian:**
- Comparten Google Sheets como fuente de datos — mismo contrato de columnas
- Código independiente
- Plugin = uso personal del usuario (Obsidian ↔ Sheets)
- Web = uso del equipo (browser ↔ Sheets, sin instalación)

---

## Estado

| Fase | Estado |
|------|--------|
| Análisis del código original (Fable) | ✅ 2026-07-12 |
| Decisión: pivotar a web estática | ✅ 2026-07-12 |
| Entrevista de requirements (plan-interview) | ✅ 2026-07-12 |
| Sprint 0: Fundación + análisis HTML | 📋 Pendiente |
| Sprint 1: Auth + Sync | 📋 Pendiente |
| Sprint 2: Filtrado + Notificaciones + Dashboard | 📋 Pendiente |
| Sprint 3: Pulido + Deploy MVP | 📋 Pendiente |
| Sprint 4+: P1 features (push, filtros avanzados) | ⏳ Post-MVP |

## Links

- [[scan-tracker-web-blueprint|Blueprint completo]]
- [[MOCs/index|← Projects Index]]
