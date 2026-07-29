---
description: Transforma código/docs en knowledge graph persistente
agent: build
---
Carga el skill `graphify` y ejecuta el workflow:
1. Analiza el input del usuario (código, docs, carpeta)
2. Genera knowledge graph con nodos, edges, y comunidades
3. Guarda en `graphify-out/graph.json`
4. Herramientas disponibles: query_graph, shortest_path, god_nodes, graph_stats
