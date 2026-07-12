---
tags:
  - ingenieria-software
  - modelado
  - diseno
  - arquitectura
aliases:
  - design-principles
  - acoplamiento
  - cohesion
created: 2026-07-10
up: "[[MOC/ingenieria-software]]"
---

# Principios de Modelado y Diseño

10 principios para guiar decisiones de diseño arquitectónico.

## Los 10 Principios

### 1. Trazabilidad con Requerimientos
Cada decisión de diseño debe rastrearse a un requerimiento.
- Si no puedes justificar por qué existe, probablemente no debería existir

### 2. Alineación Arquitectónica
El diseño debe ser consistente con la arquitectura del sistema.
- No mezclar estilos (no meter microservicios en una monolito)

### 3. Diseño de Datos = Diseño de Funciones
Los datos y las funciones se modelan juntos.
- Mal diseño de datos → código frágil y redundante

### 4. Diseño de Interfaces Cuidadoso
Las interfaces (APIs) son contratos:
- Versionado desde el inicio
- Contratos claros y estables
- [[SOLID#ISP — Interface Segregation Principle|ISP]] aplica aquí

### 5. Independencia de Componentes
Los componentes deben poder desarrollarse, probarse y desplegarse independientemente.
- Acoplamiento mínimo entre componentes

### 6. Acoplamiento Loose (Dependency Injection)

```python
# ❌ Acoplamiento fuerte
class Servicio:
    def __init__(self):
        self.db = MySQLDatabase()  # hardcode

# ✅ Acoplamiento loose
class Servicio:
    def __init__(self, db: Database):  # inyectado
        self.db = db
```

### 7. Representaciones Claras
Los diseños deben ser comprensibles por todo el equipo.
- UML, diagramas, documentación viviente

### 8. Diseño Iterativo
- No intentar el diseño perfecto a la primera
- Iterar, feedback, refinar

### 9. Compatibilidad con Ágil
- El diseño debe soportar cambios incrementales
- No crear estructuras rígidas que no evolucionan

### 10. Reutilización
- Buscar patrones existentes antes de inventar nuevos
- Bibliotecas internas, módulos compartidos

## Resumen

| # | Principio | Enfoque |
|---|-----------|---------|
| 1 | Trazabilidad | Cada diseño → requisito |
| 2 | Alineación | Consistencia arquitectónica |
| 3 | Datos = Funciones | Modelado conjunto |
| 4 | Interfaces | Contratos versionados |
| 5 | Independencia | Componentes aislados |
| 6 | Loose coupling | DI, acoplamiento mínimo |
| 7 | Representaciones | UML y documentación clara |
| 8 | Iterativo | Diseño evolutivo |
| 9 | Compatible con ágil | Soporte a cambios |
| 10 | Reutilización | No reinventar la rueda |

## Ver También
- [[SOLID]] — principios OOP que complementan estos
- [[diagrama-paquetes]] — organización de componentes
- [[diagrama-clases]] — modelado de clases
- [[diagrama-despliegue]] — arquitectura física
