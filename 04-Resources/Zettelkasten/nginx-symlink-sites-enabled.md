---
created: 2026-07-11
tags:
  - tipo/zettel
  - proyecto/minegocio
  - tech/devops
aliases:
  - nginx sites-enabled
  - symlink
---

# nginx: symlink en sites-enabled para activar site

## Lo que aprendí
nginx requiere un symlink en `sites-enabled/` que apunte al archivo en `sites-available/` para activar un site. Si el symlink no existe, el site no carga. Verificar con `ls -la /etc/nginx/sites-enabled/` después de crear la config.

## Contexto
2026-06-18 en MiNegocio. El proyecto `minegocio-dev` no estaba habilitado en nginx.

## Aplicación
Después de crear/editar archivos en `sites-available/`: crear symlink en `sites-enabled/` y hacer `nginx -t && systemctl reload nginx`.

## Conexiones
- [[dev-prod-separacion]]
- [[nginx-proxy-uploads-imagenes]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
