# Pendiente — S3-HU02-T12: Código de barras + usuarios de prueba y acceso por rol

**Fecha:** 2026-06-28
**Estado:** Cambios aplicados en local, **SIN commit ni push** (a pedido). Pendiente de revisión visual y de decidir commits/push.

## Resumen
Tres frentes: bug de código de barras en la galería, usuarios de prueba DEV + control de acceso por rol, y actualización de READMEs. Frontend verificado: compila en `:8082` y **53/53 tests pasan**.

## Ramas creadas (con cambios sin commitear)
- **frontend:** `S3-HU02-T12-codigo-barras-y-acceso-roles` (desde `S3-HU02`)
- **backend:** `S3-HU02-T08-readme-credenciales` (desde `S3-HU02-T07-capas-backend`)
- **database:** `feat/S3-HU02-seed-usuarios` (desde `feat/S3-HU02`)

> Nota: backend y database ya tenían cambios WIP previos (no míos) en `README.md` / `esquema.sql`. Al commitear, agregar **solo** los archivos de esta tarea.

## Cambios por repo

### Frontend (`minegocio-frontend`)
- **`src/components/GaleriaProductos.vue`** — bug arreglado: la vista "Productos Registrados" no mostraba el código de barras. Causa: la galería no renderizaba `codigo_barras` (el backend SÍ lo devuelve en `/api/productos` y `/api/productos/buscar`). Se añadió `<div class="card-codigo"><i class="ti ti-barcode"></i> {{ p.codigo_barras || '—' }}</div>` + estilo `.card-codigo` (mono, discreto).
- **`src/router/index.js`** — control de acceso por rol: la ruta `/admin/usuarios` lleva `meta.requiresAdmin`; el `beforeEach` ahora redirige a `/` si `getUserFromToken()?.rol !== 'admin'`. Antes solo se ocultaba el enlace (accesible por URL).
- **`src/components/SideBar.vue`** — el icono de **Productos** se muestra en rojo (`var(--color-brand)`) cuando el usuario está en un submenú (`/productos` o `/productos-registrados`), vía computed `enProductos` + clase `.nav-group-trigger--activo`.
- **`README.md`** — tabla DEV: `admin/1234` → `administrador/1234` (Administrador) y nueva fila `usuario/1234` (Usuario, sin acceso a Usuarios/Sesiones). PROD sin cambios.
- **`src/__tests__/authService.test.js`** — literal de login `'admin'` → `'administrador'` (mock; el `rol: 'admin'` de los tokens NO cambia).

### Database (`minegocio-database`)
- **`postgres/seed_dev.sql`** (NUEVO) — seed DEV idempotente: renombra `admin`→`administrador`, inserta `administrador/1234` (rol admin) y `usuario/1234` (rol usuario). Contraseñas en texto plano (DEV; login aún sin bcrypt). NO para producción.
- **`README.md`** — documenta `seed_dev.sql` y la tabla de credenciales DEV.
- **`postgres/setup_produccion.sql`** — **NO** se tocó (decisión: prod usa las cuentas del README).

### Backend (`minegocio-backend`)
- **`README.md`** — sección "Credenciales de prueba": se reemplazó la credencial suelta `Victor@user.cl / Victor264` por `administrador/1234` y `usuario/1234`, con nota de que el login es texto plano (pendiente bcrypt).

## Pendientes de ejecución (cuando se confirme)
1. Aplicar el seed en DEV: `psql -U postgres -d cliente_dev -f postgres/seed_dev.sql`.
2. Verificación manual en `:8082`:
   - Login `administrador/1234`: ve "Usuarios"; `/admin/usuarios` accesible.
   - Login `usuario/1234`: NO ve "Usuarios" ni "Sesiones"; escribir `/admin/usuarios` redirige a `/`.
   - Galería "Productos Registrados": cada tarjeta muestra su código de barras.
   - Icono "Productos" del SideBar en rojo al estar en Agregar Producto / Ver Catálogo.
3. Commits incrementales por repo (prefijos `S3-HU02-T12:` / `S3-HU02-T08:` / `S3-HU02:`) y push a gitea/origin.

## Deuda técnica detectada (fuera de alcance)
- Backend: login compara contraseña en **texto plano** (`repository/usuario_repository.go:~23`, TODO presente). Falta migrar a bcrypt.
- Backend: los endpoints admin no validan rol del lado servidor (la protección por rol quedó solo en el router del frontend).

## Pendiente previo aparte
- En `S3-HU02` (frontend) quedan commits locales de los iconos Tabler / logo / SideBar (pastilla del Kanban, icono activo en rojo) **sin pushear**, a la espera de tu OK.
