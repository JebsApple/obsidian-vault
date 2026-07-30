# Codigo limpio

Extraído de `Codigo limpio.pptx`

---

## Diapositiva 1

INGENIERÍA CIVIL EN INFORMÁTICA

## Diapositiva 2

ARICA - CHILE

## Diapositiva 3

Patrones de Código Limpio
Los Patrones de Código Limpio no son patrones de diseño clásicos, sino prácticas o principios recurrentes que te ayudan a escribir código más:
Legible
Mantenible
Comprensible
Con menos errores.
Estos patrones surgen del libro "Clean Code" de Robert C. Martin y de buenas prácticas ampliamente aceptadas en la industria del software.

## Diapositiva 4

DRY (Don't Repeat Yourself)
La duplicación conduce a errores difíciles de encontrar. Si duplicas lógica y luego necesitas cambiarla, puedes olvidarte de una de las copias.
Beneficios:
Cambios rápidos y seguros (una sola fuente de verdad).
Menor volumen de código.
Más fácil de probar y mantener.
Cálculo de impuesto repetido en 3 lugares distintos. Si la fórmula cambia, puede que olvides actualizar alguna copia.

## Diapositiva 5

DRY (Don't Repeat Yourself)

## Diapositiva 6

KISS (Keep It Simple, Stupid)
Tendemos a sobre complicar por anticipación o por ego técnico. Pero el código simple es más comprensible, más confiable y más fácil de mantener.
Beneficios:
Facilita la lectura y revisión.
Reduce la posibilidad de errores.
Cualquiera puede entenderlo, incluso tú en 6 meses.
Diseñar un sistema de plugins para algo que solo necesita un switch simple con 3 opciones.

## Diapositiva 7

KISS (Keep It Simple, Stupid)

## Diapositiva 8

YAGNI (You Aren’t Gonna Need It)
Los programadores muchas veces anticipan requisitos que nunca se llegan a usar, aumentando la complejidad innecesariamente.
Beneficios:
Menos código que mantener.
Desarrollo más rápido y enfocado.
Escribir un sistema de exportación a cinco formatos distintos, cuando por ahora solo se necesita PDF.

## Diapositiva 9

YAGNI (You Aren’t Gonna Need It)

## Diapositiva 10

Nombres significativos
Los nombres son la principal fuente de comunicación entre personas que leen código (¡y tú mismo!). Malos nombres hacen que el código sea un acertijo.
Beneficios:
No necesitas comentarios redundantes.
Mejor comprensión por parte del equipo.
Más fácil de mantener y depurar.
f(a, b) es imposible de entender sin mirar todo el código. En cambio, calcularArea(base, altura) comunica su propósito de inmediato.

## Diapositiva 11

Nombres significativos

## Diapositiva 12

Funciones pequeñas
Funciones largas mezclan responsabilidades y hacen difícil aislar errores o probar comportamientos específicos. Dividir en pequeñas funciones mejora modularidad.
Beneficios:
Reutilizables.
Más fáciles de testear.
Mejora la comprensión de la lógica.
Una función procesarPedido() que valida, calcula descuentos, guarda en la base de datos y envía correos: si algo falla, cuesta saber por qué.

## Diapositiva 13

Funciones pequeñas
.

## Diapositiva 14

Separación de preocupaciones
Cuando la lógica de negocio se mezcla con la interfaz o acceso a datos, se dificulta el testeo, el cambio de tecnologías o la reutilización.
Beneficios:
Capas independientes = mejor mantenimiento.
Puedes cambiar la interfaz sin afectar la lógica.
Facilita las pruebas unitarias.
Un botón de interfaz que tiene lógica de negocio embebida directamente en su evento onClick

## Diapositiva 15

Separación de preocupaciones

## Diapositiva 16

Refactorización continua
A medida que el código evoluciona, su estructura se deteriora. Refactorizar permite mantener un diseño saludable, sin modificar el comportamiento externo.
Beneficios:
Mejora progresiva sin reescrituras costosas.
Facilita la lectura y testeo.
Previene la deuda técnica.
Dejar el código desordenado “porque funciona”, hasta que es imposible entenderlo o cambiarlo sin romperlo.

## Diapositiva 17

Refactorización continua

## Diapositiva 18

Regla de las Tres
El código repetido es costoso de mantener: si hay que hacer un cambio o corregir un error, debe hacerse en múltiples lugares.
Beneficios:
Reducción de errores y mantenimiento más sencillo.
Mejora la claridad del propósito del código.
Facilita la refactorización y la evolución del software.
La duplicación lleva a inconsistencias y errores. Peor aún, suele ocultar comportamientos comunes que deberían haberse abstraído.

## Diapositiva 19

Regla de las Tres

## Diapositiva 20

Singleton
El patrón Singleton es uno de los patrones de diseño más conocidos y utilizados en programación, especialmente cuando se necesita garantizar que una clase tenga una única instancia y proporcionar un punto de acceso global a ella.

## Diapositiva 21

Singleton
Estás desarrollando un sistema y necesitas una única conexión a la base de datos, o un único manejador de configuración, o un logger global. Si se crean múltiples instancias, podrías tener inconsistencias o un uso ineficiente de recursos.
Aquí es donde entra el Singleton quien garantiza que solo exista una instancia y que sea accesible desde cualquier parte del código.

## Diapositiva 22

¿Cómo funciona?
Constructor privado: impide que se creen instancias desde fuera de la clase.
Instancia estática: se almacena la única instancia dentro de un atributo estático de la misma clase.
Método de acceso público: proporciona acceso a la instancia, generalmente llamado getInstance() o similar.

## Diapositiva 23

¿Cómo funciona?
s1 y s2 apuntan al mismo objeto en memoria.
El valor aleatorio se genera solo una vez en el constructor del Singleton.
Aunque lo "pidamos" muchas veces, la clase solo se construye una vez.

## Diapositiva 24

Ventajas:
Control total sobre la instancia.
Útil para recursos compartidos (loggers, configuración global, etc.).
Reduce uso innecesario de memoria o conexiones.
Desventajas:
Dificulta el testing (porque es estático = no se puede mockear fácilmente).
Rompe el principio de inyección de dependencias.
Puede convertirse en un antipatrón si se abusa (efecto "global oculto").

## Diapositiva 25

Principios SOLID
Los principios SOLID son cinco principios fundamentales del diseño orientado a objetos. Fueron popularizados por Robert C. Martin y ayudan a construir software más limpio, flexible, mantenible y escalable.

## Diapositiva 26

S — Single Responsibility Principle (SRP)
Una clase debe tener una sola razón para cambiar.
Cada clase debe hacer una sola cosa y hacerla bien. Si una clase tiene múltiples responsabilidades (por ejemplo, lógica de negocio y acceso a datos), los cambios en una pueden afectar innecesariamente la otra.
Mejor mantenibilidad
Menor acoplamiento
Menos errores al hacer cambios

## Diapositiva 27

SRP (Single Responsibility Principle)

## Diapositiva 28

O — Open/Closed Principle (OCP)
Las clases deben estar abiertas para extensión, pero cerradas para modificación.
Se puede agregar nuevas funcionalidades sin modificar el código existente. Se logra mediante herencia e interfaces.
Menor riesgo de romper código funcionando
Facilita escalar el sistema

## Diapositiva 29

O — Open/Closed Principle (OCP)

## Diapositiva 30

L — Liskov Substitution Principle (LSP)
Una clase hija debe poder sustituir a su clase padre sin que el sistema deje de funcionar correctamente.
Si una subclase rompe el comportamiento esperado de su superclase, no debería heredar de ella.
Evita errores al usar polimorfismo
Garantiza comportamientos previsibles

## Diapositiva 31

L — Liskov Substitution Principle (LSP)
Pingüino no puede volar. No debería heredar de Ave si se espera que todas las aves vuelen.

## Diapositiva 32

I — Interface Segregation Principle (ISP)
Una clase no debe estar obligada a implementar métodos que no usa.
Es mejor tener interfaces pequeñas y específicas que una grande con muchos métodos.
Mayor claridad y cohesión
Menos código innecesario

## Diapositiva 33

I — Interface Segregation Principle (ISP)

## Diapositiva 34

D — Dependency Inversion Principle (DIP)
Las clases de alto nivel no deben depender de clases de bajo nivel. Ambas deben depender de abstracciones.
Tu clase no debe depender de implementaciones concretas, sino de interfaces o abstracciones. Así puedes cambiar una parte del sistema sin romper otras.
Más flexibilidad
Fácil de testear (mockear)
Bajo acoplamiento

## Diapositiva 35

S — Single Responsibility Principle (SRP)

## Diapositiva 36

D — Dependency Inversion Principle (DIP)
Automóvil depende de la abstracción IMotor, no de una clase concreta.
Se puede elegir qué tipo de motor usar fuera de la clase Automóvil. Esto es inyección de dependencias manual.

## Diapositiva 37

ARICA - CHILE

