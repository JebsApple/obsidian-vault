<!-- fold(tema="tl2edit-redraw-sesion-local", lineas=110, leer_si="trabajando en feature/redraw-experimental") -->
---
aliases: [tl2edit-redraw-design]
tags: [project, plan, comics, tl2edit, redraw]
created: 2026-08-01
status: activo
---

# TL2EDIT — Redraw experimental + sesión local descargable

## Contexto

Rama: `feature/redraw-experimental` (sin PR todavía — se abre después de probar en dev server).
Repo: `~/proyectos/TL2EDIT`, main en v4.12.11 al momento de crear esta rama.

Dos features acordadas en brainstorming con el usuario (2026-08-01):

1. **Redraw v1**: pincel libre + cuentagotas para limpiar el texto original antes
   de tipear la traducción. Marcado explícitamente como *experimental* por el
   usuario — no reemplaza Photoshop, es una ayuda rápida para fondos lisos.
2. **Sesión local descargable**: hoy la única forma de "guardar" fuera del
   autoguardado en IndexedDB (`sessionStore.ts`, ya funciona) es Google Drive.
   Falta poder bajar/subir la sesión como archivo portable.

Roadmap de redraw acordado con el usuario, a implementar de a poco:
- **v1 (esta rama)**: relleno manual con cuentagotas + pincel.
- v2 (futuro): inpainting algorítmico simple (sin IA), enchufable como método alternativo.
- v3 (futuro): inpainting con IA vía API externa.
La arquitectura de v1 no debe cerrar la puerta a v2/v3 (ver "Puntos de extensión").

## Feature 1 — Redraw v1

### Modelo de datos

Campo nuevo en `ComicPage` (`src/types.ts`):
```ts
redrawDataUrl?: string; // PNG con fondo transparente, mismas dimensiones que la imagen de la página
```
No destructivo: `base64Data` (imagen original) nunca se modifica.

### Lógica pura — `src/lib/redraw.ts`

Funciones testeables con Vitest, sin React, siguiendo el patrón de `src/lib/`:
- `paintStroke(imageData, points, color, brushSize)`
- `eraseStroke(imageData, points, brushSize)`
- `hasPaintedPixels(imageData): boolean` — para no exportar capas vacías ni
  guardar `redrawDataUrl` cuando está todo transparente.
- `sampleColorAt(imageData, x, y): { r, g, b }` — cuentagotas.

### Hook — `useRedraw` (o extensión de `useComicEditor`)

Estado: modo activo (`paint` | `erase` | `eyedropper` | inactivo), tamaño de
pincel, color activo. Mantiene un `<canvas>` offscreen por página activa,
hidratado desde `redrawDataUrl` al entrar en modo redraw, serializado de
vuelta a `redrawDataUrl` (PNG data URL) al soltar el trazo (`pointerup`).

**Undo/redo**: se reusa `useUndoRedo` tal cual existe hoy — hace snapshot de
`pages` completo. Confirmar el trazo con el mismo flujo `snapshot()` antes de
`setPages()` que usan las demás interacciones (dibujar recuadro, editar
texto). No se escribe una pila de historial nueva.

### UI — `ComicCanvasView`

Nuevo modo "Redibujar" en la barra de herramientas, junto al toggle de
dibujar recuadros. Badge "Experimental" visible. Controles mientras está activo:
- Cuentagotas: clic en la imagen compuesta fija el color activo.
- Pincel: tamaño ajustable (slider), pinta con el color activo. Pintura
  libre, **no atada a ningún recuadro de globo**.
- Borrador: quita solo lo pintado, no afecta la imagen original.
- Toggle "ocultar redraw" para comparar antes/después.

Orden de capas en el canvas: imagen base → capa de redraw → recuadros de
texto (igual que en el PSD).

### Webtoons / secciones

Sin caso especial: se pinta sobre la imagen completa, mismas coordenadas
0-1000 que usan los bloques. Respeta la regla ya establecida en el blueprint
principal de que las secciones (`cutsPx`) son solo metadato y nunca parten
la imagen real.

### Export PSD (`src/utils/psdExport.ts`, función `generatePsdBuffer`)

Si `page.redrawDataUrl` existe y `hasPaintedPixels` es true: construir un
canvas desde el data URL y agregar una capa justo después de
`"Página Original"` y antes de `"Capas de Texto"`:
```ts
layers.push({
  name: "Redibujado (experimental)",
  canvas: redrawCanvas,
  opacity: 1,
  blendMode: "normal" as const,
});
```
Mismo patrón que la capa de fondo existente (líneas 142-147 actuales).
Editable/desactivable en Photoshop, no se aplasta contra la imagen original.

### Persistencia (`src/lib/sessionStore.ts`)

`redrawDataUrl` se guarda junto a `base64Data` en `StoredPageImage`
(`IMAGES_STORE`), mismo objeto, mismo store. El autoguardado y
`loadSession`/`RestorableSession` ya cubren el campo nuevo sin tocar su
lógica de debounce ni de poda (`pruneImages`).

### Puntos de extensión (para v2/v3 futuros)

- `redraw.ts` expone las funciones de pintar/borrar/samplear como unidades
  aisladas — un método de limpieza automática (v2/v3) puede generar el mismo
  `redrawDataUrl` sin tocar la UI de pincel.
- El campo `redrawDataUrl` y la capa PSD no asumen *cómo* se generó el
  contenido — sirven igual para relleno manual, algorítmico o IA.

### Testing

Vitest para `src/lib/redraw.ts` (pintar, borrar, detectar píxeles pintados,
samplear color). Sin E2E de Playwright para el pincel en esta rama — el
usuario prueba a mano en el dev server (preferencia ya registrada en
memoria: no smoke tests de Playwright por cuenta propia).

## Feature 2 — Sesión local descargable

### Contexto actual

`useSessionPersistence` + `sessionStore.ts` ya autoguardan en IndexedDB y
restauran al recargar. `DriveSessionModal` permite guardar manualmente en
Google Drive. Falta: bajar la sesión completa como archivo portable (mover
de máquina, respaldo fuera del navegador) y volver a abrirla.

### Lógica pura — `src/lib/sessionFile.ts`

- `buildSessionZip(pages: ComicPage[], activePageId: string | null): Promise<Blob>`
  — arma un `.zip` con jszip (ya es dependencia, mismo patrón que
  `buildPsdBatchZip`/`exportBatchToZip`):
  - `session.json`: metadata de cada página (`textBlocks`, `cutsPx`,
    `status`, `fileName`, `mimeType`, `width`, `height`, referencia al
    archivo de imagen y al de redraw si existe), `pageOrder`, `activePageId`.
  - `pages/<id>.<ext>`: imagen decodificada de `base64Data`.
  - `redraw/<id>.png`: solo si la página tiene `redrawDataUrl` con píxeles.
- `parseSessionZip(blob: Blob): Promise<RestorableSession>` — camino
  inverso, devuelve el mismo shape que ya usa `useSessionPersistence.restore()`.

### UI — `App.tsx`

Junto a los controles de sesión existentes (cerca de `DriveMenu` /
`handleRestoreSession`):
- Botón **"Descargar sesión"**: `buildSessionZip` → descarga
  `tl2edit-sesion-<fecha>.zip`.
- Botón **"Abrir sesión"**: file picker `.zip` → si hay páginas cargadas con
  trabajo, confirmar antes de reemplazar → `parseSessionZip` → mismo
  `setPages`/`setActivePageId` que usa `handleRestoreSession`.

No toca el autoguardado a IndexedDB (sigue igual, independiente). Es un
camino paralelo, no un reemplazo de Drive ni del autoguardado local.

### Testing

Vitest para `buildSessionZip`/`parseSessionZip` con un `ComicPage` de
prueba (ida y vuelta: construir zip, parsearlo, comparar).

## Checklist de prueba manual (antes de abrir PR)

- [ ] Modo redraw: pintar sobre un globo con cuentagotas, tamaño de pincel,
      borrador — undo (Ctrl+Z) revierte el trazo.
- [ ] Toggle "ocultar redraw" muestra/oculta la capa pintada.
- [ ] Exportar PSD: capa "Redibujado (experimental)" presente, editable,
      no aplastada contra "Página Original".
- [ ] Página sin nada pintado → no aparece capa de redraw en el PSD.
- [ ] Recargar la página con trabajo sin guardar → restaura, incluido lo pintado.
- [ ] Descargar sesión → abrir el `.zip` en otra pestaña/perfil → recupera
      páginas, bloques y redraw pintado.
- [ ] Webtoon largo (con secciones) → redraw funciona igual sobre la imagen completa.

## Convención de rama (confirmada 2026-08-01)

TL2EDIT sigue `{tipo}/{descripción}` (feature/fix/bugfix/release) — la
convención `S{n}-HU{n}` no se aplica acá (excepción registrada en memoria
`feedback-git-naming-authorship`). Sin prefijo Claude/Anthropic ni
co-autoría en commits ni PR.
