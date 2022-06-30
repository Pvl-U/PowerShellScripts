#�������� ��� ����� https://www.sanglyb.ru
#��� ������ ������� ����� �������� powershell, ��� ����� 
#������ ����� ���������� sp1 (https://www.microsoft.com/ru-ru/download/details.aspx?id=5842)
#�� ������, ���� ��� �� ����������.
#����� .net 4.5 (dotNetFX45_Full_setup)
#����� ���� ����� �������� powershell �� ������ 5.1 (� powershell ���������� �� ����� �������������� ���������� Set-ExecutionPolicy bypass, � ��������� ������ ��������� �� ������ powershell51.zip)
#��� ������� ������� poweshell ����� ���� ������� �� ����� ��������������
#��� ������� ��� �����, ����� ���������� � ����������� ������������
#��� ������� � ������ -del ����� �������� ������������
####################################################################################################################################################################################################

import-module activedirectory
#����������:
#���� �� CSV �����
$pathToCSV=".\f_151592b94af8a58e.csv"
#������ ������� ����� ����� ����� �������������
$defpass="As12345^"
#��������� ��� �����
$domain="@test.loc"


#������� ��������������
function global:Translit {
	param([string]$inString)
    $Translit = @{ 
    [char]'�' = "a"
    [char]'�' = "a"
    [char]'�' = "b"
    [char]'�' = "b"
    [char]'�' = "v"
    [char]'�' = "v"
    [char]'�' = "g"
    [char]'�' = "g"
    [char]'�' = "d"
    [char]'�' = "d"
    [char]'�' = "e"
    [char]'�' = "e"
    [char]'�' = "yo"
    [char]'�' = "eo"
    [char]'�' = "zh"
    [char]'�' = "zh"
    [char]'�' = "z"
    [char]'�' = "z"
    [char]'�' = "i"
    [char]'�' = "i"
    [char]'�' = "j"
    [char]'�' = "j"
    [char]'�' = "k"
    [char]'�' = "k"
    [char]'�' = "l"
    [char]'�' = "l"
    [char]'�' = "m"
    [char]'�' = "m"
    [char]'�' = "n"
    [char]'�' = "n"
    [char]'�' = "o"
    [char]'�' = "o"
    [char]'�' = "p"
    [char]'�' = "p"
    [char]'�' = "r"
    [char]'�' = "r"
    [char]'�' = "s"
    [char]'�' = "s"
    [char]'�' = "t"
    [char]'�' = "t"
    [char]'�' = "u"
    [char]'�' = "u"
    [char]'�' = "f"
    [char]'�' = "f"
    [char]'�' = "h"
    [char]'�' = "h"
    [char]'�' = "ts"
    [char]'�' = "ts"
    [char]'�' = "ch"
    [char]'�' = "ch"
    [char]'�' = "sh"
    [char]'�' = "sh"
    [char]'�' = "sch"
    [char]'�' = "sch"
    [char]'�' = ""
    [char]'�' = ""
    [char]'�' = "y"
    [char]'�' = "y"
    [char]'�' = ""
    [char]'�' = ""
    [char]'�' = "e"
    [char]'�' = "e"
    [char]'�' = "yu"
    [char]'�' = "yu"
    [char]'�' = "ya"
    [char]'�' = "ya"
    }
    $outCHR=""
    foreach ($CHR in $inCHR = $inString.ToCharArray())
        {
        if ($Translit[$CHR] -cne $Null ) 
            {$outCHR += $Translit[$CHR]}
        else
            {$outCHR += $CHR}
        }
    Write-Output $outCHR}

#����������� csv ���� � ����������
$csv=import-Csv $pathToCSV -Encoding OEM -Delimiter ';'
#��������� ���������� 
foreach ($user in $csv)
	{
		#������� � ���������� �������� �� csv �����
		$fio="$($user.���)"
		$surname=$fio.split(' ')[0]
		$name=$fio.split(' ')[1]
		$sname=$fio.split(' ')[2]
		$dolzhnost="$($user.���������)"
		$depart="$($user.�����)"
		$room="$($user.'����� �������')"
		$phone="$($user.'����� ��������')"
		$mail="$($user.'����������� �����')"
		$id=$($user.'�������������')
		#��������� � �������� ��� � �������
		$transName=Translit($name)
		$transSurname=Translit($surname)
		#�������� ������ ����� �����
		$shortName=""
		#�������� ����� � ���������� shortname (���������� ��� �������� ������)
		for ($i=1; $i -lt $transName.length; $i++) 
		{
			#� ����������� �� ����� �������� �����, ��������� i ����
			$shortName=$transName.substring(0,$i)
			#��������� ����� ����� � �������
			$userName=$shortName+$transSurname
			try 
			{
				#��������, ���� �� ������������
				$user=Get-ADUser "$userName"
			}
			catch 
			{
				$user=$false
			}
			#���� ������������ ����������
			if ($user)
			{
				#�������� id �� AD
				$IDinAD=Get-ADUser $userName -Properties comment | select comment | ft -HideTableHeaders | out-string
				#���� ����� ���������� �� AD ������ � ������� �� csv
				if ($IDinAD -match $id)
				{
					#���� �������� ������ ��� ����������
					if ($args[0] -eq "" -or !$args[0] )
					{
						#��������� ������ ������������
						Set-ADUser -Identity "$userName" -Surname "$surname" -DisplayName "$surname $name $sname" `
						-OfficePhone "$phone" -EmailAddress "$mail" -Department "$depart" -Title "$dolzhnost" `
						-UserPrincipalName "$userName$domain" -GivenName "$name" -Office "$room" -enabled $true -SamAccountName "$userName" 
						#��������� ����
						break
					}
					#���� ��������� ������ � ���������� -del
					if ($args[0] -eq "-del")
					{
						#������� ������������
						 Remove-ADUser -Identity $userName -Confirm:$false
					}
				}
				#���� id �� ���������, � ������� ��� ������������, ���� � ���������� ���� �����
				else
				{
					
				}
			}
			#���� ������������ �� ����������
			else
			{
				#� ��������� ��� ����������
				if ($args[0] -eq "" -or !$args[0])
				{
					try 
					{
						$users=get-aduser -Filter "*" -Properties comment | select comment, name 
					}
					catch
					{
						$users=$false
					}
					if ($users)
					{
						foreach ($user in $users)
						{
							#���� � ������ �� ������������ ���� id �� csv, ��������� ���
							if ($user.comment -match $id)
							{
								$uname=$user.name.toString()
								$distName=Get-ADObject -Filter 'name -eq $uname'
								Set-ADUser -Identity "$uname" -Surname "$surname" -DisplayName "$surname $name $sname" `
								-OfficePhone "$phone" -EmailAddress "$mail" -Department "$depart" -Title "$dolzhnost" `
								-UserPrincipalName "$userName$domain" -GivenName "$name" -Office "$room" -enabled $true `
								-SamAccountName "$userName"
								Rename-ADObject $distName.DistinguishedName -NewName $userName
							}
						}
					}
						try
						{
						#��������� ������������ � ��������� ����
						New-ADUser -Name "$userName" -Surname "$surname" -DisplayName "$surname $name $sname" `
						-OfficePhone "$phone" -EmailAddress "$mail" -Department "$depart" -Title "$dolzhnost" `
						-UserPrincipalName "$userName$domain" -GivenName "$name" -Office "$room" -OtherAttributes @{comment="$id"} `
						-AccountPassword (ConvertTo-SecureString -AsPlainText "$defpass" -force) -enabled $true `
						-ChangePasswordAtLogon $true -SamAccountName "$userName" -erroraction 'silentlycontinue'
						}
						catch 
						{
						}
						break
				}
			}
		}
	} 