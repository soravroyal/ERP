INSERT INTO [dbo].[LOV_WASTETYPE] (
    [Code],
    [Name],
    [StartYear]
)
 SELECT 'HW', 'Hazardous waste', 2007
  UNION ALL
 SELECT 'NON-HW', 'Non-hazardous waste', 2007
GO

DECLARE @HW INT
SELECT @HW=[LOV_WasteTypeID] FROM [dbo].[LOV_WASTETYPE] WHERE [Code]='HW'
INSERT INTO [dbo].[LOV_WASTETYPE] (
    [Code],
    [Name],
    [StartYear],
    [ParentID]
)
 SELECT 'HWIC', 'Hazardous waste within country', 2007, @HW
  UNION ALL
 SELECT 'HWOC', 'Hazardous waste outside country', 2007, @HW
GO

