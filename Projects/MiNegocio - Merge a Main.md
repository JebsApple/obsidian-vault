---
tags: [proyecto/MiNegocio, estado/pendiente]
---

# MiNegocio — Merge a Main

## Instrucciones para Claude Code

### 1. Contexto general

Repositorios involucrados (Gitea: `http://192.168.50.28:3000`):

| Repo                                  | Rama feature                     | Estado actual           |
| ------------------------------------- | -------------------------------- | ----------------------- |
| `VHerrera/MiNegocio-frontend`         | `S2-HU04-Frontend-Galeria`       | ✅ Pusheada              |
| `VHerrera/MiNegocio-frontend`         | `S2-STL-Frontend-Redesign`       | ✅ Pusheada              |
| `VHerrera/MiNegocio-frontend`         | `S2-HU04-Frontend-CargaImagenes` | Solo en remoto          |
| `VHerrera/MiNegocio-backend`          | `main`                           | ✅ Ya integrado S2-HU04  |
| `VHerrera/MiNegocio-backend-Busqueda` | `S2-HU04-API-Busqueda`           | ✅ Pusheada (repo nuevo) |
| `VHerrera/MiNegocio-backend-imagenes` | `main`                           | ✅ Pusheado (repo nuevo) |
| `VHerrera/MiNegocio-database`         | `main`                           | ✅ Al día                |


### 2. Tareas para Claude Code (pesadas)

- **Revisar ramas de compañeros**: Mirar `remotes/origin/` en cada repo. Identificar errores, malas prácticas, código muerto, falta de tests.
- **Simular merge a main**: Hacer `git merge --no-commit --no-ff` de cada rama feature contra main para detectar conflictos reales.
- **Reportar hallazgos**: Crear issues en Gitea o notas en Obsidian con los errores/conflictos encontrados.
- **Planificar merge ordenado**: Definir orden de merge (ej: database → backend → frontend).

### 3. Tareas ligeras para OpenCode (yo — OpenCode)

Cuando Claude Code necesite algo trivial (consultar archivos, ejecutar comandos rápidos, verificar ramas), que delegue via `opencode-mcp` con `opencode_run` / `opencode_ask`.

### 4. Ramas de compañeros a revisar

Buscar en remotes de cada repo:

**MiNegocio-backend:**
- `origin/#28-Endpoints-de-Inventario`
- `origin/#48-S2-HU01`
- `origin/S2-HU03`
- `origin/S2-Backend`
- `origin/S2-HU02-API`
- `origin/hotfix/smoke-test-bugs`

**MiNegocio-frontend:**
- `origin/#47-S2-HU01`
- `origin/26TabladeGestióndeProductos`
- `origin/S2-HU03`
- `origin/S2-Frontend`
- `origin/S2-HU02-Punto-de-Venta`

**MiNegocio-database:**
- `origin/#27-Vista-de-Inventario-database`
- `origin/S2-HU03`
- `origin/S2-HU01-BD-indice-y-constraint-en-campo-codigo-de-barras`

### 5. Pasos de merge recomendados

1. Hacer fetch de todos los remotos
2. Revisar cada rama de compañeros (code review)
3. Merge database → main (sin riesgo)
4. Merge backend branches → main (uno por uno, resolver conflictos)
5. Merge frontend branches → main (último, más conflictos potenciales)
6. Verificar CI/CD en Jenkins

### 6. Notas adicionales

- Las ramas `S2-STL-*` son de estilos/rediseño, deberían tener prioridad baja
- Las ramas `S2-HU*` son funcionales, prioridad alta
- `main` recibe cambios solo vía PR desde Gitea (según COMMITS.md)
- Token Gitea: [[token gitea]]
