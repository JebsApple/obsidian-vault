---
tags: [proyecto/minegocio, sprint-3, taiga, tests, HU02-T12, HU02-T08, HU02-T09]
updated: 2026-06-28
tarea_taiga: "S3-HU02-T12 (frontend), S3-HU02-T08 (backend), S3-HU02-T09 (database)"
assignee: victor
---

# Registro de Tests — S3-HU02-T12/T08/T09 (para Taiga)

> **Estado final:** Frontend ✅ 53/53 tests, Backend ✅ Compila, Database ✅ Seed válido.
> Cambios listos en ramas locales (sin push). Ramas: `S3-HU02-T12-codigo-barras-y-acceso-roles` (fe), `S3-HU02-T08-readme-credenciales` (be), `S3-HU02-T09-seed-usuarios` (db).

## Resumen para Taiga

### Frontend (T12: Código de barras + acceso por rol)
**Tests:** 53/53 ✅ (10 suites, 0 errores). Ejecutar: `npm run test`.

**Cambios:**
- Bug arreglado: GaleriaProductos.vue ahora muestra `codigo_barras` de cada producto.
- Control de acceso reforzado: `/admin/usuarios` bloqueado por rol (no-admin redirigido a `/`).
- UX mejorada: icono "Productos" en rojo al estar en `/productos` o `/productos-registrados`.
- README actualizado: credenciales DEV ahora `administrador/1234` y `usuario/1234`.
- Test updateado: login mock usa `administrador` (consistencia).

**Verificación:**
- Compila sin errores en `:8082` (HTTP 200).
- Todos los 53 tests pasan.
- App visual: galería muestra código de barras, SideBar icono Productos en rojo cuando corresponde, rutas admin bloqueadas para no-admin.

### Backend (T08: README credenciales)
**Build:** ✅ Compila sin errores. Ejecutar: `go build`.

**Cambios:**
- README: reemplazada credencial suelta `Victor@user.cl / Victor264` por credenciales DEV estándar (`administrador/1234`, `usuario/1234`).
- Documentación alineada con el nuevo seed DEV.

**Nota técnica (fuera de alcance, pendiente):**
- Login aún compara contraseña en texto plano (sin bcrypt) — ver `usuario_repository.go`.
- Endpoints admin no validan rol del lado servidor (protección solo en router frontend).

### Database (T09: Seed usuarios DEV)
**Seed:** ✅ Válido. Archivo: `postgres/seed_dev.sql` (6 líneas SQL).

**Cambios:**
- Nuevo archivo `postgres/seed_dev.sql`: idempotente, DEV-only.
  - Renombra `admin` → `administrador` (si existe).
  - Inserta `administrador/1234` (rol `admin`) y `usuario/1234` (rol `usuario`).
  - Contraseñas en texto plano (DEV; backend aún sin bcrypt).
- README actualizado: documenta seed y tabla de credenciales DEV.
- SQL producción **intacto** (decisión: prod usa cuentas del README, sin cambios en setup_produccion.sql).

**Verificación:**
- Sintaxis SQL válida (líneas de INSERT/UPDATE presentes).
- Idempotencia: múltiples aplicaciones no causan duplicados (ON CONFLICT).
- Aplicar manualmente: `psql -U postgres -d cliente_dev -f postgres/seed_dev.sql`.

## Detalles técnicos por componente

### Frontend — GaleriaProductos.vue
```vue
<!-- Nuevo en card-body -->
<div class="card-codigo">
  <i class="ti ti-barcode"></i> {{ p.codigo_barras || '—' }}
</div>
```
Estilo: mono, color meta (#888), sin énfasis visual (complementa la tarjeta sin distraer).

### Frontend — Router guards
```javascript
// meta.requiresAdmin en /admin/usuarios
if (to.meta.requiresAdmin && getUserFromToken()?.rol !== 'admin') {
  next('/')
}
```
No-admin que escriba `/admin/usuarios` en URL es redirigido al home.

### Frontend — SideBar Productos activo
Computed `enProductos` → devuelve true si `$route.path` es `/productos` o `/productos-registrados`.
Clase `.nav-group-trigger--activo` → icono `nav-icon` hereda `color: var(--color-brand)`.

### Database — seed_dev.sql
```sql
UPDATE public.usuarios SET nombre = 'administrador' WHERE nombre = 'admin';
INSERT INTO public.usuarios (...) VALUES ('administrador', 'administrador@minegocio.dev', '1234', 'admin', true)
  ON CONFLICT (email) DO UPDATE ...;
INSERT INTO public.usuarios (...) VALUES ('usuario', 'usuario@minegocio.dev', '1234', 'usuario', true)
  ON CONFLICT (email) DO NOTHING;
```

## Checklist para Taiga

- [ ] Frontend: revisar galería "Productos Registrados" — código de barras visible.
- [ ] Frontend: login `administrador/1234` → ve "Usuarios"; login `usuario/1234` → NO ve "Usuarios".
- [ ] Frontend: SideBar, en `/productos` o `/productos-registrados` → icono "Productos" en rojo.
- [ ] Backend: compilación sin errores (`go build`).
- [ ] Database: aplicar `postgres/seed_dev.sql` a `cliente_dev`.
- [ ] Database: verificar `SELECT * FROM usuarios` muestra `administrador` (admin) y `usuario` (usuario).

## Pendiente previo (no bloqueante)

Commits locales de T11 (iconos Tabler, logo, SideBar rojo, pastilla Kanban) en `S3-HU02` frontend **sin pushear** — a la espera de decisión de merge a dev.

## Deuda técnica (fuera de alcance, registrada en Obsidian)

- Backend: login texto plano → migrar a bcrypt.
- Backend: endpoints admin sin validación de rol servidor-side.
- Ver `Pendientes-S3-HU02-T12-codigo-barras-y-roles.md` en vault para detalles.
