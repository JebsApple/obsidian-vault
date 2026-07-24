# Bug Report: TL2EDIT — Hallazgos de prueba (2026-07-19)

## Backend — OCR

### ✅ Gemini OCR
- Funciona perfecto: detecta texto, bounding boxes, traducción inline
- `confidence` > 0.9
- Con imagen simple (test-comic.png) y con imagen real de cómic (21 bloques)

### ⚠️ OpenRouter OCR
- Con `test-comic.png` → devuelve `blocks: []` (vacío)
- Causa: modelos no son vision. Código itera `gemma-4-26b-a4b-it:free`, `nemotron-nano-12b-v2-vl:free`, `gemma-4-31b-it:free`. Gemma-4 es texto puro.
- Con imagen real de cómic → detecta 23 bloques pero timeout al leer detalles
- **Fix**: cambiar modelos a vision como `qwen/qwen-vl-plus:free`, `qwen/qwen2.5-vl-7b-instruct:free`, `google/gemma-3-27b-it:free`

### ❌ Tesseract OCR
- `test-comic.png` es 16-bit gray+alpha — Tesseract.js no la procesa → `blocks: []`
- Con imagen real de cómic coreano: detecta 197 words pero son ruido (números, fragmentos, caracteres rotos)
- No soporta `detectRegions` — solo agrupa palabras en líneas, no detecta globos
- **Fix**: convertir imagen a 8-bit RGB antes de enviarla a Tesseract. O aceptar que solo sirve para transcripción manual (Recuadro manual).

## Backend — Traducción

### ✅ Todos funcionan
- Google (API no oficial `client=gtx`): funciona
- DeepL: key `1ae52939-xxxx:fx` vigente hasta 11/ago/2026
- MyMemory: funciona (cuota por IP)
- Lingva (`lingva.ml`): funciona
- LibreTranslate (`libretranslate.lynx.fr`): funciona

### ⚠️ Problemas potenciales
- Google Translate es API no oficial — puede ser bloqueada
- `.env`: `LIBRETRANSLATE_URL=http://localhost:5000/translate` (formato no estándar)
- MyMemory tiene cuota diaria gratuita

## Frontend

### ✅ Carga de imágenes
- File input oculto con `display: none`, se gatilla por onClick en div
- Upload con `agent-browser upload 'input[type="file"]' path` funciona

### ✅ Detector local ONNX
- `comic-text-detector` (Hugging Face, ~90MB)
- Se descarga y cachea en Cache Storage del navegador
- En `test-comic.png`: no encontró globos (imagen muy simple)
- Con imagen real de cómic: debería funcionar (modelo entrenado con Manga109-s)

### ⚠️ Seccionado de imágenes largas
- Imagen de 800x21425px gatilla modal "Seccionar" automáticamente
- Ofrece 10 secciones, botones "Sugerir cortes", "Agregar corte", "Cancelar", "Aplicar"
- Al no aplicar cortes y cancelar, la imagen queda en estado indefinido
- **Flujo correcto**: subir imagen → aplicar cortes → "Detectar globos"

### ❌ Botón "Agregar" no funciona
- Ref @e9 en la UI — al hacer clic no pasa nada visible
- Debería abrir el file picker para agregar más imágenes
- Posible bug: onClick no conectado o handler ausente

### ❌ Error: "Failed to initialize fff" en logs
- Error en log de opencode: no relacionado con TL2EDIT, es del directorio home

## Instrucciones para Claude

Al implementar fixes:

1. **OpenRouter OCR**: cambiar modelos a vision. Sugerencia: probar `qwen/qwen-vl-plus:free` primero, luego fallback a `qwen/qwen2.5-vl-7b-instruct:free`.
2. **Tesseract**: convertir imagen a 8-bit RGB con sharp antes de pasar a Tesseract.js.
3. **Botón "Agregar"**: revisar handler onClick en el componente.
4. **Seccionado**: al cancelar seccionado, volver al estado anterior (sin la imagen subida) o permitir detectar de todas formas con la imagen completa.
5. **OpenRouter traducción**: agregar timeout de 30s por modelo.
