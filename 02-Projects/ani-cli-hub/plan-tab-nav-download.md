# Plan: Tab Navigation + Episode Actions + Download Manager

**Branch**: `feature/hub-tabs-library-playback`
**Core**: `~/proyectos/ani-cli-hub/ani-cli-mx-core`

---

## Cambios solicitados

1. **Tabs no auto-activan**: Tab/numeros solo marcan, Enter activa. Flechas llegan al tab bar desde el grid.
2. **Episode action**: Al seleccionar episodio, mostrar "Reproducir" / "Descargar" debajo de la miniatura.
3. **Download manager**: Cola de descargas con barra de progreso multi-color en la parte inferior. Max 5 simultáneas, wrap a segunda fila después de 3.
4. **Tab Descargas**: Nuevo tab que muestra archivos descargados, abre con vlc.

---

## Success Criteria

- Tab key cicla highlight sin activar; Enter activa el tab resaltado
- Flecha arriba desde primera fila del grid mueve foco al tab bar
- Flechas izq/der en tab bar navegan entre tabs
- Al seleccionar episodio aparecen 2 opciones: Reproducir / Descargar
- Descarga corre en background con barra de progreso visible
- Max 5 descargas simultáneas con colores diferenciados
- Tab "Descargas" muestra archivos .mp4 del directorio de descargas
- `bash -n` y `t/verify.sh` pasan

---

## Fase A: Tab Navigation Refactor

### A1. Nuevas variables de estado

Agregar al inicio de `show_card_grid` (antes del while):
```bash
CG_TAB_SEL="${CG_TAB_ACTIVE:-0}"   # tab resaltado (puede ser distinto del activo)
CG_TAB_FOCUS=0                      # 0=grid, 1=tab bar
```

### A2. `_cg_header` — dos indicadores visuales

Modificiar la línea 0 para mostrar:
- `CG_TAB_ACTIVE` con estilo active (fondo colorido — ya existe `c_tab_active`)
- `CG_TAB_SEL` con estilo de focus/subrayado cuando `CG_TAB_SEL != CG_TAB_ACTIVE`
- Cuando `CG_TAB_FOCUS=1`, el tab resaltado tiene un indicador extra (e.g., `▸` o borde)

### A3. Key handling — focus switching

**Cuando `CG_TAB_FOCUS=0` (grid)**:
- `$'\033[A'|k` (arriba): si `sel < ncols` (primera fila), set `CG_TAB_FOCUS=1`, render tab bar con focus
- Tab/numeros: solo cambian `CG_TAB_SEL`, repaint header. NO retornan `TAB:`.
- Enter: si `CG_TAB_SEL != CG_TAB_ACTIVE`, emitir `TAB:CG_TAB_SEL`. Si es igual, comportamiento normal (seleccionar item).

**Cuando `CG_TAB_FOCUS=1` (tab bar)**:
- `$'\033[C'|l` (derecha): `CG_TAB_SEL = min(CG_TAB_SEL+1, ntabs-1)`, repaint
- `$'\033[D'|h` (izquierda): `CG_TAB_SEL = max(CG_TAB_SEL-1, 0)`, repaint
- Enter: emitir `TAB:CG_TAB_SEL`, set `CG_TAB_FOCUS=0`
- `$'\033[B'|j` (abajo): `CG_TAB_FOCUS=0`, repaint grid con focus
- Tab: ciclar `CG_TAB_SEL`, repaint
- Escape/q: salir

### A4. `_cg_paint` — respetar focus mode

Cuando `CG_TAB_FOCUS=1`, el grid se dibuja normal pero el header tiene el indicador de focus en el tab seleccionado.

### A5. Hub loop —接收 TAB de任一来源

El handler `TAB:*` en el hub loop ya funciona — no cambia. Solo cambia CÓMO se genera el payload.

---

## Fase B: Episode Action Selection

### B1. `select_episode_action()` — nueva función

Después de `select_episode_grid` retorna `ep_no`, mostrar 2 opciones:

```bash
select_episode_action() {
    # $1 = img_path, $2 = title, $3 = ep_no
    # Renderiza dos "botones" debajo de la última posición del cursor
    # Usa read -rsn1 para capturar ←/→ y Enter
    # Retorna: "play" o "download"
}
```

Implementación mínima: dos líneas de texto estilizadas:
```
  ▶ Reproducir    ⬇ Descargar
```
Flechas mueven highlight, Enter selecciona.

Ubicación: debajo del header del grid de episodios, o como overlay minimalista.

### B2. Integrar en hub loop

En la rama `0|2|4` del hub loop, después de `select_episode_grid`:

```bash
ep_no=$(printf "%s\n" "$ep_list" | select_episode_grid "$id" "$img_path")
[ -z "$ep_no" ] && continue
action=$(select_episode_action "$img_path" "$title" "$ep_no")
case "$action" in
    download) dl_enqueue "$id" "$ep_no" "$title"; continue ;;
    *) ;;  # play — continuar al flujo normal
esac
```

---

## Fase C: Download Manager

### C1. Cola y estado

Variables globales:
```bash
declare -a DL_QUEUE=()    # "pid|file|status|progress|color"
DL_MAX=5
DL_DIR="${ANI_CLI_DOWNLOAD_DIR:-$HOME/Downloads/ani-cli}"
DL_COLORS=("\033[38;5;204m" "\033[38;5;46m" "\033[38;5;117m" "\033[38;5;220m" "\033[38;5;171m")
# rosa, verde, celeste, amarillo, morado
```

### C2. `dl_enqueue()`

```bash
dl_enqueue() {
    local id="$1" ep="$2" title="$3"
    # Contar slots activos
    local active=0
    for entry in "${DL_QUEUE[@]}"; do
        [[ "$entry" == *"running"* ]] && active=$((active+1))
    done
    # Si >= DL_MAX, agregar a pending
    if [ "$active" -ge "$DL_MAX" ]; then
        DL_QUEUE+=("0|${title}_ep${ep}|pending|0|0")
        return
    fi
    # Lanzar download en background
    _dl_start "$id" "$ep" "$title"
}
```

### C3. `dl_start()` — lanza descarga

```bash
_dl_start() {
    local id="$1" ep="$2" title="$3"
    local safe_name=$(printf '%s' "${title}_ep${ep}" | tr ' /' '_')
    local logfile=$(mktemp)
    # Obtener URL y lanzar download en background
    (
        # Obtener URL del episodio
        local url=$(get_episode_url_for_download "$id" "$ep")
        [ -z "$url" ] && exit 1
        # Lanzar yt-dlp/aria2c con output a logfile
        download "$url" "$safe_name" 2>"$logfile"
    ) &
    local pid=$!
    DL_QUEUE+=("$pid|${safe_name}|running|0|${#active_downloads}|$logfile")
}
```

### C4. `dl_monitor()` — loop de progreso

```bash
dl_monitor() {
    # Se ejecuta en background o como parte del render loop
    while true; do
        dl_render_bars
        sleep 1
        dl_check_completed
    done
}
```

### C5. `dl_render_bars()` — barras multi-color

Posición: últimas 2-4 líneas de la terminal (dependiendo de cuántas barras).

Layout para 1 descarga:
```
[████████████████░░░░░░░░░░░░░░] Anime ep1 — 67%
```

Para 2 descargas (50/50):
```
[████████████░░░░░░░░][░░░░░░░░░░░░░░░░░░░░]
  Anime ep1 — 45%        Anime ep2 — 12%
```

Para 3+ descargas: wrap a segunda fila.

Colores por slot:
- Slot 0: rosa `\033[38;5;204m` (bright red-pink)
- Slot 1: verde `\033[38;5;46m` (bright green)
- Slot 2: celeste `\033[38;5;117m` (bright cyan)
- Slot 3: amarillo `\033[38;5;220m`
- Slot 4: morado `\033[38;5;171m`

Cada barra: ancho = `term_cols / min(active_count, 3)` (o similar).

Progreso: parsear output de yt-dlp (`--newline`) o leer `/proc/$pid/fd` para aria2c.

### C6. Integración con grid render

El render loop del grid (`show_card_grid`) necesita reservar espacio inferior para las barras de descarga. Cuando hay descargas activas:
- `vis_rows` se reduce para dejar espacio a las barras
- `_cg_paint` deja las últimas N líneas libres
- Barras se pintan después de `_cg_paint` y se actualizan periódicamente

---

## Fase D: Tab Descargas

### D1. Nuevo tab

Agregar `"Descargas"` al `hub_tabs`:
```bash
hub_tabs="Catálogo|Recientes|Favoritos|Semana|Biblioteca|Descargas"
```

### D2. `show_downloads_grid()`

```bash
show_downloads_grid() {
    local dl_dir="${ANI_CLI_DOWNLOAD_DIR:-$HOME/Downloads/ani-cli}"
    [ -d "$dl_dir" ] || return 1
    # Listar .mp4, construir data_file para show_card_grid
    # Si hay thumbs en cache, usarlas. Si no, placeholder.
    # payload: solo el filename (para abrir con vlc)
}
```

### D3. Hub loop case 5 (Descargas)

```bash
5)  # Descargas
    result=$(show_downloads_grid)
    case "$result" in
        TAB:*) hub_view="${result#TAB:}"; continue ;;
        "") continue ;;
    esac
    # Abrir con vlc
    vlc "$DL_DIR/$result" &
    continue
    ;;
```

---

## Orden de implementación

1. **Fase A** (Tab Navigation) — cambios a `show_card_grid` y `_cg_header`
2. **Fase B** (Episode Action) — nueva función + integrar en hub loop
3. **Fase D** (Tab Descargas) — nuevo tab, más simple que C
4. **Fase C** (Download Manager) — la más compleja, requiere integración con el render loop

Razón: A y B son UI changes puros. D es un tab nuevo simple. C requiere Background process management + render integration.

---

## Risk Assessment

| Riesgo | Mitigación |
|--------|-----------|
| Tab focus state rompe navigate existente | Mantener `CG_TAB_FOCUS=0` como default; test con `t/verify.sh` |
| Download progress parse falla con diferentes versiones de yt-dlp | Fallback a mostrar spinner indeterminado |
| Barras de descarga comen espacio del grid | Reducir `vis_rows` dinámicamente; test con `t/verify.sh` |
| Max 5 downloads + wrap de fila complica render | Limitar a 2 filas de barras (6 slots visuales), pending queue otherwise |

---

## Affected Files

- `ani-cli-mx-core` — todo el cambio es en este archivo
  - `show_card_grid()` (~line 1380-1570): tab focus + arrow-to-tabs
  - `_cg_header()` (~line 1383): dual indicator
  - Hub loop (~line 3625-3710): episode action + download tab
  - New functions: `select_episode_action()`, `dl_enqueue()`, `dl_monitor()`, `dl_render_bars()`, `show_downloads_grid()`
  - `download()` (~line 3080): adaptar para background execution

---

## Open Questions

- [ ] Para el parse de progreso de yt-dlp: ¿usar `--newline` y leer stdout del background process? ¿O usar un temp file?
- [ ] Para el render de barras durante navegación del grid: ¿intercalar con el render del grid (timed) o usar un subshell separado?
- [ ] ¿vlc se lanza con `--play-and-exit` para que no se quede abierto?

---

## Test Strategy

1. `bash -n ani-cli-mx-core` — syntax check tras cada fase
2. `t/verify.sh` — grid integrity check
3. Manual test con `ani-dev --browse`:
   - Tab cycling without activation
   - Arrow navigation to tab bar
   - Enter to activate tab
   - Episode selection → Play/Download prompt
   - Download progress bar rendering
   - Descargas tab listing
