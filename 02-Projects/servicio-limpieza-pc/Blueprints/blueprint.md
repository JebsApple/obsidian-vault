---
tags: [blueprint, planning, proyecto/servicio-pc]
created: 2026-07-14
---

# Blueprint: Servicio Limpieza PC

## Contexto

El playbook operativo ya existe ([[plan-servicio]]) — define fases de trabajo en la máquina del cliente (entrevista → auditoría → limpieza → organización → optimización → reporte). Este blueprint cubre lo que falta para poder ofrecer el servicio: tooling, kit físico y logística.

## Fases

### Fase 1: Script de auditoría Windows
- **Objetivo:** `audit-win.ps1` — versión Windows del `audit-sistema` local. Solo lectura, imprime reporte.
- **Archivos a crear/modificar:**
  - `scripts/audit-win.ps1` — checks de Fase 1 del playbook: disco (SMART/espacio), inicio, sfc/DISM sugeridos, Defender, updates, eventos, RAM/HW
- **Verificación:** correr en una VM Windows o PC propia; reporte legible sin errores, cero cambios al sistema.

### Fase 2: Kit pendrive
- **Objetivo:** pendrive autosuficiente según estructura del playbook.
- **Contenido:**
  - `plan-servicio.md` (copia del playbook)
  - `scripts/audit-win.ps1`
  - `opencode-portable/` — binario + config
  - `herramientas/` — instaladores offline: BleachBit, Autoruns, AdwCleaner, CrystalDiskInfo, TreeSize Free
- **Verificación:** boot en PC ajena sin internet → checklist manual funciona con solo el pendrive.

### Fase 3: Acceso remoto seguro
- **Objetivo:** opencode funcional en terreno sin exponer credenciales.
- **Tareas:**
  - API key con límite de gasto bajo + rotación post-jornada
  - Publicar playbook (solo esta carpeta) en repo GitHub para lectura remota
- **Verificación:** opencode en máquina limpia lee el plan desde GitHub y ejecuta auditoría.

### Fase 4: Piloto
- **Objetivo:** primer cliente real (vecino), definir precios con datos.
- **Verificación:** reporte final entregado, tiempos medidos por fase, precios rellenados en el playbook.

## Dependencias entre Fases

```
Fase 1 → Fase 2 → Fase 4
         Fase 3 ↗
```

## Rollback Strategy

Nada toca el sistema propio; en máquinas de clientes aplican las reglas fijas del playbook (backup primero, aprobación previa, mover no borrar).
