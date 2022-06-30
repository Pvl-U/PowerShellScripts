$Logfile="C:\script\disable_users.log"
$Stamp = (Get-Date).toString("dd/MM/yyyy HH:mm:ss")
$users=Get-Content C:\script\disable_users.txt

ForEach ($user in $users)
{
Disable-ADAccount -Identity $($user)
}

# Logging
$Stamp > $Logfile
Add-Content -Path $Logfile -Value "Next Users are Disabled:"
$users >> $Logfile
Add-Content -Path $Logfile -Value "Last Error:"
$Error >> $Logfile

# Send Email
#$userName = 'noreply@languagelink.ru'
#$password = 'password'
#[SecureString]$securepassword = $password | ConvertTo-SecureString -AsPlainText -Force 
#$credential = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $securepassword
#Send-MailMessage -SmtpServer oxford -Port 587 -UseSsl -From noreply@languagelink.ru -To softmaster@languagelink.ru -Subject 'Accounts have been disabled'  -Attachments 'C:\script\disable_users.log' -Body 'Some accounts have been disabled from list in file disable_users.txt' -Credential $credential