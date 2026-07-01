---
tags: [linux, audio, bluetooth, pipewire, celular, microfono, discord]
fecha: 2026-07-01
estado: planificado
---

# Audio en Linux: Buds 8 Lite + Celular como micrófono

## Contexto

**Sistema:** PipeWire 1.6.7 + WirePlumber 0.5.15 (stack moderno, bien soportado)
**Dispositivos:**
- REDMI Buds 8 Lite → MAC `54:84:50:E5:B0:9C`
- Redmi Note 13 5G → MAC `B4:05:A1:1F:FF:1D`
- Mic integrado → `alsa_input.pci-0000_00_1f.3.analog-stereo`

---

## Problema 1: REDMI Buds 8 Lite — A2DP vs HFP

### Diagnóstico
Los Buds tienen dos modos incompatibles entre sí:

| Perfil | Calidad audio salida | Micrófono | Uso ideal |
|--------|---------------------|-----------|-----------|
| **A2DP** (actual) | Alta (AAC/SBC-XQ) | ❌ No | Música, videojuegos |
| **HFP mSBC** | Baja (16kHz) | ✅ Sí | Discord, llamadas |
| **HFP CVSD** | Muy baja (8kHz) | ✅ Sí | Llamadas básicas |

**Limitación de Bluetooth:** A2DP y HFP no pueden coexistir en el mismo dispositivo. Hay que elegir uno u otro.

### Solución A — Scripts de toggle A2DP ↔ HFP

Cambiar perfil desde terminal:
```bash
# → Modo Discord (HFP con mic, audio baja calidad)
pactl set-card-profile bluez_card.54_84_50_E5_B0_9C headset-head-unit

# → Modo música/juegos (A2DP sin mic, audio alta calidad)
pactl set-card-profile bluez_card.54_84_50_E5_B0_9C a2dp-sink
```

Cuando los Buds están en modo HFP, aparecen como:
- **Sink** (salida): `bluez_output.54_84_50_E5_B0_9C.1`
- **Source** (micrófono): `bluez_input.54:84:50:E5:B0:9C`

Script de toggle en `~/.local/bin/toggle-buds-mode`:
```bash
#!/bin/bash
CARD="bluez_card.54_84_50_E5_B0_9C"
CURRENT=$(pactl list cards 2>/dev/null | grep -A2 "$CARD" | grep "Active Profile" | awk '{print $3}')

if [[ "$CURRENT" == a2dp* ]]; then
    pactl set-card-profile "$CARD" headset-head-unit
    notify-send "Buds 8 Lite" "Modo Discord (HFP) — micrófono activado"
else
    pactl set-card-profile "$CARD" a2dp-sink
    notify-send "Buds 8 Lite" "Modo música (A2DP) — alta calidad"
fi
```

---

## Problema 2: Celular como micrófono

### Por qué Iriun no funcionó bien
Iriun es principalmente para **cámara web**, con soporte de audio limitado en Linux. No integra nativamente con PipeWire.

### Opción 1 — scrcpy 4.0 (RECOMENDADA para empezar)

**Ventajas:** Ya está en repos de CachyOS, `adb` ya instalado, sin apps extra en el celular (solo depuración USB/WiFi).

**Instalación:**
```bash
sudo pacman -S scrcpy
```

**Uso básico (USB):**
```bash
# Habilitar USB debugging en el celular (Ajustes → Opciones de desarrollador)
adb devices         # verificar que detecta el celular
scrcpy --audio-source=mic --no-video
```

**Uso por WiFi (sin cable):**
```bash
# Con celular conectado por USB la primera vez:
adb tcpip 5555
adb connect 192.168.X.X:5555   # IP del celular en la red local
# Desconectar USB y ejecutar:
scrcpy --audio-source=mic --no-video
```

**Integrar como fuente de micrófono en PipeWire:**
scrcpy redirige el audio del mic del celular al sink por defecto. Para usarlo como fuente en Discord/apps:
```bash
# Crear loopback virtual (el audio del celular → virtual mic)
pw-loopback --capture-props='media.class=Audio/Sink' \
            --playback-props='media.class=Audio/Source' &
```
→ En Discord, seleccionar "scrcpy audio" como micrófono de entrada.

**Script completo `~/.local/bin/celular-mic`:**
```bash
#!/bin/bash
# Celular como microfono via scrcpy + loopback PipeWire
case "${1:-start}" in
    start)
        echo "Iniciando mic del celular..."
        scrcpy --audio-source=mic --no-video --audio-codec=opus &
        notify-send "Celular como mic" "Conectado. Seleccionar en Discord."
        ;;
    stop)
        pkill -f "scrcpy.*audio-source=mic"
        notify-send "Celular como mic" "Desconectado"
        ;;
    wifi)
        IP="${2:-}"
        if [ -z "$IP" ]; then
            echo "Uso: celular-mic wifi <IP_CELULAR>"
            exit 1
        fi
        adb connect "$IP:5555"
        scrcpy --audio-source=mic --no-video --audio-codec=opus &
        notify-send "Celular como mic" "Conectado por WiFi ($IP)"
        ;;
esac
```

### Opción 2 — WO Mic (dedicada, más estable)

**Ventajas:** Herramienta específica para mic por red, muy estable, baja latencia, funciona por USB/WiFi/BT.

**Instalación:**
```bash
# App en celular: "WO Mic" en Google Play (gratis)
yay -S womic    # cliente Linux (AUR)
```

**Configuración:**
1. Abrir WO Mic en el celular → conectar por WiFi
2. En Linux:
   ```bash
   womic -t wifi -h 192.168.X.X    # IP del celular
   ```
3. WO Mic crea `/dev/womic` que PipeWire detecta automáticamente como fuente.

**Diferencia vs scrcpy:** WO Mic tiene menor latencia y es más estable para uso continuo en Discord. scrcpy es más conveniente (ya disponible).

### Opción 3 — DroidCam (cámara + mic)

Si también necesitas cámara web del celular:
```bash
yay -S droidcam
# App: DroidCam en Play Store
```
Crea `/dev/video` (cámara) y fuente de audio PipeWire (mic).

---

## Configuración recomendada por escenario

### Discord + videojuegos (con Buds 8 Lite)

**Escenario A — Simple:** HFP en los Buds (mic integrado en auriculares)
```bash
toggle-buds-mode   # activa HFP
# Discord detecta automáticamente mic de los Buds
```
⚠️ Audio del juego en los Buds bajará calidad a 16kHz.

**Escenario B — Mejor calidad:** A2DP en Buds + celular como mic
```bash
# Los Buds quedan en A2DP (audio de alta calidad)
celular-mic start      # mic del celular por scrcpy o WO Mic
# En Discord: Output → Buds 8 Lite, Input → celular mic
```

### Gestión de audio por aplicación

PipeWire permite enrutar apps individualmente sin afectar el sistema global:

```bash
# Ver sinks/sources disponibles
pactl list sinks short
pactl list sources short

# Mover Discord específicamente a un sink
pactl move-sink-input <DISCORD_INPUT_ID> <SINK_ID>
```

**GUI más cómoda:** instalar `qpwgraph` o `pavucontrol`:
```bash
sudo pacman -S pavucontrol    # interfaz para PulseAudio/PipeWire
sudo pacman -S qpwgraph       # graph visual de PipeWire (más potente)
```
`pavucontrol` tiene pestaña "Playback" donde puedes mover cada app a cualquier sink con un clic.

---

## Plan de implementación

- [ ] Instalar `scrcpy` → `sudo pacman -S scrcpy`
- [ ] Probar mic del celular por USB: `scrcpy --audio-source=mic --no-video`
- [ ] Crear script `toggle-buds-mode` en `~/.local/bin/`
- [ ] Crear script `celular-mic` en `~/.local/bin/`
- [ ] Instalar `pavucontrol` para gestión visual de audio
- [ ] Agregar keybind en Hyprland para `toggle-buds-mode`
- [ ] Probar escenario B (A2DP + celular mic) en Discord
- [ ] Si scrcpy no satisface → probar WO Mic (AUR)

---

## Referencia rápida de comandos

```bash
# Estado actual de audio
pactl list sinks short && pactl list sources short

# Bluetooth: ver perfil activo de los Buds
pactl list cards 2>/dev/null | grep -A5 "54_84_50"

# Toggle A2DP ↔ HFP
toggle-buds-mode

# Celular como mic (USB)
celular-mic start

# Celular como mic (WiFi, dar IP del celular)
celular-mic wifi 192.168.1.X

# GUI de audio
pavucontrol
qpwgraph
```

---

## Notas y limitaciones conocidas

- Bluetooth **no puede** tener A2DP y HFP activos simultáneamente en el mismo dispositivo
- scrcpy `--audio-source=mic` requiere Android 11+ en el celular (Redmi Note 13 5G lo cumple)
- WO Mic WiFi puede tener latencia de ~50-100ms (aceptable para voz, no para música)
- El mic integrado del equipo (`alsa_input.pci-0000_00_1f.3`) siempre está disponible como fallback
