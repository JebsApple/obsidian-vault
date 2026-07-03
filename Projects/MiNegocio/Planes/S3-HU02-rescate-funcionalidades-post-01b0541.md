# S3-HU02: Rescate de funcionalidades post-01b0541

**Base:** `01b0541` (S3-HU02-BugFix-escaneo-pos-autocarrito-y-reenfoque-scanner)

---

## Lo que se pide

### 1. Kanban con columnas editables y sin "Sin clasificar"
- Tableros (contenedores de productos) editables y eliminables por el usuario
- Al crecer la cantidad de tableros, NO se achican — en vez de eso, se crea una nueva fila abajo sin afectar el tamaño de los tableros
- Los productos se visualizan bien adentro de cada tablero
- El usuario puede agregar y eliminar productos de cada tablero
- NO debe haber columna fija "Sin clasificar"
- Botón de expandir tablero: pastilla que gira 45 grados (como estaba antes)
- Botones editar/eliminar en cada tablero
- Animaciones suaves y márgenes correctos

### 2. Filtros
- Una barra de búsqueda simple
- Botón de filtro con icono de embudo (`ti ti-adjustments-horizontal` o similar)
- Cuando el filtro está activo: icono rojo
- Cuando no hay filtro: icono gris
- Incluye los filtros que ya están implementados en la página (precio min/max, stock, orden)

---

## Dónde está cada cosa en la historia

| Funcionalidad | Existe en commits | Aplicable limpio? |
|---|---|---|
| Columnas dinámicas (ubicaciones) sin "Sin clasificar" fijo | `368f1b7` (migrar a ubicaciones) + `0d97bc2` (rediseño cards) | ❌ Base usa 4 status fijos |
| Agregar productos a un tablero vía modal | `f1fe555` | ❌ Depende de migración kanban |
| Botón expandir columna (pastilla 45°) | `d4e319b` (en T11-iconos) | ❌ Rama divergida |
| Renombrar columna inline (lápiz) | `ec09541` | ❌ Depende de migración kanban |
| Editar/Eliminar columna | `92a3ec5`, `ec09541` | ❌ Depende de migración kanban |
| Cards con imagen, precio, badge de stock | `0d97bc2` | ❌ Depende de migración kanban |
| Overflow: nuevas filas sin apachurrar | `dec1528` (responsive) + refactor grid | ❌ Depende de migración kanban |
| Drop externo no rompe tablero (JSON.parse safe) | `6df1114` | ❌ Depende de migración kanban |
| Barra de búsqueda con filtro embudo | No existe en commits | — |

**Conclusión:** Para tener todo esto funcionando, lo más limpio es migrar el KanbanBoard al sistema de ubicaciones dinámicas (como ya estaba en la rama), que incluye TODAS esas funcionalidades. No se puede cherry-pick pieza por pieza porque los commits encadenan unos con otros y la base cambió.

---

## Propuesta: Migración completa del Kanban

Basado en cómo quedó en la rama S3-HU02 (después de los merges de T02), se puede replicar el comportamiento completo:

### Lo que ganas con la migración:
- ✅ Columnas dinámicas: el usuario crea, renombra y elimina tableros a voluntad
- ✅ Sin "Sin clasificar" fijo — todas las columnas son iguales y eliminables
- ✅ Botón "Agregar ubicación" (columna fantasma al final)
- ✅ Cards con imagen, nombre, código, categoría, precio y badge de stock
- ✅ Expandir columna con pastilla que gira 45°
- ✅ Editar (lápiz) y eliminar (tacho) en cada columna
- ✅ Responsive: las columnas se apilan bien en pantallas chicas
- ✅ Sin riesgo de drop externo (JSON.parse protegido, drag nativo deshabilitado)

### Lo que se pierde respecto a la base actual:
- Los 4 status fijos (sin_clasificar, stock_normal, stock_bajo, agotado) se reemplazan por ubicaciones
- El backend debe soportar PATCH de ubicación (inventarioService ya lo tiene parcialmente)

### Barra de búsqueda con filtro embudo
Actualmente `BuscadorProductos` muestra todos los filtros visibles siempre. Se puede rediseñar:
- Un input de búsqueda con un botón de embudo al lado
- Al clickear el embudo, se despliegan los filtros (precio min/max, stock, orden)
- Si hay algún filtro activo, el embudo se pinta rojo; si no, gris
- **Esto es desarrollo nuevo** (no está en ningún commit)

---

## Orden de implementación propuesto

```
Paso 1: Migrar KanbanBoard a ubicaciones dinámicas
        (tomando como参考 los commits 368f1b7 + 0d97bc2 + f1fe555 + ec09541)
        
Paso 2: Agregar hotfixes (drop externo, responsive)
        
Paso 3: Rediseñar BuscadorProductos con filtro embudo
        (desarrollo nuevo)

Paso 4: Probar, construir y deployar
```

---

## Preguntas para resolver antes de empezar

1. **La barra de búsqueda con filtro**: ¿la quieres solo en la página de Inventario (donde está el kanban) o en todas las páginas que tengan listas?

2. **"Sin clasificar"**: ¿lo eliminamos por completo (y si un producto no tiene ubicación se oculta hasta que el usuario lo asigne)? ¿O lo dejamos como columna pero el usuario puede eliminarla si quiere?

3. **Sidebar**: ¿seguimos con el plan de los iconos de navegación visibles afuera cuando la barra está cerrada, o lo dejamos para después y nos enfocamos en kanban + filtros ahora?

4. **Eliminar productos de un tablero**: ¿"eliminar" significa borrar el producto del sistema (DELETE permanente) o solo sacarlo de esa columna/ubicación?
