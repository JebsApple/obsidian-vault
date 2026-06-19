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

## Pendiente para próxima sesión
- Revisar ERS de Google Drive para planificar próximos sprints
- Arreglar Dockerfile del backend para cross-compilation (GOARCH explícito) así Jenkins puede desplegar sin problemas
- Configurar pipeline Jenkins también para frontend
- Mergear ramas feature a develop/main si existen
