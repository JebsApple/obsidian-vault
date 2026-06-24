---
tags: [proyecto/minegocio, sprint-3, procedimiento, victor, hu02]
---

# Procedimiento — Victor — HU02: Rediseño Frontend

Tus tareas ordenadas por fecha de inicio. Empezá de arriba a abajo. Algunas se superponen en fechas — priorizá el orden indicado.

---

## 1. S3-HU02-T01: NavBar y SideBar `[frontend]`
**Fechas:** 23 jun → 30 jun

### ¿Qué estamos haciendo y por qué?

Vamos a recuperar los componentes de **navegación** de un rediseño anterior (STL-redesign). La NavBar es la barra superior y la SideBar el menú lateral. Son la interfaz para moverse entre páginas.

### Pasos

1. **Buscar componentes viejos.** Revisá commits pasados en busca de `NavBar.vue`, `SideBar.vue` y `LogoSVG.vue`. Si no aparecen, reescribilos.

2. **Paleta:** primario `#D60000` (rojo), fondo blanco, texto `#2C3E50`.

3. **NavBar:** logo SVG a la izquierda, nombre del usuario (desde `localStorage.getItem('usuario')`), botón "Cerrar sesión" a la derecha.

4. **SideBar:** enlaces a Dashboard, Productos, Productos Registrados, Ventas, Inventario. Debe poder colapsarse (ocultar/mostrar con un botón).

5. **Responsive:** en pantallas <768px, ocultar SideBar y mostrar menú hamburguesa.

6. **Layout en App.vue:** SideBar a la izquierda + contenido al lado. En responsive, SideBar oculta y contenido ocupa todo el ancho.

---

## 2. S3-HU02-T02: KanbanBoard de Inventario `[frontend]` `[backend]`
**Fechas:** 30 jun → 4 jul

### ¿Qué estamos haciendo y por qué?

Un **KanbanBoard** muestra el inventario en columnas donde podés arrastrar productos para cambiar su nivel de stock. Cada columna es un estado: Agotado, Bajo, Normal, Exceso. Es una forma visual de gestionar stock.

### Pasos

1. **Recuperar KanbanBoard.vue** de la versión STL-redesign.

2. **Columnas:**
   - Agotado — stock = 0
   - Bajo — stock entre 1 y 4
   - Normal — stock entre 5 y 20
   - Exceso — stock > 20
   Usá `STOCK_BAJO` del `utils/stockStatus.js` que creaste en HU01-T05.

3. **Cada tarjeta (card):** nombre, código de barras, thumbnail de imagen, stock actual.

4. **Drag & drop:** al soltar una tarjeta en otra columna, calculá el nuevo stock según el umbral de esa columna. Llamá a `PATCH /api/inventario/{id}/stock` con el nuevo valor.

5. **Endpoint PATCH:** si no existe en el backend, crealo en `routes/routes.go` y `handler/inventario_handler.go`. El handler recibe `{stock: nuevo_valor}`, valida que sea positivo y hace UPDATE.

---

## 3. S3-HU02-T03: Dashboard principal `[frontend]`
**Fechas:** 4 jul → 8 jul

### ¿Qué estamos haciendo y por qué?

Rediseñar la página principal (`/`, `AnalisePage.vue`) para que muestre indicadores clave del negocio de un vistazo.

### Pasos

1. **4 tarjetas de KPI:**
   - Total productos (ícono 📦, color neutro)
   - Ventas del día (💰, verde)
   - Stock bajo ≤4 (⚠️, amarillo)
   - Agotados = 0 (🚫, rojo)

2. **Últimas 5 ventas.** Tabla chica debajo de las cards.

3. Sin librerías externas — CSS grid/flexbox nativo.

---

## 4. S3-HU02-T04: Testing frontend `[frontend]` `[test]`
**Fechas:** 5 jul → 8 jul

### ¿Qué estamos haciendo y por qué?

Escribir tests automatizados para demostrar que los componentes funcionan. La rúbrica valora que haya tests, no que sean miles.

### Pasos

1. **1 test por componente** (NavBar, SideBar, KanbanBoard): render básico + verificar que las props se muestren.

2. **1 test de integración:** simular login (setear token + usuario en localStorage), verificar redirección y que el navbar muestre el nombre.

3. Usar **Vitest** (viene con Vue CLI). Tests en `src/__tests__/`.

4. Son 4 tests en total — no te vuelvas loco.

---

## 5. S3-HU02-T05: Validaciones + mensajes de error globales `[frontend]`
**Fechas:** 5 jul → 8 jul

### ¿Qué estamos haciendo y por qué?

La rúbrica nos bajó puntos porque los formularios no tienen validaciones visibles, los errores no le llegan al usuario y los botones no dicen bien qué hacen. Vamos a revisar **todas las páginas** y arreglarlo.

### Pasos

1. **Revisar formularios uno por uno.** En cada página con formulario (Productos, Ventas, Inventario, Login, Gestión Usuarios, Dashboard), asegurate que:
   - Los campos requeridos tengan un indicador visible (ej: asterisco rojo o texto "obligatorio")
   - Antes de enviar, se validen: email con @, password ≥ 8 caracteres, números donde corresponda
   - Si la validación falla, mostrar el error al lado del campo (no un alert() genérico)

2. **Revisar llamadas API.** Cada `fetch` debe tener un `.catch()` o `try/catch` que muestre un mensaje visible al usuario. Nada de `console.log`. Los mensajes deben estar en español y ser específicos:
   - Mal: "Error 500"
   - Bien: "No se pudieron cargar los productos. Intenta de nuevo."

3. **Revisar botones.** Si un botón tiene solo un icono sin texto, agregale un label. Ej: el botón "+" debe decir "Agregar producto" o al menos tener un tooltip.

4. **Probar casos borde:** enviar formulario vacío, email inválido, password corta, y verificar que los mensajes de error aparezcan.
