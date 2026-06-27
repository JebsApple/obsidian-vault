---
tags: [research, networking, vpn, selfhosted]
---

# Tailscale & Headscale 2026

## Tailscale
- Mesh VPN basado en WireGuard
- **Tailscale Serve** — expone servicios locales al tailnet con HTTPS automático
- **Tailscale Funnel** — expone al internet público (alternativa a ngrok)
- **Taildrop** — transferencia de archivos entre dispositivos
- **Tailscale SSH** — SSH gestionado con ACLs
- Gratis para hasta 3 usuarios (personal)
- Clientes: Linux, macOS, Windows, Android, iOS, Steam Deck

## Headscale (alternativa open-source)
- Implementación self-hosted del control server de Tailscale
- Sin límite de usuarios, sin dependencia de nube de Tailscale
- OIDC custom (Authentik, Keycloak, Google)
- Control total de datos de coordinación
- Corre en VPS con Docker

## Relevancia
- Útil para el proyecto Mihon ↔ Suwayomi (conexión PC-celular)
- Alternativa a VPN tradicional para acceso remoto
- Tailscale Funnel reemplaza ngrok para compartir dev servers

## Links
- https://tailscale.com
- https://github.com/juanfont/headscale
