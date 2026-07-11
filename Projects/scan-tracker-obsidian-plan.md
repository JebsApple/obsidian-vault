---
title: Scan Tracker → Obsidian (Plan C: Plugin Nativo)
tags:
  - proyecto
  - proyecto/scanlation
  - plan
  - scanlation
  - dataview
created: 2026-07-11
status: en-progreso
---

# Scan Tracker → Obsidian (Plan C: Plugin Nativo)

> Reemplaza el Plan B (script Python + systemd timer, solo lectura). Decisión 2026-07-11:
> el usuario quiere conexión viva, lectura Y escritura, seleccionando el sheet desde Drive
> dentro de Obsidian mismo — no un snapshot cada 5 min.

## Por qué plugin nativo y no MCP

El MCP de Google Drive ya conectado en Claude Code/Desktop solo lee/crea archivos — no tiene
API de Sheets para escritura de celdas. Un plugin nativo corre dentro de Obsidian (Electron,
Node completo disponible), no depende de que Claude esté abierto, y puede sincronizar en
segundo plano con `registerInterval`.

## Arquitectura

```
Obsidian Plugin (TypeScript)
├── OAuth2 Google (Client ID tipo "Desktop app")
│   └── servidor HTTP local (loopback) para capturar el redirect
├── Drive API v3 → listar spreadsheets del usuario (picker en Settings)
├── Sheets API v4 → values.get (pull) / values.update (push)
└── Sync engine
    ├── Pull: fila de sheet → nota markdown (una por capítulo o por serie, frontmatter)
    ├── Push: edición de frontmatter en nota → values.update de vuelta al sheet
    └── Conflict: last-write-wins por timestamp (v1, sin merge)
```

## Setup manual (usuario, no delegable)

1. Google Cloud Console → nuevo proyecto → habilitar **Sheets API** y **Drive API**
2. Crear credencial OAuth 2.0 → tipo **"Desktop app"** (no service account — necesitamos
   que el plugin actúe como el usuario, no como cuenta de servicio)
3. Copiar Client ID + Client Secret al Settings tab del plugin

## Archivos del plugin (`~/proyectos/scan-tracker-obsidian-plugin/`)

| Archivo | Propósito |
|---------|-----------|
| `manifest.json` | Metadata del plugin (id, versión, minAppVersion) |
| `package.json` / `esbuild.config.mjs` | Build TS → `main.js` |
| `src/main.ts` | Entry point: comandos, sync engine, registerInterval |
| `src/auth.ts` | OAuth2 flow (servidor loopback + token exchange + refresh) |
| `src/sheets-api.ts` | Wrappers `values.get` / `values.update` / Drive `files.list` |
| `src/settings.ts` | Settings tab: Client ID/Secret, picker de sheet, intervalo de sync |
| `src/sync.ts` | Pull/push entre filas del sheet y notas markdown |

Build output (`main.js`, `manifest.json`, `styles.css`) se copia/symlink a
`~/Vault/.obsidian/plugins/scan-tracker-sheets/`.

## Columnas del sheet (sin cambios del plan original)

| Col A | Col B | Col C | Col D | Col E | Col F | Col G | Col H | Col I | Col J | Col K | Col L |
|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|
| Capítulo | Prioridad | TRAD who | TRAD done | LIMP who | LIMP done | TYP who | TYP done | CORR who | CORR done | SUBE who | SUBE done |

## Nota generada por capítulo/serie

```yaml
---
tags: [manga/series, scanlation]
series: "One Piece"
spreadsheet_id: "..."
sheet_gid: 123456
row: 12
last_sync: "2026-07-11T15:30:00"
trad_who: "..."
trad_done: true
limp_who: "..."
limp_done: false
---
```

Editar el frontmatter en Obsidian y correr "Push a Sheets" (comando) escribe la fila de vuelta.

## Milestones

- [x] Decisión de arquitectura (plugin nativo vs MCP vs script) — 2026-07-11
- [ ] **M1:** Setup manual Google Cloud (usuario) — OAuth Client ID + APIs habilitadas
- [ ] **M2:** Scaffold plugin (manifest, build, esqueleto main.ts) — Claude
- [ ] **M3:** OAuth2 flow funcionando (login → token guardado) — Claude
- [ ] **M4:** Drive picker + Sheets read (pull → notas) — Claude
- [ ] **M5:** Sheets write (push desde nota) — Claude
- [ ] **M6:** Sync automático (`registerInterval`) + settings UI pulida — Claude
- [ ] **M7:** Testing con sheet real, dashboard Dataview — usuario + Claude

## Limitaciones conocidas

- Conflict resolution v1 es last-write-wins (sin merge de ediciones concurrentes)
- OAuth token vive en `data.json` del plugin (mismo nivel de seguridad que otros plugins
  con tokens — ej. copilot, smart-connections ya en este vault)
- Requiere que Obsidian esté abierto para sync automático (no es un daemon separado)
