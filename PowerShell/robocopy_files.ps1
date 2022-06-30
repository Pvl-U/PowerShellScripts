$source = '\\Server01\Share\Get-Widget.ps1'
$destination = '\\Server12\ScriptArchive\Get-Widget.ps1.txt'
$log = 'c:\temp\copyLog.txt'


get-childitem $source -recurse | foreach {
copy $_.fullname $destination -Force -Recurse -errorAction silentlyContinue
if($? -eq $false){
Write-Output "Error copying $($_.fullname)  did not copy to $destination" | out-file -append $log
} 
else 
{
write-output "$($_.fullname) copied OK to $destination" | out-file -append $log
}}


$SuccessMailParams = @{
To = 'email@gmail.com'
        From = 'email@gmail.com'
        Credential = New-Object System.Net.NetworkCredential("", "");
        Port = ''
        SmtpServer = 'smtp.gmail.com'
        Subject = 'Copy status'
        Body = "read the atached log"
        Attachments= “$log”
        }

         Send-MailMessage @SuccessMailParams
#edited: logs were not with name now fixed