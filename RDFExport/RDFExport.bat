ECHO off

ECHO Performing cleanup

rmdir /s /q Build

ECHO Starting build of configuration properties maker

:: Ensure msbuild directory is correct
C:\Windows\Microsoft.NET\Framework\v3.5\msbuild.exe RDFExport.msbuild /t:RebuildSolution /p:OutDir=../Build/

ECHO Making configuration properties for GenerateRDF

cd Build

:: Set EPRTR database parameters (-s: sever, -db: database name, -u: user, -p: password)
MakeConfiguration -s SDKCGA6332 -db EPRTRMaster -u gis -p tmggis -z

cd ..

xcopy /s GenerateRDF Build

cd Build

ECHO Running export

Make

cd ..

copy Build\rdf_export.zip rdf_export.zip

rmdir /s /q Build

ECHO Done!

