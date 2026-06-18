---
tags: [research, selfhosted, tools]
---

# Self-Hosted Recomendados 2026

Apps que vale la pena correr uno mismo (vía Docker):

## Infraestructura
| App | Reemplaza | Por qué |
|-----|-----------|---------|
| **Vaultwarden** | Bitwarden | Password manager, liviano, 1 container |
| **Immich** | Google Photos | Backup de fotos, reconocimiento facial |
| **RustDesk** | TeamViewer/AnyDesk | Escritorio remoto, open-source |
| **Audiobookshelf** | Audible | Audiolibros + podcasts self-hosted |

## Seguridad & Red
- **Headscale** → Tailscale self-hosted
- **NetBird** → Alternativa a Tailscale (WireGuard-based)
- **Pangolin** → Alternativa a Cloudflare Tunnel

## Notas
- CachyOS es ideal para self-hosting por los repos optimizados
- Podman como alternativa a Docker (daemonless, rootless, native en Linux)
- Tailscale Funnel para exponer servicios sin abrir puertos

## Links
- https://netbird.io
- https://github.com/dani-garcia/vaultwarden
- https://github.com/immich-app/immich
