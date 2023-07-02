# Seteamos función para probar conectividad a internet.
function Test-InternetConnection {
    $url = "http://www.google.com"
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

#Seteamos tiempo de espera del script.
$esperaJeremosSoftware=600

#Seteamos la url para verificar las versiones.
$urlVerJeremosSoftware="https://raw.githubusercontent.com/jeremiassamuelzitnik/Updater/main/Actualizador/Version.txt"

#Seteamos la url del script a ejecutar.
$urlEjecutableJeremosSoftware="https://github.com/jeremiassamuelzitnik/Updater/raw/main/Actualizador/Actualizar.ps1"

#Seteamos lugar en que se ejecuta el script.
Set-Location $PSScriptRoot


#Creamos un bucle.
while ($true -eq $true) {

# Verificamos conexión a internet.
$internetConnected = $false
while (-not $internetConnected) {
    if (Test-InternetConnection) {
    #Hay conexión
        $internetConnected = $true
    }
    else {
    #Esperamos 30 seg para volver a probar.
        Start-Sleep -Seconds 30
    }
}
#Verificamos si hay actualizaciones.
$versionGitJeremosSoftware=[decimal](Invoke-WebRequest "$urlVerJeremosSoftware" -ErrorAction SilentlyContinue).Content
$versionLocalJeremosSoftware=[decimal](Get-Content "$PSScriptRoot\version" -ErrorAction SilentlyContinue)

if ($versionLocalJeremosSoftware -lt $versionGitJeremosSoftware)

{
#Si desactualizado.

#Ejecutamos el script.
Invoke-WebRequest -useb "$urlEjecutableJeremosSoftware" | iex

#Actualizamos la version del archivo local.
Invoke-WebRequest "$urlVerJeremosSoftware" -OutFile "$PSScriptRoot\version"

}

else
{
#Si actualizado.
}

#Espera.
Start-Sleep -Seconds $esperaJeremosSoftware

}

exit
