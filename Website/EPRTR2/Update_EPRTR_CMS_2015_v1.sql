USE [EPRTRcms]
GO

DECLARE @cntgrp int
/*
* APPEND ContentsGroups
*/
INSERT INTO [dbo].[LOV_ContentsGroup]
 ([Code]
 ,[Name]
 ,[StartYear])
 VALUES
 ('DIFSRC_WATER_ANTHRACENE', 'Diffuse Sources Water, Anthracene', 2015),
 ('DIFSRC_WATER_CD', 'Diffuse Sources Water, CD', 2015),
 ('DIFSRC_WATER_CO', 'Diffuse Sources Water, CO', 2015),
 ('DIFSRC_WATER__FLUORANTHENE', 'Diffuse Sources Water, Fluoranthene', 2015),
 ('DIFSRC_WATER_HG', 'Diffuse Sources Water, HG', 2015),
 ('DIFSRC_WATER_NI', 'Diffuse Sources Water, NI', 2015),
 ('DIFSRC_WATER_N', 'Diffuse Sources Water, N', 2015),
 ('DIFSRC_WATER_PB', 'Diffuse Sources Water, PB', 2015),
 ('DIFSRC_WATER_P', 'Diffuse Sources Water, P', 2015),
 ('DIFSRC_WATER_TOC', 'Diffuse Sources Water, TOC', 2015),
 ('DIFSRC_WATER_ZN', 'Diffuse Sources Water, ZN', 2015),
 ('LCP', 'Large Combustion Plants', 2015);
 --('FAQ', 'FAQ, ', 2015),
 --('GLOSSARY', 'Glossary', 2015)

/*
* APPEND ReviseResourceKeys with correct LOV_ContentsGroupIDs
*/
SET @cntgrp = (SELECT [LOV_ContentsGroupID] FROM [dbo].[LOV_ContentsGroup] where Code = 'DIFSRC_WATER_ANTHRACENE');

INSERT INTO [dbo].[ReviseResourceKey]
 ([ResourceKey]
 ,[ResourceType]
 ,[AllowHTML]
 ,[KeyDescription]
 ,[KeyTitle]
 ,[ContentsGroupID])
 VALUES
('WATER_ANTHRACENE_InlandNavigation.GeneralInformation','DiffuseSources','1','','Inland Navigation, General Information',@cntgrp),
('WATER_ANTHRACENE_InlandNavigation.Methodology','DiffuseSources','1','','Inland Navigation, Methodology',@cntgrp),
('WATER_ANTHRACENE_InlandNavigation.SourceData','DiffuseSources','1','','Inland Navigation, Source Data',@cntgrp),
('WATER_ANTHRACENE_InlandNavigation.TitleFull','DiffuseSources','0','','Inland Navigation, Title Full',@cntgrp),
('WATER_ANTHRACENE_InlandNavigation.TitleShort','DiffuseSources','0','','Inland Navigation, Title Short',@cntgrp),
('WATER_ANTHRACENE_Transport.GeneralInformation','DiffuseSources','1','','Transport, General Information',@cntgrp),
('WATER_ANTHRACENE_Transport.Methodology','DiffuseSources','1','','Transport, Methodology',@cntgrp),
('WATER_ANTHRACENE_Transport.SourceData','DiffuseSources','1','','Transport, Source Data',@cntgrp),
('WATER_ANTHRACENE_Transport.TitleFull','DiffuseSources','0','','Transport, Title Full',@cntgrp),
('WATER_ANTHRACENE_Transport.TitleShort','DiffuseSources','0','','Transport, Title Short',@cntgrp),
('WATER_ANTHRACENE_UWWTP.GeneralInformation','DiffuseSources','1','','UWWTP, General Information',@cntgrp),
('WATER_ANTHRACENE_UWWTP.Methodology','DiffuseSources','1','','UWWTP, Methodology',@cntgrp),
('WATER_ANTHRACENE_UWWTP.SourceData','DiffuseSources','1','','UWWTP, Source Data',@cntgrp),
('WATER_ANTHRACENE_UWWTP.TitleFull','DiffuseSources','0','','UWWTP, Title Full',@cntgrp),
('WATER_ANTHRACENE_UWWTP.TitleShort','DiffuseSources','0','','UWWTP, Title Short',@cntgrp),
('WATER_ANTHRACENE_UnconnectedHouseholds.GeneralInformation','DiffuseSources','1','','Unconnected Households, General Information',@cntgrp),
('WATER_ANTHRACENE_UnconnectedHouseholds.Methodology','DiffuseSources','1','','Unconnected Households, Methodology',@cntgrp),
('WATER_ANTHRACENE_UnconnectedHouseholds.SourceData','DiffuseSources','1','','Unconnected Households, Source Data',@cntgrp),
('WATER_ANTHRACENE_UnconnectedHouseholds.TitleFull','DiffuseSources','0','','Unconnected Households, Title Full',@cntgrp),
('WATER_ANTHRACENE_UnconnectedHouseholds.TitleShort','DiffuseSources','0','','Unconnected Households, Title Short',@cntgrp);

SET @cntgrp = (SELECT [LOV_ContentsGroupID] FROM [dbo].[LOV_ContentsGroup] where Code = 'DIFSRC_WATER_CD');

INSERT INTO [dbo].[ReviseResourceKey]
 ([ResourceKey]
 ,[ResourceType]
 ,[AllowHTML]
 ,[KeyDescription]
 ,[KeyTitle]
 ,[ContentsGroupID])
 VALUES
('WATER_CD_AtmosphericDeposition.GeneralInformation','DiffuseSources','1','','Atmospheric Deposition, GeneralIn formation',@cntgrp),
('WATER_CD_AtmosphericDeposition.Methodology','DiffuseSources','1','', 'Atmospheric Deposition, Methodology ',@cntgrp),
('WATER_CD_AtmosphericDeposition.SourceData','DiffuseSources','1','','Atmospheric Deposition, Source Data ',@cntgrp),
('WATER_CD_AtmosphericDeposition.TitleFull','DiffuseSources','0','', 'Atmospheric Deposition, Title Full ',@cntgrp),
('WATER_CD_AtmosphericDeposition.TitleShort','DiffuseSources','0','', 'Atmospheric Deposition, Title Short ',@cntgrp),
('WATER_CD_Transport.GeneralInformation','DiffuseSources','1','', 'Transport, General Information ',@cntgrp),
('WATER_CD_Transport.Methodology','DiffuseSources','1','', 'Transport, Methodology ',@cntgrp),
('WATER_CD_Transport.SourceData','DiffuseSources','1','','Transport, Source Data ',@cntgrp),
('WATER_CD_Transport.TitleFull','DiffuseSources','0','','Transport, Title Full ',@cntgrp),
('WATER_CD_Transport.TitleShort','DiffuseSources','0','', 'Transport, Title Short ',@cntgrp),
('WATER_CD_UWWTP.GeneralInformation','DiffuseSources','1','', 'UWWTP, General Information ',@cntgrp),
('WATER_CD_UWWTP.Methodology','DiffuseSources','1','', 'UWWTP, Methodology ',@cntgrp),
('WATER_CD_UWWTP.SourceData','DiffuseSources','1','', 'UWWTP, Source Data ',@cntgrp),
('WATER_CD_UWWTP.TitleFull','DiffuseSources','0','', 'UWWTP, Title Full ',@cntgrp),
('WATER_CD_UWWTP.TitleShort','DiffuseSources','0','', 'UWWTP, Title Short ',@cntgrp),
('WATER_CD_UnconnectedHouseholds.GeneralInformation','DiffuseSources','1','','Unconnected Households, General Information',@cntgrp),
('WATER_CD_UnconnectedHouseholds.Methodology','DiffuseSources','1','', 'Unconnected Households, Methodology ',@cntgrp),
('WATER_CD_UnconnectedHouseholds.SourceData','DiffuseSources','1','', 'Unconnected Households, Source Data ',@cntgrp),
('WATER_CD_UnconnectedHouseholds.TitleFull','DiffuseSources','0','', 'Unconnected Households, Title Full ',@cntgrp),
('WATER_CD_UnconnectedHouseholds.TitleShort','DiffuseSources','0','', 'Unconnected Households, Title Short ',@cntgrp);

SET @cntgrp = (SELECT [LOV_ContentsGroupID] FROM [dbo].[LOV_ContentsGroup] where Code = 'DIFSRC_WATER_CO');

INSERT INTO [dbo].[ReviseResourceKey]
 ([ResourceKey]
 ,[ResourceType]
 ,[AllowHTML]
 ,[KeyDescription]
 ,[KeyTitle]
 ,[ContentsGroupID])
 VALUES
('WATER_CO_Transport.GeneralInformation','DiffuseSources','1','', 'Transport, General Information ',@cntgrp),
('WATER_CO_Transport.Methodology','DiffuseSources','1','', 'Transport, Methodology ',@cntgrp),
('WATER_CO_Transport.SourceData','DiffuseSources','1','', 'Transport, Source Data ',@cntgrp),
('WATER_CO_Transport.TitleFull','DiffuseSources','0','', 'Transport, Title Full ',@cntgrp),
('WATER_CO_Transport.TitleShort','DiffuseSources','0','', 'Transport, Title Short ',@cntgrp),
('WATER_CO_UWWTP.GeneralInformation','DiffuseSources','1','', 'UWWTP, General Information ',@cntgrp),
('WATER_CO_UWWTP.Methodology','DiffuseSources','1','', 'UWWTP, Methodology ',@cntgrp),
('WATER_CO_UWWTP.SourceData','DiffuseSources','1','', 'UWWTP, Source Data ',@cntgrp),
('WATER_CO_UWWTP.TitleFull','DiffuseSources','0','', 'UWWTP, Title Full ',@cntgrp),
('WATER_CO_UWWTP.TitleShort','DiffuseSources','0','', 'UWWTP, Title Short ',@cntgrp),
('WATER_CO_UnconnectedHouseholds.GeneralInformation','DiffuseSources','1','','Unconnected Households, General Information',@cntgrp),
('WATER_CO_UnconnectedHouseholds.Methodology','DiffuseSources','1','', 'Unconnected Households, Methodology ',@cntgrp),
('WATER_CO_UnconnectedHouseholds.SourceData','DiffuseSources','1','', 'Unconnected Households, Source Data ',@cntgrp),
('WATER_CO_UnconnectedHouseholds.TitleFull','DiffuseSources','0','', 'Unconnected Households, Title Full ',@cntgrp),
('WATER_CO_UnconnectedHouseholds.TitleShort','DiffuseSources','0','', 'Unconnected Households, Title Short ',@cntgrp);

SET @cntgrp = (SELECT [LOV_ContentsGroupID] FROM [dbo].[LOV_ContentsGroup] where Code = 'DIFSRC_WATER_FLUORANTHENE');

INSERT INTO [dbo].[ReviseResourceKey]
 ([ResourceKey]
 ,[ResourceType]
 ,[AllowHTML]
 ,[KeyDescription]
 ,[KeyTitle]
 ,[ContentsGroupID])
 VALUES
('WATER_FLUORANTHENE_InlandNavigation.GeneralInformation','DiffuseSources','1','','Inland Navigation, General Information',@cntgrp),
('WATER_FLUORANTHENE_InlandNavigation.Methodology','DiffuseSources','1','','Inland Navigation, Methodology',@cntgrp),
('WATER_FLUORANTHENE_InlandNavigation.SourceData','DiffuseSources','1','','Inland Navigation, Source Data',@cntgrp),
('WATER_FLUORANTHENE_InlandNavigation.TitleFull','DiffuseSources','0','','Inland Navigation, Title Full',@cntgrp),
('WATER_FLUORANTHENE_InlandNavigation.TitleShort','DiffuseSources','0','','Inland Navigation, Title Short',@cntgrp),
('WATER_FLUORANTHENE_Transport.GeneralInformation','DiffuseSources','1','','Transport, General Information',@cntgrp),
('WATER_FLUORANTHENE_Transport.Methodology','DiffuseSources','1','','Transport, Methodology',@cntgrp),
('WATER_FLUORANTHENE_Transport.SourceData','DiffuseSources','1','','Transport, Source Data',@cntgrp),
('WATER_FLUORANTHENE_Transport.TitleFull','DiffuseSources','0','','Transport, Title Full',@cntgrp),
('WATER_FLUORANTHENE_Transport.TitleShort','DiffuseSources','0','','Transport, Title Short',@cntgrp),
('WATER_FLUORANTHENE_UWWTP.GeneralInformation','DiffuseSources','1','','UWWTP, General Information',@cntgrp),
('WATER_FLUORANTHENE_UWWTP.Methodology','DiffuseSources','1','','UWWTP, Methodology',@cntgrp),
('WATER_FLUORANTHENE_UWWTP.SourceData','DiffuseSources','1','','UWWTP, Source Data',@cntgrp),
('WATER_FLUORANTHENE_UWWTP.TitleFull','DiffuseSources','0','','UWWTP, Title Full',@cntgrp),
('WATER_FLUORANTHENE_UWWTP.TitleShort','DiffuseSources','0','','UWWTP, Title Short',@cntgrp),
('WATER_FLUORANTHENE_UnconnectedHouseholds.GeneralInformation','DiffuseSources','1','','Unconnected Households, General Information',@cntgrp),
('WATER_FLUORANTHENE_UnconnectedHouseholds.Methodology','DiffuseSources','1','','Unconnected Households, Methodology',@cntgrp),
('WATER_FLUORANTHENE_UnconnectedHouseholds.SourceData','DiffuseSources','1','','Unconnected Households, Source Data',@cntgrp),
('WATER_FLUORANTHENE_UnconnectedHouseholds.TitleFull','DiffuseSources','0','','Unconnected Households, Title Full',@cntgrp),
('WATER_FLUORANTHENE_UnconnectedHouseholds.TitleShort','DiffuseSources','0','','Unconnected Households, Title Short',@cntgrp);

SET @cntgrp = (SELECT [LOV_ContentsGroupID] FROM [dbo].[LOV_ContentsGroup] where Code = 'DIFSRC_WATER_HG');

INSERT INTO [dbo].[ReviseResourceKey]
 ([ResourceKey]
 ,[ResourceType]
 ,[AllowHTML]
 ,[KeyDescription]
 ,[KeyTitle]
 ,[ContentsGroupID])
 VALUES
('WATER_HG_AtmosphericDeposition.GeneralInformation','DiffuseSources','1','','Atmospheric Deposition, General Information',@cntgrp),
('WATER_HG_AtmosphericDeposition.Methodology','DiffuseSources','1','','Atmospheric Deposition, Methodology',@cntgrp),
('WATER_HG_AtmosphericDeposition.SourceData','DiffuseSources','1','','Atmospheric Deposition, Source Data',@cntgrp),
('WATER_HG_AtmosphericDeposition.TitleFull','DiffuseSources','0','','Atmospheric Deposition, Title Full',@cntgrp),
('WATER_HG_AtmosphericDeposition.TitleShort','DiffuseSources','0','','Atmospheric Deposition, Title Short',@cntgrp),
('WATER_HG_UWWTP.GeneralInformation','DiffuseSources','1','','UWWTP, General Information',@cntgrp),
('WATER_HG_UWWTP.Methodology','DiffuseSources','1','','UWWTP, Methodology',@cntgrp),
('WATER_HG_UWWTP.SourceData','DiffuseSources','1','','UWWTP, Source Data',@cntgrp),
('WATER_HG_UWWTP.TitleFull','DiffuseSources','0','','UWWTP, Title Full',@cntgrp),
('WATER_HG_UWWTP.TitleShort','DiffuseSources','0','','UWWTP, Title Short',@cntgrp),
('WATER_HG_UnconnectedHouseholds.GeneralInformation','DiffuseSources','1','','Unconnected Households, General Information',@cntgrp),
('WATER_HG_UnconnectedHouseholds.Methodology','DiffuseSources','1','','Unconnected Households, Methodology',@cntgrp),
('WATER_HG_UnconnectedHouseholds.SourceData','DiffuseSources','1','','Unconnected Households, Source Data',@cntgrp),
('WATER_HG_UnconnectedHouseholds.TitleFull','DiffuseSources','0','','Unconnected Households, Title Full',@cntgrp),
('WATER_HG_UnconnectedHouseholds.TitleShort','DiffuseSources','0','','Unconnected Households, Title Short',@cntgrp);

SET @cntgrp = (SELECT [LOV_ContentsGroupID] FROM [dbo].[LOV_ContentsGroup] where Code = 'DIFSRC_WATER_NI');

INSERT INTO [dbo].[ReviseResourceKey]
 ([ResourceKey]
 ,[ResourceType]
 ,[AllowHTML]
 ,[KeyDescription]
 ,[KeyTitle]
 ,[ContentsGroupID])
 VALUES
('WATER_NI_Transport.GeneralInformation','DiffuseSources','1','','Transport, General Information ',@cntgrp),
('WATER_NI_Transport.Methodology','DiffuseSources','1','','Transport, Methodology ',@cntgrp),
('WATER_NI_Transport.SourceData','DiffuseSources','1','','Transport, Source Data ',@cntgrp),
('WATER_NI_Transport.TitleFull','DiffuseSources','0','','Transport, Title Full ',@cntgrp),
('WATER_NI_Transport.TitleShort','DiffuseSources','0','','Transport, Title Short ',@cntgrp),
('WATER_NI_UWWTP.GeneralInformation','DiffuseSources','1','','UWWTP, General Information ',@cntgrp),
('WATER_NI_UWWTP.Methodology','DiffuseSources','1','','UWWTP, Methodology ',@cntgrp),
('WATER_NI_UWWTP.SourceData','DiffuseSources','1','','UWWTP, Source Data ',@cntgrp),
('WATER_NI_UWWTP.TitleFull','DiffuseSources','0','','UWWTP, Title Full ',@cntgrp),
('WATER_NI_UWWTP.TitleShort','DiffuseSources','0','','UWWTP, Title Short ',@cntgrp),
('WATER_NI_UnconnectedHouseholds.GeneralInformation','DiffuseSources','1','','Unconnected Households, General Information',@cntgrp),
('WATER_NI_UnconnectedHouseholds.Methodology','DiffuseSources','1','','Unconnected Households, Methodology ',@cntgrp),
('WATER_NI_UnconnectedHouseholds.SourceData','DiffuseSources','1','','Unconnected Households, Source Data ',@cntgrp),
('WATER_NI_UnconnectedHouseholds.TitleFull','DiffuseSources','0','','Unconnected Households, Title Full ',@cntgrp),
('WATER_NI_UnconnectedHouseholds.TitleShort','DiffuseSources','0','','Unconnected Households, Title Short ',@cntgrp);

SET @cntgrp = (SELECT [LOV_ContentsGroupID] FROM [dbo].[LOV_ContentsGroup] where Code = 'DIFSRC_WATER_N');

INSERT INTO [dbo].[ReviseResourceKey]
 ([ResourceKey]
 ,[ResourceType]
 ,[AllowHTML]
 ,[KeyDescription]
 ,[KeyTitle]
 ,[ContentsGroupID])
 VALUES
('WATER_N_Agriculture.GeneralInformation','DiffuseSources','1','','Agriculture, General Information ',@cntgrp),
('WATER_N_Agriculture.Methodology','DiffuseSources','1','','Agriculture, Methodology ',@cntgrp),
('WATER_N_Agriculture.SourceData','DiffuseSources','1','','Agriculture, Source Data ',@cntgrp),
('WATER_N_Agriculture.TitleFull','DiffuseSources','0','','Agriculture, Title Full ',@cntgrp),
('WATER_N_Agriculture.TitleShort','DiffuseSources','0','','Agriculture, Title Short ',@cntgrp),
('WATER_N_AtmosphericDeposition.GeneralInformation','DiffuseSources','1','','Atmospheric Deposition, General Information',@cntgrp),
('WATER_N_AtmosphericDeposition.Methodology','DiffuseSources','1','','Atmospheric Deposition, Methodology ',@cntgrp),
('WATER_N_AtmosphericDeposition.SourceData','DiffuseSources','1','','Atmospheric Deposition, Source Data ',@cntgrp),
('WATER_N_AtmosphericDeposition.TitleFull','DiffuseSources','0','','Atmospheric Deposition, Title Full ',@cntgrp),
('WATER_N_AtmosphericDeposition.TitleShort','DiffuseSources','0','','Atmospheric Deposition, Title Short ',@cntgrp),
('WATER_N_InlandNavigation.GeneralInformation','DiffuseSources','1','','Inland Navigation, General Information ',@cntgrp),
('WATER_N_InlandNavigation.Methodology','DiffuseSources','1','','Inland Navigation, Methodology ',@cntgrp),
('WATER_N_InlandNavigation.SourceData','DiffuseSources','1','','Inland Navigation, Source Data ',@cntgrp),
('WATER_N_InlandNavigation.TitleFull','DiffuseSources','0','','Inland Navigation, Title Full ',@cntgrp),
('WATER_N_InlandNavigation.TitleShort','DiffuseSources','0','','Inland Navigation, Title Short ',@cntgrp),
('WATER_N_UWWTP.GeneralInformation','DiffuseSources','1','','UWWTP, General Information ',@cntgrp),
('WATER_N_UWWTP.Methodology','DiffuseSources','1','','UWWTP, Methodology ',@cntgrp),
('WATER_N_UWWTP.SourceData','DiffuseSources','1','','UWWTP, Source Data ',@cntgrp),
('WATER_N_UWWTP.TitleFull','DiffuseSources','0','','UWWTP, Title Full ',@cntgrp),
('WATER_N_UWWTP.TitleShort','DiffuseSources','0','','UWWTP, Title Short ',@cntgrp),
('WATER_N_UnconnectedHouseholds.GeneralInformation','DiffuseSources','1','','Unconnected Households, General Information',@cntgrp),
('WATER_N_UnconnectedHouseholds.Methodology','DiffuseSources','1','','Unconnected Households, Methodology ',@cntgrp),
('WATER_N_UnconnectedHouseholds.SourceData','DiffuseSources','1','','Unconnected Households, Source Data ',@cntgrp),
('WATER_N_UnconnectedHouseholds.TitleFull','DiffuseSources','0','','Unconnected Households, Title Full ',@cntgrp),
('WATER_N_UnconnectedHouseholds.TitleShort','DiffuseSources','0','','Unconnected Households, Title Short ',@cntgrp);

SET @cntgrp = (SELECT [LOV_ContentsGroupID] FROM [dbo].[LOV_ContentsGroup] where Code = 'DIFSRC_WATER_PB');

INSERT INTO [dbo].[ReviseResourceKey]
 ([ResourceKey]
 ,[ResourceType]
 ,[AllowHTML]
 ,[KeyDescription]
 ,[KeyTitle]
 ,[ContentsGroupID])
 VALUES
('WATER_PB_AtmosphericDeposition.GeneralInformation','DiffuseSources','1','','Atmospheric Deposition, General Information',@cntgrp),
('WATER_PB_AtmosphericDeposition.Methodology','DiffuseSources','1','','Atmospheric Deposition, Methodology ',@cntgrp),
('WATER_PB_AtmosphericDeposition.SourceData','DiffuseSources','1','','Atmospheric Deposition, Source Data ',@cntgrp),
('WATER_PB_AtmosphericDeposition.TitleFull','DiffuseSources','0','','Atmospheric Deposition, Title Full ',@cntgrp),
('WATER_PB_AtmosphericDeposition.TitleShort','DiffuseSources','0','','Atmospheric Deposition, Title Short ',@cntgrp),
('WATER_PB_Transport.GeneralInformation','DiffuseSources','1','','Transport, General Information ',@cntgrp),
('WATER_PB_Transport.Methodology','DiffuseSources','1','','Transport, Methodology ',@cntgrp),
('WATER_PB_Transport.SourceData','DiffuseSources','1','','Transport, Source Data ',@cntgrp),
('WATER_PB_Transport.TitleFull','DiffuseSources','0','','Transport, Title Full ',@cntgrp),
('WATER_PB_Transport.TitleShort','DiffuseSources','0','','Transport, Title Short ',@cntgrp),
('WATER_PB_UWWTP.GeneralInformation','DiffuseSources','1','','UWWTP, General Information ',@cntgrp),
('WATER_PB_UWWTP.Methodology','DiffuseSources','1','','UWWTP, Methodology ',@cntgrp),
('WATER_PB_UWWTP.SourceData','DiffuseSources','1','','UWWTP, Source Data ',@cntgrp),
('WATER_PB_UWWTP.TitleFull','DiffuseSources','0','','UWWTP, Title Full ',@cntgrp),
('WATER_PB_UWWTP.TitleShort','DiffuseSources','0','','UWWTP, Title Short ',@cntgrp),
('WATER_PB_UnconnectedHouseholds.GeneralInformation','DiffuseSources','1','','Unconnected Households, General Information',@cntgrp),
('WATER_PB_UnconnectedHouseholds.Methodology','DiffuseSources','1','','Unconnected Households, Methodology ',@cntgrp),
('WATER_PB_UnconnectedHouseholds.SourceData','DiffuseSources','1','','Unconnected Households, Source Data ',@cntgrp),
('WATER_PB_UnconnectedHouseholds.TitleFull','DiffuseSources','0','','Unconnected Households, Title Full ',@cntgrp),
('WATER_PB_UnconnectedHouseholds.TitleShort','DiffuseSources','0','','Unconnected Households, Title Short ',@cntgrp);

SET @cntgrp = (SELECT [LOV_ContentsGroupID] FROM [dbo].[LOV_ContentsGroup] where Code = 'DIFSRC_WATER_P');

INSERT INTO [dbo].[ReviseResourceKey]
 ([ResourceKey]
 ,[ResourceType]
 ,[AllowHTML]
 ,[KeyDescription]
 ,[KeyTitle]
 ,[ContentsGroupID])
 VALUES
('WATER_P_Agriculture.GeneralInformation','DiffuseSources','1','','Agriculture, General Information ',@cntgrp),
('WATER_P_Agriculture.Methodology','DiffuseSources','1','','Agriculture, Methodology ',@cntgrp),
('WATER_P_Agriculture.SourceData','DiffuseSources','1','','Agriculture, Source Data ',@cntgrp),
('WATER_P_Agriculture.TitleFull','DiffuseSources','0','','Agriculture, Title Full ',@cntgrp),
('WATER_P_Agriculture.TitleShort','DiffuseSources','0','','Agriculture, Title Short ',@cntgrp),
('WATER_P_InlandNavigation.GeneralInformation','DiffuseSources','1','','Inland Navigation, General Information ',@cntgrp),
('WATER_P_InlandNavigation.Methodology','DiffuseSources','1','','Inland Navigation, Methodology ',@cntgrp),
('WATER_P_InlandNavigation.SourceData','DiffuseSources','1','','Inland Navigation, Source Data ',@cntgrp),
('WATER_P_InlandNavigation.TitleFull','DiffuseSources','0','','Inland Navigation, Title Full ',@cntgrp),
('WATER_P_InlandNavigation.TitleShort','DiffuseSources','0','','Inland Navigation, Title Short ',@cntgrp),
('WATER_P_UWWTP.GeneralInformation','DiffuseSources','1','','UWWTP, General Information ',@cntgrp),
('WATER_P_UWWTP.Methodology','DiffuseSources','1','','UWWTP, Methodology ',@cntgrp),
('WATER_P_UWWTP.SourceData','DiffuseSources','1','','UWWTP, Source Data ',@cntgrp),
('WATER_P_UWWTP.TitleFull','DiffuseSources','0','','UWWTP, Title Full ',@cntgrp),
('WATER_P_UWWTP.TitleShort','DiffuseSources','0','','UWWTP, Title Short ',@cntgrp),
('WATER_P_UnconnectedHouseholds.GeneralInformation','DiffuseSources','1','','Unconnected Households, General Information',@cntgrp),
('WATER_P_UnconnectedHouseholds.Methodology','DiffuseSources','1','','Unconnected Households, Methodology ',@cntgrp),
('WATER_P_UnconnectedHouseholds.SourceData','DiffuseSources','1','','Unconnected Households, Source Data ',@cntgrp),
('WATER_P_UnconnectedHouseholds.TitleFull','DiffuseSources','0','','Unconnected Households, Title Full ',@cntgrp),
('WATER_P_UnconnectedHouseholds.TitleShort','DiffuseSources','0','','Unconnected Households, Title Short ',@cntgrp);

SET @cntgrp = (SELECT [LOV_ContentsGroupID] FROM [dbo].[LOV_ContentsGroup] where Code = 'DIFSRC_WATER_TOC');

INSERT INTO [dbo].[ReviseResourceKey]
 ([ResourceKey]
 ,[ResourceType]
 ,[AllowHTML]
 ,[KeyDescription]
 ,[KeyTitle]
 ,[ContentsGroupID])
 VALUES
('WATER_TOC_InlandNavigation.GeneralInformation','DiffuseSources','1','','Inland Navigation, General Information ',@cntgrp),
('WATER_TOC_InlandNavigation.Methodology','DiffuseSources','1','','Inland Navigation, Methodology ',@cntgrp),
('WATER_TOC_InlandNavigation.SourceData','DiffuseSources','1','','Inland Navigation, Source Data ',@cntgrp),
('WATER_TOC_InlandNavigation.TitleFull','DiffuseSources','0','','Inland Navigation, Title Full ',@cntgrp),
('WATER_TOC_InlandNavigation.TitleShort','DiffuseSources','0','','Inland Navigation, Title Short ',@cntgrp),
('WATER_TOC_UWWTP.GeneralInformation','DiffuseSources','1','','UWWTP, General Information ',@cntgrp),
('WATER_TOC_UWWTP.Methodology','DiffuseSources','1','','UWWTP, Methodology ',@cntgrp),
('WATER_TOC_UWWTP.SourceData','DiffuseSources','1','','UWWTP, Source Data ',@cntgrp),
('WATER_TOC_UWWTP.TitleFull','DiffuseSources','0','','UWWTP, Title Full ',@cntgrp),
('WATER_TOC_UWWTP.TitleShort','DiffuseSources','0','','UWWTP, Title Short ',@cntgrp),
('WATER_TOC_UnconnectedHouseholds.GeneralInformation','DiffuseSources','1','','Unconnected Households, General Information',@cntgrp),
('WATER_TOC_UnconnectedHouseholds.Methodology','DiffuseSources','1','','Unconnected Households, Methodology ',@cntgrp),
('WATER_TOC_UnconnectedHouseholds.SourceData','DiffuseSources','1','','Unconnected Households, Source Data ',@cntgrp),
('WATER_TOC_UnconnectedHouseholds.TitleFull','DiffuseSources','0','','Unconnected Households, Title Full ',@cntgrp),
('WATER_TOC_UnconnectedHouseholds.TitleShort','DiffuseSources','0','','Unconnected Households, Title Short ',@cntgrp);

SET @cntgrp = (SELECT [LOV_ContentsGroupID] FROM [dbo].[LOV_ContentsGroup] where Code = 'DIFSRC_WATER_ZN');

INSERT INTO [dbo].[ReviseResourceKey]
 ([ResourceKey]
 ,[ResourceType]
 ,[AllowHTML]
 ,[KeyDescription]
 ,[KeyTitle]
 ,[ContentsGroupID])
 VALUES
('WATER_ZN_Transport.GeneralInformation','DiffuseSources','1','','Transport, General Information ',@cntgrp),
('WATER_ZN_Transport.Methodology','DiffuseSources','1','','Transport, Methodology ',@cntgrp),
('WATER_ZN_Transport.SourceData','DiffuseSources','1','','Transport, Source Data ',@cntgrp),
('WATER_ZN_Transport.TitleFull','DiffuseSources','0','','Transport, Title Full ',@cntgrp),
('WATER_ZN_Transport.TitleShort','DiffuseSources','0','','Transport, Title Short ',@cntgrp),
('WATER_ZN_UWWTP.GeneralInformation','DiffuseSources','1','','UWWTP, General Information ',@cntgrp),
('WATER_ZN_UWWTP.Methodology','DiffuseSources','1','','UWWTP, Methodology ',@cntgrp),
('WATER_ZN_UWWTP.SourceData','DiffuseSources','1','','UWWTP, Source Data ',@cntgrp),
('WATER_ZN_UWWTP.TitleFull','DiffuseSources','0','','UWWTP, Title Full ',@cntgrp),
('WATER_ZN_UWWTP.TitleShort','DiffuseSources','0','','UWWTP, Title Short ',@cntgrp),
('WATER_ZN_UnconnectedHouseholds.GeneralInformation','DiffuseSources','1','','Unconnected Households, General Information',@cntgrp),
('WATER_ZN_UnconnectedHouseholds.Methodology','DiffuseSources','1','','Unconnected Households, Methodology ',@cntgrp),
('WATER_ZN_UnconnectedHouseholds.SourceData','DiffuseSources','1','','Unconnected Households, Source Data ',@cntgrp),
('WATER_ZN_UnconnectedHouseholds.TitleFull','DiffuseSources','0','','Unconnected Households, Title Full ',@cntgrp),
('WATER_ZN_UnconnectedHouseholds.TitleShort','DiffuseSources','0','','Unconnected Households, Title Short ',@cntgrp);

SET @cntgrp = (SELECT [LOV_ContentsGroupID] FROM [dbo].[LOV_ContentsGroup] where Code = 'LCP');

INSERT INTO [dbo].[ReviseResourceKey]
 ([ResourceKey]
 ,[ResourceType]
 ,[AllowHTML]
 ,[KeyDescription]
 ,[KeyTitle]
 ,[ContentsGroupID])
 VALUES
('Address','LCP','0','','Address',@cntgrp),
('AnnexVI_a_footnote2','LCP','0','','AnnexVI a footnote2',@cntgrp),
('AnnexVI_a_footnote2_operatingho','LCP','0','','AnnexVI a footnote2 operatinghours',@cntgrp),
('AnnexVI_a_footnote3','LCP','0','','AnnexVI a footnote3',@cntgrp),
('AnnexVI_a_footnote3_elvnox','LCP','0','','AnnexVI a footnote3 elvnox',@cntgrp),
('Art5_1','LCP','0','','Art5 1',@cntgrp),
('Biomass','LCP','0','','Biomass',@cntgrp),
('Boiler','LCP','0','','Boiler',@cntgrp),
('Boilerthermalinput','LCP','0','','Boiler thermal input',@cntgrp),
('Capacity','LCP','0','','Capacity',@cntgrp),
('Capacityaddedmw','LCP','0','','Capacity added mw',@cntgrp),
('Capacityaffectedmw','LCP','0','','Capacity affected mw',@cntgrp),
('Capacityoptedoutmw','LCP','0','','Capacity opted out mw',@cntgrp),
('City','LCP','0','','City',@cntgrp),
('Comments','LCP','0','','Comments',@cntgrp),
('Coords','LCP','0','','Coords',@cntgrp),
('Country','LCP','0','','Country',@cntgrp),
('Dateofstartofoperation','LCP','0','','Date of start of operation',@cntgrp),
('Desulphurisationrate','LCP','0','','Desulphurisation rate',@cntgrp),
('Dieselengine','LCP','0','','Dieselengine',@cntgrp),
('Dieselengineturbinethermalinput','LCP','0','','Dieselengine turbine thermal input',@cntgrp),
('Dust','LCP','0','','Dust',@cntgrp),
('EPRTRNationalId','LCP','0','','EPRTR NationalId',@cntgrp),
('Elvnox','LCP','0','','Elv nox',@cntgrp),
('Elvso2','LCP','0','','Elv so2',@cntgrp),
('Email','LCP','0','','Email',@cntgrp),
('EnergyInputAndTotalEmissionsToAir','LCP','0','','Energy Input And Total Emissions To Air',@cntgrp),
('Envelope_isreleased','LCP','0','','Envelope isreleased',@cntgrp),
('Envelope_url','LCP','0','','Envelope url',@cntgrp),
('Extensionby50mwormore','LCP','0','','Extension by 50 mw or more',@cntgrp),
('FacilityName','LCP','0','','Facility Name',@cntgrp),
('Filename','LCP','0','','Filename',@cntgrp),
('Gasengine','LCP','0','','Gas engine',@cntgrp),
('Gasenginethermalinput','LCP','0','','Gas engine thermal input',@cntgrp),
('Gasturbine','LCP','0','','Gas turbine',@cntgrp),
('Gasturbinethermalinput','LCP','0','','Gas turbine thermal input',@cntgrp),
('Hardcoal','LCP','0','','Hardcoal',@cntgrp),
('Headline','LCP','0','','Headline',@cntgrp),
('Hoursoperated','LCP','0','','Hours operated',@cntgrp),
('Latitude','LCP','0','','Latitude',@cntgrp),
('LcpArt15','LCP','0','','Lcp Art 15',@cntgrp),
('Lignite','LCP','0','','Lignite',@cntgrp),
('Liquidfuels','LCP','0','','Liquid fuels',@cntgrp),
('Longitude','LCP','0','','Longitude',@cntgrp),
('Memberstate','LCP','0','','Memberstate',@cntgrp),
('Mwth','LCP','0','','Mwth',@cntgrp),
('Nameofcontactperson','LCP','0','','Name of contact person',@cntgrp),
('Naturalgas','LCP','0','','Naturalgas',@cntgrp),
('NotabeneannexIII','LCP','0','','Notabene annex III',@cntgrp),
('Notabeneelvso2','LCP','0','','Notabene elv so2',@cntgrp),
('Nox','LCP','1','','Nox',@cntgrp),
('Numberofplants','LCP','0','','Number of plants',@cntgrp),
('Operatinghours','LCP','0','','Operating hours',@cntgrp),
('OptOutsAndNERP','LCP','0','','Opt Outs And NERP',@cntgrp),
('Optoutplant','LCP','0','','Optoutplant',@cntgrp),
('Organization','LCP','0','','Organization',@cntgrp),
('Other','LCP','0','','Other',@cntgrp),
('Othergases','LCP','0','','Othergases',@cntgrp),
('Othersector','LCP','0','','Othersector',@cntgrp),
('Othersolidfuels','LCP','0','','Other solid fuels',@cntgrp),
('Otherthermalinput','LCP','0','','Other thermal input',@cntgrp),
('Othertypeofcombustion','LCP','0','','Other type of combustion',@cntgrp),
('Phone','LCP','0','','Phone',@cntgrp),
('Plant','LCP','0','','Plant',@cntgrp),
('PlantDetails','LCP','0','','Plant Details',@cntgrp),
('PlantId','LCP','0','','Plant Id',@cntgrp),
('PlantName','LCP','0','','Plant Name',@cntgrp),
('Plantincludedinnerp','LCP','0','','Plant included inner p',@cntgrp),
('Plants','LCP','0','','Plants',@cntgrp),
('Postalcode','LCP','0','','Postal code',@cntgrp),
('Referenceyear','LCP','0','','Reference year',@cntgrp),
('Refineries','LCP','0','','Refineries',@cntgrp),
('Region','LCP','0','','Region',@cntgrp),
('ReportId','LCP','0','','ReportId',@cntgrp),
('Report_submissiondate','LCP','0','','Report submission date',@cntgrp),
('ReportingAuthority','LCP','0','','Reporting Authority',@cntgrp),
('Sinput','LCP','0','','Sinput',@cntgrp),
('So2','LCP','1','','So2',@cntgrp),
('Source','LCP','0','','Source',@cntgrp),
('State','LCP','0','','State',@cntgrp),
('Statusotheplant','LCP','0','','Status of the plant',@cntgrp),
('Substantialchange','LCP','0','','Substantial change',@cntgrp),
('Thermalinput','LCP','0','','Thermal input',@cntgrp),
('Volatilecontents','LCP','0','','Volatile contents',@cntgrp),
('explanatorytext','LCP','1','','explanatory text',@cntgrp);

/*
* APPEND ReviseResourceKeys with correct LOV_ContentsGroupIDs
*/
declare @temp table (ResourceKeyID int, ResourceValue varchar(max));

INSERT INTO @temp (ResourceKeyID, ResourceValue)
/*SELECT c.[ResourceKeyID],a.[ResourceValue]
  FROM [dbo].[tAT_ResourceValue] a inner join
	   [dbo].[tAT_ResourceKey] b on a.ResourceKeyID = b.ResourceKeyID inner join
	   [dbo].[ReviseResourceKey] c on b.ResourceKey = c.ResourceKey
  where a.ChangedDate > '2015-05-05';*/
  SELECT c.[ResourceKeyID],a.[ResourceValue]
  FROM [dbo].[tAT_ResourceValue] a inner join
	   [dbo].[tAT_ResourceKey] b on a.ResourceKeyID = b.ResourceKeyID inner join
	   [dbo].[ReviseResourceKey] c on b.ResourceKey = c.ResourceKey left outer join
	   [dbo].[ReviseResourceValue] d on a.CultureCode = d.CultureCode and c.ResourceKeyID = d.ResourceKeyID
  where a.CultureCode = 'en-GB' and ((a.ChangedDate > d.ChangedDate) or (d.ChangedDate is Null));

DECLARE @rkey int
DECLARE @rval varchar(max)

DECLARE cur CURSOR FOR SELECT ResourceKeyID, ResourceValue FROM @temp
OPEN cur

FETCH NEXT FROM cur INTO @rkey, @rval

WHILE @@FETCH_STATUS = 0 BEGIN
    --EXEC mysp @rkey, @rval ... -- call your sp here

	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
	BEGIN TRANSACTION;

		UPDATE [dbo].[ReviseResourceValue]
			SET [ResourceValue] = @rval 
			WHERE [ResourceKeyID] = @rkey and [CultureCode] = 'en-GB';

		IF @@ROWCOUNT = 0
		BEGIN
			INSERT INTO [dbo].[ReviseResourceValue]
			([ResourceKeyID],[CultureCode],[ResourceValue])
				VALUES (@rkey, 'en-GB',@rval);
		END

	COMMIT TRANSACTION;

	FETCH NEXT FROM cur INTO @rkey, @rval
END

CLOSE cur    
DEALLOCATE cur


/*
* DELETE dublicates from tAT_ResourceValue 
*/
declare @temp table (ResourceValueID int);

INSERT INTO @temp (ResourceValueID)
  SELECT a.[ResourceValueID]
  FROM [dbo].[tAT_ResourceValue] a inner join
	   [dbo].[tAT_ResourceKey] b on a.ResourceKeyID = b.ResourceKeyID inner join
	   [dbo].[ReviseResourceKey] c on b.ResourceKey = c.ResourceKey left outer join
	   [dbo].[ReviseResourceValue] d on a.CultureCode = d.CultureCode and c.ResourceKeyID = d.ResourceKeyID
  where a.CultureCode = 'en-GB' and ((a.ChangedDate > d.ChangedDate) or (d.ChangedDate is Null));

DECLARE @rvid int

DECLARE cur CURSOR FOR SELECT ResourceValueID FROM @temp
OPEN cur

FETCH NEXT FROM cur INTO @rvid

WHILE @@FETCH_STATUS = 0 BEGIN
    --EXEC mysp @rkey, @rval ... -- call your sp here

	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
	BEGIN TRANSACTION;

		DELETE FROM [dbo].[tAT_ResourceValue]
		WHERE ResourceValueID = @rvid;

	COMMIT TRANSACTION;

	FETCH NEXT FROM cur INTO @rvid
END

CLOSE cur    
DEALLOCATE cur