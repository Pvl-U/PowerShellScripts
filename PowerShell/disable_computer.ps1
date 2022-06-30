$computers= Get-Content C:\script\disable_computers.txt

ForEach ($computer in $computers)

{

Disable-ADAccount -Identity "$($computer.name)$"

}