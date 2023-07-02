#Seteamos tiempo de espera del script.
$esperaJeremosSoftware=600

#Seteamos la url para verificar las versiones.
$urlVerJeremosSoftware="https://raw.githubusercontent.com/jeremiassamuelzitnik/Updater/main/Actualizador/Version.txt"

#Seteamos la url del script a ejecutar.
$urlEjecutableJeremosSoftware="https://github.com/jeremiassamuelzitnik/Updater/raw/main/Actualizador/Actualizar.ps1"

#Seteamos lugar en que se ejecuta el script.
Set-Location $PSScriptRoot


#Verificamos si existen actualizaciones con respecto a nuestro proyecto de GitHub.
while ($true -eq $true) 
# Function to check internet connectivity
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

# Check internet connectivity
$internetConnected = $false

while (-not $internetConnected) {
    if (Test-InternetConnection) {
        $internetConnected = $true
        Write-Host "Internet connection is available. Proceeding with the script."

        # Your code goes here
        # For example, you can add your commands or functions here.

    }
    else {
        Write-Host "No internet connection available. Waiting for 30 seconds to recheck..."
        Start-Sleep -Seconds 30
    }
}

# Check internet connectivity
if (Test-InternetConnection) {
    Write-Host "Internet connection is available. Proceeding with the script."
    # Your code goes here
}
else {
    Write-Host "No internet connection available. Please check your internet connection and try again."
    # Additional actions or error handling if needed
}

{
$versionGitJeremosSoftware=[decimal](wget "$urlVerJeremosSoftware" -ErrorAction SilentlyContinue).Content
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

#10 minutos de espera.
timeout /t $esperaJeremosSoftware

}

exit
