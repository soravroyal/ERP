-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='UK'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKC', 'NORTH EAST (ENGLAND)', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'UKD', 'NORTH WEST (ENGLAND)', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'UKE', 'YORKSHIRE AND THE HUMBER', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'UKF', 'EAST MIDLANDS (ENGLAND)', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'UKG', 'WEST MIDLANDS (ENGLAND)', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'UKH', 'EAST OF ENGLAND', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'UKI', 'LONDON', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'UKJ', 'SOUTH EAST (ENGLAND)', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'UKK', 'SOUTH WEST (ENGLAND)', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'UKL', 'WALES', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'UKM', 'SCOTLAND', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'UKN', 'NORTHERN IRELAND', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'UKZ', 'EXTRA-REGIO', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS1 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='UK'
SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKC'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKC1', 'Tees Valley and Durham', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'UKC2', 'Northumberland and Tyne and Wear', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKD'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKD1', 'Cumbria', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'UKD2', 'Cheshire', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'UKD3', 'Greater Manchester', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'UKD4', 'Lancashire', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'UKD5', 'Merseyside', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKE'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKE1', 'East Yorkshire and Northern Lincolnshire', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'UKE2', 'North Yorkshire', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'UKE3', 'South Yorkshire', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'UKE4', 'West Yorkshire', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKF'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKF1', 'Derbyshire and Nottinghamshire', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'UKF2', 'Leicestershire, Rutland and Northamptonshire', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'UKF3', 'Lincolnshire', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKG'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKG1', 'Herefordshire, Worcestershire and Warwickshire', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'UKG2', 'Shropshire and Staffordshire', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'UKG3', 'West Midlands', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKH'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKH1', 'East Anglia', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'UKH2', 'Bedfordshire and Hertfordshire', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'UKH3', 'Essex', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKI'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKI1', 'Inner London', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'UKI2', 'Outer London', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKJ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKJ1', 'Berkshire, Buckinghamshire and Oxfordshire', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'UKJ2', 'Surrey, East and West Sussex', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'UKJ3', 'Hampshire and Isle of Wight', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'UKJ4', 'Kent', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKK'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKK1', 'Gloucestershire, Wiltshire and Bristol/Bath area', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'UKK2', 'Dorset and Somerset', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'UKK3', 'Cornwall and Isles of Scilly', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'UKK4', 'Devon', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKL'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKL1', 'West Wales and The Valleys', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'UKL2', 'East Wales', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKM'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKM2', 'Eastern Scotland', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'UKM3', 'South Western Scotland', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'UKM5', 'North Eastern Scotland', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'UKM6', 'Highlands and Islands', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKN'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKN0', 'Northern Ireland', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKZZ', 'Extra-Regio', 2007, @NUTS1, @COUNTRY

GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='UK'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKC1'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKC11', 'Hartlepool and Stockton-on-Tees', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKC12', 'South Teesside', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKC13', 'Darlington', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKC14', 'Durham CC', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKC2'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKC21', 'Northumberland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKC22', 'Tyneside', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKC23', 'Sunderland', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKD1'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKD11', 'West Cumbria', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKD12', 'East Cumbria', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKD2'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKD21', 'Halton and Warrington', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKD22', 'Cheshire CC', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKD3'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKD31', 'Greater Manchester South', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKD32', 'Greater Manchester North', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKD4'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKD41', 'Blackburn with Darwen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKD42', 'Blackpool', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKD43', 'Lancashire CC', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKD5'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKD51', 'East Merseyside', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKD52', 'Liverpool', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKD53', 'Sefton', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKD54', 'Wirral', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKE1'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKE11', 'Kingston upon Hull, City of', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKE12', 'East Riding of Yorkshire', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKE13', 'North and North East Lincolnshire', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKE2'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKE21', 'York', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKE22', 'North Yorkshire CC', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKE3'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKE31', 'Barnsley, Doncaster and Rotherham', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKE32', 'Sheffield', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKE4'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKE41', 'Bradford', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKE42', 'Leeds', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKE43', 'Calderdale, Kirklees and Wakefield', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKF1'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKF11', 'Derby', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKF12', 'East Derbyshire', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKF13', 'South and West Derbyshire', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKF14', 'Nottingham', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKF15', 'North Nottinghamshire', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKF16', 'South Nottinghamshire', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKF2'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKF21', 'Leicester', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKF22', 'Leicestershire CC and Rutland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKF23', 'Northamptonshire', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKF3'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKF30', 'Lincolnshire', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKG1'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKG11', 'Herefordshire, County of', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKG12', 'Worcestershire', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKG13', 'Warwickshire', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKG2'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKG21', 'Telford and Wrekin', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKG22', 'Shropshire CC', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKG23', 'Stoke-on-Trent', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKG24', 'Staffordshire CC', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKG3'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKG31', 'Birmingham', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKG32', 'Solihull', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKG33', 'Coventry', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKG34', 'Dudley and Sandwell', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKG35', 'Walsall and Wolverhampton', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKH1'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKH11', 'Peterborough', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKH12', 'Cambridgeshire CC', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKH13', 'Norfolk', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKH14', 'Suffolk', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKH2'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKH21', 'Luton', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKH22', 'Bedfordshire CC', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKH23', 'Hertfordshire', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKH3'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKH31', 'Southend-on-Sea', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKH32', 'Thurrock', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKH33', 'Essex CC', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKI1'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKI11', 'Inner London - West', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKI12', 'Inner London - East', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKI2'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKI21', 'Outer London - East and North East', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKI22', 'Outer London - South', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKI23', 'Outer London - West and North West', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKJ1'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKJ11', 'Berkshire', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKJ12', 'Milton Keynes', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKJ13', 'Buckinghamshire CC', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKJ14', 'Oxfordshire', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKJ2'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKJ21', 'Brighton and Hove', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKJ22', 'East Sussex CC', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKJ23', 'Surrey', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKJ24', 'West Sussex', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKJ3'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKJ31', 'Portsmouth', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKJ32', 'Southampton', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKJ33', 'Hampshire CC', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKJ34', 'Isle of Wight', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKJ4'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKJ41', 'Medway', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKJ42', 'Kent CC', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKK1'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKK11', 'Bristol, City of', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKK12', 'Bath and North East Somerset, North Somerset and South Gloucestershire', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKK13', 'Gloucestershire', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKK14', 'Swindon', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKK15', 'Wiltshire CC', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKK2'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKK21', 'Bournemouth and Poole', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKK22', 'Dorset CC', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKK23', 'Somerset', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKK3'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKK30', 'Cornwall and Isles of Scilly', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKK4'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKK41', 'Plymouth', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKK42', 'Torbay', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKK43', 'Devon CC', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKL1'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKL11', 'Isle of Anglesey', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKL12', 'Gwynedd', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKL13', 'Conwy and Denbighshire', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKL14', 'South West Wales', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKL15', 'Central Valleys', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKL16', 'Gwent Valleys', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKL17', 'Bridgend and Neath Port Talbot', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKL18', 'Swansea', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKL2'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKL21', 'Monmouthshire and Newport', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKL22', 'Cardiff and Vale of Glamorgan', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKL23', 'Flintshire and Wrexham', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKL24', 'Powys', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKM2'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKM21', 'Angus and Dundee City', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKM22', 'Clackmannanshire and Fife', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKM23', 'East Lothian and Midlothian', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKM24', 'Scottish Borders', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKM25', 'Edinburgh, City of', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKM26', 'Falkirk', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKM27', 'Perth & Kinross and Stirling', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKM28', 'West Lothian', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKM3'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKM31', 'East Dunbartonshire, West Dunbartonshire and Helensburgh & Lomond', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKM32', 'Dumfries & Galloway', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKM33', 'East Ayrshire and North Ayrshire mainland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKM34', 'Glasgow City', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKM35', 'Inverclyde, East Renfrewshire and Renfrewshire', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKM36', 'North Lanarkshire', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKM37', 'South Ayrshire', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKM38', 'South Lanarkshire', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKM5'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKM50', 'Aberdeen City and Aberdeenshire', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKM6'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKM61', 'Caithness & Sutherland and Ross & Cromarty', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKM62', 'Inverness & Nairn and Moray, Badenoch &amp; Strathspey', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKM63', 'Lochaber, Skye & Lochalsh, Arran & Cumbrae and Argyll & Bute', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKM64', 'Eilean Siar (Western Isles)', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKM65', 'Orkney Islands', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKM66', 'Shetland Islands', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKN0'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKN01', 'Belfast', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKN02', 'Outer Belfast', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKN03', 'East of Northern Ireland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKN04', 'North of Northern Ireland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'UKN05', 'West and South of Northern Ireland', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='UKZZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'UKZZZ', 'Extra-Regio', 2007, @NUTS2, @COUNTRY

GO
