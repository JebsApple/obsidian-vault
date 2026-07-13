---
tags:
  - proyecto/traductor-comics
  - testing
  - manual-testing
created: 2026-07-12
status: activo
---

# Test Manual — TL2EDIT

Cada test está asociado a una tarea del kanban. Marcar ✅ al pasar, ❌ al fallar (adjuntar evidencia).

---

## Sprint 0 — Foundations (completado)

> Sin tests manuales nuevos — funcionalidad base verificada durante desarrollo.

---

## Sprint 1 — Core Interaction

### 7A: Inline editing en canvas

| #    | Paso                                                                                                 | Esperado                                                             | Resultado |
| ---- | ---------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- | --------- |
| 7A-1 | Doble-click sobre un bloque de texto existente                                                       | Aparece textarea inline sobre el bloque con el texto actual          |           |
| 7A-2 | Escribir nuevo texto y presionar Enter                                                               | Texto se guarda, textarea desaparece, bloque muestra nuevo texto     |           |
| 7A-3 | Doble-click para editar, escribir algo, presionar ESC                                                | Cambios se descartan, bloque muestra texto original                  |           |
| 7A-4 | Editar un bloque, presionar Tab                                                                      | Selecciona el siguiente bloque (o vuelve al primero si es el último) |           |
| 7A-5 | Doble-click en un bloque vacío (recién creado)                                                       | Textarea aparece vacío, listo para escribir                          |           |
| 7A-6 | Verificar que el textarea se posiciona correctamente sobre el bloque en distintos tamaños de ventana | Textarea siempre cubre el área del bloque sin desfase                |           |

### 7B: Flujo 100% offline

| # | Paso | Esperado | Resultado |
|---|------|----------|-----------|
| 7B-1 | Abrir la app sin configurar ninguna API key (borrar todas del .env y localStorage) | La app carga sin errores, modo Manual activo por defecto | |
| 7B-2 | Subir una imagen | Imagen se carga en el canvas sin llamada a red | |
| 7B-3 | Dibujar un recuadro sobre la imagen | Recuadro aparece sobre la imagen | |
| 7B-4 | Hacer clic en "Agregar bloque(s)" | Bloque vacío creado con bounding box del recuadro | |
| 7B-5 | Escribir texto original en el textarea del bloque | Texto se guarda localmente | |
| 7B-6 | Hacer clic en "Exportar PSD" | Archivo .psd se descarga con imagen de fondo + capa de texto | |
| 7B-7 | Abrir el .psd en Photoshop (o GIMP) | Capas visibles: fondo + texto editable en la posición correcta | |
| 7B-8 | Repetir con 3 páginas, exportar lote como ZIP | ZIP contiene 3 archivos .psd, cada uno con su imagen y texto | |
| 7B-9 | Verificar en DevTools Network que no se hizo ninguna llamada a `/api/*` | 0 requests externos | |

### 8A: Layout 3 paneles responsive

| # | Paso | Esperado | Resultado |
|---|------|----------|-----------|
| 8A-1 | Abrir a 1920px de ancho | 3 paneles visibles: páginas (izq), canvas (centro), editor (der) | |
| 8A-2 | Abrir a 1366px | Los 3 paneles siguen visibles, se ajustan proporcionalmente | |
| 8A-3 | Abrir a 375px (mobile) | Paneles se apilan verticalmente: páginas arriba, canvas medio, editor abajo | |
| 8A-4 | Cambiar de 1920 → 375 → 1920 | Layout se adapta sin romperse, sin scroll horizontal no deseado | |
| 8A-5 | Verificar que los recuadros de texto no se desalinean al redimensionar | Posición de bloques se mantiene exacta en cualquier tamaño | |

### 8D: Keyboard shortcuts

| # | Paso | Esperado | Resultado |
|---|------|----------|-----------|
| 8D-1 | Presionar `D` | Activa modo dibujo (igual que botón "Nuevo") | |
| 8D-2 | Presionar `V` | Desactiva modo dibujo, vuelve a modo selección | |
| 8D-3 | Seleccionar un bloque y presionar `Delete` | Bloque eliminado de la lista | |
| 8D-4 | Hacer un cambio (mover bloque) y presionar `Ctrl+Z` | Acción deshecha, bloque vuelve a posición anterior | |
| 8D-5 | Presionar `Ctrl+E` | Inicia exportación PSD de la página activa | |
| 8D-6 | Tener un bloque seleccionado y presionar `Escape` | Selección se deselecciona | |
| 8D-7 | Tener varios bloques y presionar `Tab` | Selección salta al siguiente bloque | |
| 8D-8 | Verificar que shortcuts no se disparan cuando se está escribiendo en un textarea | Al escribir en el editor de texto, `D`, `V`, `Delete` no hacen nada | |

### 9A: Magic bytes verification

| # | Paso | Esperado | Resultado |
|---|------|----------|-----------|
| 9A-1 | Renombrar un archivo `.txt` a `.jpg` y subirlo | Rechazado con error "El archivo no es una imagen válida" | |
| 9A-2 | Renombrar un `.pdf` a `.png` y subirlo | Rechazado — magic bytes no coinciden con PNG | |
| 9A-3 | Subir un JPEG real (extensión `.jpg`) | Aceptado normalmente | |
| 9A-4 | Subir un PNG real (extensión `.png`) | Aceptado normalmente | |
| 9A-5 | Subir un JPEG pero con extensión `.png` | Rechazado — magic bytes dicen JPEG pero MIME dice PNG | |
| 9A-6 | Subir archivo corrupto (bytes aleatorios) con extensión `.jpg` | Rechazado con error claro | |
| 9A-7 | Subir imagen real de >15MB | Rechazado por límite de tamaño (no por magic bytes) | |
| 9A-8 | Verificar que el error muestra nombre de archivo y razón | Mensaje incluye algo como "nombre.jpg: el archivo no es una imagen válida" | |

### 9B: Auto-compresor de imágenes grandes

| # | Paso | Esperado | Resultado |
|---|------|----------|-----------|
| 9B-1 | Subir imagen JPEG de 3MB (< 10MB) | Imagen se muestra sin compresión, sin badge | |
| 9B-2 | Subir imagen PNG de 12MB (> 10MB) | Badge "Comprimida para vista" visible en el thumbnail | |
| 9B-3 | Verificar que la imagen comprimida se muestra correctamente en el canvas | Sin distorsión, colores correctos, dimensiones correctas | |
| 9B-4 | Dibujar bloque, escribir texto, exportar PSD | PSD exportado tiene resolución ORIGINAL (verificar dimensiones en Photoshop: imagen original, no la comprimida) | |
| 9B-5 | Verificar en DevTools (Application → Local Storage o State) que `originalBase64Data` existe para imagen >10MB | Campo presente con base64 de la imagen original | |
| 9B-6 | Verificar que `base64Data` (la que usa el canvas) es más pequeña que la original para imagen >10MB | Tamaño reducido (~50-70% del original) | |
| 9B-7 | Subir imagen de 5000x8000px (>10MB) | Se comprime a max 2000px en eje mayor, mantiene proporción | |
| 9B-8 | Subir imagen de 800x600px (<10MB) | No se comprime, dimensiones intactas | |
| 9B-9 | Exportar lote de 5 páginas (2 chicas, 3 grandes) | Todas exportan PSD con resolución original, las 3 grandes muestran badge | |
| 9B-10 | Abrir PSD de imagen comprimida en Photoshop | Verificar que la capa de fondo tiene las dimensiones originales (no las comprimidas) | |

---

## Sprint 2 — Polish + TypeR Export

### 8B: Componentes unificados

| # | Paso | Esperado | Resultado |
|---|------|----------|-----------|
| 8B-1 | Verificar que todos los botones usan mismos tokens de color (zinc/emerald) | Sin botones con colores inconsistentes | |
| 8B-2 | Verificar que inputs tienen mismo estilo (borde, padding, focus ring) | Estilo uniforme en todos los formularios | |
| 8B-3 | Verificar badges (OCR provider, mode, status) usan mismos tokens | Badges consistentes | |

### 8C: Interacciones y transiciones

| # | Paso | Esperado | Resultado |
|---|------|----------|-----------|
| 8C-1 | Hover sobre botones principales | Efecto glow suave | |
| 8C-2 | Click en botón (active) | Scale down sutil (0.97-0.98) | |
| 8C-3 | Abrir panel de configuración | Slide-in desde la derecha | |
| 8C-4 | Cerrar panel | Slide-out suave | |
| 8C-5 | Cargar página con muchas imágenes | Skeleton loaders visibles mientras carga | |
| 8C-6 | Arrastrar bloque en canvas | Movimiento smooth, sin jumping | |

### 9A (Sprint 2): Panel de tipo de globo

| # | Paso | Esperado | Resultado |
|---|------|----------|-----------|
| 9A-S2-1 | Verificar que los 13 tipos de globo aparecen como botones | Todos visibles: dialogue, thought, shout, etc. | |
| 9A-S2-2 | Asignar tipo "shout" a un bloque | Badge "shout" aparece en el canvas overlay del bloque | |
| 9A-S2-3 | Escribir texto con prefijo `!` (scream) y activar auto-detección | Tipo se asigna automáticamente como "shout" | |
| 9A-S2-4 | Cambiar tipo manualmente (override) | La asignación manual prevalece sobre la auto-detección | |
| 9A-S2-5 | Toggle "Asignar símbolos con IA" on/off | Con IA: tipo se sugiere automáticamente. Sin IA: solo manual | |

### 9B (Sprint 2): Reordenamiento de bloques

| # | Paso | Esperado | Resultado |
|---|------|----------|-----------|
| 9B-S2-1 | Arrastrar bloque 3 antes del bloque 1 en la lista | Orden se actualiza, números en canvas reflejan nuevo orden | |
| 9B-S2-2 | Verificar números de orden en canvas | Bloques muestran `[1]`, `[2]`, `[3]` según posición en lista | |
| 9B-S2-3 | Reordenar y exportar PSD | Orden en el .psd respeta el nuevo orden | |

### 9C: Backend generador .docx

| # | Paso | Esperado | Resultado |
|---|------|----------|-----------|
| 9C-1 | Exportar .docx con 5 bloques de tipo "dialogue" | Archivo .docx se descarga | |
| 9C-2 | Abrir .docx en Word/Google Docs | Formato: `[1] (DIALOGUE)\n\ntexto` por cada bloque | |
| 9C-3 | Verificar que tipo "thought" usa símbolo `(THOUGHT)` | Símbolo correcto en el .docx | |
| 9C-4 | Verificar regla del guión: primera frase tras cambio de fuente lleva `-` | Guion presente solo donde corresponde | |
| 9C-5 | Bloque con tipo "narration" | Formato: `[N] (NARRATION)\n\ntexto` | |
| 9C-6 | Endpoint `POST /api/export/docx` con body válido | Responde con Content-Type `application/vnd.openxmlformats-officedocument.wordprocessingml.document` | |

### 9D: Panel exportación + preview

| # | Paso | Esperado | Resultado |
|---|------|----------|-----------|
| 9D-1 | Abrir panel de exportación DOCX | Preview muestra el script formateado | |
| 9D-2 | Cambiar orden de bloques | Preview se actualiza en tiempo real | |
| 9D-3 | Ingresar título del capítulo | Título aparece en el preview | |
| 9D-4 | Toggle "Incluir original" | Bloques muestran texto original + traducción | |
| 9D-5 | Toggle "Incluir coordenadas" | Coordenadas aparecen junto a cada bloque | |

### 9E: Config de símbolos por usuario

| # | Paso | Esperado | Resultado |
|---|------|----------|-----------|
| 9E-1 | Abrir Configuración → Tab de símbolos | Tabla con los 13 tipos y sus símbolos actuales | |
| 9E-2 | Cambiar símbolo de "shout" de `(SHOUT)` a `(!!)` | Cambio se guarda | |
| 9E-3 | Exportar .docx después del cambio | Usa `(!!)` en vez de `(SHOUT)` | |
| 9E-4 | Refrescar la app | Los símbolos custom persisten (localStorage) | |
| 9E-5 | Cambiar símbolo en el preview | Preview actualiza en tiempo real | |

---

## Tests de Regresión (ejecutar antes de cada release)

| # | Paso | Esperado | Resultado |
|---|------|----------|-----------|
| R-1 | Subir imagen JPEG → Detectar texto (AI mode) | OCR detecta bloques, traduce, muestra en canvas | |
| R-2 | Subir imagen PNG → Detectar texto (AI mode) | Mismo resultado que R-1 | |
| R-3 | Dibujar región → Detectar y traducir | Texto detectado y traducido en la región dibujada | |
| R-4 | Cambiar idioma origen a Japonés → Detectar texto | Prompt usa código ISO del idioma seleccionado | |
| R-5 | Exportar PSD individual | Archivo .psd descargado, capas correctas | |
| R-6 | Exportar lote ZIP | ZIP contiene todos los .psd, cada uno correcto | |
| R-7 | Modo Manual → dibujar → escribir → exportar | Funciona sin llamadas a red | |
| R-8 | `npm run lint` y `npm run build` | Sin errores | |
