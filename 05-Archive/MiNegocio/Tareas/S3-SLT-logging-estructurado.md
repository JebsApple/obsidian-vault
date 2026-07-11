---
tags: [taiga, SLT, backend, logging, sprint-3]
---

# S3-SLT-logging-estructurado — Logging Estructurado en Backend

## Objetivo
Implementar logging estructurado (JSON, niveles, request tracing) en el backend Go para tener visibilidad operativa en producción.

## Stack
- **Runtime:** Go 1.22+
- **Librería:** `log/slog` (stdlib, sin dependencias externas)
- **Env vars:** `LOG_LEVEL` (debug|info|warn|error), por defecto `info`
- **Formato:** Salida JSON a stdout/stderr

## Qué implementar

### 1. Config Logger (`config/logger.go`)
- Inicializar `slog` con handler JSON (`slog.NewJSONHandler`)
- Leer `LOG_LEVEL` de env var
- Soporte para `LOG_FORMAT=text` (desarrollo legible, por defecto `json`)
- Exportar funciones helper: `LogDebug`, `LogInfo`, `LogWarn`, `LogError`

### 2. Middleware de Request Logging (`middleware/logger.go`)
- Envolver el router con un middleware que loggee por request:
  - Método, path, query params
  - Status code (usando `ResponseRecorder` wrapper)
  - Duración (tiempo de respuesta)
  - Client IP (del header `X-Forwarded-For` o `r.RemoteAddr`)
  - Request ID (correlation UUID) — generado si el cliente no envía `X-Request-ID`
- Inyectar el Request ID en `context.Context` para uso en handlers

### 3. Middleware de Panic Recovery (`middleware/recovery.go`)
- Capturar panics con `recover()`
- Loggear stack trace completo con `slog.Error`
- Responder 500 con JSON `{"status": "error", "mensaje": "Error interno del servidor"}`
- No exponer detalles del panic al cliente

### 4. Error Logging en Handlers
Reemplazar los `log.Printf` y errores silenciados con `slog`:
- `main.go`: `fmt.Printf` de inicio → `slog.Info`
- `handler/producto_handler.go`: `log.Printf` de upload/delete → `slog.Info`/`slog.Warn`
- Todos los handlers: cuando un handler recibe error de service/repository, loggear con `slog.Error` + contexto (producto_id, usuario_id, etc.) antes de devolver JSON al cliente
- Los errores concretos NO se exponen al cliente (solo "Error interno"), salvo validaciones

### 5. Docker / Jenkins
- En `Jenkinsfile`: agregar `--log-opt max-size=10m --log-opt max-file=3` al `docker run`
- En `Dockerfile`: mantener CMD actual, los logs van a stdout automáticamente

## Archivos a modificar

| Archivo | Cambio |
|---------|--------|
| `config/logger.go` | (NUEVO) Inicializar slog, env vars, helpers |
| `middleware/logger.go` | (NUEVO) Request logging + request ID |
| `middleware/recovery.go` | (NUEVO) Panic recovery con stack trace |
| `main.go` | Integrar middlewares, reemplazar startup log |
| `handler/producto_handler.go` | Reemplazar `log.Printf` por slog |
| `handler/auth_handler.go` | Agregar slog.Error en errores |
| `handler/inventario_handler.go` | Agregar slog.Error en errores |
| `handler/venta_handler.go` | Agregar slog.Error en errores |
| `service/auth_service.go` | Agregar slog.Error en errores |
| `service/producto_service.go` | Agregar slog.Error en errores |
| `service/venta_service.go` | Agregar slog.Error en errores |
| `service/inventario_service.go` | Agregar slog.Error en errores |
| `repository/usuario_repository.go` | Agregar slog.Error en errores DB |
| `repository/producto_repository.go` | Agregar slog.Error en errores DB |
| `repository/venta_repository.go` | Agregar slog.Error en errores DB |
| `repository/inventario_repository.go` | Agregar slog.Error en errores DB |
| `middleware/auth_middleware.go` | Agregar slog.Warn en 401 |
| `Jenkinsfile` | `docker run --log-opt max-size=10m --log-opt max-file=3` |

## Criterios de aceptación

- [ ] `slog` configurado con JSON handler al iniciar app
- [ ] Cada request HTTP produce una línea JSON con: timestamp, level, method, path, status, duration, request_id, client_ip
- [ ] Errores de handler/service/repository se loggean con contexto antes de responder al cliente
- [ ] Panics no matan el server: recovery middleware loggea stack trace y responde 500
- [ ] Request ID se propaga a través de toda la cadena (middleware → handler → service → repository)
- [ ] `LOG_LEVEL` env var controla el nivel mínimo (default: info)
- [ ] `LOG_FORMAT=text` produce salida legible (útil en dev)
- [ ] Jenkinsfile tiene log opts de docker
- [ ] `go build ./...`, `go vet ./...`, `go test ./...` pasan

## Pruebas

### Unitarias
1. Logger config: `LOG_LEVEL=debug` → handler debug visible; `LOG_LEVEL=error` → solo error
2. Logger config: `LOG_FORMAT=text` → salida texto plano
3. Recovery middleware: handler que paniquea → response 500 + log stack trace
4. Recovery middleware: handler normal → response normal sin interferencia

### Manuales
```bash
# Probar logging de request
curl http://localhost:3000/api/productos
# Debe producir una línea JSON en stdout del backend

# Probar LOG_LEVEL
LOG_LEVEL=debug go run main.go  # debe mostrar debug

# Probar LOG_FORMAT
LOG_FORMAT=text go run main.go  # texto legible

# Verificar recovery
curl -X POST http://localhost:3000/api/productos -H "Content-Type: application/json" -d '{}'
# Debe responder 500 sin crash, mostrar stack trace en logs

# Verificar request ID
curl -H "X-Request-ID: mi-test-id" http://localhost:3000/api/productos
# El log debe incluir request_id=mi-test-id
```

## Dependencias
- Ninguna externa. `log/slog` viene en Go 1.21+ (ya usamos Go 1.22).

## Owner
- Victor Herrera (backend logging)

## Rama
- `S3-SLT-logging-estructurado` en `gitea:VHerrera/MiNegocio-backend.git`
- Creada desde `dev`
