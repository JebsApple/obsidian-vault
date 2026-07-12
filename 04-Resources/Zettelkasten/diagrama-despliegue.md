---
tags:
  - ingenieria-software
  - uml
  - diagramas
  - despliegue
aliases:
  - deployment-diagram
  - infraestructura
created: 2026-07-10
up: "[[MOC/ingenieria-software]]"
---

# Diagrama de Despliegue UML

Modela la infraestructura física del sistema: hardware, software y su distribución.

## Elementos

| Elemento | Notación | Significado |
|----------|----------|------------|
| **Nodo** | Cubo 3D 📦 | Recurso computacional (servidor, PC, dispositivo) |
| **Artefacto** | Rectángulo con `<</doc>>` | Software desplegado (.war, .jar, .apk) |
| **Componente** | Rectángulo con icono | Módulo del sistema |
| **Relación** | Línea sólida/punteada | Comunicación entre nodos |
| **Manifestación** | `<<manifest>>` | Artefacto "vive en" un nodo |

## Notación de Nodo

```
┌─────────────────┐
│  <<device>>     │
│  Servidor Web   │
│  Apache/Tomcat  │
│                 │
│  ┌───────────┐  │
│  │ app.war   │  │  ← artefacto desplegado
│  └───────────┘  │
└─────────────────┘
```

## Ejemplo: Arquitectura J2EE

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│  <<device>>  │    │  <<device>>  │    │  <<device>>  │
│  Cliente     │───→│  Servidor    │───→│  Servidor    │
│  (Navegador) │    │  de Aplic.   │    │  de BD       │
│              │    │  Tomcat      │    │  MySQL       │
│  HTML/JS     │    │  app.war     │    │  datos.sql   │
└──────────────┘    └──────────────┘    └──────────────┘
```

## Ejemplo: App Android

```
┌──────────────┐    ┌──────────────┐
│  <<device>>  │    │  <<device>>  │
│  Smartphone  │───→│  Servidor    │
│  Android     │    │  Firebase    │
│  app.apk     │    │  Cloud       │
└──────────────┘    └──────────────┘
```

## Ejemplo: Cliente-Servidor

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│  <<device>>  │    │  <<device>>  │    │  <<device>>  │
│  PC Cliente  │───→│  Servidor    │───→│  NAS/Storage │
│              │    │  de Archivos │    │              │
└──────────────┘    └──────────────┘    └──────────────┘
```

## Cuándo Usar

- Planificar infraestructura antes de desplegar
- Documentar arquitectura existente
- Comunicar al equipo de operations
- Evaluar requerimientos de hardware

## Ver También
- [[devops]] — pipeline de despliegue continuo
- [[diagrama-clases]] — diseño lógico que se despliega
- [[diagrama-paquetes]] — organización del código
- [[ingenieria-software-fundamentos]] — capas de SE
