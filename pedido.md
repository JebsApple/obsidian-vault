# Pedido: Guías de Estudio Sprint 3 — Por Integrante

## Contexto
Presentación mañana. Necesito 4 guías de estudio, una por integrante, con los cambios REALES del Sprint 3. Que cada guía ayude a estudiar qué hizo cada persona, cómo funciona su código, y cómo se conecta con el resto.

## Código fuente
- **Backend:** `/home/apuru/proyectos/minegocio/minegocio-backend/`
- **Frontend:** `/home/apuru/proyectos/minegocio/minegocio-frontend/`

## Autores en git
- **Nicolás:** `NValdes`
- **Ignacio:** `IVarela` o `IgVml`
- **Víctor:** `VHerrera`
- **Gabriel:** `GFlores`

## Paso 1: Descubrir qué hizo cada uno

Para cada integrante, correr:
```bash
cd /home/apuru/proyectos/minegocio/minegocio-backend
git log --all --since="2026-06-01" --author="AUTOR" --name-only --format=""

cd /home/apuru/proyectos/minegocio/minegocio-frontend
git log --all --since="2026-06-01" --author="AUTOR" --name-only --format=""
```

Eso da la lista de archivos que tocó cada persona.

## Paso 2: Leer y analizar cada archivo

Para cada archivo modificado, leerlo y explicar:
- **Qué es** (handler, service, repository, componente Vue, servicio JS, router, etc.)
- **Para qué sirve** (qué hace esa clase/archivo)
- **Con qué se conecta** (qué otros archivos usa o lo usan)
- **Cómo funciona** (flujo lógico, no toda la línea por línea)

## Paso 3: Crear las guías

Crear estos 4 archivos en `/home/apuru/obsidian-vault/Projects/MiNegocio/`:

- `guia-nicolas-sprint3.md`
- `guia-ignacio-sprint3.md`
- `guia-victor-sprint3.md`
- `guia-gabriel-sprint3.md`

## Estructura de cada guía

```yaml
---
tags: [proyecto/minegocio, tipo/guia-estudio, sprint3]
created: 2026-07-10
---
```

### Secciones:

1. **Archivos modificados** — tabla con | Archivo | Tipo (handler/service/componente) | Qué hace |

2. **Arquitectura del código que toqué** — diagrama o lista de cómo se conectan mis archivos entre sí y con el código de los demás

3. **Explicación por archivo** — para cada archivo:
   - Nombre y path
   - Tipo (handler, service, repository, componente, servicio, etc.)
   - Para qué se creó
   - Cómo funciona (flujo lógico)
   - Con qué se conecta (qué archivos lo llaman o lo usa)

4. **Preguntas de estudio** — 5-10 preguntas que podrían hacer en la presentación sobre mi código

5. **Archivos clave para repasar** — los 5-10 archivos más importantes que debo conocer de memoria

## Formato
- Usar tablas y bloques de código
- Incluir paths exactos de los archivos
- Explicar para alguien que nunca vio el código
- No inventar — leer los archivos reales

## Archivos que típicamente existen en este proyecto

**Backend (Go):**
- `handler/` — HTTP handlers (uno por dominio)
- `service/` — lógica de negocio
- `repository/` — acceso a BD (queries SQL)
- `config/` — configuración (JWT, DB, etc.)
- `middleware/` — auth, upload, etc.
- `main.go` — wiring de todo

**Frontend (Vue 3):**
- `views/` — páginas completas
- `components/` — componentes reutilizables
- `services/` o `*.js` — llamadas fetch al backend
- `router/` — rutas y guards
