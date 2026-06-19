
quiero deshacer los cambios de SLT-frontend, dejar unicamente los cambios de funcionalidades (registro de ventas, tokens de sesiones de usuarios, lectura de codigo de barras para registro de productos y la implementacion de ingreso de imagenes para los productos)

S2-HU02: Registro de ventas; responsable: Ignacio

> **Como** vendedor,

> **quiero** registrar una venta, agregar productos al carrito, y descontar automáticamente el stock,

> **para** procesar ventas rápido y mantener el inventario actualizado.

**Criterios de aceptación:**

- La pantalla de Ventas permite agregar productos al carrito.

- Al confirmar la venta, se crea el registro y el stock se descuenta automáticamente.

- Se calcula el total de la venta automáticamente.

- Se valida que hay stock disponible; si no, avisa.

S2-HU02: [UI] Interfaz de Registro de Ventas (Punto de Venta)

**Alcance:**

- Ruta `/ventas` en Vue Router con componente POS
- Buscador de productos (búsqueda por nombre, código de barras, SKU)
- Carrito dinámico: tabla con columnas `Producto | Cantidad | Precio Unit. | Subtotal | Eliminar`
- Input cantidad con validación live: max = stock disponible
- Cálculo automático de subtotal (cantidad × precio unitario)
- Total global en footer
- Botón "Confirmar Venta" (POST a `/api/ventas`)
- Modal/alerta de éxito: "Venta registrada [#ID](project/ignaciovm-minegocio/t/ID)_TRANSACCION"
- Alerta de error si stock insuficiente o conexión falla
- Botón "Limpiar Carrito" para nueva transacción
- Diseño responsive (desktop + mobile)
- Integración con paleta `#FFFFFF`, `#D60000`, `#2C3E50`, `#95A5A6`, `#ECF0F1` (corporativa)

**Criterios de cierre:**

- Componente Vue renderiza sin errores en navegador (F12 console limpia)
- Búsqueda filtra productos en tiempo real
- Cantidad validada: no permite > stock disponible
- Total se recalcula al cambiar cantidades
- POST a API funciona y retorna ID venta
- Mensaje éxito/error visible al usuario
- Diseño responsive en mobile (viewport 375px)
- npm run build compila sin errores
- Integración con navbar/sidebar existente (menú lateral)

**Referencia técnica:** `/frontend/src/views/VentasPage.vue`, `/frontend/src/components/CarritoCompras.vue`, `/frontend/src/services/ventasService.js`

S2-HU02: [BD] Tabla de Ventas y actualización automática de stock

**Alcance:**

- Crear tabla `ventas` con campos: `id (PK), producto_id (FK), cantidad, precio_unitario, total, fecha, usuario_id (FK), created_at`
- Crear tabla `detalles_venta` si múltiples productos por transacción (opcional para esta sprint)
- Foreign Keys: `producto_id` → `productos(id)`, `usuario_id` → `usuarios(id)` con ON DELETE RESTRICT
- Crear trigger PostgreSQL: `BEFORE/AFTER INSERT ON ventas` → actualiza `productos.stock -= cantidad`
- Índices en: `producto_id, usuario_id, fecha` para queries rápidas
- Constraint: `cantidad > 0`, `total > 0`
- Script SQL con CREATE TABLE + trigger listo para ejecutar en BD dev/prod

**Criterios de cierre:**

- Tabla ventas creada y accesible desde Go (SELECT funciona)
- FK válidas sin errores de constraint
- Trigger ejecuta sin errores en INSERT
- Stock se descuenta automáticamente al insertar venta
- Índices creados (verificar con `\d ventas` en psql)
- Script SQL limpio y documentado
- Probado: insertar venta → verificar stock en tabla productos disminuye

**Referencia técnica:** `/backend/migrations/002_create_ventas_table.sql`, `/backend/migrations/003_trigger_descuento_stock.sql`

S2-HU02:[API] Endpoints CRUD de Registro de Ventas

**Alcance:**

- Endpoint `POST /api/ventas` — crear venta con validación de stock disponible
- Endpoint `GET /api/ventas` — listar ventas con filtros opcionales (fecha, usuario_id, producto_id)
- Endpoint `GET /api/ventas/:id` — obtener detalles completos de una venta específica
- Validación: cantidad solicitada ≤ stock disponible (error 400 si insuficiente)
- Transacción atómica: insertar venta + descontar stock como operación única (ACID)
- Response JSON: `{id, producto_id, cantidad, precio_unitario, total, fecha, usuario_id, status}`
- Manejo de errores: 401 sin auth, 400 datos inválidos, 500 error BD
- Logging: registrar cada venta creada en stdout/logs del backend

**Criterios de cierre:**

- Endpoints responden con HTTP correcto (201 POST, 200 GET, 400 validación, 401 auth)
- Venta creada descuenta automáticamente stock en tabla productos
- No permite venta si stock < cantidad solicitada
- Respuestas JSON validadas con estructura esperada
- Tests Postman/curl funcionan correctamente
- Documentación de API en comentarios Go
- Sin hardcoding de puertos/credenciales (usar variables de entorno)

**Referencia técnica:** `/backend/handlers/ventas.go`, `/backend/models/venta.go`

--escrito por victor: registro de ventas: 
el usuario debe poder armar un carrito de compra, sumar productos al carrito desde los inventarios, calcular el valor de la compra y poder descontar de los inventarios correspondientes dichos productos al realizar la compra, además de almacenar un ticket de venta en la base de datos, que registe los productos, fecha y usuario que realizo la venta, con sus correspondientes IDs

tokens de sesion de usuario; Responsable: Gabriel

> **Como** administrador,    
> **quiero** que las sesiones de usuario expiren automáticamente tras un tiempo configurable,    
> **para** mejorar la seguridad del sistema y evitar que sesiones activas queden abiertas indefinidamente.

Criterios de aceptación:

- Al hacer login, se genera un token JWT con tiempo de expiración.
- El administrador puede configurar el tiempo (en minutos) desde una pantalla de Configuración.
- Las rutas protegidas validan el token; si expiró, devuelven 401.
- El frontend detecta la expiración y redirige al login.

S2-HU03:  [API] Implementar JWT (JSON Web Tokens) con expiración

Alcance:

Reemplazar autenticación actual (si es sesiones) por JWT    
Endpoint POST /api/auth/login — retorna JWT con claims (user_id, rol, exp)    
Endpoint POST /api/auth/refresh — renova JWT antes de expiración    
Endpoint POST /api/auth/logout — invalida token (opcional: blacklist)    
JWT incluye: {user_id, nombre, rol, exp, iat, iss}    
Expiración configurable en .env (ej: JWT_EXPIRATION=3600 segundos = 1 hora)    
Refresh token con expiración más larga (ej: 7 días)    
Validación de JWT en todos los endpoints protegidos    
Manejo de errores: 401 token inválido/expirado, 403 sin permisos

Criterios de cierre:

Login retorna JWT válido con claims correctos    
JWT se almacena en localStorage/sessionStorage (frontend)    
Endpoints protegidos validan JWT antes de procesar    
Expiración se respeta (token inválido después del tiempo)    
Refresh token renueva antes de expiración    
Tests Postman con tokens válidos/expirados/inválidos funcionan    
Documentación de estructura JWT en comentarios    
Sin hardcoding de secret key (usar .env)

Referencia técnica: /backend/middleware/auth.go, /backend/handlers/auth.go, /backend/config/jwt.go

S2-HU03: Tabla de sesiones/tokens

Alcance:

Crear tabla sesiones para registrar tokens activos: id, usuario_id (FK), token_hash, fecha_creacion, fecha_expiracion, estado (activo/revocado)    
Alternativa: usar tabla refresh_tokens para almacenar refresh tokens    
Index en usuario_id, fecha_expiracion para limpiar expirados    
Script de limpieza: eliminar sesiones/tokens expirados (cron job o trigger)

Criterios de cierre:

Tabla creada (si se decide implementar)    
FK válida a tabla usuarios    
Índices optimizan búsquedas    
Migraciones listas    
Script de limpieza documentado

Referencia técnica: /backend/migrations/007_create_sesiones_table.sql

S2-HU03: Almacenamiento y envío de JWT en headers

Alcance:

Guardar JWT retornado por login en localStorage (o sessionStorage si requiere cierre browser)    
Crear interceptor Axios: agrega Authorization: Bearer {token} a todos los requests    
Validar expiration antes de request (comparar exp con fecha actual)    
Si token expirado, llamar automáticamente a /api/auth/refresh    
Si refresh falla, redirigir a login    
Eliminar token al logout    
Handle de error 401: redirigir a login, limpiar token

Criterios de cierre:

Token se guarda en localStorage después de login    
Todos los requests incluyen header Authorization: Bearer ...    
Token expirado dispara refresh automático    
Refresh fallido redirige a login    
Logout elimina token    
Console sin errores de auth    
npm run build sin errores

Referencia técnica: /frontend/src/plugins/axios.js, /frontend/src/services/authService.js, /frontend/src/middleware/authGuard.js

S2-HU01: Lector de codigo de barras; Responsable: Nicolás

> **Como** trabajador del negocio,

> **quiero** escanear el código de barras de un producto al registrarlo,

> **para** ingresar el código sin escribirlo manualmente y evitar duplicados.

**Criterios de aceptación:**

- El usuario escanea (o escribe) un código y pulsa Enter en el campo "Código de barras".

- Si el código ya existe, el sistema avisa y ofrece editar el producto existente.

- Funciona sin instalar drivers; el lector actúa como teclado.

- Funciona también escribiendo el código a mano + Enter (para probar sin lector).

S2-HU01:  Integración de input de código de barras en formulario de producto

Alcance:    
Input de código de barras en componente FormularioProducto.vue con foco automático    
Captura de escaneo: lector emula teclado (keypress event)    
Validación en tiempo real: código no vacío, formato válido (números, sin espacios extras)    
Búsqueda automática: si código existe en BD, pre-rellena datos del producto    
Si es nuevo, habilita edición manual de nombre, precio, etc.    
Mensaje visual: "Código válido ✓" o "Código duplicado - editar existente"    
Integración con componente Navbar/Sidebar (acceso rápido al formulario)    
Diseño responsive y usable en tablet (pantalla táctil)    
Criterios de cierre:    
Input recibe datos de scanner sin errores (console limpia)    
Código se valida sin caracteres basura    
Búsqueda por código llama a API y retorna producto correcto    
Pre-relleno de datos funciona correctamente    
Mensaje visual claro al usuario    
npm run build compila sin errores    
Probado con scanner USB real (o simulación en Postman)    
Referencia técnica: /frontend/src/components/FormularioProducto.vue, /frontend/src/services/productosService.js

S2-HU01:[API] Endpoint de búsqueda de producto por código de barras

    
Alcance:    
Endpoint GET /api/productos/codigo/:codigo — busca producto por código de barras    
Response: {id, nombre, precio_compra, precio_venta, stock, imagen_url, codigo}    
Si código no existe, retorna 404 con mensaje "Producto no encontrado"    
Validación: código no vacío, formato válido (números)    
Sin autenticación requerida (endpoint público para rapidez)    
Logging de búsquedas (para auditoría)    
Criterios de cierre:    
Endpoint retorna HTTP correcto (200 si existe, 404 si no)    
Response JSON válida con estructura esperada    
Búsqueda es case-insensitive si es necesario    
Tests Postman funcionan    
Sin errores SQL inyección (prepared statements)    
Documentación en comentarios Go    
Referencia técnica: /backend/handlers/productos.go (función GetProductoPorCodigo)

S2-HU01: [BD] Índice y constraint en campo código de barras

Alcance:

Agregar índice UNIQUE en columna codigo de tabla productos    
Constraint: codigo NOT NULL, UNIQUE    
Migraciones SQL listas para ejecutar    
Script de rollback si es necesario

Criterios de cierre:

Índice creado sin errores    
No permite insertar código duplicado (constraint respeta)    
Búsquedas por código son rápidas (query plan optimizado)    
Migraciones versionadas en /backend/migrations/

Referencia técnica: /backend/migrations/004_add_codigo_index_productos.sql

S2-HU04 — Imágenes en Productos y Búsqueda Mejorada; Responsable: Victor

> **Como** administrador,   
> **quiero** cargar imágenes al registrar productos, editar productos y buscar por nombre o código,   
> **para** tener un catálogo visual y encontrar productos rápidamente.

**Criterios de aceptación:**

- El formulario de productos permite capturar/subir una imagen.
- Las imágenes se guardan y se muestran en la tabla de productos.
- La búsqueda filtra por nombre y código de barras en tiempo real.
- Las interfaces de productos y búsqueda son claras y usables.

S2-HU04: Frontend; Carga de imagenes

[UI] Componente de carga de imagen en formulario de producto   
Alcance:

Input type file en FormularioProducto.vue   
Preview de imagen antes de guardar (draggable + click upload)   
Validación: tamaño < 5MB, formato válido   
Mensaje de error si no cumple   
Botón de carga: POST a /api/productos/:id/imagen al guardar producto   
Reemplazar imagen si ya existe   
Mostrar imagen actual si edita producto existente

Criterios de cierre:

Input funciona en desktop y mobile   
Preview muestra imagen seleccionada   
Validación rechaza archivos grandes/inválidos   
Upload enviado junto con datos producto   
Imagen visible después de guardar   
Manejo de error si upload falla   
npm run build sin errores

Referencia técnica: /frontend/src/components/FormularioProducto.vue, /frontend/src/services/productosService.js

S2-HU04: [API] Endpoint de carga y gestión de imágenes de productos

Alcance:

Endpoint POST /api/productos/:id/imagen — cargar imagen (multipart/form-data)    
Soporta formatos: JPG, PNG, WebP (max 5MB)    
Guardar imagen en servidor (carpeta /uploads/productos/) con nombre único (UUID)    
Retornar URL relativa: /uploads/productos/{uuid}.jpg    
Endpoint DELETE /api/productos/:id/imagen — eliminar imagen anterior    
Validación: solo autenticado, usuario owner o admin    
Logging: registrar cargas/eliminaciones

Criterios de cierre:

POST retorna 201 con URL imagen en response    
Imagen se guarda en disco sin corrupción    
Validación de tamaño/formato funciona (rechaza > 5MB, formato inválido)    
DELETE elimina archivo físico    
URL retornada accesible desde navegador    
Tests Postman con multipart funcionan    
Sin errores de permiso en carpeta /uploads/

Referencia técnica: /backend/handlers/productos.go (funciones UploadProductoImagen, DeleteProductoImagen), /backend/middleware/upload.go

S2-HU04: [Frontend] Galería de productos con imágenes y búsqueda mejorada

Alcance:

Página /productos-registrados con galería tipo tarjetas (cards)    
Cada tarjeta: imagen (thumbnail), nombre, precio, stock, botones (editar, eliminar)    
Imagen placeholder si no existe    
Buscador: filtra por nombre, código de barras, categoría (live search)    
Filtros adicionales: rango precio, estado stock (sin stock, bajo stock, normal)    
Paginación: 12 productos por página    
Diseño responsive grid (desktop: 4 cols, tablet: 2, mobile: 1)    
Integración con paleta corporativa

Criterios de cierre:

Galería renderiza sin errores    
Imágenes cargan correctamente   
Las imagenes se visualizan sin "zoom" si no que se prioriza que la imagen se vea por completo
Búsqueda filtra en tiempo real    
Filtros funcionan (precio, stock)    
Paginación navega sin recargar    
Responsive en 375px, 768px, 1920px    
npm run build sin errores    
Console sin warnings

Referencia técnica: /frontend/src/views/ProductosRegistrados.vue, /frontend/src/components/GaleriaProductos.vue, /frontend/src/components/BuscadorProductos.vue

Integración de búsqueda avanzada + API backend

Alcance:

Endpoint GET /api/productos/buscar?q=...&filtros=... — búsqueda full-text   
Soporta parámetros: q (nombre/código), precio_min, precio_max, stock_status (sin_stock/bajo/normal)   
Retorna lista de productos con imagen_url   
Ordenamiento por: relevancia, precio, stock   
Paginación: limit, offset

Criterios de cierre:

Búsqueda retorna resultados correctos   
Filtros aplican sin errores   
Paginación funciona   
Response incluye imagen_url válida   
Performance aceptable (< 1 segundo queries complejas)

Referencia técnica: /backend/handlers/productos.go (función BuscarProductos), /backend/services/productoService.go



Quien te está dando las ordenes es victor, para las tareas en general busco que funcionen para poder pasarlas a entorno de producción y poder presentarlas al cliente(profesor), pero en especifico son mis tareas las que tienes permiso de modificar y las de mis compañeros quiero que las uses de forma intacta, si hay un error envia el reporte en gitea, si el error es pequeño solucionalo y commitealo. 

