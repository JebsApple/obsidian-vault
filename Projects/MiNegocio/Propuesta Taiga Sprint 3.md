---
tags: [proyecto/minegocio, taiga, sprint-3, plan]
---

# Propuesta Taiga — Sprint 3

> Basado en: estado post-revert (2026-06-19), deuda técnica documentada, y requerimientos de la universidad para CI/CD.

---

## Logrado (Sprint 2)

| Historia | Descripción |
|----------|-------------|
| S2-HU01 | Login funcional con JWT |
| S2-HU02 | Punto de Venta con carrito, búsqueda, registro ventas |
| S2-HU03 | CRUD productos (crear, listar, editar, soft delete) |
| S2-HU04 | Galería + imágenes drag&drop + barcode scanner |
| S2-HU05 | Inventario (vista con estado Normal/Bajo/Agotado) |
| S2-HU06 | Registro de Ventas (historial) |
| S2-HU07 | Sesiones de usuario (login/logout audit trail) |
| S2-HU08 | UX Login con CSS propio, paleta #D60000, responsive 375px |

---

## Historias de Usuario para Sprint 3

### S3-HU01: Login Seguro con bcrypt

> **Como** administrador, **quiero** que las contraseñas se almacenen con bcrypt **para** proteger los datos aunque la DB se comprometa.

**Criterios:**
- Migrar passwords existentes de texto plano a bcrypt (script `migrate_bcrypt.go`)
- Nuevos registros usan bcrypt desde el registro
- Login existente sigue funcionando post-migración
- No hay downtime: la migración puede validar contra ambos formatos mientras se completa

**Archivos a modificar:**
- `repository/usuario_repository.go` — cambiar `WHERE password_hash = $2` por bcrypt verify
- `service/auth_service.go` — usar `bcrypt.GenerateFromPassword` en register
- Nuevo: `scripts/migrate_bcrypt.go` — lee todos los usuarios, hashea y actualiza

**Asignación sugerida:** Gabriel (backend) + Victor (DB: backup antes de migrar)

---

### S3-HU02: JWT Seguro sin Secret Hardcodeado

> **Como** administrador, **quiero** que el JWT_SECRET sea configurable por entorno **para** que el mismo binario pueda usarse en dev y prod con diferentes secretos.

**Criterios:**
- `config/jwt.go` lee `JWT_SECRET` de variable de entorno **sin fallback**
- Si no está definida, el servidor no arranca (panic o error fatal)
- Jenkins inyecta el secreto vía Jenkins Credentials
- Dev usa su propio `.env` o variable de shell

**Archivos a modificar:**
- `config/jwt.go` — eliminar default hardcodeado, hacer `os.Getenv("JWT_SECRET")` obligatorio

**Asignación sugerida:** Gabriel

---

### S3-HU03: Docker Build Multi-Arquitectura para CI/CD

> **Como** desarrollador, **quiero** que `docker build` compile para la arquitectura del servidor de producción **para** que Jenkins pueda desplegar sin error `exec format error`.

**Criterios:**
- Dockerfile compila con `GOOS=linux GOARCH=amd64` (o `arm64` según servidor destino)
- La imagen resultante corre sin error en producción
- El Jenkinsfile se actualiza para usar esta imagen

**Archivos a modificar:**
- `Dockerfile` — agregar `GOARCH` explícito en `go build`
- `Jenkinsfile` — verificar que el stage de build use la imagen actualizada

**Asignación:** Gabriel (backend/Docker) + Nicolás (Jenkins)

---

### S3-HU04: Control de Acceso por Rol

> **Como** administrador, **quiero** que cada usuario tenga permisos según su rol **para** que vendedores no puedan modificar productos ni ver datos sensibles.

**Criterios:**
- `AuthMiddleware` extrae `user_id` y `rol` del JWT y los pasa al handler via `context.WithValue`
- Middleware de autorización opcional: `RequireRole("admin")` que rechaza si el rol no coincide
- Vendedores: solo ver productos y registrar ventas
- Admins: CRUD completo, inventario, ventas de todos

**Archivos nuevos/modificados:**
- `middleware/auth_middleware.go` — extraer claims y ponerlos en `r.Context()`
- `middleware/role_middleware.go` — nuevo, verifica rol antes del handler
- `routes/routes.go` — aplicar `RequireRole` en rutas sensibles

**Asignación sugerida:** Gabriel/MelusineZoe, revisa Ignacio

---

### S3-HU05: id_vendedor Dinámico desde JWT

> **Como** vendedor, **quiero** que las ventas se registren con mi usuario **para** que el historial refleje quién vendió realmente.

**Criterios:**
- `CarritoCompras.vue` ya no hardcodea `id_vendedor: 1`
- Frontend obtiene `user_id` desde `localStorage.getItem('usuario')` (ya almacenado por LoginPage)
- `ventasService.registrarVenta(items)` envía `id_vendedor` extraído del localStorage
- Backend valida que el `id_vendedor` coincida con el token (seguridad)

**Archivos a modificar:**
- `CarritoCompras.vue` — usar `JSON.parse(localStorage.getItem('usuario')).id` en vez de hardcode
- `handler/venta_handler.go` — validar id_vendedor contra token (cuando S3-HU04 esté listo)

**Asignación sugerida:** Ignacio (frontend) + Gabriel (validación backend)

---

### S3-HU06: Pipeline CI/CD Frontend

> **Como** desarrollador, **quiero** que el frontend se despliegue automáticamente via Jenkins **para** evitar errores manuales.

**Criterios:**
- Jenkinsfile en frontend: `npm ci && npm run build && scp dist/* deploy@server:/var/www/prod/frontend/`
- Se gatilla con push a `main`
- Pipeline notifica éxito/fallo (por ahora: salida en consola Jenkins)

**Archivos nuevos:**
- `Jenkinsfile` en raíz de `minegocio-frontend`

**Asignación sugerida:** Nicolás (CI/CD), supervisa LaManzana

---

### S3-HU07: Auditoría de Sesiones Completa

> **Como** administrador, **quiero** ver quién inició sesión y cuándo **para** auditar el uso del sistema.

**Criterios:**
- Cada `POST /api/auth/login` registra automáticamente en `registro_sesiones`
- Logout llama `POST /api/sesiones/cierre` y actualiza `cierre_sesion`
- Vista de sesiones (últimas 100) y sesiones activas (sin cierre)
- Frontend: nueva página `/sesiones` o sección en dashboard

**Archivos a modificar:**
- `handler/auth_handler.go` — llamar `sesionService.RegistrarInicio` después de login exitoso
- `App.vue` logout — llamar `POST /api/sesiones/cierre` antes de limpiar localStorage
- Nueva vista `SesionesPage.vue` (opcional)

**Asignación sugerida:** Gabriel (backend) + Ignacio (frontend vista)

---

### S3-HU08: Auto-Migraciones DB al Iniciar

> **Como** desarrollador, **quiero** que las migraciones SQL se ejecuten automáticamente al iniciar el backend **para** no olvidar aplicarlas en despliegues.

**Criterios:**
- Al arrancar, backend ejecuta migraciones pendientes en orden
- Migraciones son idempotentes (`CREATE IF NOT EXISTS`, etc.)
- Tabla `schema_migrations` para trackear cuáles ya se ejecutaron

**Archivos nuevos:**
- `migrations/` directorio con archivos SQL numerados
- `config/migrate.go` — lee y ejecuta migraciones
- Llamar desde `main.go` después de `ConnectDB()`

**Asignación sugerida:** Victor (DB) + Gabriel (integración en main.go)

---

### S3-HU09: Limpieza de Código Muerto

> **Como** desarrollador, **quiero** eliminar archivos y componentes que no se usan **para** mantener el códigobase limpio.

**Criterios:**
- Eliminar `HelloWorld.vue`, `plugins/axios.js`, `middleware/authGuard.js`, `esquema.sql`
- Consolidar CSS duplicado (botones/badges repetidos)
- Eliminar `ventasService.getVenta(id)` si no se usa

**Asignación sugerida:** Ignacio (frontend)

---

### S3-HU10: KanbanBoard + NavBar/SideBar del STL-Redesign

> **Como** usuario, **quiero** un tablero Kanban para arrastrar productos entre estados de stock **para** gestionar el inventario visualmente.

**Criterios:**
- Recuperar componentes del STL-redesign (KanbanBoard, NavBar, SideBar) que se pospusieron
- NO traer AnalisePage ni InventarioPage viejos (ya tenemos versiones funcionales)
- KanbanBoard debe integrarse con el endpoint PATCH /api/inventario/{id}/stock (que existe pero no tiene ruta)
- NavBar/SideBar opcionales — solo si mejoran la UX actual

**Archivos del STL redesign que existen en commits pasados:**
- `src/components/KanbanBoard.vue` — tablero drag & drop 4 columnas
- `src/components/NavBar.vue` — barra superior con menú
- `src/components/SideBar.vue` — sidebar colapsable
- `src/components/LogoSVG.vue` — logo SVG

**Asignación sugerida:** Ignacio (frontend), revisa Victor

---

## Resumen de tareas

| ID | Tarea | Prioridad | Esfuerzo | Asignado |
|----|-------|-----------|----------|----------|
| S3-HU01 | bcrypt passwords | 🔴 Crítica | M | Gabriel + Victor |
| S3-HU02 | JWT_SECRET por entorno | 🔴 Crítica | S | Gabriel |
| S3-HU03 | Docker multi-arquitectura | 🔴 Crítica | S | Gabriel + Nicolás |
| S3-HU04 | Control acceso por rol | 🟡 Alta | M | Gabriel + MelusineZoe |
| S3-HU05 | id_vendedor dinámico | 🟡 Alta | S | Ignacio + Gabriel |
| S3-HU06 | CI/CD frontend | 🟡 Alta | M | Nicolás |
| S3-HU07 | Auditoría sesiones | 🟡 Alta | M | Gabriel + Ignacio |
| S3-HU08 | Auto-migraciones DB | 🟡 Alta | L | Victor + Gabriel |
| S3-HU09 | Limpieza código muerto | 🟢 Baja | S | Ignacio |
| S3-HU10 | KanbanBoard del STL | 🟡 Media | M | Ignacio |

---

## Jenkins Pipeline (despliegue producción)

> Adaptado de las instrucciones universitarias: [[Configuración de usuario de despliegue entre Server A (Jenkins) y Server B (Tomcat) Objetivo]]

### Arquitectura de despliegue

| Componente | Dirección | Rol |
|------------|-----------|-----|
| **Server A** — Jenkins | 192.168.50.28 | CI/CD: compila, testea, empaqueta |
| **Server B** — Producción | 192.168.50.25 | Ejecuta backend + sirve frontend |

### Flujo del pipeline

```
Push a main
  → Jenkins detecta cambio (webhook Gitea)
    → Checkout (clona repo)
    → Test (go test ./...)
    → Build (docker build con GOARCH explícito)
    → Deploy (scp/rsync + ssh a Server B)
```

### Configuración de Jenkins (Server A — 192.168.50.28)

**Credenciales:**
- URL: `http://192.168.50.28:8080`
- Usuario: `equipo6`
- Password: `equipo!"#$`

Pasos desde la UI de Jenkins:
1. **New Item** → nombre del pipeline (ej: `MiNegocio-backend`) → tipo **Pipeline**
2. **Build Triggers** → marcar "GitHub hook trigger for GITScm polling" (o el hook de Gitea)
3. **Pipeline** → "Pipeline script from SCM" → Git → URL del repo + credenciales SSH
4. Guardar

### Configuración del usuario deploy en Server B (192.168.50.25)

```bash
# Paso 1: Crear usuario deployadmin6 (reemplazar N=6 por número de equipo)
sudo adduser deployadmin6
# Contraseña: deployAdmin

# Paso 2: Configurar SSH
sudo mkdir -p /home/deployadmin6/.ssh
sudo chown -R deployadmin6:deployadmin6 /home/deployadmin6
sudo chmod 700 /home/deployadmin6/.ssh

# Paso 3: Permisos sobre directorios de producción
# Backend: directorio donde se copia el binario o se despliega Docker
sudo chown -R deployadmin6:deployadmin6 /opt/minegocio-backend
# Frontend: archivos estáticos servidos por nginx
sudo chown -R deployadmin6:deployadmin6 /var/www/prod/frontend

# Paso 4: En Server A (Jenkins), generar clave SSH para deploy
sudo ssh-keygen -t rsa -b 4096 -C "jenkins@server-a" -f /root/.ssh/id_rsa_deployadmin6
# Enter passphrase: dejar vacía

# Paso 5: Copiar clave pública a Server B
sudo ssh-copy-id -i /root/.ssh/id_rsa_deployadmin6.pub deployadmin6@192.168.50.25

# Paso 6: Verificar
sudo ssh -i /root/.ssh/id_rsa_deployadmin6 deployadmin6@192.168.50.25 "whoami"
# Debe responder: deployadmin6

# Paso 7: Sudo restringido en Server B (solo systemctl para el backend)
sudo visudo  # agregar:
# deployadmin6 ALL=(ALL) NOPASSWD: /usr/bin/systemctl start minegocio-backend, /usr/bin/systemctl stop minegocio-backend, /usr/bin/systemctl restart minegocio-backend, /usr/bin/systemctl status minegocio-backend

# Verificar
sudo visudo -c
su - deployadmin6
sudo -l  # debe mostrar solo esos comandos
sudo -n systemctl status minegocio-backend  # no debe pedir contraseña

# Paso 8: Verificación remota completa
sudo ssh -i /root/.ssh/id_rsa_deployadmin6 deployadmin6@192.168.50.25 "sudo -n systemctl status minegocio-backend"
```

### Jenkinsfile (backend)

```groovy
pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'minegocio-backend'
        PROD_SERVER = 'deployadmin6@192.168.50.25'
        DB_PASSWORD = credentials('db-password')
        JWT_SECRET  = credentials('jwt-secret')
    }
    stages {
        stage('Checkout') {
            steps { checkout scm }
        }
        stage('Test') {
            steps { sh 'go test ./...' }
        }
        stage('Build Docker') {
            steps {
                sh 'docker build -t ${DOCKER_IMAGE}:latest .'
            }
        }
        stage('Deploy Producción') {
            steps {
                sshPublisher(
                    publishers: [
                        sshPublisherDesc(
                            configName: 'prod-server',
                            verbose: true,
                            transfers: [
                                sshTransfer(
                                    execCommand: '''
                                        docker save ${DOCKER_IMAGE}:latest | ssh ${PROD_SERVER} 'docker load'
                                        ssh ${PROD_SERVER} 'docker stop minegocio-backend || true && docker rm minegocio-backend || true'
                                        ssh ${PROD_SERVER} "docker run -d --name minegocio-backend -p 3001:3000 -e DB_PASSWORD=${DB_PASSWORD} -e JWT_SECRET=${JWT_SECRET} -e DB_NAME=cliente_prod ${DOCKER_IMAGE}:latest"
                                    '''
                                )
                            ]
                        )
                    ]
                )
            }
        }
    }
    post {
        failure { sh 'echo "Pipeline falló"' }
        success { sh 'echo "Despliegue exitoso"' }
    }
}
```

### Despliegue manual del frontend (mientras no tenga pipeline)

```bash
cd /home/icin/minegocio-frontend
npm ci && npm run build
cp -r dist/* /var/www/prod/frontend/
# Verificar
curl http://192.168.50.25:8000/
```

### SonarQube (análisis de calidad)

- URL: http://192.168.50.28:9000
- Usuario: `equipo6`
- Password: `Equipo1234567!`
- Se integra como stage opcional en Jenkins: `sonar-scanner` después de `Test`

---

## Enlaces relacionados

- [[MiNegocio - Deploy Prod]] — instrucciones completas de despliegue
- [[Configuración de usuario de despliegue entre Server A (Jenkins) y Server B (Tomcat) Objetivo]]
- [[Cuentas Jenkins-sonarqube]]
- [[Deuda Técnica]]
