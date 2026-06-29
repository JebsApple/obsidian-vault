# 🤖 IA-Control — Control remoto de Claude desde Obsidian

Desde tu PC (sin SSH) le mandás tareas al server y te responde acá mismo.

## Cómo usarlo
1. Abrí **`pedido.md`** (en esta carpeta).
2. Escribí tu tarea debajo del frontmatter.
3. Elegí el **modo** y cambiá **`estado: ejecutar`**.
4. Guardá. Tu PC lo sube; el server lo ejecuta y deja la respuesta en **`respuestas/`** (la verás aparecer sola).

## Campos del frontmatter de `pedido.md`
```yaml
estado: pendiente   # cambiá a "ejecutar" para lanzar. El server lo pone en "hecho" al terminar
dir: /home/icin/minegocio-frontend   # carpeta donde corre Claude (opcional)
```

## Seguridad (modo PLAN fijo)
- El puente está en **modo PLAN únicamente**: Claude **solo lee y analiza**, NUNCA modifica archivos ni corre comandos con cambios. Es de solo lectura.
- Sirve para: revisar estado, diagnosticar, proponer planes, leer logs/código y responder preguntas sobre el proyecto.
- **Freno de emergencia:** creá un archivo vacío llamado `PAUSA` en esta carpeta y el server deja de procesar pedidos.
- Todo queda logueado en el server: `~/.local/share/vault-ia-worker.log`.

## Latencia
El server revisa pedidos cada **1 min** y sincroniza el vault cada **2 min**. Con push/pull manual en tu PC, la respuesta tarda unos **2-4 min**. Si esperás los intervalos del plugin, más.
