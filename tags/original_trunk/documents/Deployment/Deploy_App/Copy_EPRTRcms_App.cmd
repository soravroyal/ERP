echo off
echo Reset IIS
iisreset
echo Delete EPRTRcms folder
ERASE "C:\Inetpub\wwwroot\EPRTRcms" /q /s
echo Copy EPRTRcms folder
echo on
XCOPY "\\sdkcga6302\c$\E-PRTR_CMS_DEPLOY\EPRTRcms" "C:\Inetpub\wwwroot\EPRTRcms" /S
echo off
echo CONNECTIONSTRINGS ect. IN WEB.CONFIG FIL is updated 
call replace_webconfig_cms.bat
echo Updating DBresources texts. When prompted enter db password
call C:\E-PRTR_Ori\Deploy_App\Copy_and_Execute_Resources.cmd
REM Encrypt web.config file
rem CD C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727
rem aspnet_regiis.exe -pef "connectionStrings" "c:\EPRTRweb"
pause