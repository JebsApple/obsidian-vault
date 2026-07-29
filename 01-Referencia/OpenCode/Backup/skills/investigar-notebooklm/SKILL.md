---
name: investigar-notebooklm
description: Use when the user asks to research, investigate, or learn something new — a concept, technology, comparison, or open question — whether or not it relates to the current project. Also use whenever the user explicitly mentions NotebookLM. Builds a NotebookLM notebook of real sources and can answer inline from them, rather than answering from memory alone.
---

# Investigar con NotebookLM

Uso manual: cuando el usuario pide investigar, profundizar o aprender sobre un tema
("investigá X", "quiero entender Y a fondo", "buscá fuentes sobre Z", "usá
NotebookLM para..."). A diferencia de `aprendizaje-guiado-proyecto` (que se dispara
solo al programar), esta skill se invoca a pedido, para cualquier tema.

## Flujo

### 1. Aclarar el tema si hace falta

Si la pregunta es ambigua, precisar en una línea qué se va a buscar antes de gastar
research. No hace falta interrogatorio largo — una sola pregunta si es necesaria.

### 2. Reusar o crear notebook

Buscar con `notebook_list` si ya existe un notebook para este tema (mismo título o
similar). Si el usuario está retomando un tema ya investigado antes, reusar ese
`notebook_id` en vez de duplicar.

Si es tema nuevo:
```
notebook_create(title="<tema>")
```

### 3. Research

```
research_start(notebook_id=<id>, query="<tema formulado como búsqueda>", source="web", mode="fast")
research_status(notebook_id=<id>, task_id=<id>)   # poll hasta completed
research_import(notebook_id=<id>, task_id=<id>, cited_only=true)
```

- `mode="fast"` para preguntas puntuales (~30s, ~10 fuentes).
- `mode="deep"` si el usuario pide algo exhaustivo o es un tema amplio (~5min, ~40
  fuentes, solo web).
- `source="drive"` si el usuario menciona que las fuentes están en su Google Drive.

Si el usuario ya tiene URLs específicas en mente, agregarlas directo sin pasar por
research:
```
source_add(notebook_id=<id>, source_type="url", urls=[...])
```

### 4. Responder o dejar para estudio

Dos modos, según lo que pida el usuario:

- **Quiere respuesta ya**: usar `notebook_query(notebook_id=<id>, query="<pregunta>")`
  sobre las fuentes recién importadas y traer la síntesis a la conversación.
- **Quiere estudiarlo él**: no hace falta `notebook_query` — alcanza con reportar que
  el notebook quedó armado y su link, para que lo abra cuando quiera.

Si es ambiguo, preferir traer una síntesis corta igual (más útil) y mencionar que el
notebook completo queda disponible para profundizar.

### 5. Notas opcionales

Si el usuario pide guardar conclusiones, usar `note(notebook_id=<id>,
action="create", ...)` en vez de solo contestar en el chat — así queda persistido en
el notebook.

## Notas

- Todas las llamadas son vía MCP `notebooklm` (tools `notebook_*`, `research_*`,
  `source_*`, `note`) — ya configurado en `~/.config/opencode/opencode.json`.
- `notebook_query` es para preguntar sobre fuentes YA importadas al notebook, no para
  buscar fuentes nuevas — para eso es `research_start`.
- Si `research_status` no completa en el timeout, reportar y ofrecer reintentar en
  vez de bloquear.
