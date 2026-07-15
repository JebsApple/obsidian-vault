# Missing Links — Edges sugeridos por análisis de Jaccard

Nodos que comparten vecinos idénticos pero no están directamente conectados. Estos son los edges de "bajo fruta" que probablemente deberían existir.

## Alta confianza (Jaccard = 1.0)

Estos son funciones del mismo módulo que comparten los mismos vecinos:

| Nodo A | Nodo B | Vecinos comunes | Interpretación |
|--------|--------|-----------------|----------------|
| at() | rt() | 2 | Timer functions del plugin |
| at() | ot() | 2 | Timer functions del plugin |
| at() | lt() | 2 | Timer functions del plugin |
| ot() | rt() | 2 | Timer functions del plugin |
| lt() | rt() | 2 | Timer functions del plugin |
| lt() | ot() | 2 | Timer functions del plugin |
| ct() | gt() | 2 | Counter functions del plugin |
| ct() | ht() | 2 | Counter functions del plugin |
| ct() | ut() | 2 | Counter functions del plugin |
| gt() | ht() | 2 | Counter functions del plugin |

**Nota**: Estos son internals del plugin stversions — crear edges entre ellos no agrega valor semántico. El análisis automático los detecta pero son ruido para uso práctico.

## Recomendación

Los edges más útiles para crear manualmente serían:
1. **Nodos aislados de MiNegocio** → conectar a sus proyectos padres
2. **Cross-project bridges** → crear edges explícitos entre comunidades que comparten patrones
3. **MOC nodes** → conectar a comunidades sin índice

Prioridad: Conectar los 47 nodos aislados a sus comunidades antes de crear nuevos edges entre nodos ya conectados.
