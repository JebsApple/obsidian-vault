# S3-HU02: Rescate de funcionalidades post-01b0541

**Base:** `01b0541` (S3-HU02-BugFix-escaneo-pos-autocarrito-y-reenfoque-scanner)

---

## Alcance total

### 1. KanbanBoard — Columnas dinámicas editables

**Qué:** Reemplazar los 4 status fijos por ubicaciones dinámicas que el usuario administra.

**Comportamiento:**
- Por defecto aparecen 3 columnas: Bodega, Vitrina, Sin clasificar
- Todas las columnas son iguales: cualquiera se puede eliminar (incluyendo "Sin clasificar")
- El usuario puede crear, renombrar y eliminar columnas
- Botón "+ Agregar ubicación" al final (columna fantasma)
- Cuando hay más de 4 columnas, el grid envuelve a una nueva fila abajo (no se achican)
- Animación suave al expandir/contraer/agregar

**En cada columna:**
- Header: nombre de columna + contador + botón expandir + botón editar (lápiz) + botón eliminar (tacho)
- Botón expandir: pastilla minimalista que gira 45° (como estaba en la rama T11-iconos)
- Botón renombrar: lápiz que convierte el nombre en input inline
- Botón eliminar: solo visible si la columna no tiene productos

**En cada card (producto):**
- Imagen con lazy loading y draggable=false
- Nombre, código de barras (con icono), categoría
- Precio + badge de stock (verde/ámbar/rojo según cantidad)
- Al expandir la columna: muestra detalles extra (ID, código, stock numérico)
- Drag & drop entre columnas (actualiza ubicación vía API)
- Botón "+" en el header de cada columna abre modal para agregar producto existente

**Protecciones:**
- JSON.parse protegido (try/catch para drops externos)
- Drag nativo de imágenes deshabilitado
- Drop externo ignorado silenciosamente

**Origen en commits:**
- `368f1b7` (migrar a ubicaciones) + `0d97bc2` (rediseño cards) + `f1fe555` (modal agregar) + `ec09541` (renombrar columnas) + `6df1114` (drop externo) + `d4e319b` (expand pill 45°)

### 2. Buscador con filtro embudo

**Qué:** Barra de búsqueda unificada con botón de filtro desplegable.

**Comportamiento:**
- Input de búsqueda con icono de lupa
- Botón de filtro al lado con icono de embudo (`ti-adjustments-horizontal`)
- Al hacer clic en el embudo: se despliegan los filtros (precio min, precio max, stock, orden)
- Filtro activo → embudo rojo
- Sin filtros activos → embudo gris
- Incluye en todas las páginas con listas (Inventario, Productos, Ventas, etc.)
- Reutiliza los filtros ya implementados en `BuscadorProductos.vue`

**Origen:** Desarrollo nuevo (no existe en commits anteriores). Se rediseña el componente `BuscadorProductos.vue` existente.

### 3. Sidebar con iconos fuera al colapsar

**Qué:** Al cerrar la sidebar, los iconos de navegación quedan visibles fuera de la sidebar, en el margen izquierdo de la página.

**Comportamiento:**
- Sidebar colapsada (80px): solo logo del kiosko + flecha toggle
- Aparece una columna angosta al lado con los iconos de navegación (sin texto)
- Todos los iconos son clickeables y navegan a su página
- Al expandir la sidebar, los iconos vuelven a su lugar dentro de la barra con el texto visible
- Animación de transición suave

**Origen:** Desarrollo nuevo. No existe así en ningún commit. Toma como referencia el sidebar de `c07a450`, `41e032d`, `27f3381`, `92a3ec5` pero modificado.

### 4. CI/Build + lint (cherry-pick directo)

- `4b4397a`: Jenkinsfile build prod
- `2339f6a`: Jenkinsfile confirmación manual
- `91cb48b`: npm script deploy-dev
- `610fb1d`: lint imports sin uso

### 5. IVA 19% + campo proveedor (cherry-pick con verificación)

- `d80c998`: FormularioProducto + Productos

---

## Dependencias entre fases

```
KanbanBoard (Fase 1) ── es requisito para ── ninguna otra
                           │
BuscadorEmbudo (Fase 2) ── es independiente, solo rediseña componente existente
                           │
Sidebar (Fase 3) ── es independiente del kanban, pero toca App.vue + layout
                           │
CI/Build + lint (Fase 4) ── independiente, cherry-pick directo
                           │
IVA (Fase 5) ── independiente, cherry-pick con verificación
```

**Se pueden implementar en paralelo:** Fase 2, 4 y 5 son independientes.
**Secuencial:** Fase 1 y 3 son grandes cambios que tocan layout — coordinar MainLayout / App.vue.

---

## Archivos a modificar por fase

### Fase 1 — KanbanBoard (alto impacto)
- `src/components/KanbanBoard.vue` — Reescribir: ubicaciones dinámicas, cards, expand, drag
- `src/components/ModalAgregarProducto.vue` — Nuevo componente
- `src/views/Inventario.vue` — Adaptar a nuevas props/eventos del kanban
- `src/services/inventarioService.js` — Agregar PATCH ubicación, GET ubicaciones
- `src/views/Productos.vue` — Adaptar si es necesario (puede que el modal necesite lista)

### Fase 2 — Buscador con filtro (impacto medio)
- `src/components/BuscadorProductos.vue` — Rediseñar con embudo colapsable
- `src/views/Inventario.vue` — Ajustar integración
- Otras vistas que usen el buscador

### Fase 3 — Sidebar (alto impacto)
- `src/components/SideBar.vue` — Reestructurar: nav items separados, lógica colapso
- `src/App.vue` — Ajustar layout para el nav-icon strip fuera del sidebar
- Posible: nuevo componente `NavIcons.vue` para los iconos exteriores

### Fase 4 — CI/Build (bajo impacto)
- `Jenkinsfile` — Añadir pasos
- `package.json` — Añadir script
- `src/__tests__/authGuard.test.js` — 1 línea

### Fase 5 — IVA (bajo impacto)
- `src/components/FormularioProducto.vue` — Campo proveedor + IVA
- `src/views/Productos.vue` — Columna "P. Sin IVA"

---

## Preguntas

1. **Las páginas que tienen el buscador**: actualmente solo Inventario tiene `BuscadorProductos`. ¿En qué páginas específicas lo quieres? ¿Ventas (POS), Productos, Productos Registrados? ¿Todas deben tener los mismos filtros (precio, stock, orden)?

2. **Sidebar**: Cuando la sidebar está expandida, los iconos de navegación están dentro con texto. Cuando se colapsa, los iconos aparecen fuera (a la izquierda de la página). Pregunta de diseño: esos iconos fuera, ¿deben aparecer con un fondo/panel visible siempre, o se ven flotando sobre el contenido de la página?
