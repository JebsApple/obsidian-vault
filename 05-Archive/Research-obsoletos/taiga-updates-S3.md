---
tags: [proyecto/minegocio, taiga, sprint-3, update]
---

# Taiga — Actualización de tareas S3 (post-arquitectura dev/prod)


---

## Nueva tarea: S3-HU05 — Separación de Entornos Dev/Prod

> **UX:** 0 | **Design:** 0 | **Front:** 0 | **Back:** 2 | **DevOps:** 3 | **Total:** 5
>
> **Como** administrador del sistema, **quiero** entornos de desarrollo y producción separados con sus propios usuarios de base de datos **para** evitar que cambios en dev afecten a prod y cumplir con el principio de mínimo privilegio.

### Tareas

#### S3-HU05-T01: Usuarios PostgreSQL dedicados (Victor) — 27 jun
Crear `minegocio_dev` y `minegocio_prod` en PostgreSQL nativo con permisos mínimos. Cada uno solo puede conectar a su base de datos correspondiente. Eliminar dependencia del superusuario `postgres`.

#### S3-HU05-T02: Dockerizar backend DEV en :3000 (Victor) — 27 jun → 28 jun
Buildear imagen `minegocio-backend:dev`, correr contenedor `minegocio-backend-dev` en puerto `:3000` con variables de entorno apuntando a `cliente_dev` / `minegocio_dev`.

#### S3-HU05-T03: Migrar backend PROD a minegocio_prod (Victor) — 28 jun
Actualizar contenedor `minegocio-backend` (`:3001`) para usar `minegocio_prod` en vez de `postgres`. Verificar que sigue funcionando.

#### S3-HU05-T04: Limpieza (Victor) — 28 jun
Eliminar Docker frontend fantasma (`:8081`). Detener `sandbox-db`. Verificar que solo queden 2 contenedores activos (PROD + DEV).

---

## Tareas existentes que cambian

| Tarea | Cambio | Impacto |
|-------|--------|---------|
| **S3-HU01-T13** (Ignacio) | Ya no es "crear 1 usuario DB" → ahora es "documentar" los 2 usuarios que Victor ya creó. El alcance se reduce a documentación + verificación. | **Alcance reducido.** Fechas pasan de `5→7 jul` a `2→3 jul`. |
| **S3-HU01-T11** (Victor) | README ahora debe incluir tabla de entornos con: puertos nginx, puertos backend, usuarios DB, cómo buildear/deployar manualmente DEV, cómo Jenkins deploya PROD. | **Alcance extendido.** |
| **S3-HU01-T03** (Nicolás) | Sin cambios. Jenkins ya deploya solo a PROD desde `main`. No deploya a DEV. | ✅ Sin cambios |
| **S3-HU01-T12** (Nicolás) | Sin cambios. Frontend CI/CD solo deploya a `/var/www/prod/frontend/` desde `main`. | ✅ Sin cambios |

## Tareas existentes que NO cambian

S3-HU01-T01, T02, T04, T05, T06, T07, T08, T10, T14.
S3-HU02 entera (T01-T05).
S3-HU03 entera (T01-T05).
S3-HU04 entera (T01-T03).

---

## Dependencias actualizadas

```
S3-HU05-T01 (Victor, 27 jun)
  └── Bloquea S3-HU01-T13 (Ignacio, 2→3 jul) — necesita que los usuarios existan para documentarlos
  └── Bloquea S3-HU05-T02 (Victor, 27→28 jun) — necesita minegocio_dev para el contenedor DEV
  └── Bloquea S3-HU05-T03 (Victor, 28 jun) — necesita minegocio_prod para actualizar PROD
      └── Bloquea S3-HU01-T11 (Victor, 27→30 jun) — necesita la arquitectura final para documentarla
```

## Resumen de asignaciones actualizado

| Tarea | Descripción | Asignado | Fechas |
|-------|-------------|----------|--------|
| S3-HU05-T01 | Usuarios PostgreSQL dedicados | Victor | 27 jun |
| S3-HU05-T02 | Dockerizar backend DEV en :3000 | Victor | 27→28 jun |
| S3-HU05-T03 | Migrar PROD a minegocio_prod | Victor | 28 jun |
| S3-HU05-T04 | Limpieza contenedores fantasma | Victor | 28 jun |
| S3-HU01-T13 | Documentar usuarios DB (alcance reducido) | Ignacio | 2→3 jul |
| S3-HU01-T11 | README con arquitectura 2 entornos (extendido) | Victor | 27→30 jun |
