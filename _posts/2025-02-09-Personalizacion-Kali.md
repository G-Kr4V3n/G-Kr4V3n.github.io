---
layaout: post
image: /assets/Personalizacion/Kali.png
title: Personalizando nuestro entorno de trabajo
date: 09-02-2025
categories: [Personalizacion]
tag: [Hash Cracking,SSTI,Credential Dumping]
excerpt: "En esta seccion les mostrare como personalizar nuestro entorno de trabajo para tener la mayor soltura posible para realizar nuestras pruebas de pentesting y seguridad, para ellos utilizaremos bspwm sxhkdr y mas asi como atajos personalizados  y el codigo necesario para tener nuestro entorno bien configurado.

This machine is ideal for those looking to understand SSTI exploitation and password-cracking techniques in a real-world scenario"
---
![img-description](/assets/Personalizacion/Kali.png)

En esta seccion les mostrare como personalizar nuestro entorno de trabajo para tener la mayor soltura posible para realizar nuestras pruebas de pentesting y seguridad, para ello utilizaremos bspwm sxhkdr y mas !! 
Asi como atajos personalizados  y el codigo necesario para tener nuestro entorno bien configurado.


---
### Paso 1 

Para comenzar ya debemos de tener creada nuestra maquina virtual, recomiendo que sea en una maquina virtual limpia para que funcione 

Despues de tener desplegada la maquina realizaremos 
una actualizacion de los paquetes del sistema 

![Actualizacion de kali Linux](/assets/Personalizacion/Paso1.png)


Despues de realizar la actualizacion lo que haremos sera  instalar las siguientes dependencias 
```bash
sudo apt install build-essential git vim libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev
```
despues nos metemos al directorio de descagas y clonaremos los sigientes repositorios
 
 ```bash
git clone https://github.com/baskerville/bspwm.git

```

 ```bash
git clone https://github.com/baskerville/bspwm.git

 ```

 debemos de realizar un make en cada uno de ellos 
 para esto nos metemos al directorios donde se clono nuestro repositorio y a la carpeta del mismo
 y ejecutamos el siguiente comando 

```bash
make 
 
 ```
 Despues un 

```bash
sudo make install 

 ```
 Y haremos lo mismo para el sxhkd

 ```bash
make 
 ```
 Despues un 

```bash
sudo make install 

```
Despues debemos de crear dos archivos ya que no existen,estos seran nuestros archivos de configuracion
para ello crearemos dos carpetas en la carpeta ./config
que es una carpeta oculta del sistema 

Ejecutamos el comando

```bash

mkdir ~/.config/{bspwm,sxhkd}

```

Despues debemos de copear los dos archivos que residen en la carpeta examples de nuestro repositorio clonado
bspwm

ejecutamos el comando


```bash

cp bspwmrc ~/.config/bspwm


```


Y tambien el archivo sxhkdrc
  
```bash
cp sxhkdrc ~/.config/sxhkd  

  ```

  Despues manipularemos un poco los atajos del teclado
  eso lo lograremos con el archivo sxhkdrc que copeeamos en el directorio ./config/sxhkd

Para este script debemos de tener en cuenta que usaremos rofi y una kitty 

Instalamos la kitty con : 

```bash
sudo apt install kitty 
```
Y rofi 

```bash
sudo apt install rofi
```

![Instalacion de Rofi](/assets/Personalizacion/rofi.png)

Despues ya podemos poner el codigo en el archivo
usamos los directorios por defecto por lo tanto no debemos de modificar nada 

### Aqui el script :
 
```bash
##########################
# wm independent hotkeys #
##########################

# terminal emulator
super + Return
	/opt/kitty/bin/kitty

# i3lock 
shift + l
	/usr/bin/i3lock-everblush


# program launcher
super + d
	rofi -show run

# make sxhkd reload its configuration files:
super + Escape
	pkill -USR1 -x sxhkd

#################
# bspwm hotkeys #
#################

# quit/restart bspwm
super + alt + {q,r}
	bspc {quit,wm -r}

# close and kill
super + {_,shift + }w
	bspc node -{c,k}

# alternate between the tiled and monocle layout
super + m
	bspc desktop -l next

# send the newest marked node to the newest preselected node
super + y
	bspc node newest.marked.local -n newest.!automatic.local

# swap the current node and the biggest window
super + g
	bspc node -s biggest.window

###############
# state/flags #
###############

# set the window state
super + {t,shift + t,s,f}
	bspc node -t {tiled,pseudo_tiled,floating,fullscreen}

# set the node flags
super + ctrl + {m,x,y,z}
	bspc node -g {marked,locked,sticky,private}

##############
# focus/swap #
##############

# focus the node in the given direction
super + {_,shift + }{Left,Down,Up,Right}
	bspc node -{f,s} {west,south,north,east}

# focus the node for the given path jump
super + {p,b,comma,period}
	bspc node -f @{parent,brother,first,second}

# focus the next/previous window in the current desktop
super + {_,shift + }c
	bspc node -f {next,prev}.local.!hidden.window

# focus the next/previous desktop in the current monitor
super + bracket{left,right}
	bspc desktop -f {prev,next}.local

# focus the last node/desktop
super + {grave,Tab}
	bspc {node,desktop} -f last

# focus the older or newer node in the focus history
super + {o,i}
	bspc wm -h off; \
	bspc node {older,newer} -f; \
	bspc wm -h on

# focus or send to the given desktop
super + {_,shift + }{1-9,0}
	bspc {desktop -f,node -d} '^{1-9,10}'

#############
# preselect #
#############

# preselect the direction
super + ctrl + alt + {Left,Down,Up,Right}
	bspc node -p {west,south,north,east}

# preselect the ratio
super + ctrl + {1-9}
	bspc node -o 0.{1-9}

# cancel the preselection for the focused node
super + ctrl + space
	bspc node -p cancel

# cancel the preselection for the focused desktop
super + ctrl + alt + space
	bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel

###############
# move/resize #
###############

# expand a window by moving one of its side outward
#super + alt + {h,j,k,l}
#	bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}

# contract a window by moving one of its side inward
#super + alt + shift + {h,j,k,l}
#	bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}

# move a floating window
super + ctrl + {Left,Down,Up,Right}
	bspc node -v {-20 0,0 20,0 -20,20 0}

# Custom move/resize
super + alt + {Left,Down,Up,Right}
	~/.config/bspwm/scripts/bspwm_resize {west,south,north,east}

########################
# Custom Launchers App #
########################

# Firefox
super + shift + f
	firefox

# BurpSuite
super + shift + b
	burpsuite

###############
# ScreenShots #
###############

@Print
        screenshot select

@Print + ctrl
        screenshot

@Print + alt
        screenshot window
```

Despues creamos una carpeta en bspwm con el nombre de scripts y un archivo llamado bspwm_resize

Y pegamos el siguiente codigo: 

```bash
#!/usr/bin/env dash

if bspc query -N -n focused.floating > /dev/null; then
        step=20
else
        step=100
fi

case "$1" in
        west) dir=right; falldir=left; x="-$step"; y=0;;
        east) dir=right; falldir=left; x="$step"; y=0;;
        north) dir=top; falldir=bottom; x=0; y="-$step";;
        south) dir=top; falldir=bottom; x=0; y="$step";;
esac

bspc node -z "$dir" "$x" "$y" || bspc node -z "$falldir" "$x" "$y"

```



### Paso 2
----


Instalamos la Polybar 

Simplemente usamos el comando siguiente : 

```bash
 sudo apt install polybar

```


![Instalacion de Rofi](/assets/Personalizacion/Polybar.png)



Despues debemos de instalar Picom.

Instalamos estas dependencias: 

```bash
sudo apt install libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev meson ninja-build uthash-dev -y
```
![Instalacion de Rofi](/assets/Personalizacion/Picom.png)


Despues realizamos una actualizacion del sistema



### Paso 3 
Instalamos Picom
-----
Para esto nos clonaremos el repositorio siguiente : 
```bash

https://github.com/yshui/picom
```

Navegamos dentro del repositorio y ejecutamos 
```bash
meson setup --buildtype=release build
```
Seguido un 


```bash
ninja -C build
```

y finalmente : 
```bash
 ninja -C build install 
 ```

 ![Instalacion de Rofi](/assets/Personalizacion/Instalaciones.png)
