---
tags: [proyecto/minegocio, sprint-3, taiga, tests, HU02-T04]
updated: 2026-06-27
tarea_taiga: S3-HU02-T04 — Testing frontend con Vitest
assignee: victor
---

# Registro de Tests — S3-HU02-T04 (para Taiga)

> Copiar/pegar en la tarea **S3-HU02-T04** de Taiga. Stack: Vitest + @vue/test-utils + happy-dom.
> Estado: **53/53 ✅, 0 errores**. Ejecutar: `npx vitest run`.

## Resumen para Taiga (pegar en descripción/comentario)

```
Cobertura de tests frontend ampliada de 23 a 53 tests (10 suites, 0 errores).
Nuevas suites: authService, productosService, ventasService, inventarioService, KanbanBoard.
Cubre: capa de servicios (todas las llamadas API + manejo de errores), autenticación
JWT (login/logout/decodificación de token) y el tablero Kanban (clasificación por
stock + drag&drop). Ejecutar con `npx vitest run`.
```

## Detalle por suite (53 tests)

### authService.test.js (8) — NUEVO
- login: guarda token y refresh_token en localStorage al autenticar
- login: lanza "Credenciales inválidas" cuando la respuesta no es ok
- logout: elimina token y refresh_token de localStorage
- getToken: retorna el token almacenado
- getUserFromToken: retorna null cuando no hay token
- getUserFromToken: retorna null cuando el token está expirado
- getUserFromToken: decodifica id, nombre y rol de un token válido
- getUserFromToken: usa rol "vendedor" por defecto cuando el token no trae rol

### productosService.test.js (8) — NUEVO
- getProductos retorna la lista cuando la respuesta es ok
- getProductos envía el header Authorization con el token
- getProductos lanza error cuando la respuesta no es ok
- createProducto hace POST a /api/productos y retorna el creado
- createProducto propaga el mensaje de error del backend
- updateProducto hace PUT a /api/productos/{id}
- deleteProducto hace DELETE a /api/productos/{id}
- buscarProductos arma el query string con los filtros activos

### ventasService.test.js (4) — NUEVO
- getVentas retorna el historial cuando la respuesta es ok
- getVentas lanza error cuando la respuesta no es ok
- registrarVenta hace POST a /api/ventas con el payload
- registrarVenta propaga el mensaje de error del backend

### inventarioService.test.js (5) — NUEVO
- getAll retorna el inventario cuando la respuesta es ok
- updateStock hace PATCH a /api/inventario/{id} con el nuevo stock
- updateStock lanza error cuando la respuesta no es ok
- buscarProductos normaliza la forma { productos: [...] }
- buscarProductos acepta también una respuesta que ya es array

### KanbanBoard.test.js (5) — NUEVO
- renderiza las 4 columnas de estado
- clasifica por estado de stock (0=agotado, <=4=bajo, resto=normal)
- toggleExpand alterna la columna expandida
- emite product-moved al soltar una card en otra columna
- no emite product-moved si se suelta en la misma columna de origen

### Login.test.js (3) — existente (renombrado de LoginPage)
- renderiza el formulario de login
- guarda solo token y refresh_token en localStorage (sin usuario ni esAdmin)
- muestra error cuando las credenciales son inválidas

### Analisis.test.js (4) — existente (renombrado de AnalisePage; fix \$modal+ok)
- muestra landing cuando no hay sesión
- muestra dashboard cuando hay token
- la landing tiene el botón de ingresar
- el botón de export está deshabilitado en el dashboard

### SideBar.test.js (5) — existente
- renderiza sin errores con props por defecto
- NO muestra enlace Admin Usuarios cuando rol es vendedor
- SÍ muestra enlace Admin Usuarios cuando rol es admin
- (+2 de visibilidad de enlaces por rol)

### authGuard.test.js (7) — existente
- isTokenExpired: null / inválido / expirado / válido
- requiresAuth en /admin/usuarios; /login y / sin requiresAuth

### AdminUsuariosPage.test.js (4) — existente (Nicolás/HU04, no tocado)

## Nota técnica
- JWT de prueba: `header.${btoa(JSON.stringify(payload))}.firma` (jwt-decode solo lee payload).
- fetch mockeado con `vi.stubGlobal('fetch', ...)`; respuestas con `{ ok, json }`.
- Pendiente menor (no bloqueante): SideBar.test.js emite warnings de Vue Router por rutas no registradas en su router mock — son warnings, no fallos.
