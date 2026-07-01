**Victor Herrera**


![[Pasted image 20260701103334.png]]![[Pasted image 20260701103235.png]]


**Ingreso a modo Privilegiado**

```
enable
```

		** **

```
show version
```

![[Pasted image 20260701103742.png]]

![[Pasted image 20260701103817.png]]

![[Pasted image 20260701103806.png]]

**Verificación de la configuración actual.**


```
show running-config
```


![[Pasted image 20260701104020.png]]

**Cambio de nombre del equipo:**


```
configure terminal
```

```
hostname SW-LAB-01
```

![[Pasted image 20260701104246.png]]

**Desactivar busqueda DNS.**

```
no ip domain-lookup
```


![[Pasted image 20260701105029.png]]

**MOTD banner**

```
banner motd #Laboratorio Intermedio - Switch Cisco 2960#
```

![[Pasted image 20260701104617.png]]

**Verificación:**

```
end
```

```
show running-config
```

![[Pasted image 20260701105208.png]]
![[Pasted image 20260701105833.png]]

**Listar todas las interfaces disponibles:**


```
show ip interface brief
```


![[Pasted image 20260701110120.png]]

**Configurar descripción y estado de interfaces**

```
SW-LAB-01# configure terminal
SW-LAB-01(config)# interface FastEthernet 0/1
SW-LAB-01(config-if)# description Puerto de acceso - PC Admin
SW-LAB-01(config-if)# no shutdown
SW-LAB-01(config-if)# exit

SW-LAB-01(config)# interface FastEthernet 0/2
SW-LAB-01(config-if)# description Puerto de acceso - Impresora
SW-LAB-01(config-if)# shutdown
SW-LAB-01(config-if)# exit

SW-LAB-01(config)# interface FastEthernet 0/3
SW-LAB-01(config-if)# description Puerto de reserva
SW-LAB-01(config-if)# shutdown
SW-LAB-01(config-if)# exit

SW-LAB-01(config)# interface FastEthernet 0/4
SW-LAB-01(config-if)# description Enlace a switch secundario
SW-LAB-01(config-if)# no shutdown
SW-LAB-01(config-if)# end
```

**Determinar estado de las interfaces**
```
show interfaces status
```
![[Pasted image 20260701110816.png]]

**Obtener información del sistema**

*estadísticas de todas las interfaces*

```
show interfaces             
```

![[Pasted image 20260701111004.png]]

![[Pasted image 20260701111012.png]]

![[Pasted image 20260701111037.png]]

![[Pasted image 20260701111048.png]]

*config actual (en RAM)*

```
show running-config          
```


![[Pasted image 20260701111126.png]]

*config guardada (en NVRAM)*

```
show startup-config 
```

![[Pasted image 20260701111347.png]]

**Guardar la configuración**

```
copy running-config startup-config
```

![[Pasted image 20260701111652.png]]

**Cierre de sesión:**
```
exit
```

**Comprobación de configuración de inicio guardada**

![[Pasted image 20260701111824.png]]
![[Pasted image 20260701111844.png]]
![[Pasted image 20260701111902.png]]
