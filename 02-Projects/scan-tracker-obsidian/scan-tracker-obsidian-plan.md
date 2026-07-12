---
aliases: [scan-tracker-plan]
tags: [project, plan, scanlation, obsidian-plugin]
created: 2026-07-12
status: superseded
---

> ⚠️ **Superseded 2026-07-12.** Plan canónico y actualizado: [[blueprint|Blueprints/blueprint.md]] (M0-M9 revisado por Opus, fixes G1/G2 ya aplicados a `sync.ts`/`main.ts`). Este archivo queda como snapshot histórico.

# Scan Tracker — Plan Completo (histórico, ver blueprint.md)

## Contexto

Plugin de Obsidian que sincroniza hojas de cálculo de Google Sheets (tracker de scanlation) con notas markdown del vault. Bidireccional: pull trae datos del sheet → notas, push manda notas → sheet.

**Stack:** TypeScript, Obsidian Plugin API, Google Sheets API v4, Google Drive API v3

**Repos:**
- Plugin: `~/proyectos/scan-tracker-obsidian-plugin/`
- Plugin instalado: `~/Vault/.obsidian/plugins/scan-tracker-sheets/`
- Proyecto Vault: `~/Vault/02-Projects/scan-tracker-obsidian/`

**Google Cloud:**
- Proyecto: `scan-tracker-502106`
- Client ID: `50665049250-ipcmj3jr7fakbmabk2tq32ea1nh3id1o.apps.googleusercontent.com`
- Test user: `mnznpremium756@gmail.com`

---

## Hojas de prueba

| Nombre | Sheet ID | Notas |
|--------|----------|-------|
| Sheet 1 | `173Tw9XhFooh5NKcJrmkEBJlL1WvkK51WyvPaSxw9BdE` | Usar para testing principal |
| Sheet 2 | `1mxRSrfmwVPVJKQqKwbIv68mGHqn3453iLCl-Grk0kD4` | Para edge cases (multi-sheet) |

---

## Estado actual

| Milestone | Estado | Notas |
|-----------|--------|-------|
| M1: Google Cloud setup | ✅ | Proyecto, OAuth credentials, test user |
| M2: Scaffold plugin | ✅ | esbuild, manifest, estructura src/ |
| M3: OAuth2 loopback | ✅ | `auth.ts` — local server + browser redirect |
| M4: Sheets API read | ✅ | `sheets-api.ts` — getValues, listSpreadsheets |
| M5: Push to Sheets | ✅ | `sheets-api.ts` — updateValues |
| M6: Auto-sync + settings | ✅ | `settings.ts` — UI para series, intervalo |
| M7: Testing con sheet real | 📋 | **Siguiente paso** |
| M8: Conflict detection | ⏳ | Post-M7 |
| M9: Multi-hoja robusto | ⏳ | Post-M7 |

---

## M7: Testing con sheet real

**Objetivo:** Validar que el plugin funciona end-to-end con sheets reales del Drive.

### Pre-requisitos

1. Copiar `~/Vault/.obsidian/plugins/scan-tracker-sheets/` (si no existe, buildear con `npm run build`)
2. Abrir Obsidian → Settings → Community Plugins → habilitar "Scan Tracker Sheets Sync"
3. Configurar:
   - Client ID: `50665049250-ipcmj3jr7fakbmabk2tq32ea1nh3id1o.apps.googleusercontent.com`
   - Client Secret: (obtener de Google Cloud Console)
4. Hacer login con Google (botón "Login")

### Escenarios de testing

#### Escenario 1: Pull básico

- Configurar una serie en Settings con:
  - Spreadsheet ID: `173Tw9XhFooh5NKcJrmkEBJlL1WvkK51WyvPaSxw9BdE`
  - Rango: `Hoja1!A2:L1000` (ajustar según la hoja real)
  - Carpeta: `Scanlation/Test`
- Ejecutar comando "Pull: traer todas las series desde Sheets"
- **Verificar:** Se crean notas en `Scanlation/Test/` con frontmatter correcto
- **Verificar:** Cada nota tiene `spreadsheet_id`, `sheet_name`, `row`, `last_sync`

#### Escenario 2: Push básico

- Abrir una nota generada por el pull
- Modificar un campo (ej: `trad_done: true`)
- Ejecutar comando "Push: mandar esta nota de vuelta al Sheet"
- **Verificar:** El valor se actualiza en Google Sheets
- **Verificar:** `last_sync` se actualiza en la nota

#### Escenario 3: Bidireccional

- Modificar un valor directamente en Google Sheets
- Ejecutar pull
- **Verificar:** La nota se actualiza con el nuevo valor
- Modificar otro valor en la nota
- Ejecutar push
- **Verificar:** El sheet se actualiza

#### Escenario 4: Auto-sync

- Configurar auto-sync en 1 minuto
- Modificar un valor en el sheet
- Esperar 1 minuto
- **Verificar:** La nota se actualiza automáticamente

### Criterios de aceptación

- [ ] Pull crea notas con frontmatter completo
- [ ] Push actualiza el sheet correctamente
- [ ] Bidireccional funciona sin perder datos
- [ ] Auto-sync dispara pull en el intervalo configurado
- [ ] Errores de red muestran Notice en Obsidian
- [ ] Token refresh funciona cuando el token expira

### Errores esperados y fixes

| Error probable | Causa | Fix |
|----------------|-------|-----|
| `403 Forbidden` | Scopes insuficientes o sheet no compartida | Compartir sheet con el email del test user |
| `404 Not Found` | Sheet ID o rango incorrecto | Verificar ID y rango en Settings |
| `Token expired` | Refresh token no guardado | Verificar que `tokens.refresh_token` se persiste |
| Notes vacías | Rango no incluye datos | Ajustar rango en Settings |

---

## M8: Conflict detection (post-M7)

**Objetivo:** Detectar cuando una nota y su fila en el sheet fueron modificados desde la última sync.

### Comportamiento

1. En cada pull, guardar `last_sync` en frontmatter
2. En cada push, comparar `last_sync` con el timestamp de la última modificación del sheet
3. Si hay conflicto: ** Sheets wins **, pero mostrar Notice en Obsidian: `"Conflicto en [nombre]: el sheet tiene cambios más recientes. Tu modificación no se subió."`

### Implementación mínima

- Agregar campo `last_sync` al frontmatter (ya existe)
- Antes de push, hacer un getValues para esa fila y comparar `last_sync`
- Si el sheet fue modificado después de `last_sync`, abortar push con Notice

---

## M9: Multi-hoja robusto (post-M7)

**Objetivo:** Soportar múltiples hojas en un mismo spreadsheet (tabs diferentes).

### Implementación

- El campo `range` ya soporta formato `Hoja1!A2:L1000`
- Verificar que `sheet_name` se extrae correctamente de `rangeSheetName()`
- Testing con la segunda sheet (`1mxRSrfmwVPVJKQqKwbIv68mGHqn3453iLCl-Grk0kD4`)

---

## Proyecto separado: scan-tracker-app

**Estado:** No iniciado. Plan por separado.

**Alcance futuro:**
- Web app (dashboard) que se conecta a las mismas Google Sheets
- Visualizar todas las series y capítulos
- Filtrar por urgencia/prioridad
- Dashboard de status de series
- Notificaciones / conexión a calendario para asignación de capítulos
- Escalabilidad: desktop (Electron) y mobile (React Native) en futuro lejano

**Relación con el plugin:**
- Comparten Google Sheets como fuente de datos
- Código separado, proyectos independientes
- El plugin complementa la app ( Obsidian ↔ Sheets )
- La app complementa el plugin ( Web UI ↔ Sheets )

---

## Archivos clave del plugin

| Archivo | Función |
|---------|---------|
| `src/main.ts` | Entry point, comandos, auto-sync |
| `src/auth.ts` | OAuth2 loopback flow |
| `src/sheets-api.ts` | Google Sheets + Drive API |
| `src/sync.ts` | Lógica pull/push, mapeo columnas↔frontmatter |
| `src/settings.ts` | UI de settings, configuración de series |
| `esbuild.config.mjs` | Build config |
| `manifest.json` | Metadata del plugin Obsidian |

### Estructura de columnas del sheet (COLUMNS en sync.ts)

```
capitulo | prioridad | trad_who | trad_done | limp_who | limp_done | typ_who | typ_done | corr_who | corr_done | sube_who | sube_done
```
