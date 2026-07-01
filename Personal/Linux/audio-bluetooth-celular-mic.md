---
tags: [linux, audio, bluetooth, pipewire, celular, microfono, discord]
fecha: 2026-07-01
estado: en-progreso
---

# Audio en Linux: Buds 8 Lite + Celular como micrófono

## Por qué la interfaz parece rota (y no lo está)

La confusión de pavucontrol/qpwgraph viene de cómo funciona Bluetooth:

```
Modo A2DP  →  sistema ve:  [Buds SALIDA]              (sin micrófono)
Modo HFP   →  sistema ve:  [Buds SALIDA] + [Buds MIC]  (aparece el mic)
```

Cuando cambias de modo en la pestaña "Configuración", los dispositivos en otras
pestañas cambian porque el hardware Bluetooth literalmente expone diferentes
canales según el perfil activo. No es un bug, es el protocolo.

**La restricción fundamental de Bluetooth:**

| Perfil | Audio salida | Micrófono | Cuándo usarlo |
|--------|-------------|-----------|---------------|
| A2DP   | Alta calidad (AAC) | ❌ No disponible | Música, juegos |
| HFP    | Calidad llamada (16kHz) | ✅ Sí | Discord, llamadas |

No existe A2DP + mic Bluetooth al mismo tiempo en el mismo dispositivo.
La solución para tener ambos es usar el celular como micrófono por red.

---

## Sistema actual

- **PipeWire 1.6.7** + WirePlumber 0.5.15
- **REDMI Buds 8 Lite** → MAC `54:84:50:E5:B0:9C` (conectados en A2DP)
- **Redmi Note 13 5G** → MAC `B4:05:A1:1F:FF:1D`
- **Mic integrado** → `alsa_input.pci-0000_00_1f.3.analog-stereo`

---

## Soluciones

### Opción A — HFP (más simple, sin celular)

Un comando alterna entre modo música y modo Discord:

```bash
toggle-buds-mode
```

- **Pros:** Sin apps extra, funciona sin celular
- **Contras:** El audio de los Buds baja a calidad de llamada mientras Discord está activo

### Opción B — WO Mic (recomendada para mejor calidad)

Buds en A2DP para audio de alta calidad + celular como micrófono por WiFi.

**Instalación (una sola vez):**
```bash
# Cliente Linux
yay -S womic

# App en el celular: buscar "WO Mic" en Google Play (gratis, de Yuanshao.com)
```

**Uso diario:**
```bash
mic-celular           # inicia (necesita IP del celular en la red)
mic-celular stop      # detiene
```

WO Mic crea un dispositivo virtual automáticamente — no hay que configurar
ninguna interfaz. Discord lo ve como cualquier otro micrófono.

**Para saber la IP del celular:** Ajustes → WiFi → (tocar la red actual) → ver IP

### Opción C — scrcpy (ya en repos, sin app extra)

```bash
# Requiere USB debugging activado en el celular
sudo pacman -S scrcpy
```

⚠️ **NO usar con pw-loopback** — eso hace que te oigas a ti mismo.
El enfoque correcto con scrcpy usa un null sink (ver sección Scripts).

---

## Scripts instalados en `~/.local/bin/`

### `toggle-buds-mode` — alterna A2DP ↔ HFP

```bash
#!/bin/bash
CARD="bluez_card.54_84_50_E5_B0_9C"
CURRENT=$(pactl list cards 2>/dev/null \
    | grep -A50 "$CARD" \
    | grep "Active Profile:" \
    | awk '{print $3}')

if [[ "$CURRENT" == a2dp* ]]; then
    pactl set-card-profile "$CARD" headset-head-unit
    echo "→ Modo HFP: micrófono disponible (audio calidad llamada)"
    notify-send -i audio-headset "Buds 8 Lite" "Modo Discord — mic activado\nAudio: calidad llamada"
else
    pactl set-card-profile "$CARD" a2dp-sink
    echo "→ Modo A2DP: audio de alta calidad (sin micrófono)"
    notify-send -i audio-headphones "Buds 8 Lite" "Modo música — A2DP\nAudio: alta calidad"
fi
```

### `mic-celular` — celular como micrófono vía WO Mic

```bash
#!/bin/bash
# Requiere: yay -S womic  +  app "WO Mic" en el celular
CONFIG="$HOME/.config/mic-celular.ip"

case "${1:-}" in
    stop)
        pkill -f womic && notify-send "Mic celular" "Desconectado"
        exit 0 ;;
    "")
        if [ -f "$CONFIG" ]; then
            IP=$(cat "$CONFIG")
        else
            read -rp "IP del celular (ej: 192.168.1.X): " IP
            echo "$IP" > "$CONFIG"
        fi ;;
    *)
        IP="$1"
        echo "$IP" > "$CONFIG" ;;
esac

notify-send "Mic celular" "Conectando a $IP..."
womic -t wifi -h "$IP"
```

### `status-audio` — ver estado actual sin abrir interfaces

```bash
#!/bin/bash
echo "=== SALIDA ==="
pactl list sinks short | awk '{printf "  %s\n  Estado: %s\n\n", $2, $5}'

echo "=== ENTRADA (micrófonos) ==="
pactl list sources short | grep -v monitor | awk '{printf "  %s\n  Estado: %s\n\n", $2, $5}'

echo "=== BUDS - perfil activo ==="
pactl list cards 2>/dev/null \
    | grep -A50 "54_84_50_E5_B0_9C" \
    | grep "Active Profile:" \
    | sed 's/.*Active Profile: /  /'
```

---

## Flujo de trabajo diario

### Música / videojuegos
```
(no hacer nada — Buds en A2DP por defecto)
```

### Discord con mic de los Buds
```bash
toggle-buds-mode        # cambia a HFP
# abrir Discord, seleccionar "REDMI Buds 8 Lite" como mic
# al terminar:
toggle-buds-mode        # vuelve a A2DP
```

### Discord con mic del celular (mejor calidad de voz)
```bash
mic-celular             # conecta WO Mic (primera vez pide IP)
# Discord detecta "WO Mic" como micrófono automáticamente
# audio de los Buds sigue en A2DP (alta calidad)
# al terminar:
mic-celular stop
```

### Ver qué está pasando con el audio
```bash
status-audio
```

---

## Plan de implementación

- [x] Entender el modelo mental (A2DP vs HFP)
- [ ] Crear script `toggle-buds-mode` en `~/.local/bin/`
- [ ] Crear script `mic-celular` en `~/.local/bin/`
- [ ] Crear script `status-audio` en `~/.local/bin/`
- [ ] Instalar WO Mic: `yay -S womic`
- [ ] Instalar WO Mic en el celular (Google Play)
- [ ] Probar `toggle-buds-mode` + Discord (Opción A)
- [ ] Probar `mic-celular` + Discord (Opción B)
- [ ] Agregar keybind en Hyprland para `toggle-buds-mode`

---

## Por qué NO usar pw-loopback con scrcpy

`pw-loopback` conecta una salida a una entrada — cuando scrcpy reproduce el
audio del celular en los parlantes/Buds, el loopback lo recaptura y crea un
ciclo. Por eso te oías a ti mismo. El enfoque correcto sería un null sink
(sumidero virtual sin salida física), pero eso requiere más pasos manuales.
WO Mic resuelve todo esto automáticamente.

---

## Comandos de referencia rápida

```bash
# Estado de audio sin abrir GUI
status-audio

# Toggle A2DP ↔ HFP
toggle-buds-mode

# Mic del celular
mic-celular              # conectar (pide IP la primera vez)
mic-celular 192.168.1.X  # conectar con IP específica
mic-celular stop         # desconectar

# Ver el nombre exacto del card de los Buds
pactl list cards short
```
