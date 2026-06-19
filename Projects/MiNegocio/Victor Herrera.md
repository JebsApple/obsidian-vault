---
tags: [proyecto/minegocio, integrante, victor, database]
---

# Victor Herrera — Base de Datos (PostgreSQL)

## Responsabilidad

Esquema principal de la base de datos, migraciones, y coordinación de merges entre repos.

## Archivos a su cargo

### `minegocio-database/postgres/esquema.sql`

Define las tablas `usuarios` y `productos` con sus constraints, índices, y relaciones.

**Línea por línea:**

- `CREATE TABLE public.productos (...)` — tabla principal de productos con campos: `id` (PK auto-incremental), `nombre` (255 chars, NOT NULL), `codigo_barras` (único, nullable para scanning), `precio_compra` y `precio_venta` (enteros >= 0), `stock` (>= 0 default 0), `imagen_url` (texto nullable), `descripcion`, `categoria`, `marca`, `fecha_ingreso` (default now()), `id_usuario` (FK), `activo` (default true para soft delete).

- `CREATE TABLE public.usuarios (...)` — usuarios del sistema con `id` PK, `nombre`, `email` (UNIQUE para login), `password_hash` (el hash, no texto plano teóricamente, aunque el login legacy compara password_hash directamente), `rol` (admin/vendedor), `activo`, timestamps.

- `CREATE VIEW public.inventario_view AS ...` — vista que calcula estado del stock: 'Normal' (stock >= 5), 'Bajo' (1-4), 'Agotado' (0). Usada por el endpoint `/api/inventario`.

- Índices: `idx_productos_activo`, `idx_productos_categoria`, `idx_productos_nombre`, `idx_productos_codigo_barras`, `idx_usuarios_email`, `idx_usuarios_rol`.

- FK: `productos.id_usuario → usuarios.id ON DELETE SET NULL`.

**Flujo:** Los repositorios Go (`producto_repository.go`, `usuario_repository.go`) hacen SELECT/INSERT/UPDATE contra estas tablas.

### `minegocio-database/postgres/backup_server.sql`

Dump completo del cluster (726 líneas). Crea roles `postgres` y `app_user`, bases `cliente_dev` y `cliente_prod` con sus respectivos datos seed.

**Para exponer:** Explicar que es un `pg_dumpall` del servidor PostgreSQL, que incluye tanto el esquema como los datos de ejemplo (usuarios admin/admin con hash).

### `minegocio-database/inventario_view.sql`

```sql
CREATE OR REPLACE VIEW inventario_view AS
SELECT id, nombre, stock,
    CASE WHEN stock >= 5 THEN 'Normal'
         WHEN stock BETWEEN 1 AND 4 THEN 'Bajo'
         ELSE 'Agotado'
    END AS estado
FROM productos;
```

**Línea por línea:**
1. `CREATE OR REPLACE VIEW` — crea o reemplaza la vista (idempotente, seguro ejecutar múltiples veces)
2. `SELECT id, nombre, stock` — columnas de la tabla productos
3. `CASE WHEN ... END AS estado` — lógica de negocio: clasifica cada producto según su nivel de stock
4. `FROM productos` — fuente de datos

### `minegocio-database/registro-ventas/sprint2_create_registro_ventas.sql`

```sql
CREATE TABLE IF NOT EXISTS public.registro_ventas (
    id_venta        SERIAL PRIMARY KEY,
    id_producto     INTEGER NOT NULL REFERENCES public.productos(id),
    precio_producto INTEGER NOT NULL CHECK (precio_producto >= 0),
    cantidad        INTEGER NOT NULL CHECK (cantidad > 0),
    fecha_venta     TIMESTAMP NOT NULL DEFAULT now(),
    id_vendedor     INTEGER REFERENCES public.usuarios(id) ON DELETE SET NULL
);
```

**Línea por línea:**
1. `IF NOT EXISTS` — evita error si ya existe
2. `id_venta SERIAL PRIMARY KEY` — auto-incremental, clave primaria
3. `id_producto INTEGER NOT NULL REFERENCES productos(id)` — FK obligatoria al producto vendido
4. `precio_producto INTEGER CHECK (>=0)` — precio en el momento de la venta (histórico, no se actualiza si cambia después)
5. `cantidad INTEGER CHECK (>0)` — unidades vendidas
6. `fecha_venta TIMESTAMP DEFAULT now()` — sellado de tiempo automático
7. `id_vendedor INTEGER REFERENCES usuarios(id) ON DELETE SET NULL` — quién vendió, nullable si el usuario se elimina
8. Índices para búsqueda por producto, vendedor y fecha

**Colaboradores:** IgVml creó el script original de la tabla `registro_ventas` (S2-HU02).

## Cómo explicar el flujo en capas (Database)

```
Cliente (Vue.js)
  → fetch('/api/inventario')
    → Nginx proxy (8080 → localhost:3000)
      → Go Router (routes.go)
        → Handler (inventario_handler.go)
          → Service (inventario_service.go)
            → Repository (inventario_repository.go): SELECT * FROM inventario_view
              → PostgreSQL: ejecuta la VIEW que hace CASE WHEN sobre productos
```

## Relación con otros integrantes

- **Gabriel:** los repositorios Go que él escribe dependen de este esquema
- **Nicolás:** el endpoint `/api/inventario` usa la `inventario_view` que creaste
- **Ignacio:** la galería y tabla de productos dependen de `productos`
