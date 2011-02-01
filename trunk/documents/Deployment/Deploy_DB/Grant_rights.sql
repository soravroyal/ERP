USE [EPRTRmaster]
GO
CREATE USER [gis] FOR LOGIN [gis]
GO
ALTER USER [gis] WITH DEFAULT_SCHEMA=[db_owner]
GO
EXEC sp_addrolemember N'db_owner', N'gis'
GO

USE [EPRTRweb]
GO
CREATE USER [gis] FOR LOGIN [gis]
GO
ALTER USER [gis] WITH DEFAULT_SCHEMA=[db_owner]
GO
EXEC sp_addrolemember N'db_owner', N'gis'
GO


USE [EPRTRreview]
GO
CREATE USER [gis] FOR LOGIN [gis]
GO
ALTER USER [gis] WITH DEFAULT_SCHEMA=[db_owner]
GO
EXEC sp_addrolemember N'db_owner', N'gis'
GO


USE [EPRTRpublic]
GO
CREATE USER [gis] FOR LOGIN [gis]
GO
ALTER USER [gis] WITH DEFAULT_SCHEMA=[db_owner]
GO
EXEC sp_addrolemember N'db_owner', N'gis'
GO






USE [EPRTRcms]
GO
CREATE USER [gis] FOR LOGIN [gis]
GO
ALTER USER [gis] WITH DEFAULT_SCHEMA=[db_owner]
GO
EXEC sp_addrolemember N'db_owner', N'gis'
GO

USE [EPRTRcms]
GO
 ALTER AUTHORIZATION ON SCHEMA::[aspnet_ChangeNotification_ReceiveNotificationsOnlyAccess] TO [gis]
GO
USE [EPRTRcms]
GO
 ALTER AUTHORIZATION ON SCHEMA::[db_datareader] TO [gis]
GO
USE [EPRTRcms]
GO
EXEC sp_addrolemember N'db_owner', N'gis'
GO
USE [EPRTRcms]
GO
EXEC sp_addrolemember N'aspnet_ChangeNotification_ReceiveNotificationsOnlyAccess', N'gis'
GO



USE [master]
GO
ALTER DATABASE [EPRTRcms] SET  ENABLE_BROKER WITH NO_WAIT
GO