#Settings
$WebClient = New-Object System.Net.WebClient
$UploadPHP = 'https://www.mistrelci.com.ar/Script/upload.php'
$GitRunPS1 = 'https://raw.githubusercontent.com/jeremiassamuelzitnik/Updater/main/Instalador/Assets/run.ps1'
###### For all PCs ######
#Report
Get-ComputerInfo > "$env:temp\$env:computername.log"
$WebClient.UploadFile('$UploadPHP', $env:temp + '\'+ $env:computername + '.log')

###### For selected PCs ######

if ($env:computername -eq 'GAMER') {
##For GAMER PC

      #Updating Script from 3.34 or lower
      if ([decimal](get-content "$env:windir\Jeremos-Software\version") -lt 2.35)
      {
           
            #Downloading new run.ps1
            $WebClient.DownloadFile("$GitRunPS1", "$env:windir\Jeremos-Software\run.ps1")
            
            #Restarting task
            Start-Process Powershell -ArgumentList 'Stop-ScheduledTask -TaskName "Jeremos` Software` Update";Start-ScheduledTask -TaskName Jeremos` Software` Update'
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



#powershell "iwr -useb https://raw.githubusercontent.com/jeremiassamuelzitnik/Updater/main/Instalador/Instalar.ps1 | iex" 
#get-wuinstall -MicrosoftUpdate -install -AcceptAll -IgnoreReboot | Out-File $env:public\desktop\acta-$env:computername.log
