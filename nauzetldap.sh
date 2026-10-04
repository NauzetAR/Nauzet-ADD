#Variable de dominio
dominio="dc=nauzet2026,dc=ldap"
op=3

#Inicio de while
while [ "$op" -ne 4 ]; do
    echo "--- MENU LDAP ---"
    echo "1. Eliminar correo de un usuario"
    echo "2. Modificar el correo de un usuario"
    echo "3. Búsqueda de usuarios"
    echo "4. Salir"
    read -p "Elige una opción (1-4): " op

#Inicio de Case

    case $op in

#Eliminar correo
        1)
            read -p "Introduce el UID del usuario (ej: nombrealu1): " uid_1
            read -p "Introduce la OU (Alumnado o Profesorado): " ou_1

            # Crear archivo temporal LDIF para eliminar el atributo mail
            echo "dn: uid=$uid_1,ou=$ou_1,$dominio" > temp_correo.ldif
            echo "changetype: modify" >> temp_correo.ldif
            echo "delete: mail" >> temp_correo.ldif

            # Aplicar los cambios en LDAP y borrar el archivo temporal
            ldapmodify -x -D "cn=admin,$dominio" -W -f temp_correo.ldif
            rm -f temp_correo.ldif
            ;;

#Cambiar correo de usuario
        2)
            read -p "Introduce el UID del usuario (ej: nombrealu2): " uid_2
            read -p "Introduce la OU (Alumnado o Profesorado): " ou_2
            read -p "Introduce el nuevo correo: " correo

            # Crear archivo temporal LDIF para reemplazar el atributo mail
            echo "dn: uid=$uid_2,ou=$ou_2,$dominio" > temp_cambio.ldif
            echo "changetype: modify" >> temp_cambio.ldif
            echo "replace: mail" >> temp_cambio.ldif
            echo "mail: $correo" >> temp_cambio.ldif

            # Aplicar los cambios en LDAP y borrar el archivo temporal
            ldapmodify -x -D "cn=admin,$dominio" -W -f temp_cambio.ldif
            rm -f temp_cambio.ldif
            ;;
#Mostrar usuarios
        3)
            echo "1. Ver un usuario"
            echo "2. Ver todos (nombre y correo)"
            read -p "Elige subopción (1 o 2): " sub

            if [ "$sub" == "1" ]; then
                read -p "Introduce el UID: " uid_3
                ldapsearch -x -b "$dominio" "(uid=$uid_3)" cn mail
            else
                ldapsearch -x -b "$dominio" "(objectClass=inetOrgPerson)" cn mail
            fi
            ;;

#Salir del bucle
        4)
            echo "Saliendo del script..."
            ;;

#Descarte de opciones invalidas
        *)
            echo "Opción no válida. Por favor, elige un número del 1 al 4."
            ;;
    esac
done
