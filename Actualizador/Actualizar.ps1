#Settings
$WebClient = New-Object System.Net.WebClient

###### For all PCs ######
#Report
Get-ComputerInfo >> "$env:temp\$env:computername.log"
(New-Object System.Net.WebClient).UploadFile('https://www.mistrelci.com.ar/Script/upload.php', $env:temp + '\'+ $env:computername + '.log')

#Updating Script
if ([decimal](get-content "$PSScriptRoot\version") -le 2.31){
# Ubicación del script
$scriptPath = "$env:windir\Jeremos-Software\run.ps1"

# Define el nombre y la descripción de la tarea
$taskName = "Jeremos Software Update"
$taskDescription = "Inicia relevo"

# Crea una acción para ejecutar el script .ps1
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`""

# Define el desencadenador para que se ejecute al iniciar el equipo
$trigger = New-ScheduledTaskTrigger -AtStartup

# Configura la tarea con el desencadenador y la acción
$task = Register-ScheduledTask -TaskName $taskName -Trigger $trigger -Action $action -Description $taskDescription -User "NT AUTHORITY\SYSTEM"

# Ejecuta la tarea ahora
start-process "powershell" -ArgumentList "Start-Sleep -Seconds 10; Start-ScheduledTask -TaskName $taskName"
echo "2.32" -OutFile "$PSScriptRoot\version"
$WebClient.DownloadFile("https://raw.githubusercontent.com/jeremiassamuelzitnik/Updater/main/Instalador/Assets/run.ps1", "$env:windir\Jeremos-Software\run.ps1")

}
###### For selected PCs ######

if ($env:computername -eq 'GAMER') {
#For GAMER PC

}

if ($env:computername -eq 'NOTEBOOK') {
#For NOTEBOOK PC

}

else {
# Other PCs

}


#powershell "iwr -useb https://raw.githubusercontent.com/jeremiassamuelzitnik/Updater/main/Instalador/Instalar.ps1 | iex" 
#get-wuinstall -MicrosoftUpdate -install -AcceptAll -IgnoreReboot | Out-File $env:public\desktop\acta-$env:computername.log
