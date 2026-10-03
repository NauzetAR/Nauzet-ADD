Import-Module ActiveDirectory

#Obtención del dominio
$domain = (get-ADDomain).DistinguishedName

do {
    # 1) Mostrar el menú
    Write-Host "1. Información del dominio"
    Write-Host "2. Crear OU"
    Write-Host "3. Crear grupo"
    Write-Host "4. Crear usuario"
    Write-Host "5. Salir"
    
 # 2) Leer la opción
    $opcion = Read-Host "Elige una opción"

 # 3) Según la opción, hacer una cosa u otra
    switch ($opcion) {
 #Información del sistma
        "1" { 
              $NomEquipo = $env:COMPUTERNAME
              $NomDominio = (Get-ADDomain).DNSRoot
              $N_OU = (Get-ADOrganizationalUnit -Filter *).Count
              $N_Grupos = (Get-ADGroup -filter *).count
              $N_Usuarios = (Get-ADUser -filter *).count
              
              Write-Host "Nombre del Equipo: $NomEquipo" 
              Write-Host "Nombre del Dominio: $NomDominio"
              Write-Host "Cantidad de Unidades Organizativas (OU): $N_OU"
              Write-Host "Número de Grupos: $N_Grupos"
              Write-Host "Número de Usuarios: $N_Usuarios"   
            }
  #Creación de OU
        "2" { Write-Host "Aquí se creará la OU"
         
                 $NomOU = read-host "Ingrese el nombre del nuevo OU"
                 New-ADOrganizationalUnit -name $NomOU -Path $domain

              Write-Host "La OU $NomOU se a creado correctamente"  
            }
  #Creación de grupo
        "3" {    $NewGroup = read-host "Ingrese el nombre del nuevo grupo"
                 $PhatOU = read-host "Ingrese la ruta de guardado (Ejemplo: ou=nombre)"
                    $OU_Dominio = "$PhatOU,$domain"
                 $GrupoTipo = read-host "Ingrese el grupo de distribuicion (Ejemplo: Global)"
                 $GrupoCategoria = read-host "Ingrese la categoria deseada (Ejemplo: Security)"
             new-adgroup -name $NewGroup -GroupScope $GrupoTipo -GroupCategory $GrupoCategoria -Path $OU_Dominio
            }
  #Creación de usuario
        "4" {   $claveNewUser = Read-Host "Contraseña inicial" -AsSecureString
        
                 $NomNewUser = read-host "Ingrese el nombre del usurio"
                 $ApeNewUser = read-host "Ingrese el apellido del usurio"
                 $GMNewUser = read-host "Ingrese el correo del usurio"
                 $NomSesionNewUser = read-host "Ingrese el nombre del inicio de sesión"        
                 $OUNewUser = read-host "Ingrese la OU del usurio (Ejemplo: ou=nombre)"
                    $OUUser_domain = "$OUNewUser,$domain"
                 $GroupNewUser = read-host "Ingrese el grupo del usurio"
            
            New-ADUser -Name "$NomNewUser $ApeNewUser" -SamAccountName $NomSesionNewUser -UserPrincipalName $GMNewUser -Path $OUUser_domain -AccountPassword $claveNewUser -Enabled $true -ChangePasswordAtLogon $true 
            Add-ADGroupMember -Identity $GroupNewUser -Members $NomSesionNewUser
           }
  #Salida del menu
        "5" { Write-Host "Adiós" }
        default { Write-Host "Opción no válida" }
    }

} while ($opcion -ne "5") 
