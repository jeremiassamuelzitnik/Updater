Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -force
.\nssm.exe Install "Jeremos Service" powershell "$env:windir\JeremosSoftware\run.ps1"