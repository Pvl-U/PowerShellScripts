$timespan = New-Timespan -Days 180

Search-ADAccount -UsersOnly -AccountInactive -TimeSpan $timespan | Disable-ADAccount