---
created: 2026-07-11
tags:
  - tipo/zettel
  - proyecto/minegocio
  - tech/git
aliases:
  - Gitea SSH
  - Gitea HTTP
---

# Gitea: SSH funciona sin contraseña, HTTP requiere token

## Lo que aprendí
El remote SSH `git@gitea:user/repo.git` funciona sin contraseña (con clave SSH configurada). El remote HTTP `http://192.168.50.28:3000/user/repo.git` requiere token en la URL (`http://TOKEN@host/repo.git`) o autenticación interactiva. `git push gitea branch` funciona con SSH; con HTTP (origin) requiere token.

## Contexto
Sesión 4 de MiNegocio (2026-06-18). Se intentaba pushear a Gitea y había confusión entre los dos métodos de autenticación.

## Aplicación
Configurar SSH como método primario para Gitea. Guardar el token HTTP como fallback. Nunca hardcodear tokens en scripts committed.

## Conexiones
- [[git-ramas-en-espanol]]
- [[gitea-api-push-ssh]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
