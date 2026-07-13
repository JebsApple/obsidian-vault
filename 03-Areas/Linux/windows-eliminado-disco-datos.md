---
created: 2026-07-13
tags:
  - area/linux
  - sistema/cachyos
  - tipo/registro
aliases:
  - Windows Eliminado — Disco Datos
---

# Windows eliminado — p3 reconvertida a disco de datos (2026-07-13)

Plan final elegido: **no** unificar (unify-disk.sh descartado), sino reformatear la partición de Windows como disco secundario ext4. Se hizo en vivo, sin USB.

## Qué se hizo

1. Rescate completo: `Users/Victor` (79G) + extras raíz C: (`proyectos`, `flutter`, `Python314`, `XboxGames`, `WsiAccount`, `postgres`, `Public` — 6.5G). Verificado con rsync dry-run: 0 faltantes.
2. `mkfs.ext4 -L Datos /dev/nvme0n1p3` → UUID `728060ef-43c7-4ef9-a4db-0b443b35fd71`.
3. fstab: línea `/mnt/windows` reemplazada por montaje en `/home/apuru/Datos` (`defaults,noatime,nofail`).
4. Entrada EFI "Windows Boot Manager" (Boot0001) borrada con efibootmgr.
5. Archivos organizados en `~/Datos`: `Proyectos/` (MiNegocio, GitHub, Clases), `Documentos/`, `Imagenes/`, `Videos/`, `Descargas/` (34G instaladores), `Juegos/XboxGames`, `SDKs/` (flutter, go, Python314), `_Revisar/` (64G: AppData caché, dotfolders, OneDrive-resto — regla: mover, no borrar).

## Estado final

- Raíz p7: 157G usados / 154G libres (51%)
- Datos p3: 109G usados / 438G libres (20%)
- p1/p2/p4 (~1.1 GB restos Windows) sin uso, inofensivas. Si algún día se quiere recuperar ese espacio, requiere mover particiones (ver historial sesión).

## Limpieza y migración posterior (mismo día)

- `_Revisar/AppData-cache` (31G), `dotfolders` (8.6G) y duplicados de `Victor-resto` (23G, verificados con rsync dry-run) borrados. `_Revisar` quedó en 1.2G.
- **ObsidianVault de Windows** rescatado a `Datos/Documentos/ObsidianVault-Windows`.
- Movido de raíz a Datos: `.config.bak` (26G) → `Datos/Backups/config.bak-migracion-caelestia`; `~/.ollama` (10G) y `~/.local/share/Steam` (16G) → `Datos/AppData/` con symlinks en su lugar original (mismo NVMe, sin pérdida de rendimiento).
- Cachés raíz: npm 5.7G→1.1G, yay/uv borrados.
- Resultado: raíz 101G usados / 209G libres (33%); Datos 97G usados / 450G libres (18%).

## Notas

- Juegos Steam bajo `Program Files (x86)` NO se rescataron (reinstalables).
- `_Revisar/AppData-cache` (31G) borrada 2026-07-13 con aprobación del usuario — era caché reinstalable.
- Lección: `mv` entre filesystems falla en merges y con archivos read-only (caché Go 0444) — usar `rsync -a --remove-source-files` y luego `chmod -R u+w` antes de borrar restos.
