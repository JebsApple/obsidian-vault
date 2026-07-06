---
tags: [proyecto, caso05, redes, cotizacion, ieee]
---

# Caso05 — Instrucciones para corregir cotizaciones del informe

## Archivo base a editar
`~/Descargas/estudio /Caso05_Herrera_Soncco_Informe.docx` (2.9 MB, versión completa)

## Paso 0 — Entender qué cambia

| Producto | ANTES (Lexo) | DESPUÉS | Diferencia x unidad |
|----------|-------------|---------|-------------------|
| Canaleta PVC 40×16mm 2m | $1.900 (agotado) | $1.490 Sodimac | -$410 |
| Ángulo Plano 40×16mm | $510 (agotado) | $580 Comdiel | +$70 |
| Ángulo Exterior 40×16mm | $460 (agotado) | $580 Comdiel | +$120 |
| Ángulo Interior 40×16mm | $460 (agotado) | $580 Comdiel | +$120 |
| Conexión/Derivación T | $500 (agotado) | $580 Comdiel | +$80 |
| Copla/Unión | $450 (agotado) | $549 Comdiel | +$99 |
| Tapa Terminal/Final | $450 (agotado) | $549 Comdiel | +$99 |

## Paso 1 — Reemplazar canaleta Lexo por Sodimac/Imperial

Buscar en la tabla de cotización la fila de "Canaleta PVC 40×16mm Lexo" y copiar exactamente:

| Producto | Cantidad | Precio Unitario | Total |
|----------|----------|----------------|-------|
| DRL Moldura PVC 40×16mm 2m (Imperial) — Sodimac | 35 | $1.490 | $52.150 |

Cálculo: 35 × $1.490 = $52.150

URL captura: `sodimac.cl/sodimac-cl/articulo/147232860/`

## Paso 2 — Reemplazar accesorios Lexo por Comdiel

Si el informe tiene una línea genérica "Accesorios canaleta ~$17.880", **borrarla** y reemplazar con este desglose (usar cantidades del informe original si están especificadas; si no, estimar basado en 35 tiras de 2m):

DESGLOSE COMPLETO:

| Producto | Cant. | P.Unit. | Total | Código |
|----------|-------|---------|-------|--------|
| Ángulo Plano 40×16mm — Comdiel | 4 | $580 | $2.320 | 00572A |
| Ángulo Exterior 40×16mm — Comdiel | 4 | $580 | $2.320 | 00572B |
| Ángulo Interior 40×16mm — Comdiel | 4 | $580 | $2.320 | 00572C |
| Derivación T Plana 40×16mm — Comdiel | 6 | $580 | $3.480 | 00572D |
| Unión 40×16mm — Comdiel | 10 | $549 | $5.490 | 00572E |
| Tapa Final 40×16mm — Comdiel | 4 | $549 | $2.196 | 00572F |
| **TOTAL ACCESORIOS** | **32** | | **$18.126** | |

Si el informe usa otras cantidades, respetar las originales pero aplicar los nuevos precios.

## Paso 3 — Tabla de cotización COMPLETA (para reemplazar toda la tabla)

Tabla definitiva con precios unitarios y totales calculados, en formato IEEE:

---
**Tabla [N]. Presupuesto de materiales para cableado estructurado. Fuente: Elaboración propia.**

| Ítem | Producto | Cantidad | Precio Unitario | Total |
|------|----------|----------|----------------|-------|
| 1 | Bobina UTP Cat6 305m — Ulink | 1 | $155.000 | $155.000 |
| 2 | Bobina UTP Cat6 100m — Ulink | 1 | $20.794 | $20.794 |
| 3 | Jack RJ45 hembra Cat6 keystone | 18 | $3.500 | $63.000 |
| 4 | Faceplate 1 posición | 18 | $500 | $9.000 |
| 5 | Conector RJ45 macho Cat6 (pack 100u) | 1 | $6.500 | $6.500 |
| 6 | Patch cord Cat6 1m | 18 | $800 | $14.400 |
| 7 | Patch cord Cat6 2m | 18 | $1.000 | $18.000 |
| 8 | Patch Panel Cat6 24 puertos — LS Cable | 1 | $122.770 | $122.770 |
| 9 | DRL Moldura PVC 40×16mm 2m — Imperial/Sodimac | 35 | $1.490 | $52.150 |
| 10 | Ángulo Plano 40×16mm — Comdiel | 4 | $580 | $2.320 |
| 11 | Ángulo Exterior 40×16mm — Comdiel | 4 | $580 | $2.320 |
| 12 | Ángulo Interior 40×16mm — Comdiel | 4 | $580 | $2.320 |
| 13 | Derivación T Plana 40×16mm — Comdiel | 6 | $580 | $3.480 |
| 14 | Unión 40×16mm — Comdiel | 10 | $549 | $5.490 |
| 15 | Tapa Final 40×16mm — Comdiel | 4 | $549 | $2.196 |
| 16 | Fijaciones (tornillos, tarugos, clips) | 1 | $10.000 | $10.000 |
| 17 | Etiquetas identificadoras | 1 | $5.000 | $5.000 |
| | **TOTAL MATERIALES** | | | **$494.740** |

Cálculos de verificación:
- Bobinas: 155.000 + 20.794 = $175.794
- Jacks + faceplates: 63.000 + 9.000 = $72.000
- Conectores + patch cords: 6.500 + 14.400 + 18.000 = $38.900
- Patch panel: $122.770
- **Subtotal cableado:** 175.794 + 72.000 + 38.900 + 122.770 + 10.000 + 5.000 = $424.464
- Canaleta Sodimac: 35 × 1.490 = $52.150
- Accesorios Comdiel: 2.320 + 2.320 + 2.320 + 3.480 + 5.490 + 2.196 = $18.126
- **Subtotal canalización:** 52.150 + 18.126 = $70.276
- **TOTAL:** 424.464 + 70.276 = **$494.740**

Diferencia vs. presupuesto original ($511.544): **-$16.804**

## Paso 4 — Agregar columna Precio Unitario (si no existe)

Si la tabla actual solo tiene `Producto | Cantidad | Total`, insertar columna `Precio Unitario` entre Cantidad y Total.

Usar los precios unitarios de la tabla del Paso 3.

## Paso 5 — Insertar espacios para capturas (Formato IEEE)

Agregar DESPUÉS de cada ítem cotizado, en Anexo A. Cada captura con:

```
Fig. <N>. Captura de pantalla — Cotización <producto> en <proveedor>.
Fuente: <proveedor>.
```

| # | Fig. | Producto | URL |
|---|------|----------|-----|
| 1 | Fig. 3 | Bobina UTP Cat6 305m — Ulink | prafer.cl |
| 2 | Fig. 4 | Jack RJ45 + Faceplate + Conector | prafer.cl |
| 3 | Fig. 5 | Patch cord Cat6 1m y 2m | prafer.cl |
| 4 | Fig. 6 | Patch Panel Cat6 24p — LS Cable | transworld.cl/producto/patch-panel-24-puertos-alta-densidad-cat6/ |
| 5 | Fig. 7 | DRL Moldura PVC 40×16mm 2m | sodimac.cl/sodimac-cl/articulo/147232860/ |
| 6 | Fig. 8 | Ángulo Plano 40×16mm | comdiel.cl/angulo-plano-para-canaleta-40x16mm |
| 7 | Fig. 9 | Ángulo Exterior + Interior 40×16mm | comdiel.cl/angulo-exterior-para-canaleta-40x16mm + comdiel.cl/angulo-interior-para-canaleta-40x16mm |
| 8 | Fig. 10 | Derivación T + Unión 40×16mm | comdiel.cl/derivacion-t-plana-para-canaleta-40x16mm + comdiel.cl/union-para-canaleta-40x16mm |
| 9 | Fig. 11 | Tapa Final 40×16mm | comdiel.cl/tapa-final-para-canaleta-40x16mm |

## Paso 6 — Actualizar VAN/TIR (si están calculados)

Si el informe tiene VAN y TIR basados en $511.544:

- Diferencia: **-$16.804** (menos inversión inicial)
- VAN nuevo = VAN original + $16.804 (mejora)
- TIR nueva: sube marginalmente (depende de los flujos)
- Actualizar el valor en la fórmula/tabla correspondiente

Si el informe no tiene VAN/TIR, omitir este paso.

## Paso 7 — Verificar y actualizar sugerencias

Revisar la sección "Sugerencias" o "Recomendaciones" al final del informe:
- Si menciona "Lexo Chile" → cambiar a "Sodimac / Imperial DRL para canaletas y Comdiel para accesorios"
- Si sugiere cotizar como empresa a Lexo → eliminar esa sugerencia

## Formato IEEE — Reglas estrictas

| Elemento | Formato | Ejemplo |
|----------|---------|---------|
| Figuras | Arábigo: Fig. 1, 2, 3... | Fig. 3. Captura... Fuente: Sodimac. |
| Tablas | Romano: Tabla I, II, III... | Tabla IV. Presupuesto... Fuente: Elaboración propia. |
| Citas en texto | Corchetes: [1], [2] | "...como se ve en la Fig. 3 [1]." |
| Lista referencias | Al final del documento | [1] Transworld, "Patch Panel..." |
| Capturas | ~media página, con borde sutil | — |

## URLs definitivas

| Producto | URL |
|----------|-----|
| Canaleta Sodimac | https://www.sodimac.cl/sodimac-cl/articulo/147232860/ |
| Ángulo Plano Comdiel | https://www.comdiel.cl/angulo-plano-para-canaleta-40x16mm |
| Ángulo Exterior Comdiel | https://www.comdiel.cl/angulo-exterior-para-canaleta-40x16mm |
| Ángulo Interior Comdiel | https://www.comdiel.cl/angulo-interior-para-canaleta-40x16mm |
| Derivación T Comdiel | https://www.comdiel.cl/derivacion-t-plana-para-canaleta-40x16mm |
| Unión Comdiel | https://www.comdiel.cl/union-para-canaleta-40x16mm |
| Tapa Final Comdiel | https://www.comdiel.cl/tapa-final-para-canaleta-40x16mm |
| Patch Panel Transworld | https://transworld.cl/producto/patch-panel-24-puertos-alta-densidad-cat6/ |

## Checklist final

- [ ] ¿Canaleta Lexo reemplazada por Sodimac DRL $1.490?
- [ ] ¿"Accesorios ~$17.880" desglosado en 6 filas con cantidades?
- [ ] ¿Columna Precio Unitario agregada?
- [ ] ¿Totales recalculados: $494.740?
- [ ] ¿Espacios para 9 capturas insertados (Fig. 3 a Fig. 11)?
- [ ] ¿Formato IEEE correcto en Fig. y Tablas?
- [ ] ¿VAN/TIR actualizados (si aplica)?
- [ ] ¿Sugerencias actualizadas (Lexo → Sodimac/Comdiel)?
- [ ] ¿Restan $16.804 respecto al presupuesto original?
