---
tags: [tasks, handoff, backend, auth]
updated: 2026-06-18
assignee: ai-reader
---

# Tareas pendientes para agente lector

## Contexto
Proyecto MiNegocio. Backend Go en http://192.168.50.28:3000 (Gitea).
Ver [[MiNegocio]] para contexto completo.

---

## ✅ COMPLETADO — Sesión 2026-06-18

### Auth store reactivo (`src/store/auth.js`)
- Creado store con `reactive()` de Vue 3 sincronizado con localStorage
- `setAuth(token, user)` y `clearAuth()` actualizan store + localStorage
- App.vue, NavBar, AnalisePage, LoginPage ahora usan `auth.isAuthenticated` (reactivo real)

### Router guard (`router.beforeEach`)
- Agregado `beforeEach` con `meta: { requiresAuth: true }` en rutas protegidas
- `/` redirige a `/analisis` (elimina duplicado con `/analisis`)
- Sin guard: `/login`, `/registro`, `/contacto`

### NavBar sin redundancia
- Eliminados los 3 links centrales (Inventario, Análisis, Productos) — duplicados con SideBar
- Solo logo + menú usuario (login/logout/registro)

### Login CSS mejorado
- Contenedor 440px centrado
- Formulario con sombra, inputs grandes, botón full-width

### User Registration (backend)
- `POST /api/registro` — endpoint público
- Validación: nombre y password requeridos, duplicados detectados
- Rol por defecto: `vendedor`, activo=true
- Retorna JWT (auto-login tras registro)

### User Registration (frontend)
- `src/views/RegistroPage.vue` — formulario de registro
- Ruta `/registro` en router
- Link "Regístrate aquí" en LoginPage
- Link "Registrarse" en NavBar (cuando no logueado)

### Auth en ventasService.js
- Agregados headers `Authorization: Bearer` a todas las llamadas del servicio de ventas

### Entornos DEV/PROD separados
- **DEV:** nginx 8080 → frontend `/var/www/dev/frontend/` → API proxy localhost:3000 → `cliente_dev`
- **PROD:** nginx 80 → frontend `/var/www/prod/frontend/` → API proxy localhost:3001 → `cliente_prod`
- Backend PROD: contenedor `backend-prod` con `DB_NAME=cliente_prod`
- PROD DB tiene tablas: usuarios, productos, registro_ventas, registro_sesiones

### Branches en Gitea
- `feat/registro-usuarios` creada y push en backend + frontend
- Backend: commit `f2ce5d3`
- Frontend: commit `f4706b3`

### nginx PROD
- Agregado `location /uploads/ { proxy_pass http://localhost:3001; }` en ambos configs
- PROD nginx ahora proxy a 3001 (backend-prod)

## Pendiente para próxima sesión
- Configurar deploy PROD via Jenkins (Jenkinsfile ya existe)
- Revisar ERS de Google Drive para planificar próximos sprints
- Mergear `feat/registro-usuarios` a `main` cuando esté aprobado
