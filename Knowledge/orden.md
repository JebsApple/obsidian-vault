---
tags: [limpieza, servidor, inventario, git]
---

# Orden - Limpieza del Servidor (2026-06-18)

## Problema
El servidor tenía repos duplicados, archivos sin commitear de un compañero, binarios compilados en el repo, node_modules/ en backend Go, y URLs de remote con token embebido.

## Acción tomada

### Repos eliminados (duplicados)
- `MiNegocio-backend/` → trabajo migrado a `minegocio-backend`
- `MiNegocio-frontend-work/` → redundante (branch ya está en remote)
- `MiNegocio-database/` → redundante

### Backend (`minegocio-backend`)
- Re-clonado fresh desde Gitea (commit `0a04bb2`, último main)
- `.gitignore` agregado (binarios Go, node_modules, .claude/)
- Rama `feat/inventario-endpoints` creada con el trabajo sin commitear del compañero:
  - `handler/inventario_handler.go`
  - `repository/inventario_repository.go`
  - `service/inventario_service.go`
- Commit mensaje claro: "feat(inventario): agregar endpoints CRUD de inventario (vista + stock)" + nota sobre trabajo de compañero

### Base de datos (`minegocio-database`)
- Reclonado desde Gitea, rama `240Optimizacion&softdelete`

### Frontend (`minegocio-frontend`)
- Sin cambios (ramas de trabajo `S2-HU04-*`)
- Remote URL tenía token embebido — no se pudo limpiar (permisos)

### Pendiente
- Push de rama `feat/inventario-endpoints` a Gitea (desde otro dispositivo)
- Eliminar `minegocio-backend-old/` (dueño deployequipo6, requiere sudo)
- CRUD inventario plano (inventario.go) quedó obsoleto — reemplazado por versión estructurada en handler/repository/service
- Integrar rutas de inventario en routes/routes.go y main.go

## Próximos pasos
1. Subir cambios desde otro dispositivo a las ramas
2. Hacer merge a main via PR cuando esté listo
3. No pushear directo a main
