---
tags: [proyecto/minegocio, sprint-3, procedimiento, nicolas, hu01]
---

# Procedimiento — Nicolás — HU01: Deuda Técnica

Tus tareas ordenadas por fecha de inicio. Empezá de arriba a abajo.

---

## 1. S3-HU01-T03: Docker multi-arquitectura + Pipeline Jenkins `[backend]` `[test]` `[bugfix]`
**Fechas:** 23 jun → 30 jun

### ¿Qué estamos haciendo y por qué?

Hoy el backend se despliega "a mano". Vamos a **automatizar** con Jenkins: cuando alguien haga push a `main`, Jenkins corre tests, buildca la imagen Docker y la sube al servidor. Además arreglamos el Dockerfile que no especifica arquitectura (bug: compila para la máquina equivocada).

### Conceptos clave

- **Docker:** empaqueta la app con todo lo necesario para correr (librerías, config) en una imagen que funciona igual en cualquier servidor.
- **Jenkins:** robot que escucha eventos (push a git) y ejecuta tareas automáticas (tests, build, deploy).
- **Gitea:** nuestro GitHub propio, en `http://192.168.50.28:3000`.
- **GOOS/GOARCH:** variables que le dicen a Go para qué sistema operativo y arquitectura compilar. Linux AMD64 = servidores normales.

### Pasos

1. **Arreglar Dockerfile.** En la raíz del backend, cambiá el `go build` a:
   ```dockerfile
   RUN GOOS=linux GOARCH=amd64 go build -o main .
   ```
   Esto fuerza compilación para Linux 64 bits desde cualquier máquina.

2. **Crear/actualizar Jenkinsfile.** En la raíz del backend, con estas etapas:
   - **Checkout:** `checkout scm` — descarga el código desde Gitea
   - **Test:** `go test ./...` — ejecuta los tests
   - **Build Docker:** `docker build -t minegocio-backend:latest .`
   - **Deploy:** enviar la imagen al servidor de producción (192.168.50.25). Podés usar `docker save` + `scp` + `docker load` + `docker run`, o bien en el servidor hacer `git pull && docker build && docker run`.

3. **Configurar webhook en Gitea.** En el repo: Settings → Webhooks → Add webhook. URL de Jenkins (algo como `http://192.168.50.28:8080/gitea-webhook/post`). Elegí "Push events". Así Jenkins se entera automáticamente.

4. **Probar.** Hacé un push a `main` y verificá que Jenkins ejecute todo sin errores y la imagen funcione en producción.

---

## 2. S3-HU01-T04: SonarQube local + Jenkins `[backend]` `[test]`
**Fechas:** 30 jun → 4 jul

### ¿Qué estamos haciendo y por qué?

**SonarQube** analiza el código automáticamente y encuentra bugs, código duplicado, vulnerabilidades. Es un "revisor de código automático". La rúbrica pide usarlo. Servidor en `http://192.168.50.28:9000`.

### Pasos

1. **Agregar SonarQube al Jenkinsfile.** Un stage opcional que ejecute `sonar-scanner` con:
   - `sonar.projectKey=minegocio-backend`
   - `sonar.sources=.`
   - `sonar.host.url=http://192.168.50.28:9000`
   - `sonar.login=<token>` (generalo desde la UI de SonarQube)

2. **Verificar conectividad.** Entrá a `http://192.168.50.28:9000` con usuario `equipo6` y la pass de la vault.

3. **Probar análisis local.** Ejecutá `sonar-scanner` manualmente desde tu terminal.

4. **Revisar resultados.** El análisis debe pasar sin errores "bloqueantes". Los problemas típicos: variables no usadas, código duplicado, funciones muy largas.
