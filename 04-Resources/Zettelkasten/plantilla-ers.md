---
tags:
  - ingenieria-software
  - requerimientos
  - plantilla
  - ers
aliases:
  - SRS
  - especificacion-requerimientos
created: 2026-07-10
up: "[[MOC/ingenieria-software]]"
---

# Plantilla ERS (Especificación de Requerimientos de Software)

Estructura estándar para documentar requerimientos (SRS — Software Requirements Specification).

## Estructura del Documento

### 1. Introducción
- **Propósito:** para quién es el documento
- **Alcance:** qué cubre el sistema
- **Definiciones:** términos clave
- **Referencias:** documentos relacionados

### 2. Descripción General
- **Perspectiva del producto:** contexto en el sistema
- **Funciones principales:** resumen de capacidades
- **Restricciones:** limitaciones conocidas
- **Supuestos:** condiciones que se dan por sentadas

### 3. Requerimientos Específicos

#### Requerimientos Funcionales
Para cada RF:
- **Identificador** único (RF01, RF02, ...)
- **Descripción** clara y concisa
- **Prioridad** (MoSCoW o numérica)
- **Criterios de aceptación**

#### Requerimientos No Funcionales
- Rendimiento, disponibilidad, seguridad
- Mantenibilidad, portabilidad, usabilidad

### 4. Casos de Uso
- Diagramas de [[diagrama-uso|casos de uso]]
- Especificaciones textuales de cada caso

### 5. Anexos
- Prototipos, wireframes
- Glosario completo

## Ejemplo: Sistema Deportivo

Del curso (24 RF + 6 RNF):

```
RF01: Registrar nuevos socios
RF02: Consultar datos de socio
RF03: Generar carnet de socio
...
RF24: Reporte de asistencia

RNF01: Disponibilidad 99.5%
RNF02: Respuesta < 3 segundos
RNF03: Respaldo diario automático
RNF04: Cifrado AES-256
RNF05: Multi-idioma (ES/EN)
RNF06: Mantenimiento en < 4 horas
```

## Mejores Prácticas

- Cada RF tiene un identificador único y trazable
- Usar verbos de acción medibles (no "debe ser bueno")
- Incluir supuestos y dependencias
- Versionar el documento con el proyecto

## Ver También
- [[requerimientos]] — clasificación RF/RNF
- [[moscow]] — priorización
- [[comunicacion-requerimientos]] — cómo obtener los requerimientos
- [[diagrama-uso]] — para los casos de uso del ERS
