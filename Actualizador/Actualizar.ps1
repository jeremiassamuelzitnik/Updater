#Settings
$WebClient = New-Object System.Net.WebClient
$UploadPHP = 'https://www.mistrelci.com.ar/Script/upload.php'
$GitRunPS1 = 'https://raw.githubusercontent.com/jeremiassamuelzitnik/Updater/main/Instalador/Assets/run.ps1'
$GitTimeout = 'https://raw.githubusercontent.com/jeremiassamuelzitnik/Updater/main/Actualizador/timeout.txt'
$defaultLog = "$env:windir\Jeremos-Software\Logs\$env:computername.log"
if (-not (Test-Path "$env:windir\Jeremos-Software\Logs")) {mkdir "$env:windir\Jeremos-Software\Logs"}

###### For all PCs ######
#Report
$formattedDate = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
Write-Output "LOG  $formattedDate>" | Out-File -FilePath "$defaultLog" -Append

#Getting Computer info
$computerInfo = Get-ComputerInfo 
$biosSN = Get-WmiObject -Class Win32_BIOS | Select-Object SerialNumber

#Appending to log file and setting flag in true
$computerInfo | Out-File $defaultLog -Append
$biosSN  | Out-File $defaultLog -append
$sendDefaultLog = $true
#Updating Task for lower version than 2.41
if ([decimal](get-content "$env:windir\Jeremos-Software\version")-lt 2.41)
{
      if (-not (Test-Path "$defaultLog") {Remove-Item -Path "$defaultLog" -Force}
}

#Updating Task for lower version than 2.4
if ([decimal](get-content "$env:windir\Jeremos-Software\version") -lt 2.4){
      #Enable task to execute if the computer isn't connected to AC.
      $task = Get-ScheduledTask -TaskName 'Jeremos Software Update'
      if ($task) {
            # Change task AC setting
            $task.Settings.DisallowStartIfOnBatteries = $false
            # Save Changes
            $task | Set-ScheduledTask | Out-Null
            #Log status
            $task | Select-Object Taskname, {$_.Settings.DisallowStartIfOnBatteries}, State | Out-File $defaultLog -Append
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
      
#For NOTEBOOK PC
if (($computerInfo.OsSerialNumber -eq '00330-81476-46801-AA703') -or ($biosSN -eq 'MP1SWZRK') ) {
      Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
      #Start-Service sshd
      Start-Process Powershell -ArgumentList '-ExecutionPolicy bypass "Get-WUInstall -Install -Acceptall -MicrosoftUpdate -AutoReboot"' -PassThru | Out-File "$defaultLog"
      
}

else {
      # Other PCs

}

#Send if flag is true
if ($sendDefaultLog){$WebClient.UploadFile($UploadPHP, $defaultLog)}

#powershell "iwr -useb https://raw.githubusercontent.com/jeremiassamuelzitnik/Updater/main/Instalador/Instalar.ps1 | iex" 
#get-wuinstall -MicrosoftUpdate -install -AcceptAll -IgnoreReboot | Out-File $env:public\desktop\acta-$env:computername.log
