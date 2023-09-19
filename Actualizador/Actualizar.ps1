#Settings
$WebClient = New-Object System.Net.WebClient

###### For all PCs ######
#Report
Get-ComputerInfo > "$env:temp\$env:computername.log"
$WebClient.UploadFile('https://www.mistrelci.com.ar/Script/upload.php', $env:temp + '\'+ $env:computername + '.log')


#Updating 2.32
if ([decimal](get-content "$env:windir\Jeremos-Software\version") -eq 2.32)
{
pause
Start-Sleep -Seconds 10
# Removing old service
."$env:windir\Jeremos-Software\nssm.exe" stop "Jeremos Software Update" confirm
."$env:windir\Jeremos-Software\nssm.exe" remove "Jeremos Software Update" confirm
}

#Updating Script from 3.1
if ([decimal](get-content "$env:windir\Jeremos-Software\version") -eq 2.31)
{

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

# Downloading new Run.ps1
$WebClient.DownloadFile("https://raw.githubusercontent.com/jeremiassamuelzitnik/Updater/main/Instalador/Assets/run.ps1", "$env:windir\Jeremos-Software\run.ps1")

# Ejecuta la tarea ahora
'2.32' | Out-File -FilePath "$env:windir\Jeremos-Software\version"
start-process "powershell" -ArgumentList "Start-ScheduledTask -TaskName $taskName"

# Stoping old service
Stop-Service 'Jeremos Software Update' -Force
}



###### For selected PCs ######

if ($env:computername -eq 'GAMER') {
#For GAMER PC
      
      
      
      if ($env:computername -eq 'NOTEBOOK') {
      #For NOTEBOOK PC
      
      # Crear un objeto personalizado para almacenar la información
      $systemInfo = New-Object PSObject -Property @{
          BaseboardSerial = ""
          CPUSerial = ""
          RAMSerials = @()
          MonitorSerials = @()
          DiskSerials = @()
          BIOSSerial = ""
          USBDeviceSerials = @()
      }
      
      # Obtener el número de serie de la placa base
      $baseboard = Get-WmiObject -Class Win32_BaseBoard
      $systemInfo.BaseboardSerial = $baseboard.SerialNumber
      
      # Obtener el número de serie de la CPU
      $cpu = Get-WmiObject -Class Win32_Processor
      $systemInfo.CPUSerial = $cpu.ProcessorId
      
      # Obtener el número de serie de la memoria RAM
      $ram = Get-WmiObject -Class Win32_PhysicalMemory
      $systemInfo.RAMSerials = $ram | ForEach-Object { $_.SerialNumber }
      
      # Obtener los números de serie de los monitores
      $monitors = Get-WmiObject -Namespace root\wmi -Class WmiMonitorID
      $systemInfo.MonitorSerials = $monitors | ForEach-Object { [System.Text.Encoding]::ASCII.GetString($_.SerialNumberID) }
      
      # Obtener los números de serie de los discos duros
      $disks = Get-WmiObject -Class Win32_DiskDrive
      $systemInfo.DiskSerials = $disks | ForEach-Object { $_.SerialNumber }
      
      # Obtener el número de serie de la BIOS
      $bios = Get-WmiObject -Class Win32_BIOS
      $systemInfo.BIOSSerial = $bios.SerialNumber
      
      # Obtener información de dispositivos USB
      $usbDevices = Get-WmiObject -Query "SELECT * FROM Win32_PnPEntity WHERE PNPClass = 'USB'"
      $usbDevicesWithSerial = $usbDevices | Where-Object { $_.SerialNumber -ne $null }
      
      # Agregar números de serie de dispositivos USB al objeto
      $systemInfo.USBDeviceSerials = $usbDevicesWithSerial | ForEach-Object { $_.SerialNumber }
      
      # Mostrar la información como objetos
      $systemInfo


}

else {
# Other PCs

}



#powershell "iwr -useb https://raw.githubusercontent.com/jeremiassamuelzitnik/Updater/main/Instalador/Instalar.ps1 | iex" 
#get-wuinstall -MicrosoftUpdate -install -AcceptAll -IgnoreReboot | Out-File $env:public\desktop\acta-$env:computername.log
