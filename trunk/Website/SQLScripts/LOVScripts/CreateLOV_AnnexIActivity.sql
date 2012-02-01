INSERT INTO [dbo].[LOV_ANNEXIACTIVITY] (
    [Code],
    [Name],
    [IPPCCode],
    [StartYear],
    [ParentID]
)
 SELECT '1', 'Energy sector', NULL, 2007, NULL
  UNION ALL
 SELECT '2', 'Productiona and processing of metals', NULL, 2007, NULL
  UNION ALL
 SELECT '3', 'Mineral industry', NULL, 2007, NULL
  UNION ALL
 SELECT '4', 'Chemical industry', NULL, 2007, NULL
  UNION ALL
 SELECT '5', 'Waste and waste water management', NULL, 2007, NULL
  UNION ALL
 SELECT '6', 'Paper and wood production processing', NULL, 2007, NULL
  UNION ALL
 SELECT '7', 'Intensive livestock production and aquaculture', NULL, 2007, NULL
  UNION ALL
 SELECT '8', 'Animal and vegetable products from the food and beverage sector', NULL, 2007, NULL
  UNION ALL
 SELECT '9', 'Other activities', NULL, 2007, NULL
GO

DECLARE @S1 INT
SELECT @S1=[LOV_AnnexIActivityID] FROM [dbo].[LOV_ANNEXIACTIVITY] WHERE [Code]='1'
DECLARE @S2 INT
SELECT @S2=[LOV_AnnexIActivityID] FROM [dbo].[LOV_ANNEXIACTIVITY] WHERE [Code]='2'
DECLARE @S3 INT
SELECT @S3=[LOV_AnnexIActivityID] FROM [dbo].[LOV_ANNEXIACTIVITY] WHERE [Code]='3'
DECLARE @S4 INT
SELECT @S4=[LOV_AnnexIActivityID] FROM [dbo].[LOV_ANNEXIACTIVITY] WHERE [Code]='4'
DECLARE @S5 INT
SELECT @S5=[LOV_AnnexIActivityID] FROM [dbo].[LOV_ANNEXIACTIVITY] WHERE [Code]='5'
DECLARE @S6 INT
SELECT @S6=[LOV_AnnexIActivityID] FROM [dbo].[LOV_ANNEXIACTIVITY] WHERE [Code]='6'
DECLARE @S7 INT
SELECT @S7=[LOV_AnnexIActivityID] FROM [dbo].[LOV_ANNEXIACTIVITY] WHERE [Code]='7'
DECLARE @S8 INT
SELECT @S8=[LOV_AnnexIActivityID] FROM [dbo].[LOV_ANNEXIACTIVITY] WHERE [Code]='8'
DECLARE @S9 INT
SELECT @S9=[LOV_AnnexIActivityID] FROM [dbo].[LOV_ANNEXIACTIVITY] WHERE [Code]='9'

INSERT INTO [dbo].[LOV_ANNEXIACTIVITY] (
    [Code],
    [Name],
    [IPPCCode],
    [StartYear],
    [ParentID]
)
 SELECT '1.(a)', 'Mineral oil and gas refineries', '1.2', 2007, @S1
  UNION ALL
 SELECT '1.(b)', 'Installations for gasification and liquefaction', '1.4', 2007, @S1
  UNION ALL
 SELECT '1.(c)', 'Thermal power stations and other combustion installations', '1.1', 2007, @S1
  UNION ALL
 SELECT '1.(d)', 'Coke ovens', '1.3', 2007, @S1
  UNION ALL
 SELECT '1.(e)', 'Coal rolling mills', NULL, 2007, @S1
  UNION ALL
 SELECT '1.(f)', 'Installations for the manufacture of coal products and solid smokeless fuel', NULL, 2007, @S1
  UNION ALL
 SELECT '2.(a)', 'Metal ore (including sulphide ore) roasting or sintering installations', '2.1', 2007, @S2
  UNION ALL
 SELECT '2.(b)', 'Installations for the production of pig iron or steel (primary or secondary melting) including continuous casting', '2.2', 2007, @S2
  UNION ALL
 SELECT '2.(c)', 'Installations for the processing of ferrous metals', '2.3', 2007, @S2
  UNION ALL
 SELECT '2.(d)', 'Ferrous metal foundries', '2.4', 2007, @S2
  UNION ALL
 SELECT '2.(e)', 'Installations:', '2.5', 2007, @S2
  UNION ALL
 SELECT '2.(f)', 'Installations for surface treatment of metals and plastic materials using an electrolytic or chemical process', '2.6', 2007, @S2
  UNION ALL
 SELECT '3.(a)', 'Underground mining and related operations', NULL, 2007, @S3
  UNION ALL
 SELECT '3.(b)', 'Opencast mining and quarrying', NULL, 2007, @S3
  UNION ALL
 SELECT '3.(c)', 'Installations for the production of:', '3.1', 2007, @S3
  UNION ALL
 SELECT '3.(d)', 'Installations for the production of asbestos and the manufacture of asbestos-based products', '3.2', 2007, @S3
  UNION ALL
 SELECT '3.(e)', 'Installations for the manufacture of glass, including glass fibre', '3.3', 2007, @S3
  UNION ALL
 SELECT '3.(f)', 'Installations for melting mineral substances, including the production of mineral fibres', '3.4', 2007, @S3
  UNION ALL
 SELECT '3.(g)', 'Installations for the manufacture of ceramic products by firing, in particular roofing tiles, bricks, refractory bricks, tiles, stoneware or porcelain', '3.5', 2007, @S3
  UNION ALL
 SELECT '4.(a)', 'Chemical installations for the production on an industrial scale of basic organic chemicals, such as:', '4.1', 2007, @S4
  UNION ALL
 SELECT '4.(b)', 'Chemical installations for the production on an industrial scale of basic inorganic chemicals, such as:', '4.2', 2007, @S4
  UNION ALL
 SELECT '4.(c)', 'Chemical installations for the production on an industrial scale of phosphorous-, nitrogen- or potassium-based fertilisers (simple or compound fertilisers)', '4.3', 2007, @S4
  UNION ALL
 SELECT '4.(d)', 'Chemical installations for the production on an industrial scale of basic plant health products and of biocides', '4.4', 2007, @S4
  UNION ALL
 SELECT '4.(e)', 'Installations using a chemical or biological process for the production on an industrial scale of basic pharmaceutical products', '4.5', 2007, @S4
  UNION ALL
 SELECT '4.(f)', 'Installations for the production on an industrial scale of explosives and pyrotechnic products', '4.6', 2007, @S4
  UNION ALL
 SELECT '5.(a)', 'Installations for the recovery or disposal of hazardous waste', '5.1', 2007, @S5
  UNION ALL
 SELECT '5.(b)', 'Installations for the incineration of non-hazardous waste in the scope of Directive 2000/76/EC of the European Parliament and of the Council of 4 December 2000 on the incineration of waste', '5.2', 2007, @S5
  UNION ALL
 SELECT '5.(c)', 'Installations for the disposal of non-hazardous waste', '5.3', 2007, @S5
  UNION ALL
 SELECT '5.(d)', 'Landfills (see note in Guidance Document)', '5.4', 2007, @S5
  UNION ALL
 SELECT '5.(e)', 'Installations for the disposal or recycling of animal carcasses and animal waste', '6.5', 2007, @S5
  UNION ALL
 SELECT '5.(f)', 'Urban waste-water treatment plants', NULL, 2007, @S5
  UNION ALL
 SELECT '5.(g)', 'Independently operated industrial waste-water treatment plants which serve one or more activities of this annex', NULL, 2007, @S5
  UNION ALL
 SELECT '6.(a)', 'Industrial plants for the production of pulp from timber or similar fibrous materials', '6.1.(a)', 2007, @S6
  UNION ALL
 SELECT '6.(b)', 'Industrial plants for the production of paper and board and other primary wood products', '6.1.(b)', 2007, @S6
  UNION ALL
 SELECT '6.(c)', 'Industrial plants for the preservation of wood and wood products with chemicals', NULL, 2007, @S6
  UNION ALL
 SELECT '7.(a)', 'Installations for the intensive rearing of poultry or pigs', '6.6', 2007, @S7
  UNION ALL
 SELECT '7.(b)', 'Intensive aquaculture', NULL, 2007, @S7
  UNION ALL
 SELECT '8.(a)', 'Slaughterhouses', '6.4', 2007, @S8
  UNION ALL
 SELECT '8.(b)', 'Treatment and processing intended for the production of food and beverage products from:', NULL, 2007, @S8
  UNION ALL
 SELECT '8.(c)', 'Treatment and processing of milk', NULL, 2007, @S8
  UNION ALL
 SELECT '9.(a)', 'Plants for the pre-treatment (operations such as washing, bleaching, mercerisation) or dyeing of fibres or textiles', '6.2', 2007, @S9
  UNION ALL
 SELECT '9.(b)', 'Plants for the tanning of hides and skins', '6.3', 2007, @S9
  UNION ALL
 SELECT '9.(c)', 'Installations for the surface treatment of substances, objects or products using organic solvents, in particular for dressing, printing, coating, degreasing, waterproofing, sizing, painting, cleaning or impregnating', '6.7', 2007, @S9
  UNION ALL
 SELECT '9.(d)', 'Installations for the production of carbon (hard-burnt coal) or electro-graphite by means of incineration or graphitisation', '6.8', 2007, @S9
  UNION ALL
 SELECT '9.(e)', 'Installations for the building of, and painting or removal of paint from ships', NULL, 2007, @S9
GO

DECLARE @A2C INT
SELECT @A2C=[LOV_AnnexIActivityID] FROM [dbo].[LOV_ANNEXIACTIVITY] WHERE [Code]='2.(c)'
DECLARE @A2E INT
SELECT @A2E=[LOV_AnnexIActivityID] FROM [dbo].[LOV_ANNEXIACTIVITY] WHERE [Code]='2.(e)'
DECLARE @A3C INT
SELECT @A3C=[LOV_AnnexIActivityID] FROM [dbo].[LOV_ANNEXIACTIVITY] WHERE [Code]='3.(c)'
DECLARE @A4A INT
SELECT @A4A=[LOV_AnnexIActivityID] FROM [dbo].[LOV_ANNEXIACTIVITY] WHERE [Code]='4.(a)'
DECLARE @A4B INT
SELECT @A4B=[LOV_AnnexIActivityID] FROM [dbo].[LOV_ANNEXIACTIVITY] WHERE [Code]='4.(b)'
DECLARE @A7A INT
SELECT @A7A=[LOV_AnnexIActivityID] FROM [dbo].[LOV_ANNEXIACTIVITY] WHERE [Code]='7.(a)'
DECLARE @A8B INT
SELECT @A8B=[LOV_AnnexIActivityID] FROM [dbo].[LOV_ANNEXIACTIVITY] WHERE [Code]='8.(b)'

INSERT INTO [dbo].[LOV_ANNEXIACTIVITY] (
    [Code],
    [Name],
    [IPPCCode],
    [StartYear],
    [ParentID]
)
 SELECT '2.(c).(i)', '- Hot-rolling mills', '2.3.(a)', 2007, @A2C
  UNION ALL
 SELECT '2.(c).(ii)', '- Smitheries with hammers', '2.3.(b)', 2007, @A2C
  UNION ALL
 SELECT '2.(c).(iii)', '- Application of protective fused metal coats', '2.3.(c)', 2007, @A2C
  UNION ALL
 SELECT '2.(e).(i)', '- For the production of non-ferrous crude metals from ore, concentrates or secondary raw materials by metallurgical, chemical or electrolytic processes', '2.5.(a)', 2007, @A2E
  UNION ALL
 SELECT '2.(e).(ii)', '- For the smelting, including the alloying, of non-ferrous metals, including recovered products (refining, foundry casting, etc.)', '2.5.(b)', 2007, @A2E
  UNION ALL
 SELECT '3.(c).(i)', '- Cement clinker in rotary kilns', '3.1', 2007, @A3C
  UNION ALL
 SELECT '3.(c).(ii)', '- Lime in rotary kilns', '3.1', 2007, @A3C
  UNION ALL
 SELECT '3.(c).(iii)', '- Cement clinker or lime in other furnaces', '3.1', 2007, @A3C
  UNION ALL
 SELECT '4.(a).(i)', '- Simple hydrocarbons (linear or cyclic, saturated or unsaturated, aliphatic or aromatic)', '4.1.(a)', 2007, @A4A
  UNION ALL
 SELECT '4.(a).(ii)', '- Oxygen-containing hydrocarbons', '4.1.(b)', 2007, @A4A
  UNION ALL
 SELECT '4.(a).(iii)', '- Sulphurous hydrocarbons', '4.1.(c)', 2007, @A4A
  UNION ALL
 SELECT '4.(a).(iv)', '- Nitrogenous hydrocarbons', '4.1.(d)', 2007, @A4A
  UNION ALL
 SELECT '4.(a).(v)', '- Phosphorus-containing hydrocarbons', '4.1.(e)', 2007, @A4A
  UNION ALL
 SELECT '4.(a).(vi)', '- Halogenic hydrocarbons', '4.1.(f)', 2007, @A4A
  UNION ALL
 SELECT '4.(a).(vii)', '- Organometallic compounds', '4.1.(g)', 2007, @A4A
  UNION ALL
 SELECT '4.(a).(viii)', '- Basic plastic materials (polymers, synthetic fibres and cellulose-based fibres)', '4.1.(h)', 2007, @A4A
  UNION ALL
 SELECT '4.(a).(ix)', '- Synthetic rubbers', '4.1.(i)', 2007, @A4A
  UNION ALL
 SELECT '4.(a).(x)', '- Dyes and pigments', '4.1.(j)', 2007, @A4A
  UNION ALL
 SELECT '4.(a).(xi)', '- Surface-active agents and surfactants', '4.1.(k)', 2007, @A4A
  UNION ALL
 SELECT '4.(b).(i)', '- Gases', '4.2.(a)', 2007, @A4B
  UNION ALL
 SELECT '4.(b).(ii)', '- Acids', '4.2.(b)', 2007, @A4B
  UNION ALL
 SELECT '4.(b).(iii)', '- Bases', '4.2.(c)', 2007, @A4B
  UNION ALL
 SELECT '4.(b).(iv)', '- Salts', '4.2.(d)', 2007, @A4B
  UNION ALL
 SELECT '4.(b).(v)', '- Non-metals, metal oxides or other inorganic compounds', '4.2.(e)', 2007, @A4B
  UNION ALL
 SELECT '7.(a).(i)', '- With 40 000 places for poultry', '6.6.(a)', 2007, @A7A
  UNION ALL
 SELECT '7.(a).(ii)', '- With 2 000 places for production pigs (over 30kg)', '6.6.(b)', 2007, @A7A
  UNION ALL
 SELECT '7.(a).(iii)', '- With 750 places for sows', '6.6.(c)', 2007, @A7A
  UNION ALL
 SELECT '8.(b).(i)', '- Animal raw materials (other than milk)', NULL, 2007, @A8B
  UNION ALL
 SELECT '8.(b).(ii)', '- Vegetable raw materials', NULL, 2007, @A8B
GO
