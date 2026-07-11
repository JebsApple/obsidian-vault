---
created: 2026-07-11
tags:
  - tipo/zettel
  - proyecto/minegocio
  - tech/go
aliases:
  - Scan NULL
  - COALESCE PostgreSQL
  - sql.NullString
---

# Go Scan() con NULL en PostgreSQL: usar COALESCE o sql.Null*

## Lo que aprendí
En Go, `rows.Scan()` en PostgreSQL falla silenciosamente si una columna `NULL` va a un `string`. El patrón `if err == nil { append }` descarta esas filas en silencio — el producto desaparecía de `/api/productos` pero seguía en `/api/inventario`. Soluciones: usar `COALESCE(col, '')` en el SQL o tipos `sql.Null*` en Go. Siempre propagar el error de Scan, nunca tragarlo.

## Contexto
2026-06-18 y 2026-07-02 en MiNegocio. Primero al hacer queries de productos, luego al investigar "productos fantasma" en inventario.

## Aplicación
En cualquier repository nuevo con Go + PostgreSQL: revisar si hay columnas anulables y usar COALESCE o sql.Null* siempre. Nunca ignorar el error de Scan.

## Conexiones
- [[go-register-endpoint-cadena]]
- [[tabla-schema-mismatch]]
- [[nginx-symlink-sites-enabled]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
