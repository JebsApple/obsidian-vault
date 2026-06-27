---
tags: [universidad, jenkins, despliegue]
---

Permitir que Jenkins (Server A) despliegue aplicaciones en Tomcat (Server B) mediante SSH sin contraseña y con permisos mínimos necesarios.

Servidor A: 192.168.50.28 - Icin2026


PASO 1: Crear usuario de despliegue en Server B (reemplazar por la ultima letra "N" por el numero de su equipo) sudo adduser deployadminN

Contraseña inicial:

deployAdmin

(La contraseña solo se utilizará para administración inicial. Los despliegues usarán clave SSH.)

PASO 2: Crear directorio SSH 

_sudo mkdir -p /home/deployadminN/.ssh_

dar permisos

_sudo chown -R deployadminN:deployadminN /home/deployadminN_

_sudo chmod 700 /home/deployadminN/.ssh_

PASO 3: Dar acceso al directorio de despliegue

para la carpeta donde estan los archivos de producción ejemplo:

/opt/tomcat-prod

Asignar permisos:

_sudo chown -R deployadminN:deployadminN /opt/tomcat-prod/webapps_

Verificar:

_ls -ld /opt/tomcat-prod/webapps_

Debe mostrar:

deployadminN deployadminN

PASO 4: Generar clave SSH en Server A ir a serverA

_sudo ssh-keygen  
-t rsa  
-b 4096  
-C "jenkins@server-a"  
-f /root/.ssh/id_rsa_deployadminN_

Cuando solicite passphrase:

Enter Enter

(dejar vacía para automatización).

PASO 5: Copiar clave pública al Server B 

_sudo ssh-copy-id  
-i /root/.ssh/id_rsa_deployadminN.pub  
_[_deployadmin@192.168.50.2N_](mailto:deployadmin@192.168.50.2N)

Cambiar la IP según corresponda.

PASO 6: Verificar acceso SSH sudo ssh  
_-i /root/.ssh/id_rsa_deployadmin  
_[_deployadminN@192.168.50.27_](mailto:deployadminN@192.168.50.27)_  
"whoami"_

Resultado esperado:

deployadminN

PASO 7: Configurar sudo restringido Ir a serverB NO agregar el usuario al grupo sudo.

Verificar con :

id deployadmin

No debe aparecer el grupo: sudo

Luego editar sudoers: la idea es que el usuario deployadmin solo pueda iniciar ciertos servicios sin contraseña. en este ejemplo se utiliza los servicios de tomcat-prod (cambiar por los correspondientes en su servidor) Si no utiliza tomcat saltar al paso 9 y luego configurar el sudoers para sus servicios del backend.

sudo visudo

Agregar:

_deployadmin ALL=(ALL) NOPASSWD:  
/usr/bin/systemctl start tomcat-prod,  
/usr/bin/systemctl stop tomcat-prod,  
/usr/bin/systemctl restart tomcat-prod,  
/usr/bin/systemctl status tomcat-prod_

Validar:

sudo visudo -c PASO 8: Verificar permisos sudo

Entrar como deployadmin:

_su - deployadmin_

Verificar:

_sudo -l_

Debe mostrar únicamente los comandos systemctl definidos.

Probar:

_sudo -n systemctl status tomcat-prod_

No debe solicitar contraseña.

PASO 9: Verificación remota completa

Desde Server A:

_sudo ssh  
-i /root/.ssh/id_rsa_deployadmin  
_[_deployadminN@192.168.50.2N_](mailto:deployadminN@192.168.50.2N)  
_"sudo -n systemctl status tomcat-prod"_

Debe mostrar el estado del servicio sin solicitar contraseña.

10- permisos para que el usuario deployAdmin pueda desplegar el front

sudo chown -R deployadminN:deployadminN /var/www/prod/taller01

cambiar la ruta segun su la ubicacion de su front en el servidor.

[[Cuentas Jenkins-sonarqube]]