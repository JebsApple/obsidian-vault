---
tags:
  - proyecto/traductor-comics
  - blueprint
  - planificacion
  - ia/translation
status: activo
created: 2026-07-10
---

# Blueprint: Traductor de Cómics a PSD v2

**Objetivo:** Reducir dependencia de IA, agregar múltiples proveedores de traducción/OCR, e implementar modo manual completamente funcional.

**Stack:** Express + React 19 (mantener)
**Modelos de IA para ejecución:** Opus (planificación), Fable (consultor), Sonnet (construcción), Haiku (tareas pequeñas)

**Repo local:** `~/Documentos/media/comics/traductor-de-cómics-a-psd/`
**Repo GitHub:** `jebsapple/traductor-comics-psd`

---

## FASE 1: Arquitectura Base y Configuración

### Step 1.1: Sistema de Configuración Centralizado
- **Objetivo:** Crear un sistema de configuración que soporte múltiples proveedores y persista en localStorage
- **Archivos a crear/modificar:**
  - `src/types.ts` - Agregar tipos para configuración
  - `src/config/providers.ts` - Definición de proveedores disponibles
  - `src/config/settings.ts` - Gestión de settings (load/save/reset)
  - `src/hooks/useSettings.ts` - Hook para acceder a configuración
- **Verificación:** Settings se persisten en localStorage y sobreviven refresh

### Step 1.2: Panel de Configuración UI
- **Objetivo:** Crear componente de configuración accesible desde header
- **Archivos a crear/modificar:**
  - `src/components/SettingsPanel.tsx` - Panel modal de configuración
  - `src/App.tsx` - Agregar acceso al panel
- **Verificación:** Panel abre, permite cambiar settings, se cierra, y los cambios persisten

---

## FASE 2: Proveedores de Traducción

### Step 2.1: Backend - Abstract Translation Provider
- **Archivos:**
  - `server/providers/translation/index.ts` - Interfaz base
  - `server/providers/translation/gemini.ts` - Gemini
  - `server/providers/translation/openrouter.ts` - OpenRouter
  - `server/providers/translation/deepl.ts` - DeepL API
  - `server/providers/translation/libretranslate.ts` - LibreTranslate
  - `server/providers/translation/factory.ts` - Factory pattern
- **Endpoints:** `POST /api/translate-text`, `GET /api/providers/status`

### Step 2.2: Frontend - Translation Provider Selector
- **Archivos:** `TranslationProviderBadge.tsx`, `App.tsx`
- **UX:** Badge en header con mini-selector dropdown

---

## FASE 3: OCR y Detección de Globos

### Step 3.1: Backend - Tesseract.js Local OCR
- **Archivos:** `server/providers/ocr/{index,tesseract,gemini,openrouter,factory}.ts`
- **Dep:** `tesseract.js@5`

### Step 3.2: Backend - Refactorizar Endpoint de Traducción
- **Archivo:** `server.ts`
- **Nuevo flujo:** Recibir imagen → OCR provider → traducir → retornar bloques

### Step 3.3: Frontend - OCR Provider Indicator
- **Archivos:** `OCRProviderBadge.tsx`, `ComicCanvasView.tsx`

---

## FASE 4: Modo Manual

### Step 4.1: Backend - Endpoint de Texto Manual
- **Archivo:** `server.ts` — endpoint `/api/translate-text`

### Step 4.2: Frontend - Manual Block Creator
- **Archivos:** `ManualBlockCreator.tsx`, `App.tsx`

### Step 4.3: Frontend - Mode Toggle (AI/Manual)
- **Archivos:** `ModeToggle.tsx`, `App.tsx`

---

## FASE 5: UX y Pulido

### Step 5.1: Mejoras de Error Handling
### Step 5.2: Loading States y Feedback
### Step 5.3: Documentación y Onboarding

---

## FASE 6: Canvas Drawing — Dibujar Cajas Visualmente

### Step 6.1: Canvas Interaction Layer
- **Objetivo:** Permitir al usuario dibujar rectángulos sobre la imagen con click+drag
- **Archivo:** `src/components/ComicCanvasView.tsx`
- **Coords:** pantalla → normalizadas (0-1000): `normalized = (pixel / dimension) * 1000`

### Step 6.2: Backend — OCR Selectivo por Regiones
- **Archivo:** `server.ts` — `POST /api/ocr-regions`
- **Body:** `{ image, regions: [{top,left,bottom,right}], ocrProvider, sourceLang }`

### Step 6.3: Frontend — Flujo Dibujar → OCR → Traducir
- **Archivos:** `App.tsx`, `ComicCanvasView.tsx`

---

## FASE 7: Modo Offline Total

### Step 7.1: Frontend — Edición Directa de Bloques en Canvas
- Doble-click → textarea sobre bloque → Enter guarda, ESC cancela

### Step 7.2: Frontend — Flujo 100% Offline
- Funciona sin API keys: dibujar → escribir → exportar

---

## FASE 8: Refactor UI/UX

### Step 8.1: Layout Minimalista (3 paneles)
### Step 8.2: Componentes Unificados (design system)
### Step 8.3: Interacciones y Transiciones
### Step 8.4: Keyboard Shortcuts

---

## FASE 9: Validación de Archivos y Compresión Inteligente

### Step 9.1: Magic Bytes Verification
- **Objetivo:** Verificar que los archivos subidos son realmente imágenes (no confiar en `file.type` del navegador)
- **Archivo:** `src/App.tsx` — en `handlePageFiles`, antes del `FileReader`
- **Magic bytes:**
  - JPEG: `FF D8 FF`
  - PNG: `89 50 4E 47 0D 0A 1A 0A`
- **Verificación:** Leer primeros 8 bytes con `file.slice(0, 8)` + `ArrayBuffer`, comparar contra esperados. Rechazar con error claro si no coinciden.

### Step 9.2: Auto-Compresor de Imágenes Grandes
- **Objetivo:** Imágenes > 10MB se comprimen automáticamente para la vista del canvas, pero el PSD export usa la resolución original
- **Archivos a modificar:**
  - `src/types.ts` — agregar campo `originalBase64Data?: string` a `ComicPage`
  - `src/App.tsx` — en `handlePageFiles`, después de cargar la imagen: si `file.size > 10MB`, comprimir via canvas API (max 2000px eje mayor, quality 0.8) y guardar resultado en `base64Data`, original en `originalBase64Data`
  - `src/utils/psdExport.ts` — `generatePsdBuffer` usa `page.originalBase64Data ?? page.base64Data` para el fondo
- **UX:** Badge sutil "Comprimida para vista" en el thumbnail cuando aplique
- **Verificación:** PSD exportido tiene resolución original, canvas muestra versión comprimida

---

## FASE 10: Exportación DOCX para TypeR

### Step 10.1: Panel de Botones de Tipo de Globo
- 13 tipos: dialogue, thought, shout, double, narration, box, secondary, system, sfx, object_text, staff_note, screen_text, tech_balloon
- Auto-detección de símbolos desde prefijo del texto

### Step 10.2: Reordenamiento de Bloques (drag & drop)
### Step 10.3: Backend — Generación de .docx (`server/export/docx.ts`)
### Step 10.4: Frontend — Panel de Exportación DOCX
### Step 10.5: Configuración de Símbolos (User-Customizable)

---

## Criterios de Aceptación Final

**FASE 1-5:** ✅ (completas — ver tracking)
**FASE 6-10:** Pendientes — ver Kanban sprints

---

## Referencias

- **DeepL API:** https://developers.deepl.com/docs/api-reference/translate/openapi-spec-for-text-translation
- **LibreTranslate:** https://libretranslate.com/docs
- **Tesseract.js:** https://github.com/naptha/tesseract.js
- **ag-psd:** https://github.com/nicktomlin/ag-psd
