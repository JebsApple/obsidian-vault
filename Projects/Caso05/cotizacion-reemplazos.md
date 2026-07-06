---
tags: [proyecto, caso05, redes, cotizacion, ieee]
---

# Caso05 — Instrucciones para corregir cotizaciones del informe

## Archivo base a editar
`~/Descargas/estudio /Caso05_Herrera_Soncco_Informe.docx` (2.9 MB, versión completa)

## Paso 1 — Reemplazar canaleta Lexo por Sodimac/Imperial
Ubicar en la tabla de cotización la fila *"Canaleta PVC 40×16mm Lexo"*:

| Campo | Valor original | Nuevo valor |
|-------|---------------|-------------|
| Producto | Canaleta PVC 40×16mm Lexo | DRL Moldura PVC 40×16mm 2m Imperial |
| Proveedor | Lexo Chile | Sodimac |
| Cantidad | 35 | 35 |
| Precio unitario | $1.900 | **$1.490** |
| Total | $66.500 | **$52.150** |

URL captura: `sodimac.cl/sodimac-cl/articulo/147232860/`

## Paso 2 — Reemplazar accesorios Lexo por Comdiel
Ubicar las filas de accesorios (o la línea "Accesorios canaleta ~$17.880") y reemplazar:

| Accesorio Lexo (eliminar) | Reemplazo Comdiel | Código | P.Unit. |
|---------------------------|-------------------|--------|---------|
| Ángulo plano $510 ❌ | Ángulo Plano 40×16mm | 00572A | $580 |
| Curva exterior $460 ❌ | Ángulo Exterior 40×16mm | 00572B | $580 |
| Curva interior $460 ❌ | Ángulo Interior 40×16mm | 00572C | $580 |
| Conexión T $500 ❌ | Derivación T Plana 40×16mm | 00572D | $580 |
| Copla $450 ❌ | Unión 40×16mm | 00572E | $549 |
| Tapa terminal $450 ❌ | Tapa Final 40×16mm | 00572F | $549 |

Si el informe tiene un total global "Accesorios canaleta ~$17.880", **desglosar en filas individuales** con cantidades exactas.

## Paso 3 — Actualizar totales de la tabla de cotización
Buscar la tabla de presupuesto (Tabla IV en v1, Tabla V en v2) y recalcular:

| Concepto | Original | Nuevo | Diferencia |
|----------|----------|-------|------------|
| Canaletas | $66.500 | $52.150 | -$14.350 |
| Accesorios | ~$17.880 | ~$20.508 | +$2.628 |
| Subtotal canalización | ~$84.380 | ~$72.658 | -$11.722 |
| Total materiales | $511.544 | ~$499.822 | **-$15.722** |

Si la tabla usa formato IEEE — numeración romana (Tabla IV, V...), encabezados en negrita, bordes finos.

## Paso 4 — Agregar columna "Precio Unitario"
Si la tabla de cotización no tiene columna de precio unitario, **agregarla entre Cantidad y Total** para cumplir formato IEEE.

Ejemplo de columnas:
`| Producto | Cantidad | Precio Unitario | Total |`

## Paso 5 — Insertar espacios para capturas de pantalla
Agregar como Fig. 3 a Fig. 10 (numeración arábiga secuencial) en Anexo A. Cada captura con este formato exacto:

```
Fig. 3. Captura de pantalla — Cotización [producto] en [proveedor].
Fuente: [proveedor/cl].
```

### Capturas necesarias (9 total):
1. Bobina UTP Cat6 305m — prafer.cl
2. Bobina UTP Cat6 100m — prafer.cl
3. Jack RJ45 keystone + Faceplate + Conector RJ45 — prafer.cl
4. Patch cord Cat6 1m y 2m — prafer.cl
5. **Patch Panel Cat6 24p — transworld.cl** ($122.770 visible)
6. **DRL Moldura PVC 40×16mm — sodimac.cl** ($1.490)
7. **Ángulos (plano/ext/int) — comdiel.cl** ($580 c/u)
8. **Derivación T + Unión — comdiel.cl** ($580 / $549)
9. **Tapa Final 40×16mm — comdiel.cl** ($549)

## Paso 6 — Actualizar VAN/TIR
Si el total de materiales baja ~$15.722:
- **VAN**: mejora (aumenta) ligeramente
- **TIR**: sube marginalmente
- Recalcular con la fórmula del informe y actualizar la tabla correspondiente

## Paso 7 — Verificar sugerencias al final del informe
Revisar la sección de sugerencias del informe "estudio" (`~/Descargas/estudio /`):
- Si ya mencionan Comdiel o Imperial → alinearlas con los reemplazos aplicados
- Si mencionan Lexo → reemplazar la mención por Comdiel

## Formato IEEE — Reglas estrictas

| Elemento | Formato | Ejemplo |
|----------|---------|---------|
| Figuras | `Fig. <N>. <Título>. Fuente: <origen>.` | Fig. 3. Cotización patch panel... Fuente: Transworld. |
| Tablas | `Tabla <N romano>. <Título>. Fuente: <origen>.` | Tabla IV. Presupuesto de materiales. Fuente: Elaboración propia. |
| Citas | `[N]` en texto, lista al final | "...como se ve en la Fig. 3 [1]." |
| Capturas | ~media página, con espacio alrededor | — |

## Resumen de cambios

| # | Cambio | Dónde |
|---|--------|-------|
| 1 | Lexo canaleta $1.900 → Sodimac DRL $1.490 | Tabla cotización |
| 2 | Lexo accesorios → Comdiel acc. ($549-$580) | Tabla cotización |
| 3 | Desglosar "Acc. canaleta $17.880" en filas individuales | Tabla cotización |
| 4 | Agregar columna Precio Unitario | Tabla cotización |
| 5 | Recálculo subtotales | Tabla cotización |
| 6 | Insertar 9 espacios Fig. 3-11 con formato IEEE | Anexo A |
| 7 | Recalcular VAN/TIR | Tabla VAN |
| 8 | Actualizar sugerencias si mencionan Lexo | Sección sugerencias |

## Archivos de respaldo
- `~/Descargas/Caso05_Herrera_Soncco_Informe.docx` — v1
- `~/Descargas/Caso05_Herrera_Soncco_Informe_v2.docx` — v2
- `~/Descargas/estudio /Caso05_Herrera_Soncco_Informe.docx` — el que se edita
- `~/pt/saves/Caso05_Herrera_Soncco.pkt` — Packet Tracer
- Guías IEEE: `~/Documentos/Claude/projects/caso-05/`
