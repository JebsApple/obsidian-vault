---
tags: [proyecto, deriva, desktop, widgets, física, python, wayland]
status: definición
fecha: 2026-06-21
---

# Deriva — Sistema de Widgets Flotantes con Física

Sistema de overlays flotantes para Hyprland con física real: bobbing continuo, inercia al arrastrar, colisiones entre objetos. Funciona como capa visual encima del wallpaper.

---

## Concepto central

Ventanas sin bordes del sistema (borderless) que viven sobre el wallpaper. Pueden contener cualquier tipo de contenido y se comportan con física de "objetos flotando en agua".

---

## Modos de comportamiento

### Modo `anclado`
- Se puede arrastrar de lugar
- Al soltar, se mueve con inercia pero **vuelve a la posición de origen**
- Pensado para widgets de configuración o info que deben tener orden
- Ejemplo: panel de status, bloc de notas

### Modo `libre`
- Física completa: bobbing + inercia + colisiones
- Puede aparecer y desaparecer aleatoriamente (con fade)
- No tiene posición fija
- Ejemplo: imagen decorativa, carta flotando, foto de la monita

---

## Física requerida

| Comportamiento | Descripción |
|---------------|-------------|
| Bobbing continuo | Vaivén suave y lento mientras el objeto está quieto (senoidal) |
| Inercia al soltar | Al soltar tras arrastrar, sigue moviéndose y frena gradualmente |
| Snap-back | Solo en modo `anclado`: spring force de regreso al home |
| Colisiones | Los objetos se empujan entre sí al tocarse |

---

## Tipos de contenido (widgets)

| Tipo | Descripción |
|------|-------------|
| `image` | PNG/JPG estático flotando (carta, papel anime, sticker) |
| `gallery` | Slideshow de carpeta, imágenes preseleccionadas con crossfade |
| `status` | Panel de sistema: hora, fecha, CPU, RAM, red, apps recientes |
| `notepad` | Texto editable que persiste en archivo |
| `clock` | Reloj grande standalone |
| `nowplaying` | Canción actual via playerctl |
| `gif` | GIF animado flotante |
| *(futuro)* | `terminal`, `clima`, `video` |

---

## Creación y configuración

- **Config TOML** (`~/.config/deriva/config.toml`): para widgets fijos/anclados, se definen ahí con posición, tamaño, modo, contenido
- **CLI** (`derivactl add/remove/list`): para widgets libres/decorativos del momento
- GUI: fuera de scope por ahora

---

## Estética objetivo

- Ventanas sin bordes de sistema
- Interactuables (las de config) o decorativas (pass-through de clicks)
- Estilos visuales: panel tech-azul, papel estilo anime, sticker, etc.
- Animaciones de entrada/salida (fade, slide)

---

## Stack técnico

- **Python 3** — lenguaje principal
- **GTK4** — ya instalado (`python-gobject 3.56.3`)
- **gtk4-layer-shell** — ya instalado, permite overlay sobre el desktop en Wayland
- **GLib main loop** — para el loop de física
- **psutil** — métricas de sistema (CPU, RAM, red)
- **TOML** — config
- **argparse** — CLI

---

## Etapas

### Etapa 1 — Motor base (MVP)
- [ ] Ventana GTK4 + layer-shell por widget (overlay Wayland)
- [ ] Modo `anclado`: drag + inercia + snap-back
- [ ] Modo `libre`: drag + inercia + bobbing continuo
- [ ] Tipo `image`: carga y muestra PNG/JPG
- [ ] Config TOML básico: posición, tamaño, modo, ruta
- [ ] `deriva` daemon + `derivactl start/stop`

### Etapa 2 — Widgets de contenido
- [ ] Tipo `gallery`: slideshow con crossfade
- [ ] Tipo `status`: hora, fecha, CPU, RAM, red (psutil)
- [ ] Tipo `notepad`: texto editable, persistencia
- [ ] `derivactl add <tipo> [opciones]` / `derivactl remove <nombre>`

### Etapa 3 — Física avanzada + decorativos
- [ ] Colisiones entre objetos
- [ ] Objetos `libre` con aparición/desaparición aleatoria (fade)
- [ ] Bobbing configurable (velocidad, amplitud)
- [ ] Animaciones de entrada/salida

### Etapa 4 — Premium
- [ ] Tipos: `clock`, `nowplaying`, `gif`
- [ ] Temas visuales (tech-azul, papel-anime)
- [ ] Hot-reload de config (inotify)
- [ ] Múltiples perfiles de desktop

---

## Nombre del proyecto

**Deriva** — de "a la deriva", como objetos flotando sin destino fijo.
