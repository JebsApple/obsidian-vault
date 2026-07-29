---
name: aprendizaje-guiado-proyecto
description: Use when starting to code in a project that uses a language, framework, or library the user hasn't studied yet, or when a new stack/dependency shows up mid-session — auto-creates a NotebookLM notebook with official docs for that stack plus a summary of what this project is building, so the user can study it later. Do not use for trivial one-line fixes or when a notebook for this project already exists this session.
---

# Aprendizaje Guiado por Proyecto

Cuando opencode empieza a programar en un proyecto y detecta un lenguaje, framework o
librería que el usuario probablemente no domina (stack nuevo para el repo, dependencia
recién agregada, primera vez tocando ese proyecto), esta skill arma automáticamente un
notebook de NotebookLM con fuentes oficiales + contexto del proyecto, para que el
usuario lo estudie después. No es obligatorio para cambios triviales.

## Cuándo disparar

- Primera tarea de código en un repo no visto antes en la sesión.
- El proyecto usa un lenguaje/framework distinto al de la tarea anterior.
- Se detecta una dependencia/librería nueva agregada (package.json, requirements.txt,
  Cargo.toml, go.mod, etc.) que no estaba antes.
- El usuario pide explícitamente "quiero aprender esto mientras lo hacés" o similar.

No disparar para: fixes de una línea, tareas puramente de config, o si ya existe un
notebook de este proyecto creado en la sesión actual (evitar duplicar research).

## Flujo

### 1. Detectar el stack

Leer manifest del proyecto (package.json, pyproject.toml, Cargo.toml, go.mod,
composer.json, etc.) o inspeccionar imports/extensiones de archivo si no hay manifest.
Identificar: lenguaje principal, framework(s) clave, 1-2 librerías no triviales que se
estén usando en la tarea actual.

### 2. Evitar duplicados

Antes de crear notebook nuevo, llamar `notebook_list` y buscar título
`Aprendizaje: <nombre-proyecto>`. Si ya existe, reusar ese `notebook_id` (agregar
fuentes nuevas si el stack detectado cambió) en vez de crear otro.

### 3. Crear el notebook (si no existe)

```
notebook_create(title="Aprendizaje: <nombre-proyecto>")
```

Guardar el `notebook_id` devuelto.

### 4. Buscar fuentes oficiales del lenguaje/framework

```
research_start(
  notebook_id=<id>,
  query="official documentation <lenguaje> <framework> <librería clave> best practices",
  source="web",
  mode="fast"
)
research_status(notebook_id=<id>, task_id=<id>)   # poll hasta status=completed
research_import(notebook_id=<id>, task_id=<id>, cited_only=true)
```

Usar `mode="fast"` (~30s, ~10 fuentes) salvo que el usuario pida un research más
profundo — en ese caso `mode="deep"`.

### 5. Agregar contexto del proyecto como fuente

Redactar un resumen corto (stack completo, qué se está construyendo, arquitectura
relevante, archivos clave tocados) y agregarlo como fuente de texto:

```
source_add(
  notebook_id=<id>,
  source_type="text",
  title="Contexto del proyecto: <nombre-proyecto>",
  text="<resumen del stack + qué se está implementando + archivos clave>"
)
```

Esto conecta la teoría del lenguaje/framework con lo que el usuario realmente está
construyendo, en vez de dejar fuentes genéricas sueltas.

### 6. (Opcional) Nota guía de estudio

Si el research trajo varias fuentes, agregar una nota corta con 3-5 preguntas guía
para estudiar (`note(notebook_id=<id>, action="create", title="Guía de estudio",
content="...")`).

### 7. Reportar, no interrumpir

No abrir el notebook automáticamente ni bloquear la tarea de código en curso. Al
terminar la tarea, mencionar en una línea que se armó el notebook y su link (viene en
la respuesta de `notebook_create`/`notebook_get`).

## Notas

- Todas las llamadas son vía MCP `notebooklm` (tools `notebook_*`, `research_*`,
  `source_*`, `note`) — ya configurado en `~/.config/opencode/opencode.json`.
- Si `research_status` no completa en `max_wait` (default 900s), reportar al usuario
  en vez de reintentar en loop.
- Esta skill es best-effort: si NotebookLM falla (auth vencida, rate limit), no debe
  bloquear la tarea de código — avisar y seguir.
