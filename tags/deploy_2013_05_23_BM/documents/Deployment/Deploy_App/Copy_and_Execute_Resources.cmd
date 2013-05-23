echo off
echo Delete the resource import and content file
ERASE "C:\E-PRTR_Ori\Deploy_App\Import_CoreTexts.bat" /q /s
ERASE "C:\E-PRTR_Ori\Deploy_App\DBResources_CoreTexts.csv" /q /s
echo Get new versions of files
echo on
XCOPY "\\sdkcga6302\E-PRTR_DEPLOY\Import_CoreTexts.bat" "C:\E-PRTR_Ori\Deploy_App" /S
XCOPY "\\sdkcga6302\E-PRTR_DEPLOY\DBResources_CoreTexts.csv" "C:\E-PRTR_Ori\Deploy_App" /S
echo off
rem echo Modify the Import package to point to the right database if necessary and press any key...
echo replacing path in bat file
cscript replace.vbs "C:\E-PRTR_Ori\Deploy_App\Import_CoreTexts.bat" "C:\E-PRTR" "C:\E-PRTR_Ori\Deploy_App\"
echo replacing cms core texts
call C:\E-PRTR_Ori\Deploy_App\Import_CoreTexts.bat
echo Reset IIS
iisreset
pause