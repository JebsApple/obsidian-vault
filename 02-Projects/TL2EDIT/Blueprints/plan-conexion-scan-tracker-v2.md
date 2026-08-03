<!-- fold(tema="tl2edit", lineas=380, leer_si="trabajando en integración TL2EDIT/Scan-Tracker") -->
---
aliases: [conexion-tl2edit-scantracker, plan-integracion-scan-tracker-v2]
tags: [project, plan, tl2edit, scan-tracker, integracion, comics, scanlation]
created: 2026-07-28
updated: 2026-07-31
status: implementado-en-v4.6.3
related:
  - "[[plan-conexion-scan-tracker]]"
  - "[[tl2edit-blueprint]]"
  - "[[scan-tracker-web-blueprint]]"
---

# Plan — Conexión TL2EDIT ↔ Scan Tracker (v2, adaptado a v3.14.8)

> Actualización del plan original para la arquitectura actual de TL2EDIT:
> el sistema de series ahora usa `Series` + `SeriesProvider` (contexto),
> `config/series.ts` y `SeriesPanel.tsx` con tabs. El plan v1 referenciaba
> `SeriesStyleSet`, `useSeriesSets` (store módulo) y `SeriesSetsPanel` — todo
> reemplazado. El contrato de la hoja es el MISMO que scan-tracker-web.

---

## Decisión de arquitectura (sin cambios vs v1)

**Contrato = hoja de Google Sheets, NO Firestore.** TL2EDIT ya tiene OAuth de
Google con refresh token (`useGoogleAuth.ts`); se agrega el scope
`spreadsheets` y se lee/escribe la hoja directo. No se instala `firebase`.
El usuario pega la URL de la hoja una vez por serie.

## Contrato de la hoja (sin cambios — replicar de scan-tracker-web)

| Columna | Contenido |
|---------|-----------|
| A | `num` (capítulo, string) |
| B | `prio` (string mayúsculas) |
| C/D, E/F, G/H, I/J, K/L | etapas 1-5: `who` / `done` |

Claves posicionales: `trad/limp/typ/corr/sube` por posición, no por nombre.
`done` true solo si `"TRUE"` (trim + upper). Fila A vacía = se salta.
`srcRow` 1-based. Encabezado en primeras 3 filas (`/^cap/i`); sin él, datos en fila 0.
Rango `'<titulo>'!A1:L1000`, comillas simples duplicadas.

---

## Fase 1 — Modelo y persistencia

### 1.1 `src/types.ts` — extender `Series`

Agregar **antes** de `export interface Series` (línea ~261):

```ts
/** Vínculo de una serie con su hoja de seguimiento en Scan Tracker. */
export interface ScanTrackerLink {
  sheetUrl: string;
  sheetTitle?: string;
  gid?: number;
  alias?: string;
  lastSyncAt?: number;
}
export const MAX_SCAN_TRACKER_ALIAS_LEN = 60;
```

Dentro de `Series`, después de `useContextInPrompt` y antes de `updatedAt`:

```ts
  /** Ausente = serie sin vincular a Scan Tracker. */
  scanTracker?: ScanTrackerLink;
```

### 1.2 `src/config/series.ts` — sanitizar

La config actual solo tiene `sanitizeText` (no `sanitizeOptionalText`).
Agregar un helper de texto opcional y el sanitizador del vínculo:

```ts
function sanitizeOptionalText(value: unknown, maxLen: number): string | undefined {
  if (value === undefined) return undefined;
  const cleaned = sanitizeText(value, maxLen);
  return cleaned.length > 0 ? cleaned : undefined;
}

function sanitizeScanTrackerLink(raw: unknown): ScanTrackerLink | undefined {
  if (!raw || typeof raw !== 'object') return undefined;
  const l = raw as Partial<ScanTrackerLink>;
  const sheetUrl = sanitizeText(l.sheetUrl, 500).trim();
  if (!/^https:\/\/docs\.google\.com\/spreadsheets\/d\/[\w-]+/.test(sheetUrl)) return undefined;
  return {
    sheetUrl,
    sheetTitle: sanitizeOptionalText(l.sheetTitle, 200),
    gid: typeof l.gid === 'number' && Number.isFinite(l.gid) && l.gid >= 0 ? l.gid : undefined,
    alias: sanitizeOptionalText(l.alias, MAX_SCAN_TRACKER_ALIAS_LEN),
    lastSyncAt: typeof l.lastSyncAt === 'number' && Number.isFinite(l.lastSyncAt) ? l.lastSyncAt : undefined,
  };
}
```

En `sanitizeSeries`, agregar `const scanTracker = sanitizeScanTrackerLink(r.scanTracker);`
y sumarlo al return (retrocompatible: ausente = sin vínculo).

### 1.3 Tests — `src/config/series.test.ts` (crear si no existe)

Los tests actuales de series están en `src/components/SeriesPanel.test.tsx` y
`SeriesSwitcher.test.tsx` (no hay test de config). Crear `src/config/series.test.ts`:
- URL no-Google Sheets → `scanTracker` descartado
- URL válida + alias de 200 chars → alias recortado a 60
- set sin `scanTracker` → carga sin romper (retrocompatibilidad)
- gid negativo o no numérico → descartado

**Aceptación:** `npx tsc --noEmit && npx vitest run src/config/series.test.ts`

---

## Fase 2 — Lectura de la hoja

### 2.1 Scope de OAuth — `src/hooks/useGoogleAuth.ts`

En `DRIVE_SCOPES` (línea ~6), agregar antes del `.join(' ')`:
```ts
  // spreadsheets: leer y marcar etapas en la hoja de seguimiento de Scan Tracker.
  'https://www.googleapis.com/auth/spreadsheets',
```
⚠️ Invalida el consentimiento previo (popup de Google una vez más). Esperado.

### 2.2 Archivo nuevo — `src/lib/scanTrackerSheet.ts`

Puerto TypeScript de `sheets-api.js` + `etapas-service.js` de scan-tracker-web.
Duplicado a propósito (proyectos independientes, mismo contrato).

Constantes y tipos (igual que v1): `ETAPA_KEYS`, `COLW`, `ETAPAS_DEFAULT`,
`EtapaEstado`, `ScanTrackerChapter`, `ScanTrackerSheet`.

Funciones exportadas (mismas firmas que v1): `spreadsheetIdFromUrl`,
`gidFromUrl`, `detectEtapaDefs`, `parseChapters`, `readScanTrackerSheet`,
`markEtapa`.

**Helper `sheetsFetch`**: replicar `driveFetch` de `src/lib/drive/api.ts:7`
(misma autenticación y manejo de error). Ya no es `googleDrive.ts:31` — el
refactor E3.1 movió `driveFetch` a `src/lib/drive/api.ts`.

### 2.3 Tests — `src/lib/scanTrackerSheet.test.ts`

Solo funciones puras (patrón `imageBlockGeometry.test.ts`):
- `spreadsheetIdFromUrl`: válida con/sin `#gid=`, basura → null
- `gidFromUrl`: `#gid=123`, `?gid=0`, sin gid → null
- `detectEtapaDefs`: 5 etapas, 3 etapas, vacío → default
- `parseChapters`: encabezado en filas 0/1/2, sin encabezado, fila A vacía se
  salta, `done` solo con TRUE (case-insensitive), `srcRow` 1-based correcto

**Aceptación:** `npx tsc --noEmit && npx vitest run src/lib/scanTrackerSheet.test.ts`

---

## Fase 3 — UI de vinculación

### 3.1 `src/components/SeriesPanel.tsx` — sección en el tab General

El panel actual tiene tabs **General / Estilos / Personajes**. La sección de
Scan Tracker va **al final del tab General** (donde ya están nombre y contexto),
como componente nuevo:

`src/components/ScanTrackerSection.tsx`, con props explícitas (sin estado global):

```tsx
interface ScanTrackerSectionProps {
  link: ScanTrackerLink | undefined;
  onLink: (sheetUrl: string) => void;
  onUnlink: () => void;
  onAliasChange: (alias: string) => void;
}
```

- Sin link: input + botón "Vincular hoja". Validar con la misma regex del
  sanitizer; error inline "Pega la URL completa de la hoja de Google".
- Con link: URL truncada, `sheetTitle` si existe, input de alias, "Desvincular".
- Estilo: clases del design system (`btn`, `btn-secondary`, `card`,
  `text-muted`) y variables CSS. Sin inline styles nuevos.

### 3.2 `src/hooks/useSeries.tsx` — métodos del contexto

Agregar a `SeriesContextValue` y al provider:

```ts
  setScanTrackerLink: (seriesId: string, sheetUrl: string) => void;
  removeScanTrackerLink: (seriesId: string) => void;
  setScanTrackerAlias: (seriesId: string, alias: string) => void;
  updateScanTrackerCache: (seriesId: string, patch: Pick<ScanTrackerLink, 'sheetTitle' | 'gid' | 'lastSyncAt'>) => void;
```

Implementar siguiendo el patrón de `updateContext` / `toggleUseContext`
(mutar `seriesList` con setState funcional, `touch()` para updatedAt, y el
`useEffect` que persiste ya cubre localStorage).

`setScanTrackerLink` reinicia cache de título/gid (`{ sheetUrl, lastSyncAt: undefined }`).

**Aceptación:** `npx tsc --noEmit && npx vitest run`
Manual: crear serie, pegar URL real, recargar, confirmar que persiste.

---

## Fase 4 — Panel de capítulos (solo lectura)

### 4.1 `src/hooks/useScanTrackerChapters.ts` (nuevo)

```ts
export function useScanTrackerChapters(
  link: ScanTrackerLink | undefined,
  accessToken: string | null,
): { chapters: ScanTrackerChapter[]; etapaDefs: [EtapaKey, string][]; loading: boolean; error: string | null; refresh: () => void }
```

- Link o token nulos → estado vacío, sin request.
- `AbortController` abortado en cleanup (patrón `useOCR.ts`).
- Al éxito, `updateScanTrackerCache` con title/gid/lastSyncAt.
- Error como string legible, no se lanza.

### 4.2 UI en `ScanTrackerSection.tsx`

Con vínculo, listar capítulos: número, prioridad, chip por etapa (nombre visible
de `etapaDefs`) coloreado por `done`. Botón "Actualizar" → `refresh()`.

**Aceptación:** con hoja real, el panel muestra los mismos valores que
scan-tracker-web abierto en paralelo.

---

## Fase 5 — Escritura de vuelta

### 5.1 Marcar etapa

Chips clickeables: alternan `done` y escriben `alias` en `who` vía
`markEtapa(accessToken, link, ch.srcRow, etapaKey, alias, !done)`.

**Patrón obligatorio** (de `sync-service.js:pushCell`): mutar estado local
primero, **revertir si la escritura falla**, mostrar error con el toast existente
(`setGlobalError`).

### 5.2 Gancho opcional en exportación

En `src/hooks/useExport.ts`, tras export exitoso a Drive de una serie vinculada
con alias, ofrecer (no auto) marcar `typ` del capítulo. Toast con acción.
Si el capítulo activo no se puede determinar, **omitir esta sub-fase**.

**Aceptación:** marcar desde TL2EDIT y verlo en scan-tracker-web tras sync.
Cortar red a mitad → chip revierte + error.

---

## Fuera de alcance (sin cambios vs v1)

- No instalar SDK de Firebase en TL2EDIT.
- No leer el catálogo `series/{id}` de Firestore (descubrimiento automático
  queda para iteración futura; URL se pega a mano).
- No tocar el repo `scan-tracker-web` (integración de un solo lado).
- No crear capítulos ni filas nuevas desde TL2EDIT (solo lectura + marcar etapas).

---

## Convenciones de trabajo

- **Rama**: `feature/conexion-scan-tracker` (ya creada desde main v3.14.8).
- **Commits**: uno por fase, español, `feat:` / `fix:` / `test:`. Sin co-autoría.
- **PR**: uno solo al final contra `main`. No mergear directo.
- Cada fase deja `npx tsc --noEmit` limpio y `npx vitest run` en verde.
- Comentarios en español, explicando el porqué (densidad de `config/series.ts`).
- Los tests nuevos siguen la infraestructura actual: jsdom + Testing Library
  para componentes, `// @vitest-environment jsdom` en `.test.tsx`.

---

## Referencias de código (actualizadas)

| Qué | Dónde (v3.14.8) |
|---|---|
| Contrato de columnas y parseo | `~/proyectos/scan-tracker-web/src/services/etapas-service.js` |
| Mapa `COLW` y rollback | `~/proyectos/scan-tracker-web/src/services/sync-service.js` |
| Llamados REST a Sheets API | `~/proyectos/scan-tracker-web/src/repositories/sheets-api.js` |
| Patrón de fetch autenticado | `~/proyectos/TL2EDIT/src/lib/drive/api.ts:7` (`driveFetch`) |
| OAuth y access_token | `~/proyectos/TL2EDIT/src/hooks/useGoogleAuth.ts` |
| Modelo de series (persistencia) | `~/proyectos/TL2EDIT/src/config/series.ts` + `src/types.ts:261` |
| Hook de series (contexto) | `~/proyectos/TL2EDIT/src/hooks/useSeries.tsx` |
| Panel de series (UI, tabs) | `~/proyectos/TL2EDIT/src/components/SeriesPanel.tsx` |

---

## Actualización 2026-07-31 — implementado en v4.6.3 (PR de `feature/conexion-scan-tracker-v2`)

> Cambios de alcance respecto al plan original, aplicados durante la implementación
> y confirmados por el usuario. Este bloque documenta el estado final para que sirva
> de fuente de verdad en lugar del plan original donde difieran.

### Cambios de alcance (vs. "Fuera de alcance" del plan)

| Original (plan) | Realidad (v4.6.3) |
|---|---|
| No instalar SDK de Firebase en TL2EDIT | **Sí se instaló** (`firebase@12`). Se usa para autenticar contra el proyecto `scan-tracker-5ef75` (canje del access_token de Google por sesión de Firebase Auth, mismo patrón que scan-tracker-web) y leer el perfil del usuario. |
| No leer el catálogo compartido `series/{id}` de Firestore | Se **intentó** (commit 33fc384) y luego se **descartó**: la fuente de series pasó a ser **`users/{uid}.series`** (las series que el usuario registró en scan-tracker-web con hoja vinculada). `listScanTrackerCatalog` se eliminó en la auditoría (sin uso). |
| No tocar scan-tracker-web | Se tocó una vez: **PR #7** de scan-tracker-web abrió la lectura de `users/{uid}` (alias + series) y `series/*` en `firestore.rules` (la integración la necesita). |
| No crear capítulos ni filas nuevas desde TL2EDIT | Se mantiene: TL2EDIT solo **lee** capítulos y **marca etapas** (who/done), nunca crea filas. |

### Decisiones de UX finales (difieren del plan)

- **Apodo**: NO se configura a mano (el plan lo dejaba como input). Se **detecta automáticamente** cruzando los alias del perfil de Scan Tracker ("Mis nombres", `users/{uid}.aliases`) con los "quién" de la hoja de cada serie. Si ninguno coincide → "Ningún apodo coincide con esta serie" y el marcado queda deshabilitado.
- **Modal "Agregar serie"**: muestra **las series del usuario** (de su perfil, con hoja) con botón Agregar (marca "Agregada" si ya existe). El camino manual queda colapsado en segundo plano.
- **Avance de capítulos**: solo los capítulos donde aparece el apodo del usuario, en filas/tarjetas con sus etapas (las ajenas se ven como "—"). Toggle **"Ocultar listos"** activo por defecto (listo = sin etapas tuyas pendientes).
- **Capítulo activo**: se elige tocando la fila del capítulo (toggle). Al seleccionar una serie, si no había capítulo activo se deja el primer capítulo pendiente de traducción del usuario.
- **Título del trabajo**: al seleccionar una serie vinculada → `"Serie - Cap N"` (primer capítulo en Traducción asignado al usuario y sin marcar); sin pendientes → solo el nombre de la serie.
- **Export a Drive**: el selector de carpeta permite **editar el nombre** antes de guardar (también en Google Docs). Los nombres default van **sin extensión** (los handlers la agregan al crear el archivo).

### Fases del plan → estado real

1. Modelo y persistencia (`ScanTrackerLink` en `Series`, sanitize) ✅
2. Lectura de la hoja (`scanTrackerSheet.ts`, scope `spreadsheets` + `prompt=consent`) ✅
3. UI de vinculación (`ScanTrackerSection`, métodos en `useSeries.tsx`) ✅
4. Panel de capítulos ✅ (evolucionó: grilla personal → tarjetas con filtro "ocultar listos")
5. Escritura de vuelta ✅ (marcar etapas con rollback + gancho "Typeo" al exportar)

### Archivos clave del estado final

- `src/lib/scanTrackerCatalog.ts` — Firebase Auth + `getMyScanTrackerSeries` / `getMyScanTrackerAliases`
- `src/lib/scanTrackerSheet.ts` — contrato de la hoja, lectura, `markEtapa`, `detectAliasFromChapters`, `findNextTradChapter`
- `src/hooks/useScanTrackerSeries.ts`, `useScanTrackerChapters.ts`, `useMyScanTrackerAliases.ts`
- `src/components/CreateSeriesModal.tsx`, `ScanTrackerSection.tsx`, `DriveFolderPicker.tsx` (nombre editable)
- `src/App.tsx` — efecto de título automático por serie + gancho de auto-marcado "Typeo"
