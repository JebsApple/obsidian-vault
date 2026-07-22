---
aliases: [tl2edit-blueprint]
tags: [project, plan, comics, translation, ocr]
created: 2026-07-13
updated: 2026-07-18
status: activo
---

# TL2EDIT — Plan

## Contexto

Traductor de cómics a PSD editable. Detecta globos de texto, transcribe y
traduce el diálogo, exporta `.psd` con capas editables para Photoshop y
`.docx` con el guion en formato typertools.
Repo: [JebsApple/TL2EDIT](https://github.com/JebsApple/TL2EDIT) (público).
Copia activa: `~/proyectos/TL2EDIT` (la copia vieja de `~/Documentos` fue borrada).

## Stack

| Capa | Tecnología |
|------|-----------|
| Frontend | React 19 + Vite + Tailwind v4 + design system Nocturne (`src/nocturne.css`) |
| Backend | Express + TypeScript (`tsx`), puerto 3000 |
| OCR | Gemini, OpenRouter (vision), Tesseract.js (local, sin key) |
| Traducción | Gemini, OpenRouter, DeepL, LibreTranslate (sin key) |
| Export | `ag-psd` (PSD/PSB), `docx` (guion typertools), `jszip` (batch ZIP) |
| Tests | Vitest (81 tests, lógica pura en `src/lib/`) |

## Estado actual (2026-07-18)

Rama `feature/webtoon-multipagina-tipos` (commit `be8ff3d` + fixes posteriores).
El rediseño Nocturne quedó conectado al backend multiproveedor real (el
conflicto PR #1 vs #2 del 13-07 se resolvió reescribiendo el frontend sobre
la base HU02).

### Features completadas

- **Multi-página**: tabs por imagen (cerrables), carga múltiple, botón
  "Exportar todo" (ZIP con un PSD por página) cuando hay 2+ imágenes.
- **Webtoons largos** (alto/ancho > 2.5):
  - Viewer con scroll vertical y zoom por ancho; recuadros fijos a la imagen.
  - Modal de seccionado: cortes sugeridos por detección de filas planas
    (algoritmo local estilo SmartStitch, **sin IA**: objetivo cada ~2200 px,
    ajustado a la fila de píxeles "plana" más cercana para no cortar globos).
    Arrastrables, agregar/quitar. Cola cuando entran varias imágenes largas.
  - OCR por sección (mejor lectura: Gemini escala todo a máx 3072×3072) con
    progreso real n/N y remapeo de coordenadas a la imagen completa.
- **Recuadros**: dibujar, redimensionar (handles en esquinas), eliminar
  (× en canvas / tacho en sidebar), reordenar (↑↓ — define el orden del DOCX),
  OCR bajo demanda por globo (icono escáner).
- **Modos**: IA = detección de globos + traducción automática. Manual =
  recuadros a mano (vacíos, se traducen a mano); toggle "OCR al dibujar" y
  botón de OCR por globo para detectar solo lo marcado.
- **Tipos de globo** (config separada en localStorage `tl2edit-block-types`,
  panel propio desde Configuración): símbolo typertools + fuente PSD por
  tipo. Fuentes personalizadas libres (datalist con sugerencias). Prefijos:
  `-`diálogo `**`grito `()`pensamiento `/`título `[]`narración `sfx ` `Nt `
  `<>`sistema `##`secundario `~`personalizado (etiqueta editable).
- **Export**: DOCX (símbolo + traducción por globo, en orden, una línea por
  globo), PSD desde la imagen completa (las secciones nunca la parten),
  **PSB automático** si supera 30.000 px. Capa de texto siempre presente
  (cuadros sin texto exportan capa con espacio, nombre "Globo NN").
- **Limpieza del output IA**: `collapseLineBreaks` (la IA imita los saltos
  del globo → se colapsan a una línea) y `normalizeShouting` (TODO EN
  MAYÚSCULAS → mayúsculas gramaticales; SFX de una palabra intactos).
- **Confidence OCR**: 0-1 desde Gemini/OpenRouter/Tesseract; < 0.7 marca
  tag "Revisar" (`REVIEW_CONFIDENCE_THRESHOLD` en `src/types.ts`).
- Idioma origen "Detección automática" (`auto`) + en/ja/ko. UI en español neutro.

### Arquitectura clave (no romper)

- **Las secciones son metadato** (`ComicPage.cutsPx: number[]`), nunca parten
  la imagen: OCR recorta y remapea (`src/lib/sections.ts:remapBoxToFull`,
  sin redondeo a enteros — fidelidad en imágenes largas); PSD/visor usan
  siempre el original. Elimina todo problema de "encaje" al exportar.
- Bloques en coordenadas 0-1000 de la imagen completa (floats permitidos).
- Config de tipos de globo separada de settings generales
  (`src/config/blockTypes.ts` + `useBlockTypes`); settings generales en
  `comic-translator-settings` (`src/config/settings.ts`).
- Export de texto: `buildExportLines` (`src/lib/exportTxt.ts`) es la única
  fuente del formato typertools; DOCX la consume.

## Checklist de prueba manual (pre-release)

- [ ] Webtoon real coreano: cargar, revisar cortes sugeridos, detectar, verificar
      posiciones de recuadros y calidad OCR por sección
- [ ] Dos imágenes largas a la vez → el seccionador debe abrirse para ambas en secuencia
- [ ] Modo manual: dibujar cuadro (sin OCR), escribir traducción, exportar PSD →
      capa "Globo NN" presente y editable en Photoshop
- [ ] Botón escáner por globo (OCR de un cuadro manual ya dibujado)
- [ ] Reordenar globos con ↑↓ y verificar orden en el DOCX
- [ ] Tipos de globo: cambiar símbolo y fuente (incluida una personalizada
      instalada en Photoshop), exportar PSD y verificar fuente de la capa
- [ ] PSD > 30.000 px de alto → debe salir `.psb` y abrir en Photoshop
- [ ] Exportar todo (ZIP) con 2+ páginas
- [ ] Traducciones: sin saltos de línea, sin TODO MAYÚSCULAS (salvo SFX)

### BYOK (2026-07-18)

Cada usuario carga su propia API key (Gemini/OpenRouter/DeepL) en Configuración
→ "Tus API keys" (localStorage, viaja por request en `apiKeys`, nunca se guarda
en el servidor). Si falta, cae al fallback del `.env` del servidor. Guía
integrada ("¿Cómo consigo una?") con pasos + link a aistudio.google.com.
Decisión: se descartó BYOK 100% cliente→Gemini (sin pasar por el backend)
por alcance — la key SÍ pasa por el server como proxy (visible al operador
de esa instancia, no a otros usuarios), documentado en el README.

**Corrección importante de dominio**: Tesseract NO es capaz de detectar
globos en una página completa (no es modelo de visión, solo transcribe
texto plano de un recorte ya marcado). Modo IA (detección automática)
exige Gemini u OpenRouter — filtrado en el selector y bloqueado con error
claro si se intenta con Tesseract. `AUTO_DETECT_OCR_PROVIDERS` en
`src/config/providers.ts`. Default `ocrProvider: 'gemini'`,
`translationProvider: 'libretranslate'` (`src/config/settings.ts`).

## Backlog

### P1
- [ ] Merge de `feature/webtoon-multipagina-tipos` a `main` tras el checklist
- [ ] Primera release (tag + README actualizado con flujo webtoon)
- [ ] Métricas reales de calidad OCR (comparar transcripción vs corrección manual)

### P2
- [ ] Multi-idioma de UI
- [ ] Historial de páginas procesadas
- [ ] Persistir sesión de trabajo (páginas/bloques) en localStorage o archivo

## Convención de ramas

`{tipo}/{descripción}` para trabajo general; HUs universitarias usan
`S{sprint}-HU{hu}-{descripción}`. Commits `feat/fix/...` sin co-autoría.
