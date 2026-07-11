---
tags: [proyecto/minegocio, sprint-3, instrucciones, gabriel, backend, frontend, database]
---

# Instrucciones — Gabriel — S3-HU05: CRUD de Proveedores

## Orden de implementación

```
T01 (DB) → T02 (Backend CRUD) → T03 (Frontend página) → T04 (Integrar en productos) → T05 (Tests)
```

Cada tarea depende de la anterior. No saltarse pasos.

---

## T01 — Base de datos

### Archivo: `~/minegocio/minegocio-database/postgres/esquema.sql`

Agregar al final del archivo:

```sql
CREATE TABLE public.proveedores (
    id         SERIAL PRIMARY KEY,
    nombre     VARCHAR(255) NOT NULL,
    rut        VARCHAR(20),
    email      VARCHAR(150),
    telefono   VARCHAR(50),
    direccion  TEXT,
    activo     BOOLEAN DEFAULT true NOT NULL
);
```

Agregar columna a `productos` (después de `marca`):

```sql
ALTER TABLE public.productos ADD COLUMN IF NOT EXISTS id_proveedor INTEGER REFERENCES public.proveedores(id) ON DELETE SET NULL;
```

### Filosofía de `ON DELETE SET NULL`
- Si se elimina un proveedor, los productos que le pertenecían quedan sin proveedor (`NULL`)
- No se bloquea la eliminación ni se eliminan productos en cascada
- La UI debe mostrar "Sin proveedor" cuando `id_proveedor IS NULL`

---

## T02 — Backend CRUD

### Structs en `models/models.go`

Agregar:

```go
type Proveedor struct {
    ID        int    `json:"id"`
    Nombre    string `json:"nombre"`
    Rut       string `json:"rut,omitempty"`
    Email     string `json:"email,omitempty"`
    Telefono  string `json:"telefono,omitempty"`
    Direccion string `json:"direccion,omitempty"`
    Activo    bool   `json:"activo"`
}

type CreateProveedorRequest struct {
    Nombre    string `json:"nombre"`
    Rut       string `json:"rut,omitempty"`
    Email     string `json:"email,omitempty"`
    Telefono  string `json:"telefono,omitempty"`
    Direccion string `json:"direccion,omitempty"`
}
```

### Repository: `repository/proveedor_repository.go`

Seguir el patrón exacto de `repository/producto_repository.go`:

```go
package repository

import (
    "database/sql"
    "backend-dev/models"
)

type ProveedorRepository struct {
    DB *sql.DB
}

func NewProveedorRepository(db *sql.DB) *ProveedorRepository {
    return &ProveedorRepository{DB: db}
}

func (r *ProveedorRepository) GetAll() ([]models.Proveedor, error) {
    rows, err := r.DB.Query(`SELECT id, nombre, COALESCE(rut,''), COALESCE(email,''), COALESCE(telefono,''), COALESCE(direccion,''), activo FROM proveedores WHERE activo = true ORDER BY nombre`)
    if err != nil {
        return nil, err
    }
    defer rows.Close()

    var proveedores []models.Proveedor
    for rows.Next() {
        var p models.Proveedor
        if err := rows.Scan(&p.ID, &p.Nombre, &p.Rut, &p.Email, &p.Telefono, &p.Direccion, &p.Activo); err != nil {
            return nil, err
        }
        proveedores = append(proveedores, p)
    }
    return proveedores, rows.Err()
}

func (r *ProveedorRepository) GetByID(id int) (*models.Proveedor, error) {
    var p models.Proveedor
    err := r.DB.QueryRow(`SELECT id, nombre, COALESCE(rut,''), COALESCE(email,''), COALESCE(telefono,''), COALESCE(direccion,''), activo FROM proveedores WHERE id = $1`, id).
        Scan(&p.ID, &p.Nombre, &p.Rut, &p.Email, &p.Telefono, &p.Direccion, &p.Activo)
    if err != nil {
        return nil, err
    }
    return &p, nil
}

func (r *ProveedorRepository) Create(req *models.CreateProveedorRequest) (*models.Proveedor, error) {
    var p models.Proveedor
    err := r.DB.QueryRow(
        `INSERT INTO proveedores (nombre, rut, email, telefono, direccion) VALUES ($1, $2, $3, $4, $5)
         RETURNING id, nombre, COALESCE(rut,''), COALESCE(email,''), COALESCE(telefono,''), COALESCE(direccion,''), activo`,
        req.Nombre, req.Rut, req.Email, req.Telefono, req.Direccion,
    ).Scan(&p.ID, &p.Nombre, &p.Rut, &p.Email, &p.Telefono, &p.Direccion, &p.Activo)
    if err != nil {
        return nil, err
    }
    return &p, nil
}

func (r *ProveedorRepository) Update(id int, req *models.CreateProveedorRequest) error {
    _, err := r.DB.Exec(
        `UPDATE proveedores SET nombre = $1, rut = $2, email = $3, telefono = $4, direccion = $5 WHERE id = $6`,
        req.Nombre, req.Rut, req.Email, req.Telefono, req.Direccion, id,
    )
    return err
}

func (r *ProveedorRepository) SoftDelete(id int) error {
    _, err := r.DB.Exec(`UPDATE proveedores SET activo = false WHERE id = $1`, id)
    return err
}
```

### Service: `service/proveedor_service.go`

```go
package service

import (
    "backend-dev/models"
)

type ProveedorRepositoryI interface {
    GetAll() ([]models.Proveedor, error)
    GetByID(id int) (*models.Proveedor, error)
    Create(req *models.CreateProveedorRequest) (*models.Proveedor, error)
    Update(id int, req *models.CreateProveedorRequest) error
    SoftDelete(id int) error
}

type ProveedorService struct {
    repo ProveedorRepositoryI
}

func NewProveedorService(repo ProveedorRepositoryI) *ProveedorService {
    return &ProveedorService{repo: repo}
}

func (s *ProveedorService) GetAll() ([]models.Proveedor, error)              { return s.repo.GetAll() }
func (s *ProveedorService) GetByID(id int) (*models.Proveedor, error)        { return s.repo.GetByID(id) }
func (s *ProveedorService) Create(req *models.CreateProveedorRequest) (*models.Proveedor, error) { return s.repo.Create(req) }
func (s *ProveedorService) Update(id int, req *models.CreateProveedorRequest) error { return s.repo.Update(id, req) }
func (s *ProveedorService) SoftDelete(id int) error                          { return s.repo.SoftDelete(id) }
```

**Nota:** La interfaz `ProveedorRepositoryI` está definida en el mismo archivo del service (NO en `service/interfaces.go`) por simplicidad, siguiendo el patrón de VentaService. Si prefieres el patrón de ProductoService, ponla en `interfaces.go`. Cualquiera funciona.

### Handler: `handler/proveedor_handler.go`

Seguir el patrón exacto de `handler/producto_handler.go`:

```go
package handler

import (
    "encoding/json"
    "net/http"
    "strconv"
    "backend-dev/models"
    "github.com/gorilla/mux"
)

type ProveedorServiceI interface {
    GetAll() ([]models.Proveedor, error)
    GetByID(id int) (*models.Proveedor, error)
    Create(req *models.CreateProveedorRequest) (*models.Proveedor, error)
    Update(id int, req *models.CreateProveedorRequest) error
    SoftDelete(id int) error
}

type ProveedorHandler struct {
    proveedorService ProveedorServiceI
}

func NewProveedorHandler(ps ProveedorServiceI) *ProveedorHandler {
    return &ProveedorHandler{proveedorService: ps}
}

func (h *ProveedorHandler) GetProveedores(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "application/json")
    proveedores, err := h.proveedorService.GetAll()
    if err != nil {
        w.WriteHeader(http.StatusInternalServerError)
        json.NewEncoder(w).Encode(map[string]string{"status": "error", "mensaje": "Error al obtener proveedores"})
        return
    }
    json.NewEncoder(w).Encode(proveedores)
}

func (h *ProveedorHandler) GetProveedor(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "application/json")
    vars := mux.Vars(r)
    id, err := strconv.Atoi(vars["id"])
    if err != nil {
        w.WriteHeader(http.StatusBadRequest)
        json.NewEncoder(w).Encode(map[string]string{"status": "error", "mensaje": "ID inválido"})
        return
    }
    proveedor, err := h.proveedorService.GetByID(id)
    if err != nil {
        w.WriteHeader(http.StatusNotFound)
        json.NewEncoder(w).Encode(map[string]string{"status": "error", "mensaje": "Proveedor no encontrado"})
        return
    }
    json.NewEncoder(w).Encode(proveedor)
}

func (h *ProveedorHandler) CreateProveedor(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "application/json")
    var req models.CreateProveedorRequest
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        w.WriteHeader(http.StatusBadRequest)
        json.NewEncoder(w).Encode(map[string]string{"status": "error", "mensaje": "JSON inválido"})
        return
    }
    if req.Nombre == "" {
        w.WriteHeader(http.StatusBadRequest)
        json.NewEncoder(w).Encode(map[string]string{"status": "error", "mensaje": "El nombre es obligatorio"})
        return
    }
    proveedor, err := h.proveedorService.Create(&req)
    if err != nil {
        w.WriteHeader(http.StatusInternalServerError)
        json.NewEncoder(w).Encode(map[string]string{"status": "error", "mensaje": "Error al crear proveedor"})
        return
    }
    w.WriteHeader(http.StatusCreated)
    json.NewEncoder(w).Encode(proveedor)
}

func (h *ProveedorHandler) UpdateProveedor(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "application/json")
    vars := mux.Vars(r)
    id, err := strconv.Atoi(vars["id"])
    if err != nil {
        w.WriteHeader(http.StatusBadRequest)
        json.NewEncoder(w).Encode(map[string]string{"status": "error", "mensaje": "ID inválido"})
        return
    }
    var req models.CreateProveedorRequest
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        w.WriteHeader(http.StatusBadRequest)
        json.NewEncoder(w).Encode(map[string]string{"status": "error", "mensaje": "JSON inválido"})
        return
    }
    if req.Nombre == "" {
        w.WriteHeader(http.StatusBadRequest)
        json.NewEncoder(w).Encode(map[string]string{"status": "error", "mensaje": "El nombre es obligatorio"})
        return
    }
    if err := h.proveedorService.Update(id, &req); err != nil {
        w.WriteHeader(http.StatusInternalServerError)
        json.NewEncoder(w).Encode(map[string]string{"status": "error", "mensaje": "Error al actualizar proveedor"})
        return
    }
    json.NewEncoder(w).Encode(map[string]string{"status": "ok"})
}

func (h *ProveedorHandler) DeleteProveedor(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "application/json")
    vars := mux.Vars(r)
    id, err := strconv.Atoi(vars["id"])
    if err != nil {
        w.WriteHeader(http.StatusBadRequest)
        json.NewEncoder(w).Encode(map[string]string{"status": "error", "mensaje": "ID inválido"})
        return
    }
    if err := h.proveedorService.SoftDelete(id); err != nil {
        w.WriteHeader(http.StatusInternalServerError)
        json.NewEncoder(w).Encode(map[string]string{"status": "error", "mensaje": "Error al eliminar proveedor"})
        return
    }
    json.NewEncoder(w).Encode(map[string]string{"status": "ok"})
}
```

**Nota:** La interfaz `ProveedorServiceI` está en el mismo archivo del handler, no en `handler/interfaces.go`. Si el equipo prefiere centralizarlas, muévela a `interfaces.go`.

### Routes: `routes/routes.go`

Agregar después de las rutas de inventario:

```go
// En SetupRoutes, agregar proveedorHandler como parámetro
func SetupRoutes(
    authHandler      *handler.AuthHandler,
    productoHandler  *handler.ProductoHandler,
    inventarioHandler *handler.InventarioHandler,
    ventaHandler     *handler.VentaHandler,
    proveedorHandler *handler.ProveedorHandler,  // <-- nuevo
) *mux.Router {

// Y dentro de la función, después de las rutas de inventario:
router.Handle("/api/proveedores", middleware.AuthMiddleware(http.HandlerFunc(proveedorHandler.GetProveedores))).Methods("GET")
router.Handle("/api/proveedores/{id:[0-9]+}", middleware.AuthMiddleware(http.HandlerFunc(proveedorHandler.GetProveedor))).Methods("GET")
router.Handle("/api/proveedores", middleware.AuthMiddleware(http.HandlerFunc(proveedorHandler.CreateProveedor))).Methods("POST")
router.Handle("/api/proveedores/{id:[0-9]+}", middleware.AuthMiddleware(http.HandlerFunc(proveedorHandler.UpdateProveedor))).Methods("PUT")
router.Handle("/api/proveedores/{id:[0-9]+}", middleware.AuthMiddleware(http.HandlerFunc(proveedorHandler.DeleteProveedor))).Methods("DELETE")
```

### main.go

Agregar después de las líneas de venta:

```go
// Repositories
proveedorRepo := repository.NewProveedorRepository(db)

// Services
proveedorService := service.NewProveedorService(proveedorRepo)

// Handlers
proveedorHandler := handler.NewProveedorHandler(proveedorService)

// Routes — pasar proveedorHandler
router := routes.SetupRoutes(authHandler, productoHandler, inventarioHandler, ventaHandler, proveedorHandler)
```

---

## T03 — Frontend: Página de proveedores

### Service: `services/proveedorService.js`

```javascript
const API_BASE = ''

function authHeaders() {
  const token = localStorage.getItem('token') || ''
  return { 'Authorization': `Bearer ${token}`, 'Content-Type': 'application/json' }
}

const proveedorService = {
  async getAll() {
    const res = await fetch(`${API_BASE}/api/proveedores`, { headers: authHeaders() })
    if (!res.ok) throw new Error('Error al cargar proveedores')
    return await res.json()
  },

  async getByID(id) {
    const res = await fetch(`${API_BASE}/api/proveedores/${id}`, { headers: authHeaders() })
    if (!res.ok) throw new Error('Error al obtener proveedor')
    return await res.json()
  },

  async crear(data) {
    const res = await fetch(`${API_BASE}/api/proveedores`, {
      method: 'POST', headers: authHeaders(), body: JSON.stringify(data)
    })
    return await res.json()
  },

  async actualizar(id, data) {
    const res = await fetch(`${API_BASE}/api/proveedores/${id}`, {
      method: 'PUT', headers: authHeaders(), body: JSON.stringify(data)
    })
    return await res.json()
  },

  async eliminar(id) {
    const res = await fetch(`${API_BASE}/api/proveedores/${id}`, {
      method: 'DELETE', headers: authHeaders()
    })
    return await res.json()
  }
}

export default proveedorService
```

### Vista: `views/ProveedoresPage.vue`

```vue
<template>
  <div class="page">
    <div class="page-header">
      <h1>Proveedores</h1>
      <button class="btn-primary" @click="abrirFormulario">+ Nuevo proveedor</button>
    </div>

    <div v-if="cargando" class="loading">Cargando...</div>

    <table v-else class="table">
      <thead>
        <tr>
          <th>Nombre</th>
          <th>RUT</th>
          <th>Email</th>
          <th>Teléfono</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="p in proveedores" :key="p.id">
          <td>{{ p.nombre }}</td>
          <td>{{ p.rut || '-' }}</td>
          <td>{{ p.email || '-' }}</td>
          <td>{{ p.telefono || '-' }}</td>
          <td class="acciones">
            <button class="btn-sm" @click="editar(p)">Editar</button>
            <button class="btn-sm btn-danger" @click="eliminar(p.id)">Eliminar</button>
          </td>
        </tr>
        <tr v-if="proveedores.length === 0">
          <td colspan="5" class="empty">No hay proveedores registrados</td>
        </tr>
      </tbody>
    </table>

    <!-- Modal formulario -->
    <div v-if="mostrarFormulario" class="modal-overlay" @click.self="cerrarFormulario">
      <div class="modal">
        <h2>{{ editandoId ? 'Editar proveedor' : 'Nuevo proveedor' }}</h2>
        <form @submit.prevent="guardar">
          <div class="form-group">
            <label>Nombre *</label>
            <input v-model="form.nombre" required />
          </div>
          <div class="form-group">
            <label>RUT</label>
            <input v-model="form.rut" placeholder="12.345.678-9" />
          </div>
          <div class="form-group">
            <label>Email</label>
            <input v-model="form.email" type="email" />
          </div>
          <div class="form-group">
            <label>Teléfono</label>
            <input v-model="form.telefono" />
          </div>
          <div class="form-group">
            <label>Dirección</label>
            <input v-model="form.direccion" />
          </div>
          <p v-if="error" class="error-msg">{{ error }}</p>
          <div class="form-actions">
            <button type="button" class="btn-secondary" @click="cerrarFormulario">Cancelar</button>
            <button type="submit" class="btn-primary" :disabled="cargando">
              {{ cargando ? 'Guardando...' : 'Guardar' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import proveedorService from '../services/proveedorService.js'

export default {
  name: 'ProveedoresPage',
  data() {
    return {
      proveedores: [],
      cargando: true,
      mostrarFormulario: false,
      editandoId: null,
      form: { nombre: '', rut: '', email: '', telefono: '', direccion: '' },
      error: ''
    }
  },
  mounted() { this.cargarProveedores() },
  methods: {
    async cargarProveedores() {
      this.cargando = true
      try { this.proveedores = await proveedorService.getAll() }
      catch (e) { console.error(e) }
      finally { this.cargando = false }
    },
    abrirFormulario() {
      this.editandoId = null
      this.form = { nombre: '', rut: '', email: '', telefono: '', direccion: '' }
      this.error = ''
      this.mostrarFormulario = true
    },
    editar(p) {
      this.editandoId = p.id
      this.form = { nombre: p.nombre, rut: p.rut, email: p.email, telefono: p.telefono, direccion: p.direccion }
      this.mostrarFormulario = true
    },
    cerrarFormulario() { this.mostrarFormulario = false },
    async guardar() {
      this.cargando = true
      this.error = ''
      try {
        if (this.editandoId) {
          await proveedorService.actualizar(this.editandoId, this.form)
        } else {
          await proveedorService.crear(this.form)
        }
        this.mostrarFormulario = false
        await this.cargarProveedores()
      } catch (e) {
        this.error = e.message || 'Error al guardar'
      } finally {
        this.cargando = false
      }
    },
    async eliminar(id) {
      if (!confirm('¿Eliminar este proveedor?')) return
      try {
        await proveedorService.eliminar(id)
        this.proveedores = this.proveedores.filter(p => p.id !== id)
      } catch (e) {
        console.error(e)
      }
    }
  }
}
</script>
```

### Router: `router/index.js`

Agregar import y ruta:

```javascript
import ProveedoresPage from '../views/ProveedoresPage.vue'

// En el array routes:
{ path: '/proveedores', name: 'proveedores', component: ProveedoresPage }
```

### SideBar: `components/SideBar.vue`

Agregar después del grupo Productos (antes de `</nav>`):

```html
<router-link to="/proveedores" class="nav-item" active-class="nav-item--active">
  <i class="ti ti-truck nav-icon"></i>
  <span>Proveedores</span>
</router-link>
```

---

## T04 — Integrar proveedor en FormularioProducto

### Modificar `components/FormularioProducto.vue`

**1. Importar proveedorService al inicio del script (después de productosService):**

```javascript
import proveedorService from '../services/proveedorService.js'
```

**2. Agregar data al `data()`:**

```javascript
proveedores: [],
cargandoProveedores: false,
```

**3. Agregar en `mounted()`, después de `this.$nextTick(...)`:**

```javascript
this.cargarProveedores()
```

**4. Agregar método:**

```javascript
async cargarProveedores() {
  this.cargandoProveedores = true
  try { this.proveedores = await proveedorService.getAll() }
  catch (e) { console.error('Error al cargar proveedores:', e) }
  finally { this.cargandoProveedores = false }
}
```

**5. Agregar campo `id_proveedor` al form data (en `data().form`):**

```javascript
id_proveedor: ''
```

**6. Agregar en el template, después del campo Marca:**

```html
<div class="field">
  <label>Proveedor</label>
  <select v-model="form.id_proveedor">
    <option value="">Sin proveedor</option>
    <option v-for="p in proveedores" :key="p.id" :value="p.id">
      {{ p.nombre }}
    </option>
  </select>
</div>
```

**7. Al editar (en `mounted`, cuando `this.producto` existe):**

```javascript
id_proveedor: this.producto.id_proveedor || ''
```

**8. Al escanear código duplicado (en `procesarEscaneo`, populating form):**

```javascript
id_proveedor: productoExistente.id_proveedor || ''
```

---

## T05 — Pruebas

### Backend

Seguir el patrón de `handler/producto_handler_test.go` para crear:
- `repository/proveedor_repository_test.go`: Test CRUD con DB real (o mock)
- `handler/proveedor_handler_test.go`: Test HTTP handlers

**Lo mínimo que debe probar:**
1. Crear proveedor → devuelve 201 con JSON del proveedor
2. Obtener todos → lista no vacía
3. Obtener por ID → devuelve el proveedor correcto
4. Actualizar → campos modificados correctamente
5. Eliminar (soft) → ya no aparece en GET all

### Frontend
- Abrir página `/proveedores` → ver tabla vacía con mensaje
- Crear proveedor → aparece en la tabla
- Abrir formulario de producto → el `<select>` tiene los proveedores

---

## Resumen de archivos

**Crear:**
- `repository/proveedor_repository.go`
- `service/proveedor_service.go`
- `handler/proveedor_handler.go`
- `services/proveedorService.js`
- `views/ProveedoresPage.vue`
- `repository/proveedor_repository_test.go` (opcional)
- `handler/proveedor_handler_test.go` (opcional)

**Modificar:**
- `models/models.go` — structs Proveedor + CreateProveedorRequest
- `routes/routes.go` — 5 rutas + parámetro en SetupRoutes
- `main.go` — wiring
- `router/index.js` — ruta /proveedores
- `components/SideBar.vue` — link de navegación
- `components/FormularioProducto.vue` — selector + carga de proveedores
- `postgres/esquema.sql` — tabla + FK

## Stack

- **Backend:** Go + gorilla/mux + lib/pq
- **Frontend:** Vue 3 Options API, fetch nativo, localStorage
- **DB:** PostgreSQL 16
