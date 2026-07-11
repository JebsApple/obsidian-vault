---
created: 2026-07-11
tags:
  - tipo/zettel
  - proyecto/minegocio
  - tech/devops
aliases:
  - docker build Go
  - glibc musl
  - build inside container
---

# Docker build con Go: compilar dentro del contenedor

## Lo que aprendí
Copiar un binario compilado con `docker cp` a un contenedor Alpine falla por diferencias glibc vs musl. La solución correcta es compilar dentro del contenedor: `docker exec backend sh -c "cd /app && go build -o main ."`. También, el binario va a `/app/main` (según Dockerfile `CMD`), no a otro path.

## Contexto
Sesión 4 de MiNegocio (2026-06-18). Se intentaba actualizar el backend en el contenedor Docker de producción.

## Aplicación
Para proyectos Go + Docker Alpine: siempre compilar dentro del contenedor (`go build` dentro de `docker exec` o multi-stage build) para evitar incompatibilidades de libc.

## Conexiones
- [[dev-prod-separacion]]
- [[nginx-symlink-sites-enabled]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
