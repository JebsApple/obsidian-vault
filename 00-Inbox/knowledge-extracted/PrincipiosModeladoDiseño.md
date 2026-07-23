# PrincipiosModeladoDiseño

Extraído de `PrincipiosModeladoDiseño.pptx`

---

## Diapositiva 1

INGENIERÍA CIVIL EN INFORMÁTICA

## Diapositiva 2

ARICA - CHILE

## Diapositiva 3

Principios del modelado de diseño
Son 10 principios que forman una guía esencial para crear software de calidad, tanto en entornos tradicionales como ágiles.

## Diapositiva 4

1. El diseño debe poder rastrearse hasta el modelo de requerimientos
Cada clase, módulo o componente que se diseña debe estar relacionado con un requerimiento funcional o no funcional previamente identificado. Esto permite asegurar que el sistema cumple con lo que el cliente necesita.
Ejemplo:
Si el requerimiento dice: "El sistema debe permitir registrar nuevos usuarios", entonces debe existir una clase Usuario, una interfaz de registro y un servicio que lo procese. No se deben crear componentes que no respondan a un requerimiento.

## Diapositiva 5

2. Considerar siempre la arquitectura del sistema que se va a crear
El diseño debe estar alineado con la arquitectura general (por capas, microservicios, cliente-servidor, etc.). Esto evita contradicciones y facilita la integración entre los componentes.
Ejemplo:
Si la arquitectura definida es por capas (presentación, lógica, datos), el diseño debe incluir una clase UsuarioController (capa presentación), UsuarioService (lógica de negocio) y UsuarioDao (acceso a datos).

## Diapositiva 6

3. El diseño de los datos es tan importante como el diseño de las funciones de procesamiento
Diseñar bien las estructuras de datos (clases, atributos, relaciones) evita errores futuros. No basta con saber qué hace el sistema, también hay que entender cómo organiza y almacena la información.
Ejemplo:
En una aplicación de ventas, si no se modelan correctamente las relaciones entre Cliente, Factura y Producto, las funciones como "calcular total" o "listar facturas" fallarán o serán difíciles de implementar.

## Diapositiva 7

4. Las interfaces (internas y externas) deben diseñarse con cuidado
Una interfaz define cómo interactúan dos partes del sistema. Puede ser entre módulos del código (interfaces internas) o entre el sistema y otros sistemas/usuarios (interfaces externas).
Ejemplo:
Diseñar una API REST para que una app móvil consulte productos: GET/productos. Si esta interfaz no está clara o cambia mucho, puede romper el funcionamiento de la app.

## Diapositiva 8

4. Las interfaces (internas y externas) deben diseñarse con cuidado
{
"id": 1,
"nombre": "Teclado",
"precio": 49.99
}
Se cambia por:
{
"codigo": 1,
"titulo": "Teclado",
"costo": 49.99
}
La app deja de funcionar porque no reconoce los nuevos nombres.

## Diapositiva 9

4. Las interfaces (internas y externas) deben diseñarse con cuidado
Versionado de la API
GET /api/v1/productos
GET /api/v2/productos
Documentar y validar
Usar herramientas como Swagger/OpenAPI para definir y documentar claramente la estructura del JSON.
Si se necesita modificar el JSON, debe hacerse con versionado, documentación y cuidando la compatibilidad hacia atrás.

## Diapositiva 10

5. El diseño de la interfaz de usuario debe ajustarse a las necesidades del usuario final, con énfasis en la facilidad de uso
La experiencia del usuario (UX) debe ser prioridad. No solo debe verse “bonita”, sino ser intuitiva, rápida y accesible.
Ejemplo:
En una app de control de asistencia docente, un botón grande y claro que diga “Registrar entrada” es mejor que varios menús ocultos para hacer lo mismo.

## Diapositiva 11

6. El diseño a nivel de componente debe ser funcionalmente independiente
Cada componente (clase o módulo) debe tener una responsabilidad clara. No mezclar funciones distintas en un mismo lugar (evitar “código espagueti”).
Ejemplo:
Una clase CorreoService solo debería encargarse de enviar correos, no de validar contraseñas ni conectarse a la base de datos.

## Diapositiva 12

7. Los componentes deben estar ligeramente acoplados entre sí y con el entorno externo
Los componentes deben depender lo menos posible unos de otros. Así, se pueden modificar, probar o reemplazar sin afectar al resto del sistema.
Ejemplo:
Si UsuarioService depende de una interfaz Notificador, y no directamente de CorreoService, podemos cambiar a WhatsAppNotificador sin tocar el servicio de usuario.

## Diapositiva 13

7. Los componentes deben estar ligeramente acoplados entre sí y con el entorno externo
class UsuarioService {
private CorreoService correoService = new CorreoService();
public void registrarUsuario(Usuario u) {
// lógica de registro...
correoService.enviarCorreo(u.getEmail(), "Bienvenido");
}
}

## Diapositiva 14

7. Los componentes deben estar ligeramente acoplados entre sí y con el entorno externo
interface Notificador {
void notificar(String destino, String mensaje);
}
class CorreoService implements Notificador {
public void notificar(String email, String mensaje) {
// lógica para enviar email
}
}
class WhatsAppNotificador implements Notificador {
public void notificar(String telefono, String mensaje) {
// lógica para enviar por WhatsApp
}
}

## Diapositiva 15

7. Los componentes deben estar ligeramente acoplados entre sí y con el entorno externo
class UsuarioService {
private Notificador notificador;
// Se inyecta la implementación deseada
public UsuarioService(Notificador notificador) {
this.notificador = notificador;
}
public void registrarUsuario(Usuario u) {
// lógica de registro...
notificador.notificar(u.getDestino(), "Bienvenido");
}
}
Notificador notificador = new CorreoService(); // o new WhatsAppNotificador();
UsuarioService servicio = new UsuarioService(notificador);

## Diapositiva 16

8. Las representaciones del diseño (modelos) deben entenderse fácilmente
Diagramas (como UML), esquemas y documentación deben ser simples, claros y comprensibles, incluso por personas que no desarrollan.
Ejemplo:
Un diagrama de clases con nombres claros, pocas relaciones cruzadas y colores para distinguir capas ayuda a entender el sistema rápidamente.

## Diapositiva 17

9. El diseño debe desarrollarse de manera iterativa
No se necesita tener el diseño completo desde el inicio. Se puede ir mejorando y detallando con el tiempo, conforme se comprenden mejor los requerimientos.
Ejemplo:
Primero se diseña un módulo básico de “registro de usuarios”. Luego, en otra iteración, se le agrega validación, roles o conexión con redes sociales.

## Diapositiva 18

10. La creación de un modelo de diseño no impide una metodología ágil
Tener diagramas, modelos y documentación ligeros no contradice trabajar con Scrum o XP. El diseño ayuda a mantener el sistema y adaptarlo con el tiempo.
Ejemplo:
En Scrum, al inicio del sprint se puede hacer un modelo de clases básico para la funcionalidad que se va a desarrollar. No hace falta modelar todo el sistema desde el principio.

## Diapositiva 19

ARICA - CHILE

