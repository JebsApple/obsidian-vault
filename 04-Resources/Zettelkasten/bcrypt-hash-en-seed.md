---
created: 2026-07-11
tags:
  - tipo/zettel
  - proyecto/minegocio
  - tech/go
aliases:
  - bcrypt seed
  - password hash
---

# bcrypt en seed: generar hash real, no placeholder

## Lo que aprendí
El seed SQL no debe tener texto literal como `password_hash = 'CAMBIAR_POR_HASH_REAL'` porque `bcrypt.CompareHashAndPassword` siempre falla. Generar el hash real con Go: `bcrypt.GenerateFromPassword([]byte("admin123", bcrypt.DefaultCost))` y usarlo en el seed.

## Contexto
2026-06-18 y 2026-07-09 en MiNegocio. Primero al migrar a bcrypt, luego al encontrar que el seed tenía el placeholder.

## Aplicación
Siempre generar hashes reales en los seeds de BD. Nunca usar placeholders en producción. Crear scripts de fix (`fix_admin_password.sql`) para DBs existentes.

## Conexiones
- [[go-register-endpoint-cadena]]
- [[tabla-schema-mismatch]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
