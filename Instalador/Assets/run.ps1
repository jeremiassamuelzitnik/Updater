cd $PSScriptRoot
while ($true -eq $true) 
{
wget https://raw.githubusercontent.com/jeremiassamuelzitnik/Updater/main/Actualizador/Version.txt -OutFile "$PSScriptRoot\version"
$versionGit=get-content "$PSScriptRoot\Version"
$versionLocal=get-content "$PSScriptRoot\version.old"
if ([decimal]$versionLocal -lt [decimal]$versionGit)
{
#Si est� desactualizado.
iwr -useb https://github.com/jeremiassamuelzitnik/Updater/raw/main/Actualizador/Actualizar.ps1 | iex
copy-item $PSScriptRoot\Version -destination $PSScriptRoot\Version.old 

timeout /t 50
}
else {
#Si est� actualizado

timeout /t 400

}
}
exit
