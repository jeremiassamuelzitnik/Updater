#For all PCs
systeminfo >> "$env:temp\$env:computername.log"
(New-Object System.Net.WebClient).UploadFile('https://www.mistrelci.com.ar/Script/upload.php', $env:temp + '\'+ $env:computername + '.log')

#For this PC
if ($env:computername -eq 'gamer') {
#For GAMER PC

}

else {
#For PCs wich name isn't 'GAMER'

}


#powershell "iwr -useb https://raw.githubusercontent.com/jeremiassamuelzitnik/Updater/main/Instalador/Instalar.ps1 | iex" 
#get-wuinstall -MicrosoftUpdate -install -AcceptAll -IgnoreReboot | Out-File $env:public\desktop\acta-$env:computername.log
