---
tags: [proyecto, caso05, redes, cotizacion, ieee]
---
}}}}}
# Caso05 — Reemplazo de cotizaciones y formato IEEE

## Problema
Productos Lexo (canaleta PVC 40×16mm y accesorios) sin stock/agotados en la cotización del informe. No se pueden comprar, no hay precio visible para captura IEEE.

## Hallazgos

### Transworld — Patch Panel Cat6 24p ✅
- Precio visible: **$122.770** IVA inc.
- Mismo precio que ya está en el informe
- No requiere reemplazo
- URL: `transworld.cl/producto/patch-panel-24-puertos-alta-densidad-cat6/`

### Lexo — Canaleta PVC 40×16mm 2m ❌ AGOTADO
- Precio: $1.900/tira
- Stock: **cero** (agotado)
- URL (solo referencia): `lexochile.cl/producto/canaleta-pvc-40x16mm-largo-2-mts/`

### Lexo — Accesorios 40×16mm ❌ TODO AGOTADO
| Accesorio | Precio Lexo | Stock |
|-----------|-------------|-------|
| Ángulo plano | $510 | ❌ |
| Curva exterior | $460 | ❌ |
| Curva interior | $460 | ❌ |
| Conexión T | $500 | ❌ |
| Copla (unión) | $450 | ❌ |
| Tapa terminal | $450 | ❌ |

## Reemplazos confirmados

### Canaleta → Sodimac DRL Moldura PVC 40×16mm
- **Precio:** $1.490/tira
- **Total (35 tiras):** $52.150 (vs $66.500 Lexo = -$14.350)
- URL: `sodimac.cl/sodimac-cl/articulo/147232860/`
- Alternativa: Comdiel a $1.380/tira

### Accesorios → Comdiel (todos con stock)
| Accesorio | Código Comdiel | Precio |
|-----------|----------------|--------|
| Ángulo Plano | 00572A | $580 |
| Ángulo Exterior | 00572B | $580 |
| Ángulo Interior | 00572C | $580 |
| Derivación T Plana | 00572D | $580 |
| Unión | 00572E | $549 |
| Tapa Final | 00572F | $549 |

URLs:
- `comdiel.cl/canaleta-40x16-mm-largo-2-metros` (canaleta $1.380)
- `comdiel.cl/angulo-plano-para-canaleta-40x16mm`
- `comdiel.cl/angulo-exterior-para-canaleta-40x16mm`
- `comdiel.cl/angulo-interior-para-canaleta-40x16mm`
- `comdiel.cl/derivacion-t-plana-para-canaleta-40x16mm`
- `comdiel.cl/union-para-canaleta-40x16mm`
- `comdiel.cl/tapa-final-para-canaleta-40x16mm`

## Presupuesto recalculado

### Opción recomendada (Comdiel canaleta + accesorios)
| Ítem | Cant. | P.Unit. | Total |
|------|-------|---------|-------|
| Canaleta PVC 40×16mm 2m | 35 | $1.380 | $48.300 |
| Accesorios (estimado) | — | — | ~$20.508 |
| **Subtotal canalización** | | | **~$68.808** |
| Cableado (sin cambios) | | | $427.164 |
| **Total materiales** | | | **~$495.972** |

### Opción Sodimac canaleta + Comdiel accesorios
| Ítem | Cant. | P.Unit. | Total |
|------|-------|---------|-------|
| DRL Moldura PVC 40×16mm 2m | 35 | $1.490 | $52.150 |
| Accesorios Comdiel (estimado) | — | — | ~$20.508 |
| **Subtotal canalización** | | | **~$72.658** |
| Cableado (sin cambios) | | | $427.164 |
| **Total materiales** | | | **~$499.822** |

**Ahorro total:** ~$15.572 vs presupuesto original ($511.544)

## URLs para capturas IEEE
Páginas definitivas con precio visible para tomar capturas:

1. **prafer.cl** — Bobinas UTP Cat6, jacks, faceplates, conectores, patch cords
2. **transworld.cl** — Patch Panel Cat6 24p ($122.770)
3. **comdiel.cl/canaleta-40x16-mm-largo-2-metros** — Canaleta ($1.380)
4. **comdiel.cl/angulo-plano-para-canaleta-40x16mm** — Ángulo plano ($580)
5. **comdiel.cl/angulo-exterior-para-canaleta-40x16mm** — Ángulo exterior ($580)
6. **comdiel.cl/angulo-interior-para-canaleta-40x16mm** — Ángulo interior ($580)
7. **comdiel.cl/derivacion-t-plana-para-canaleta-40x16mm** — Derivación T ($580)
8. **comdiel.cl/union-para-canaleta-40x16mm** — Unión ($549)
9. **comdiel.cl/tapa-final-para-canaleta-40x16mm** — Tapa final ($549)

## Formato IEEE para figuras y tablas
Según guías en `~/Documentos/Claude/projects/caso-05/`:

```
Fig. <N>. <Título descriptivo>. Fuente: <origen>.
Tabla <N. romano>. <Título>. Fuente: <origen>.
```

### Ejemplos concretos
```
Fig. 3. Captura de pantalla — Cotización patch panel Cat6 24 puertos en Transworld.cl.
Fuente: Transworld.

Tabla IV. Presupuesto de materiales para cableado estructurado.
Fuente: Elaboración propia.
```

### Reglas
- Numerar figuras arábigo secuencial (Fig. 1, 2, 3...)
- Numerar tablas en romanos (Tabla I, II, III...)
- Cada captura ocupa ~media página con espacio alrededor
- Referenciar en el texto: "Como se observa en la Fig. 3..."
- Citar fuente con corchetes si hay referencias al final

## Archivos del proyecto
| Archivo | Descripción |
|---------|-------------|
| `~/Descargas/Caso05_Herrera_Soncco_Informe.docx` | v1: solo cableado, $511.544 |
| `~/Descargas/Caso05_Herrera_Soncco_Informe_v2.docx` | v2: + equipamiento activo, $1.214.665 |
| `~/Descargas/Caso05_Herrera_Soncco_Informe_v2_1.docx` | v2.1: idéntico a v2 |
| `~/Descargas/estudio /Caso05_Herrera_Soncco_Informe.docx` | Completo 2.9 MB (con sugerencias y anexos) |
| `~/pt/saves/Caso05_Herrera_Soncco.pkt` | Simulación Packet Tracer |

## Pendientes
- [ ] Revisar sugerencias al final del informe "estudio" (2.9 MB) → ver si ya recomiendan Comdiel/Sodimac
- [ ] Editar .docx: reemplazar tabla cotización, actualizar subtotales
- [ ] Agregar ~6-8 capturas como Fig. 3-10 en Anexo A con formato IEEE
- [ ] Recalcular VAN/TIR si cambia el presupuesto
- [ ] Decidir: Comdiel ($1.380/tira) vs Sodimac ($1.490/tira) para canaleta
