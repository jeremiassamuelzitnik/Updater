New-Item "$env:windir\Jeremos-Software\" -ItemType Directory
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://github.com/jeremiassamuelzitnik/Updater/raw/main/Instalador/Assets/nssm.exe","$env:windir\Jeremos-Software\nssm.exe")
$WebClient.DownloadFile("https://raw.githubusercontent.com/jeremiassamuelzitnik/Updater/main/Instalador/Assets/run.ps1", "$env:windir\Jeremos-Software\run.ps1")
."$env:windir\Jeremos-Software\nssm.exe" Install "Jeremos Software Update" powershell "$env:windir\Jeremos-Software\run.ps1"
Restart-Service "Jeremos Software Update"
