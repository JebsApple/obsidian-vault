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
| M0: Preflight | ✅ | Build verificado, tokens OK (2026-07-12) |
| G1: Fix rango sin nombre de hoja | ✅ | `sync.ts` — `rangeSheetName`/`rangeStartRow` lanzan error en vez de desfasar fila silenciosamente (2026-07-12) |
| G2: Fix pull pisa ediciones locales | ✅ | `sync.ts` — `sync_baseline` (hash) detecta edición local sin pushear, aborta overwrite y reporta conflicto (2026-07-12) |
| M7: Testing con sheet real | 📋 | **Siguiente paso** |
| M8: Conflict detection | ✅ (base) | Implementado como parte de G2 — falta 8.3/8.4 (Drive modifiedTime, proteger push) |
| M9: Multi-hoja robusto | ⏳ | Post-M7 — falta comillas en notación A1 para tabs con espacios |

> Análisis completo (Opus, 2026-07-12): revisión línea por línea de `auth.ts/main.ts/sheets-api.ts/settings.ts/sync.ts` encontró 9 gaps (G1-G9) no cubiertos por el plan original de M7-M9. G1 y G2 eran bloqueantes (corrupción/pérdida de datos) y ya están arreglados en código. El resto queda documentado abajo como parte del testing.

---

## Fase 0: Preflight (~5 min)

**Objetivo:** garantizar que build y sesión están sanos antes de testear lógica.

### Step 0.1: Build + symlink
- **Archivos:** `~/proyectos/scan-tracker-obsidian-plugin/`
- **Verificación:** `npm run build` sin errores; `~/Vault/.obsidian/plugins/scan-tracker-sheets/main.js` apunta al repo (symlink) con mtime del build
- **Estado:** ✅ verificado 2026-07-12

### Step 0.2: Verificar sesión
- **Archivos:** `~/Vault/.obsidian/plugins/scan-tracker-sheets/data.json`
- **Verificación:** `tokens.refresh_token` presente; un Pull no debe pedir re-login aunque `access_token` esté vencido
- **Estado:** ✅ `refresh_token` presente

---

## Fase 7: Testing con sheet real (revisado)

**Objetivo:** validar caminos felices Y de fallo con sheets reales.

### Step 7.1: Pull básico (camino feliz)
- **Archivos:** Settings del plugin
- **Config:** Sheet 1, rango **con nombre de hoja explícito** `Hoja1!A2:L1000`, carpeta `Scanlation/Test`
- **Verificar:** Notas creadas con `spreadsheet_id`, `sheet_name`, `row`, `last_sync`, `sync_baseline`; `row` coincide con la fila real del sheet (chequear 1 nota a mano)
- **Modelo sugerido:** Sonnet

### Step 7.2: [ex-BUG, ya fixeado] Rango sin nombre de hoja
- **Archivos:** `src/sync.ts`
- **Verificar:** Crear serie con rango `A2:L1000` (sin `Hoja1!`) → Pull debe fallar con Notice claro (`"rango ... no incluye el nombre de la hoja"`), NO debe crear notas con fila desfasada
- **Modelo sugerido:** Sonnet

### Step 7.3: Push básico
- **Archivos:** `src/sync.ts`
- **Verificar:** Editar `trad_done: true` en una nota → Push → celda correcta actualizada en el sheet (verificar fila); `last_sync`/`sync_baseline` actualizados; ninguna otra fila tocada
- **Modelo sugerido:** Sonnet

### Step 7.4: [EDGE] Round-trip no degrada datos
- **Archivos:** `src/sync.ts`
- **Verificar:** Poner en el sheet una celda `SI` y otra `X` en columnas `*_done`; pull; push sin tocar esas celdas → documentar que hoy `SI`/`X` se normalizan a `TRUE` tras el push (comportamiento conocido, no bloqueante)
- **Modelo sugerido:** Sonnet

### Step 7.5: [EDGE] Colisión de capítulos
- **Archivos:** `src/sync.ts`
- **Verificar:** Sheet con dos filas de mismo `capitulo` (o dos series → misma carpeta) → confirmar si una nota pisa a la otra; si sí, agregar sufijo de `row` al filename antes de M9
- **Modelo sugerido:** Sonnet

### Step 7.6: Bidireccional + conflicto (valida el fix de G2)
- (a) Editar en sheet → pull → nota refleja el cambio
- (b) Editar nota SIN push → ejecutar pull → **verificar que la edición local NO se pierde** y que el Pull reporta el conflicto por Notice (`"con edición local sin pushear, no se pisaron: ..."`)
- **Archivos:** `src/sync.ts`
- **Modelo sugerido:** Sonnet

### Step 7.7: Auto-sync
- **Archivos:** `src/main.ts`
- **Verificar:** `autoSyncMinutes = 1`; editar sheet; esperar; nota se actualiza sola. Confirmar que una edición local no pusheada sobrevive al ciclo de auto-sync (gracias a G2)
- **Modelo sugerido:** Haiku

### Step 7.8: [EDGE] Errores de API
- **Archivos:** `src/sheets-api.ts`
- **Verificar:** Provocar 403 (sheet no compartida), 404 (ID malo) → Notice claro. Documentar que 429 (rate limit) no tiene retry/backoff todavía — candidato a mejora futura, no bloqueante para M7
- **Modelo sugerido:** Sonnet

### Criterios de aceptación M7
- [ ] Pull mapea `row` correctamente y rechaza rangos sin nombre de hoja (7.2)
- [ ] Push escribe la fila correcta, sin efectos colaterales
- [ ] Round-trip de booleanos documentado/aceptado
- [ ] Colisión de nombres resuelta o documentada
- [ ] Edición local no pusheada sobrevive a pull/auto-sync y se reporta como conflicto (7.6)
- [ ] 403/404 con feedback claro

---

## Fase 8: Conflict detection — implementado por contenido, no por timestamp

**Nota técnica:** el plan original asumía comparar `last_sync` contra "timestamp de modificación del sheet". **No es viable**: la Sheets Values API no expone timestamp por fila, y `last_sync` se reescribe en cada pull/push (comparar contra sí mismo no detecta nada). Se implementó en su lugar detección **por contenido**: `sync_baseline` = hash de los 12 valores de la fila al momento del pull; si al pull siguiente el hash local difiere del baseline, hubo edición local sin push → no se pisa.

| Step | Estado | Detalle |
|------|--------|---------|
| 8.1: Guardar baseline en pull | ✅ | `sync.ts:writeNote` — `sync_baseline` en cada nota pulleada |
| 8.2: Detectar conflicto en pull | ✅ | `sync.ts:writeNote` compara hash local vs `sync_baseline` antes de pisar |
| 8.3: Pre-check barato con Drive `modifiedTime` | ⏳ | Opcional — usar scope `drive.readonly` ya concedido para saltar chequeos si el spreadsheet no cambió. No bloqueante |
| 8.4: Push también valida conflicto | ⏳ | Hoy push no re-lee la fila antes de escribir. Si el sheet cambió entre pull y push, push pisa el sheet sin avisar. Pendiente: `getValues` de la fila antes de `updateValues`, comparar contra `sync_baseline`, abortar si difiere |

---

## Fase 9: Multi-hoja robusto (ampliado)

**Objetivo:** soportar múltiples hojas en un mismo spreadsheet (tabs diferentes).

### Step 9.1: Comillas en notación A1
- **Archivos:** `src/sync.ts` (`rangeSheetName`, construcción de `range` en `pushNote`)
- **Verificar:** tab con espacios/acentos (ej. `'Mi Hoja'!A2:L1000`) — hoy `rangeSheetName` toma todo antes del `!` tal cual y `pushNote` reconstruye `${fm.sheet_name}!...` sin re-citar. Agregar citado consistente en lectura y escritura
- **Modelo sugerido:** Sonnet

### Step 9.2: Testing con Sheet 2 (múltiples tabs)
- **Archivos:** `src/settings.ts`
- **Verificar:** Configurar serie con Sheet 2 (`1mxRSrfmwVPVJKQqKwbIv68mGHqn3453iLCl-Grk0kD4`), pull + push funcionan sin cruzar datos entre tabs
- **Modelo sugerido:** Haiku

### Step 9.3: Carpetas separadas por serie
- **Archivos:** Settings del plugin
- **Verificar:** cada serie usa carpeta propia para no colisionar nombres de capítulo entre series (evita el caso de 7.5)
- **Modelo sugerido:** Haiku

---

## Orden de ejecución realista

M0 (✅) → G1/G2 (✅) → 7.1 → 7.2 → 7.3 → 7.4/7.5 (paralelizables) → 7.6/7.7 → 7.8 → 8.3/8.4 → M9

## Criterios de aceptación globales

- [ ] Pull crea notas con frontmatter completo (incl. `sync_baseline`)
- [ ] Push actualiza el sheet correctamente
- [ ] Bidireccional funciona sin perder datos locales no pusheados
- [ ] Auto-sync dispara pull en el intervalo configurado sin pisar ediciones locales
- [ ] Errores de red muestran Notice en Obsidian
- [ ] Token refresh funciona cuando el token expira
- [ ] Conflicto detectado y notificado al usuario (pull→local ✅, push→sheet pendiente 8.4)
- [ ] Múltiples hojas en un spreadsheet funcionan (incl. tabs con espacios)

---

## Archivos clave del plugin

| Archivo | Función |
|---------|---------|
| `src/main.ts` | Entry point, comandos, auto-sync |
| `src/auth.ts` | OAuth2 loopback flow |
| `src/sheets-api.ts` | Google Sheets + Drive API |
| `src/sync.ts` | Lógica pull/push, mapeo columnas↔frontmatter, hash de conflicto |
| `src/settings.ts` | UI de settings, configuración de series |
| `esbuild.config.mjs` | Build config |
| `manifest.json` | Metadata del plugin Obsidian |

### Estructura de columnas del sheet (COLUMNS en sync.ts)

```
capitulo | prioridad | trad_who | trad_done | limp_who | limp_done | typ_who | typ_done | corr_who | corr_done | sube_who | sube_done
```

---

## Proyecto relacionado: scan-tracker-web

**Estado:** decidido — pivote de `scan-tracker-desktop` (idea original en GH, JavaFX, pausada jun 2026). Ver `~/Vault/02-Projects/scan-tracker-web/`.

**Por qué existe además del plugin:** el plugin es la herramienta personal (requiere Obsidian). El equipo de scanlation (traductor, limpiador, typesetter, corrector, subidor) no usa Obsidian y necesita algo sin instalación. Se descarta continuar en JavaFX (WebView obsoleto, requiere JDK+Maven, cero distribuible) y se pivota a **web estática con Google Identity Services**, reutilizando el HTML/JS ya escrito en `scan-tracker-desktop` y patrones de auth/Sheets API del plugin (TS).

**Relación:**
- Ambos comparten Google Sheets como fuente de datos — mismo contrato de columnas (`capitulo | prioridad | *_who | *_done` × 5 etapas)
- Código independiente, sin dependencias cruzadas
- El plugin es personal (Obsidian ↔ Sheets); la web es del equipo (browser ↔ Sheets)
