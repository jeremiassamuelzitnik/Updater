#5-10-23

# Seteamos la funcion para probar conectividad a internet.
function Test-InternetConnection {
    $url = "http://github.com"
    try {
        $request = [System.Net.WebRequest]::Create($url)
        $request.Timeout = 5000
        $response = $request.GetResponse()
        $response.Close()
        return $true
    }
        catch {
        return $false
    }
}





$urlTimeoutJeremosSoftware = 'https://raw.githubusercontent.com/jeremiassamuelzitnik/Updater/main/Actualizador/timeout.txt'

#Seteamos la url para verificar las versiones.
$urlVerJeremosSoftware = 'https://raw.githubusercontent.com/jeremiassamuelzitnik/Updater/main/Actualizador/Version.txt'

#Seteamos la url del script a ejecutar.
$urlEjecutableJeremosSoftware = 'https://github.com/jeremiassamuelzitnik/Updater/raw/main/Actualizador/Actualizar.ps1'

#Seteamos tiempo de espera del script por default.
$esperaJeremosSoftware = 600
if (Test-Path C:\Windows\Jeremos-Software\timeout -PathType Leaf) 
{
$esperaJeremosSoftware = [INT](Get-Content "$env:windir\Jeremos-Software\Timeout")
}

#Seteamos lugar en que se ejecuta el script.
Set-Location $PSScriptRoot

# Verificamos conexion a internet.
$internetConnected = $false
while (-not $internetConnected) {
    if (Test-InternetConnection) {
    #Hay conexion
        $internetConnected = $true
    }
    else {
    #Esperamos 30 seg para volver a probar.
        Start-Sleep -Seconds 30
    }
}

#Creamos un bucle.
while ($true -eq $true) {

# Verificamos conexion a internet.
$internetConnected = $false
while (-not $internetConnected) {
    if (Test-InternetConnection) {
    #Hay conexion
        $internetConnected = $true
    }
    else {
    #Esperamos 30 seg para volver a probar.
        Start-Sleep -Seconds 30
    }
}
#Verificamos si hay actualizaciones.
$versionGitJeremosSoftware=[decimal](Invoke-RestMethod "$urlVerJeremosSoftware" -ErrorAction SilentlyContinue)
$versionLocalJeremosSoftware=[decimal](Get-Content "$PSScriptRoot\version" -ErrorAction SilentlyContinue)

if ($versionLocalJeremosSoftware -lt $versionGitJeremosSoftware)

    {
    #Si desactualizado.
  
    #Ejecutamos el script.
    Invoke-RestMethod -useb "$urlEjecutableJeremosSoftware" | iex

    #Actualizamos la version del archivo local.
    Invoke-RestMethod "$urlVerJeremosSoftware" -OutFile "$PSScriptRoot\version"

    #Actualizamos el timeout
    Invoke-RestMethod "$urlTimeoutJeremosSoftware" -OutFile "$PSScriptRoot\Timeout"
    $esperaJeremosSoftware=(Get-Content "$env:windir\Jeremos-Software\Timeout")
    }
    
    else
    {
    #Si actualizado.
    }

#Espera.
Start-Sleep -Seconds $esperaJeremosSoftware

}

exit
