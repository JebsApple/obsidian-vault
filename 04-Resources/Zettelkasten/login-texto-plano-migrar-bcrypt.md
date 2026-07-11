---
created: 2026-07-11
tags:
  - tipo/zettel
  - proyecto/minegocio
  - tech/vue
aliases:
  - login bug
  - token texto plano
---

# Login con texto plano contra password_hash: migrar a bcrypt

## Lo que aprendí
Si el login compara texto plano contra `password_hash` en la BD, siempre falla (o peor, funciona sin seguridad). Migrar a `bcrypt.CompareHashAndPassword` de `golang.org/x/crypto`. Requiere regenerar todos los hashes en la BD.

## Contexto
2026-06-18 en MiNegocio. Se descubrió que el login usaba texto plano.

## Aplicación
Nunca implementar login sin hashing de passwords. Usar bcrypt (o argon2id) desde el inicio. Regenerar hashes al migrar.

## Conexiones
- [[bcrypt-hash-en-seed]]
- [[vue-localstorage-no-es-reactivo]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
