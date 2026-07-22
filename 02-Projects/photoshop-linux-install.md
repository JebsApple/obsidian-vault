# Photoshop 2026 en CachyOS — Plan de Instalación

**Fecha:** 2026-07-17
**Estado:** Pendiente
**Stack:** CachyOS (Arch), Intel i3-N300, 7.5GB RAM, Wine (patched 11.10)

---

## Resumen

Instalar Adobe Photoshop CC 2026 en CachyOS usando Wine parcheado por PhialsBasement, que corrige bugs específicos de Adobe (MSXML3/MSHTML).

## Requisitos

- [x] Wine 11.13 instalado (sistema)
- [x] winetricks presente
- [ ] Photoshop 2026 instalador (descargar de Google Drive → ~/Downloads/)
- [ ] Wine parcheado 11.10 de PhialsBasement (~208MB)

## Plan paso a paso

### Fase 1 — Preparar Wine parcheado

```bash
# 1. Descargar Wine parcheado de PhialsBasement
wget https://github.com/PhialsBasement/wine-adobe-installers/releases/download/v1.1/wine-11.10-adobe-linux-x86_64.tar.xz

# 2. Extraer a ~/wine-adobe/
mkdir -p ~/wine-adobe
tar -xf wine-11.10-adobe-linux-x86_64.tar.xz -C ~/wine-adobe/ --strip-components=1

# 3. Crear prefix
WINEPREFIX=~/.wine-adobe ~/wine-adobe/bin/wineboot --init
```

### Fase 2 — Instalar dependencias

```bash
WINEPREFIX=~/.wine-adobe WINE=~/wine-adobe/bin/wine winetricks -q \
  atmlib gdiplus msxml3 msxml6 vcrun2017 vkd3d corefonts
```

### Fase 3 — Instalar Photoshop

```bash
# Montar o extraer el instalador de Photoshop
cd ~/Downloads/
# (extraer/instalar según formato del instalador)

# Ejecutar instalador
WINEPREFIX=~/.wine-adobe WINE=~/wine-adobe/bin/wine \
  ~/Downloads/Photoshop_Set-Up.exe
```

### Fase 4 — Post-instalación

- Desactivar "Usar procesador gráfico" en Preferencias de PS (si carga)
- Skipped: Creative Cloud launcher (puede fallar, PS funciona sin él)
- Si falla: probar con `WINEDEBUG=-all` para logs limpios

## Fuentes

- [PhialsBasement/wine-adobe-installers](https://github.com/PhialsBasement/wine-adobe-installers)
- [Phoronix: Wine 11.10 Adobe fixes (Ene 2026)](https://www.phoronix.com/news/Wine-11.10-Adobe-Linux)

## Notas

- PS 2026 es **experimental** en Linux. PS CC 2021 es la versión más estable.
- GPU acceleration puede no funcionar.
- Si Creative Cloud pide login, puede bloquear — probar modo offline.
