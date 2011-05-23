
/****** Object:  View for finding all countries reporting under E-PRTR    Script Date: 03/11/2009 14:06:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[WEB_REPORTINGCOUNTRY]
AS
SELECT     dbo.LOV_COUNTRY.*
FROM         dbo.LOV_AREAGROUP INNER JOIN
                      dbo.LOV_COUNTRYAREAGROUP ON dbo.LOV_AREAGROUP.LOV_AreaGroupID = dbo.LOV_COUNTRYAREAGROUP.LOV_AreaGroupID INNER JOIN
                      dbo.LOV_COUNTRY ON dbo.LOV_COUNTRYAREAGROUP.LOV_CountryID = dbo.LOV_COUNTRY.LOV_CountryID
WHERE     (dbo.LOV_AREAGROUP.Code = N'E-PRTR')

GO
