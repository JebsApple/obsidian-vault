# Diagrama de clases

Extraído de `Diagrama de clases.pptx`

---

## Diapositiva 1

INGENIERÍA CIVIL EN INFORMÁTICA

## Diapositiva 2

ARICA - CHILE

## Diapositiva 3

Diagrama de clases
Un diagrama de clases en UML es una representación gráfica que se utiliza para visualizar la estructura de un sistema.
Cada clase se representa con un rectángulo dividido en tres partes: el nombre de la clase, los atributos y los métodos.

## Diapositiva 4

Elementos del diagrama de clase
Clase : Representada como un rectángulo dividido en tres secciones:
Nombre de la clase
Atributos
Métodos

## Diapositiva 5

Elementos del diagrama de clase
Modificadores
Símbolos utilizados para indicar modificadores de acceso para miembros de la clase:
+: Público
-: Privado
#: Protegido
/: Derivado (valor calculado o derivado)
~: Paquete (acceso predeterminado o a nivel de paquete)

## Diapositiva 6

Elementos del diagrama de clase
La relación de asociación simple
Una asociación entre dos o más clases que están conectadas por una línea sólida simple.

## Diapositiva 7

Elementos del diagrama de clase
La relación de asociación simple
La clase "Library" puede considerarse la clase fuente porque contiene una referencia a varias instancias de la clase "Book". Esta clase se consideraría la clase destino porque pertenece a una biblioteca específica.

## Diapositiva 8

Elementos del diagrama de clase
La relación de asociación dirigida
Consideremos un escenario donde una clase "Profesor" está asociada a una clase "Curso" en un sistema universitario. La flecha de asociación dirigida puede apuntar de la clase "Profesor" a la clase "Curso", lo que indica que un profesor está asociado con un curso específico o lo imparte.

## Diapositiva 9

Elementos del diagrama de clase
La relación de Herencia (o generalización)
Es un tipo de relación padre-hijo en la que un nivel tiene al menos una subclase. El hijo está conectado al padre a través de una línea sólida con una punta de flecha vacía.

## Diapositiva 10

Elementos del diagrama de clase
La relación de Herencia (o generalización)
En el ejemplo de las cuentas bancarias, podemos utilizar la generalización para representar diferentes tipos de cuentas, como cuentas corrientes, cuentas de ahorro y cuentas de crédito.

## Diapositiva 11

Elementos del diagrama de clase
La relación de agregación
Tipo de relación en la que una clase forma parte de la otra. Algunas de las instancias que aparecen en una clase y están marcadas con * pueden asociarse a la otra clase. Una línea sólida une las dos clases con una punta de flecha en forma de diamante vacía conectada a la clase de compuesto.
La clase 2 es parte de la clase 1.
Muchas instancias (indicadas por *) de Clase2 se pueden asociar con Clase1.

## Diapositiva 12

Elementos del diagrama de clase
La relación de agregación
La empresa puede considerarse como el todo, mientras que los empleados son las partes. Los empleados pertenecen a la empresa, y esta puede tener varios empleados. Sin embargo, si la empresa deja de existir, los empleados pueden seguir existiendo de forma independiente.

## Diapositiva 13

Elementos del diagrama de clase
La relación de composición
En este caso, las dos clases no pueden existir por sí solas y están conectadas por una línea que apunta a la clase compuesta con una punta de flecha en forma de diamante rellena.
Los objetos de la clase 2 viven y mueren con la clase 1.
La clase 2 no puede sostenerse por sí sola.

## Diapositiva 14

Elementos del diagrama de clase
La relación de composición
Imagina una aplicación de agenda digital. La agenda es el todo, y cada entrada de contacto es una parte. Cada entrada de contacto es propiedad exclusiva de la agenda y está gestionada por ella. Si la agenda se elimina o destruye, también se eliminan todas las entradas asociadas.

## Diapositiva 15

Elementos del diagrama de clase
La relación de dependencia
Una línea discontinua con una punta de flecha abierta une dos clases.

## Diapositiva 16

Elementos del diagrama de clase
La relación de dependencia
Clase Persona: Representa a una persona que lee un libro. La clase Persona depende de la clase Libro para acceder y leer el contenido.
Clase Libro: Representa un libro que contiene contenido para ser leído por una persona. La clase Libro es independiente y puede existir sin la clase Persona

## Diapositiva 17

Elementos del diagrama de clase
Multiplicidad
La multiplicidad representa el número de instancias. Estas instancias están asociadas una clase con otra clase. La multiplicidad se muestra como un rango (p. ej., 0..1, 1..*, etc.). Lo notará cerca del final de la línea de asociación.
Exactamente uno: 1
Cero o uno: 0..1
Muchos: 0..* o *
Uno o más: 1..*
Número exacto, por ejemplo, 3, 4 o 6
O una relación compleja (por ejemplo, 0..1, 3..4, 6.*) significaría cualquier número de objetos distinto de 2 o 5.

## Diapositiva 18

Elementos del diagrama de clase
Multiplicidad
Requisito: Un estudiante puede tomar muchos cursos y muchos estudiantes pueden estar inscritos en un curso.

## Diapositiva 19

Uso del diagrama de clase
Los diagramas de clases muestran la estructura estática de un sistema de software, mostrando clases, atributos, métodos y relaciones.
Ayudan a visualizar y organizar los componentes del sistema, sirviendo como modelo para la implementación.
Fomentan las discusiones sobre el diseño del sistema, promoviendo una comprensión compartida entre los miembros del equipo.

## Diapositiva 20

Enunciado
Una biblioteca pública quiere desarrollar un sistema para gestionar los préstamos de libros. Cada libro tiene un título, un ISBN, un autor y una cantidad de ejemplares. Cada usuario de la biblioteca puede tomar prestado hasta 5 libros a la vez. El sistema debe registrar los préstamos, con la fecha de inicio, la fecha de devolución esperada y la fecha real de devolución (si ya fue devuelto).

## Diapositiva 21

Enunciado
Requerimientos Funcionales
Registrar nuevos usuarios y libros.
Permitir a los usuarios tomar libros en préstamo si tienen menos de 5 libros activos.
Registrar la devolución de un libro.
Consultar el estado de los préstamos (vigente, vencido, devuelto).

## Diapositiva 22

Enunciado
Requerimientos No Funcionales
Interfaz amigable
Base de datos relacional

## Diapositiva 23

ARICA - CHILE

