# Taiga — S3-HU02-T14

## Referencia

| Campo        | Valor            |
| ------------ | ---------------- |
| Sprint       | S3               |
| User Story   | HU02             |
| Task         | T14              |
| Descripción  | UI: sidebar colapsable, tabs folder, responsive |
| Rama         | dev              |
| Servidor DEV | http://192.168.50.25:8080 |

---

## User Story HU02

> Como usuario quiero una interfaz moderna y responsiva para gestionar productos
> e inventario, para poder trabajar cómodamente desde cualquier dispositivo.

---

## Tarea T14 — Mejoras de UI

### Qué se hizo

1. **Sidebar colapsable** con animación `@keyframes`, botón toggle visible solo
   en ventanas angostas (<60% del ancho de pantalla).

2. **Switch tabs tipo folder** en Productos e Inventario: botones con curvatura
   solo arriba y borde inferior continuo. Reemplaza el diseño de píldoras.

3. **Stock con edición inline** en Inventario: input + botón guardar en cada fila
   de la tabla, sin formulario separado.

4. **Transiciones con keyframes** en lugar de `transition` CSS para sidebar y
   cambio de vistas (fade-slide).

5. **Breakpoints responsivos** consistentes (1200px, 768px, 480px) para galería,
   filtros y padding de página.

### Archivos modificados

| Archivo | Cambio |
|---------|--------|
| src/App.vue | Layout dinámico con `sidebarColapsado`, breakpoint al 60%, listener resize |
| src/components/SideBar.vue | Props `colapsado`/`puedeColapsar`, Vue Transition + keyframes, toggle condicional |
| src/views/Productos.vue | Switch de píldoras a folder tabs, fade-slide con keyframes, responsive |
| src/views/Inventario.vue | Switch Tablero/Stock, edición inline, fade-slide keyframes, responsive |
| src/components/GaleriaProductos.vue | Grid 4→3→2→1 columnas con breakpoint 1200px |
| src/components/BuscadorProductos.vue | Filtros columna en ≤480px |
| src/styles/productos.css | Page padding responsive |

### Criterios de aceptación

- [x] Sidebar colapsa con animación suave (opacidad + altura)
- [x] Botón toggle solo visible en ventanas angostas
- [x] Tabs con efecto folder (curva arriba, borde continuo abajo)
- [x] Stock editable inline con guardado por fila
- [x] Galería responsiva 4→3→2→1 columnas
- [x] Filtros responsivos se apilan en móvil
- [x] 53 tests pasan
- [x] Build producción sin errores

### Notas técnicas

- Se usó `<Transition name="sidebar-slide">` con `v-show` en lugar de `v-if`
  para mantener el DOM y evitar recálculos.
- La curva `cubic-bezier(0.25, 0.1, 0.25, 1)` aplica a todas las animaciones
  nuevas para consistencia.
- `_editStock` es una propiedad temporal no persistida que se sincroniza con
  `item.stock` al cargar datos.
