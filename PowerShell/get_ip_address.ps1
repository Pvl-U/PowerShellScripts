<#
Мы записываем в переменную $MAC результат от выполнение командлета Get-WmiObject, с помощью которого передаём WMI запрос на 
компьютеры, указанные в параметре -computername и возвращаем нужную нам информацию из класса Win32_NetworkAdapterConfiguration.
Обратите внимание, если надо получить IP-адрес и MAC-адрес текущего компьютера, то вместо имён компьютеров, 
параметру -computername мы передадим точку. И сохраняем результат в файл comp_mac_ip.csv
(статья: https://habr.com/ru/post/242445/)
#>


# узнать IP-адрес и MAC-адрес нескольких компьютеров в сети

$MAC = Get-WmiObject -ComputerName localhost, localhost -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=True  |  Select-Object -Property * | SELECT PSComputerName, @{Name="IPAddress";Expression={$_.IPAddress.get(0)}}, MACAddress, Description
$MAC
# Export результатта в файл
#$MAC | Export-Csv D:comp_ip_mac.csv -Encoding UTF8

# узнать IP-адрес и MAC-адрес локального компьютера

$MAC = Get-WmiObject -ComputerName . -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=True  |  Select-Object -Property * | SELECT PSComputerName, @{Name="IPAddress";Expression={$_.IPAddress.get(0)}}, MACAddress, Description
$MAC
# Export результатта в файл
#$MAC | Export-Csv D:comp_ip_mac.csv -Encoding UTF8