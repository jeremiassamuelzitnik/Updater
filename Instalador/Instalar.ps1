# Creamos la carpeta
New-Item "$env:windir\Jeremos-Software\" -ItemType Directory
# Descargamos el script
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://raw.githubusercontent.com/jeremiassamuelzitnik/Updater/main/Instalador/Assets/run.ps1", "$env:windir\Jeremos-Software\run.ps1")

# Seteamos la ubicación del script
$scriptPath = "$env:windir\Jeremos-Software\run.ps1"

# Seteamos el nombre y la descripción de la tarea
$taskName = "Jeremos Software Update"
$taskDescription = "Inicia relevo"

# Seteamos una acción para ejecutar el script .ps1
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`""

# Seteamos el desencadenador para que se ejecute al iniciar el equipo
$trigger = New-ScheduledTaskTrigger -AtStartup

# Configuramos la tarea con el desencadenador y la acción
$task = Register-ScheduledTask -TaskName $taskName -Trigger $trigger -Action $action -Description $taskDescription -User "NT AUTHORITY\SYSTEM"

# Ejecutamos la tarea ahora
Start-ScheduledTask -TaskName $taskName
