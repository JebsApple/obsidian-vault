---
created: 2026-07-11
tags:
  - tipo/zettel
  - proyecto/minegocio
  - tech/frontend
aliases:
  - 404 uploads
  - nginx proxy uploads
---

# nginx debe proxear /uploads/ al backend para imágenes

## Lo que aprendí
Si el backend guarda imágenes con ruta relativa `/uploads/productos/<archivo>` y las sirve en `:3000`, pero nginx solo proxia `/api/`, las imágenes dan 404. Solución: añadir `location /uploads/ { proxy_pass http://localhost:3001; }` en nginx (prod) o `:3000` (dev). Verificar siempre con `curl -I`.

## Contexto
2026-06-26 en MiNegocio. Las imágenes de productos (`<img :src="p.imagen_url">`) fallaban con 404 después de integrar la funcionalidad de upload.

## Aplicación
Al agregar archivos estáticos servidos por el backend: recordar configurar nginx para proxear esa ruta. Verificar siempre con curl antes de asumir que el frontend falla.

## Conexiones
- [[dev-prod-separacion]]
- [[iconos-tabler-invisibles]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
