---
created: 2026-07-11
tags:
  - tipo/zettel
  - tech/audio
aliases:
  - WirePlumber default-nodes
  - audio loopback residual
---

# WirePlumber default-nodes persiste y puede apuntar a dispositivos eliminados

## Lo que aprendí
WirePlumber guarda default-nodes en `~/.local/state/wireplumber/default-nodes`. Si apunta a un dispositivo eliminado (ej: `snd_aloop`), el audio vuelve al loopback en cada reinicio. Limpiar manualmente con `wpctl set-default <id>` + editar el state file. Configurar `api.acp.auto-profile = true` en `~/.config/wireplumber/wireplumber.conf.d/50-audio-defaults.conf` para selección automática de profile.

## Contexto
2026-06-23 en CachyOS. Después de desinstalar `snd_aloop`, el audio seguía yendo al loopback.

## Aplicación
Al eliminar dispositivos de audio virtuales: verificar y limpiar `~/.local/state/wireplumber/default-nodes`. Configurar auto-profile para evitar problemas futuros.

## Conexiones
- [[audio-cambiar-perfil-tarjeta]]
- [[mic-virtual-pipewire-loopback]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
