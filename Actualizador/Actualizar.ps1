#Settings
$WebClient = New-Object System.Net.WebClient

###### For all PCs ######
#Report
Get-ComputerInfo >> "$env:temp\$env:computername.log"
(New-Object System.Net.WebClient).UploadFile('https://www.mistrelci.com.ar/Script/upload.php', $env:temp + '\'+ $env:computername + '.log')

#Updating Script
if ([decimal](get-content "$PSScriptRoot\version") -le 2.1){
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
