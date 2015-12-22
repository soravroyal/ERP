
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
 ('POLLUTANTINFO', 'Pollutant info', 2015);

declare @temp table (ResourceKey varchar(max), ResourceType varchar(max), KeyTitle varchar(max), ResourceValue varchar(max));

INSERT INTO @temp (ResourceKey, ResourceType, KeyTitle, ResourceValue)
 VALUES
('POLLUTANTINFO.All','PollutantInfo','Label, Pollutantinfo All','All'),
('POLLUTANTINFO.CASNumber','PollutantInfo','Label, Pollutant CAS Number','CAS Number'),
('POLLUTANTINFO.CASToolTip','PollutantInfo','Tooltip, Pollutant CAS number','The CAS number is a unique reference for a chemical provides by the Chemical Abstracts Service.'),
('POLLUTANTINFO.Classification','PollutantInfo','Label, Pollutant Classification','Classification'),
('POLLUTANTINFO.ClassificationTooltip','PollutantInfo','Tooltip, Pollutant classification','The classification of a chemical under the Dangerous Substances Directive (67/548/EEC)'),
('POLLUTANTINFO.Contents','PollutantInfo','Label, Pollutant Contents','Contents'),
('POLLUTANTINFO.ECNumber','PollutantInfo','Label, Pollutant EC Number','EC Number'),
('POLLUTANTINFO.ECToolTip','PollutantInfo','Tooltip, Pollutant EC','The EC number is a unique reference number for a chemical that is commercially available within the EU.'),
('POLLUTANTINFO.Formula','PollutantInfo','Label, Pollutant Formula','Formula'),
('POLLUTANTINFO.Group','PollutantInfo','Label, Pollutant Group','Pollutant Group'),
('POLLUTANTINFO.IUPAC','PollutantInfo','Label, Pollutant IUPAC','IUPAC Name'),
('POLLUTANTINFO.IUPACTooltip','PollutantInfo','Tooltip, Pollutant IUPAC','tooltip for IUPAC Name:'),
('POLLUTANTINFO.Name','PollutantInfo','Label, Pollutant Name','Name'),
('POLLUTANTINFO.Pollutant','PollutantInfo','Label, Pollutant','Pollutant'),
('POLLUTANTINFO.PollutantId','PollutantInfo','Label, Pollutant Id',' E-PRTR Pollutant No'),
('POLLUTANTINFO.PollutantInfo','PollutantInfo','Label, Pollutant Info','Pollutant Info'),
('POLLUTANTINFO.Pollutants','PollutantInfo','Label, Pollutants','Pollutants'),
('POLLUTANTINFO.Search','PollutantInfo','Label, Pollutantinfo Search','Search'),
('POLLUTANTINFO.Summary','PollutantInfo','Label, Pollutant Summary','General information'),
('POLLUTANTINFO.air','PollutantInfo','Label, Pollutantinfo Air','to air kg/year'),
('POLLUTANTINFO.chemspider','PollutantInfo','Label, Pollutant Chemspider id','Chemspider id'),
('POLLUTANTINFO.clp','PollutantInfo','Label, Pollutant Hazard Class','Hazard Class'),
('POLLUTANTINFO.clpLinkText','PollutantInfo','Text, Pollutant CLP Link','Regulation (EC) No 1272/2008, OJ L 353'),
('POLLUTANTINFO.clpLinkUrl','PollutantInfo','Link, Pollutant CLP URL1','http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=OJ:L:2008:353:0001:1355:'),
('POLLUTANTINFO.clpLinkUrl2','PollutantInfo','Link, Pollutant CLP URL2',':PDF'),
('POLLUTANTINFO.clpex','PollutantInfo','Text, Pollutant CLPEX','The Regulation (EC) No 1272/2008 establishes a standard classification and labelling system for substances distinguishing a) Hazard Class and b) Hazard Statements'),
('POLLUTANTINFO.clpghs','PollutantInfo','Label, Pollutant Classification & Labelling','Classification & Labelling'),
('POLLUTANTINFO.description','PollutantInfo','Label, Pollutant Description','Description'),
('POLLUTANTINFO.eprtrProvisions','PollutantInfo','Label, Pollutant eprtrProvisions','Pollutant thresholds'),
('POLLUTANTINFO.ghs','PollutantInfo','Label, Pollutant Hazard Statements','Hazard Statements'),
('POLLUTANTINFO.ghsex','PollutantInfo','Label, Pollutant Hazard CLP Regulations','),Hazard descriptions from the CLP Regulations'),
('POLLUTANTINFO.hazards','PollutantInfo','Label, Pollutant Hazards','Hazards and other technical characteristics'),
('POLLUTANTINFO.healthAffects','PollutantInfo','Label, Pollutant Health Affects','How do the releases affect you and your environment?'),
('POLLUTANTINFO.impacts','PollutantInfo','Label, Pollutant Impacts','Human Health & Environmental Hazard Assessment'),
('POLLUTANTINFO.isoFootNote1','PollutantInfo','Text, Pollutant ISO Footnote1','(*) indicates that performance information is included in the standard but not in a suitable form for inclusion.'),
('POLLUTANTINFO.isoFootNote2','PollutantInfo','Text, Pollutant ISO Footnote2','(-) Indicates that no information is available.'),
('POLLUTANTINFO.isoFootNote3','PollutantInfo','Text, Pollutant ISO Footnote3','Notes:This table is based on the following published information: the 2003 General Principles of Monitoring BREF '),
('POLLUTANTINFO.isoFootNote4','PollutantInfo','Text, Pollutant ISO Footnote4',';CEN and ISO websites and those of their relevant Technical Committees (TCs) for details and publication dates ( i.e. CEN TC230 – water analysis and CEN TC 264 – air quality, ISO TC 147 – water quality and ISO TC 146 – air quality); and current UK guidance on monitoring for air and water for IPPC Directive installations (Environment Agency documents M2 Version 6 - January 2010and M18 Version 2 - April 2009 covering air and water respectively) available on '),
('POLLUTANTINFO.isoFootNote5','PollutantInfo','Text, Pollutant ISO Footnote5',').Standard numbers have been checked against CEN and ISO websites and, to best of our knowledge, are both available and consistent with EN or ISO publication dates.'),
('POLLUTANTINFO.isoFootNote6','PollutantInfo','Text, Pollutant ISO Footnote6','Information related to uncertainty is included where it is available, in a suitable form, in the standard.The information given for Stationary source emissions generally refers to sampling and analysis, that for Water quality data refers to the coefficient of variation of reproducibility - CVR - of the analysis alone.CVR is the reproducibility standard deviation/mean concentration, expressed as a %, this has been expressed to one significant decimal place %. Wherever possible we have taken the sample matrix most similar to the industrial discharges to be reported under the EPRTR Regulation.Where the Standard allows a choice of technique we have taken the &#39;worst&#39; case - on the basis that if an operator reports a discharge as having been measured in accordance with the Standard and not necessarily a particular variation of it.'),
('POLLUTANTINFO.isoFootNoteLink1','PollutantInfo','Link, Pollutant ISO Footnote link1',' http://eippcb.jrc.es/reference/'),
('POLLUTANTINFO.isoFootNoteLink2','PollutantInfo','Link, Pollutant ISO Footnote link2',' http://www.environment-agency.gov.uk/business/regulation/31831.aspx '),
('POLLUTANTINFO.isoFootNoteTitle','PollutantInfo','Label, Pollutant ISO Footnotes','Footnotes'),
('POLLUTANTINFO.isostandard','PollutantInfo','Label, Pollutant Standard','Standard'),
('POLLUTANTINFO.isotarget','PollutantInfo','Label, Pollutant ISO Target','Target'),
('POLLUTANTINFO.isotitle','PollutantInfo','Label, Pollutant ISO Title','Title'),
('POLLUTANTINFO.isouncert','PollutantInfo','Label, Pollutant ISO Uncertainty','Uncertainty'),
('POLLUTANTINFO.land','PollutantInfo','Label, Pollutantinfo Land','to land kg/year'),
('POLLUTANTINFO.mainmethodsrelease','PollutantInfo','Label, Pollutant Main methods','Where do the releases originate?'),
('POLLUTANTINFO.mainuses','PollutantInfo','Label, Pollutant Main Uses','Main Uses'),
('POLLUTANTINFO.measurement','PollutantInfo','Label, Pollutant Measurement','Measurement & calculation methods'),
('POLLUTANTINFO.noClp','PollutantInfo','Text, Pollutant No CLP','There is no classification and labelling assigned.'),
('POLLUTANTINFO.noData','PollutantInfo','Text, Pollutant No Data Available','No Data Available'),
('POLLUTANTINFO.noRandS','PollutantInfo','Text, Pollutant No R&S','There are no Risk and Safety phrases assigned.'),
('POLLUTANTINFO.physical','PollutantInfo','Label, Pollutant Physical','Physical Properties'),
('POLLUTANTINFO.pollutanthead','PollutantInfo','Label, Pollutantinfo Header','Pollutant descriptions'),
('POLLUTANTINFO.pollutantheadlink','PollutantInfo','Link, Pollutantinfo Link1','http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=OJ:L:2000:192:0036:0043:EN:PDF'),
('POLLUTANTINFO.pollutantheadlink2','PollutantInfo','Link, Pollutantinfo Link2',':PDF#page=3'),
('POLLUTANTINFO.pollutantheadlinkLabel','PollutantInfo','Label, Pollutantinfo Link','Annex A1 of EPER Decision 2000/479/EC'),
('POLLUTANTINFO.pollutantheadnotes','PollutantInfo','Text, Pollutantinfo Notes1','This page will display information and the reporting thresholds relating to the 91 pollutants covered under E-PRTR (reporting year 2007 and followings). You can search for a pollutant by pollutant group or by selecting a specific pollutant.'),
('POLLUTANTINFO.pollutantheadnotes2','PollutantInfo','Text, Pollutantinfo Notes2','For information and reporting thresholds relating to the 50 pollutants covered under EPER (reporting year 2001 and 2004), please refer to'),
('POLLUTANTINFO.pollutantheadnotes3','PollutantInfo','Text, Pollutantinfo Notes3','Almost all the EPER pollutants correspond to the E-PRTR pollutants except for BTEX and PAHs. The CO\n emissions for EPER and E-PRTR are reported differently (EPER does exclude emissions from biomass).'),
('POLLUTANTINFO.print','PollutantInfo','Label, Pollutant Print','Print'),
('POLLUTANTINFO.provOverview','PollutantInfo','Label, Pollutant Prov Overview','Overview'),
('POLLUTANTINFO.provReportGeneric','PollutantInfo','Label, Pollutant Prov General Reporting','General Reporting'),
('POLLUTANTINFO.provReportSpecific','PollutantInfo','Label, Pollutant Prov Specific Reporting','Specific Reporting'),
('POLLUTANTINFO.provisions','PollutantInfo','Label, Pollutant Provisions','Other relevant reporting requirements'),
('POLLUTANTINFO.proviso','PollutantInfo','Label, Pollutant Proviso','Methods and uncertainty'),
('POLLUTANTINFO.provother','PollutantInfo','Text, Pollutant Prov Other','Overview of relevant reporting requirements for the selected pollutant or compound set by European Regulations or Multilateral Environmental Agreements (MEAs).'),
('POLLUTANTINFO.provprtr','PollutantInfo','Label, Pollutant Provision','Provisions under E-PRTR Regulation'),
('POLLUTANTINFO.provprtrNote','PollutantInfo','Text, Pollutant Prov Note1','* - indicates that the parameter and medium in question do not trigger a reporting requirement.'),
('POLLUTANTINFO.provprtrNote2','PollutantInfo','Text, Pollutant Prov Note2','BTEX - sum parameter of benzene, toluene, ethyl benzene, xylenes.'),
('POLLUTANTINFO.rands','PollutantInfo','Label, Pollutant R&S','Risk and Safety Phrases (R&S)'),
('POLLUTANTINFO.randsex','PollutantInfo','Text, Pollutant R&S','Risk and Safety phrases describe the risks of a substance and safety measures that should be taken.'),
('POLLUTANTINFO.smiles','PollutantInfo','Tooltip, Pollutant SMILES','SMILES tooltip'),
('POLLUTANTINFO.structure','PollutantInfo','Label, Pollutant Structure','Structure'),
('POLLUTANTINFO.synonyms','PollutantInfo','Label, Pollutant Synonyms','Synonyms or other commercial names'),
('POLLUTANTINFO.threshold','PollutantInfo','Label, Pollutantinfo Threshold','Threshold for releases'),
('POLLUTANTINFO.water','PollutantInfo','Label, Pollutantinfo Water','to water kg/year');


DECLARE @cntgrp int
DECLARE @rrkid int
DECLARE @rrk varchar(max)
DECLARE @rrt varchar(max)
DECLARE @rval varchar(max)
DECLARE @rttl varchar(max)
DECLARE @lcg varchar(max)
/*
* APPEND ReviseResourceKeys with correct LOV_ContentsGroupIDs
*/

DECLARE cur CURSOR FOR SELECT ResourceKey, ResourceType, KeyTitle FROM @temp
OPEN cur

FETCH NEXT FROM cur INTO @rrk, @rrt, @rttl

WHILE @@FETCH_STATUS = 0 BEGIN
    --EXEC mysp @rkey, @rval ... -- call your sp here
	SET @cntgrp = (SELECT [LOV_ContentsGroupID] FROM [dbo].[LOV_ContentsGroup] where Code = 'POLLUTANTINFO');
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
	BEGIN TRANSACTION;
		INSERT INTO [dbo].[ReviseResourceKey]
			([ResourceKey] ,[ResourceType] ,[AllowHTML] ,[KeyDescription] ,[KeyTitle] ,[ContentsGroupID])
		VALUES
			(@rrk,@rrt,'1','',@rttl,@cntgrp);

	COMMIT TRANSACTION;

	FETCH NEXT FROM cur INTO @rrk, @rrt, @rttl
END

CLOSE cur    
DEALLOCATE cur


DECLARE cur CURSOR FOR SELECT ResourceKey, ResourceType, ResourceValue FROM @temp
OPEN cur

FETCH NEXT FROM cur INTO @rrk, @rrt, @rval

WHILE @@FETCH_STATUS = 0 BEGIN
    --EXEC mysp @rkey, @rval ... -- call your sp here

	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
	BEGIN TRANSACTION;
		SET @rrkid = (SELECT ResourceKeyID FROM [dbo].[ReviseResourceKey] where [ResourceKey] = @rrk and [ResourceType] = @rrt);

		UPDATE [dbo].[ReviseResourceValue]
			SET [ResourceValue] = @rval 
			WHERE [ResourceKeyID] = @rrkid and [CultureCode] = 'en-GB';

		IF @@ROWCOUNT = 0
		BEGIN
			INSERT INTO [dbo].[ReviseResourceValue]
			([ResourceKeyID],[CultureCode],[ResourceValue])
				VALUES (@rrkid, 'en-GB',@rval);
		END
	COMMIT TRANSACTION;

	FETCH NEXT FROM cur INTO  @rrk, @rrt, @rval
END

CLOSE cur    
DEALLOCATE cur


