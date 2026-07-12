---
tags: [scanlation, obsidian-plugin, google-sheets, plan]
created: 2026-07-11
status: en-progreso
---

# Scan Tracker → Obsidian (Plan C: Plugin Nativo)

> Reemplaza el Plan B (script Python + systemd timer, solo lectura).
> El usuario quiere conexión viva, lectura Y escritura, seleccionando el sheet desde Drive dentro de Obsidian mismo.

## Por qué plugin nativo y no MCP

El MCP de Google Drive solo lee/crea archivos — no tiene API de Sheets para escritura de celdas. Un plugin nativo corre dentro de Obsidian (Electron, Node completo), no depende de que Claude esté abierto.

## Arquitectura

```
Obsidian Plugin (TypeScript)
├── OAuth2 Google (Client ID tipo "Desktop app")
│   └── servidor HTTP local (loopback) para capturar el redirect
├── Drive API v3 → listar spreadsheets del usuario (picker en Settings)
├── Sheets API v4 → values.get (pull) / values.update (push)
└── Sync engine
    ├── Pull: fila de sheet → nota markdown (frontmatter)
    ├── Push: edición de frontmatter → values.update
    └── Conflict: last-write-wins por timestamp
```

## Columnas del sheet

| Capítulo | Prioridad | TRAD who | TRAD done | LIMP who | LIMP done | TYP who | TYP done | CORR who | CORR done | SUBE who | SUBE done |
|----------|-----------|----------|-----------|----------|-----------|---------|----------|----------|-----------|----------|-----------|

## Para probar (próxima sesión)
1. Abrir Obsidian
2. Settings → Scan Tracker Sheets Sync → Login
3. Autorizar con `mnznpremium756@gmail.com`
4. Seleccionar sheet → "Pull: traer todas las series"

## Limitaciones
- Conflict resolution v1: last-write-wins
- OAuth token en `data.json` del plugin
- Requiere Obsidian abierto para sync automático
