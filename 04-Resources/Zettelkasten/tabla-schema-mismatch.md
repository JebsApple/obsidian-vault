---
created: 2026-07-11
tags:
  - tipo/zettel
  - proyecto/minegocio
  - tech/go
aliases:
  - schema mismatch
  - tabla registro_ventas
---

# Tabla existente con schema distinto al esperado por el repository

## Lo que aprendí
Si una tabla ya existe en la BD pero con esquema distinto (ej: `id` en vez de `id_venta`, sin FK, sin CHECK), el repository fallará. Hay que recrear la tabla para coincidir con lo que el repository espera. No asumir que una tabla existente tiene el schema correcto.

## Contexto
2026-06-18 en MiNegocio. La tabla `registro_ventas` existía pero con esquema incompatible con `venta_repository.go`.

## Aplicación
Al integrar código que crea tablas: siempre verificar el schema existente en la BD contra lo que el repository espera. Crear migraciones que alteren la tabla existente en vez de asumir que es nueva.

## Conexiones
- [[go-scan-null-coalesce]]
- [[bcrypt-hash-en-seed]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
