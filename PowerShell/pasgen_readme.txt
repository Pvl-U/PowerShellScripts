# ������� ��� ���������� ������� PowerShell �������� ������������
echo $profile

# � ������� �����������, ���� �� ���������
mkdir $Home\Documents\WindowsPowerShell\

# ������� �������, ���� �� ���������
New-Item $Home\Documents\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1

# ��������� � ������� ��� �����
Add-Content -Path $Home\Documents\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1 -Value 'Set-Alias pasgen D:\Git\ShellScripts\PowerShell\pasgen.ps1 -Scope "Global"'

# ��������� ��� ���������
Get-Content "$Home\Documents\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1"

# ��� �������������� ��������
#notepad "$Home\Documents\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1"

