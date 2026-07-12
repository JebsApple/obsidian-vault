---
aliases: [scan-tracker, scanlation]
tags: [project, proyecto/scanlation, obsidian-plugin, google-sheets]
created: 2026-07-11
status: en-progreso
deadline: ""
---

# Scan Tracker → Obsidian

**Objetivo:** Plugin nativo de Obsidian para sincronizar hojas de cálculo de Google Sheets (tracker de scanlation) con notas markdown del vault. Pull + Push bidireccional.

**Stack:** TypeScript, Obsidian Plugin API, Google Sheets API v4, Google Drive API v3

**Repos:**
- Plugin: `~/proyectos/scan-tracker-obsidian-plugin/`
- Plugin instalado: `~/Vault/.obsidian/plugins/scan-tracker-sheets/`

---

## Estado

| Milestone | Estado |
|-----------|--------|
| M1: Google Cloud setup | ✅ |
| M2: Scaffold plugin | ✅ |
| M3: OAuth2 loopback | ✅ (código) |
| M4: Sheets API read | ✅ (código) |
| M5: Push to Sheets | ✅ (código) |
| M6: Auto-sync + settings | ✅ (código) |
| M7: Testing con sheet real | 📋 Pendiente |

**Siguiente:** M7 — testing end-to-end con sheets reales.

## Google Cloud

| Campo | Valor |
|-------|-------|
| Proyecto | `scan-tracker-502106` |
| Client ID | `50665049250-ipcmj3jr7fakbmabk2tq32ea1nh3id1o.apps.googleusercontent.com` |
| Test user | `mnznpremium756@gmail.com` |

## Hojas de prueba

| Nombre | Sheet ID |
|--------|----------|
| Sheet 1 | `173Tw9XhFooh5NKcJrmkEBJlL1WvkK51WyvPaSxw9BdE` |
| Sheet 2 | `1mxRSrfmwVPVJKQqKwbIv68mGHqn3453iLCl-Grk0kD4` |

## Relación con scan-tracker-desktop

Existe `scan-tracker-desktop` (Java/JavaFX) en GitHub — misma funcionalidad pero como app de escritorio. **Pausado por ahora.** El plugin de Obsidian es independiente: sync directo con Google Sheets, no depende del desktop.

| Proyecto | Stack | Estado |
|----------|-------|--------|
| scan-tracker-desktop | Java/JavaFX + HTML | Pausado |
| scan-tracker-obsidian-plugin | TypeScript/Obsidian API | **Activo** |

## Links

- [[Blueprints/blueprint|Blueprint completo]]
- [[Trackers/sprint-0|Sprint 0 (Testing)]]
- [[MOCs/index|← Projects Index]]
