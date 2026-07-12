---
aliases: [scan-tracker-plan]
tags: [project, plan, scanlation, obsidian-plugin]
created: 2026-07-12
status: activo
---

# Scan Tracker — Plan Completo

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

## Fase 7: Testing con sheet real

**Objetivo:** Validar que el plugin funciona end-to-end con sheets reales del Drive.

### Step 7.1: Build + install plugin
- **Archivos:** `~/proyectos/scan-tracker-obsidian-plugin/`, `~/Vault/.obsidian/plugins/scan-tracker-sheets/`
- **Verificación:** `npm run build` sin errores, carpeta del plugin actualizada en Vault
- **Modelo sugerido:** Haiku

### Step 7.2: Configurar plugin en Obsidian
- **Archivos:** Settings del plugin en Obsidian
- **Verificación:** Login con Google funciona, hojas del Drive aparecen en dropdown
- **Modelo sugerido:** Haiku (manual, solo instrucciones)

### Step 7.3: Test pull básico
- **Archivos:** `src/sync.ts`, `src/main.ts`
- **Verificar:** Notas creadas en `Scanlation/Test/` con frontmatter completo (`spreadsheet_id`, `sheet_name`, `row`, `last_sync`)
- **Modelo sugerido:** Sonnet

### Step 7.4: Test push básico
- **Archivos:** `src/sync.ts`
- **Verificar:** Modificar `trad_done: true` en nota → push → valor actualizado en Google Sheets
- **Modelo sugerido:** Sonnet

### Step 7.5: Test bidireccional
- **Archivos:** `src/sync.ts`
- **Verificar:** Modificar sheet → pull → nota actualizada → modificar nota → push → sheet actualizado
- **Modelo sugerido:** Sonnet

### Step 7.6: Test auto-sync
- **Archivos:** `src/main.ts`
- **Verificar:** Configurar intervalo 1 min → modificar sheet → esperar → nota se actualiza automáticamente
- **Modelo sugerido:** Haiku

---

## Fase 8: Conflict detection

**Objetivo:** Detectar cuando una nota y su fila en el sheet fueron modificados desde la última sync.

### Step 8.1: Comparar timestamps antes de push
- **Archivos:** `src/sync.ts`
- **Verificar:** Antes de push, hacer getValues para esa fila y comparar `last_sync` con timestamp del sheet
- **Modelo sugerido:** Sonnet

### Step 8.2: Notice en conflicto
- **Archivos:** `src/sync.ts`
- **Verificar:** Si el sheet fue modificado después de `last_sync`, abortar push con Notice: `"Conflicto en [nombre]: el sheet tiene cambios más recientes. Tu modificación no se subió."`
- **Modelo sugerido:** Sonnet

---

## Fase 9: Multi-hoja robusto

**Objetivo:** Soportar múltiples hojas en un mismo spreadsheet (tabs diferentes).

### Step 9.1: Verificar extracción de sheet_name
- **Archivos:** `src/sheets-api.ts`
- **Verificar:** `rangeSheetName()` extrae correctamente el nombre de la hoja del rango
- **Modelo sugerido:** Haiku

### Step 9.2: Testing con segunda sheet
- **Archivos:** `src/settings.ts`
- **Verificar:** Configurar serie con Sheet 2 (`1mxRSrfmwVPVJKQqKwbIv68mGHqn3453iLCl-Grk0kD4`), pull + push funcionan
- **Modelo sugerido:** Haiku

---

## Criterios de aceptación globales

- [ ] Pull crea notas con frontmatter completo
- [ ] Push actualiza el sheet correctamente
- [ ] Bidireccional funciona sin perder datos
- [ ] Auto-sync dispara pull en el intervalo configurado
- [ ] Errores de red muestran Notice en Obsidian
- [ ] Token refresh funciona cuando el token expira
- [ ] Conflicto detectado y notificado al usuario
- [ ] Múltiples hojas en un spreadsheet funcionan

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
