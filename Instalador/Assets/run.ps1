#Seteamos tiempo de espera del script.
$esperaJeremosSoftware=600

#Seteamos la url para verificar las versiones.
$urlVerGitJeremosSoftware="https://raw.githubusercontent.com/jeremiassamuelzitnik/Updater/main/Actualizador/Version.txt"

#Seteamos la url del script a ejecutar.
$urlEjecutableJeremosSoftware="https://github.com/jeremiassamuelzitnik/Updater/raw/main/Actualizador/Actualizar.ps1"

#Seteamos lugar en que se ejecuta el script.
Set-Location $PSScriptRoot


#Verificamos si existen actualizaciones con respecto a nuestro proyecto de GitHub.
while ($true -eq $true) 
{
$versionGitJeremosSoftware=[decimal](wget "$urlVerGitJeremosSoftware" -ErrorAction SilentlyContinue).Content
$versionLocalJeremosSoftware=[decimal](Get-Content "$PSScriptRoot\version" -ErrorAction SilentlyContinue)

if ($versionLocalJeremosSoftware -lt $versionGitJeremosSoftware)

{
#Si desactualizado.

#Ejecutamos el script.
iwr -useb "$urlEjecutableJeremosSoftware" | iex

#Actualizamos la version del archivo local.
wget "$urlVerGitJeremosSoftware" -OutFile "$PSScriptRoot\version"

}

else
{
#Si actualizado.
}

#10 minutos de espera.
timeout /t $esperaJeremosSoftware

}

exit
