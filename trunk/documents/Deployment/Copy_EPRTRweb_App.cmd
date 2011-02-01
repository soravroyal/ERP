echo off
echo Reset IIS
iisreset
echo Delete EPRTRweb folder
ERASE "C:\EPRTRweb" /q /s
echo Copy EPRTRweb folder
echo on
XCOPY "\\sdkcga6302\c$\E-PRTR_DEPLOY\PrecompiledWeb\EPRTRweb" "C:\EPRTRweb" /S
echo off
echo RET CONNECTIONSTRINGS IN WEB.CONFIG FIL
pause
REM Encrypt web.config file
rem CD C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727
rem aspnet_regiis.exe -pef "connectionStrings" "c:\EPRTRweb"
pause