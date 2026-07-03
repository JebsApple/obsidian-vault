# Plan: Rediseño KanbanBoard

## Archivos a modificar
- `src/components/KanbanBoard.vue` — Rediseño completo
- `src/components/ModalAgregarProducto.vue` — **Nuevo** modal selector
- `src/views/Inventario.vue` — Ajustes menores

---

## 1. KanbanBoard.vue — Rediseño

### 1.1 Headers de columna
Cada header tendrá tres botones: `+ Agregar` (nuevo), lápiz (renombrar existe), papelera (eliminar existe).
- `+ Agregar` emite `'agregar-producto', { ubicacion, productosEnColumna }`
- Título: `<h3>` con nombre + contador `(n)`

### 1.2 Grid de tarjetas (2-3 cols)
Dentro de cada columna: `grid-template-columns: repeat(auto-fill, minmax(140px, 1fr))`

Cada tarjeta:
- **Imagen**: aspect-ratio 1/1, ~100px, object-fit cover, placeholder "Sin imagen"
- **Nombre**: 600 weight, ellipsis
- **Código**: icono barcode + código_barras
- **Categoría**: gris
- **Precio**: var(--color-brand), bold
- **Stock badge**: verde (>10), ámbar (1-10), rojo (0), gris (null)

Drag-drop nativo se conserva.

### 1.3 Estado vacío
"Sin productos en esta ubicación" + botón "+ Agregar producto" que emite `'agregar-producto'`.

### 1.4 Botón "+ Agregar ubicación"
- Eliminar rail lateral derecho
- Columna fantasma al final del grid con borde dashed
- Clic → emite `'crear-ubicacion'` → padre llama `inventarioService.createUbicacion()` + recarga

### 1.5 Emits
```
['product-moved', 'agregar-producto', 'crear-ubicacion', 'renombrar', 'eliminar']
```

---

## 2. ModalAgregarProducto.vue (Nuevo)

### 2.1 Estructura
Modal grande (800px) con teleport + overlay + scroll interno.

### 2.2 Props
`ubicacion` (Object), `productosEnColumna` (Array de IDs).

### 2.3 Carga
`inventarioService.buscarProductos('')` con `limit=100`. Productos ya en columna se marcan "Ya agregado" (deshabilitados).

### 2.4 Búsqueda local (sin llamadas API)
- Input texto con debounce 300ms (filtra nombre, código_barras)
- Selector de categoría (extraído de datos)

### 2.5 Grid
4 columnas estilo GaleriaProductos. Cada card con imagen, nombre, precio, stock badge, botón "Agregar".

### 2.6 Emits
`'agregar', { producto, ubicacion }` y `'cerrar'`.

### 2.7 Integración
KanbanBoard muestra modal con `v-if`, maneja `agregar` → `updateUbicacion()` + recarga.

---

## 3. Inventario.vue
- Quitar referencias al rail lateral
- Handler `@crear-ubicacion` para crear ubicación + recargar

---

## 4. Flujo completo
```
Clic "+ Agregar" en header de columna
  → Modal se abre con ≤100 productos
  → Usuario busca/filtra localmente
  → Clic "Agregar" en un producto
  → PATCH /api/inventario/{id} con {ubicacion: ubicacion.id}
  → Recarga Kanban

Arrastre entre columnas
  → PATCH /api/inventario/{id} con {ubicacion: nuevaUbicacion.id}

Clic "+ Agregar ubicación" (columna fantasma)
  → Prompt nombre → POST /api/ubicaciones → recarga
```

---

## 5. Notas
- Sin nuevas dependencias (Vue 2, fetch, CSS Grid)
- Sin breakpoints nuevos (scroll horizontal del Kanban se mantiene)
- Usa paleta existente (`--color-brand`, `--ease-spring`, stock badges compartidos)
- Modal con teleport siguiendo patrón de `AppModal.vue`
