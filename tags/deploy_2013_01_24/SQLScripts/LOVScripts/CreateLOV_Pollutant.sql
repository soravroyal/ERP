-- GROUPS ---------------------------------------------------------------------
INSERT INTO [dbo].[LOV_POLLUTANT] (
	[Code],
	[Name],
	[StartYear]
)
 SELECT 'GRHGAS', 'Greenhouse gases', 2007
  UNION ALL
 SELECT 'OTHGAS', 'Other gases', 2007
  UNION ALL
 SELECT 'HEVMET', 'Heavy metals', 2007
  UNION ALL
 SELECT 'PEST', 'Pesticides', 2007
  UNION ALL
 SELECT 'CHLORG', 'Chlorinated organic substances', 2007
  UNION ALL
 SELECT 'OTHORG', 'Other organic substances', 2007
  UNION ALL
 SELECT 'INORG', 'Inorganic substances', 2007
  UNION ALL
 SELECT 'BTEX', 'BTEX', 2007
GO

UPDATE [dbo].[LOV_POLLUTANT] SET [ParentID]=(
 SELECT [LOV_PollutantID] FROM [dbo].[LOV_POLLUTANT] WHERE [Code]='OTHORG')
 WHERE [Code]='BTEX'
GO

-- POLLUTANTS -----------------------------------------------------------------
DECLARE @GROUP INT
SELECT @GROUP=[LOV_PollutantID] FROM [dbo].[LOV_POLLUTANT] WHERE [Code]='GRHGAS'
INSERT INTO [dbo].[LOV_POLLUTANT] (
	[Code],
	[Name],
	[StartYear],
	[ParentID],
	[CAS]
)
 SELECT 'CH4', 'Methane (CH4)', 2007, @GROUP, '74-82-8'
  UNION ALL
 SELECT 'CO2', 'Carbon dioxide (CO2)', 2007, @GROUP, '124-38-9'
  UNION ALL
 SELECT 'HFCS', 'Hydro-fluorocarbons (HFCs)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'N2O', 'Nitrous oxide (N2O)', 2007, @GROUP, '10024-97-2'
  UNION ALL
 SELECT 'PFCS', 'Perfluorocarbons (PFCs)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'SF6', 'Sulphur hexafluoride (SF6)', 2007, @GROUP, '2551-62-4'

SELECT @GROUP=[LOV_PollutantID] FROM [dbo].[LOV_POLLUTANT] WHERE [Code]='OTHGAS'
INSERT INTO [dbo].[LOV_POLLUTANT] (
	[Code],
	[Name],
	[StartYear],
	[ParentID],
	[CAS]
)
 SELECT 'CO', 'Carbon monoxide (CO)', 2007, @GROUP, '630-08-0'
  UNION ALL
 SELECT 'NH3', 'Ammonia (NH3)', 2007, @GROUP, '7664-41-7'
  UNION ALL
 SELECT 'NMVOC', 'Non-methane volatile organic compounds (NMVOC)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'NOX', 'Nitrogen oxides (NOx/NO2)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'SOX', 'Sulphur oxides (SOx/SO2)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'HCFCS', 'Hydrochlorofluorocarbons(HCFCs)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'CFCS', 'Chlorofluorocarbons (CFCs)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'HALONS', 'Halons', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'CHLORINE AND INORGANIC COMPOUNDS', 'Chlorine and inorganic compounds (as HCl)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'FLUORINE AND INORGANIC COMPOUNDS', 'Fluorine and inorganic compounds (as HF)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'HCN', 'Hydrogen cyanide (HCN)', 2007, @GROUP, '74-90-8'

SELECT @GROUP=[LOV_PollutantID] FROM [dbo].[LOV_POLLUTANT] WHERE [Code]='HEVMET'
INSERT INTO [dbo].[LOV_POLLUTANT] (
	[Code],
	[Name],
	[StartYear],
	[ParentID],
	[CAS]
)
 SELECT 'AS AND COMPOUNDS', 'Arsenic and compounds (as As)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'CD AND COMPOUNDS', 'Cadmium and compounds (as Cd)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'CR AND COMPOUNDS', 'Chromium and compounds (as Cr)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'CU AND COMPOUNDS', 'Copper and compounds (as Cu)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'HG AND COMPOUNDS', 'Mercury and compounds (as Hg)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'NI AND COMPOUNDS', 'Nickel and compounds (as Ni)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'PB AND COMPOUNDS', 'Lead and compounds (as Pb)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'ZN AND COMPOUNDS', 'Zinc and compounds (as Zn)', 2007, @GROUP, NULL

SELECT @GROUP=[LOV_PollutantID] FROM [dbo].[LOV_POLLUTANT] WHERE [Code]='PEST'
INSERT INTO [dbo].[LOV_POLLUTANT] (
	[Code],
	[Name],
	[StartYear],
	[ParentID],
	[CAS]
)
 SELECT 'ALACHLOR', 'Alachlor', 2007, @GROUP, '15972-60-8'
  UNION ALL
 SELECT 'ALDRIN', 'Aldrin', 2007, @GROUP, '309-00-2'
  UNION ALL
 SELECT 'ATRAZINE', 'Atrazine', 2007, @GROUP, '1912-24-9'
  UNION ALL
 SELECT 'CLORDANE', 'Chlordane', 2007, @GROUP, '57-74-9'
  UNION ALL
 SELECT 'CHLORDECONE', 'Chlordecone', 2007, @GROUP, '143-50-0'
  UNION ALL
 SELECT 'CHLORFENVINPHOS', 'Chlorfenvinphos', 2007, @GROUP, '470-90-6'
  UNION ALL
 SELECT 'CHLORPYRIFOS', 'Chlorpyrifos', 2007, @GROUP, '2921-88-2'
  UNION ALL
 SELECT 'DDT', 'DDT', 2007, @GROUP, '50-29-3'
  UNION ALL
 SELECT 'DIELDRIN', 'Dieldrin', 2007, @GROUP, '60-57-1'
  UNION ALL
 SELECT 'DIURON', 'Diuron', 2007, @GROUP, '330-54-1'
  UNION ALL
 SELECT 'ENDOSULPHAN', 'Endosulphan', 2007, @GROUP, '115-29-7'
  UNION ALL
 SELECT 'ENDRIN', 'Endrin', 2007, @GROUP, '72-20-8'
  UNION ALL
 SELECT 'HEPTACHLOR', 'Heptachlor', 2007, @GROUP, '76-44-8'
  UNION ALL
 SELECT 'HEXACHLOROCYCLOHEXANE(HCH)', '1,2,3,4,5,6-hexachlorocyclohexane (HCH)', 2007, @GROUP, '608-73-1'
  UNION ALL
 SELECT 'LINDANE', 'Lindane', 2007, @GROUP, '58-89-9'
  UNION ALL
 SELECT 'MIREX', 'Mirex', 2007, @GROUP, '2385-85-5'
  UNION ALL
 SELECT 'SIMAZINE', 'Simazine', 2007, @GROUP, '122-34-9'
  UNION ALL
 SELECT 'TOXAPHENE', 'Toxaphene', 2007, @GROUP, '8001-35-2'
  UNION ALL
 SELECT 'ISOPROTURON', 'Isoproturon', 2007, @GROUP, '34123-59-6'
  UNION ALL
 SELECT 'TRIBUTYLTIN AND COMPOUNDS', 'Tributyltin and compounds', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'TRIPHENYLTIN AND COMPOUNDS', 'Triphenyltin and compounds', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'TRIFLURALIN', 'Trifluralin', 2007, @GROUP, '1582-09-8'
  UNION ALL
 SELECT 'ISODRIN', 'Isodrin', 2007, @GROUP, '465-73-6'

SELECT @GROUP=[LOV_PollutantID] FROM [dbo].[LOV_POLLUTANT] WHERE [Code]='CHLORG'
INSERT INTO [dbo].[LOV_POLLUTANT] (
	[Code],
	[Name],
	[StartYear],
	[ParentID],
	[CAS]
)
 SELECT 'CHLORO-ALKANES (C10-13)', 'Chloro-alkanes, C10-C13', 2007, @GROUP, '85535-84-8'
  UNION ALL
 SELECT 'DICHLOROETHANE-1,2 (DCE)', '1,2-dichloroethane (DCE)', 2007, @GROUP, '107-06-2'
  UNION ALL
 SELECT 'DICHLOROMETHANE (DCM)', 'Dichloromethane (DCM)', 2007, @GROUP, '75-09-2'
  UNION ALL
 SELECT 'HALOGENATED ORGANIC COMPOUNDS', 'Halogenated organic compounds (as AOX)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'HEXACHLOROBENZENE (HCB)', 'Hexachlorobenzene (HCB)', 2007, @GROUP, '118-74-1'
  UNION ALL
 SELECT 'HEXACHLOROBUTADIENE (HCBD)', 'Hexachlorobutadiene (HCBD)', 2007, @GROUP, '87-68-3'
  UNION ALL
 SELECT 'PCDD+PCDF (DIOXINS+FURANS)', 'PCDD + PCDF (dioxins + furans) (as Teq)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'PENTACHLOROBENZENE', 'Pentachlorobenzene', 2007, @GROUP, '608-93-5'
  UNION ALL
 SELECT 'PENTACHLOROPHENOL (PCP)', 'Pentachlorophenol (PCP)', 2007, @GROUP, '87-86-5'
  UNION ALL
 SELECT 'POLYCHLORINATED BIPHENYLS (PCBS)', 'Polychlorinated biphenyls (PCBs)', 2007, @GROUP, '1336-36-3'
  UNION ALL
 SELECT 'TETRACHLOROETHYLENE (PER)', 'Tetrachloroethylene (PER)', 2007, @GROUP, '127-18-4'
  UNION ALL
 SELECT 'TETRACHLOROMETHANE (TCM)', 'Tetrachloromethane (TCM)', 2007, @GROUP, '56-23-5'
  UNION ALL
 SELECT 'TRICHLOROBENZENES (TCB)', 'Trichlorobenzenes (TCBs) (all isomers)', 2007, @GROUP, '12002-48-1'
  UNION ALL
 SELECT 'TRICHLOROETHANE-1,1,1 (TCE)', '1,1,1-trichloroethane', 2007, @GROUP, '71-55-6'
  UNION ALL
 SELECT 'TETRACHLOROETHANE-1,1,2,2', '1,1,2,2-tetrachloroethane', 2007, @GROUP, '79-34-5'
  UNION ALL
 SELECT 'TRICHLOROETHYLENE (TRI)', 'Trichloroethylene', 2007, @GROUP, '79-01-6'
  UNION ALL
 SELECT 'TRICHLOROMETHANE', 'Trichloromethane', 2007, @GROUP, '67-66-3'
  UNION ALL
 SELECT 'VINYL CHLORIDE', 'Vinyl chloride', 2007, @GROUP, '75-01-4'
  UNION ALL
 SELECT 'BROMINATED DIPHENYLETHER', 'Brominated diphenylethers (PBDE)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'HEXABROMOBIPHENYL', 'Hexabromobiphenyl', 2007, @GROUP, '36355-1-8'

SELECT @GROUP=[LOV_PollutantID] FROM [dbo].[LOV_POLLUTANT] WHERE [Code]='OTHORG'
INSERT INTO [dbo].[LOV_POLLUTANT] (
	[Code],
	[Name],
	[StartYear],
	[ParentID],
	[CAS]
)
 SELECT 'ANTHRACENE', 'Anthracene', 2007, @GROUP, '120-12-7'
  UNION ALL
 SELECT 'NP/NPES', 'Nonylphenol and Nonylphenol ethoxylates (NP/NPEs)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'ETHYLENE OXIDE', 'Ethylene oxide', 2007, @GROUP, '75-21-8'
  UNION ALL
 SELECT 'NAPHTHALENE', 'Naphthalene', 2007, @GROUP, '91-20-3'
  UNION ALL
 SELECT 'ORGANOTIN - COMPOUNDS', 'Organotin compounds (as total Sn)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'DEHP', 'Di-(2-ethyl hexyl) phthalate (DEHP)', 2007, @GROUP, '117-81-7'
  UNION ALL
 SELECT 'PHENOLS', 'Phenols (as total C)', 2007, @GROUP, '108-95-2'
  UNION ALL
 SELECT 'POLYCYCLIC AROMATIC HYDROCARBONS', 'Polycyclic aromatic hydrocarbons (PAHs)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'TOTAL ORGANIC CARBON (TOC)', 'Total organic carbon (TOC) (as total C or COD/3)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'OCTYLPHENOLS AND OCTYLPHENOL ETHOXYLATES', 'Octylphenols and Octylphenol ethoxylates', 2007, @GROUP, '1806-26-4'
  UNION ALL
 SELECT 'FLUORANTHENE', 'Fluoranthene', 2007, @GROUP, '206-44-0'
  UNION ALL
 SELECT 'BENZO(G,H,I)PERYLENE', 'Benzo(g,h,i)perylene', 2007, @GROUP, '191-24-2'

SELECT @GROUP=[LOV_PollutantID] FROM [dbo].[LOV_POLLUTANT] WHERE [Code]='BTEX'
INSERT INTO [dbo].[LOV_POLLUTANT] (
	[Code],
	[Name],
	[StartYear],
	[ParentID],
	[CAS]
)
 SELECT 'BENZENE', 'Benzene', 2007, @GROUP, '71-43-2'
  UNION ALL
 SELECT 'ETHYLBENZENE', 'Ethyl benzene', 2007, @GROUP, '100-41-4'
  UNION ALL
 SELECT 'TOLUENE', 'Toluene', 2007, @GROUP, '108-88-3'
  UNION ALL
 SELECT 'XYLENES', 'Xylenes', 2007, @GROUP, '1330-20-7'

SELECT @GROUP=[LOV_PollutantID] FROM [dbo].[LOV_POLLUTANT] WHERE [Code]='INORG'
INSERT INTO [dbo].[LOV_POLLUTANT] (
	[Code],
	[Name],
	[StartYear],
	[ParentID],
	[CAS]
)
 SELECT 'TOTAL - NITROGEN', 'Total nitrogen', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'TOTAL - PHOSPHORUS', 'Total phosphorus', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'CHLORIDES', 'Chlorides (as total Cl)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'ASBESTOS', 'Asbestos', 2007, @GROUP, '1332-21-4'
  UNION ALL
 SELECT 'CYANIDES', 'Cyanides (as total CN)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'FLUORIDES', 'Fluorides (as total F)', 2007, @GROUP, NULL
  UNION ALL
 SELECT 'PM10', 'Particulate matter (PM10)', 2007, @GROUP, NULL

GO

INSERT INTO [dbo].[LOV_POLLUTANT] (
	[Code],
	[Name],
	[StartYear],
    [EndYear],
	[ParentID],
	[CAS]
)
 VALUES ('PAHs in EPER', 'Polycyclic Aromatic Hydrocarbons (PAH in EPER)', 2001, 2004, 6, NULL)
GO
