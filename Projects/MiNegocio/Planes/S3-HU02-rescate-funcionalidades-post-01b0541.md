# S3-HU02: Rescate de funcionalidades post-01b0541

**Base:** `01b0541` (S3-HU02-BugFix-escaneo-pos-autocarrito-y-reenfoque-scanner)

## Resumen de dependencias

| # | Commit | Funcionalidad | Cherry-pick limpio? | Dependencias no incluidas |
|---|--------|---------------|-------------------|--------------------------|
| 1 | `6df1114` | HOTFIX: drop externo no rompe kanban | ❌ | Nuevo Kanban (ubicaciones) |
| 2 | `dec1528` | HOTFIX: kanban responsive móvil | ❌ | Nuevo Kanban (columnas, agregando) |
| 3 | `1602bea` | HOTFIX: sidebar no se reabre en scroll móvil | ❌ | Sidebar colapsable moderno |
| 4 | `4b4397a` | Jenkinsfile build prod | ✅ | — |
| 5 | `2339f6a` | Jenkinsfile confirmación manual | ✅ | — |
| 6 | `91cb48b` | npm script deploy-dev | ✅ | — |
| 7 | `d80c998` | IVA 19% + campo proveedor | ⚠️ Parcial | Parece aplicable. FormularioProducto y Productos existen en base. |
| 8 | `51a42df` | Fixes inventario, ventas, estilos | ❌ | Inventario.vue usa `:ubicaciones` del nuevo kanban |
| 9 | `610fb1d` | Lint imports authGuard.test | ✅ | — |
| 10 | `5074838` | Reverse stagger close sidebar | ❌ | Sidebar colapsable moderno |
| 11 | `ec09541` | Renombrar columnas kanban inline | ❌ | Nuevo Kanban (getProductosPorUbicacion, esEliminable) |
| 12 | `a846c5a` | Flag WIP build | ❌ | Sidebar moderno (estadoInterno, ripple, mostrarWip) |

## Análisis detallado

### Grupo A: Cherry-pick directo ✅
- `4b4397a`, `2339f6a` — Solo Jenkinsfile. Sin efecto en funcionalidad.
- `91cb48b` — Solo package.json (script deploy-dev).
- `610fb1d` — 1 línea en authGuard.test.js.

*Se pueden aplicar ya, cero riesgo.*

### Grupo B: Aplicable con verificación ⚠️
- **`d80c998`** (IVA + proveedor): Cambia FormularioProducto.vue (agrega campo proveedor e IVA) y Productos.vue (columna P. Sin IVA). Archivos existen en base con misma estructura. *Verificar que líneas calcen antes de cherry-pick.*

### Grupo C: Bloqueados por nuevo Kanban ❌
- **`ec09541`** (renombrar columnas): El kanban base usa 4 status fijos (sin_clasificar, stock_normal, stock_bajo, agotado). `ec09541` espera columnas dinámicas por ubicación con `getProductosPorUbicacion`, `esEliminable`, etc.
- **`6df1114`** (drop externo): Usa `ubicacionDe()` que no existe en kanban base.
- **`dec1528`** (responsive): Usa `columnas.length` en vez de `statuses.length`.
- **`51a42df`** (fixes): Inventario.vue pasa `:ubicaciones` prop que no existe en KanbanBoard base.

### Grupo D: Bloqueados por Sidebar colapsable moderno ❌
- **`1602bea`** (scroll móvil): Base no tiene `estadoInterno`, `actualizarBreakpoint()`, `eraAncha`.
- **`5074838`** (reverse stagger): Base usa template antiguo (sidebar-logo, toggle-btn colapsado/puedeColapsar).
- **`a846c5a`** (WIP flag): Referencia `estadoInterno` y `ripple` class del sidebar moderno.

## Solución propuesta

### Paso 1: Hotfixes manuales (implementar a mano sobre base 01b0541)

Dado que los hotfixes no se pueden cherry-pick, conviene implementarlos manualmente:

#### 1a. Drop externo (equivalente a `6df1114`)
En KanbanBoard.vue base (cuatro status fijos):
- Envolver `JSON.parse(raw)` en try/catch en `handleDrop()`
- Agregar `draggable="false"` a `<img>` en cards
- Agregar validación `if (!producto || typeof producto !== 'object' || producto.id == null)`

#### 1b. Responsive móvil (equivalente a `dec1528`)
En KanbanBoard.vue base:
- No aplica igual porque el kanban base tiene 4 columnas fijas, no dinámicas. El responsive base podría necesitar ajuste menor pero ya tiene media queries nativos.

#### 1c. Sidebar scroll móvil (equivalente a `1602bea`)
El sidebar base no tiene auto-expand con resize, por lo que este bug no existe en la base. **No necesario.**

### Paso 2: CI/Build
Cherry-pick directo:
```
git cherry-pick 4b4397a 2339f6a 91cb48b
```

### Paso 3: Lint
```
git cherry-pick 610fb1d
```

### Paso 4: IVA + proveedor
Verificar y cherry-pick:
```
git cherry-pick d80c998
```

### Paso 5: Renombrar columnas kanban ⚠️
**No aplicable directamente.** El kanban base usa 4 status fijos. Para tener renombrar columnas, primero habría que migrar el kanban a ubicaciones dinámicas (commit `368f1b7`) y el rediseño completo (`0d97bc2`). Eso es una reestructura mayor. Alternativa: implementar rename inline solo para los 4 status fijos (no recomendado porque el backend ya espera ubicaciones).

### Paso 6: Sidebar con iconos fuera al colapsar (personalizado) 🎯
El usuario pide: *"al cerrarse la barra quedan unicamente los iconos de las paginas, fuera de la sidebar, aparecen en el costado izquierdo de la pagina, y el icono de la pagina(kiosko) permanece en la sidebar cerrada + el icono de la flechita para abrirla de nuevo"*

Esto implica un cambio de layout mayor:
- Sidebar base a 80px solo con logo+toggle
- Los nav icons se mueven FUERA del sidebar (a la izquierda de la página)
- Aparecen como columna icon-only flotante al lado del sidebar colapsado
- La flechita toggle + logo kiosko permanecen en el sidebar colapsado

**Esto no existe en ningún commit.** Es una función nueva que requiere:
1. Mostrar la navegación siempre visible (iconos)
2. Sidebar colapsado a 80px solo con kiosko + toggle
3. Los iconos de navegación aparecen en el margen izquierdo de la página

## Recomendación

1. Aplicar CI/Build + lint + IVA (cherry-picks seguros)
2. Implementar hotfix drop externo manualmente (son ~10 líneas)
3. Para la sidebar + iconos fuera al colapsar: necesita desarrollo nuevo
4. Para renombrar kanban y WIP flag: postergar hasta decidir si migrar kanban o no
5. Pregunta pendiente: los fixes de `51a42df` (estilos CSS y Ventas.vue) — ¿se quieren rescatar manualmente? Los CSS son solo estilos, Ventas.vue tiene fixes de UI.

## Orden de implementación sugerido

```
1. git cherry-pick 4b4397a 2339f6a 91cb48b 610fb1d  (CI + lint)
2. git cherry-pick d80c998                          (IVA, verificar)
3. Implementar hotfix drop externo manual           (~10 min)
4. Implementar sidebar-nav-icons-outside            (desarrollo nuevo)
5. Fixes CSS de 51a42df (base.css, variables.css)   (manual, archivos de estilo)
6. Postergar: renombrar kanban, WIP flag, fixes inventario/ventas
```
