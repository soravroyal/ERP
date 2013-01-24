----------------------------------------------------------------------------------------------
--	Atkins 12/2011
--	The porpose of this script is to solve ticket: 
--	#83: Fix broken facility history
----------------------------------------------------+---------------------------
--    Reporter:  spanghel                           |       Owner:  starzwol 
--        Type:  task                               |      Status:  new      
--    Priority:  major                              |   Milestone:  Release D
--   Component:  Task 4: Bugfixing and maintenance  |     Version:           
--  Resolution:                                     |    Keywords:           
----------------------------------------------------+---------------------------
--	Background:
--	After the resubmission round, the facility history has been broken for a number of facilities, 
--	due to the fact that the Member states do not report the previous national id in the way it was intended.
--	Currently, the import routine checks whether previous reporting year and reporting year are different, 
--	in that case it is assumed that the facility has been imported before and the validation starts 
--	in order to find the matching facilityID.
--	If previous reporting year and reporting year are identical, then the system identifies the facility 
--	as a new facility, a facility that is being reported for the first time. Such a facility gets 
--	automatically assigned a newly generated FacilityId.
--	Reimporting facility with identical reporting and previous reporting year thus always generates
--	a new FacilityID and consequently breaks the history regarding previous imports.
--	
--	This script is written in order to reset all facilityIDs of resubmissions that do not point correctly.
--	Precondition for this script to work is that all NationalIDs in the respective counties are unique.
----------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------
--	Table FacilityNational is used as helptable. Initially it will hold all
--	references between FacilityID, NationalID and country Codes from tabe FACILITYREPORT.
--	After the clean up column ToBeUsed will indicate which of these references are
--	to be used by table FACILITYREPORT
 
if object_id('FacilityNational')is not null DROP TABLE FacilityNational
go

create table FacilityNational(
FacilityID int,
NationalID nvarchar(255),
Code nvarchar(255),
ToBeUsed int
)
go

----------------------------------------------------------------------------------------------
--	table FacilityNational gets initialized with all distinct FacilityID, NationalID and 
--	country Codes from tabe FACILITYREPORT

insert into FacilityNational
select distinct 
	FacilityID,
	NationalID,
	l.Code,
	0	--initially no entry is qualified to be used after the clean up
from POLLUTANTRELEASEANDTRANSFERREPORT prtr
inner join FACILITYREPORT f
on	f.PollutantReleaseAndTransferReportID = prtr.PollutantReleaseAndTransferReportID
inner join LOV_COUNTRY l
on	l.LOV_CountryID = prtr.LOV_CountryID

----------------------------------------------------------------------------------------------
--	All FaciltyIDs that refference more than 1 NationalID are assumed to have been correctly
--	reported by the MS to indicate a change of NationalIDs and are thus marked. This
--	information is to be kept after the update.

update FacilityNational
set tobeused = 1
from FacilityNational fn
inner join(
	select 
		FacilityID, 
		COUNT(*) as nb
	from FacilityNational
	group by FacilityID
	--order by 2 desc
)m
on	m.FacilityID = fn.FacilityID
and m.nb > 1

----------------------------------------------------------------------------------------------
--	For each NationalID/CountryCode the min FacilityID is found and the respective 
--	records tobeused value is set to 2.
--	After this step any record still having a tobeused value = 1 will be discarded,
--	but still needs to be taken care of because it may very well indicate
--	that a facility might have changed NatioanlIds more than once, but the second change
--	refers to a different facilityID. This issue can be handled
--	by checking the leftover records that still have a tobeused value = 1.

update FacilityNational
set tobeused = 2
from FacilityNational fn
inner join(
	select distinct
		MIN(FacilityID) as FacilityID,
		NationalID,
		Code
		--COUNT(*) 
	from FacilityNational
	group by 
		NationalID,
		Code,
		tobeused
	having tobeused = 1
--	order by 4 desc
)m
on	m.NationalID = fn.NationalID
and	m.Code = fn.Code
and	m.FacilityID = fn.FacilityID 

----------------------------------------------------------------------------------------------
--	Find those facilityIDs that are left alone after all couples have been assigend tobeused value = 2,
--	this indicates that a facilities nationalID has been changed twice. 61 such incidences have been detected 
--	in the database. Special treatment has to be applied in order to secure that these double changes
--	of NationalID can get traced correctly by one and only one facilityID.
--	To do this FacilityIDs with single tobeused values = 1 must have matching FacilitieIDs 
--	with single tobeused values = 2. Applying this logic the 61 NatitionalIDs are found and
--	their FacilityIDs are redirected.

--	Table NationalIDs is used as another helptable to hold this 61 records including
--	their original(wrong) and later corrected FacilityIDs. 

if object_id('NationalIDs')is not null DROP TABLE NationalIDs
go
create table NationalIDs(
NationalID nvarchar(255),
Code nvarchar(255),
WrongFacilityID int,
CorrectFacilityID int
)
go

insert into NationalIDs (NationalID,Code,WrongFacilityID)
	select NationalID,Code,fn.FacilityID
	from
		FacilityNational fn
	inner join (
		select 
			FacilityID 
		from FacilityNational
		group by FacilityID,tobeused
		having
			tobeused = 1
		and COUNT(*) = 1
	)m
	on  m.FacilityID = fn.FacilityID
	and	fn.tobeused = 1

----------------------------------------------------------------------------------------------
--	Now that we have found the NationalID with the wrong FacilityID, the correct FacilityID
--	is found in table FacilityNational.

update NationalIDs
set CorrectFacilityID = fn.FacilityID
from 
	NationalIDs n
inner join 
	FacilityNational fn
on	fn.nationalID = n.NationalID
and	fn.Code = n.Code
where 
	fn.tobeused = 2

----------------------------------------------------------------------------------------------
--	Having found the correct reference of the FacilityID, table FacilityNational's Facility
--	column is updated.

update FacilityNational
set FacilityID = n.CorrectFacilityID
from
	NationalIDs n
inner join
	FacilityNational fn
on n.WrongFacilityID = fn.FacilityID
where tobeused = 2

----------------------------------------------------------------------------------------------
--	All addional combination of NationalIDs and Country Codes, that just have been identified 
--	and thus have allocated a valied facilityID, get disqualified.
--	They are assumed to have been produced wrongly when reimporting resubmissions. 

update FacilityNational
set tobeused = -1
from 
	FacilityNational fn
inner join(
	select 
		fn2.FacilityID,
		fn2.NationalID,
		fn2.Code 
	from 
		FacilityNational fn1
	inner join
		FacilityNational fn2
	on	fn1.NationalID = fn2.NationalID
	and fn1.Code = fn2.Code
	where 
		fn1.ToBeUsed > 0
	and	fn2.ToBeUsed = 0
)m
on m.FacilityID = fn.FacilityID

----------------------------------------------------------------------------------------------
--	For all NationalID/CountryCode that only get refferenced by facilityIDs that do not
--	point torwards more than one NationalID/CountryCode (see previous update), 
--	find the lowest referencing FacilityID

update FacilityNational
set tobeused = 2
from FacilityNational fn
inner join(
	select 
		MIN(facilityID)as facilityID ,
		NationalID,
		Code
	from FacilityNational fn1
	group by 
		NationalID,
		Code
) m
on	m.facilityID = fn.FacilityID
where fn.ToBeUsed = 0

----------------------------------------------------------------------------------------------
--	That's it! Now all rows in table FacilityNational
--	with a tobeused value = 2 contain only valied and unique references
--	between NationalID, CountryCode and FacilityID.
--	The final step is to update table FACILITYREPORT.
 
	--	column xmlFacilityReportID has no function and is used to hold
	--	a temporary copy of the original FacilityID. This is done for test purpose only.
	--	The column can be deleted after the validation of the update operation.
	update FACILITYREPORT
	set xmlFacilityReportID = FacilityID
	where isnull(xmlFacilityReportID,0) = 0

update FACILITYREPORT
set FacilityID = fn.FacilityID
from FACILITYREPORT fr
inner join 
	POLLUTANTRELEASEANDTRANSFERREPORT prtr 
on	fr.PollutantReleaseAndTransferReportID = prtr.PollutantReleaseAndTransferReportID
inner join 
	LOV_COUNTRY l
on	l.LOV_CountryID = prtr.LOV_CountryID
inner join
	FacilityNational fn
on	fn.NationalID = fr.NationalID
and fn.Code = l.Code
and fn.ToBeUsed = 2


----------------------------------------------------------------------------------------------
--	Actual FacilitIDs still pointing torwards more than one national ID within the same year indicate that at 
--	one point in time it was allowed to split an existing facility into 2 and both 
--	inherted the same facility ID. This is not allowed any more and the following script assiges
--	different facility IDs for each nationalID pointing at the same facilityID in the same year

update FACILITYREPORT
set FacilityID = m4.FacilityID_new
from FACILITYREPORT f
inner join
	POLLUTANTRELEASEANDTRANSFERREPORT prtr
on	prtr.PollutantReleaseAndTransferReportID = f.PollutantReleaseAndTransferReportID
inner join (
	select
		ReportingYear,
		LOV_CountryID, 
		m1.NationalID, 
		FacilityID,
		FacilityID_new
	from (
		select 
			max(prtr.ReportingYear) as ReportingYear,
			prtr.LOV_CountryID, 
			f.NationalID, 
			f.FacilityID
		from
			FACILITYREPORT f
		inner join
			vAT_POLLUTANTRELEASEANDTRANSFERREPORT prtr
		on	prtr.PollutantReleaseAndTransferReportID = f.PollutantReleaseAndTransferReportID
		where FacilityID in(

			select distinct m3.FacilityID
			from (	
				select 
					m2.FacilityID, 
					m2.ReportingYear, 
					m2.Code,
					COUNT(*) as nb
				from(
					select
						prtr.ReportingYear,
						f.NationalID,
						f.FacilityID,
						l.Code
					from vAT_POLLUTANTRELEASEANDTRANSFERREPORT prtr
					inner join FACILITYREPORT f
					on	f.PollutantReleaseAndTransferReportID = prtr.PollutantReleaseAndTransferReportID
					inner join LOV_COUNTRY l
					on	l.LOV_CountryID = prtr.LOV_CountryID
				)m2
				group by 
					m2.FacilityID, 
					m2.ReportingYear,
					m2.Code
				having COUNT(*) > 1
			)m3

			--select distinct FacilityID
			--FROM 
			--	FACILITYREPORT fr1
			--inner join
			--	vAT_POLLUTANTRELEASEANDTRANSFERREPORT prtr1
			--on prtr1.PollutantReleaseAndTransferReportID = fr1.PollutantReleaseAndTransferReportID
			--inner join (
			--	select distinct 
			--		f.FacilityID as fID,
			--		MAX(prtr.ReportingYear) as maxY
			--	from FACILITY f
			--	inner join 
			--		FACILITYREPORT fr
			--	on f.FacilityID = fr.FacilityID
			--	inner join
			--		vAT_POLLUTANTRELEASEANDTRANSFERREPORT prtr
			--	on prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
			--	group by f.FacilityID
			--	) m
			--on  m.fID = fr1.FacilityID
			--and m.maxY = prtr1.ReportingYear
			--group by FacilityID,prtr1.LOV_CountryID
			--having COUNT(*) > 1			
		)
		group by prtr.LOV_CountryID, f.NationalID, f.facilityid
	)m1
	inner join(
		select
			NationalID,
			MAX(xmlFACILITYREPORTID) as FacilityID_new
		from FACILITYREPORT 
		group by NationalID
		)m2
	on m1.NationalID = m2.NationalID
)m4
on	m4.NationalID = f.NationalID
and m4.FacilityID = f.FacilityID
and m4.LOV_CountryID = prtr.LOV_CountryID


----------------------------------------------------------------------------------------------
--	Update of FACILITYLOG table.
--	An extra column is added to table FACILITYLOG. This column is used to hold a copy
--	of the original FacilityID (the FacilityID generated by the import procedure)

--alter table FACILITYLOG drop column OldFacilityID

if not exists ( select * from INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='FACILITYLOG' and COLUMN_NAME='OldFacilityID' )
alter table FACILITYLOG add OldFacilityID int
go 

update FACILITYLOG
set OldFacilityID = FacilityID
where isnull(OldFacilityID,0) = 0

update FACILITYLOG
set FacilityID = fr.FacilityID
from FACILITYLOG f
inner join
	FACILITYREPORT fr
on	fr.FacilityReportID = f.FacilityReportID


----------------------------------------------------------------------------------------------
--	Clean up of help tables

DROP TABLE FacilityNational
DROP TABLE NationalIDs

--SELECT * FROM FACILITYLOG ORDER BY 2 ASC