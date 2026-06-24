---
tags: [proyecto/minegocio, sprint-3, procedimiento, hu02]
---

# Procedimiento — HU02: Rediseño Frontend

## S3-HU02-T01: NavBar y SideBar `[frontend]`
**Asignado:** Victor | **Fechas:** 23 jun → 30 jun

### ¿Qué estamos haciendo y por qué?

Vamos a recuperar los componentes de **navegación** que se hicieron en un rediseño anterior (STL-redesign). La NavBar es la barra de arriba, la SideBar es el menú lateral. Son la interfaz para moverse entre páginas del sistema.

### Pasos

1. **Recuperar componentes.** Buscá en commits pasados los componentes `NavBar.vue`, `SideBar.vue` y `LogoSVG.vue`. Si no aparecen, reescribilos desde cero.

2. **Paleta de colores.** Primario `#D60000` (rojo), fondo blanco, texto `#2C3E50`.

3. **NavBar:** Logo SVG a la izquierda, nombre del usuario (desde `localStorage`), botón "Cerrar sesión" a la derecha.

4. **SideBar:** Enlaces a Dashboard, Productos, Productos Registrados, Ventas, Inventario. Debe poder colapsarse (ocultar/mostrar).

5. **Responsive.** En pantallas <768px, ocultar SideBar y mostrar menú hamburguesa.

6. **Layout en App.vue:** SideBar a la izquierda + contenido al lado.

---

## S3-HU02-T02: KanbanBoard de Inventario `[frontend]` `[backend]`
**Asignado:** Victor | **Fechas:** 30 jun → 4 jul

### ¿Qué estamos haciendo y por qué?

Un **KanbanBoard** muestra el inventario como columnas donde podés arrastrar productos para cambiar su nivel de stock. Es una forma visual de gestionar el inventario.

### Pasos

1. **Recuperar KanbanBoard.vue** de la versión STL-redesign.

2. **Columnas:** Agotado (stock=0), Bajo (1-4), Normal (5+), Exceso (>20). Usá la constante desde `utils/stockStatus.js` (creada en T05).

3. **Cada tarjeta:** nombre, código de barras, thumbnail de imagen, stock actual.

4. **Drag & drop.** Al soltar una tarjeta en otra columna, calcular nuevo stock según el umbral de esa columna y llamar `PATCH /api/inventario/{id}/stock`.

5. **Endpoint PATCH.** Si no existe en `routes/routes.go`, crearlo. El handler recibe `{stock: nuevo_valor}`, valida que sea positivo y hace UPDATE.

---

## S3-HU02-T03: Dashboard principal `[frontend]`
**Asignado:** Victor | **Fechas:** 4 jul → 8 jul

### ¿Qué estamos haciendo y por qué?

La página principal (`/`, `AnalisePage.vue`) se rediseña con indicadores clave del negocio (KPIs) visibles de un vistazo.

### Pasos

1. **4 tarjetas de KPI:**
   - Total productos (color neutro)
   - Ventas del día (verde)
   - Stock bajo <=4 (amarillo)
   - Agotados = 0 (rojo)

2. **Últimas 5 ventas.** Tabla chica debajo de las cards.

3. **Sin librerías externas.** CSS grid/flexbox nativo.

---

## S3-HU02-T04: Testing frontend `[frontend]` `[test]`
**Asignado:** Victor | **Fechas:** 5 jul → 8 jul

### ¿Qué estamos haciendo y por qué?

Vamos a escribir tests automatizados para demostrar que los componentes funcionan. La rúbrica valora que haya tests.

### Pasos

1. 1 test por componente recuperado (NavBar, SideBar, KanbanBoard): render básico + props.

2. 1 test de integración: login → token en localStorage → redirección.

3. Usar Vitest (viene con Vue CLI). Tests en `src/__tests__/`.

---

## Referencias

- [[Sprint 3 - Plan de Trabajo]]
- [[PonytailAudit-2026-06-19]]
- [[Rúbrica Evaluación]]
