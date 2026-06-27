# Configurar NaraRouter en opencode (CLI) — instrucciones reproducibles

Objetivo: dejar opencode usando NaraRouter como provider OpenAI-compatible,
config por **archivo** (no por el menú interactivo), y con el `auth.json` limpio.

## Reglas clave (no romper)

1. **Toda la config de NaraRouter va en `~/.config/opencode/opencode.jsonc`**, en el
   bloque `provider`. NO usar el flujo interactivo `opencode auth login` para esto:
   guarda la key bajo proveedores equivocados (`opencode`, `302ai`, etc.) y "falla".
2. El archivo real es `opencode.jsonc` (no `opencode.json`). opencode lee ambos.
3. Conservar siempre los bloques `mcp` (Obsidian) y `plugin` (ponytail) que ya existen.

## Paso 1 — Conseguir los modelos reales de la cuenta

Los IDs de modelo son **planos** (ej. `mistral-large`), NO `provider/model-id`.
Con la API key real, listar lo que la cuenta tiene habilitado:

```bash
curl -s https://router.bynara.id/v1/models \
  -H "Authorization: Bearer <API_KEY>" | python3 -m json.tool
```

Anotar cada `id`, y si tiene `"vision": true` (acepta imágenes) y `"reasoning": true`.
El campo `weight` = cuánto consume de la cuota diaria por token (más alto = más caro).

## Paso 2 — Escribir el bloque provider en opencode.jsonc

Dentro del JSON raíz, añadir `provider` y `model` SIN borrar `mcp`/`plugin`.
Por cada modelo del paso 1, una entrada en `models` (la clave = el `id` exacto).
`modalities.input` = `["text","image"]` solo si el modelo tiene visión; si no, `["text"]`.

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "naraya": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "NaraRouter",
      "options": {
        "baseURL": "https://router.bynara.id/v1",
        "apiKey": "<API_KEY>"
      },
      "models": {
        "mistral-large":      { "name": "Mistral Large",       "modalities": { "input": ["text"],          "output": ["text"] } },
        "mistral-medium-3-5": { "name": "Mistral Medium 3.5",  "modalities": { "input": ["text","image"],  "output": ["text"] } },
        "mimo-v2.5-free":     { "name": "MiMo v2.5 (free)",    "modalities": { "input": ["text","image"],  "output": ["text"] } },
        "mimo-v2.5-pro-free": { "name": "MiMo v2.5 Pro (free)","modalities": { "input": ["text"],          "output": ["text"] } }
      }
    }
  },
  "model": "naraya/mistral-large",
  "mcp":    { "...conservar lo existente..." },
  "plugin": [ "...conservar lo existente..." ]
}
```

- `model` = modelo por defecto, formato `naraya/<id>`.
- Recomendado por defecto: `naraya/mistral-large` (tool-calling fiable, weight 1).

## Paso 3 — Limpiar auth.json (quitar lo que metió el menú interactivo)

```bash
# backup con fecha
cp ~/.local/share/opencode/auth.json ~/.local/share/opencode/auth.json.bak-$(date +%Y%m%d)
# dejarlo vacío: la key de naraya ya vive en opencode.jsonc
printf '{}\n' > ~/.local/share/opencode/auth.json
```

(Si el usuario usa otros providers legítimos en `auth.json`, quitar SOLO las entradas
sobrantes en vez de vaciarlo. Revisar antes de borrar.)

## Paso 4 — Verificar (sin abrir la TUI)

```bash
# JSON válido
python3 -c "import json; json.load(open('$HOME/.config/opencode/opencode.jsonc')); print('JSON OK')"

# el provider responde con el default del config
opencode run "responde solo: ok"

# opencode ve solo los modelos de naraya
opencode models | grep naraya
```

Si `opencode run` devuelve la respuesta y exit 0, está listo.
En la TUI: abrir `opencode` y cambiar de modelo con `/models`.

## Notas

- La API key queda en texto plano en `opencode.jsonc`. Alternativa más segura:
  `"apiKey": "{env:NARAROUTER_API_KEY}"` y exportar la variable en el shell.
- Base URL: `https://router.bynara.id/v1`
- Doc oficial de la integración: NaraRouter → Integrations → Opencode.
