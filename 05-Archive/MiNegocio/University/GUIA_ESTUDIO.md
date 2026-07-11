# Guía de Estudio — MiNegocio Frontend

> Explicación línea a línea para presentación al profesor.
> Versión: S3-HU02-T14 (Sidebar colapsable + Tabs folder + Responsive)

---

## Índice

1. [Visión general de la aplicación](#1-visión-general)
2. [Tecnologías usadas y por qué](#2-tecnologías)
3. [Estructura del proyecto](#3-estructura)
4. [Flujo del usuario](#4-flujo-del-usuario)
5. [Explicación por archivo](#5-explicación-por-archivo)
6. [Cómo se comunican los componentes](#6-comunicación)
7. [Animaciones con keyframes](#7-animaciones)
8. [Responsive Design](#8-responsive)

---

## 1. Visión general de la aplicación

MiNegocio es un sistema web de gestión comercial (POS) que permite:

- Registrar y administrar productos
- Controlar inventario con tablero Kanban
- Realizar ventas
- Gestionar usuarios (admin)

Está construida como **SPA (Single Page Application)** con Vue 3, lo que
significa que toda la interfaz se carga una sola vez y las transiciones entre
páginas ocurren sin recargar el navegador.

---

## 2. Tecnologías usadas y por qué

| Tecnología | Propósito |
|------------|-----------|
| **Vue 3** | Framework frontend progresivo. Elegido por su sintaxis clara, sistema de componentes y ecosistema maduro. Permite crear SPA de forma rápida con Composition API. |
| **Vue Router** | Enrutamiento del lado del cliente. Sin recarga de página al cambiar entre Dashboard, Ventas, Inventario, etc. |
| **Vite** | Bundler ultrarrápido para desarrollo y build de producción. |
| **Vitest** | Testing unitario que corre sobre Vite, sin necesidad de configuración extra. |
| **Tabler Icons** | Librería de iconos SVG (ti-*). Elegida por tener ~5000 iconos limpios y ser gratuita. |
| **CSS3 (vars + keyframes)** | Estilos con variables CSS para theming y animaciones con `@keyframes` para transiciones suaves. Sin framework de UI (Tailwind, Bootstrap) — se priorizó CSS vanilla para control total. |
| **localStorage** | Persistencia del token JWT del lado del cliente. |

---

## 3. Estructura del proyecto

```
proyecto/minegocio-frontend/
├── src/
│   ├── App.vue                 ← Componente raíz (layout, sidebar, breakpoints)
│   ├── main.js                 ← Punto de entrada (crea la app Vue)
│   ├── components/
│   │   ├── SideBar.vue         ← Menú lateral colapsable
│   │   ├── BuscadorProductos.vue  ← Buscador + filtros reutilizable
│   │   ├── GaleriaProductos.vue   ← Grid de tarjetas de productos
│   │   └── KanbanBoard.vue     ← Tablero Kanban para inventario
│   ├── views/
│   │   ├── Productos.vue       ← Página unificada de productos
│   │   └── Inventario.vue      ← Página de inventario con Kanban + Stock
│   ├── services/               ← Llamadas HTTP al backend (API)
│   ├── router/                 ← Configuración de rutas
│   └── styles/
│       └── productos.css       ← Estilos compartidos entre Productos e Inventario
├── docs/
│   ├── COMENTARIOS.md
│   ├── TAIGA.md
│   └── GUIA_ESTUDIO.md         ← Este archivo
└── package.json
```

---

## 4. Flujo del usuario

### Escenario típico: Gestión de stock

```
1. Usuario se loguea
   → App.vue detecta token en localStorage
   → Muestra SideBar + router-view

2. Usuario hace clic en "Inventario"
   → Vue Router navega a /inventario
   → Inventario.vue se monta
   → Llama a inventarioService.getAll() + productosService.getAll()
   → Combina datos en items[] con _editStock temporal

3. Usuario ve dos pestañas: "Tablero" | "Stock"
   → Pestaña activa controlada por vistaActiva ('tablero' | 'stock')
   → Transición fade-slide entre vistas

4. En pestaña "Stock", edita cantidad directamente en la tabla
   → v-model en input modifica item._editStock (sin guardar aún)
   → Clase .stock-dirty aparece si el valor cambió
   → Usuario hace clic en icono de disco (guardar)
   → Se llama actualizarStock(item)
   → inventarioService.updateStock(id, nuevoStock)
   → Si éxito: recarga items[]
   → Si error: modal de alerta

5. Si la ventana es angosta (<60% pantalla)
   → Aparece botón ^ en sidebar
   → Al colapsar, App.vue cambia flex-direction a column
   → SideBar se achica a solo logo + nombre
   → Botón v para expandir de nuevo
```

---

## 5. Explicación por archivo

### 5.1 App.vue — Raíz y layout

```vue
<template>
  <div id="app" :class="{ 'app-logged-in': isLoggedIn }">
```

**Línea 1**: El contenedor raíz de toda la app. La clase `app-logged-in` se
aplica solo cuando hay sesión activa, activando estilos específicos.

```vue
    <div class="app-layout" :class="{ 
      'layout-full': isLoggedIn, 
      'sidebar-colapsado': isLoggedIn && sidebarColapsado 
    }">
      <SideBar v-if="isLoggedIn" 
        :isLoggedIn="isLoggedIn" 
        :colapsado="sidebarColapsado" 
        :puedeColapsar="puedeColapsar" 
        @toggle-colapso="sidebarColapsado = !sidebarColapsado" />
```

**Líneas 5-11**: El layout principal tiene dos hijos: SideBar y main.
`sidebar-colapsado` añade `flex-direction: column` en CSS, haciendo que el
sidebar pase a ser horizontal y el contenido principal ocupe todo el ancho.

SideBar recibe props:
- `colapsado`: si está contraído
- `puedeColapsar`: si mostrar los botones toggle
- Escucha `@toggle-colapso` para cambiar el estado

```javascript
data() {
  return {
    token: localStorage.getItem('token'),
    sidebarColapsado: false,
    puedeColapsar: false
  }
},
```

**Líneas 39-44**: Estados reactivos del componente.
`sidebarColapsado` controla si el menú está contraído.
`puedeColapsar` se actualiza según el tamaño de ventana.

```javascript
mounted() {
  this.actualizarBreakpoint()
  window.addEventListener('resize', this.actualizarBreakpoint)
},

beforeUnmount() {
  window.removeEventListener('resize', this.actualizarBreakpoint)
},
```

**Líneas 50-55**: Ciclo de vida. Al montar, calcula el breakpoint y registra
el listener de resize. Al destruirse, limpia el listener para evitar que
siga ejecutándose si el componente ya no existe (memory leak).

```javascript
actualizarBreakpoint() {
  const limite = window.screen.width * 0.6
  if (window.innerWidth > limite) {
    this.sidebarColapsado = false
    this.puedeColapsar = false
  } else {
    this.puedeColapsar = true
  }
}
```

**Líneas 72-79**: Lógica del breakpoint. Si la ventana es más ancha que el
60% de la resolución del monitor, el sidebar se fuerza expandido y los botones
toggle se ocultan. Si la ventana es angosta, se permite colapsar.

```css
.app-layout.layout-full {
  height: calc(100vh - 56px);
  display: flex;
  overflow: hidden;
  transition: flex-direction 0.35s ease;
}

.app-layout.layout-full.sidebar-colapsado {
  flex-direction: column;
}
```

**CSS**: El layout usa flexbox. La transición en `flex-direction` no se anima
como tal (CSS no interpola row→column), pero combinada con `transition: height`
en `.main-content` y el cambio de tamaño del sidebar, produce un movimiento
suave.

```css
.sidebar-colapsado .sidebar {
  width: 100% !important;
  flex-direction: row;
  height: auto;
  border-right: none;
  border-bottom: 1px solid var(--color-border-light);
  align-items: center;
  overflow: visible;
}
```

Cuando el sidebar está colapsado, pasa de vertical (256px de ancho) a
horizontal (100% de ancho, automático de alto), actuando como una barra
superior delgada.

---

### 5.2 SideBar.vue — Menú lateral

```vue
<template>
  <aside class="sidebar" :class="{ 'sidebar--collapsed': colapsado }">
```

**Línea 1**: Etiqueta semántica `<aside>` para la barra lateral.
`sidebar--collapsed` reduce el ancho a `auto` (solo el logo cabe).

```vue
<span class="logo-text">
  <span class="logo-mi">Mi</span>Negocio
</span>
<button v-if="colapsado && puedeColapsar" class="toggle-btn" 
  @click.stop="$emit('toggle-colapso')" title="Abrir menú">
  <i class="ti ti-chevron-down"></i>
</button>
```

Logo con botón de expandir. `v-if="colapsado && puedeColapsar"` asegura que
solo se muestre cuando ambas condiciones se cumplen. `@click.stop` evita que
el clic se propague al `div` padre (que también tiene un click listener para
navegar a `/`).

```vue
<Transition name="sidebar-slide">
  <div v-show="!colapsado" class="sidebar-collapsible">
```

**Vue `<Transition>`**: Componente nativo de Vue que aplica clases CSS de
entrada/salida automáticamente cuando el elemento se muestra/oculta.

`v-show` mantiene el elemento en el DOM (solo oculta con display), lo que
evita que Vue destruya/recree los componentes hijos cada vez.

Las clases que Vue genera automáticamente:
- `sidebar-slide-enter-active` → durante la animación de entrada
- `sidebar-slide-leave-active` → durante la animación de salida

```css
.sidebar-slide-enter-active {
  animation: slideDown 0.35s cubic-bezier(0.25, 0.1, 0.25, 1);
}

@keyframes slideDown {
  0%   { max-height: 0; opacity: 0; }
  60%  { opacity: 0; }
  100% { max-height: 1000px; opacity: 1; }
}
```

**Keyframes**: La opacidad se mantiene en 0 hasta el 60% de la animación.
Esto significa que el contenedor se despliega primero (max-height crece) y
recién después aparece el contenido. Esto evita el feo efecto de "texto
arrastrándose mientras se despliega".

La curva `cubic-bezier(0.25, 0.1, 0.25, 1)` es la conocida como
"ease-in-out" suave: comienza lento, acelera en el medio y desacelera al
final, dando sensación natural.

```css
@keyframes slideUp {
  0%   { max-height: 1000px; opacity: 1; }
  40%  { opacity: 0; }
  100% { max-height: 0; opacity: 0; }
}
```

Al colapsar: opacity baja a 0 al 40% (el contenido se desvanece rápido) y
luego max-height se reduce a 0. El contenido "desaparece antes de plegarse".

```vue
props: {
  colapsado: { type: Boolean, default: false },
  puedeColapsar: { type: Boolean, default: false }
},
emits: ['toggle-colapso'],
```

Props documentan la interfaz del componente. `emits` es la forma moderna de
Vue 3 de declarar eventos. Esto permite trazabilidad: el padre sabe qué
eventos puede recibir.

---

### 5.3 Productos.vue — Página de productos

```vue
<BuscadorProductos @buscar="onBuscar" />

<div class="vista-switch">
  <button class="switch-btn" :class="{ active: vistaActiva === 'galeria' }"
    @click="vistaActiva = 'galeria'">
    Galería
  </button>
  <button class="switch-btn" :class="{ active: vistaActiva === 'registrados' }"
    @click="vistaActiva = 'registrados'">
    Registrados
    <span class="switch-badge">{{ todosProductos.length }}</span>
  </button>
</div>
```

- BuscadorProductos es un componente independiente que emite `@buscar` con los
  filtros. El padre (Productos) recibe los filtros y filtra la lista.
- `vistaActiva` es un string reactivo ('galeria' | 'registrados') que controla
  qué vista se muestra. Se usa `v-if` + `v-else` para mostrar una ú otra.
- El badge es un contador de productos totales, estilizado como píldora.

```vue
<Transition name="fade-slide" mode="out-in">
  <GaleriaProductos v-if="vistaActiva === 'galeria'" key="galeria" ... />
  <div v-else key="registrados"> ... </div>
</Transition>
```

`mode="out-in"` hace que primero salga la vista actual y luego entre la nueva.
El `key` en cada elemento es esencial para que Vue sepa que son componentes
diferentes y aplique la transición.

```css
.switch-btn {
  flex: 1;
  border-radius: 10px 10px 6px 6px;
  margin-bottom: -2px;
  border-bottom: 2px solid transparent;
}

.switch-btn.active {
  background: var(--color-brand);
  border-bottom-color: var(--color-brand);
}
```

**Efecto folder**: 
- `border-radius: 10px 10px 6px 6px` — las esquinas superiores son más
  redondeadas (10px) que las inferiores (6px), dando forma de lengüeta.
- `margin-bottom: -2px` — el botón se superpone 2px al borde inferior del
  contenedor.
- `border-bottom: 2px solid transparent` — reserva espacio para el borde.
- Cuando activo: `border-bottom-color` coincide con el background, haciendo
  que el borde inferior del botón se "fusione" con el borde del contenedor.

---

### 5.4 Inventario.vue — Página de inventario

```javascript
data() {
  return {
    items: [],
    cargando: true,
    vistaActiva: 'tablero'
  }
},
```

`vistaActiva` empieza en 'tablero' para que la vista por defecto sea el Kanban.

```javascript
async cargar() {
  this.cargando = true
  try {
    const [inventario, productos] = await Promise.all([
      inventarioService.getAll(),
      productosService.getAll()
    ])
    const prodMap = new Map(productos.map(p => [p.id, p]))
    this.items = inventario.map(item => ({
      ...item,
      imagen_url: prodMap.get(item.id)?.imagen_url,
      precio_venta: prodMap.get(item.id)?.precio_venta,
      codigo: prodMap.get(item.id)?.codigo_barras,
      _editStock: item.stock
    }))
  } catch (e) {
    await this.$modal.alert(e.message || 'Error al cargar el inventario.')
  } finally {
    this.cargando = false
  }
}
```

`Promise.all` ejecuta ambas llamadas HTTP en paralelo, no secuencial.
Esto reduce el tiempo de carga a la API más lenta, no a la suma de ambas.
`_editStock` se inicializa con el stock actual para que el input refleje
el valor existente y no aparezca vacío.

```vue
<div class="stock-inline">
  <input type="number" v-model.number="item._editStock" min="0"
    class="stock-inline-input"
    :class="{ 'stock-dirty': item._editStock !== undefined 
      && item._editStock !== item.stock }" />
  <button @click="actualizarStock(item)"
    :disabled="item._editStock === undefined || item._editStock === '' 
      || item._editStock === item.stock">
    <i class="ti ti-device-floppy"></i>
  </button>
</div>
```

**Edición inline**: el input está directamente en la celda de la tabla, no en
un modal o formulario aparte. `v-model.number` convierte automáticamente el
valor a número. `stock-dirty` resalta el input cuando el valor cambió.
El botón se deshabilita si el valor es inválido o igual al original.

---

### 5.5 GaleriaProductos.vue — Grid de tarjetas

```css
.galeria-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
}

@media (max-width: 1200px) {
  .galeria-grid { grid-template-columns: repeat(3, 1fr); }
}

@media (max-width: 768px) {
  .galeria-grid { grid-template-columns: repeat(2, 1fr); }
}

@media (max-width: 480px) {
  .galeria-grid { grid-template-columns: 1fr; }
}
```

CSS Grid con `repeat(n, 1fr)` distribuye el espacio disponible en n columnas
iguales. Los media queries van de mayor a menor (mobile-first sería al revés),
pero en este caso se lee como "por defecto 4, pero si la pantalla encoge,
reduce".

---

### 5.6 BuscadorProductos.vue — Filtros

```css
@media (max-width: 480px) {
  .buscador-filtros {
    flex-direction: column;
  }
  .filtro-grupo { width: 100%; }
  .filtro-grupo input[type="number"] { width: 100%; }
  .filtro-grupo select { width: 100%; }
}
```

En pantallas muy pequeñas, los filtros pasan de estar uno al lado del otro a
apilarse verticalmente, ocupando cada uno el ancho completo.

---

## 6. Comunicación entre componentes

### Props (padre → hijo)

```
App.vue
  ├── :colapsado → SideBar.vue
  ├── :puedeColapsar → SideBar.vue
  └── :productos → GaleriaProductos.vue (en Productos.vue)
```

Las props fluyen siempre del padre al hijo. Son de solo lectura en el hijo.

### Eventos (hijo → padre)

```
SideBar.vue
  └── @toggle-colapso → App.vue (cambia sidebarColapsado)

BuscadorProductos.vue
  └── @buscar(filtros) → Productos.vue / Inventario.vue
```

Los eventos permiten que el hijo notifique algo al padre. Se emiten con
`$emit('nombre-evento', dato)`.

### Provide/Inject

```javascript
// En App.vue o componente raíz
provide() {
  return { $modal: this.$modal }
}

// En cualquier hijo
inject: ['$modal']
```

Sistema de dependencias: un componente "provee" un valor y cualquier
descendiente puede "inyectarlo" sin pasarlo por todos los niveles intermedios.

### Transiciones (Vue `<Transition>`)

```vue
<Transition name="fade-slide" mode="out-in">
```

Vue aplica automáticamente clases como:
- `.fade-slide-enter-active` (mientras entra)
- `.fade-slide-leave-active` (mientras sale)
- `.fade-slide-enter-from` (estado inicial de entrada)
- `.fade-slide-leave-to` (estado final de salida)

Con `@keyframes`, usamos `animation` en `*-enter-active`/`*-leave-active`
para controlar el comportamiento completo en un solo lugar.

---

## 7. Animaciones con keyframes

### ¿Por qué keyframes en vez de transition?

| Transition | Keyframes |
|---|---|
| Solo interpola entre dos valores | Múltiples pasos (0%, 60%, 100%) |
| Misma curva para ida y vuelta | Curvas diferentes para enter/leave |
| No controla timing intermedio | Control total sobre estados intermedios |
| Fill mode limitado | `both` retiene estado inicial/final |

### Animaciones implementadas

| Nombre | Propósito | Detalle |
|---|---|---|
| `slideDown` | Expandir sidebar | Opacity 0 hasta 60% (primero baja, luego aparece) |
| `slideUp` | Colapsar sidebar | Opacity 0 al 40% (primero desaparece, luego sube) |
| `fadeSlideIn` | Entrada de vista | Opacity 0→1 + translateX(14px)→0 |
| `fadeSlideOut` | Salida de vista | Opacity 1→0 + translateX(0)→(-14px) |

Todas usan `cubic-bezier(0.25, 0.1, 0.25, 1)` para consistencia visual.

---

## 8. Responsive Design

### Breakpoints

| Breakpoint | Qué cambia |
|---|---|
| ≤1200px | Galería: 4 → 3 columnas |
| ≤768px | Galería: 3 → 2 columnas, Page padding reduce, Sidebar modo horizontal |
| ≤480px | Galería: 2 → 1 columna, Filtros apilados, Page padding mínimo |

### Breakpoint del sidebar (lógica JS, no media query)

```
window.innerWidth > window.screen.width * 0.6 → sidebar fijo expandido
```

Se usa JS en lugar de media query porque la condición depende del ancho de
pantalla disponible (`window.screen.width`), no solo del viewport. La idea es:
"si tengo al menos 60% del monitor, que el menú se quede abierto; si estoy
usando menos espacio (ventana chica, tablet), permitir colapsar".

### Transiciones responsivas

Todas las animaciones y cambios de layout tienen `transition` CSS para evitar
saltos bruscos al redimensionar. Los media queries cambian propiedades
estructurales (grid-template-columns, flex-direction, padding) pero el
navegador interpola entre layouts porque los elementos se reacomodan
naturalmente con flexbox/grid.

---

## Conceptos clave de Vue 3 vistos en este código

| Concepto | Dónde se usa | Explicación |
|---|---|---|
| `v-if` / `v-show` | SideBar, tabs | `v-if` destruye/crea el DOM; `v-show` solo oculta con display:none |
| `v-model.number` | Input stock | Two-way binding con conversión automática a número |
| `:class="{}"` | Todos los componentes | Binding dinámico de clases CSS según estado |
| `@click` / `@click.stop` | Botones, toggles | Event listeners; `.stop` evita propagación |
| `$emit` | SideBar → App | Evento personalizado hacia el padre |
| `props` | SideBar, Galeria | Datos que fluyen del padre al hijo (solo lectura) |
| `computed` | SideBar.usuarioNombre | Valores derivados que se recalculan cuando cambian sus dependencias |
| `watch` | SideBar.$route | Observa cambios en una propiedad y ejecuta lógica |
| `mounted` / `beforeUnmount` | App.vue | Ciclo de vida: al montar y al destruir |
| `<Transition>` | SideBar, tabs | Componente nativo para animaciones de entrada/salida |
| `provide` / `inject` | Modal | Pasar dependencias sin props en cascada |
| `Promise.all` | Inventario.cargar | Ejecutar promesas en paralelo |
| CSS `@keyframes` | SideBar, tabs | Animaciones con múltiples pasos y timing preciso |
| CSS `cubic-bezier()` | Todas las animaciones | Curvas de velocidad para movimiento natural |
