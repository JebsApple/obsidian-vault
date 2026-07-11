---
tags: [investigacion, proyecto/minegocio, camara, imagen, producto]
---

# Foto desde celular — MiNegocio

> Cómo integrar la cámara del celular para fotografiar productos al registrarlos.

## Opciones

### 1. `getUserMedia()` + `<input capture>` (recomendado — cero instalación)

La API `navigator.mediaDevices.getUserMedia()` funciona en Chrome/Edge/Firefox/Safari mobile. No requiere app, no requiere cable USB, no requiere configuración.

**Flujo:**
1. Usuario abre la webapp desde el celular (misma LAN o expuesto via Tailscale/nginx)
2. Botón "Fotografiar" → abre la cámara trasera (`facingMode: "environment"`)
3. Captura → se genera un `Blob` o `File` → se envía al endpoint `/api/productos/{id}/imagen`
4. El backend lo recibe igual que el drag&drop actual (MultipartForm campo "imagen")

**Código mínimo en FormularioProducto.vue:**
```html
<input type="file" accept="image/*" capture="environment" @change="onFileChange">
```
O con preview en vivo:
```js
const stream = await navigator.mediaDevices.getUserMedia({
  video: { facingMode: { exact: "environment" } }
})
video.srcObject = stream
// capturar frame con canvas → canvas.toBlob() → upload
```

**Ventajas:** Sin apps, sin cables, funciona en iOS y Android.
**Desventaja:** El usuario debe abrir la página desde el celular (no desde la PC).

### 2. Compartir cámara del celular como webcam USB

El celular se conecta por USB a la PC y emula una cámara web:

| App | Plataforma | Conexión | Calidad |
|-----|-----------|----------|---------|
| **Iriun Webcam** | Android/iOS | USB o WiFi | 1080p |
| **DroidCam** | Android | USB o WiFi | 720p/1080p |
| **IP Webcam** | Android | HTTP (WiFi) | 1080p+ |

**Luego en la PC:** el `<input type="file" accept="image/*">` puede capturar de esa webcam virtual. O se puede acceder con `getUserMedia()` normal.

**Ventaja:** Usas la PC con la webapp, el celular es solo cámara.
**Desventaja:** Setup extra (instalar app + driver), latencia, menos portable.

### 3. QR / código en pantalla para transferencia rápida

Alternativa ligera: mostrar un **código QR** en la pantalla de registro que abre un mini-sitio para tomar la foto y la envía al endpoint via fetch.

**Flujo:**
1. En la PC → "Agregar foto" → genera token único → muestra QR
2. Celular escanea QR → abre `http://PC:3000/capture?token=abc`
3. Toma foto con `getUserMedia()` → POST al server con el token
4. PC recibe el evento → asigna la foto al producto

**Herramientas:** `qrcode.js` para generar QR, `getUserMedia` para capturar.
**Complejidad:** Media — requiere endpoint extra para pairing token+foto.

### 4. Compartir archivo por red (SAMBA / Snapdrop / PairDrop)

| Método | Descripción |
|--------|-------------|
| **PairDrop** | `pairdrop.net` (self-hosted). Abres en PC y celular → drag&drop la foto → se descarga en la PC. Alternativamente abrir PairDrop desde la webapp y agregar un botón que abra PairDrop en iframe/nueva pestaña. |
| **KDE Connect / GSConnect** | Envía archivos del celular a la PC automáticamente en la misma LAN. Luego se toman desde la carpeta de descargas. |
| **LocalSend** | App FOSS multiplataforma, envía archivos directo por LAN. |
| **Syncthing** | Carpeta compartida entre celular y PC — la foto aparece automáticamente. |

## Recomendación

**Para el Sprint 3:** agregar `capture="environment"` al `<input type="file">` del `FormularioProducto.vue`. Es un cambio de 1 atributo HTML — mínimo esfuerzo, funciona inmediatamente en cualquier celular abriendo la webapp.

```diff
- <input ref="fileInput" type="file" accept="image/jpeg,image/png,image/webp" style="display:none" @change="onFileChange">
+ <input ref="fileInput" type="file" accept="image/*" capture="environment" style="display:none" @change="onFileChange">
```
*ponytail: `capture="environment"` — funciona si el usuario abre la página en el celular. Si requiere captura desde la PC con el celular como cámara externa, implementar getUserMedia con preview.*

En `onFileChange` ya se valida tipo y tamaño — funciona sin cambios adicionales.

Para el caso **PC + celular como cámara externa** (usuario trabajando en la PC): DroidCam o Iriun Webcam por USB, luego en la webapp `getUserMedia({ video: { deviceId: exact-camera-id } })`. Agregar selector de dispositivos si hay más de una cámara disponible.

## Links
- [MDN: capture attribute](https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/capture)
- [MDN: getUserMedia still photos](https://developer.mozilla.org/en-US/docs/Web/API/Media_Capture_and_Streams_API/Taking_still_photos)
- [Iriun Webcam](https://iriun.com/)
- [PairDrop](https://pairdrop.net/)
