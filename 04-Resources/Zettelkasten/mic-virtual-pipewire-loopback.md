---
created: 2026-07-11
tags:
  - tipo/zettel
  - tech/audio
aliases:
  - virtual mic
  - pw-loopback
  - loopback pipewire
---

# Micrófono virtual permanente con PipeWire loopback

## Lo que aprendí
Para crear un micrófono virtual permanente: configurar en `~/.config/pipewire/pipewire.conf.d/10-virtual-mic.conf` con módulo loopback. Temporal: `pw-loopback --capture-props='media.class=Audio/Source ...'`. El volumen del micrófono desde celular suele ser bajo — necesita amplificación >100%.

## Contexto
2026-06-21 en CachyOS. Se usaba AudioSource (celular como micrófono via ADB) y se necesitaba un sink virtual.

## Aplicación
Para micrófonos virtuales: PipeWire loopback es más limpio que ALSA loopback (`snd_aloop`). Configurar en conf.d para persistencia.

## Conexiones
- [[pipewire-default-nodes-limpiar]]
- [[audio-cambiar-perfil-tarjeta]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
