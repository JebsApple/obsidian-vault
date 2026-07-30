---
tipo: sistema
version: 2.0
creado: 2026-07-30
tags:
  - protocolo/agente
  - protocolo/vault
---

# Protocolo para Agentes AI

> Instrucciones obligatorias para cualquier agente (Claude Code, opencode, etc.)
> que interactúe con este vault.

## 1. Al inicio de cada sesión

1. Leer `90-Sistema/PROTOCOLO.md` (este archivo).
2. Leer `CONTEXTO.md` para saber dónde se quedó la sesión anterior.
3. Leer `90-Sistema/ESQUEMA.md` para entender el frontmatter.
4. Leer el `_index.md` del proyecto o área relevante.

## 2. Reglas de escritura

### 2.1 Frontmatter obligatorio

Toda nota NUEVA debe incluir frontmatter YAML con al menos:
```yaml
---
tipo: proyecto|area|zettel|sesion|diario|capture|decision|reporte
creado: YYYY-MM-DD
tags: []
---
```

### 2.2 Dónde escribir cada cosa

| Qué creas | Dónde va |
|---|---|
| Nota de proyecto | `02-Projects/<proyecto>/` |
| Nota atómica de conocimiento | `04-Resources/Zettelkasten/` |
| Reporte/auditoría | `02-Projects/<proyecto>/` (si activo) o `05-Archive/MiNegocio/Registro/` |
| Plan de sprint/tarea | `02-Projects/<proyecto>/` |
| Sesión de trabajo | `02-Projects/<proyecto>/` como `sesion-YYYY-MM-DD.md` |
| Decisión arquitectónica | `02-Projects/<proyecto>/` como `decision-<tema>.md` |
| Captura rápida | `00-Inbox/` (se clasifica después) |
| Daily note | `01-Daily/YYYY-MM-DD.md` |

### 2.3 Sesiones (continuidad)

Al TERMINAR una sesión de trabajo:
1. Actualizar `CONTEXTO.md` con:
   - Último proyecto trabajado
   - Resumen de 2-3 líneas
   - Próximos pasos concretos
   - Bloqueos si existen
2. Si trabajaste en un proyecto, actualizar su nota principal con el estado actual.

### 2.4 Enlaces

- Usa `[[wiki-link]]` para conectar notas relacionadas.
- Las notas atómicas en Zettelkasten DEBEN conectarse a otras notas (0 enlaces = nota huérfana = candidata a Archive).
- Los MOCs deben enlazar a al menos 3 notas del tema.

## 3. Reglas de lectura

### 3.1 Orden de búsqueda

1. **MOCs** — si existe un MOC del tema, úsalo como punto de entrada.
2. **Etiquetas** — busca por `tag:` en frontmatter.
3. **Dataview** — para listados dinámicos (tasks, proyectos activos, etc.).
4. **Graph** — si la búsqueda anterior no encuentra, revisa el grafo de relaciones.

### 3.2 Contexto mínimo para decisiones

Antes de dar una recomendación técnica, verifica:
1. ¿Hay decisiones previas documentadas sobre este tema? (buscar `tipo: decision` en el proyecto)
2. ¿Hay restricciones conocidas? (tech stack, deadline, equipo)
3. ¿Hay lecciones aprendidas? (buscar `lecciones` en el proyecto o en Zettelkasten)

## 4. Mantenimiento

- Reporta notas huérfanas (sin enlaces entrantes ni salientes) para archivar.
- Sugiere crear MOCs cuando detects 3+ notas relacionadas sin conectar.
- Nunca borres archivos sin preguntar.
- Siempre haz backup antes de mover archivos existentes.
