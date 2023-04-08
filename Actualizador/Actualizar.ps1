#Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
#choco install clickpaste -y
#choco install everything -y
systeminfo > "$env:public\desktop\$env:computername.log"
get-wuinstall -MicrosoftUpdate -install -AcceptAll -IgnoreReboot | Out-File "$env:public\desktop\actualización $env:computername.log"
