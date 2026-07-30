# OmniRoute

Router de IA multi-provider con fallback automático, compresión y dashboard web.

## Estado actual

- **Versión**: 3.8.49
- **Dashboard**: http://localhost:20128
- **API Base**: http://localhost:20128/v1
- **API Key**: `dev` (local)
- **Puerto**: 20128

## Uso con OpenCode

```bash
export OMNIROUTE_API_KEY=dev
opencode -m omniroute/auto/best-free
```

Modelos disponibles: `opencode models | grep omniroute`

Los más útiles:
- `omniroute/auto/best-free` — mejor modelo gratuito del momento
- `omniroute/auto/coding:free` — coding free
- `omniroute/auto/coding:cheap` — coding económico
- `omniroute/ddgw/gpt-5.4-mini` — GPT-5.4 Mini vía DuckDuckGo
- `omniroute/auto/best-coding` — mejor coding (usa pago si hay)
- `omniroute/auto/best-fast` — más rápido disponible

## Comandos útiles

```bash
# Iniciar servidor
omniroute serve --port 20128 --no-open --daemon

# Ver estado
curl http://localhost:20128/v1/models -H "Authorization: Bearer dev"

# Regenerar config OpenCode (si cambian los modelos)
omniroute setup-opencode --api-key dev --only "auto/,ddgw/gpt,mcode/" --model auto/best-free

# Ver modelos disponibles en OmniRoute
curl -s http://localhost:20128/v1/models -H "Authorization: Bearer dev" | jq '.data[].id'
```

## Models en OpenCode (~41)

Generados con `--only "auto/,ddgw/gpt-5.4-nano,ddgw/gpt-5.4-mini,mcode/"` para incluir solo modelos con `limit.output` (requisito de OpenCode).

Config en `~/.config/opencode/opencode.json` (separado del `opencode.jsonc` original).

## Rollback

Para volver al estado anterior sin OmniRoute:

```bash
bash ~/.opencode-backup/omniroute-rollback/reparar-opencode.sh
```

Eso mata el proceso, desinstala el paquete, borra `opencode.json`, restaura config original.

## Notas

- OmniRoute decide qué proveedor usar según latencia y disponibilidad (ruteo automático)
- `auto/best-free` routeó a `big-pickle` en prueba con 62ms de latencia
- La API key `dev` es el default local — no exponer en producción
- Archivos de config: `~/.omniroute/` (datos, logs, sqlite)
- No requiere registro de cuenta para uso local
