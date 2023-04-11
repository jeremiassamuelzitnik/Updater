#Seteamos tiempo de espera del script.
$esperaJeremosSoftware=600

#Seteamos la url para verificar las versiones.
$urlGitJeremosSoftware="https://raw.githubusercontent.com/jeremiassamuelzitnik/Updater/main/Actualizador/Version.txt"

#Seteamos la url del script a ejecutar.
$scriptEjecutableJeremosSoftware="https://github.com/jeremiassamuelzitnik/Updater/raw/main/Actualizador/Actualizar.ps1"

#Seteamos lugar en que se ejecuta el script.
Set-Location $PSScriptRoot


#Verificamos si existen actualizaciones con respecto a nuestro proyecto de GitHub.
while ($true -eq $true) 
{
$versionGitJeremosSoftware= [decimal](wget "$urlGitJeremosSoftware" -ErrorAction SilentlyContinue).Content
$versionLocalJeremosSoftware=[decimal](Get-Content "$PSScriptRoot\version" -ErrorAction SilentlyContinue)

if ($versionLocalJeremosSoftware -lt $versionGitJeremosSoftware)

{
#Si desactualizado.

#Ejecutamos el script.
iwr -useb "$scriptEjecutableJeremosSoftware" | iex

#Actualizamos la version del archivo local.
wget "$urlGitJeremosSoftware" -OutFile "$PSScriptRoot\version"

}

else
{
#Si actualizado.
}

#10 minutos de espera.
timeout /t $esperaJeremosSoftware

}

exit
