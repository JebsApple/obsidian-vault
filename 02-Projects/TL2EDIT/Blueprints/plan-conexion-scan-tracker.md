---
aliases: [conexion-tl2edit-scantracker, plan-integracion-scan-tracker]
tags: [project, plan, tl2edit, scan-tracker, integracion, comics, scanlation]
created: 2026-07-28
updated: 2026-07-28
status: listo-para-ejecutar
related:
  - "[[plan-v2-auditoria]]"
  - "[[tl2edit-blueprint]]"
  - "[[scan-tracker-web-blueprint]]"
---

# Plan — Conexión TL2EDIT ↔ Scan Tracker

> Plan de ejecución mecánica. Cada fase trae rutas exactas, firmas de función y
> criterios de aceptación verificables por comando. No requiere decisiones de
> diseño durante la implementación: ya están tomadas y justificadas abajo.

---

## Decisión de arquitectura (ya tomada — no re-evaluar)

**El contrato de integración es la hoja de Google Sheets, NO Firestore.**

Razón: scan-tracker-web usa Firestore (`series/{id}`) únicamente como *directorio*
— mapea un rol de Discord a una URL de hoja. La fuente de verdad real de los
capítulos y su progreso es la hoja de Google. TL2EDIT ya tiene OAuth de Google
funcionando (`src/hooks/useGoogleAuth.ts`, flujo auth-code con refresh token
server-side); sumarle el SDK de Firebase implicaría un segundo sistema de
identidad y una dependencia nueva para lo que es apenas una búsqueda de URL.

Consecuencia mecánica: TL2EDIT **no** instala `firebase`. Solo agrega el scope
`spreadsheets` a su OAuth existente y lee/escribe la hoja directo.

El usuario pega la URL de la hoja una vez por serie. No hay descubrimiento
automático en esta iteración (ver "Fuera de alcance").

---

## Contrato de la hoja (extraído del código de scan-tracker-web)

Fuente: `src/services/etapas-service.js` y `src/services/sync-service.js` del
repo `scan-tracker-web`. **Replicar exactamente**, no reinventar.

| Columna | Contenido |
|---------|-----------|
| A | Número de capítulo (`num`) — string, no numérico |
| B | Prioridad (`prio`) — string en mayúsculas |
| C / D | Etapa 1: `who` / `done` — clave interna `trad` |
| E / F | Etapa 2: `who` / `done` — clave interna `limp` |
| G / H | Etapa 3: `who` / `done` — clave interna `typ` |
| I / J | Etapa 4: `who` / `done` — clave interna `corr` |
| K / L | Etapa 5: `who` / `done` — clave interna `sube` |

Reglas exactas:

1. **Fila de encabezado**: se busca en las **primeras 3 filas**; es la primera
   fila donde alguna celda matchea `/^cap/i` tras `.trim()`. Los datos empiezan
   en la fila siguiente. Si no se encuentra, los datos empiezan en la fila 0.
2. **Claves posicionales**: `trad/limp/typ/corr/sube` se asignan por *posición*
   (1ra etapa de la hoja, 2da, etc.), **no** por el nombre real de la etapa. Un
   equipo puede llamar "Redraw" a la etapa 2 y la clave interna sigue siendo
   `limp`. Los nombres visibles se leen del encabezado.
3. **`done` es verdadero** solo si `String(celda).trim().toUpperCase() === "TRUE"`.
4. **Filas vacías**: si la columna A está vacía o es solo espacios, la fila se salta.
5. **`srcRow` es 1-based** (número de fila tal cual aparece en la hoja).
6. **Rango de lectura**: `'<titulo>'!A1:L1000`. Comillas simples del título se
   escapan duplicándolas (`'` → `''`).

---

## Fase 1 — Modelo y persistencia

### 1.1 `src/types.ts`

Agregar la interfaz nueva **antes** de `SeriesStyleSet`:

```ts
/** Vínculo de una serie de TL2EDIT con su hoja de seguimiento en Scan Tracker.
 *  La hoja es el contrato compartido entre ambas apps: scan-tracker-web la usa
 *  como fuente de verdad del progreso, y acá se lee/escribe con el mismo
 *  formato de columnas (ver plan-conexion-scan-tracker en el vault). */
export interface ScanTrackerLink {
  /** URL completa de la hoja, tal como la pega el usuario (incluye #gid= si lo trae). */
  sheetUrl: string;
  /** Título de la pestaña resuelto en la última lectura. Cache: evita un
   *  request de metadata extra en cada escritura. */
  sheetTitle?: string;
  /** gid de la pestaña resuelto en la última lectura. */
  gid?: number;
  /** Alias del usuario en esta hoja (lo que va en la celda `who` al marcar una
   *  etapa). Es por serie porque un mismo usuario puede figurar distinto en
   *  hojas de equipos distintos. */
  alias?: string;
  /** Última lectura exitosa, epoch ms. */
  lastSyncAt?: number;
}
```

Agregar el campo opcional a `SeriesStyleSet`, después de `useContextInPrompt` y
antes de `updatedAt`:

```ts
  /** Ausente = serie sin vincular a Scan Tracker. */
  scanTracker?: ScanTrackerLink;
```

Agregar la constante junto a `MAX_SERIES_STYLE_SETS` (línea ~126):

```ts
export const MAX_SCAN_TRACKER_ALIAS_LEN = 60;
```

### 1.2 `src/config/seriesSets.ts`

Agregar el sanitizador **después** de `sanitizeCharacter` y antes de `sanitizeSet`:

```ts
function sanitizeScanTrackerLink(raw: unknown): ScanTrackerLink | undefined {
  if (!raw || typeof raw !== 'object') return undefined;
  const l = raw as Partial<ScanTrackerLink>;
  const sheetUrl = sanitizeText(l.sheetUrl, 500, '').trim();
  // Sin URL no hay vínculo: el resto de los campos son cache de esa URL.
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

Dentro de `sanitizeSet`, agregar antes del `updatedAt` (línea ~121):

```ts
  const scanTracker = sanitizeScanTrackerLink(s.scanTracker);
```

…y sumarlo al return de `sanitizeSet` (línea ~123), que queda así:

```ts
  return { id, name, types, customTypes, characters, context, useContextInPrompt, scanTracker, updatedAt };
```

Importar `ScanTrackerLink` y `MAX_SCAN_TRACKER_ALIAS_LEN` desde `'../types'`.

### 1.3 Tests — `src/config/seriesSets.test.ts`

Agregar al final del archivo, siguiendo el estilo existente (describe/it en español):

- `it('descarta el vínculo si la URL no es de Google Sheets')` — pasar
  `scanTracker: { sheetUrl: 'https://evil.com/x' }` y esperar `scanTracker === undefined`.
- `it('conserva el vínculo con URL válida y recorta el alias')` — alias de 200
  caracteres queda en 60.
- `it('un set guardado sin scanTracker carga sin romper')` — retrocompatibilidad.
- `it('descarta gid negativo o no numérico')`.

**Aceptación fase 1:**
```bash
cd ~/proyectos/TL2EDIT && npx tsc --noEmit && npx vitest run src/config/seriesSets.test.ts
```
Debe salir sin errores y con los 4 tests nuevos en verde.

---

## Fase 2 — Lectura de la hoja

### 2.1 Scope de OAuth — `src/hooks/useGoogleAuth.ts`

En el array `DRIVE_SCOPES` (línea ~6), agregar como último elemento antes del
`.join(' ')`:

```ts
  // spreadsheets: leer y marcar etapas en la hoja de seguimiento de Scan Tracker.
  'https://www.googleapis.com/auth/spreadsheets',
```

> ⚠️ Este cambio invalida el consentimiento previo: los usuarios verán el popup
> de Google una vez más. Es esperado, no es un bug.

### 2.2 Archivo nuevo — `src/lib/scanTrackerSheet.ts`

Puerto TypeScript de `sheets-api.js` + `etapas-service.js` de scan-tracker-web.
No importar nada de ese repo: es código duplicado a propósito (proyectos
independientes, mismo contrato).

```ts
const SHEETS_API = 'https://sheets.googleapis.com/v4/spreadsheets';

/** Claves internas de etapa. Posicionales, no atadas al nombre real. */
export const ETAPA_KEYS = ['trad', 'limp', 'typ', 'corr', 'sube'] as const;
export type EtapaKey = typeof ETAPA_KEYS[number];

/** Columnas fijas por etapa: [columna de `who`, columna de `done`]. */
export const COLW: Record<EtapaKey, [string, string]> = {
  trad: ['C', 'D'], limp: ['E', 'F'], typ: ['G', 'H'], corr: ['I', 'J'], sube: ['K', 'L'],
};

export const ETAPAS_DEFAULT: [EtapaKey, string][] = [
  ['trad', 'Traducción'], ['limp', 'Limpieza'], ['typ', 'Typeo'],
  ['corr', 'Corrección'], ['sube', 'Sube'],
];

export interface EtapaEstado { who: string; done: boolean; }

export interface ScanTrackerChapter {
  num: string;
  prio: string;
  /** Fila real en la hoja, 1-based. */
  srcRow: number;
  etapas: Partial<Record<EtapaKey, EtapaEstado>>;
}

export interface ScanTrackerSheet {
  spreadsheetId: string;
  gid: number;
  title: string;
  /** Nombres visibles por etapa, leídos del encabezado real. */
  etapaDefs: [EtapaKey, string][];
  chapters: ScanTrackerChapter[];
}
```

Funciones a implementar (todas exportadas):

| Firma | Comportamiento |
|---|---|
| `spreadsheetIdFromUrl(url: string): string \| null` | Regex `/\/d\/([\w-]+)/`, devuelve grupo 1 o `null`. |
| `gidFromUrl(url: string): number \| null` | Regex `/[#&?]gid=(\d+)/`, devuelve `Number(grupo1)` o `null`. |
| `detectEtapaDefs(headerRow: string[]): [EtapaKey, string][]` | Desde índice 2, de a pares, hasta agotar `ETAPA_KEYS` o encontrar label vacío. Si queda vacío, devolver `ETAPAS_DEFAULT`. |
| `parseChapters(rows: string[][]): { chapters: ScanTrackerChapter[]; etapaDefs: [EtapaKey, string][] }` | Aplica las 6 reglas del contrato de arriba. |
| `readScanTrackerSheet(accessToken: string, url: string, signal?: AbortSignal): Promise<ScanTrackerSheet>` | 2 requests: metadata (`?fields=sheets.properties`) para resolver título/gid, luego `values/'<titulo>'!A1:L1000`. |
| `markEtapa(accessToken, link: ScanTrackerLink, srcRow: number, etapa: EtapaKey, who: string, done: boolean, signal?): Promise<void>` | 2 escrituras `PUT` a `values/<rango>?valueInputOption=USER_ENTERED`: celda `who` y celda `done` (esta última con el string `'TRUE'` o `'FALSE'`). |

Helper interno `sheetsFetch(accessToken, url, init?, signal?)`: replica
`driveFetch` de `src/lib/googleDrive.ts:31` — mismo manejo de error (lanzar
`Error` con status y los primeros 200 chars del body).

### 2.3 Tests — `src/lib/scanTrackerSheet.test.ts` (archivo nuevo)

Solo funciones puras, sin red (seguir el patrón de `src/lib/imageBlockGeometry.test.ts`):

- `spreadsheetIdFromUrl`: URL válida con y sin `#gid=`, URL basura → `null`.
- `gidFromUrl`: con `#gid=123`, con `?gid=0`, sin gid → `null`.
- `detectEtapaDefs`: encabezado de 5 etapas, de 3 etapas, encabezado vacío → default.
- `parseChapters`:
  - encabezado en fila 0, fila 1 y fila 2 (las 3 posiciones válidas)
  - sin encabezado → empieza en la fila 0
  - fila con columna A vacía se salta
  - `"TRUE"`, `"true"`, `" True "` → `done: true`; `"FALSE"`, `""`, `"1"` → `done: false`
  - `srcRow` correcto (1-based) incluso saltando filas vacías

**Aceptación fase 2:**
```bash
cd ~/proyectos/TL2EDIT && npx tsc --noEmit && npx vitest run src/lib/scanTrackerSheet.test.ts
```

---

## Fase 3 — UI de vinculación

### 3.1 `src/components/SeriesSetsPanel.tsx`

Agregar una sección nueva al detalle de la serie seleccionada, **debajo** de
`SeriesContextSection` (se renderiza en la línea ~245; montar la sección nueva
inmediatamente después de que cierre).

Componente nuevo: `src/components/ScanTrackerSection.tsx`, siguiendo el patrón
de `SeriesContextSection.tsx` (props explícitas, sin estado global).

```tsx
interface ScanTrackerSectionProps {
  link: ScanTrackerLink | undefined;
  onLink: (sheetUrl: string) => void;
  onUnlink: () => void;
  onAliasChange: (alias: string) => void;
}
```

Contenido:
- Si `link` es `undefined`: input de texto + botón "Vincular hoja". Validar con
  la misma regex de `sanitizeScanTrackerLink`; si no matchea, mostrar el error
  inline "Pega la URL completa de la hoja de Google" y no llamar `onLink`.
- Si `link` existe: mostrar la URL truncada, el `sheetTitle` si está, input de
  alias, y botón "Desvincular".

**Estilo**: usar clases del design system (`btn`, `btn-secondary`, `card`,
`text-muted`) y variables CSS (`var(--space-N)`). **No agregar inline styles
nuevos** — es deuda técnica ya identificada en la auditoría QA (hallazgo B1).

### 3.2 `src/hooks/useSeriesSets.ts`

Agregar a `UseSeriesSetsResult` y al objeto de retorno:

```ts
  /** Vincula (o revincula) la serie a una hoja. Reinicia el cache de título/gid. */
  setScanTrackerLink: (id: string, sheetUrl: string) => void;
  removeScanTrackerLink: (id: string) => void;
  setScanTrackerAlias: (id: string, alias: string) => void;
  /** Guarda el cache tras una lectura exitosa. */
  updateScanTrackerCache: (id: string, patch: Pick<ScanTrackerLink, 'sheetTitle' | 'gid' | 'lastSyncAt'>) => void;
```

Implementarlas siguiendo el patrón exacto de `setSeriesContext` (mutar `current`,
llamar `notify()`, y tocar `updatedAt` del set).

**Aceptación fase 3:**
```bash
cd ~/proyectos/TL2EDIT && npx tsc --noEmit && npx vitest run
```
Verificación manual: crear una serie, pegar una URL de hoja real, recargar la
página y confirmar que el vínculo persiste.

---

## Fase 4 — Panel de capítulos (solo lectura)

### 4.1 Hook nuevo — `src/hooks/useScanTrackerChapters.ts`

```ts
export interface UseScanTrackerChaptersResult {
  chapters: ScanTrackerChapter[];
  etapaDefs: [EtapaKey, string][];
  loading: boolean;
  error: string | null;
  refresh: () => void;
}

export function useScanTrackerChapters(
  link: ScanTrackerLink | undefined,
  accessToken: string | null,
): UseScanTrackerChaptersResult
```

Reglas:
- Si `link` o `accessToken` son nulos: estado vacío, `loading: false`, sin request.
- Usa `AbortController` y lo aborta en el cleanup del `useEffect` (patrón ya
  usado en `src/hooks/useOCR.ts`).
- Al éxito, llamar `updateScanTrackerCache` con `sheetTitle`, `gid` y `lastSyncAt`.
- El error se guarda como string legible, no se lanza.

### 4.2 UI

En `ScanTrackerSection.tsx`, cuando hay vínculo, listar los capítulos: número,
prioridad, y un chip por etapa con el nombre visible (de `etapaDefs`) coloreado
según `done`. Botón "Actualizar" que llama `refresh()`.

**Aceptación fase 4:** con una hoja real vinculada, el panel muestra los
capítulos y sus etapas con los mismos valores que muestra scan-tracker-web
abierto en paralelo.

---

## Fase 5 — Escritura de vuelta

### 5.1 Marcar el typeo

En `ScanTrackerSection.tsx`, cada chip de etapa pasa a ser clickeable: alterna
`done` y escribe el `alias` de la serie en la celda `who`.

Llamar `markEtapa(accessToken, link, ch.srcRow, etapaKey, alias, !done)`.

**Patrón obligatorio** (copiado de `sync-service.js:pushCell` de scan-tracker):
mutar el estado local primero para que la UI responda al toque, y **revertir si
la escritura falla**. Si no, la pantalla queda mintiendo hasta el próximo
refresh. Mostrar el error con el toast existente (`setGlobalError`).

### 5.2 Gancho opcional en la exportación

En `src/hooks/useExport.ts`, tras una exportación exitosa a Drive de una serie
vinculada y con alias configurado, ofrecer (no ejecutar automáticamente) marcar
la etapa `typ` del capítulo como hecha. Un toast con acción, no un diálogo modal.

> Si el capítulo activo no se puede determinar sin ambigüedad, **omitir esta
> sub-fase**. Es un extra, no un requisito.

**Aceptación fase 5:** marcar una etapa desde TL2EDIT y verla reflejada en
scan-tracker-web tras un sync. Cortar la red a mitad y confirmar que el chip
vuelve a su estado anterior con un mensaje de error.

---

## Fuera de alcance (explícito)

- **No** instalar el SDK de Firebase en TL2EDIT.
- **No** leer el catálogo `series/{id}` de Firestore. El descubrimiento
  automático de series por rol de Discord queda para una iteración futura; por
  ahora la URL se pega a mano.
- **No** tocar el repo `scan-tracker-web`. Toda la integración es de un solo
  lado y no le pide nada nuevo a la otra app.
- **No** crear capítulos ni filas nuevas desde TL2EDIT (solo lectura + marcar
  etapas existentes).

---

## Convenciones de trabajo

- **Rama**: `feature/conexion-scan-tracker`, partiendo de `main` actualizado.
- **Commits**: uno por fase, en español, formato `feat:` / `fix:` / `test:`.
  Sin co-autoría.
- **PR**: uno solo al final contra `main`. No mergear directo.
- Cada fase debe dejar `npx tsc --noEmit` limpio y `npx vitest run` en verde
  antes de pasar a la siguiente.
- Los comentarios en código van en español, explicando el *porqué* y no el
  *qué* — seguir la densidad del código existente (ver `seriesSets.ts` como
  referencia de tono).

---

## Referencias de código

| Qué | Dónde |
|---|---|
| Contrato de columnas y parseo | `~/proyectos/scan-tracker-web/src/services/etapas-service.js` |
| Mapa `COLW` y patrón de escritura con rollback | `~/proyectos/scan-tracker-web/src/services/sync-service.js` |
| Llamados REST a Sheets API | `~/proyectos/scan-tracker-web/src/repositories/sheets-api.js` |
| Patrón de fetch autenticado a Google | `~/proyectos/TL2EDIT/src/lib/googleDrive.ts:31` |
| OAuth y manejo del access_token | `~/proyectos/TL2EDIT/src/hooks/useGoogleAuth.ts` |
| Persistencia y sanitizado de series | `~/proyectos/TL2EDIT/src/config/seriesSets.ts` |
| Ancla de diseño del `id` estable | `~/proyectos/TL2EDIT/src/types.ts:109` |
