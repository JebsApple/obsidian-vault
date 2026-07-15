# PhoeNix Games Lab — Guia de descarga Linux

## Que es

PhoeNix Games Lab es una coleccion de juegos nativos Linux en Internet Archive.
Varios formats: GOG (DRM-free), Steam-Rip (Goldberg crack), LinuxRuleZ! repacks.

Coleccion: [native-linux-games-collection](https://archive.org/details/native-linux-games-collection)

## Descargar un juego

1. Ir a la pagina del juego en Archive.org
2. Scroll a **Download Options** → clic en **Show All**
3. Buscar el archivo:
   - **`.sh`** → instalador GOG (mejor para Heroic)
   - **`.tar.xz`** / **`.tar.gz`** → archivo con el juego adentro
   - **`.iso`** → imagen de disco
4. Click derecho en el archivo → **Copy Link**
5. Pegar en un gestor de descargas (AB DM, XDM) o en el navegador

## Preparar el juego

Script: `~/bin/prepare-game`

```bash
# Con nombre explicito
prepare-game ~/Descargas/archivo.tar.xz NombreJuego

# Sin nombre (lo infiere del archivo)
prepare-game ~/Descargas/game-Celeste_\(v1.4.0.0\)_\[Linux\].tar.xz
```

**Que hace:**
1. Extrae el archivo (`.tar.xz`, `.tar.gz`, `.tar.bz2`, `.sh`)
2. Lo mueve a `~/Games/<nombre>`
3. Hace ejecutables los scripts y binarios
4. Muestra los archivos de lanzamiento

## Agregar a Heroic Launcher

1. Abrir Heroic
2. Ir a la pestana **Side-loaded** (sidebar)
3. Clic en **Add Game**
4. Seleccionar el ejecutable o `.sh` que mostro `prepare-game`
   - Tipico: `~/Games/<nombre>/start.sh`
5. Listo, el juego aparece en la biblioteca

## Notas

- Los GOG importan directo via Heroic Import Game
- Los Steam-Rips NO funcionan con Heroic (usan Goldberg crack)
- Celeste ya esta instalado en `~/Games/Celeste`
- Script `prepare-game` esta en `~/bin/` (agregado al PATH en `.zshrc`)

## Fuentes

- Tutorial original: [How to use PhoeNix Games Lab](https://archive.org/details/howto-using-phoenix-games-lab-collection)
- Heroic Launcher: [heroicgameslauncher.com](https://heroicgameslauncher.com)
- Guia Heroic en Linux: [Retro Crisis - Heroic Launcher Guide](https://www.youtube.com/watch?v=9fUvCSivwY)
