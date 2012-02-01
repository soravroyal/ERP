REM Encrypt web.config file
CD C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727
aspnet_regiis.exe -pef "connectionStrings" "c:\EPRTRweb" -prov "DataProtectionConfigurationProvider"
pause