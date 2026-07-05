---
tags: [proyecto/minegocio, rubrica, evaluacion]
---

# Rúbrica de Evaluación — MiNegocio

> Fuente: `rubricaEquipo6.ods`

| Categoría        | Criterio                                  | Logrado | Observado | Notas                                                                              |
| ---------------- | ----------------------------------------- | ------- | --------- | ---------------------------------------------------------------------------------- |
| **Modelo**       | Código organizado, mantenible (por capas) | 5       | 4         | model se usa para identificar las tablas de BD y como DTO                          |
| **BD**           | Calidad scripts de Base de Datos          | 5       | 4         | falta identificar a qué HU pertenece cada migración                                |
| **Frontend**     | Consistencia visual                       | 3       | 1         | galería llama a productos registrados, botón limpiar carro, se compra todo y no... |
| **Frontend**     | Navegación intuitiva                      | 3       | 2         | botón agregar nuevo no dice para qué sirve                                         |
| **Frontend**     | Validaciones visibles                     | 3       | 2         | detalles en el formulario                                                          |
| **Frontend**     | Mensajes de error comprensibles           | 3       | 2         | falla y no entrega aviso al usuario                                                |
| **Backend**      | Comentarios en el código                  | 3       | 2         | existen comentarios pocos y algunos en el model que no aportan                     |
| **Backend**      | Limpieza en el código                     | 3       | 2         | `//import "time"` no está siendo usado por el momento                              |
| **Backend**      | Configuración y seguridad                 | —       | —         | el token debe usarse en todas las llamadas a la API                                |
| **Backend**      | Buenas Prácticas                          | 3       | 2         | mezcla inglés y español en los nombres                                             |
| **Backend**      | Log                                       | —       | —         | sistema de logging para monitorear la ejecución                                    |
| **DevOps**       | Aislamiento de entornos                   | 3       | 2         | la BD usa usuario postgres                                                         |
| **DevOps**       | Readme front                              | 3       | 1         | inconsistencias: dicen que usan nginx y corren prod con dockers                    |
| **DevOps**       | Readme back                               | 3       | 1         | instrucciones para dev, falta el paso a paso de cómo levantar dev y prod           |
| **DevOps**       | Despliegue en dev                         | 3       | 1         | solo front y el docker de dev                                                      |
| **DevOps**       | Despliegue en prod                        | 5       | —         | —                                                                                  |
| **DevOps**       | Pipeline Jenkins Front                    | 5       | 4         | usan usuario icin, no implementaron usuario con menos poderes                      |
| **DevOps**       | Compilación automática Front              | 5       | 3         | usa script en Jenkins y no el Jenkinsfile                                          |
| **DevOps**       | Automatización despliegue Front           | 5       | —         | —                                                                                  |
| **DevOps**       | Pipeline Jenkins Back                     | 5       | 4         | usan usuario icin, no implementaron usuario con menos poderes                      |
| **DevOps**       | Compilación automática Back               | 5       | —         | —                                                                                  |
| **DevOps**       | Automatización despliegue Back            | 5       | —         | —                                                                                  |
| **Presentación** | —                                         | **18**  | **13**    | —                                                                                  |

## Observaciones principales

1. **Seguridad:** El token JWT debe protegerse y usarse en todas las llamadas a la API. Base de datos usa usuario postgres directamente.
2. **Consistencia frontend:** Mezcla de estilos, botones sin descripción, faltan mensajes de error al usuario.
3. **Comentarios:** Comentarios en inglés que no aportan valor, código comentado sin usar.
4. **READMEs:** Inconsistentes entre frontend y backend, faltan instrucciones claras de despliegue.
5. **CI/CD:** Los pipelines usan usuario `icin` con demasiados permisos. Frontend usa script en Jenkins en vez de Jenkinsfile.
6. **Nomenclatura:** Mezcla de inglés y español en nombres de variables/métodos.

## Puntaje total

- **Logrado:** 18 / ? (máximo por determinar)
- **Brecha:** 5 puntos entre logrado y observado en varias categorías
