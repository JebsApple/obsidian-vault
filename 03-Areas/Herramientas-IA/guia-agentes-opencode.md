# Guía de Agentes OpenCode

OpenCode tiene **6 modos** seleccionables en el TUI. Cada uno usa un modelo distinto según la tarea.

## Los 6 modos

| Modo | Modelo | Para qué |
|---|---|---|
| `build` | opencode/big-pickle (default) | Desarrollo general, escribir código, debugging |
| `plan` | opencode/big-pickle (default) | Solo lectura. Planificar, analizar, revisar sin modificar nada |
| `coding` | OmniRoute auto/best-coding | Código pesado, features complejas, refactors grandes |
| `reasoning` | OmniRoute auto/best-reasoning | Problemas difíciles, debugging profundo, diseño de arquitectura |
| `fast` | OmniRoute auto/best-fast | Tareas rápidas, consultas simples, formateo, búsquedas |
| `chat` | OmniRoute auto/best-chat | Conversación casual, brainstorming, preguntas generales |

## Cómo cambiar de modo

En el TUI de OpenCode:

1. Abre la paleta de comandos (Ctrl/Cmd + P o `/`)
2. Escribe `agent` o `mode`
3. Selecciona el modo que quieras

O desde la terminal al abrir:

```bash
opencode -m coding
opencode -m reasoning
```

## Flujo de trabajo recomendado

Para tareas complejas, alterna entre modos:

```
1. Plan → planifica la solución (solo lectura, sin riesgo)
2. Coding → implementa el código
3. Reasoning → debug si algo falla
4. Fast → formateo rápido, lint, chequeos
5. Chat → dudas, brainstorming
```

### Ejemplo

```
Usuario: "Necesito un sistema de caché para la API"

Modo plan:
  Analiza la estructura actual, propone diseño
  → "Usa Redis con TTL configurable,接口 así..."

Modo coding:
  Implementa la solución
  → Escribe el código, tests, documentación

Modo reasoning (si algo falla):
  Debug de un race condition
  → Encuentra la causa raíz y propone fix

Modo fast:
  Formatea, lint, typecheck
  → npx prettier --write, npm run typecheck
```

## Delegación entre agentes

Dentro de una sesión, puedes pedirle al agente actual que delegue tareas específicas a otros modos como sub-agentes:

```
"Delegar a coding la implementación del endpoint POST /users"

"Pasar a fast para correr el formateo"

"Usar reasoning para analizar este stack trace"
```

O si estás en modo build y quieres planificar sin riesgo:

```
"Cambia a modo plan para analizar esto antes de codificar"
```

## Consideraciones

- **Internal Server Error**: el modo build y plan usan `big-pickle` de opencode. A veces da error 500 intermitente (bug conocido). Reintentar suele resolverlo.
- **OmniRoute** debe estar corriendo para los modos coding, reasoning, fast, chat. Si no, esos modos fallan.
- **Rollback**: hay snapshots automáticos en `~/.opencode-backup/snapshots/`. Si algo se rompe:

```bash
bash ~/.opencode-backup/omniroute-rollback/reparar-opencode.sh list
bash ~/.opencode-backup/omniroute-rollback/reparar-opencode.sh restore <nombre>
```

## Resolver "internal server error" en build/plan

El error `AI_APICallError: Internal server error` con `modelID=big-pickle` es un bug conocido de opencode (issue #29566). Soluciones:

1. **Reintentar** — casi siempre funciona al segundo intento
2. **Usar modo OmniRoute** — coding, fast, reasoning no tienen este problema
3. **Limpiar caché**: `rm -rf ~/.cache/opencode`
4. Si persiste, restaurar snapshot anterior y reportar en GitHub
