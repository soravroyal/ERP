echo off
echo Database updating script for BRANCHES of E-PRTR 
REM Set environment variables SQLCMDUSER, SQLCMDPASSWORD and SQLCMDSERVER
REM before running this script.
rem --------------------------------------------------------------------

set basedir=C:\EIONET\DeltaScripts
 
echo --------------------------------------------------------------------
echo updating EPRTRmaster . . .
rem List of delta scripts to be executed on EPRTRmaster
set SQLCMDDBNAME=EPRTRmaster

sqlcmd -i %basedir%\RemoveSwissFromAreaGroup.sql

echo --------------------------------------------------------------------
echo updating EPRTRcms . . .
rem List of delta scripts to be executed on EPRTRcms
set SQLCMDDBNAME=EPRTRcms


