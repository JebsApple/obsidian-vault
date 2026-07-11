---
created: 2026-07-11
tags:
  - tipo/zettel
  - proyecto/minegocio
  - tech/devops
aliases:
  - DEV PROD
  - nginx reverse proxy
---

# Separación DEV/PROD con nginx reverse proxy

## Lo que aprendí
DEV y PROD deben ser instancias completamente separadas: diferentes puertos de nginx (8080 vs 80), diferentes directorios frontend (`/var/www/dev/` vs `/var/www/prod/`), diferentes contenedores backend (`backend` vs `backend-prod`), diferentes DBs (`cliente_dev` vs `cliente_prod`), y JWT_SECRET diferente entre entornos. PROD necesitó crear tablas manualmente (solo tenía `usuarios`).

## Contexto
Sesión 4 de MiNegocio (2026-06-18). Se configuró la separación completa de entornos en el servidor 192.168.50.25.

## Aplicación
Al configurar entornos DEV/PROD: todo separado (DB, secrets, puertos, contenedores). Nunca compartir JWT_SECRET entre entornos. Verificar que la DB de PROD tenga todas las tablas.

## Conexiones
- [[docker-build-go-compilar-dentro]]
- [[nginx-symlink-sites-enabled]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
