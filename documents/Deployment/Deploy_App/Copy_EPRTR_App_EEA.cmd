echo off
echo Delete EPRTRweb folder
ERASE "C:\E-PRTR_Ori\EEA\EPRTRreview\EPRTRweb" /q /s
ERASE "C:\E-PRTR_Ori\EEA\EPRTRpublic\EPRTRweb" /q /s
ERASE "C:\E-PRTR_Ori\EEA\EPRTRcms" /q /s
echo Copy EPRTRweb folder
echo on
XCOPY "\\sdkcga6302\c$\E-PRTR_DEPLOY\PrecompiledWeb\EPRTRweb" "C:\E-PRTR_Ori\EEA\EPRTRreview\EPRTRweb" /S
XCOPY "\\sdkcga6302\c$\E-PRTR_DEPLOY\PrecompiledWeb\EPRTRweb" "C:\E-PRTR_Ori\EEA\EPRTRpublic\EPRTRweb" /S
XCOPY "\\sdkcga6302\c$\E-PRTR_CMS_DEPLOY\EPRTRcms" "C:\E-PRTR_Ori\EEA\EPRTRcms" /S
echo off
echo CONNECTIONSTRINGS ect. IN WEB.CONFIG FIL is updated 
call replace_webconfig_eprtr_eea.bat
echo STRINGS IN MAP FILES are updated
call replace_maps_eprtr_eea.bat
echo CONNECTIONSTRINGS ect. IN WEB.CONFIG FIL is updated 
call replace_webconfig_cms_eea.bat
echo Update is_review from false to true in C:\E-PRTR_Ori\EEA\EPRTRreview\EPRTRweb\web.config
pause
ERASE "C:\E-PRTR_Ori\EEA\Deltascripts\" /q /s
XCOPY "C:\EIONET\SQLScripts\Deltascripts" "C:\E-PRTR_Ori\EEA\Deltascripts" /S
ERASE "C:\E-PRTR_Ori\EEA\Import_CoreTexts.bat" /q /s
ERASE "C:\E-PRTR_Ori\EEA\DBResources_CoreTexts.csv" /q /s
echo Get new versions of files
echo on
XCOPY "\\sdkcga6302\c$\E-PRTR_DEPLOY\Import_CoreTexts.bat" "C:\E-PRTR_Ori\EEA" /S
XCOPY "\\sdkcga6302\c$\E-PRTR_DEPLOY\DBResources_CoreTexts.csv" "C:\E-PRTR_Ori\EEA" /S
echo off
echo Modify the Import package to point to the right database if necessary and press any key...
pause
echo Zipping folders
@For /F "tokens=1,2,3,4 delims=/ " %%A in ('Date /t') do @( 
Set WDay=%%A
Set Day=%%C
Set Month=%%B
Set Year=%%D
Set All=%%C-%%B-%%D
)
echo off
cd C:\Program Files\7-Zip
7z.exe a "C:\E-PRTR_Ori\Deploy_App\EPRTRwebsites_%All%.zip" "C:\E-PRTR_Ori\EEA\" -y
pause