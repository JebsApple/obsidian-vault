---
tags:
  - ingenieria-software
  - testing
  - automatizacion
  - selenium
  - junit
aliases:
  - test-automation
  - ci-testing
created: 2026-07-10
up: "[[MOC/ingenieria-software]]"
---

# Automatización de Pruebas

Herramientas y beneficios de automatizar el testing de software.

## Beneficios

| Beneficio | Descripción |
|-----------|------------|
| **Velocidad** | Ejecución masiva en minutos vs horas manuales |
| **Repetibilidad** | Misma prueba, mismo resultado siempre |
| **Cobertura** | Probar miles de escenarios en cada release |
| **Detección temprana** | Bugs encontrados antes de producción |
| **Ahorro de costo** | Corregir en dev es 10x más barato que en prod |
| **CI/CD** | Integración continua necesita testing automatizado |

## Desafíos

| Desafío | Mitigación |
|---------|-----------|
| Costo inicial alto | Empezar con pruebas críticas |
| Mantenimiento de scripts | Page Object Model, design patterns |
| No todo es automatizable | UX, exploratorio, edge cases extremos |
| Curva de aprendizaje | Capacitación, documentación |

## Herramientas Principales

### Selenium
- Framework para testing web automatizado
- Soporta Chrome, Firefox, Safari, Edge
- Lenguajes: Java, Python, C#, JavaScript
- Patrón: Page Object Model (POM)

### JUnit
- Framework de testing para Java
- Anotaciones: `@Test`, `@Before`, `@After`
- Assertions: assertEquals, assertTrue, assertNotNull
- Integrado en la mayoría de IDEs Java

### SonarQube
- Análisis estático de código
- Detecta: bugs, vulnerabilities, code smells
- Métricas: cobertura, duplicación, complejidad ciclomática
- Integración con CI/CD pipelines

## Integración con CI/CD

```
┌──────┐    ┌──────┐    ┌──────┐    ┌──────┐
│ Code │───→│ Build│───→│ Test │───→│Deploy│
│ Push │    │Maven │    │JUnit │    │Docker│
│      │    │npm   │    │Selen.│    │K8s   │
└──────┘    └──────┘    └──────┘    └──────┘
                   │         │
              SonarQube   Reports
              (análisis)  (coverage)
```

## Estrategia de Testing

| Nivel | Qué prueba | Herramienta |
|-------|-----------|------------|
| Unit | Funciones aisladas | JUnit, pytest, Jest |
| Integration | Módulos juntos | Selenium, TestContainers |
| E2E | Flujo completo usuario | Selenium, Playwright |
| Performance | Carga y estrés | JMeter, k6 |

## Ver También
- [[devops]] — testing como fase del pipeline
- [[automatizacion-pruebas]] — detail de Selenium/CI/CD
- [[calidad-software]] — testing como evaluación de calidad
- [[SOLID]] — código SOLID es más testeable
