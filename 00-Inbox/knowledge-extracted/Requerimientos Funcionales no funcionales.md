# Requerimientos Funcionales no funcionales

Extraído de `Requerimientos Funcionales no funcionales.pptx`

---

## Diapositiva 1

INGENIERÍA CIVIL EN INFORMÁTICA

## Diapositiva 2

ARICA - CHILE

## Diapositiva 3

Requerimientos
En la Ingeniería de Software, los requerimientos son las condiciones o capacidades que debe tener un sistema para satisfacer las necesidades del usuario o negocio. Se dividen en funcionales y no funcionales.

## Diapositiva 4

Requerimientos Funcionales
Son enunciados acerca de servicios que el sistema debe proveer, de cómo debería reaccionar a entradas particulares y de cómo debería comportarse en situaciones específicas. En algunos casos, los requerimientos funcionales también explican lo que no debe hacer el sistema.

## Diapositiva 5

Requerimientos Funcionales
Una biblioteca quiere un sistema web donde los usuarios puedan buscar libros, reservar ejemplares disponibles y ver el estado de sus préstamos. Los administradores deben poder agregar libros nuevos y gestionar los préstamos.
Requerimientos funcionales
Para usuarios:
El sistema debe permitir que los usuarios busquen libros por título, autor o género.
El sistema debe permitir que los usuarios registrados reserven libros disponibles.
El sistema debe mostrar el estado actual de los préstamos de cada usuario (en curso, vencido, devuelto).
Para administradores:
El sistema debe permitir a los administradores agregar, modificar o eliminar libros del catálogo.
El sistema debe permitir a los administradores registrar la entrega y devolución de los libros prestados.

## Diapositiva 6

Requerimientos No Funcionales
Son limitaciones sobre servicios o funciones que ofrece el sistema.
Los requerimientos no funcionales se suelen aplicar al sistema como un todo, más que a características o a servicios individuales del sistema.
Categorías comunes:
Rendimiento (tiempo de respuesta, concurrencia)
Usabilidad (facilidad de uso)
Seguridad (cifrado, autenticación)
Mantenibilidad (modularidad del código)
Portabilidad (ejecutarse en distintos sistemas operativos)

## Diapositiva 7

Requerimientos No Funcionales
Disponibilidad:
El sistema debe estar disponible las 24 horas del día, los 7 días de la semana.
Rendimiento:
Las búsquedas de libros deben responder en menos de 2 segundos bajo carga normal.
Seguridad:
El acceso a funciones administrativas debe requerir autenticación mediante usuario y contraseña cifrada.
Usabilidad:
La interfaz debe ser accesible desde dispositivos móviles y de escritorio.
Compatibilidad:
El sistema debe ser compatible con los navegadores más utilizados (Chrome, Firefox, Edge y Safari).
Escalabilidad:
El sistema debe poder adaptarse para manejar al menos 1000 usuarios concurrentes sin afectar el rendimiento.

## Diapositiva 8

Actividad
3 grupos
Cada grupo toma un enunciado
Del enunciado escribir los requerimientos funcionales y no funcionales.

## Diapositiva 9

Enunciado 1:rayner
La cafetería “Café Urbano” desea implementar una aplicación web para que sus clientes puedan consultar el menú actualizado, realizar pedidos en línea y pagar con tarjeta o billeteras virtuales. Los usuarios podrán seleccionar si desean recoger el pedido en el local o recibirlo a domicilio. Una vez hecho el pedido, el sistema debe notificar al cliente sobre el estado (en preparación, listo, entregado). Además, los administradores deben poder actualizar el menú y controlar el estado de los pedidos en tiempo real.
Público objetivo: clientes habituales, jóvenes familiarizados con la tecnología.
Objetivo del sistema: agilizar los pedidos y mejorar la experiencia del cliente.
Restricción: debe integrarse con la plataforma de pago que ya usa la cafetería.

## Diapositiva 10

Enunciado 2: darlen  ignacio
La academia “Formar+” quiere una plataforma web educativa para gestionar cursos online. Los docentes deben poder crear cursos, subir materiales en distintos formatos (PDF, video, enlaces), asignar tareas con fechas límite y calificar a los alumnos. Los estudiantes, por su parte, podrán acceder a los cursos en los que están inscriptos, entregar tareas y ver sus calificaciones. El sistema debe generar alertas automáticas por correo electrónico sobre nuevas tareas o calificaciones publicadas. Además, debe permitir a los administradores gestionar usuarios y generar reportes de actividad.
Público objetivo: jóvenes y adultos que toman cursos técnicos.
Requiere seguridad para proteger los datos personales y académicos.
La plataforma debe funcionar en computadoras y dispositivos móviles.

## Diapositiva 11

Enunciado 3: Flavio
Una startup fintech quiere lanzar una aplicación móvil que ayude a los usuarios a llevar un control de sus finanzas personales. La app permitirá registrar ingresos y egresos, clasificarlos por categorías (alimentación, transporte, entretenimiento, etc.) y mostrar reportes gráficos por semana o mes. Los usuarios podrán establecer presupuestos por categoría y recibir alertas si se acercan al límite. La aplicación debe funcionar sin conexión y sincronizar los datos con la nube cuando el dispositivo tenga acceso a Internet. También debe ofrecer autenticación segura mediante PIN o huella digital.
Público objetivo: adultos jóvenes con conocimientos básicos de finanzas.
Requiere una interfaz amigable y visualmente atractiva.
La seguridad de los datos financieros es una prioridad.

## Diapositiva 12

Enunciado 4: Felipe
La clínica “Salud Integral” desea implementar un sistema web para gestionar la reserva de horas médicas. Los pacientes deberán registrarse con sus datos personales y podrán agendar citas seleccionando especialidad, médico y horario disponible. El sistema mostrará la disponibilidad en tiempo real y evitará reservas duplicadas. Los pacientes podrán modificar o cancelar sus citas con al menos 24 horas de anticipación. Además, recibirán recordatorios automáticos por correo electrónico y SMS 24 horas antes de la consulta. Por su parte, los médicos podrán acceder a su agenda diaria, visualizar la información básica del paciente y registrar observaciones de cada atención. El personal administrativo podrá gestionar usuarios y generar reportes de citas realizadas, canceladas y ausencias.
Público objetivo: pacientes, médicos y personal administrativo.
Objetivo del sistema: optimizar la gestión de citas, reducir ausencias y mejorar la atención.
Restricción: debe cumplir con normativas de protección de datos sensibles (salud) y asegurar la confidencialidad de la información.

## Diapositiva 13

Enunciado 5: Felipe
La tienda “TecnoMarket” quiere desarrollar una plataforma de comercio electrónico que permita a los usuarios registrarse, iniciar sesión y explorar un catálogo de productos tecnológicos organizado por categorías. Cada producto deberá mostrar descripción, precio, stock disponible e imágenes. Los usuarios podrán agregar productos a un carrito de compras, modificar cantidades y realizar el pago mediante distintos métodos (tarjetas, transferencias u otros). Una vez realizada la compra, el sistema generará una orden y enviará una confirmación al cliente por correo electrónico. Los administradores podrán gestionar el inventario (agregar, editar o eliminar productos), actualizar precios y acceder a reportes de ventas, productos más vendidos y niveles de stock.
Público objetivo: clientes interesados en tecnología.
Objetivo del sistema: aumentar las ventas, mejorar la experiencia de compra y digitalizar el negocio.
Restricción: el sistema debe ser capaz de soportar picos de alta demanda (por ejemplo, en eventos de descuentos) sin degradar su rendimiento.

## Diapositiva 14

Enunciado 6:Sebastian
La academia “AprendeYa” necesita una plataforma de aprendizaje en línea donde los estudiantes puedan registrarse, inscribirse en cursos y acceder a contenido educativo como videos, documentos y actividades interactivas. Los cursos estarán organizados en módulos, y cada módulo podrá incluir evaluaciones (cuestionarios o tareas). El sistema deberá permitir a los estudiantes rendir evaluaciones y recibir retroalimentación automática o del docente. Los profesores podrán crear cursos, subir materiales, definir evaluaciones y hacer seguimiento del progreso de los estudiantes. Además, los estudiantes podrán visualizar su avance dentro de cada curso.
Público objetivo: estudiantes y docentes.
Objetivo del sistema: facilitar el aprendizaje remoto y mejorar el seguimiento del desempeño académico.
Restricción: la plataforma debe funcionar correctamente en dispositivos móviles y en condiciones de conectividad limitada (por ejemplo, permitiendo carga progresiva de contenidos).

## Diapositiva 15

Enunciado 7:
La empresa de transporte “MoveFast” desea desarrollar una aplicación que permita a los usuarios solicitar viajes dentro de la ciudad. Para ello, los usuarios deberán registrarse, ingresar su ubicación actual y destino, y recibir una estimación del costo y tiempo de llegada. Una vez solicitado el viaje, el sistema asignará automáticamente un conductor disponible cercano. El usuario podrá visualizar en tiempo real la ubicación del vehículo hasta su llegada. Al finalizar el viaje, el usuario podrá calificar al conductor y ver un resumen del recorrido. Los conductores podrán registrarse, aceptar o rechazar solicitudes de viaje, visualizar rutas sugeridas y acceder a su historial de viajes y ganancias.
Público objetivo: usuarios urbanos y conductores.
Objetivo del sistema: optimizar el servicio de transporte, reduciendo tiempos de espera y mejorando la experiencia del usuario.
Restricción: el sistema debe integrarse con servicios de geolocalización en tiempo real y garantizar tiempos de respuesta bajos para la asignación de viajes.

## Diapositiva 16

ARICA - CHILE

