---
created: 2026-07-11
tags:
  - tipo/zettel
  - tech/audio
aliases:
  - card profile
  - pactl set-card-profile
  - cambiar salida audio
---

# Cambiar salida de audio = perfil de tarjeta, no solo sink

## Lo que aprendí
En laptops con UNA tarjeta de audio (ej: HDA Intel PCH), integrado y HDMI son perfiles distintos de la misma tarjeta — solo existe UN sink a la vez. Cambiar de salida NO es solo `set-default-sink`:
- **Integrado:** `pactl set-card-profile <card> output:analog-stereo+input:analog-stereo`
- **HDMI:** `set-card-profile <card> output:hdmi-stereo+input:analog-stereo`
- **Bluetooth/USB:** sink aparte → `set-default-sink`

Preferir perfil con `+input:analog-stereo` para conservar el micrófono.

## Contexto
2026-06-25 en CachyOS. Se creó el panel `hypr-audio` y se descubrió que cambiar entre parlantes/HDMI requería cambiar el profile, no solo el sink.

## Aplicación
Al crear controles de audio: detectar si la salida es de la misma tarjeta (profile) o un dispositivo externo (sink). Usar `pactl subscribe` para live updates.

## Conexiones
- [[pipewire-default-nodes-limpiar]]
- [[mic-virtual-pipewire-loopback]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
