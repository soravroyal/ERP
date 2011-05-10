DECLARE @WTYPE INT
SELECT @WTYPE=[LOV_WasteTypeID] FROM [dbo].[LOV_WASTETYPE] WHERE [Code]='HW'
INSERT INTO [dbo].[LOV_WASTETHRESHOLD] (
	[LOV_WasteTypeID],
	[Threshold],
	[StartYear]
)
 SELECT @WTYPE, 2, 2007

SELECT @WTYPE=[LOV_WasteTypeID] FROM [dbo].[LOV_WASTETYPE] WHERE [Code]='NON-HW'
INSERT INTO [dbo].[LOV_WASTETHRESHOLD] (
	[LOV_WasteTypeID],
	[Threshold],
	[StartYear]
)
 SELECT @WTYPE, 2000, 2007

GO
