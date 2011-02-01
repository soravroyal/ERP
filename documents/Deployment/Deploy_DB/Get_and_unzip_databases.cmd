REM Copy zip-file containing db's from sdkcga6302
XCOPY "\\sdkcga6302\c$\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\Backup\EPRTRdbs.zip" "C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\Backup" /Y
REM Extract zip-file
cd C:\Program Files\7-Zip
7z.exe x "C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\Backup\EPRTRdbs.zip" -o"C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\Backup" -y
pause