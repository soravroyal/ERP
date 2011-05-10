use EPRTRmaster

---------------------------------------------------------------------------------
--	delete test data
---------------------------------------------------------------------------------

delete from WASTETRANSFER where RemarkText = 'Test Data'
delete from WASTEHANDLERPARTY
delete from ACTIVITY where FacilityReportID in 
	(select FacilityReportID from FACILITYREPORT where RemarkText = 'Test Data') 
delete from POLLUTANTRELEASE where RemarkText = 'Test Data'
delete from POLLUTANTTRANSFER where RemarkText = 'Test Data'
delete from FACILITYREPORT where RemarkText = 'Test Data'
delete from POLLUTANTRELEASEANDTRANSFERREPORT where RemarkText = 'Test Data'
delete from PRODUCTIONVOLUME where eperFacilityID is null
delete from COMPETENTAUTHORITYPARTY where ReportingYear = 2007
delete from METHODUSED
delete from METHODLIST
delete from ADDRESS where eperFacilityID is null and AddressID not in ( 
	select AddressID from address where eperFacilityID is null 
	and PostalCode is null and StreetName is null and City is null
	)
	
---------------------------------------------------------------------------------
--	Initialize COMPETENTAUTHORITYPARTY
--	and generate POLLUTANTRELEASEANDTRANSFERREPORT Data for 2007
---------------------------------------------------------------------------------

declare @cID as int
declare country_cur cursor for 
	select distinct c.LOV_CountryID 
	from	
		FACILITYREPORT f
	inner join 
		POLLUTANTRELEASEANDTRANSFERREPORT p 
	on	p.PollutantReleaseAndTransferReportID = f.PollutantReleaseAndTransferReportID
	inner join 
		LOV_COUNTRY c 
	on	c.LOV_CountryID = p.LOV_CountryID

declare @LOV_ID int
select @LOV_ID = LOV_StatusID  
	from EPRTRmaster.dbo.LOV_STATUS 
	where Code = 'IMPORTED'

open country_cur
fetch next from country_cur into @cID
while @@FETCH_STATUS = 0
begin	
	insert into COMPETENTAUTHORITYPARTY 
	values(
		 @cID, --LOV_CountryID,
		 2007, -- ReportingYear,
		'Environment Survey of ' + (select Name from LOV_COUNTRY where LOV_CountryID = @cID), -- Name,
		(select top 1 AddressID from ADDRESS where LOV_CountryID = @cID 
			and substring(StreetName,12,1) > '' and SUBSTRING(City,5,1) > ''), -- address
		'0099-12345678', -- TelephoneCommunication,
		'0099-02000011', -- FaxCommunication,
		'b.donlon@eea.eu', -- EmailCommunication,
		'Brian Donlon' -- ContactPersonName
		)
	insert into POLLUTANTRELEASEANDTRANSFERREPORT
	values (	
		2007,	
		@cID,
		1,	
		'Test Data',
		'www.environment.survey.' + lower((select Code from LOV_COUNTRY where LOV_CountryID = @cID)),
		'2007-02-01 00:00:00.000',	
		'2007-06-13 00:00:00.000',	
		NULL, -- Published
		null, -- ForReview
		null, -- ResubmitReason,
		null, -- LOV_StatusID	
		null
		)
	fetch next from country_cur into @cID
end
close country_cur
deallocate country_cur

update COMPETENTAUTHORITYPARTY 
set 
	TelephoneCommunication = '0049-662-124000',
	FaxCommunication = '0049-662-124001',
	EmailCommunication = 'w_himmel@eea.eu',
	ContactPersonName = 'Werner Himmelfreundpointner'
where
ReportingYear = 2007
and LOV_CountryID in (15,81,214)

update COMPETENTAUTHORITYPARTY 
set 
	TelephoneCommunication = '+45/62782000',
	FaxCommunication = '+45/62782001',
	EmailCommunication = 'mcs@eea.eu',
	ContactPersonName = 'Mette Christine Sørensen'
where
ReportingYear = 2007
and LOV_CountryID in (59,213,166,73,101)

update COMPETENTAUTHORITYPARTY 
set 
	TelephoneCommunication = '+19/612382000',
	FaxCommunication = '+19/612382000',
	EmailCommunication = 'dupont@eea.eu',
	ContactPersonName = 'Charlott Dupont'
where
ReportingYear = 2007
and LOV_CountryID in (74,129,22)

--select * from COMPETENTAUTHORITYPARTY c
--inner join ADDRESS a on c.AddressID = a.AddressID
--where c.ReportingYear = 2007


---------------------------------------------------------------------------------
--	generate METHODLIST and METHODUSED
---------------------------------------------------------------------------------

INSERT INTO [dbo].[METHODLIST](MethodListID)
	SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5

INSERT INTO [dbo].[METHODUSED](
    [MethodListID],
    [LOV_MethodTypeID],
    [MethodDesignation]
)
SELECT 1, 12, 'EN 14385:2004'
	UNION ALL
SELECT 2, 11, 'EN 14385:2005'
	UNION ALL
SELECT 3, 10, 'E1 14385:2006'
	UNION ALL
SELECT 4, 9,  'E5 14385:2007'
	UNION ALL
SELECT 5, 8,  'EG 14385:1998'
	UNION ALL

SELECT 1, 7,  'KK 14385:1924'
	UNION ALL
SELECT 2, 6,  'KK 14385:1963'
	UNION ALL
SELECT 3, 5,  'KK 14385:2002'
	UNION ALL
SELECT 4, 4,  'KU 14385:2011'
	UNION ALL

SELECT 1, 3,  'XY 14385:2004'
	UNION ALL
SELECT 2, 2,  'ZZ 14385:1998'
	UNION ALL

SELECT 1, 1,  'zY 14385:2002'


---------------------------------------------------------------------------------
--	generate PRODUCTIONVOLUME Data
---------------------------------------------------------------------------------

declare @MinProdVol int

insert into PRODUCTIONVOLUME values ('Electricity',50000000,4,null)
insert into PRODUCTIONVOLUME values ('Rice',300000,3,null)
insert into PRODUCTIONVOLUME values ('Potatos',500000,3,null)
insert into PRODUCTIONVOLUME values ('Lego',1000000000,1,null)
insert into PRODUCTIONVOLUME values ('Cement',400000,3,null)
insert into PRODUCTIONVOLUME values ('Lakrider',5000,2,null)
insert into PRODUCTIONVOLUME values ('Matador Mix',20000000,1,null)
insert into PRODUCTIONVOLUME values ('Silver Bullion',150000,3,null)
insert into PRODUCTIONVOLUME values ('Paper',30000,3,null)
insert into PRODUCTIONVOLUME values ('Wine',132000000,12,null)
set @MinProdVol = (select MIN(ProductionVolumeID) from PRODUCTIONVOLUME where eperFacilityID is null)


---------------------------------------------------------------------------------
--	generate FACILITYREPORT Data for 2007
---------------------------------------------------------------------------------

declare @CONFI int
declare @IPPCQ int
declare @NACE int
declare @EMPNR int
declare @ProdVolRange int
declare @tt int
declare @tw int
declare @vol int
set @CONFI = 8
set @IPPCQ = 100
set @NACE = 606
set @EMPNR = 1000
set @ProdVolRange = 10
set @tt = 7
set @tw = 3
set @vol = 11

if object_id('tempdb..#TT')is not null DROP TABLE #TT
create table #TT(TextID int, PublicInformation nvarchar(255))
insert into #TT values(1,'General pollutant transfer enhancement plan established on May 1.')
insert into #TT values(2,'Closed every first week in month')
insert into #TT values(3,'Public visiting hours from 10 am to 16 pm every Monday')
insert into #TT values(4,'Not operating from December 25. to January 1.')
insert into #TT values(5,'CIO private telephone number: 0099-32146124')
insert into #TT values(6,'Nothing to report')
insert into #TT values(7,'Waste production according to schedule')

if object_id('tempdb..#TW')is not null DROP TABLE #TW
create table #TW(TextID int, WebsiteCommunication nvarchar(255))
insert into #TW values(1,'www.ecological.agency.eu')
insert into #TW values(2,'www.pollutant.survey.eu')
insert into #TW values(3,'www.environment.ministry.eu')

insert into FACILITYREPORT
select
	--FacilityReportID,
	pr.PollutantReleaseAndTransferReportID as PollutantReleaseAndTransferReportID,
	FacilityID,
	NationalID,
	case when (FacilityID - @tw * cast(FacilityID/@tw as float))> 0 then ParentCompanyName
		when (FacilityID - @CONFI * cast(FacilityID/@CONFI as float)) in (0,1,2,7) then null
		else  ParentCompanyName end,
	case when (FacilityID - @tw * cast(FacilityID/@tw as float))> 0 then FacilityName
		when (FacilityID - @CONFI * cast(FacilityID/@CONFI as float)) in (2,3,4) then null
		else FacilityName end,
	case when (FacilityID - @tw * cast(FacilityID/@tw as float))> 0 then f.AddressID
		when (FacilityID - @CONFI * cast(FacilityID/@CONFI as float)) in (2,5,6,7) then null
		else f.AddressID end,
	f.GeographicalCoordinate,
	f.LOV_StatusID,	
	LOV_RiverBasinDistrictID as LOV_RiverBasinDistrictID,
	LOV_RiverBasinDistrictID_Source as LOV_RiverBasinDistrictID_Source,
	(FacilityID - @NACE * cast(FacilityID/@NACE as float)) + 361 as LOV_NACEMainEconomicActivityID,
	(select Name from LOV_NACEACTIVITY where LOV_NACEActivityID =
		(FacilityID - @NACE * cast(FacilityID/@NACE as float)) + 361) as MainEconomicActivityName,
	cap.CompetentAuthorityPartyID as CompetentAuthorityPartyID,
	(FacilityID - @ProdVolRange * cast(FacilityID/@ProdVolRange as float)) + @MinProdVol as ProductionVolumeID,
	((FacilityID - @IPPCQ * cast(FacilityID/@IPPCQ as float)) + 1) * 10000 as TotalIPPCInstallationQuantity,
	((FacilityID - @tw * cast(FacilityID/@tw as float))+1) * 8 as OperatingHour,
	((FacilityID - @EMPNR * cast(FacilityID/@EMPNR as float)) + 750) as TotalEmployeeQuantity,
	LOV_NUTSRegionID as LOV_NUTSRegionID,
	LOV_NUTSRegionID_Source as LOV_NUTSRegionID_Source,
	(select WebsiteCommunication from #TW where TextID =
		(FacilityID - @tw * cast(FacilityID/@tw as float)) + 1) as WebsiteCommunication,
	(select PublicInformation from #TT where TextID =
		(FacilityID - @tt * cast(FacilityID/@tt as float)) + 1) as PublicInformation,
	case when (FacilityID - @tw * cast(FacilityID/@tw as float))> 0 then 0 else 1 end as ConfidentialIndicator,
	case when (FacilityID - @tw * cast(FacilityID/@tw as float))> 0 then null else
		(FacilityID - @CONFI * cast(FacilityID/@CONFI as float)) + 1 end as LOV_ConfidentialityID,
	case when (FacilityID - @vol * cast(FacilityID/@vol as float)) in (6,9) then 1 else 0 end,
	'Test Data' as RemarkText,
	null --f.eperFacilityID
from FACILITYREPORT f 
inner join 
	ADDRESS a
on	a.AddressID = f.AddressID
inner join
	POLLUTANTRELEASEANDTRANSFERREPORT pr
on	pr.LOV_CountryID = a.LOV_CountryID 
and pr.ReportingYear = 2007
inner join
	COMPETENTAUTHORITYPARTY cap
on  cap.LOV_CountryID = a.LOV_CountryID 
and cap.ReportingYear = 2007
inner join 
	POLLUTANTRELEASEANDTRANSFERREPORT prtr
on  f.PollutantReleaseAndTransferReportID = prtr.PollutantReleaseAndTransferReportID
and prtr.ReportingYear = 2004

--select * from FACILITYREPORT f
--inner join 
--	POLLUTANTRELEASEANDTRANSFERREPORT prtr
--on  f.PollutantReleaseAndTransferReportID = prtr.PollutantReleaseAndTransferReportID
--and prtr.ReportingYear = 2007

-------------------------------------------------------------------------------
--	generate WASTEHANDLERPARTY Data
---------------------------------------------------------------------------------
insert into ADDRESS 
	select top 1 null,133,'Salzburg',5020,LOV_CountryID,null 
	from ADDRESS where City like 'Linz'
union
	select top 1 'Innsbrucker Bundesstrasse',null,'Salzburg',5020,LOV_CountryID,null 
	from ADDRESS where City like 'Linz'
union
	select top 1 'Innsbrucker Bundesstrasse',133,'Salzburg',5020,LOV_CountryID,null 
	from ADDRESS where City like 'Linz'
union
	select top 1 'Innsbrucker Bundesstrasse',133,'Salzburg',null,LOV_CountryID,null 
	from ADDRESS where City like 'Linz'
union
	select top 1 'Innsbrucker Bundesstrasse',133,'Salzburg',5020,null,null 
	from ADDRESS where City like 'Linz'
union
	select top 1 'Innsbrucker Bundesstrasse',133,null,5020,LOV_CountryID,null 
	from ADDRESS where City like 'Linz'

--delete from WASTETRANSFER where RemarkText = 'Test Data'
--delete from WASTEHANDLERPARTY

declare @count INT 
set @count = 0 
while (@count < 600) 
begin 
	insert into WASTEHANDLERPARTY values ('Carbon Terminater' + ' WHP_' + CAST(@count as varchar), 
		(select top 1 AddressID from ADDRESS where City = 'DUBLIN'),
		(select top 1 AddressID from ADDRESS where City = 'BELFAST'))
	insert into WASTEHANDLERPARTY values ('El Chico' + ' WHP_' + CAST(@count as varchar), 
		(select top 1 AddressID from ADDRESS where City = 'BARCELONA'),
		(select top 1 AddressID from ADDRESS where City = 'MADRID'))
	insert into WASTEHANDLERPARTY values ('Rien ne va plus' + ' WHP_' + CAST(@count as varchar),
		(select top 1 AddressID from ADDRESS where City = 'MARSEILLE'),
		(select top 1 AddressID from ADDRESS where City = 'TOULOUSE'))
	insert into WASTEHANDLERPARTY values ('Recyling Company' + ' WHP_' + CAST(@count as varchar),
		(select top 1 AddressID from ADDRESS where City = 'CAMBRIDGE'),
		(select top 1 AddressID from ADDRESS where City = 'MANCHESTER'))
	insert into WASTEHANDLERPARTY values ('R38' + ' WHP_' + CAST(@count as varchar),
		(select top 1 AddressID from ADDRESS where City = 'Aabenraa'),
		(select top 1 AddressID from ADDRESS where City = 'Randers'))
	insert into WASTEHANDLERPARTY values ('Green Clean' + ' WHP_' + CAST(@count as varchar),
		(select top 1 AddressID from ADDRESS where City = 'MANCHESTER'),
		(select top 1 AddressID from ADDRESS where City = 'BIRMINGHAM'))
	insert into WASTEHANDLERPARTY values ('Sauberemacher A/S' + ' WHP_' + CAST(@count as varchar),
		(select top 1 AddressID from ADDRESS where City = 'Freiburg'),
		(select top 1 AddressID from ADDRESS where City = 'Bremen'))
	insert into WASTEHANDLERPARTY values ('Faire un tour aux Toilettes' + ' WHP_' + CAST(@count as varchar),
		(select top 1 AddressID from ADDRESS where City = 'STRASBOURG'),
		(select top 1 AddressID from ADDRESS where City = 'PARIS'))
	insert into WASTEHANDLERPARTY values ('Pas aux Site ' + ' WHP_' + CAST(@count as varchar),
		(select top 1 AddressID from ADDRESS where City = 'STRASBOURG'),null)
	insert into WASTEHANDLERPARTY values ('Pas du Adresse' + ' WHP_' + CAST(@count as varchar),
		null,(select top 1 AddressID from ADDRESS where City = 'PARIS'))
	insert into WASTEHANDLERPARTY values ('Salzburg Parsch' + ' WHP_' + CAST(@count as varchar),
		(select AddressID from ADDRESS where City = 'Salzburg' and StreetName is null),
		(select top 1 AddressID from ADDRESS where City = 'Wien'))
	insert into WASTEHANDLERPARTY values ('Salzburg Aigen' + ' WHP_' + CAST(@count as varchar),
		(select AddressID from ADDRESS where City = 'Salzburg' and BuildingNumber is null),
		(select top 1 AddressID from ADDRESS where City = 'Wien'))
	insert into WASTEHANDLERPARTY values ('Salzburg Maxglan' + ' WHP_' + CAST(@count as varchar),
		(select AddressID from ADDRESS where BuildingNumber = 133 and City is null),
		(select top 1 AddressID from ADDRESS where City = 'Wien'))
	insert into WASTEHANDLERPARTY values ('Salzburg Gnigl' + ' WHP_' + CAST(@count as varchar),
		(select AddressID from ADDRESS where City = 'Salzburg' and PostalCode is null),
		(select top 1 AddressID from ADDRESS where City = 'Wien'))
	insert into WASTEHANDLERPARTY values ('Salzburg Lehen' + ' WHP_' + CAST(@count as varchar),
		(select AddressID from ADDRESS where BuildingNumber = 133 and LOV_CountryID is null),
		(select top 1 AddressID from ADDRESS where City = 'Wien'))
	insert into WASTEHANDLERPARTY values ('OEMV' + ' WHP_' + CAST(@count as varchar),
		(select top 1 AddressID from ADDRESS where City = 'Wien'),
		(select AddressID from ADDRESS where City = 'Salzburg' and StreetName is null))
	insert into WASTEHANDLERPARTY values ('Favoritten' + ' WHP_' + CAST(@count as varchar),
		(select top 1 AddressID from ADDRESS where City = 'Wien'),
		(select AddressID from ADDRESS where City = 'Salzburg' and BuildingNumber is null))
	insert into WASTEHANDLERPARTY values ('Freudenau' + ' WHP_' + CAST(@count as varchar),
		(select top 1 AddressID from ADDRESS where City = 'Wien'),
		(select AddressID from ADDRESS where BuildingNumber = 133 and City is null))
	insert into WASTEHANDLERPARTY values ('Schwechat' + ' WHP_' + CAST(@count as varchar),
		(select top 1 AddressID from ADDRESS where City = 'Wien'),
		(select AddressID from ADDRESS where City = 'Salzburg' and PostalCode is null))
	insert into WASTEHANDLERPARTY values ('Stammersdorf' + ' WHP_' + CAST(@count as varchar),
		(select top 1 AddressID from ADDRESS where City = 'Wien'),
		(select AddressID from ADDRESS where BuildingNumber = 133 and LOV_CountryID is null))
   set @count = (@count + 1) 
end 

--select * from WASTEHANDLERPARTY


---------------------------------------------------------------------------------
--	generate Waste Transfer Data
---------------------------------------------------------------------------------

delete from WASTETRANSFER where RemarkText = 'Test Data'

declare @Qa float
declare @Ty int --(1,2,3,4)
declare @Tr int --(1,2)
declare @Tr1 int --(1,2)
declare @Mb int --(1,2,3)
declare @Ml int --(1,2,3,4,5)
declare @Pa int
declare @Pa1 int 
declare @Co int --(1,2,3,4,5,6,7,8)
declare @frep int
declare @PaMax int 
declare @PaMin int 
declare @linecount int
declare @ci int
declare @whpCountryID int
declare @ci1 int
declare @whpCountryID1 int
declare @frepCountryID int

set @PaMax = (select max(WasteHandlerPartyID) from WASTEHANDLERPARTY)
set @PaMin = (select min(WasteHandlerPartyID) from WASTEHANDLERPARTY)
set @Ty = 4
set @Tr = 2
set @Tr1 = 7
set @Mb = 3 
set @Ml = 5 
set @Pa = @PaMax 
set @Pa1 = @PaMin 
set @Co = 7 
set @linecount = 0

declare frep_cur cursor for 
	select f.FacilityReportID, p.LOV_CountryID 
	from 
		FACILITYREPORT f
	inner join
		POLLUTANTRELEASEANDTRANSFERREPORT p
	on	f.PollutantReleaseAndTransferReportID = p.PollutantReleaseAndTransferReportID
	where 
		f.RemarkText = 'Test Data'

open frep_cur
fetch next from frep_cur into @frep,@frepCountryID

while @@FETCH_STATUS = 0
begin	
	set @linecount = @linecount + 1
	if @Ty = 4 set @Ty = 2 else set @Ty = @Ty + 1
	if @Tr = 2 set @Tr = 1 else set @Tr = @Tr + 1 
	if @Tr1 = 7 set @Tr1 = 1 else set @Tr1 = @Tr1 + 1 
	if @Mb = 3 set @Mb = 1 else set @Mb = @Mb + 1
	if @Ml = 5 set @Ml = 1 else set @Ml = @Ml + 1 
	if @Pa = @PaMax set @Pa = @PaMin else set @Pa = @Pa + 1 
	if @Pa1 = @PaMin set @Pa1 = @PaMax else set @Pa1 = @Pa1 - 1 
	if @Co = 7 set @Co = 1 else set @Co = @Co + 1 
	
	set @ci = (
		select
			COUNT(*) 
		from 
			WASTEHANDLERPARTY whp
		inner join 
			ADDRESS add1 
		on whp.AddressID = add1.AddressID
		inner join 
			ADDRESS add2 
		on whp.SiteAddressID = add2.AddressID
		where (
			add1.City is null
		or add1.LOV_CountryID is null
		or add1.PostalCode is null
		or add1.StreetName is null
		or add2.City is null
		or add2.LOV_CountryID is null
		or add2.PostalCode is null
		or add2.StreetName is null)
		and WasteHandlerPartyID = @Pa
		)

	set @whpCountryID = (
		select
			LOV_CountryID
		from
		WASTEHANDLERPARTY whp
		inner join 
			ADDRESS add1 
		on	whp.AddressID = add1.AddressID
		and whp.WasteHandlerPartyID = @Pa
		)

	set @ci1 = (
		select
			COUNT(*) 
		from 
			WASTEHANDLERPARTY whp
		inner join 
			ADDRESS add1 
		on whp.AddressID = add1.AddressID
		inner join 
			ADDRESS add2 
		on whp.SiteAddressID = add2.AddressID
		where (
			add1.City is null
		or add1.LOV_CountryID is null
		or add1.PostalCode is null
		or add1.StreetName is null
		or add2.City is null
		or add2.LOV_CountryID is null
		or add2.PostalCode is null
		or add2.StreetName is null)
		and WasteHandlerPartyID = @Pa1
		)

	set @whpCountryID1 = (
		select
			LOV_CountryID
		from
		WASTEHANDLERPARTY whp
		inner join 
			ADDRESS add1 
		on	whp.AddressID = add1.AddressID
		and whp.WasteHandlerPartyID = @Pa1
		)

	set @Qa = (@Ty+@Tr+@Mb+@Tr1+@Pa) / @Co  

	if @linecount < 8000
	insert into WASTETRANSFER
	select @frep												--FacilityReportID
		  ,4													--LOV_WasteTypeID
		  ,case 
				when (@Co = 5) or (@ci1 = 1) then null 
				else (@frep - 2*cast(@frep/2 as float)) + 1 end --LOV_WasteTreatmentID
		  ,@Mb													--LOV_MethodBasisID
		  ,case 
				when (@Co = 5) or (@ci1 = 1) then null 
				else @Ml end 									--LOV_MethodListID
		  ,case 
				when @ci1 = 1 and @Co = 6 then null
				else cast(cast(@Qa *111 as int)/100.0 as float)
				end												--Quantity
		  ,2													--LOV_QuantutyUnitID
		  ,case when @Co = 5 then null else @Pa1 end			--WasteHandlerPartyID
		  ,case when @Co = 5 then 1 else @ci1 end				--ConfidentialIndicator
		  ,case 
				when (@Co = 5) or (@ci1 = 1) then @Co 
				else null end									--LOV_ConfidentialityID
		  ,'Test Data'											--RemarkText
	where not @frepCountryID = @whpCountryID1

	if @linecount < 4000 
	insert into WASTETRANSFER
	select @frep												--FacilityReportID
		  ,4													--LOV_WasteTypeID
		  ,case 
				when (@Co = 7) or (@ci = 1) then null 
				else (@frep - 2*cast(@frep/2 as float)) + 1 end --LOV_WasteTreatmentID
		  ,@Mb													--LOV_MethodBasisID
		  ,case 
				when (@Co = 7) or (@ci = 1) then null 
				else @Ml end 									--LOV_MethodListID
		  ,case 
				when @Tr = 2 and @Co = 7 then null
				when @ci = 1 and @Co = 4 then null
				else cast(cast(@Qa * 99 as int)/100.0 as float)
				end												--Quantity
		  ,2													--LOV_QuantutyUnitID
		  ,case when @Co = 7 and @Tr = 1 then null else @Pa	end	--WasteHandlerPartyID
		  ,case when @Co = 7 then 1 else @ci end				--ConfidentialIndicator
		  ,case 
				when (@Co = 7) or (@ci = 1) then @Co 
				else null end									--LOV_ConfidentialityID
		  ,'Test Data'											--RemarkText
	where not @frepCountryID = @whpCountryID

	if @linecount <= 7000
	insert into WASTETRANSFER
	select @frep												--FacilityReportID
		  ,3													--LOV_WasteTypeID
		  ,case when @Ty = 3 and @Tr = 1 then null
			else (@frep - 2*cast(@frep/2 as float)) + 1 end		--LOV_WasteTreatmentID
		  ,@Mb													--LOV_MethodBasisID
		  ,case when @Ty = 3 and @Tr = 1 then null else @Ml end	--LOV_MethodListID
		  ,case when @Ty = 3 and @Tr = 1 and @Co = 3 then null
				else cast(cast(@Qa * 88 as int)/100.0 as float)
				end												--Quantity
		  ,2													--LOV_QuantutyUnitID
		  ,null													--WasteHandlerPartyID
		  ,case when @Ty = 3 and @Tr = 1 then 1 else 0 end		--ConfidentialIndicator
		  ,case when @Ty = 3 and @Tr = 1 then @Co else null end	--LOV_ConfidentialityID
		  ,'Test Data'											--RemarkText

	if @linecount >= 5000 and @linecount < 10000
	insert into WASTETRANSFER
	select @frep												--FacilityReportID
		  ,2													--LOV_WasteTypeID
		  ,case when @Ty = 3 and @Tr = 1 then null
			else (@frep - 2*cast(@frep/2 as float)) + 1 end		--LOV_WasteTreatmentID
		  ,@Mb													--LOV_MethodBasisID
		  ,case when @Ty = 3 and @Tr = 1 then null else @Ml end	--LOV_MethodListID
		  ,case when @Ty = 3 and @Tr = 1 and @Co = 5 then null
				else cast(cast(@Qa * 77 as int)/100.0 as float)
				end												--Quantity
		  ,2													--LOV_QuantutyUnitID
		  ,null													--WasteHandlerPartyID
		  ,case when @Ty = 3 and @Tr = 1 then 1 else 0 end		--ConfidentialIndicator
		  ,case when @Ty = 3 and @Tr = 1 then @Co else null end	--LOV_ConfidentialityID
		  ,'Test Data'											--RemarkText

	fetch next from frep_cur into @frep,@frepCountryID
end
close frep_cur
deallocate frep_cur

--select distinct WasteHandlerPartyID, count(*) from WASTETRANSFER where not WasteHandlerPartyID is null  group by WasteHandlerPartyID
--select count(*) from WASTETRANSFER where WasteHandlerPartyID is null and LOV_WasteTypeID = 4
--select * from WASTETRANSFER where LOV_WasteTypeID = 4


---------------------------------------------------------------------------------
--	generate Industrial Activity data for main activity
---------------------------------------------------------------------------------

if object_id('EPRTRmaster.dbo.TEMP_ANNEXIACTIVITY')is not null DROP TABLE EPRTRmaster.dbo.TEMP_ANNEXIACTIVITY
create table EPRTRmaster.dbo.TEMP_ANNEXIACTIVITY (
	ObjectID int identity(1,1) NOT NULL,
	AnnexIActivityID int)

insert into TEMP_ANNEXIACTIVITY
select distinct LOV_AnnexIActivityID from LOV_ANNEXIACTIVITY where EndYear is null and ParentID is not null

declare @maxActivities int
set @maxActivities = (select COUNT(*) from TEMP_ANNEXIACTIVITY)
	
insert into ACTIVITY
select 
	f.FacilityReportID as FacilityReportID,
	1 as RankingNumeric,
	temp.AnnexIActivityID as LOV_AnnexIActivityID 
from FACILITYREPORT f 
inner join
	TEMP_ANNEXIACTIVITY temp
on	temp.ObjectID = (f.FacilityReportID - @maxActivities * cast(f.FacilityReportID/@maxActivities as float)) + 1 
where 
	RemarkText = 'Test Data'


---------------------------------------------------------------------------------
--	generate Industrial Activity data for sub-activities
---------------------------------------------------------------------------------

truncate table EPRTRmaster.dbo.TEMP_ANNEXIACTIVITY

insert into TEMP_ANNEXIACTIVITY
select distinct LOV_AnnexIActivityID from vAT_ANNEXIACTIVITY where SubActivityCode is not null

set @maxActivities = (select COUNT(*) from TEMP_ANNEXIACTIVITY)
	
insert into ACTIVITY
select
	f.FacilityReportID as FacilityReportID,
	2 as RankingNumeric,
	temp.AnnexIActivityID as LOV_AnnexIActivityID 
from FACILITYREPORT f 
inner join
	TEMP_ANNEXIACTIVITY temp
on	temp.ObjectID = (f.FacilityReportID - @maxActivities * cast(f.FacilityReportID/@maxActivities as float)) + 1 
where 
	RemarkText = 'Test Data'

insert into ACTIVITY
select top 100
	f.FacilityReportID as FacilityReportID,
	3 as RankingNumeric,
	temp.AnnexIActivityID as LOV_AnnexIActivityID 
from FACILITYREPORT f 
inner join
	TEMP_ANNEXIACTIVITY temp
on	temp.ObjectID = ((f.FacilityReportID+7) - @maxActivities * cast((f.FacilityReportID+7)/@maxActivities as float)) + 1 
where 
	RemarkText = 'Test Data'

insert into ACTIVITY
select top 50
	f.FacilityReportID as FacilityReportID,
	4 as RankingNumeric,
	temp.AnnexIActivityID as LOV_AnnexIActivityID 
from FACILITYREPORT f 
inner join
	TEMP_ANNEXIACTIVITY temp
on	temp.ObjectID = ((f.FacilityReportID+11) - @maxActivities * cast((f.FacilityReportID+11)/@maxActivities as float)) + 1 
where 
	RemarkText = 'Test Data'

DROP TABLE EPRTRmaster.dbo.TEMP_ANNEXIACTIVITY
--select * from ACTIVITY where FacilityReportID in 
--	(select FacilityReportID from FACILITYREPORT where RemarkText = 'Test Data') 
--order by 4,2,3


---------------------------------------------------------------------------------
--	initialize Pollutant Release
---------------------------------------------------------------------------------

declare @POL int
set @POL = 99
declare @MethB int
set @MethB = 3
declare @Med int
set @Med = 7
declare @MethL int
set @MethL = 5
declare @Conf int
set @Conf = 8
declare @offset int


---------------------------------------------------------------------------------
--	insert "Air" pollution in table POLLUTANTRELEASE	
---------------------------------------------------------------------------------

set @offset = 0
insert into POLLUTANTRELEASE
select 
	FacilityReportID as FacilityReportID,
	case when (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1)= 8 then 2
		else 1 end as LOV_MediumID, -- 1:air, 2:land 3:water
	case when (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1)= 8 then 92
		else (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1) end as LOV_PollutantID,
	(((FacilityReportID + @offset) - @MethB * cast((FacilityReportID + @offset)/@MethB as float)) + 1)as LOV_MethodBasisID,
	case 
		when (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1) < 8 then null
		else (((FacilityReportID + @offset) - @MethL * cast((FacilityReportID + @offset)/@MethL as float)) + 1)
		end as MethodListID,
	((((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float))) *
		(((FacilityReportID + @offset) - @MethB * cast((FacilityReportID + @offset)/@MethB as float)) + 30000) *
		(((FacilityReportID + @offset) - @MethL * cast((FacilityReportID + @offset)/@MethL as float)) + 7)* 100)as TotalQuantity,
	(select LOV_UnitID from LOV_UNIT where Code = 'KGM') as LOV_TotalQuantityUnitID,
	((((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float))+1) *
		(((FacilityReportID + @offset) - @MethB * cast((FacilityReportID + @offset)/@MethB as float)) + 1) *
		(((FacilityReportID + @offset) - @MethL * cast((FacilityReportID + @offset)/@MethL as float)) + 1)* 1000)as AccidentalQuantity,
	(select LOV_UnitID from LOV_UNIT where Code = 'KGM') as LOV_AccidentalQuantityUnitID,
	case 
		when (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1) >= 8 then 0
		else 1 
		end as ConfidentialIndicator,
	case 
		when (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1) >= 8 then null
		else (((FacilityReportID) - @Conf * cast((FacilityReportID )/@Conf as float)) + 1)
		end as LOV_ConfidentialityID,
	'Test Data' as RemarkText
from 
	FACILITYREPORT 
where RemarkText = 'Test Data'


---------------------------------------------------------------------------------
--	insert "Land" pollution in table POLLUTANTRELEASE	
---------------------------------------------------------------------------------

set @offset = 199
insert into POLLUTANTRELEASE
select 
	FacilityReportID as FacilityReportID,
	2 as LOV_MediumID, -- 1:air, 2:land 3:water 
	case when (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1)= 8 then 92
		else (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1) end as LOV_PollutantID,
	(((FacilityReportID + @offset) - @MethB * cast((FacilityReportID + @offset)/@MethB as float)) + 1)as LOV_MethodBasisID,
	case 
		when (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1) < 8 then null
		else (((FacilityReportID + @offset) - @MethL * cast((FacilityReportID + @offset)/@MethL as float)) + 1)
		end as MethodListID,
	((((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float))) *
		(((FacilityReportID + @offset) - @MethB * cast((FacilityReportID + @offset)/@MethB as float)) + 30000) *
		(((FacilityReportID + @offset) - @MethL * cast((FacilityReportID + @offset)/@MethL as float)) + 7)* 100)as TotalQuantity,
	(select LOV_UnitID from LOV_UNIT where Code = 'KGM') as LOV_TotalQuantityUnitID,
	((((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float))+1) *
		(((FacilityReportID + @offset) - @MethB * cast((FacilityReportID + @offset)/@MethB as float)) + 1) *
		(((FacilityReportID + @offset) - @MethL * cast((FacilityReportID + @offset)/@MethL as float)) + 1)* 1000)as AccidentalQuantity,
	(select LOV_UnitID from LOV_UNIT where Code = 'KGM') as LOV_AccidentalQuantityUnitID,
	case 
		when (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1) >= 8 then 0
		else 1 
		end as ConfidentialIndicator,
	case 
		when (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1) >= 8 then null
		else (((FacilityReportID) - @Conf * cast((FacilityReportID )/@Conf as float)) + 1)
		end as LOV_ConfidentialityID,
	'Test Data' as RemarkText
from 
	FACILITYREPORT 
where RemarkText = 'Test Data'


---------------------------------------------------------------------------------
--	insert "Water" pollution in table POLLUTANTRELEASE	
---------------------------------------------------------------------------------

set @offset = 217
insert into POLLUTANTRELEASE
select 
	FacilityReportID as FacilityReportID,
	case when (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1)= 8 then 2
		else 3 end as LOV_MediumID, -- 1:air, 2:land 3:water 
	case when (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1)= 8 then 92
		else (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1) end as LOV_PollutantID,
	(((FacilityReportID + @offset) - @MethB * cast((FacilityReportID + @offset)/@MethB as float)) + 1)as LOV_MethodBasisID,
	case 
		when (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1) < 8 then null
		else (((FacilityReportID + @offset) - @MethL * cast((FacilityReportID + @offset)/@MethL as float)) + 1)
		end as MethodListID,
	((((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float))) *
		(((FacilityReportID + @offset) - @MethB * cast((FacilityReportID + @offset)/@MethB as float)) + 30000) *
		(((FacilityReportID + @offset) - @MethL * cast((FacilityReportID + @offset)/@MethL as float)) + 7)* 100)as TotalQuantity,
	(select LOV_UnitID from LOV_UNIT where Code = 'KGM') as LOV_TotalQuantityUnitID,
	((((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float))+1) *
		(((FacilityReportID + @offset) - @MethB * cast((FacilityReportID + @offset)/@MethB as float)) + 1) *
		(((FacilityReportID + @offset) - @MethL * cast((FacilityReportID + @offset)/@MethL as float)) + 1)* 1000)as AccidentalQuantity,
	(select LOV_UnitID from LOV_UNIT where Code = 'KGM') as LOV_AccidentalQuantityUnitID,
	case 
		when (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1) >= 8 then 0
		else 1 
		end as ConfidentialIndicator,
	case 
		when (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1) >= 8 then null
		else (((FacilityReportID) - @Conf * cast((FacilityReportID )/@Conf as float)) + 1)
		end as LOV_ConfidentialityID,
	'Test Data' as RemarkText
from 
	FACILITYREPORT 
where RemarkText = 'Test Data'


---------------------------------------------------------------------------------
--	insert both, "Air", "Water" and "Soil" pollution in table POLLUTANTRELEASE	
---------------------------------------------------------------------------------

set @offset = 317
insert into POLLUTANTRELEASE
select 
	FacilityReportID as FacilityReportID,
	case when ((FacilityReportID + @offset) - @MethB * cast((FacilityReportID + @offset)/@MethB as float)) in (0,1) then 1
		when ((FacilityReportID + @offset) - @MethB * cast((FacilityReportID + @offset)/@MethB as float)) in (2,3) then 2
		else 3 end as LOV_MediumID, -- 1:air, 2:land 3:water 
	case when (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1)= 8 then 92
		else (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1) end as LOV_PollutantID,
	(((FacilityReportID + @offset) - @MethB * cast((FacilityReportID + @offset)/@MethB as float)) + 1)as LOV_MethodBasisID,
	case 
		when (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1) < 8 then null
		else (((FacilityReportID + @offset) - @MethL * cast((FacilityReportID + @offset)/@MethL as float)) + 1)
		end as MethodListID,
	((((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float))) *
		(((FacilityReportID + @offset) - @MethB * cast((FacilityReportID + @offset)/@MethB as float)) + 30000) *
		(((FacilityReportID + @offset) - @MethL * cast((FacilityReportID + @offset)/@MethL as float)) + 7)* 100)as TotalQuantity,
	(select LOV_UnitID from LOV_UNIT where Code = 'KGM') as LOV_TotalQuantityUnitID,
	((((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float))+1) *
		(((FacilityReportID + @offset) - @MethB * cast((FacilityReportID + @offset)/@MethB as float)) + 1) *
		(((FacilityReportID + @offset) - @MethL * cast((FacilityReportID + @offset)/@MethL as float)) + 1)* 1000)as AccidentalQuantity,
	(select LOV_UnitID from LOV_UNIT where Code = 'KGM') as LOV_AccidentalQuantityUnitID,
	case 
		when (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1) >= 8 then 0
		else 1 
		end as ConfidentialIndicator,
	case 
		when (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1) >= 8 then null
		else (((FacilityReportID) - @Conf * cast((FacilityReportID )/@Conf as float)) + 1)
		end as LOV_ConfidentialityID,
	'Test Data' as RemarkText
from 
	FACILITYREPORT 
where RemarkText = 'Test Data'

declare @BTEX int
declare @BENZENE int
declare @ETHYLBENZENE int
declare @TOLUENE int
declare @XYLENES int 
declare @AIR int 
declare @WATER int 
declare @LAND int

set @BTEX = (select LOV_PollutantID from LOV_POLLUTANT where Code = 'BTEX')
set @BENZENE = (select LOV_PollutantID from LOV_POLLUTANT where Code = 'BENZENE')
set @ETHYLBENZENE = (select LOV_PollutantID from LOV_POLLUTANT where Code = 'ETHYLBENZENE')
set @TOLUENE = (select LOV_PollutantID from LOV_POLLUTANT where Code = 'TOLUENE')
set @XYLENES = (select LOV_PollutantID from LOV_POLLUTANT where Code = 'XYLENES')
set @AIR = (select LOV_MediumID from LOV_MEDIUM where Code = 'AIR') 
set @WATER = (select LOV_MediumID from LOV_MEDIUM where Code = 'LAND') 
set @LAND = (select LOV_MediumID from LOV_MEDIUM where Code = 'WATER')

update POLLUTANTRELEASE
set 
	TotalQuantity = ((FacilityReportID - 200 * cast(FacilityReportID/200 as float)) + 51),
    AccidentalQuantity = ((FacilityReportID - 200 * cast(FacilityReportID/200 as float)) + 1)
where
	LOV_PollutantID in (@BENZENE, @ETHYLBENZENE, @TOLUENE, @XYLENES)
and LOV_MediumID in (@WATER, @LAND)
and RemarkText = 'Test Data'

update POLLUTANTRELEASE
set 
	TotalQuantity = ((FacilityReportID - 2000 * cast(FacilityReportID/2000 as float)) + 501),
    AccidentalQuantity = ((FacilityReportID - 2000 * cast(FacilityReportID/2000 as float)) + 1)
where
	LOV_PollutantID in (@BENZENE)
and LOV_MediumID in (@AIR)
and RemarkText = 'Test Data'

delete from POLLUTANTRELEASE
where
	LOV_PollutantID in (@ETHYLBENZENE, @TOLUENE, @XYLENES)
and LOV_MediumID in (@AIR)
and RemarkText = 'Test Data'

--select * from POLLUTANTRELEASE
--where RemarkText = 'Test Data'
--order by 2

---------------------------------------------------------------------------------
--	insert "WasteWater" pollution in table POLLUTANTTRANSFER	
---------------------------------------------------------------------------------

--delete from POLLUTANTTRANSFER where RemarkText = 'Test Data'
set @offset = 319
insert into POLLUTANTTRANSFER
select 
	FacilityReportID as FacilityReportID,
	(((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1)as LOV_PollutantID,
	(((FacilityReportID + @offset) - @MethB * cast((FacilityReportID + @offset)/@MethB as float)) + 1)as LOV_MethodBasisID,
	case 
		when (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1) < 8 then null
		else (((FacilityReportID + @offset) - @MethL * cast((FacilityReportID + @offset)/@MethL as float)) + 1)
		end as MethodListID,
	((((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float))) *
		(((FacilityReportID + @offset) - @MethB * cast((FacilityReportID + @offset)/@MethB as float)) + 30000) *
		(((FacilityReportID + @offset) - @MethL * cast((FacilityReportID + @offset)/@MethL as float)) + 7)* 100)as Quantity,
	(select LOV_UnitID from LOV_UNIT where Code = 'KGM') as LOV_QuantityUnitID,
	case 
		when (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1) >= 8 then 0
		else 1 
		end as ConfidentialIndicator,
	case 
		when (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1) >= 8 then null
		else (((FacilityReportID) - @Conf * cast((FacilityReportID )/@Conf as float)) + 1)
		end as LOV_ConfidentialityID,
	'Test Data' as RemarkText
from 
	FACILITYREPORT 
where RemarkText = 'Test Data'

--select * from POLLUTANTTRANSFER
--where RemarkText = 'Test Data'
--order by 2

set @offset = 330
insert into POLLUTANTTRANSFER
select top 5000
	FacilityReportID as FacilityReportID,
	(((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1)as LOV_PollutantID,
	(((FacilityReportID + @offset) - @MethB * cast((FacilityReportID + @offset)/@MethB as float)) + 1)as LOV_MethodBasisID,
	case 
		when (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1) < 8 then null
		else (((FacilityReportID + @offset) - @MethL * cast((FacilityReportID + @offset)/@MethL as float)) + 1)
		end as MethodListID,
	((((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float))) *
		(((FacilityReportID + @offset) - @MethB * cast((FacilityReportID + @offset)/@MethB as float)) + 30000) *
		(((FacilityReportID + @offset) - @MethL * cast((FacilityReportID + @offset)/@MethL as float)) + 7)* 100)as Quantity,
	(select LOV_UnitID from LOV_UNIT where Code = 'KGM') as LOV_QuantityUnitID,
	case 
		when (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1) >= 8 then 0
		else 1 
		end as ConfidentialIndicator,
	case 
		when (((FacilityReportID + @offset) - @POL * cast((FacilityReportID + @offset)/@POL as float)) + 1) >= 8 then null
		else (((FacilityReportID) - @Conf * cast((FacilityReportID )/@Conf as float)) + 1)
		end as LOV_ConfidentialityID,
	'Test Data' as RemarkText
from 
	FACILITYREPORT 
where RemarkText = 'Test Data'

--insert into POLLUTANTTRANSFER
--select top 500
--	FacilityReportID as FacilityReportID,
--	@BENZENE as LOV_PollutantID,
--	1 as LOV_MethodBasisID,
--	1 MethodListID,
--	123 as Quantity,
--	(select LOV_UnitID from LOV_UNIT where Code = 'KGM') as LOV_QuantityUnitID,
--	0 ConfidentialIndicator,
--	null  as LOV_ConfidentialityID,
--	'Test Data' as RemarkText
--from 
--	POLLUTANTTRANSFER 
--where RemarkText = 'Test Data'
--and LOV_PollutantID not in (@BENZENE,@BTEX)

update POLLUTANTTRANSFER
set 
	Quantity = ((FacilityReportID - 200 * cast(FacilityReportID/200 as float)) + 51)
where
	LOV_PollutantID in (@BTEX, @BENZENE, @ETHYLBENZENE, @TOLUENE, @XYLENES)
and RemarkText = 'Test Data'

--select
--	LOV_PollutantID,
--	FacilityReportID,
--	COUNT(*)
--from POLLUTANTTRANSFER
--group by 
--	LOV_PollutantID,
--	FacilityReportID
--order by 3 desc
