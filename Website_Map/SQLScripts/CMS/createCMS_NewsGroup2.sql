USE EPRTRcms
GO

insert into [EPRTRcms].[dbo].[NewsKey]
(topnewsindicator,newsdate,visible)
values(1,cast('2009-07-22 00:00:00' as DateTime),0)

insert into [EPRTRcms].[dbo].[NewsValue]
(newskeyid,culturecode,headertext,bodytext,authorname,createdate)
values(1,'en-GB','The E-PRTR Review website is now ready!','All member states can now review thier latest data.','hylleand',cast('2009-07-22 00:00:00' as DateTime))
go

