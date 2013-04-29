SET SQLCMDDBNAME=EPRTRxml
sqlcmd -Q "EXEC [dbo].[add_aux_columns];"
sqlcmd -Q "EXEC [dbo].[import_xml] @pCDRURL = N'%1', @pCDRUploaded = N'%2',@pCDRReleased=N'%3',@pStatus=3,@pResubmitReason='%4';"
pause