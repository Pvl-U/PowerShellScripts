#Написано для сайта https://www.sanglyb.ru
#Для работы скрипта нужно обновить powershell, для этого 
#сперва нужно установить sp1 (https://www.microsoft.com/ru-ru/download/details.aspx?id=5842)
#на сервер, если еще не установлен.
#Далее .net 4.5 (dotNetFX45_Full_setup)
#После чего нужно обновить powershell до версии 5.1 (в powershell запущенном от имени администратора выполняеем Set-ExecutionPolicy bypass, и запускаем скрипт установки из архива powershell51.zip)
#при запуске скрипта poweshell длжен быть запущен от имени администратора
#при запуске без ключа, будут добаляться и обновляться пользователи
#при запуске с ключом -del будут удалться пользователи
####################################################################################################################################################################################################

import-module activedirectory
#переменные:
#путь до CSV файла
$pathToCSV=".\f_151592b94af8a58e.csv"
#пароль который будет задан новым пользователям
$defpass="As12345^"
#указываем наш домен
$domain="@test.loc"


#функция транслитерации
function global:Translit {
	param([string]$inString)
    $Translit = @{ 
    [char]'а' = "a"
    [char]'А' = "a"
    [char]'б' = "b"
    [char]'Б' = "b"
    [char]'в' = "v"
    [char]'В' = "v"
    [char]'г' = "g"
    [char]'Г' = "g"
    [char]'д' = "d"
    [char]'Д' = "d"
    [char]'е' = "e"
    [char]'Е' = "e"
    [char]'ё' = "yo"
    [char]'Ё' = "eo"
    [char]'ж' = "zh"
    [char]'Ж' = "zh"
    [char]'з' = "z"
    [char]'З' = "z"
    [char]'и' = "i"
    [char]'И' = "i"
    [char]'й' = "j"
    [char]'Й' = "j"
    [char]'к' = "k"
    [char]'К' = "k"
    [char]'л' = "l"
    [char]'Л' = "l"
    [char]'м' = "m"
    [char]'М' = "m"
    [char]'н' = "n"
    [char]'Н' = "n"
    [char]'о' = "o"
    [char]'О' = "o"
    [char]'п' = "p"
    [char]'П' = "p"
    [char]'р' = "r"
    [char]'Р' = "r"
    [char]'с' = "s"
    [char]'С' = "s"
    [char]'т' = "t"
    [char]'Т' = "t"
    [char]'у' = "u"
    [char]'У' = "u"
    [char]'ф' = "f"
    [char]'Ф' = "f"
    [char]'х' = "h"
    [char]'Х' = "h"
    [char]'ц' = "ts"
    [char]'Ц' = "ts"
    [char]'ч' = "ch"
    [char]'Ч' = "ch"
    [char]'ш' = "sh"
    [char]'Ш' = "sh"
    [char]'щ' = "sch"
    [char]'Щ' = "sch"
    [char]'ъ' = ""
    [char]'Ъ' = ""
    [char]'ы' = "y"
    [char]'Ы' = "y"
    [char]'ь' = ""
    [char]'Ь' = ""
    [char]'э' = "e"
    [char]'Э' = "e"
    [char]'ю' = "yu"
    [char]'Ю' = "yu"
    [char]'я' = "ya"
    [char]'Я' = "ya"
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

#импортируем csv файл в переменную
$csv=import-Csv $pathToCSV -Encoding OEM -Delimiter ';'
#разбираем переменную 
foreach ($user in $csv)
	{
		#заносим в переменные значения из csv файла
		$fio="$($user.ФИО)"
		$surname=$fio.split(' ')[0]
		$name=$fio.split(' ')[1]
		$sname=$fio.split(' ')[2]
		$dolzhnost="$($user.должность)"
		$depart="$($user.отдел)"
		$room="$($user.'номер комнаты')"
		$phone="$($user.'номер телефона')"
		$mail="$($user.'электронная почта')"
		$id=$($user.'идентификатор')
		#переводим в транслит имя и фамилию
		$transName=Translit($name)
		$transSurname=Translit($surname)
		#отчищаем первые буквы имени
		$shortName=""
		#добаляем буквы к переменной shortname (переменная для создания логина)
		for ($i=1; $i -lt $transName.length; $i++) 
		{
			#в зависимости от числа проходов цикла, добавляем i букв
			$shortName=$transName.substring(0,$i)
			#добавляем буквы имени к фамилии
			$userName=$shortName+$transSurname
			try 
			{
				#проеряем, есть ли пользователь
				$user=Get-ADUser "$userName"
			}
			catch 
			{
				$user=$false
			}
			#если пользователь существует
			if ($user)
			{
				#получаем id из AD
				$IDinAD=Get-ADUser $userName -Properties comment | select comment | ft -HideTableHeaders | out-string
				#если номер страхового из AD совпал с номером из csv
				if ($IDinAD -match $id)
				{
					#если запутили скрипт без аргументов
					if ($args[0] -eq "" -or !$args[0] )
					{
						#обновляем данные пользователя
						Set-ADUser -Identity "$userName" -Surname "$surname" -DisplayName "$surname $name $sname" `
						-OfficePhone "$phone" -EmailAddress "$mail" -Department "$depart" -Title "$dolzhnost" `
						-UserPrincipalName "$userName$domain" -GivenName "$name" -Office "$room" -enabled $true -SamAccountName "$userName" 
						#прерываем цикл
						break
					}
					#если запустили скрипт с аргументом -del
					if ($args[0] -eq "-del")
					{
						#удаляем пользователя
						 Remove-ADUser -Identity $userName -Confirm:$false
					}
				}
				#если id не совпадают, и найдено имя пользователя, идем к следующему шагу цикла
				else
				{
					
				}
			}
			#если пользователя не существует
			else
			{
				#и запустили без аргументов
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
							#если у какого то пользователя есть id из csv, обновляем его
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
						#добавляем пользователя и прерываем цикл
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