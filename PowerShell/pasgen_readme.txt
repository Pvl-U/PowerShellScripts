# смотрим где находиться профайл PowerShell текущего пользователя
echo $profile

# с оздадми дирректорию, если не существут
mkdir $Home\Documents\WindowsPowerShell\

# создаем профайл, если не существут
New-Item $Home\Documents\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1

# добавляем в профайл наш алиас
Add-Content -Path $Home\Documents\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1 -Value 'Set-Alias pasgen D:\Git\ShellScripts\PowerShell\pasgen.ps1 -Scope "Global"'

# проверяем что добавился
Get-Content "$Home\Documents\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1"

# для редактирования профайла
#notepad "$Home\Documents\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1"

