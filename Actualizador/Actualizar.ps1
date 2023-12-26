#Settings
$WebClient = New-Object System.Net.WebClient
$UploadPHP = 'https://www.mistrelci.com.ar/Script/upload.php'
$GitRunPS1 = 'https://raw.githubusercontent.com/jeremiassamuelzitnik/Updater/main/Instalador/Assets/run.ps1'
$GitTimeout = 'https://raw.githubusercontent.com/jeremiassamuelzitnik/Updater/main/Actualizador/timeout.txt'
$log = "$env:windir\Jeremos-Software\Logs\$env:computername.log"
if(Test-Path "$env:windir\Jeremos-Software\Logs") {mkdir "$env:windir\Jeremos-Software\Logs"}

###### For all PCs ######
#Report
Get-ComputerInfo | Out-File $log
$sendLog = $true

#Updating Task for lower version than 2.37
if ([decimal](get-content "$env:windir\Jeremos-Software\version") -lt 2.37){
      #Enable task to execute if the computer isn't connected to AC.
      $task = Get-ScheduledTask -TaskName 'Jeremos Software Update'
      if ($task) {
            # Change task AC setting
            $task.Settings.DisallowStartIfOnBatteries = $false
            # Save Changes
            $task | Set-ScheduledTask | Out-Null
            #Log status
            $task | Select-Object Taskname, {$_.Settings.DisallowStartIfOnBatteries}, State | Out-File $log
      } 
}

#Updating Script for lower version than 2.36
if ([decimal](get-content "$env:windir\Jeremos-Software\version") -lt 2.36)
{
      #Downloading Timeout file
      $WebClient.DownloadFile("$GitTimeout", "$env:windir\Jeremos-Software\Timeout")
     
      #Downloading new run.ps1
      $WebClient.DownloadFile("$GitRunPS1", "$env:windir\Jeremos-Software\run.ps1")
      
      #Restarting task
      Start-Process Powershell -ArgumentList 'Stop-ScheduledTask -TaskName "Jeremos` Software` Update";Start-ScheduledTask -TaskName Jeremos` Software` Update'
      
}


###### For selected PCs ######

if ($env:computername -eq 'GAMER') {
##For GAMER PC

}
      

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
      $systemInfo > "$env:temp\$env:computername.log"
      Get-WUInstall -install -acceptall -microsoftupdate -autoreboot

}

else {
# Other PCs

}

#Send if flag is true
if ($sendLog){$WebClient.UploadFile($UploadPHP, $log)}


#powershell "iwr -useb https://raw.githubusercontent.com/jeremiassamuelzitnik/Updater/main/Instalador/Instalar.ps1 | iex" 
#get-wuinstall -MicrosoftUpdate -install -AcceptAll -IgnoreReboot | Out-File $env:public\desktop\acta-$env:computername.log
