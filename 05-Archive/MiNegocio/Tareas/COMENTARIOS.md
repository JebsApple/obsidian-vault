# COMENTARIOS — Sidebar colapsable + Tabs folder + Responsive

## Resumen de cambios

Se rediseñaron 7 archivos para unificar la UI de productos/inventario con
switch de pestañas tipo carpeta, sidebar colapsable con animación suave, y
breakpoints responsivos consistentes.

---

## 1. SideBar.vue — Sidebar colapsable

### Props nuevas: `colapsado`, `puedeColapsar`

Antes el sidebar era estático. Ahora recibe dos props booleanas desde App.vue
que controlan si está colapsado y si se muestra el botón de toggle.

### `<Transition name="sidebar-slide">`

Se reemplazó el `v-show` + clase CSS por un Vue `<Transition>` nativo.
Ventaja: Vue gestiona las clases de entrada/salida automáticamente y podemos
usar `@keyframes` en lugar de `transition`.

### `@keyframes slideDown / slideUp`

- `slideDown`: opacity 0 hasta el 60% (el contenido aparece después de que
  el contenedor se haya desplegado), luego fade in.
- `slideUp`: opacity 0 al 40% (se desvanece antes de terminar de subir).
- Curva `cubic-bezier(0.25, 0.1, 0.25, 1)` para un movimiento más natural
  que el `ease` por defecto.

### Botón de toggle condicional

- Cuando colapsado + puedeColapsar: se muestra flecha abajo en el logo.
- Cuando expandido + puedeColapsar: se muestra flecha arriba al lado del
  usuario (`.toggle-btn--bottom`).
- Ambos emiten `toggle-colapso` hacia App.vue.

---

## 2. App.vue — Layout dinámico

### `sidebarColapsado` y `puedeColapsar`

Estados reactivos que controlan el layout. `puedeColapsar` se calcula en
`actualizarBreakpoint()`:

```
window.innerWidth > window.screen.width * 0.6 → sidebar expandido fijo
```

Si la ventana es más ancha que el 60% de la pantalla, el sidebar no se puede
colapsar y los botones de toggle se ocultan.

### `flex-direction` con transición

`transition: flex-direction 0.35s ease` — cuando el sidebar colapsa, el layout
cambia de `row` a `column`, y la sidebar pasa de vertical a horizontal.
La transición sobre `flex-direction` no se anima directamente (CSS no puede
interpolar `row → column`), pero el cambio de altura del contenido sí se ve
suave gracias al `transition: height 0.3s ease` en `.main-content`.

### Listener resize en mounted/beforeUnmount

Se limpia el evento al destruir el componente para evitar memory leaks.

---

## 3. Productos.vue + Inventario.vue — Switch tabs tipo folder

Se reemplazó el diseño anterior (píldoras con border-radius completo) por
botones con terminación curva en la parte superior y borde inferior continuo.

### Clases `switch-btn`

```
border-radius: 10px 10px 6px 6px;
margin-bottom: -2px;
border-bottom: 2px solid transparent;
```

Esto crea el efecto "carpeta": la curva solo está arriba, y el borde inferior
se empalma con el borde del contenedor padre.

El botón activo tiene:
```
background: var(--color-brand);
color: white;
border-bottom-color: var(--color-brand);
```

El padre `.vista-switch` tiene `border-bottom: 2px solid #e0e0e0` para que
el borde inferior sea continuo entre los botones.

### Transiciones con `@keyframes` en fade-slide

Reemplacé `transition: opacity 0.2s ease, transform 0.2s ease` por
`@keyframes fadeSlideIn / fadeSlideOut`. Keyframes permiten más control
sobre la curva de animación y el fill mode (`both` mantiene el estado final).

---

## 4. Inventario.vue — Stock con edición inline

Se eliminó la sección "Buscar y ajustar stock" con formulario separado. Ahora:

- BuscadorProductos arriba del switch (componente reutilizable).
- Pestaña "Tablero" muestra KanbanBoard.
- Pestaña "Stock" muestra tabla con edición inline.
- Cada fila tiene un input + botón guardar.
- `_editStock` es una propiedad reactiva temporal que se sincroniza con
  `item.stock` al cargar.
- Clase `.stock-dirty` cuando el valor editado difiere del original.

### Método `actualizarStock(item)`

Llama a `inventarioService.updateStock()` y recarga la lista completa.
Antes era `agregarAInventario()` con búsqueda manual.

---

## 5. GaleriaProductos.vue — Grid responsive

Breakpoints:
- >1200px: 4 columnas
- ≤1200px: 3 columnas
- ≤768px: 2 columnas
- ≤480px: 1 columna

Antes era 4 → 2 → 1, sin el punto intermedio de 3 columnas.

---

## 6. BuscadorProductos.vue — Filtros responsivos

En ≤480px los filtros cambian a `flex-direction: column` y ocupan el ancho
completo. En ≤768px se reduce el padding y gap.

---

## 7. productos.css — Page padding responsive

Se agregaron media queries para reducir el padding de `.page` en móvil:
- 24px 16px en ≤768px
- 20px 12px en ≤480px

---

## Observaciones

- No se cambió la lógica de negocio (servicios, store, API calls).
- Todos los cambios son puramente de UI/UX.
- 53 tests pasan, build producción exitoso.
- Rama `dev`, servidor DEV en http://192.168.50.25:8080
