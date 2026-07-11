---
title: Scan Tracker → Obsidian (Plan B: Script Export)
tags:
  - proyecto
  - proyecto/scanlation
  - plan
  - scanlation
  - dataview
created: 2026-07-11
status: pendiente
---

# Scan Tracker → Obsidian (Plan B)

## Objetivo
Script Python que lee Google Sheets (scan-tracker) y genera notas markdown en Obsidian con dashboards Dataview para visibility personal.

## Stack
- **Lenguaje:** Python
- **Auth:** Google Service Account (JSON key)
- **Output:** `~/Vault/Scanlation/` (raíz del vault)
- **Sync:** systemd timer cada 5 min

## Archivos a crear

| Archivo | Propósito |
|---------|-----------|
| `~/.local/bin/scantracker-sync` | Script Python (ejecutable) |
| `~/.config/scantracker-sync/config.yaml` | Config: sheets, aliases, vault path |
| `~/.config/scantracker-sync/credentials.json` | Service account key (manual setup) |
| `~/.config/systemd/user/scantracker-sync.service` | Servicio systemd |
| `~/.config/systemd/user/scantracker-sync.timer` | Timer cada 5 min |
| `~/Vault/Scanlation/scripts/progressBar.js` | Componente DataviewJS reutilizable |
| `~/Vault/Scanlation/index.md` | Dashboard auto-generado |

## Datos: Google Sheets → Markdown

**Columnas del scan-tracker:**

| Col A | Col B | Col C | Col D | Col E | Col F | Col G | Col H | Col I | Col J | Col K | Col L |
|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|
| Capítulo | Prioridad | TRAD who | TRAD done | LIMP who | LIMP done | TYP who | TYP done | CORR who | CORR done | SUBE who | SUBE done |

**Nota de serie generada** (`One Piece.md`):
```yaml
---
tags:
  - manga/series
  - scanlation
series: "One Piece"
sheet_url: "https://docs.google.com/spreadsheets/d/..."
sheet_gid: 123456
last_sync: "2026-07-11T15:30:00"
chapters_total: 45
chapters_done: 12
priority: "URGENTE"
---
```

**Dashboard** (`index.md`): Dataview queries para progreso, filtros, stats.

## Setup inicial (uno-time)

1. Google Cloud Console → Service Account → descargar JSON
2. Compartir cada hoja con el email del service account (Viewer)
3. `pip install google-api-python-client google-auth pyyaml`
4. Crear `config.yaml` con URLs de las hojas
5. `scantracker-sync --dry-run` → verificar
6. Activar systemd timer

## Limitaciones
- Solo lectura (no escribe al Sheets)
- Sync cada 5 min (no real-time)
- Service account necesita share manual por hoja
- Dashboard es visibility, no reemplaza la app original

## Cronograma
- **Fase 1:** Setup Google Cloud + service account (~30 min)
- **Fase 2:** Script Python core (~2-3 horas)
- **Fase 3:** Templates DataviewJS + dashboard (~1-2 horas)
- **Fase 4:** systemd timer + testing (~30 min)
- **Total estimado:** ~4-6 horas
