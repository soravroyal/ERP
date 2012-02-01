@Echo Off
@For /F "tokens=1,2,3,4 delims=/ " %%A in ('Date /t') do @( 
Set WDay=%%A
Set Day=%%C
Set Month=%%B
Set Year=%%D
Set All=%%C-%%B-%%D
)
cd C:\Program Files\Microsoft Office\OFFICE11
MSACCESS.EXE %basedir%\Full_Database.mdb /x FINISH_DATABASE
rename %basedir%\Full_Database.mdb Full_Database_%All%.mdb