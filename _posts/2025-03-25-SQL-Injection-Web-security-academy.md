---
layaout: post
image: /assets/DocumentacionHacking/InyeccionSQL.png
title: SQL Injection web-security-academy
date: 25-03-2025
categories: [Laboratorios]
tag: [SQL inyection]
excerpt: "En esta seccion vamos a explorar el funcionamiento de lo que es SQL inyection la cual es una de las vulnerabilidades mas comunes en lo que respecta a dominios web"
---
![img-description](/assets/DocumentacionHacking/InyeccionSQL.png)

En esta sección, exploraremos el funcionamiento de la inyección SQL, una de las vulnerabilidades más comunes en los dominios web. La inyección SQL permite a un atacante interferir con las consultas que una aplicación hace a su base de datos, lo que puede resultar en la exposición de datos sensibles, la modificación de datos o incluso la ejecución de comandos en el servidor.

## Para comenzar
---

Para comenzar, debemos tener en cuenta cómo funciona una inyección y por qué funciona así. Para comprender cómo funciona la inyección SQL, estaremos trabajando con la plataforma:

https://portswigger.net/web-security

En este caso, accedemos a la sección de all-labs.

![img-description](/assets/DocumentacionHacking/portswigger.png)

En esta plataforma, podemos practicar con diversos ejercicios.

----
## !! Entrando en materia !!

Debemos tener como marco de referencia la estructura que compone una página web del lado del backend.

![img-description](/assets/DocumentacionHacking/estructura.png)

En este caso la estructura es la Base de datos -> Tablas -> Columnas -> Datos

Una inyección SQL funciona cuando las entradas proporcionadas por el usuario se tratan como comandos SQL válidos.
Una de las consultas más comunes es:

``` sql
or 1=1-- -
```

¿Por qué funciona? Bueno, esta consulta lo que hace es que, como es de carácter True, es decir, como verdadero ya que 1=1 es correcto, tomará como verdadero todo lo que uno ponga después de esa inyección.

Al momento de querer ejecutar una inyección SQL en una página web, debemos tener en cuenta cómo funciona una consulta a la base de datos por detrás.

``` sql
SELECT * FROM Productos WHERE Categories '___' released=1
```

En este caso, el espacio '__' en blanco de la consulta es donde nosotros insertaremos la inyección SQL.

## Comenzando 

Uno de los pasos mas importantes a la hora de ejecutar una SQL inyection es que debemos de encontrar el numero de  columnas que tiene la tabla a la que queremos hacer la inyeccion
Esto es asi por que despues de que nosotros encontramos el numero de columnas en la tabla, podemos hacer uso de un union select el cual lo que hace es convinar las columnas,para que de esta manera nosotros podamos obtener la informacion que necesitemos


Algo que podemos hacer para saber cuantas columnas tiene una tabla es jugar con el comando


``` sql
order by 4-- -
```

Esta parte de la consulta SQL lo que hace es ordenar los resultados de la consulta según la cuarta columna en el conjunto de resultados. 

**`--`**: Este es un comentario en línea en SQL. Todo lo que sigue después de `--` en la misma línea será ignorado por el motor de busqueda de la base de datos. En este caso, `-- -` hace que cualquier cosa después de `--` sea ignorada.

![Texto alternativo](/assets/DocumentacionHacking/Comando.png)


Como podemos ver nos da un error en la pagina por que el numero de columnas que colocamos no coincide con el numero de columnas que esta por detras , para este caso jugaremos con el numero hasta encontrar en que momento no nos da el error 

![Texto alternativo](/assets/DocumentacionHacking/comandoCorrecto.png)

Como podemos ver ya no nos marca el error, lo que quiere decir que este numero si coincide con el numero de columnas de la tabla de la base de datos que esta pagina tiene.

![Texto alternativo](/assets/DocumentacionHacking/union.png)


En este caso colocamos los null , para cada columna, es decir si hubiesen sido 4 columnas tendriamos que poner 4 NULL 


En este caso en los NULL son las columnas de la base de datos,debemos de ver que columna es inyectable 

![Texto alternativo](/assets/DocumentacionHacking/columnasInyec.png)



----
### Como ver la informacion de la base de datos 

En este punto nosotros tenemos que hacer uso del comando: 

``` sql
    union select 1, schema_name from information_schema.schemata-- -
```

Este comando se usa para ver  las bases de datos disponibles en un servidor 

![Texto alternativo](/assets/DocumentacionHacking/comandoAplicado.png)


Debemos de tener en cuenta que para extraer la informacion que necesitamos debemos de hacer uso de comandos sql  

![Texto alternativo](/assets/DocumentacionHacking/proceso.png)

En este caso, lo que buscamos es la contraseña del usuario administrador. Para esto, buscamos las tablas que tengan relación con el usuario. Encontramos una tabla llamada `public`, y al listar su contenido, encontramos una columna llamada `users`. Realizamos una búsqueda en esta columna.

``` sql

union select NULL,column_name from information_schema.columns where table_schema='public' and table_name='users'-- -

```

De esta manera podemos ver los campos que esta tabla contiene 


![Texto alternativo](/assets/DocumentacionHacking/info.png)


Hay ocaciones en que el group_concat() no lo va a aceptar el navegador para este caso podemos tratar de compactar los datos que queremos ver 
para eso podemos hacer uso de `||':'||` en la consulta


``` sql
union select NULL,username||':'||password from users-- -
``` 

Y como podemos ver ya nos da el username y el password en una sola linea 


![Texto alternativo](/assets/DocumentacionHacking/user-passw.png)

Y listo, ya tenemos  el password del administrator 
y podemos acceder con sus credenciales

![Texto alternativo](/assets/DocumentacionHacking/LabFi.png)
