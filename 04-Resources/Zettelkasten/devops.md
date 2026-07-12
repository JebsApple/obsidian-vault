---
tags:
  - zettelkasten
  - devops
  - ci-cd
aliases:
  - Pipeline DevOps
created: 2026-07-10
fuente: DevOps.pptx — Universidad de Tarapacá
up: "[[MOCs/ingenieria-software|MOC Ingeniería de Software]]"
---

# DevOps

Filosofía que integra desarrollo (Dev) y operaciones (Ops) con automatización continua.

## 8 Fases del Pipeline

| Fase | Herramientas |
|------|-------------|
| 1. **Plan** | Jira, Trello |
| 2. **Code** | Git, GitHub/GitLab |
| 3. **Build** | Maven, Gradle, npm |
| 4. **Test** | JUnit, Selenium, SonarQube |
| 5. **Release** | Jenkins, GitHub Actions |
| 6. **Deploy** | Docker, Ansible |
| 7. **Operate** | Kubernetes, Terraform |
| 8. **Monitor** | Prometheus, Grafana |

## CI/CD
- **Continuous Integration:** Fusionar código frecuentemente, validar automáticamente
- **Continuous Delivery:** Deploy listo para producción con un botón
- **Continuous Deploy:** Deploy automático a producción tras pasar tests

## Beneficios
- Feedback rápido
- Menos errores en producción
- Deploy más frecuente y confiable
- Colaboración entre equipos

## Ver también
- [[04-Resources/Zettelkasten/automatizacion-pruebas|Automatización de Pruebas]]
- [[04-Resources/Zettelkasten/sonarqube|SonarQube]]
- [[04-Resources/Zettelkasten/modelos-desarrollo|Modelos de Desarrollo]]
