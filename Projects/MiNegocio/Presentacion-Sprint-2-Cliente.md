---
tags: [proyecto/minegocio, presentacion, sprint-2, cliente]
---

# Presentación Sprint 2 — MiNegocio

**Fecha:** 2026-06-20  
**Presentan:** Gabriel Flores, Ignacio Varela, Nicolás Valdés, Victor Herrera  
**URL Demo:** http://192.168.50.25:8000  
**Credenciales Demo:** `Victor@user.cl` / `Victor264`

---

## 1. ¿Qué es MiNegocio?

Sistema web de gestión de negocio: inventario, ventas, productos y usuarios.

- **Dueño del negocio** → administra productos, ve estadísticas, controla stock
- **Vendedor** → registra ventas rápido, consulta inventario
- Stack: Vue 3 + Go + PostgreSQL + Docker + Jenkins CI/CD

---

## 2. Funcionalidades Completadas (Sprint 2)

### 2.1 Autenticación JWT
- Login/Registro con tokens seguros
- Token de acceso (24h) + refresh token (7 días)
- Rutas protegidas — sin token no se puede acceder
- Cierre de sesión desde Navbar
- Registro de sesiones (quién y cuándo inicia/cierra)

### 2.2 CRUD de Productos
- Crear, listar, editar y eliminar productos
- Campos: nombre, código de barras, precios (compra/venta), stock, descripción, categoría, marca
- Soft delete (no se pierden datos, solo se desactivan)
- Cálculo automático de ganancia estimada en tiempo real

### 2.3 Galería con Búsqueda y Filtros
- Cuadrícula responsiva (4 → 2 → 1 columna)
- Cards con imagen, precio, stock y acciones
- Búsqueda con debounce (400ms de espera)
- Filtros: precio mínimo/máximo, estado de stock
- Ordenamiento por nombre, precio o stock
- Paginación (12 productos por página)
- Badge de stock: Verde (Normal), Naranja (Bajo), Rojo (Agotado)

### 2.4 Carga de Imágenes Drag & Drop
- Arrastrar imagen desde el explorador de archivos
- Validación por magic bytes (JPEG, PNG, WebP) — seguridad real
- Límite de 5MB
- Vista previa antes de guardar
- Eliminación de imágenes

### 2.5 Escáner de Código de Barras
- Funciona con cualquier escáner USB (emula teclado)
- Detecta si el código ya existe → pre-rellena para editar
- Si es nuevo → limpia formulario y deja el código listo
- Sin librerías externas, usa eventos nativos del DOM

### 2.6 Punto de Venta (POS)
- Panel izquierdo: productos disponibles
- Panel derecho: carrito de compras
- Búsqueda rápida de productos
- Ajuste de cantidades desde el carrito
- Confirmación → descuenta stock automáticamente
- Transacción SQL: si falta stock, la venta no se concreta

### 2.7 Inventario con Estados
- Tabla de stock con estado calculado automáticamente:
  - **Normal**: 5+ unidades
  - **Bajo**: 1-4 unidades
  - **Agotado**: 0 unidades
- Vista SQL que calcula el estado sin lógica en código

### 2.8 Historial de Ventas
- Lista completa con producto, cantidad, precio, fecha y vendedor
- Ordenado por fecha descendente (más reciente primero)

### 2.9 Dashboard de Servicios
- Menú central con acceso a todas las secciones
- Diseño responsivo desde 375px (celulares)
- Paleta corporativa: rojo `#D60000`, blanco, negro
- Navbar con enlaces a todas las secciones

---

## 3. Arquitectura del Sistema (para diagramas en Canva)

### 3.1 Vista General

```
[Usuario/Navegador]
       ↕
  [Nginx]
  ↕            ↕
[Frontend]  [Backend Go]
  (Vue 3)    (API REST)
                ↕
          [PostgreSQL]
```

### 3.2 Capas del Backend

```
Ruta (método + URL)
  → Middleware (JWT, upload)
    → Handler (recibe HTTP, responde JSON)
      → Service (lógica de negocio)
        → Repository (queries SQL)
```

### 3.3 Servidores

| Servidor | IP | Rol |
|----------|-----|-----|
| Server A (Jenkins, Gitea) | 192.168.50.28 | CI/CD, repositorio git, SonarQube |
| Server B (Producción) | 192.168.50.25 | Backend Docker + Frontend + nginx |

### 3.4 Pipeline CI/CD

```
Push a main → Jenkins (webhook)
  → Checkout → Tests → Build Docker → Deploy
```

---

## 4. Mapa de Navegación (para diagrama en Canva)

```
/login
  → /servicios (Dashboard)
       ├── /productos           → CRUD + código de barras
       ├── /productos-registrados → Galería con buscador
       ├── /ventas              → Punto de venta POS
       ├── /inventario          → Stock con estados
       └── /registro-ventas     → Historial
```

---

## 5. Historias de Usuario

| ID | Funcionalidad | Responsable |
|----|--------------|-------------|
| S2-HU01 | Login con JWT | Gabriel Flores |
| S2-HU02 | Punto de Venta (carrito + registro) | Ignacio Varela |
| S2-HU03 | CRUD productos | Nicolás Valdés |
| S2-HU04 | Galería + imágenes + barcode | Victor Herrera |
| S2-HU05 | Inventario con estados | Nicolás Valdés |
| S2-HU06 | Historial de ventas | Ignacio Varela |
| S2-HU07 | Registro de sesiones | Gabriel Flores |
| S2-HU08 | UX responsivo + paleta | Victor Herrera |

---

## 6. Stack Tecnológico

- **Frontend:** Vue.js 3, vue-router, fetch API
- **Backend:** Go, gorilla/mux, JWT, bcrypt
- **Base de datos:** PostgreSQL 16
- **CI/CD:** Jenkins, Docker, Gitea
- **Servidor:** nginx, Ubuntu
- **Calidad:** SonarQube (análisis estático)

---

## 7. Demo — Flujo Recomendado (10 min)

1. **Login** (1 min) — formulario, ingreso, ver Dashboard
2. **Dashboard** (30s) — menú con todas las opciones
3. **Registrar producto** (2 min) — formulario + escáner código barras
4. **Subir imagen** (1 min) — drag & drop + preview
5. **Galería** (1 min) — buscar producto, filtrar por precio
6. **Venta** (2 min) — POS, agregar al carrito, confirmar
7. **Inventario** (30s) — stock actualizado post-venta
8. **Historial** (30s) — venta registrada en el listado
9. **Cierre** (30s) — cerrar sesión

---

## 8. Slides Sugeridas para Canva

1. **Portada** — "MiNegocio Sprint 2" + integrantes
2. **Problema** — Negocio sin control digital
3. **Solución** — SaaS web, accesible desde cualquier dispositivo
4. **Arquitectura** — Diagrama servidores + capas
5. **Navegación** — Mapa de pantallas con flechas
6. **Autenticación** — Pantalla login + flujo JWT
7. **Catálogo** — CRUD + código de barras
8. **Galería** — Grid de productos + búsqueda
9. **Punto de Venta** — POS con carrito
10. **Inventario** — Tabla con badges de colores
11. **Ventas** — Historial
12. **CI/CD** — Pipeline Jenkins
13. **Stack** — Logos de tecnologías
14. **Sprint 3** — Lo que viene: bcrypt, roles, Kanban

---

## 9. Datos Técnicos Clave

| Aspecto | Respuesta |
|---------|-----------|
| ¿Cómo se validan imágenes? | Magic bytes (no confiar en extensión) |
| Tamaño máximo | 5MB |
| Formatos | JPEG, PNG, WebP |
| ¿Dónde se guarda el archivo? | En disco, ruta en base de datos |
| Duración del token | 24h acceso, 7d refresh |
| Algoritmo JWT | HMAC-SHA256 |
| ¿Cómo se descuenta stock? | Transacción SQL (INSERT venta + UPDATE stock) |
| Protección de rutas | Middleware JWT en backend |
| Responsive | 4 → 2 → 1 columna |
| Despliegue | Docker + Jenkins + nginx |

---

## 10. Integrantes

| Integrante | Feature | Tecnología clave |
|------------|---------|-----------------|
| **Gabriel Flores** | JWT Auth + Sesiones + Registro | Go, JWT, bcrypt |
| **Ignacio Varela** | POS Ventas + Carrito + Historial | Vue 3, SQL transaccional |
| **Nicolás Valdés** | Inventario + Código barras + CRUD | SQL VIEW, escáner HID |
| **Victor Herrera** | Imágenes + Galería + DB + CI/CD | Magic bytes, Docker, drag&drop |

---

## 11. Recursos para la Presentación

- **URL demo:** http://192.168.50.25:8000
- **Usuario demo:** `Victor@user.cl` / `Victor264`
- **Gitea:** http://192.168.50.28:3000
- **Jenkins:** http://192.168.50.28:8080 (equipo6 / equipo!"#$)
- **SonarQube:** http://192.168.50.28:9000
- **Diagrama servidores:** Referencia `Knowledge/conexion-remota.md`
