---
created: 2026-07-11
tags:
  - tipo/zettel
  - tech/waybar
aliases:
  - BindsTo
  - daemon independiente
  - hover daemon
---

# Waybar daemon: NO atar al ciclo de vida de waybar

## Lo que aprendí
`BindsTo=waybar.service` en el daemon auxiliar **detiene** el daemon cuando waybar para pero **NO lo rearranca** cuando waybar vuelve. El daemon quedó muerto y el state file clavado. Fix: hacer el daemon independiente (`WantedBy=default.target`, `Restart=always`, `After=waybar.service`). El daemon ya es self-healing: relee `pidof waybar` y `hyprctl layers` en cada ciclo.

## Contexto
2026-06-23 en Waybar. El hover-daemon dejó de funcionar después de un `waybar-reload`.

## Aplicación
Para daemons auxiliares que solo escriben un state file: hacerlos independientes y resilientes. NO atarlos al ciclo de vida del servicio principal. Si el daemon necesita saber si el servicio principal está vivo, que lo detecte en cada ciclo.

## Conexiones
- [[waybar-css-hover-per-module]]
- [[waybar-double-start-problema]]

## Fuente
- Original: `05-Archive/MiNegocio/Conocimiento/lecciones.md`
- Proyecto: MiNegocio
