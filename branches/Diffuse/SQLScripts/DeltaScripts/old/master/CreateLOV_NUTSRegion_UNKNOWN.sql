use EPRTRmaster

INSERT INTO [dbo].[LOV_COUNTRY](
      [Code],
      [Name],
      [StartYear],
      [EndYear]
)
 VALUES ('UNKNOWN', 'N/A', 2001, null)
GO

INSERT INTO [dbo].[LOV_NUTSREGION](
	[Code],
	[Name],
	[StartYear],
    [EndYear],
	[LOV_CountryID]
)
 VALUES ('UNKNOWN', 'N/A', 2001, null, SCOPE_IDENTITY())
GO
