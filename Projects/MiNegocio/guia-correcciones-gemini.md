---
tags: [proyecto/minegocio, correcciones, gemini-feedback]
---

# Guía de Correcciones — Crítica de Gemini basada en pauta del profesor

## 1. Presupuesto: Incluir equipamiento activo
- Agregar al listado de costos (Tabla IV): 1 switch principal 24 puertos, 3 switches de acceso (8 o 16 puertos), 1 router de borde, 1 rack mural, 1 UPS
- Eliminar cláusula de exclusión de sección 4.1
- Cotizar con valores comerciales reales

## 2. Inversión Inicial (I₀)
- Reemplazar $631.083 por nuevo total consolidado (Materiales completos + Mano de obra)
- Actualizar flujo de caja (Tabla VII)

## 3. Beneficios anuales: Modelar justificación técnica
- Ejemplo: "5 caídas mensuales que detienen 18 usuarios x 2 horas. Red Cat6 reduce inactividad 90%, recuperando $X horas-hombre = ahorro anual de $260.000"
- No dejar el valor sin respaldo

## 4. Patch cords: incrementar cantidad
- 3 enlaces troncales → 6 patch cords adicionales (2 por enlace)
- Total: 42 patch cords en vez de 36

## 5. Conectores RJ45 macho
- Eliminar del presupuesto (incompatible con norma ANSI/TIA-568.2-D que usa jacks hembra + patch panel)
- O justificar técnicamente si se mantienen

## 6. Recalcular VAN y TIR
- Ejecutar fórmulas con inversión real indexada
- Si VAN negativo: proponer alternativas (extender a 5 años o recalcular beneficios)
