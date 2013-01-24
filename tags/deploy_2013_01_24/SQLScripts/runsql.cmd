@ECHO OFF

REM See http://msdn.microsoft.com/en-us/library/ms162773.aspx for reference.
REM Set environment variables SQLCMDUSER, SQLCMDPASSWORD and SQLCMDSERVER
REM before running this script.

SET basedir=C:\SQL\EPRTR2EIONET

REM Clear existing database:
SET SQLCMDDBNAME=master
sqlcmd -Q "ALTER DATABASE EPRTRmaster SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE EPRTRmaster;"
sqlcmd -Q "CREATE DATABASE EPRTRmaster COLLATE Latin1_General_CI_AS;"

REM Create database structure:
SET SQLCMDDBNAME=EPRTRmaster
sqlcmd -i %basedir%\CreateTables.sql
sqlcmd -i %basedir%\CreateReferences.sql

REM Populate LOV tables:
REM (Some LOVs reference others; reorder the following lines at your peril!)
sqlcmd -i %basedir%\LOVScripts\CreateLOV_Country.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_AreaGroup.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_CountryAreaGroup.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_RiverBasinDistrict.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_Status.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_AT.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_BG.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_BE.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_CH.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_CY.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_CZ.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_DE.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_DK.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_EE.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_ES.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_FI.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_FR.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_GR.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_HU.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_IE.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_IS.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_IT.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_LI.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_LT.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_LU.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_LV.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_MT.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_NL.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_NO.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_PL.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_PT.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_RO.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_SE.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_SI.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_SK.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NUTSRegion_UK.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_Medium.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_MethodBasis.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_MethodType.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_Pollutant.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_PollutantThreshold.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_WasteType.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_WasteThreshold.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_WasteTreatment.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_AnnexIActivity.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_NACEActivity.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_Confidentiality.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_CoordinateSystem.sql
sqlcmd -i %basedir%\LOVScripts\CreateLOV_Unit.sql

echo finsh LOV

REM Create views for data warehouse export:
sqlcmd -i %basedir%\CreateDataWarehouseViews.sql

REM Create views for frontend data search:
rem sqlcmd -i %basedir%\FrontendScripts\CreateSearchOptions.sql
rem sqlcmd -i %basedir%\FrontendScripts\CreateFacilitySearch.sql
rem sqlcmd -i %basedir%\FrontendScripts\FacilityLevel.sql

REM Populate the database with a few rows of test data:
rem sqlcmd -i %basedir%\CreateTestData.sql

REM Load EPER data:

echo EPERimportNACE
sqlcmd -i %basedir%\EPERimportNACE.sql
echo CopyEPERdata2EPRTR
sqlcmd -i %basedir%\CopyEPERdata2EPRTR.sql

echo Create_pAT_Procedures
sqlcmd -i %basedir%\Create_pAT_Procedures.sql
sqlcmd -i %basedir%\Create_tAT_Tables.sql
sqlcmd -i %basedir%\Create_vAT_PrepViews.sql

echo CreateViewsFACILITYSEARCH.sql
sqlcmd -i %basedir%\CreateViewsFACILITYSEARCH.sql
sqlcmd -i %basedir%\CreateViewsFACILITYDETAIL.sql
sqlcmd -i %basedir%\CreateViewsACTIVITYSEARCH.sql
sqlcmd -i %basedir%\CreateViewsPOLLUTANTTRANSFER_RELEASE.sql
sqlcmd -i %basedir%\CreateViewsWASTETRANSFER.sql
sqlcmd -i %basedir%\CreateViewsForDropdownBox.sql

rem sqlcmd -i %basedir%\GeocodingNUTS_RBD.sql
rem sqlcmd -i %basedir%\GenerateTestdata2007.sql

REM Create database indices:
rem sqlcmd -i %basedir%\CreateIndices.sql
