# Plan: Stitch integration in TL2EDIT

## Problem

Current workflow is manual: download raw from Drive → run `raw stitch` in terminal → upload stitched strips back → import into TL2EDIT. User wants to do it all inside the app.

## Architecture Decision

**Server-side stitching** — stitchtoon is a native CLI, can't run in browser.

Flow: Drive ZIP/CBZ → server downloads → extracts → renames sequentially → stitchtoon → upload strips to Drive → return file IDs → frontend adds to session.

## Files to Create

### 1. `server/stitch.ts` — Stitch logic

Port the relevant parts of `~/.local/bin/raw`'s stitch function:

```
stitchImageBuffer(images: Buffer[], options: { imgsPerStrip?: number; targetHeight?: number }) → Buffer[]
```

- Uses sharp for: AVIF→JPG conversion, image metadata (dimensions), concatenation
- Uses stitchtoon via child_process.execFile for the actual stitching
- Two modes:
  - **imgsPerStrip**: auto-calculate target height from total / strips (like `raw stitch`)
  - **targetHeight**: direct `-H` parameter (like `raw stitch -H`)

Internal flow:
1. Write images to a temp dir as sequentially numbered files (001.jpg, 002.jpg...)
2. Convert AVIF to JPG via sharp (stitchtoon doesn't support AVIF)
3. If imgsPerStrip mode: get total height via sharp, divide by imgs_per_strip = target height
4. Run stitchtoon pass 1: unify all into one image (`-H 9999999`)
5. Run stitchtoon pass 2: cut to target height
6. Read output PNGs from temp dir
7. Cleanup temp dir

### 2. Add `/api/stitch` route to `server.ts`

```
POST /api/stitch
Body: {
  accessToken: string,      // Google Drive token
  fileId: string,           // ZIP/CBZ file on Drive
  parentId: string,         // Drive folder where output goes
  mode: 'imgs' | 'height',
  imgsPerStrip?: number,    // for mode='imgs'
  targetHeight?: number,    // for mode='height'
}
Response: {
  folderId: string,         // created output folder
  folderName: string,
  strips: { id: string; name: string }[]
}
```

Route logic:
1. Download file from Drive via `drive.files.get` with alt=media
2. Write to temp file, detect type (ZIP or CBZ via magic bytes)
3. Extract with JSZip (already a dependency)
4. Filter image files (jpg/png/webp/jpeg/avif), sort alphabetically
5. Call `stitchImageBuffer()` 
6. Upload each strip to Drive in a new folder `<originalName>-stitched`
7. Return folder ID + strip file IDs

### 3. Frontend: StitchModal component

`src/components/StitchModal.tsx` — modal that appears when user clicks "Stitch" on a ZIP/CBZ in the Drive browser.

- Shows file name
- Two radio options: "Imágenes por tira" (default: 4) or "Altura personalizada" (px input)
- Preview info: will produce ~N strips
- "Coser" button → calls `/api/stitch` → returns strip IDs
- Progress indicator during processing

### 4. Modify `DriveImageBrowser.tsx`

- When a file is selected, if it's a ZIP/CBZ (check extension), show a "Coser" button next to "Importar"
- Clicking "Coser" opens StitchModal with the selected file's info
- On stitch complete, the strips get imported directly as pages (like importOne but using the returned Drive file IDs)

## Files to Modify

| File | Change |
|------|--------|
| `server.ts` | Add `/api/stitch` route |
| `src/components/DriveImageBrowser.tsx` | Add "Coser" button for ZIP/CBZ files, open StitchModal |
| `src/components/GoogleDriveControls.tsx` | Pass stitch callback to DriveImageBrowser |

## Files to Create

| File | Purpose |
|------|---------|
| `server/stitch.ts` | Stitch logic (extract, convert, stitchtoon) |
| `src/components/StitchModal.tsx` | Stitch options UI |

## What We're NOT Doing

- **No interactive image picker** (the `raw stitch` menu where you pick which images to include) — YAGNI, can add later if needed
- **No client-side extraction** — all server-side, browser can't run stitchtoon
- **No auto-stitch on import** — user explicitly clicks "Coser" on a ZIP/CBZ
- **No stitch preview** — would require rendering strips client-side before upload, not worth the complexity

## Verification

1. `npm run lint` — typecheck passes
2. `npm test` — existing tests pass
3. Manual test: login to Drive → browse to a folder with a ZIP/CBZ → click "Coser" → verify strips appear in new folder → import strips → verify they show as pages

## Open Questions

1. **Stitchtoon availability**: stitchtoon must be installed on the server. If deploying to Render, this won't work (no CLI tools). For local dev it's fine. Should we add a check at server start?
2. **Error handling for stitchtoon failures**: stitchtoon can fail on corrupt images or weird dimensions. Need to surface these errors clearly.
3. **Large files**: A 200-page manga ZIP could be 500MB+. Download + extract + stitch could take minutes. Need progress feedback? → For v1, just a spinner. Progress is complex (would need SSE or polling).
