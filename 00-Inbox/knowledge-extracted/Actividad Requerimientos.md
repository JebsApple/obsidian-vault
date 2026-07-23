# Actividad Requerimientos

Extraído de `Actividad Requerimientos.docx`

---

Entrevista N°1
Participantes:
Analista: Marta
Cliente: Sr. Gómez (jefe del área de Atención Ciudadana)
Escena: Primera reunión de levantamiento de requerimientos
Marta: Buenos días, Sr. Gómez. Gracias por recibirnos. La idea de esta reunión es entender mejor cómo trabajan actualmente con los reclamos de los vecinos. ¿Le parece bien?
Sr. Gómez: Sí... está bien.
Marta: Perfecto. ¿Podría contarme, por ejemplo, cómo recibe normalmente un reclamo un vecino?
Sr. Gómez: Por teléfono... o a veces por escrito.
Marta: Entiendo. ¿Y esos reclamos se registran en algún sistema?
Sr. Gómez: Tenemos algo en Excel.
Marta: ¿Todos los reclamos quedan registrados ahí?
Sr. Gómez: Supongo que sí… los más importantes, seguro.
Marta: Bien. ¿Y cómo se hace el seguimiento? ¿Quién los resuelve?
Sr. Gómez: Cada oficina sabe lo que tiene que hacer.
(Silencio incómodo. Marta nota que el cliente está poco participativo y comienza a cambiar la estrategia.)
Marta: Le muestro algo. Este es un ejemplo de un formulario digital donde el vecino puede seleccionar el tipo de reclamo, adjuntar una foto y dejar su ubicación. ¿Le parecería útil algo así?
Sr. Gómez: Mmm... sí, eso podría servir.
Marta: Perfecto. ¿Y le gustaría recibir notificaciones cuando se cierra un reclamo?
Sr. Gómez: Sí, eso también. Que quede registrado todo.
Marta: ¿Preferiría que los vecinos puedan consultar el estado del reclamo por internet?
Sr. Gómez: Claro, sí. Sería ideal.
Marta: Entiendo. ¿Y en cuanto al tiempo de respuesta, manejan algún plazo estándar?
Sr. Gómez: Bueno... depende del reclamo. Pero sí, deberíamos poner plazos.
(Marta toma nota y continúa con preguntas más cerradas.)
Entrevista N°2
Participantes:
Analista: Marta
Cliente: Sra. Rodríguez (directora de Atención Ciudadana)
Escena: Primera reunión de levantamiento de requerimientos
Marta: Buen día, Sra. Rodríguez. ¿Le parece que empecemos por cómo deberían ingresar los reclamos?
Sra. Rodríguez: Claro. Queremos que el vecino lo haga desde el celular, pueda adjuntar fotos, audio, su ubicación, y que el sistema lo redirija automáticamente al área que corresponda. Algo bien simple, tipo “como cuando uno manda un WhatsApp”.
Marta: Bien. Tomo nota. ¿Esa redirección debería considerar tipo de reclamo, ubicación y nivel de urgencia?
Sra. Rodríguez: Sí, idealmente todo eso. Que lo detecte solo.
Marta: Perfecto. Solo como nota, eso implicaría integrar una lógica que combine varias reglas, además del análisis automático de texto o imágenes si quiere que sea completamente automático. Podemos proponer algo inicial basado en tipos predefinidos.
Sra. Rodríguez: Bueno… pero eso no debería ser tan complicado, ¿no? Es solo filtrar y mandar.
Marta: Entiendo la idea, y el resultado sí sería sencillo para el vecino. Pero lograrlo implica desarrollar reglas precisas y, si se quiere automatizar con inteligencia, agregar módulos más complejos. Para la primera versión podemos hacer una asignación basada en categorías, y luego ver si amerita un motor más inteligente.
Sra. Rodríguez: Ah, no lo había pensado. Bueno, sí, avancemos por etapas.
Marta: Genial. Luego mencionó que quiere enviar notificaciones por email o WhatsApp. Para WhatsApp, necesitaríamos una integración con la API oficial de Meta, que lleva configuración, validación, y un pequeño costo por mensaje.
Sra. Rodríguez: Mmm… eso ya cambia un poco. ¿Y se puede empezar solo con email?
Marta: Claro. Email y una notificación dentro del mismo portal serían ideales para empezar. Luego se puede escalar.
Sra. Rodríguez: Perfecto. Entonces definamos bien esas primeras etapas.
Participantes:
Analista: Marta
Cliente: Sr. González (jefe de Proyectos Sociales)
Escena: Segunda reunión de avance del sistema de gestión de reclamos
Marta: Buen día, Sr. Gómez. Según lo que conversamos en la primera reunión, ya diseñamos el formulario con los campos que solicitó: tipo de reclamo, ubicación, foto, y datos opcionales del ciudadano.
Sr. González: Ah, sí, pero estuve pensando… me parece mejor pedir siempre el RUT y que el reclamo no sea anónimo. Así evitamos reclamos falsos.
Marta: Entiendo. Eso es un cambio respecto al diseño inicial. Ya tenemos parte del desarrollo hecho para permitir envíos anónimos. ¿Está seguro de que desea ese cambio?
Sr. González: Sí, pero además pensé que sería bueno permitir reclamos por voz, como notas de audio.
Marta: Bien, podríamos agregarlo. Pero eso implicaría actualizar tanto el front como el backend, además del almacenamiento de audios. Esto alarga el desarrollo y posiblemente el costo. ¿Está dispuesto a ajustar el cronograma?
Sr. González: Bueno… no, la fecha de entrega tiene que ser la misma. Ya se lo prometí al intendente.
Marta: Comprendo. Solo que cada modificación genera trabajo adicional. Para mantener la fecha, deberíamos priorizar: ¿quiere que reemplacemos alguna funcionalidad por esta nueva?
Sr. González: No, no. Quiero todo. Y además… se me ocurrió que estaría bueno que cada vecino pueda ver un mapa con los reclamos cerca de su casa.
Marta: Eso implicaría integrar una visualización geográfica, con filtros por tipo de reclamo y estado. Es factible, pero definitivamente no entra en la primera versión con el tiempo actual.
Sr. González: Bueno… evaluemos eso después. Pero lo del audio sí lo necesito.
Marta: De acuerdo. Le propongo que documentemos formalmente los cambios en los requerimientos y trabajemos sobre una segunda fase. Si no, el proyecto puede retrasarse y salirse del presupuesto original.
Sr. Gómez: Entiendo. Realiza una lista con los cambios y me pasas el nuevo cronograma. Pero tratemos de que no se note mucho que cambió.
Preguntas generales (todos)
¿Qué tipo de cliente identificas?
¿Qué dificultades se presentan en la toma de requerimientos?
¿Cómo enfrenta el analista a la situación?
Pregunta especifica (por caso)
A - ¿Qué preguntas clave podrían desbloquear la conversación?
B - ¿Qué consecuencias tendría decir “sí” a todo sin explicar el esfuerzo involucrado?
C - ¿Qué problemas genera este comportamiento para el proyecto?
