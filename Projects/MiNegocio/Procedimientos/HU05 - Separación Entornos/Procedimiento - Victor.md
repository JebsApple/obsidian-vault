---
tags: [proyecto/minegocio, sprint-3, procedimiento, victor, hu05]
---

# Procedimiento — Victor — HU05: Separación de Entornos Dev/Prod

**Fechas:** 

---


---


---


---

---

## Keywords para la exposición

| Pregunta | Respuesta |
|----------|-----------|
| ¿Por qué dos usuarios DB en vez de uno? | Principio de mínimo privilegio: cada entorno solo ve sus datos. Si un entorno se compromete, el otro no se afecta. |
| ¿Por qué no separar por puerto de DB? | Simplifica administración (un solo PostgreSQL). La separación lógica por DB name + usuario es suficiente. |
| ¿Por qué Docker para DEV si es manual? | El mismo binario (Go) corre en ambos entornos sin compilar dos veces. Solo cambian las variables de entorno. |
| ¿Qué pasa si olvido setear JWT_SECRET? | El servidor no arranca — T02 fuerza panic si no hay JWT_SECRET. |
