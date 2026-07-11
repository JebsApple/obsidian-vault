---
created: 2026-07-11
tags:
  - tipo/zettel
  - proyecto/minegocio
  - tech/go
aliases:
  - register endpoint
  - usuario registration
---

# User registration: cadena completa handler → service → repository

## Lo que aprendí
Para crear un endpoint de registro: crear `RegisterRequest` (request body), `Register` en `AuthServiceI` (interfaz), `AuthService.Register` (bcrypt hash → Create → JWT), `AuthHandler.Register` con validación, y registrar la ruta. Validar duplicados con `GetByNombre()` antes de crear.

## Contexto
Sesión 4 de MiNegocio (2026-06-18). Se creó `/api/register` y `/api/auth/register` (POST). El tipo `RegisterRequest` ya existía en models pero no se usaba.

## Aplicación
Siempre seguir la cadena de capas: handler (HTTP) → service (lógica) → repository (BD). Reusar tipos existentes en models antes de crear nuevos.

## Conexiones
- [[bcrypt-hash-en-seed]]
- [[jwt-auth-guard-router]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
