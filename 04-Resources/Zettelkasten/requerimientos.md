---
tags:
  - ingenieria-software
  - requerimientos
  - planeacion
aliases:
  - functional-requirements
  - non-functional-requirements
created: 2026-07-10
up: "[[MOC/ingenieria-software]]"
---

# Requerimientos: Funcionales y No Funcionales

Clasificación fundamental de todo requisito de software.

## Requerimientos Funcionales (RF)

Describen **qué hace** el sistema — comportamiento observable.

| Ejemplo | RF del sistema |
|---------|---------------|
| "El sistema debe permitir registro de usuarios" | Funcionalidad concreta |
| "El sistema debe generar reportes PDF" | Output específico |
| "El sistema debe enviar notificaciones" | Acción verificable |

## Requerimientos No Funcionales (RNF)

Describen **cómo funciona** el sistema — atributos de calidad.

| Categoría | Ejemplo |
|-----------|---------|
| **Rendimiento** | "Debe responder en <2s bajo 1000 usuarios concurrentes" |
| **Usabilidad** | "Un usuario nuevo debe completar registro en <3 min" |
| **Seguridad** | "Cifrado AES-256 para datos en reposo" |
| **Mantenibilidad** | "Cambios menores en <4h, mayores en <2d" |
| **Portabilidad** | "Funcionar en Linux, Windows, macOS" |

## Método MoSCoW

Priorización de requerimientos:

| Prioridad | Significado | Ejemplo |
|-----------|-------------|---------|
| **Must have** | Sin esto el sistema no funciona | Login, CRUD básico |
| **Should have** | Importante pero no bloqueante | Búsqueda avanzada |
| **Could have** | Mejora pero prescindible | Exportar a Excel |
| **Won't have (this time)** | Excluido del alcance actual | Integración con IA |

## SMART para Requerimientos

Cada requerimiento debe ser:
- **S**pecífico — claro y sin ambigüedad
- **M**edible — verificable con un criterio
- **A**chievable — técnicamente posible
- **R**elevante — alineado con objetivos
- **T**emporal — con fecha límite

## Ejemplo: Sistema Deportivo (24 RF + 6 RNF)

Del [[plantilla-ers|ERS]] del curso:
- **RF01-RF24:** Gestión de socios, recepción, agenda, pagos, reportes
- **RNF01-RNF06:** Disponibilidad 99%, respuesta <3s, respaldo diario, cifrado, multi-idioma, mantenimiento en <4h

Ver [[plantilla-ers]] para la estructura completa del ERS.

## Ver También
- [[historias-usuario]] — formato ágil para RF
- [[comunicacion-requerimientos]] — cómo obtener requerimientos
- [[plantilla-ers]] — estructura del documento ERS
