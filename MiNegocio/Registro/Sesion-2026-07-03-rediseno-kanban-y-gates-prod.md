---
tags:
  - sprint3
  - frontend
  - devops
updated: 2026-07-03
---

# Sesión 2026-07-03 — Rediseño Kanban + gates de producción en Jenkins

## Qué se hizo

### 1. Rediseño KanbanBoard (plan [[S-SPRINT-HU-T-rediseno-kanban]]) — COMPLETADO

Rama `S3-HU02` (frontend), commits pusheados a Gitea:

| Commit | Descripción |
|--------|-------------|
| `57f159e` | Header integrado al sidebar con colapso autogestionado (WIP previo del árbol) |
| `91cb48b` | Script npm `deploy-dev` |
| `0d97bc2` | Rediseño kanban: cards ricas, botón + Agregar por columna, columna fantasma |
| `f1fe555` | `ModalAgregarProducto.vue` nuevo + service `buscarProductos(q, limit)` |
| `a846c5a` | Flag de build `VUE_APP_HABILITAR_WIP` (oculta WIP en prod) |
| `2339f6a` / `4b4397a` | Jenkinsfile: confirmación manual + build prod con WIP off |

Detalles del rediseño:
- **Cards**: imagen 1:1 (object-fit cover, placeholder "Sin imagen"), nombre, código de barras con icono, categoría, precio en rojo marca, badge de stock (verde >10, ámbar 1-10, rojo 0, gris sin dato). Grid `auto-fill minmax(140px, 1fr)`.
- **Header de columna**: título + contador `(n)`, botón `+ Agregar` (abre modal), lápiz (renombrar inline, ya existía), papelera (eliminar, ya existía). Se quitó el expand/colapso de columnas (las cards ahora siempre muestran el detalle).
- **Columna fantasma** con borde punteado al final reemplaza el riel lateral para agregar ubicaciones (mismo input inline Enter/Esc).
- **Estado vacío**: "Sin productos en esta ubicación" + botón agregar.
- **ModalAgregarProducto**: 800px, teleport, carga ≤100 productos una vez, búsqueda local con debounce 300ms + filtro de categoría (sin llamadas extra a la API), grid 4 columnas, productos ya en la columna quedan "Ya agregado" deshabilitados. Queda abierto para agregar varios seguidos. Cierra con Esc, overlay o X.
- Drag & drop se conserva tal cual.

Desviaciones del plan (deliberadas): se mantuvieron los nombres de eventos existentes (`agregar-ubicacion`, `renombrar-ubicacion`, `eliminar-ubicacion`) en vez de renombrarlos, para no romper Inventario.vue ni los tests; la columna fantasma usa el input inline ya testeado en vez de un prompt.

Tests: **88/88 verdes** (14 nuevos: 8 modal, 4 kanban nuevos, 2 flag WIP). Build prod y dev OK. Desplegado a dev (nginx :8080).

### 2. Jenkins listo para que WIP no llegue a prod

WIP definido por Victor: **dashboard (Análisis), página de usuarios y sesiones**.

- **Flag de build** `src/config/funcionalidades.js`: `VUE_APP_HABILITAR_WIP !== 'false'`. En prod: sidebar oculta Dashboard/Usuarios/Sesiones, `/` y `/admin/usuarios` redirigen a `/ventas`. Local y dev quedan igual.
- **Frontend Jenkinsfile**: build de `main` compila con `VUE_APP_HABILITAR_WIP=false`; deploy a prod ahora pide confirmación manual (input, timeout 15 min).
- **Backend Jenkinsfile** (rama `S3-HU02-T15-iva-proveedores`, commit `c1bd070`): **FIX CRÍTICO** — el stage "Deploy Producción" no tenía `when { branch 'main' }`: cualquier rama WIP reemplazaba el contenedor de prod. Ahora gated a main + confirmación manual.
- **Database Jenkinsfile** (commit `bcc216a`): confirmación manual antes de aplicar esquema en prod (ya estaba gated a main).

## Pendientes que siguen igual
- Migrar ALTERs de S3 a la BD dev + rebuild backend dev (ver [[Sesion-2026-07-02-T08-T15-IVA-proveedores-fantasmas]]).
- Merge `S3-HU02` → `dev` (coordinación equipo).
- Nota: los Jenkinsfiles nuevos rigen cuando estas ramas se mergeen; verificar en Jenkins que el pipeline sea multibranch para que `when { branch 'main' }` aplique.
