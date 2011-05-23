echo off
echo create resource files for flash maps
set basedir=%CD%

echo -----------------------------------------------

del %basedir%\da_DK
mkdir %basedir%\da_DK
call GenerateMapResourceFiles_dr_DK.dtsx

echo -----------------------------------------------

del %basedir%\en_GB
mkdir %basedir%\en_GB
call GenerateMapResourceFiles_en_GB.dtsx

echo -----------------------------------------------

del %basedir%\fr_FR
mkdir %basedir%\fr_FR
call GenerateMapResourceFiles_fr_FR.dtsx
