---
tags:
  - ui-ux
  - diseno
  - color
  - typography
  - trends
  - Referencia
created: 2026-07-12
---

# UI/UX Design — Guía 2026

## Principios Fundamentales

1. **Entender al usuario** — Research antes de diseñar. Personas, empathy maps, jobs-to-be-done
2. **Consistencia** — Design system, tokens, component library reutilizable
3. **Jerarquía visual** — Tamaño, color, contraste, proximidad guían la mirada
4. **Simplicidad** — Minimalism, progressive disclosure, whitespace activo
5. **Accesibilidad** — WCAG 2.2 AA mínimo: contraste 4.5:1, keyboard nav, ARIA labels, alt text

## Color Theory 2026

### Datos clave
- 90% de la evaluación de un producto es subconsciente y basada en color (primeros 90 segundos)
- Color aumenta reconocimiento de marca hasta 80%
- 85% de consumidores citan color como razón principal de compra

### Tendencias de color

| Tendencia | Descripción | Uso |
|-----------|-------------|-----|
| Fluid Palettes | Colores que cambian según contexto (hora, wallpaper) | Apps personales |
| Dark Mode+ | Más allá de dark: theme-aware, adaptativo | Todos los productos |
| Gradient Systems | Gradientes como sistema, no decoración | Branding, UI moderna |
| Anti-Design | Colores "clash" intencionales, imperfección | Portfolios, marcas edgy |
| Neural Colors | Paletas generadas por ML para optimizar conversión | E-commerce, SaaS |

### Paletas funcionales

```
# SaaS Dashboard
Primary:   #2563EB (azul confianza)
Success:   #16A34A
Warning:   #F59E0B
Error:     #DC2626
Surface:   #F8FAFC (light) / #0F172A (dark)
```

### Reglas de contraste

- Texto normal: mínimo 4.5:1 (WCAG AA)
- Texto grande (18px+ bold): mínimo 3:1
- UI components: mínimo 3:1 contra fondo
- Tools: Chrome DevTools contrast checker, Stark plugin

## Typography

### Mejores fuentes UI 2026

| Fuente | Tipo | Mejor para |
|--------|------|------------|
| Inter | Sans-serif | UI general, legibilidad |
| Figtree | Sans-serif | Moderno, amigable |
| Mona Sans | Sans-serif | GitHub-style, neutral |
| Geist | Sans-serif | Vercel ecosystem |
| JetBrains Mono | Monospace | Code, terminals |
| Satoshi | Sans-serif | Branding, display |

### Reglas

- **Máximo 2 fuentes**: una para headings, una para body
- **Variable fonts** para performance (un archivo, múltiples pesos)
- **Line height**: 1.4-1.6 para body, 1.0-1.2 para headings
- **Font size scale**: 12, 14, 16, 18, 20, 24, 30, 36, 48, 60px
- Test across platforms: what renders well on macOS may fail on Windows

## Tendencias UI/UX 2026

### 1. Spatial UI
- Interfaces que usan profundidad 3D (no solo headsets)
- Responsive 3D: cards/botones que reaccionan a cursor/tilt
- AR previews en e-commerce
- 3D elements aumentan time-on-page hasta 6x

### 2. Generative UI
- Interfaces que se reorganizan según el usuario
- Predictive layout: si siempre revisas balance a las 8am, ese botón es grande
- Reducción de fricción por contexto

### 3. Multimodal Interactions
- Voice + touch + gesture en la misma UI
- Skeleton screens > spinners
- Transiciones que respetan loading times

### 4. Anti-Design 2.0
- Caos intencional: oversized, clashing colors, text overlapping
- Portfolios, marcas edgy, apps que rechazan templates
- No es "malo" — es break rules on purpose

## Layout Best Practices

```css
/* Design Tokens base */
:root {
  --space-xs: 4px;
  --space-sm: 8px;
  --space-md: 16px;
  --space-lg: 24px;
  --space-xl: 32px;
  --space-2xl: 48px;
  --space-3xl: 64px;
  
  --radius-sm: 6px;
  --radius-md: 8px;
  --radius-lg: 12px;
  
  --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
  --shadow-md: 0 4px 6px rgba(0,0,0,0.1);
  --shadow-lg: 0 10px 15px rgba(0,0,0,0.1);
}
```

### Responsive

- Mobile-first: diseñar para 375px primero
- Breakpoints: 640, 768, 1024, 1280, 1536px
- Flexible grids, scalable images, CSS media queries
- Touch targets mínimo 44x44px

## Feedback & Micro-interactions

- Skeleton screens durante loading
- Hover states en todos los interactive elements
- Transiciones suaves (200-300ms ease-out)
- Toast notifications para acciones exitosas
- Error messages inline, no modales

## Tools

| Herramienta | Uso | Precio |
|------------|-----|--------|
| Figma | Design & prototyping | Free/Pro |
| Tailwind CSS | Utility-first CSS | Free |
| shadcn/ui | Component library | Free |
| Radix UI | Accessible primitives | Free |
| Stark | Contrast/accessibility | Freemium |
