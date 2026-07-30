# Plan de Re-implementación TL2EDIT — Features Post-PR #80

> Estado base: **main = post-revert #88 = commit a5dbd30 (PR #80 merged)**
> Estrategia: Implementación secuencial por features, no por ramas.
> Stitch: NO se toca (solo si cambio 100% seguro).

---

## Features a implementar (orden de ejecución)

```
main (PR #80)
 │
 ├──► Paso 1: Formato exportación DOCX mejorado
 │      (cada bloque su párrafo, sin separación páginas, imágenes incluidas)
 │
 ├──► Paso 2: Apodos para nombre original + traducido
 │      (NicknameRule, hook, UI panel)
 │
 ├──► Paso 3: Series con tipos de bloque propios
 │      (Series con blockTypeOverrides, UI selector)
 │
 ├──► Paso 4: Unificar botones de exportación en UI
 │      (Exportar → DOCX / Google Docs, PSD igual)
 │
 └──► Paso 5: Drive hardening
        (exponential backoff, URL encoding audit)
```

---

## Paso 1: Formato DOCX mejorado

**Archivo**: `src/lib/exportDocx.ts`
**Descripción**: Cambiar el formato de exportación DOCX.

### Formato nuevo

```
-diálogo

()pensamiento

**grito

-dialogo 2

[imagen: sticker.png]    ← bloque imagen insertado como imagen

-dialogo 3
```

### Cambios concretos
- **Cada bloque = su propio párrafo** (eliminar lógica de `groupId` que unía bloques en una línea)
- **Párrafo en blanco entre cada bloque** (`spacing: { after: 200 }`)
- **Sin separación entre páginas** (todo corrido en una sola sección)
- **Bloques imagen se mantienen** con `ImageRun` (ya funciona)
- **Apodos**: aplicar `applyNicknames()` al texto aprobado antes de escribir
- **Google Docs**: se queda igual (sube DOCX con `convert: true`)
- DOCX se mantiene como formato único (ni .txt ni nada más)

### Criterios de éxito
- [ ] `npm test` pasa
- [ ] `npm run build` pasa
- [ ] Output DOCX tiene cada bloque en su propio párrafo
- [ ] Hay línea en blanco entre bloque y bloque
- [ ] No hay separación entre páginas
- [ ] Imágenes aparecen insertadas en el DOCX

---

## Paso 2: Apodos para nombre original + traducido

### 2.1 Modelo de datos (`src/types.ts`)
```typescript
export interface NicknameRule {
  id: string
  nickname: string
  originalPattern: string    // Patrón en texto ORIGINAL
  translatedPattern: string  // Patrón en texto TRADUCIDO
  enabled: boolean
}
```

### 2.2 Hook (`src/hooks/useNicknames.ts`)
Mismo patrón que `useReplacements.ts` (store a nivel módulo + `useSyncExternalStore`):
- `nicknames: NicknameRule[]`
- `addRule`, `removeRule`, `updateRule`, `toggleRule`
- `importRules`, `exportRules`

### 2.3 UI (`src/components/NicknamesPanel.tsx`)
Panel similar a ReplacementsPanel con 3 campos por entrada:
| Campo | Ejemplo |
|-------|---------|
| Apodo | Naruto |
| Nombre original | うずまきナルト |
| Nombre traducido | Uzumaki Naruto |

### 2.4 Integración en export
- En `exportDocx.ts`: función `applyNicknames(text, nicknames, mode)` 
  - `mode='original'`: reemplaza `originalPattern` → `nickname`
  - `mode='translated'`: reemplaza `translatedPattern` → `nickname`
- Aplicar al texto aprobado antes de escribir cada párrafo
- En OCR: aplicar apodos al original ANTES de enviar a traducir (mejora calidad)

### Criterios de éxito
- [ ] Panel de apodos visible y funcional
- [ ] Apodo reemplaza en texto original
- [ ] Apodo reemplaza en texto traducido
- [ ] `npm test` pasa

---

## Paso 3: Series con tipos de bloque propios

### 3.1 Modelo de datos (`src/types.ts`)
```typescript
export interface SeriesBlockTypeOverride {
  blockTypeId: string        // 'dialogo', 'grito', o id de custom type
  prefix?: string            // ej: '→' en vez de '-'
  fontFamily?: string
  label?: string
}

export interface Series {
  id: string
  name: string
  blockTypeOverrides: SeriesBlockTypeOverride[]
}
```

### 3.2 Resolución (`src/types.ts` — modificar `resolveBlockType`)
```typescript
export function resolveBlockType(
  typeConfig: BlockTypesConfig,
  blockType: string,
  seriesOverrides?: SeriesBlockTypeOverride[]
): { label, prefix, fontFamily, icon }
```
Regla:
1. Si hay override de la serie activa para ese `blockTypeId` → usar override
2. Si no → usar el blockType global (actual)

### 3.3 Hook (`src/hooks/useSeries.ts`)
- `seriesList: Series[]`
- `currentSeries: Series | null`
- `setCurrentSeries(id)`
- `addSeries`, `removeSeries`, `updateSeries`

### 3.4 UI (`src/components/SeriesPanel.tsx`)
- Selector de serie activa (dropdown)
- Editor de overrides por serie

### Criterios de éxito
- [ ] Selector de serie en UI
- [ ] Override cambia prefijo en sidebar y export
- [ ] `npm test` pasa

---

## Paso 4: Unificar botones de exportación en UI

### Cambios en `src/App.tsx`
| Antes | Después |
|-------|---------|
| Botón DOCX + hover (Descargar / Drive / Google Docs) | Botón **Exportar** + hover (Descargar DOCX / Google Docs) |
| Botón GDOCS aparte | ❌ Eliminado (unificado en Exportar) |
| Botón PSD + hover (Descargar / Guardar en Drive) | ✅ Igual |

### Cambios en `src/hooks/useExport.ts`
- `handleExportDocxMulti` se mantiene (DOCX → local)
- `handleExportGoogleDocs` se mantiene (DOCX → Drive con convert)
- Eliminar `buildDocxBlobMulti` si es necesario (no, se usa para ambos)

### Criterios de éxito
- [ ] Un solo botón "Exportar" con hover: "Descargar DOCX" y "Google Docs"
- [ ] Botón PSD igual que ahora
- [ ] Exportar a local descarga .docx
- [ ] Exportar a Drive → Google Docs funciona

---

## Paso 5: Drive hardening

### 5.1 Exponential backoff genérico (`src/lib/googleDrive.ts`)
```typescript
async function driveFetchWithRetry(
  accessToken, url, init?, signal?, maxRetries = 3
): Promise<Response> {
  // Reintenta con backoff exponencial en 429, 500, 503
  // 1er reintento: 2s, 2do: 4s, 3ro: 8s
}
```

### 5.2 URL encoding audit
- Verificar TODOS los `q=` params usan `encodeURIComponent()`
- En particular: `listDriveSessions`, `ensureSessionsFolder`, `ensureExportsFolder`, `listDriveFolder`

### Criterios de éxito
- [ ] `npm test` pasa
- [ ] Todas las queries a Drive API están URL-encodeadas

---

## Archivos a crear

| Archivo | Propósito |
|---------|-----------|
| `src/hooks/useNicknames.ts` | Hook de apodos |
| `src/components/NicknamesPanel.tsx` | UI de apodos |
| `src/hooks/useSeries.ts` | Hook de series |
| `src/components/SeriesPanel.tsx` | UI de series |

## Archivos a modificar

| Archivo | Cambio |
|---------|--------|
| `src/lib/exportDocx.ts` | Nuevo formato (cada bloque su párrafo, sin separación páginas, apodos) |
| `src/types.ts` | Agregar `NicknameRule`, `Series`, `SeriesBlockTypeOverride`. Modificar `resolveBlockType()` |
| `src/hooks/useExport.ts` | Ajustar para nuevo flujo |
| `src/hooks/useComicEditor.ts` | Integrar apodos y series |
| `src/App.tsx` | Unificar botones Exportar + PSD. Integrar NicknamesPanel y SeriesPanel |
| `src/lib/googleDrive.ts` | Exponential backoff, URL encode audit |
| `src/lib/pageHelpers.ts` | Si aplica para baseFileName |

## Archivos que NO se tocan

| Archivo | Motivo |
|---------|--------|
| `server/stitchEngine.ts` | Stitch no se modifica |
| `server/stitch.ts` | Stitch no se modifica |
| `src/components/StitchModal.tsx` | Stitch no se modifica |
| `src/components/DriveSessionModal.tsx` | Ya funciona (PR #80) |
| `src/hooks/useSessionPersistence.ts` | Ya funciona |

---

## Checklist de Seguridad (NO ROMPER)

| Área | Archivos intocables sin validación |
|------|-----------------------------------|
| **Drive** | `googleDrive.ts` — solo agregar, no cambiar firmas existentes |
| **Stitch** | `stitchEngine.ts`, `stitch.ts`, `StitchModal.tsx` — NO TOCAR |
| **Session** | `useSessionPersistence.ts`, `SESSION_FORMAT_VERSION` |
| **Telemetry** | `TELEMETRY_SCHEMA_VERSION`, sanitize, consent flow |

---

*Generado: 2026-07-30. Prioriza estabilidad sobre velocidad.*
