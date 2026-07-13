---
created: 2026-07-12
tags:
  - proyecto/servicio-pc
  - tipo/playbook
aliases:
  - Servicio Limpieza PC Vecinal
---

# Servicio: Limpieza y Optimización de Computadoras (vecinal)

Playbook ejecutable por opencode (leyendo este plan desde GitHub o pendrive) en la máquina del cliente. Perspectiva: técnico metódico — diagnóstico antes de acción, backup antes de tocar, reporte al final.

## Oferta

1. **Limpieza + optimización** (Windows, mayoría de casos): más rápido, más espacio, menos errores, revisión de virus.
2. **Instalación Linux amigable** (opcional, casos específicos): PC viejo que Windows ya no mueve, o usuario que solo navega/ofimática. No empujarlo — ofrecerlo solo cuando encaje (ver criterios abajo).

## Kit pendrive

```
pendrive/
├── plan-servicio.md          ← este archivo
├── scripts/audit-win.ps1     ← auditoría automatizada (crear)
├── opencode-portable/        ← binario opencode + config con API key limitada
└── herramientas/             ← instaladores offline: BleachBit, Autoruns (Sysinternals)
```

**Realidad opencode en PC ajeno:** necesita internet + API key. Usar key con límite de gasto bajo y rotarla después de cada jornada. Si no hay internet decente: correr `audit-win.ps1` solo y seguir este plan como checklist manual.

## Reglas fijas (para el agente y para mí)

1. **Consentimiento explícito** del dueño antes de tocar archivos personales.
2. **Backup primero** de carpetas de usuario si hay disco externo disponible. Nunca borrar sin respaldo o confirmación.
3. **Nunca manejar contraseñas del cliente** — que él las escriba.
4. **No prometer** recuperación de datos ni "queda como nuevo".
5. Todo cambio destructivo (desinstalar, borrar) → lista previa y aprobación del dueño.
6. Reporte final por escrito (qué se hizo, qué se encontró, recomendaciones).

## Fase 0 — Entrevista (5 min, define todo lo demás)

- ¿Para qué usan el PC? (estudio / trabajo / juegos / solo navegar)
- ¿Qué molesta? (lento al arrancar / lento siempre / se llena disco / popups)
- ¿Archivos importantes dónde? ¿Tienen respaldo?
- ¿Cuántos usuarios usan la máquina?

## Fase 1 — Auditoría (solo lectura)

| Check | Comando Windows |
|-------|-----------------|
| Salud disco | `Get-PhysicalDisk`, SMART con CrystalDiskInfo si hay dudas |
| Espacio | `Get-PSDrive C`, TreeSize/WinDirStat para ver qué pesa |
| Inicio lento | Administrador de tareas → pestaña Inicio; `Get-CimInstance Win32_StartupCommand` |
| Integridad sistema | `sfc /scannow`, luego `DISM /Online /Cleanup-Image /RestoreHealth` si falla |
| Malware | Windows Defender examen completo + `mrt.exe` (herramienta de eliminación de Microsoft). AdwCleaner para adware/toolbars |
| Updates | Windows Update pendientes; versión de Windows aún soportada o no |
| Eventos | `Get-WinEvent -LogName System -MaxEvents 50` filtrando errores repetidos |
| RAM/HW | `Get-ComputerInfo` — si tiene 4 GB y HDD, ninguna limpieza lo salva: recomendar SSD/RAM o Linux |

## Fase 2 — Limpieza (con aprobación)

1. Temporales: Liberador de espacio / Storage Sense / BleachBit (conservador, sin registro).
2. Bloatware: listar programas instalados, marcar candidatos, desinstalar solo aprobados.
3. Inicio: deshabilitar arranque automático de todo lo no esencial (dejar antivirus).
4. Navegador: extensiones sospechosas, motor de búsqueda secuestrado, caché.
5. Adware/PUPs: AdwCleaner + resultados de Defender/MRT.

## Fase 3 — Organización de archivos (delicada, siempre con el dueño al lado)

- Escritorio saturado → carpetas por tipo (Documentos, Fotos, Trabajo, Viejo).
- Descargas: mover lo útil, proponer borrar instaladores viejos (.exe ya instalados).
- Duplicados evidentes solo con confirmación visual del dueño.
- **Regla: mover, no borrar.** Carpeta `_Revisar` para lo dudoso.

## Fase 4 — Optimización

- Efectos visuales a rendimiento en PCs lentos.
- Plan de energía equilibrado/alto rendimiento en escritorio.
- Verificar TRIM activo en SSD (`fsutil behavior query DisableDeleteNotify`).
- HDD: desfragmentar (nunca SSD).

## Fase 5 — Verificación y reporte

- Reiniciar y cronometrar arranque (antes/después si se midió al inicio).
- Reporte simple: qué se encontró, qué se hizo, qué se recomienda (ej: "el disco tiene sectores dañados, respaldar ya").

## Oferta Linux — criterios honestos

Recomendar SOLO si: (a) hardware viejo con Windows insoportable y sin presupuesto para SSD/RAM, (b) uso = navegador + documentos + video, (c) usuario dispuesto. Windows es el estándar del vecindario — no evangelizar.

- Distro: **Linux Mint Cinnamon** (o Zorin OS) — familiar para usuario Windows, LibreOffice, updates simples.
- Siempre con backup completo previo y demo en vivo (USB live) antes de instalar.
- Dual boot solo si el dueño lo entiende; si no, confunde más de lo que ayuda.
- Dejar anotado en papel: cómo actualizar, cómo apagar, dónde están sus cosas.

## Precios (definir)

- Limpieza básica: __ | Limpieza + organización archivos: __ | Instalación Linux con respaldo: __
- Diagnóstico de hardware sin arreglo: __ (o gratis como gancho)

## Pendientes

- [ ] Crear `scripts/audit-win.ps1` (versión Windows del `audit-sistema` de mi equipo)
- [ ] Armar pendrive con herramientas offline
- [ ] API key con límite de gasto para opencode en terreno
- [ ] Publicar vault (o solo esta carpeta) en repo GitHub para lectura remota
