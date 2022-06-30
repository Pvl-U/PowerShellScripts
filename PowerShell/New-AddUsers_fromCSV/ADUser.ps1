Import-Module ActiveDirectory
# Задаем директорию со скриптом
Set-Location C:\script\AddUsers_fromCSV
# текущее ремя
$Stamp = (Get-Date).toString("dd/MM/yyyy HH:mm:ss")

# локальный домен
$Domain='@languagelink.ru'

# Целевой обьект в AD
$NewUserOU='OU=New_Users,OU=Remote_Users,OU=DATACENTER,DC=LanguageLink,DC=ru'

# log-файл в папке logs
$Logfile='logs\adusers.log'
Clear-Content -Path $Logfile
Add-Content -Path $Logfile -Value $Stamp

# CSV файл с НОВЫМИ ПОЛЬЗОВАТЕЛЯМИ
$newusers_csv='NewUsers1.csv'

# export
$new_users=Import-CSV -Path $newusers_csv -Encoding UTF8 -Delimiter ';'

# CSV файл для экспорта созданных учетных записей
$export_users='NewUsers_report.csv'


ForEach ($user in $new_users)
{

$DisplayName=$User.FullName

$FullName=$User.FullName

$surName=$fullName.split(' ')[0]

$givenName=$fullName.split(' ')[1]

# первые 2 буквы givenName + все слово surName
$sAMAccountName=$surName.substring(0,2)+$givenName

$userPrincipalName=$sAMAccountName+$Domain

$Company=$User.company

$Department=$User.department

$City=$User.City

# генерируем 9 значный пароль
#   - count - Длина пароля
#   - input - Какие символы использовать для генерации.
$random1 = get-random -count 3 -input ([char[]]'abcdefghijklmnopqrstuvwxyz') 
$random2 = get-random -count 3 -input ([char[]]'ABCDEFGHIJKLMNOPQRSTUVWXYZ') 
$random3 = get-random -count 3 -input ([char[]]'0123456789')
$userPassword = get-random  -count 9 -input ([char[]]($random1+$random2+$random3)) | % -begin { $pass = $null } -process {$pass += $_} -end {$pass}

$expire=$null

$Description=$User.Description

#проеряем, есть ли пользователь

$existADUser = Get-ADUser -Filter "SamAccountName -eq '$sAMAccountName'"

   
# если пользователь не существует
  if($null -eq $existADUser)
  {
    New-ADUser -PassThru -Path $NewUserOU -DisplayName $DisplayName -Name $DisplayName -GivenName $givenName -SamAccountName $sAMAccountName -Surname $surName -UserPrincipalName $userPrincipalName -Enabled $True -ChangePasswordAtLogon $False -PasswordNeverExpires $True -AccountPassword (ConvertTo-SecureString $userPassword -AsPlainText -Force) -CannotChangePassword $True -City $City -Company $Company -Department $Department -Description "$Description"
    Add-ADGroupMember -Identity Remote_users_1C_gl -Members $sAMAccountName
    
    $newuser = [PSCustomObject]@{Name = $DisplayName; Login = $userPrincipalName; Password = $userPassword}
    $newuser | Export-Csv -Path $export_users -NoTypeInformation -Append -Encoding UTF8 -Delimiter ';'
    
    Add-Content -Value "Account $DisplayName has been created in AD" -Path $Logfile
   }

  else
# если пользователь существует
  {
    write-host "User: '$fullName' exist in Active Directory"
    Add-Content -Value "Account $fullName exist in Active Directory" -Path $Logfile
  }


}
$results=Get-Content -Path $export_users
$results | % { $_ -replace '"',''} | out-file $export_users -fo -en UTF8

