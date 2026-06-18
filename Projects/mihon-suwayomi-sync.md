---
tags: [proyecto, manga, red-local, en-progreso]
---

# Sync Mihon ↔ Suwayomi

Objetivo: que Mihon (Android) y Suwayomi (PC) estén sincronizados automáticamente — capítulos leídos y biblioteca — sin transferir backups manualmente.

## Solución elegida

Usar **Suwayomi como servidor central**. Mihon actúa como cliente via la extensión Suwayomi (Keiyoushi).

## Estado actual

- [x] Suwayomi corriendo en PC (instalado nativamente, no Docker)
  - PID activo, escucha en `*:4567`
  - Responde OK en localhost
- [x] FlareSolverr corriendo en Docker (puerto 8191)
- [x] Extensión Suwayomi instalada en Mihon
- [x] URL configurada: `http://192.168.0.106:4567`
- [ ] Conexión PC ↔ celular funcional — **bloqueada por problema de red**
- [ ] Migración de biblioteca Mihon → fuente Suwayomi

## Problema de red

El celular no puede alcanzar la IP del PC en la red local.

**Diagnóstico:**
- Sin firewall en PC (nft/iptables vacíos)
- AP Isolation desactivado en router
- PC en WiFi 2.4GHz (canal 7, 2442 MHz) — adaptador soporta 5GHz también
- Router tiene una sola SSID (sin separación de bandas visible)
- Celular en datos 5G móviles cuando falló — probablemente la causa real

**Hipótesis principal:** el celular estaba en datos móviles (5G), no en WiFi, al hacer las pruebas. Pendiente verificar con WiFi activo y datos móviles desactivados.

## Próximos pasos

1. Probar conexión desde celular con **datos móviles desactivados** y WiFi activo
2. Si falla → instalar Tailscale en PC y celular para bypass de red
   ```bash
   sudo pacman -S tailscale
   sudo systemctl enable --now tailscaled
   sudo tailscale up
   ```
3. Si funciona → migrar biblioteca en Mihon manga por manga (mantener presionado → Migrar → fuente Suwayomi)

## Referencia rápida

| Qué | Valor |
|-----|-------|
| IP local PC | 192.168.0.106 |
| Puerto Suwayomi | 4567 |
| URL para Mihon | `http://192.168.0.106:4567` |
| Extensión | Suwayomi (repo Keiyoushi) |
