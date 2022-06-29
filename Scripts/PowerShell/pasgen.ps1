# Password Generator
# Требования к паролю: должен содержать 3 комбинации букв и цифр
$PassLength = Read-Host 'Длина пароля (5-128)'
$PassNumber = Read-Host 'Количество паролей'

#$PassLength=5

# разбиваем длинну пароля на 3 части и сохраняем в массив
$PassLengthSplit = @()
$PassLengthSplit += [int]($PassLength/3)
$PassLengthSplit += $PassLengthSplit[0]
$PassLengthSplit += ($PassLength-$PassLengthSplit[0]-$PassLengthSplit[1])

# наборы символов, которые обязательно будут использованы в генерации пароля сохраняем в массив
$char=@()
$char += 'abcdefghijkmnopqrstuvwxyz'
$char += $char[0].ToUpper()
$char += '123456789'

1..$PassNumber | ForEach-Object -process {
$Random = @()
for ( $index = 0; $index -lt $PassLengthSplit.Count; $index++ )
{
#$Random = randomchar $PassLengthSplit[$index] $char[$index]
$Random += (1..$PassLengthSplit[$index] | % {[char[]]$char[$index] | Get-Random})
}
#$passw = $Random | sort {Get-Random}
#$passw -join ''
($Random | sort {Get-Random}) -join ''

}
#Pause