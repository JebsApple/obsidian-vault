---
tag: taiga/S3-HU02
tags:
  - taiga
  - sprint3
  - frontend
---

# Comentarios para Taiga — Tareas S3-HU02-T08 a T11

## **S3-HU02-T08: Animaciones y Consistencia Visual**
**Comentario técnico:**
- **Mejoras realizadas:**
  - Animaciones sincronizadas en `KanbanBoard.vue` con transiciones `cubic-bezier(0.4, 0, 0.2, 1)` y delays escalonados para evitar layout shift.
  - Reemplazo de colores hardcodeados por CSS variables en `variables.css` (ej: `--color-brand: #D60000`, `--color-text: #2C3E50`).
  - Unificación de `font-family` global en `App.vue` (Roboto, sans-serif).
  - Estilos consistentes para botones (`btn-primary`, `btn-outline`) y badges (`badge-low`, `badge-out-of-stock`) en `base.css`.
  - Eliminación de estilos inline en `VentasPage.vue` y `FormularioProducto.vue`.

**Pruebas:**
- Build exitoso (`npm run build`).
- Animaciones fluidas sin saltos visuales.
- Paleta de colores aplicada en todos los componentes.

**Archivos modificados:**
- `src/components/KanbanBoard.vue`
- `src/styles/variables.css`
- `src/styles/base.css`
- `src/App.vue`
- `src/views/VentasPage.vue`
- `src/components/FormularioProducto.vue`

---

## **S3-HU02-T09: Nomenclatura de Vistas (Español)**
**Comentario técnico:**
- **Mejoras realizadas:**
  - Vistas renombradas sin sufijo `Page`:
    - `AnalisePage.vue` → `Analise.vue`
    - `LoginPage.vue` → `Login.vue`
    - `ProductosPage.vue` → `Productos.vue`
    - `VentasPage.vue` → `Ventas.vue`
    - `InventarioPage.vue` → `Inventario.vue`
  - Actualización de rutas en `src/router/index.js` para reflejar los nuevos nombres.
  - Regla ESLint `multi-word` desactivada para vistas de 1 palabra (ej: `Login.vue`).
  - Verificación de imports y referencias en todo el código.

**Pruebas:**
- Build exitoso (`npm run build`).
- Todas las rutas funcionan sin errores 404.
- Navegación entre vistas intacta.

**Archivos modificados:**
- `src/views/Analise.vue`
- `src/views/Login.vue`
- `src/views/Productos.vue`
- `src/views/Ventas.vue`
- `src/views/Inventario.vue`
- `src/router/index.js`

---

## **S3-HU02-T10: Limpieza de CSS Duplicado**
**Comentario técnico:**
- **Mejoras realizadas:**
  - Consolidación de estilos duplicados:
    - Reglas de badges y botones movidas de `GaleriaProductos.vue` a `src/styles/base.css`.
    - Estilos de tablas unificados en `ProductosRegistrados.vue` e `InventarioPage.vue`.
    - Eliminación de estilos inline en `CarritoCompras.vue` (uso de clases globales).
  - Revisión de `productos.css` y `servicios.css` para evitar solapamientos con `base.css`.

**Pruebas:**
- Build exitoso (`npm run build`).
- Diseño visual consistente en todas las vistas.

**Archivos modificados:**
- `src/styles/base.css`
- `src/views/GaleriaProductos.vue`
- `src/views/ProductosRegistrados.vue`
- `src/views/InventarioPage.vue`
- `src/views/CarritoCompras.vue`

---

## **S3-HU02-T11: Iconos para Assets**
**Comentario técnico:**
- **Mejoras realizadas:**
  - Creación de directorio `src/assets/icons/` con iconos SVG optimizados:
    - `icon-dashboard.svg`, `icon-products.svg`, `icon-sales.svg`, `icon-inventory.svg`
    - `icon-edit.svg`, `icon-delete.svg`, `icon-add.svg`, `icon-alert.svg`
  - Integración de iconos en `SideBar.vue` y `NavBar.vue`.
  - Iconos para acciones comunes en `GaleriaProductos.vue` y `ProductosRegistrados.vue`.
  - Icono de alerta para stock bajo/agotado en `KanbanBoard.vue`.

**Pruebas:**
- Build exitoso (`npm run build`).
- Iconos visibles y consistentes en todas las vistas.

**Archivos modificados:**
- `src/assets/icons/` (nuevo directorio)
- `src/components/SideBar.vue`
- `src/components/NavBar.vue`
- `src/components/KanbanBoard.vue`
- `src/views/GaleriaProductos.vue`
- `src/views/ProductosRegistrados.vue`