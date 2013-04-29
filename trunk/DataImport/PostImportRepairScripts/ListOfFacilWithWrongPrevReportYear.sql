use EPRTRMaster_2012_11_19

select distinct lc.name as Country, fr.NationalID, pr.ReportingYear, fr.PrevReportingYear, fr.FacilityName, fr.ParentCompanyName
from FACILITYREPORT fr inner join
	POLLUTANTRELEASEANDTRANSFERREPORT as pr
	on pr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
	inner join LOV_COUNTRY lc on lc.LOV_CountryID = pr.LOV_CountryID
	inner join 
	(select distinct s1.FacilityID, s1.NationalID, s1.LOV_CountryID, s1.PrevReportingYear
from
(select 
	FacilityID,
	NationalID,
	pr.LOV_CountryID,
	PrevReportingYear
  FROM [FACILITYREPORT] as fr
	inner join POLLUTANTRELEASEANDTRANSFERREPORT as pr
	on pr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID		
  where PrevNationalID is not null And PrevReportingYear is not Null and
		(PrevReportingYear <> ReportingYear and NationalID = PrevNationalID)
		) as s1
		left outer join
(select 
	FacilityID, NationalID,pr.LOV_CountryID, ReportingYear
  FROM [FACILITYREPORT] as fr
	inner join POLLUTANTRELEASEANDTRANSFERREPORT as pr
	on pr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
 ) as s2		
 on s1.FacilityID = s2.FacilityID and s1.LOV_CountryID = s2.LOV_CountryID 
	and s1.NationalID = s2.NationalID and s1.PrevReportingYear = s2.ReportingYear
where s2.FacilityID is Null
) as wr on 
	wr.FacilityID = fr.FacilityID 
	and fr.NationalID = wr.NationalID
	and pr.LOV_CountryID = wr.LOV_CountryID
	and fr.PrevReportingYear = wr.PrevReportingYear
order by Country, NationalID, ReportingYear
/*) as s1 right outer join
[WrongPreviousReportingYear] as s2
on --s1.FacilityID = s2.FacilityID and
	s1.NationalID = s2.NationalID and
	s1.LOV_CountryID = s2.LOV_CountryID
where s1.FacilityID is Null	
order by s2.LOV_CountryID, s2.NationalID
*/