---
tags: [tasks, handoff, backend, auth]
updated: 2026-06-19
assignee: ai-reader
---

# Tareas pendientes para agente lector

## Contexto
Proyecto MiNegocio. Backend Go en http://192.168.50.28:3000 (Gitea).
Ver [[MiNegocio]] para contexto completo.

---

## ✅ COMPLETADO — Sesión 2026-06-19

### Bugs reparados
- Ventas: payload corregido a `{items: [{producto_id, cantidad, precio_venta}], id_vendedor}` + productos cargados desde API real
- HomePage: auto-redirect a `/login` o `/servicios` según auth
- Nav: centrado con flex, condicional según sesión

### Páginas agregadas
- InventarioPage.vue (GET /api/inventario)
- RegistroVentasPage.vue (GET /api/ventas)
- ServiciosPage.vue (dashboard con enlaces a todo)

### Git
- Frontend: commit `0c7e5f3` push a main
- Backend: commit `efaf857` (gitignore + rm main binario) push a main

### Obsidian
- Actualizado [[MiNegocio]] con estado completo del proyecto
- Creada guía [[MiNegocio - Deploy Prod]] con instrucciones Jenkins paso a paso

## ✅ COMPLETADO — Auditoría Pre-Presentación 2026-06-19

- Smoke test PROD completo: 11/11 endpoints OK → [[SmokeTest-PROD-2026-06-19]]
- Commit y push fix token reactivity + endpoint `/api/auth/login` en frontend
- Build de producción actualizado (`app.a97460aa.js`) en `/var/www/prod/frontend`
- Password hash en DB corregido (revertido a texto plano, compatible con backend actual)
- Credenciales confirmadas: `Victor@user.cl` / `Victor264`
- Reporte de auditoría creado → [[Auditoria-Presentacion-2026-06-20]]

## Pendiente para próxima sesión
- Revisar ERS de Google Drive para planificar próximos sprints
- Arreglar Dockerfile del backend para cross-compilation (GOARCH explícito) así Jenkins puede desplegar sin problemas
- Configurar pipeline Jenkins también para frontend
- Mergear/cerrar PR#10 y PR#11 en frontend
- Reparar nginx DEV: cambiar proxy de localhost:3000 → localhost:3001
- Migrar passwords en DB a bcrypt real (ahora están en texto plano)
- Resolver conflicto git en `Knowledge/lecciones.md`
