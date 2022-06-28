# Password Generator
$PassLength = Read-Host 'Длина пароля (1-128)'
$PassNumber = Read-Host 'Количество паролей'

$PassLengthSplit1 = [int]($PassLength/3)
$PassLengthSplit2 = [int]($PassLength/3)
$PassLengthSplit3 = $PassLength - $PassLengthSplit1 - $PassLengthSplit2

1..$PassNumber | ForEach-Object -process {
        $PassResult = -join (1..$PassLengthSplit1 | % { [char[]]'abcdefghijklmnopqrstuvwxyz' | Get-Random })
        $PassResult = $PassResult + (-join (1..$PassLengthSplit2 | % { [char[]]'ABCDEFGHIJKLMNOPQRSTUVWXYZ' | Get-Random }))
        $PassResult = $PassResult + (-join (1..$PassLengthSplit3 | % { [char[]]'0123456789' | Get-Random }))
        #$PassResult = get-random -count $PassLength -input $PassResult | % -begin { $pass = $null } -process {$pass += $_} -end {$pass}
        
        $PassResult 
        }
#Pause
