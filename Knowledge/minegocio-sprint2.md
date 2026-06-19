---
tags: [proyecto/minegocio, sprint-2, plan]
---

# Minegocio — Sprint 2: Plan de trabajo

**Fecha:** 2026-06-18  
**Proyecto:** Minegocio (ignaciovm-minegocio)  
**Repo:** `/home/apuru/minegocio`

---

## Fase 1 — Bugs existentes

### 1.1 Login muestra "admin" arriba a la derecha
- **Problema:** `TokenResponse` no incluye datos del usuario. `NavBar.vue` lee `localStorage.getItem('usuario')` que nunca se guarda.
- **Fix:** Agregar `nombre`, `email`, `rol` al `TokenResponse` en Go. `LoginPage.vue` guarda `localStorage.setItem('usuario', JSON.stringify({nombre, email, rol}))`.
- Archivos: `models/models.go`, `service/auth_service.go`, `handler/auth_handler.go`, `LoginPage.vue`

### 1.2 Restaurar FormularioProducto.vue
- **Problema:** Se eliminó el componente standalone `FormularioProducto.vue`.
- **Fix:** Extraer del `front.zip` en Descargas y restaurarlo. Integrar como componente en `ProductosPage.vue`.
- Archivos: `src/components/FormularioProducto.vue` (nuevo), `ProductosPage.vue`

---

## Fase 2 — Registro de usuarios

### 2.1 Backend
- Agregar `Insert` a `repository/usuario_repository.go`
- Agregar `Register` a `service/auth_service.go`
- Agregar `Register` handler a `handler/auth_handler.go`
- Ruta `POST /api/register` (pública) en `routes/routes.go`

### 2.2 Frontend
- Formulario de registro en `LoginPage.vue` con toggle Login/Registro
- Campos: nombre, email, password

---

## Fase 3 — Productos / Inventario

### 3.1 Botón "Editar Productos" en inventario
- Enlace desde `InventarioPage.vue` → `/productos-registrados` o `/productos`

### 3.2 Eliminar producto (soft delete)
- Botón eliminar con confirmación en tabla de `ProductosPage.vue`.
- Backend ya tiene `DELETE /api/productos/{id}` que hace `activo=false`.

---

## Fase 4 — Estilos

### 4.1 Arreglar márgenes y espaciado
- Botones e inputs tienen espaciado inconsistente.
- Ajustar padding/margin en `variables.css` y `base.css`.

### 4.2 Separar CSS en capas
- `variables.css` — design tokens (ya existe)
- `base.css` — reset, layout, tipografía (ya existe)
- `components.css` — botones, cards, badges compartidos (nuevo)
- `productos.css`, `inventario.css`, `login.css`, `ventas.css` — específicos de página
- Eliminar: `home.css`, `servicios.css`, `contacto.css`, `carritocompras.css`

---

## Fase 5 — Zips, Git y documentación

### 5.1 Extraer zips
```bash
mkdir -p /home/apuru/minegocio-extracted/{back,front,database}
unzip /home/apuru/Descargas/back.zip -d /home/apuru/minegocio-extracted/back/
unzip /home/apuru/Descargas/front.zip -d /home/apuru/minegocio-extracted/front/
unzip /home/apuru/Descargas/database.zip -d /home/apuru/minegocio-extracted/database/
```

### 5.2 Comparar cambios
```bash
diff -rq /home/apuru/minegocio-extracted/back/ /home/apuru/minegocio/minegocio-backend/ | grep -v node_modules
```

### 5.3 Git
```bash
cd /home/apuru/minegocio
git init
git add -A && git commit -m "chore: baseline sprint 2"
git checkout -b develop
# Por cada feature crear rama desde develop
```

### 5.4 Ramas propuestas
| Rama | Base | Propósito |
|------|------|-----------|
| `main` | — | Producción |
| `develop` | `main` | Integración |
| `feature/registro-usuarios` | `develop` | Registro + login fix |
| `feature/mejoras-UI` | `develop` | Estilos, FormularioProducto, botones |

## Base de datos

### Tabla registro_ventas
Creada/recreada para coincidir con `venta_repository.go`:

```sql
CREATE TABLE public.registro_ventas (
    id_venta        SERIAL PRIMARY KEY,
    id_producto     INTEGER NOT NULL REFERENCES public.productos(id),
    precio_producto INTEGER NOT NULL CHECK (precio_producto >= 0),
    cantidad        INTEGER NOT NULL CHECK (cantidad > 0),
    fecha_venta     TIMESTAMP NOT NULL DEFAULT now(),
    id_vendedor     INTEGER REFERENCES public.usuarios(id) ON DELETE SET NULL
);
```

Migración en `migrations/002_create_registro_ventas.sql`.

---

## Resumen de archivos a modificar

### Backend
- `models/models.go` — agregar campos a TokenResponse
- `service/auth_service.go` — Register() + Login devuelve usuario
- `handler/auth_handler.go` — Register handler
- `repository/usuario_repository.go` — Insert()
- `routes/routes.go` — POST /api/register

### Frontend
- `src/views/LoginPage.vue` — registro + guardar usuario
- `src/components/NavBar.vue` — ya lee usuario (no tocar)
- `src/components/FormularioProducto.vue` — restaurar del zip
- `src/views/ProductosPage.vue` — integrar FormularioProducto, botón eliminar
- `src/views/InventarioPage.vue` — enlace "Editar Productos"
- `src/styles/variables.css` — ajustar espaciado
- `src/styles/base.css` — ajustar espaciado
- `src/styles/components.css` — nuevo (botones/cards compartidos)
