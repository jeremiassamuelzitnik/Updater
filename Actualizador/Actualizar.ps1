#Settings
$WebClient = New-Object System.Net.WebClient
$UploadPHP = 'https://www.mistrelci.com.ar/Script/upload.php'
$GitRunPS1 = 'https://raw.githubusercontent.com/jeremiassamuelzitnik/Updater/main/Instalador/Assets/run.ps1'
$GitTimeout = 'https://raw.githubusercontent.com/jeremiassamuelzitnik/Updater/main/Actualizador/timeout.txt'
$defaultLog = "$env:windir\Jeremos-Software\Logs\$env:computername.log"
if (-not (Test-Path "$env:windir\Jeremos-Software\Logs")) {mkdir "$env:windir\Jeremos-Software\Logs"}

###### For all PCs ######
#Report
Get-ComputerInfo | Out-File $defaultLog
$sendDefaultLog = $true

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
            $task | Select-Object Taskname, {$_.Settings.DisallowStartIfOnBatteries}, State | Out-File $defaultLog
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
      Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
      start-service sshd

      #Get-WUInstall -Install -Acceptall -MicrosoftUpdate -AutoReboot

}

else {
# Other PCs

}

#Send if flag is true
if ($sendDefaultLog){$WebClient.UploadFile($UploadPHP, $defaultLog)}

#powershell "iwr -useb https://raw.githubusercontent.com/jeremiassamuelzitnik/Updater/main/Instalador/Instalar.ps1 | iex" 
#get-wuinstall -MicrosoftUpdate -install -AcceptAll -IgnoreReboot | Out-File $env:public\desktop\acta-$env:computername.log
