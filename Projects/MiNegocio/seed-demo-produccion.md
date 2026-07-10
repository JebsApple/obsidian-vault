---
tags: [proyecto/minegocio, sql, seed, demo, produccion]
created: 2026-07-10
updated: 2026-07-10
---

# Seed rápido para demo — Producción

> **Problema anterior:** ventas usaba id_vendedor=2,3 que no existían. Este seed primero inserta los usuarios, luego ventas solo con id_vendedor=1.

## Paso 0 — SSH

```bash
ssh icin@192.168.50.25
```

## Paso 1 — Usuarios (todos los del equipo, ON CONFLICT seguro)

```bash
sudo -u postgres psql -d cliente_prod -c "INSERT INTO usuarios (nombre, email, password_hash, rol) VALUES ('Victor','VictorAdmin@minegocio.cl','\$2a\$10\$xMq.Y1XATMP9kaiRWFi.dO3NTXYk79cW6Ye2kV3mFeR2AMprnaRBC','admin'),('Ignacio','IgnacioAdmin@minegocio.cl','\$2a\$10\$MduST0JZC9da.4vPe9XZjOgriJcd1iIRM7PsQDNLwheZ7wzhjqFTG','admin'),('Nicolas','NicolasAdmin@minegocio.cl','\$2a\$10\$ldDfsujus5KVjFCU2D0zN.PI37Za5.nAxX8WBaWlebRcD26fsv4U6','vendedor'),('Gabriel','GabrielAdmin@minegocio.cl','\$2a\$10\$ldDfsujus5KVjFCU2D0zN.PI37Za5.nAxX8WBaWlebRcD26fsv4U6','vendedor'),('diego','diego@minegocio.cl','\$2a\$10\$EA2fkK7WumV9rxlGcI1UCek.I.ewXwgXHVndAzR0OZzFExZCHLR7e','vendedor'),('admin','admin@test.com','\$2a\$10\$w5WkAGIo1r2ihLzhBw8AK.tqVYW27bu8PFdpRSmbqiHAoh6CMKuqK','admin') ON CONFLICT (email) DO NOTHING;"
```

## Paso 2 — Verificar usuarios

```bash
sudo -u postgres psql -d cliente_prod -c "SELECT id, nombre, email, rol FROM usuarios ORDER BY id;"
```

> Deben aparecer 6 usuarios. **Si solo aparece 1**, algo falló en el paso anterior. No continues hasta que veas los 6.

## Paso 3 — Proveedores (5)

> **Si ya los insertaste antes**, salta este paso.

```bash
sudo -u postgres psql -d cliente_prod -c "INSERT INTO proveedores (nombre, rut, email, telefono, direccion) VALUES ('Distribuidora Andes','76.123.456-7','ventas@andes.cl','+56912345678','Av. San Martin 1234, Santiago'),('Alimentos del Sur','76.987.654-3','pedidos@delsur.cl','+56987654321','Calle Freire 567, Temuco'),('Bebidas Premium','76.555.111-2','contacto@bebidasp.cl','+56955511122','Ruta 5 Sur km 12, Valparaiso'),('Lacteos del Valle','76.777.222-5','ventas@lacteosvalle.cl','+56977722255','Camino Las Palmas 456, Rancagua') ON CONFLICT DO NOTHING;"
```

## Paso 4 — Productos (15, variedad para dashboard)

> **Si ya los insertaste antes**, salta este paso.

```bash
sudo -u postgres psql -d cliente_prod -c "INSERT INTO productos (nombre, codigo_barras, precio_compra, precio_venta, stock, descripcion, categoria, marca, id_usuario, ubicacion) VALUES ('Coca-Cola 1.5L','7802010001015',800,1490,48,'Gaseosa 1.5L','Bebidas','Coca-Cola',1,'Bodega'),('Agua Cachantun 1.5L','7802010005012',500,890,60,'Agua mineral','Bebidas','Cachantun',1,'Bodega'),('Arroz Tucapel 1kg','7802010006034',700,1290,40,'Arroz grano largo','Alimentos','Tucapel',1,'Bodega'),('Fideo Carozzi 400g','7802010007053',450,890,55,'Pasta seca','Alimentos','Carozzi',1,'Bodega'),('Aceite Mirasol 1L','7802010008075',1500,2490,3,'Aceite vegetal','Alimentos','Mirasol',1,'Bodega'),('Leche Soprole 1L','7802010111236',550,990,28,'Leche entera UHT','Lacteos','Soprole',1,'Vitrina'),('Queso Loncoleche 500g','7802010113567',2500,4290,10,'Queso mantecoso','Lacteos','Loncoleche',1,'Vitrina'),('Papas Lays 180g','7802010121035',1500,2490,0,'Papas fritas','Snacks','Lays',1,'Vitrina'),('Chocolate Savoy 150g','7802010122156',1200,2190,16,'Chocolate con leche','Snacks','Savoy',1,'Vitrina'),('Galletas McCarlitos 200g','7802010123456',800,1490,22,'Galletas manteca','Snacks','McCarlitos',1,'Vitrina'),('Cereal Zucaritas 300g','7802010125678',1800,2990,8,'Cereal de maiz','Snacks','Kelloggs',1,'Bodega'),('Jabon Dove 90g','7802010131234',1200,1990,20,'Jabon hidratante','Aseo','Dove',1,'Vitrina'),('Detergente Omo 1.5L','7802010133456',3500,5490,2,'Detergente liquido','Aseo','Omo',1,'Bodega'),('Cloro Clorox 1L','7802010134567',800,1390,30,'Cloro desinfectante','Aseo','Clorox',1,'Bodega'),('Suavizante Comfort 800ml','7802010135678',1500,2490,18,'Suavizante ropa','Aseo','Comfort',1,'Bodega') ON CONFLICT (codigo_barras) DO NOTHING;"
```

> Stock variado a propósito: Lays=0 (agotado), Omo=2, Aceite=3, Zucaritas=8 (bajos), el resto normales.

## Paso 5 — Ventas (20 registros, solo Victor id=1)

```bash
sudo -u postgres psql -d cliente_prod -c "INSERT INTO registro_ventas (id_producto, precio_producto, cantidad, fecha_venta, id_vendedor) VALUES (1,1490,3,'2025-06-02 10:15:00',1),(2,790,2,'2025-06-05 11:30:00',1),(6,1290,5,'2025-06-07 09:45:00',1),(11,990,4,'2025-06-10 14:20:00',1),(16,2490,2,'2025-06-12 10:30:00',1),(7,890,6,'2025-06-14 11:15:00',1),(1,1490,8,'2025-06-16 08:30:00',1),(4,5490,1,'2025-06-18 15:45:00',1),(12,1990,3,'2025-06-20 13:00:00',1),(5,890,10,'2025-06-22 09:00:00',1),(3,990,5,'2025-06-24 10:15:00',1),(17,2190,2,'2025-06-26 14:30:00',1),(9,1190,4,'2025-06-28 09:30:00',1),(1,1490,6,'2025-07-01 08:45:00',1),(11,990,7,'2025-07-03 11:00:00',1),(6,1290,5,'2025-07-05 09:00:00',1),(16,2490,3,'2025-07-07 10:30:00',1),(5,890,12,'2025-07-09 09:15:00',1),(1,1490,10,'2025-07-10 08:00:00',1),(8,2490,2,'2025-07-10 14:00:00',1);"
```

## Paso 6 — Resetear secuencias

```bash
sudo -u postgres psql -d cliente_prod -c "SELECT setval('productos_id_seq',(SELECT MAX(id)FROM productos));SELECT setval('proveedores_id_seq',(SELECT MAX(id)FROM proveedores));SELECT setval('registro_ventas_id_venta_seq',(SELECT MAX(id_venta)FROM registro_ventas));"
```

## Paso 7 — Verificar todo

```bash
sudo -u postgres psql -d cliente_prod -c "SELECT 'usuarios' AS tabla,COUNT(*) FROM usuarios UNION ALL SELECT 'proveedores',COUNT(*) FROM proveedores UNION ALL SELECT 'productos',COUNT(*) FROM productos UNION ALL SELECT 'ventas',COUNT(*) FROM registro_ventas;"
```

**Esperado:** usuarios=6, proveedores=4-5, productos=15, ventas=20.

## Credenciales

| Usuario | Email | Pass | Rol |
|---------|-------|------|-----|
| Victor | VictorAdmin@minegocio.cl | Victor264 | admin |
| Ignacio | IgnacioAdmin@minegocio.cl | Admin226 | admin |
| Nicolas | NicolasAdmin@minegocio.cl | User224 | vendedor |
| Gabriel | GabrielAdmin@minegocio.cl | User224 | vendedor |
| diego | diego@minegocio.cl | diego123 | vendedor |
| admin | admin@test.com | admin123 | admin |
