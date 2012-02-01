echo off
echo Reset IIS
iisreset
echo Delete EPRTRweb folder
ERASE "C:\Inetpub\wwwroot\EPRTRreview\EPRTRweb" /q /s
ERASE "C:\Inetpub\wwwroot\EPRTRpublic\EPRTRweb" /q /s
echo Copy EPRTRweb folder
echo on
XCOPY "\\sdkcga6302\c$\E-PRTR_DEPLOY\PrecompiledWeb\EPRTRweb" "C:\Inetpub\wwwroot\EPRTRreview\EPRTRweb" /S
XCOPY "\\sdkcga6302\c$\E-PRTR_DEPLOY\PrecompiledWeb\EPRTRweb" "C:\Inetpub\wwwroot\EPRTRpublic\EPRTRweb" /S
echo off
echo CONNECTIONSTRINGS ect. IN WEB.CONFIG FIL is updated 
call replace_webconfig_eprtr.bat
echo STRINGS IN MAP FILES are updated
call replace_maps_eprtr.bat
echo Update CMS core texts
call C:\E-PRTR_Ori\Deploy_App\Copy_and_Execute_Resources.cmd
pause
REM Encrypt web.config file
rem CD C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727
rem aspnet_regiis.exe -pef "connectionStrings" "c:\EPRTRweb"
pause