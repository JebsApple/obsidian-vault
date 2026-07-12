---
tags:
  - ingenieria-software
  - principios
  - oop
aliases:
  - SRP
  - OCP
  - LSP
  - ISP
  - DIP
created: 2026-07-10
up: "[[MOC/ingenieria-software]]"
---

# SOLID

Cinco principios de diseño orientado a objetos que hacen el código más mantenible, extensible y testeable.

## Los 5 Principios

### SRP — Single Responsibility Principle
> Una clase debe tener **una sola razón para cambiar**.

Cada clase maneja un solo aspecto del sistema.
```python
# ❌ SRP violado
class UserManager:
    def create_user(self): ...
    def send_email(self): ...
    def generate_report(self): ...

# ✅ SRP respetado
class UserService: ...
class EmailService: ...
class ReportService: ...
```

### OCP — Open/Closed Principle
> Abierto a extensión, cerrado a modificación.

```python
# OCP: agregar nuevo tipo sin modificar código existente
class Notifier(ABC):
    @abstractmethod
    def send(self, msg): ...

class EmailNotifier(Notifier):
    def send(self, msg): ...

class SmsNotifier(Notifier):
    def send(self, msg): ...

# Agregar PushNotifier no modifica NotificationService
```

### LSP — Liskov Substitution Principle
> Subtipos deben ser sustituibles por sus tipos base sin alterar corrección.

Si `Squircle` hereda de `Circle`, debe poder usarse donde se espere un `Circle` sin romper nada.
```python
# ❌ LSP violado
class Rectangle:
    def set_width(self, w): ...
    def set_height(self, h): ...
    def area(self): return self.w * self.h

class Square(Rectangle):
    def set_width(self, w):
        self.w = self.h = w  # rompe expectativa de rectangle
```

### ISP — Interface Segregation Principle
> Mejor interfaces pequeñas y específicas que una grande general.

```python
# ❌ ISP violado
class Worker(ABC):
    @abstractmethod
    def work(self): ...
    @abstractmethod
    def eat(self): ...
    @abstractmethod
    def sleep(self): ...

# ✅ ISP respetado
class Workable(ABC):
    @abstractmethod
    def work(self): ...

class Feedable(ABC):
    @abstractmethod
    def eat(self): ...
```

### DIP — Dependency Inversion Principle
> Módulos de alto nivel no deben depender de bajo nivel. Ambos deben depender de abstracciones.

```python
# ❌ DIP violado
class MySQLDatabase:
    def save(self, data): ...

class UserService:
    def __init__(self):
        self.db = MySQLDatabase()  # acoplamiento directo

# ✅ DIP respetado
class Database(ABC):
    @abstractmethod
    def save(self, data): ...

class UserService:
    def __init__(self, db: Database):  # depende de abstracción
        self.db = db
```

## Resumen Visual

| Principio | Qué previene | Beneficio |
|-----------|--------------|-----------|
| SRP | Clases que hacen todo | Cambios aislados |
| OCP | Modificar código existente | Extensión segura |
| LSP | Herencia que rompe | Polimorfismo confiable |
| ISP | Interfaces gigantes | Acoplamiento mínimo |
| DIP | Módulos rígidos | Flexibilidad |

## Ver También
- [[codigo-limpio]] — principios complementarios DRY/KISS/YAGNI
- [[principios-modelado]] — principios de modelado arquitectónico
- [[calidad-software]] — métricas de calidad
