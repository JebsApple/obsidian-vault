---
tags:
  - minecraft
  - docker
  - gaming
  - Referencia
created: 2026-07-12
---

# Minecraft Server con Docker + PaperMC

## PaperMC > Spigot > Vanilla

PaperMC es un fork de Spigot con mejor rendimiento y parches de seguridad.

## Docker Setup

```bash
docker run -d \
  --name minecraft \
  -p 25565:25565 \
  -v /opt/minecraft/data:/data \
  -e EULA=TRUE \
  -e TYPE=PAPER \
  -e MEMORY=4G \
  itzg/minecraft-server
```

## RAM por tipo

| Tipo | Jugadores | RAM |
|------|-----------|-----|
| Vanilla | 1-10 | 2-4GB |
| Modded | 1-10 | 6-8GB |
| Premium | 50+ | 8-12GB |
| Mega server | 100+ | 12-16GB+ |

## JVM Flags (Aikar's Flags)

```bash
# Para 8-12GB RAM
JAVA_FLAGS="-Xms8G -Xmx8G \
  -XX:+UseG1GC \
  -XX:+ParallelRefProcEnabled \
  -XX:MaxGCPauseMillis=200 \
  -XX:+UnlockExperimentalVMOptions \
  -XX:G1NewSizePercent=30 \
  -XX:G1MaxNewSizePercent=40 \
  -XX:G1HeapRegionSize=8M \
  -XX:G1ReservePercent=20 \
  -XX:G1HeapWastePercent=5 \
  -XX:G1MixedGCCountTarget=4 \
  -XX:InitiatingHeapOccupancyPercent=15 \
  -XX:G1MixedGCLiveThresholdPercent=90 \
  -XX:G1RSetUpdatingPauseTimePercent=5 \
  -XX:SurvivorRatio=32 \
  -XX:+PerfDisableSharedMem \
  -XX:MaxTenuringThreshold=1"
```

## server.properties clave

```properties
view-distance=6          # Menor = mejor rendimiento
simulation-distance=4    # Menor que view-distance
max-players=20
difficulty=normal
spawn-protection=16
entity-broadcast-range-percentage=75
```

## Optimización

- Pre-generar world: `forgegen` o `/forceload`
- Limitar entidades con Paper config
- TPS target: 20 (50ms/tick)
- SSD/NVMe esencial para world I/O

## Backups automáticos

```bash
# En crontab o timer
docker exec minecraft rcon-cli say "Worldsaved — backing up..."
docker exec minecraft rcon-cli save-off
docker exec minecraft rcon-cli save-all
cp -r /opt/minecraft/data/worlds /backup/minecraft/$(date +%Y%m%d)
docker exec minecraft rcon-cli save-on
# Rolling: borrar backups > 7 días
find /backup/minecraft -mtime +7 -exec rm -rf {} \;
```

## Hardware

- Single-core clock speed importa más que cores
- 3.5+ GHz recomendado
- 16GB+ RAM total
- SSD/NVMe dedicado para world data
