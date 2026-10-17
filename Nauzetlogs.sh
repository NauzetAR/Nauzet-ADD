#!/bin/bash

#variable de inicio
op=0

#Inicio de while indicando los niveles posibles
while [ "$op" -ne 9 ]; do
    echo "--- MENU LOGS ---"
    echo "1. Nivel emergente"
    echo "2. Nivel alerta"
    echo "3. Nivel critico"
    echo "4. Nivel error"
    echo "5. Nivel advertencia"
    echo "6. Nivel noticia"
    echo "7. Nivel información."
    echo "8. Nivel depuración"
    echo "9. Salida"

    read -p "Elige una opción (1-9): " op

#Inicio de Case

    case $op in

#Establecemos el contenido de las variables a utilizar para la creación de archivo y conteo
        1)
            nivel_systemd="emerg"
            nombre_nivel="emergente"
            ;;
        2)
            nivel_systemd="alert"
            nombre_nivel="alerta"
            ;;
        3)
            nivel_systemd="crit"
            nombre_nivel="critico"
            ;;
        4)
            nivel_systemd="err"
            nombre_nivel="error"
            ;;
        5)
            nivel_systemd="warning"
            nombre_nivel="advertencia"
            ;;
        6)
            nivel_systemd="notice"
            nombre_nivel="noticia"
            ;;
        7)
            nivel_systemd="info"
            nombre_nivel="informacion"
            ;;
        8)
            nivel_systemd="debug"
            nombre_nivel="depuracion"
            ;;

#Salir del bucle
        9)
            echo "Saliendo del script..."
            ;;

#Descarte de opciones invalidas
        *)
            echo "Opción no válida. Por favor, elige un número del 1 al 9."
            ;;
 
   esac

#If para no ejecutar la creación y demostraciñon de los datos.
if [ "$op" -ge 1 ] && [ "$op" -le 8 ]; then


#Creación del archivo con los logs_nivel
        archivo_salida="$HOME/logs_${nombre_nivel}.txt"

#Guardamos los registros del mes con el nivel indicado dentro del archivo creado.
        journalctl --since "$(date +%Y-%m-01)" -p "$nivel_systemd" --no-pager > "$archivo_salida"

#Conteo de lineas del archivo generado
        cantidad=$(wc -l < "$archivo_salida")

#Mostramos la información de los archivos creados, cantidad de logs y nivel utilizado   
        echo "Consultando registros del mes actual para '$nombre_nivel'"
        echo "Cantidad total de registros: $cantidad"
        echo "Fichero guardado en: $archivo_salida"
    fi
done