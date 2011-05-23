-- changing mapping to IPPC codes

UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY] SET	IPPCCode = '6.4.(a)' WHERE Code = '8.(a)'
UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY] SET	IPPCCode = '6.4.(b)' WHERE Code = '8.(b)'
UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY] SET	IPPCCode = '6.4.(c)' WHERE Code = '8.(c)'
GO


