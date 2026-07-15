---
tags:
  - project/active
  - tracking
status: active
source_plan: "[[Caelestia-Rice]]"
updated: 2026-07-15
executor: opencode
---

# Caelestia Rice — Plan de ejecución final (para opencode)

Plan original (`Caelestia-Rice.md`) estaba desactualizado. Este doc reemplaza las fases pendientes con instrucciones verificadas y ejecutables sin ambigüedad. Todo lo de abajo fue confirmado leyendo el sistema real el 2026-07-15 — no hay suposiciones.

## Regla de oro: fuente de color única

**NUNCA hardcodear hex.** El scheme cambia con el wallpaper (`caelestia scheme set`). La fuente de verdad es:

```
~/.local/state/caelestia/scheme.json
```

Estructura confirmada (`jq keys`): `.colours`, `.flavour`, `.mode`, `.name`. Los colores están en `.colours.<key>` **sin `#`** (ej: `.colours.primary` → `"c2c1ff"`, hay que anteponer `#` al usarlo en CSS/config).

Keys relevantes disponibles en `.colours`: `background`, `onBackground`, `surface`, `surfaceContainer`, `onSurface`, `primary`, `onPrimary`, `tertiary`, `onTertiary`, `outline`, `term0`..`term15`.

Comando de extracción estándar (usar SIEMPRE esta forma, adaptando la key):
```bash
jq -r '.colours.primary' ~/.local/state/caelestia/scheme.json
```

Antes de cualquier tarea que use color: correr `jq -r '.colours' ~/.local/state/caelestia/scheme.json` y confirmar que el archivo existe y es JSON válido (`jq empty archivo.json`). Si no existe o jq falla, ABORTAR la tarea y reportar el error exacto — no seguir con valores inventados ni copiados de otro lado.

**Crítico — JSON válido no es suficiente.** `jq -r '.colours.primary'` sobre una key que no existe NO falla, devuelve el string literal `null` — que se cuela directo al CSS como `#null` sin que nada lo detecte. Antes de usar CUALQUIER key, validar que existe de verdad:
```bash
jq -e '.colours.primary != null' ~/.local/state/caelestia/scheme.json >/dev/null || { echo "ERROR: key 'primary' no existe en scheme.json"; exit 1; }
```
Si el scheme cambió de variant/flavour, alguna key puede faltar o cambiar de nombre — validar cada key usada, no asumir que las 8-20 keys del ejemplo siguen ahí para siempre.

## Estado ya cerrado (NO TOCAR, ya verificado 2026-07-15)

| Item | Estado | Archivo |
|------|--------|---------|
| Wallpapers | ✅ hecho | `~/Pictures/Wallpapers/caelestia-wallpapers/` |
| Dynamic scheme | ✅ hecho | vía `caelestia scheme` |
| Touchpad/keyboard | ✅ hecho | `~/.config/caelestia/hypr-user.lua` |
| Blur/shadow/gaps | ✅ hecho | `~/.config/hypr/variables.lua`, `decoration.lua` |
| Kitty | ✅ hecho | `~/.config/kitty/kitty.conf` (paleta real extraída, font CaskaydiaCove, opacity 0.85) |
| Starship | ✅ hecho (ya usaba colores ANSI dinámicos, sin cambios) | `~/.config/starship.toml` |
| Thunar (GTK) | ✅ hecho, glass real | `~/.config/gtk-3.0/thunar.css`, `settings.ini` |
| Dolphin (Qt) | ✅ hecho, `ColorScheme=Caelestia` corregido (antes beige roto) | `~/.config/dolphinrc` |
| Btop | ✅ ya estaba correcto | `~/.config/btop/themes/caelestia.theme` |
| Discord (Vencord/BetterDiscord/Vesktop) | ✅ ya estaba hecho y activo | `~/.config/{Vencord,BetterDiscord,vesktop}/themes/caelestia.theme.css` |
| VSCode | ✅ ya estaba hecho | `~/.config/Code/User/settings.json` → `workbench.colorTheme: "Caelestia"` |
| Launcher (fuzzel/caelestia) | ✅ coherente, no configurable más allá de lo que ya está | `~/.config/caelestia/shell.json` |
| Lock screen | ✅ ya coherente — blur y clock widget vienen hardcodeados en el QML del shell (`LockSurface.qml`, `Center.qml`), no son opciones de `shell.json` | N/A |
| Selector de color "3 círculos" (Fase 5 del plan viejo) | ❌ **OBSOLETO — no existe en caelestia-shell instalado.** Confirmado en `/etc/xdg/quickshell/caelestia/modules/nexus/pages/wallandstyle/ColourSelect.qml`: literalmente dice `"Page under construction"` / `"This page will be available in a future update."` No construir nada custom para esto — no es tarea de config, es un placeholder upstream. |
| Cava — colores | ✅ config ya escrito | `~/.config/cava/config` (gradiente con paleta actual) |

**Riesgo conocido a vigilar (no accionable ahora, solo anotarlo)**: `~/.config/gtk-3.0/settings.ini` y `gtk-4.0/settings.ini` (icon-theme=Papirus-Dark) podrían ser sobreescritos si caelestia regenera esos archivos en un futuro cambio de scheme — no se encontró el script generador para hacerlo persistente. Si tras un `caelestia scheme set` el ícono de Thunar vuelve a `breeze`, hay que re-aplicar `gtk-icon-theme-name=Papirus-Dark` en ambos `settings.ini`.

## TAREA 1 — Instalar Cava (requiere el usuario, comando de un solo paso)

**Por qué requiere al usuario**: `pacman -S` necesita sudo, y sudo no funciona desde agentes/Bash tool en este entorno (memoria del usuario: "sudo needs password").

Paso único, exacto, confirmado en repo oficial (no AUR):
```bash
sudo pacman -S cava
```

**Verificación post-instalación (opencode debe correr esto DESPUÉS de que el usuario confirme que corrió el comando, nunca antes)**:
```bash
which cava && cava --version
```
Si `which cava` no devuelve nada, el paquete no quedó instalado — no asumir éxito, reportarlo y detenerse.

**No hay nada más que hacer** — la config (`~/.config/cava/config`) ya existe y ya usa la paleta real. Solo falta el binario.

## TAREA 2 — Instalar y temar Spicetify (requiere el usuario, 2 pasos, con checkpoint de confirmación)

**Por qué requiere confirmación explícita en 2 pasos**: Spicetify modifica archivos internos del cliente de Spotify (parcheo de binario). Si algo sale mal a mitad de proceso, Spotify puede quedar roto y requerir reinstalación. No ejecutar todo de corrido sin que el usuario vea cada paso.

**Una sola confirmación al inicio NO vale para toda la tarea.** Son 2 checkpoints distintos y separados: (a) confirmar que se quiere instalar spicetify-bin, y (b) confirmar cuál tema aplicar (paso 2.2.2). Si el usuario solo respondió "sí, procede" una vez al arrancar, eso cubre el paso 2.1 — NO autoriza a elegir el tema por él ni a correr `apply` sin preguntar cuál de los dos temas prefiere. Si llega al paso 2.2.2 sin una respuesta explícita a "¿dribbblish-dynamic o nord?", detenerse ahí y preguntar — no asumir ninguno de los dos por default.

### Paso 2.1 — Instalación (el usuario corre esto, con `!` o en su terminal)
```bash
yay -S spicetify-bin
```
Confirmado: `yay` está disponible en el sistema. Se eligió `spicetify-bin` sobre `spicetify-cli-git` porque es el paquete binario, estable, actualizado recientemente — no hay razón para compilar desde git en este caso.

**Verificación (opencode corre esto DESPUÉS de que el usuario confirme)**:
```bash
which spicetify && spicetify --version
```
Si falla, detenerse y reportar el error real de `yay`, no reintentar ciegamente.

### Paso 2.2 — Aplicar tema (SOLO si el paso 2.1 verificó OK)

1. Backup obligatorio antes de tocar nada del cliente:
```bash
spicetify backup
```
Verificar que el comando terminó sin error (exit code 0) antes de continuar. Si falla, detenerse — no forzar.

2. Instalar un tema oscuro vía AUR. Dos opciones válidas, dejar que el usuario elija cuál (no decidir por él sin preguntar, es una elección estética):
   - `spicetify-theme-dribbblish-dynamic` — dinámico, se adapta al color dominante del álbum, más "vivo"
   - `spicetify-theme-nord-git` — paleta fija fría, más control/consistencia con el rice

   Instalar la elegida:
   ```bash
   yay -S spicetify-theme-dribbblish-dynamic
   # o
   yay -S spicetify-theme-nord-git
   ```

3. Aplicar:
   ```bash
   spicetify config current_theme <nombre-tema>
   spicetify apply
   ```
   Verificar exit code 0. Si `spicetify apply` falla, correr `spicetify restore` para revertir al cliente original antes de reportar el error — nunca dejar Spotify en estado roto sin intentar el rollback.

4. Verificación final: abrir Spotify y confirmar visualmente que cargó el tema (no hay forma de verificar esto por CLI/exit-code — requiere confirmación humana). Reportar al usuario "aplica y revisa, si se ve roto correr `spicetify restore`".

**Nota de color**: los temas de spicetify listados usan su propia paleta (Nord o dinámica por álbum), NO la paleta de caelestia — no hay integración nativa spicetify↔caelestia. Si se quiere matchear la paleta exacta, sería necesario editar `color.ini` del tema manualmente con los valores de `scheme.json` (fuera de alcance de esta tarea salvo que el usuario lo pida explícitamente después de ver el resultado).

## TAREA 3 — Obsidian: snippet CSS con paleta Caelestia

No requiere sudo, no requiere instalar nada — 100% ejecutable sin intervención del usuario.

**Estado actual verificado**: `~/Vault/.obsidian/snippets/` solo tiene `minegocio-embellece.css` (activo, tema MiNegocio rojo `#d60000` — NO tocar ni desactivar, es de otro proyecto). No existe snippet de Caelestia.

### Paso 3.1 — Extraer y generar el bloque CSS en una sola pasada

No extraer valores sueltos y transcribirlos a mano al paso siguiente — eso es donde se cuela un error de copiado. Generar el bloque completo con un solo comando `jq`, usando las keys reales de la API de temas de Obsidian (`--background-primary`, `--text-normal`, `--interactive-accent`, `--text-accent`, etc. — no inventar nombres de variable):

```bash
SCHEME=~/.local/state/caelestia/scheme.json
for k in background surface onBackground primary tertiary onPrimary outline; do
  jq -e ".colours.$k != null" "$SCHEME" >/dev/null || { echo "ERROR: falta key '$k' en scheme.json"; exit 1; }
done

jq -r '.colours | ".theme-dark {\n  --background-primary: #\(.background);\n  --background-secondary: #\(.surface);\n  --text-normal: #\(.onBackground);\n  --interactive-accent: #\(.primary);\n  --interactive-accent-hover: #\(.primary);\n  --text-accent: #\(.tertiary);\n  --text-on-accent: #\(.onPrimary);\n  --background-modifier-border: #\(.outline);\n}"' "$SCHEME" > ~/Vault/.obsidian/snippets/caelestia.css
```

Esto valida cada key ANTES de generar el archivo (aborta si falta alguna) y escribe el CSS final directo desde los valores reales del JSON, sin paso intermedio de transcripción manual.

### Paso 3.2 — Verificar el archivo generado
```bash
cat ~/Vault/.obsidian/snippets/caelestia.css
```
Confirmar visualmente que no hay ningún `#null` en el archivo (señal de que alguna key vino vacía pese a la validación — no debería pasar si el paso 3.1 se corrió completo, pero es la última red de seguridad antes de activar el snippet).

No tocar `.theme-light` — el vault se usa en modo oscuro (confirmado: `accentColor` actual en `appearance.json` sugiere tema oscuro consistente con el resto del rice).

### Paso 3.3 — Activar el snippet

**No pegar un JSON fijo por encima del archivo.** El estado mostrado abajo es el que había el 2026-07-15 — para cuando esto se ejecute pudo haber cambiado (otro snippet agregado, plugin Obsidian Git tocó el archivo, etc.). Sobreescribir con un bloque fijo borraría silenciosamente cualquier cambio posterior. En su lugar: **leer** el array actual y hacer **append condicional** solo si `"caelestia"` no está ya presente.

Backup primero:
```bash
cp ~/Vault/.obsidian/appearance.json ~/Vault/.obsidian/appearance.json.bak
```

Append condicional (no-op si ya está activado, no duplica, no toca nada más del archivo):
```bash
jq 'if (.enabledCssSnippets | index("caelestia")) then . else .enabledCssSnippets += ["caelestia"] end' \
  ~/Vault/.obsidian/appearance.json.bak > ~/Vault/.obsidian/appearance.json
```

**No cambiar `accentColor`** ni ninguna otra key del archivo — es del proyecto MiNegocio, fuera de alcance, no pedido por el usuario. El comando de arriba solo toca `enabledCssSnippets`, todo lo demás queda intacto tal cual esté en ese momento.

### Paso 3.4 — Verificación
```bash
jq empty ~/Vault/.obsidian/appearance.json && echo "JSON válido"
```
Si falla, restaurar el backup inmediatamente:
```bash
cp ~/Vault/.obsidian/appearance.json.bak ~/Vault/.obsidian/appearance.json
```
Confirmación visual final requiere que el usuario recargue Obsidian (Ctrl+R o reiniciar) — no hay forma de verificarlo por CLI.

## Checklist de ejecución (orden sugerido)

- [ ] Tarea 3 (Obsidian) — sin dependencias externas, hacer primero
- [ ] Tarea 1 (Cava) — pedir al usuario que corra el comando, luego verificar
- [ ] Tarea 2 (Spicetify) — la más riesgosa, hacer al final, con checkpoints explícitos y sin saltarse el backup/rollback

## Reglas generales anti-error para quien ejecute esto

1. Nunca asumir que un paquete/comando existe — verificar con `which` o `pacman -Qi` antes de usarlo.
2. Nunca hardcodear un color — siempre `jq` desde `scheme.json` en el momento de ejecutar (el scheme pudo cambiar desde que se escribió este doc).
3. Backup antes de sobreescribir cualquier archivo de config existente con contenido.
4. Validar JSON con `jq empty` después de cualquier edición a un `.json`.
5. Si un paso requiere sudo o modifica un cliente de terceros (Spotify), pausar y esperar confirmación explícita del usuario — no encadenar pasos irreversibles automáticamente.
6. Si algo fallado tiene un comando de rollback conocido (ej. `spicetify restore`), usarlo antes de reportar el error, no dejar el sistema a medio romper.
