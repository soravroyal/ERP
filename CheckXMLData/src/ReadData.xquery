declare namespace ns = "urn:eu:com:env:prtr:data:standard:2";

declare variable $source_url as xs:string external;
declare variable $id as xs:string external;
declare variable $country as xs:string external;
declare variable $year as xs:string external;

(: Functions :)

declare function local:getPollutantRelease($facilityReports)
{
	let $pollutants := $facilityReports/ns:PollutantRelease
	for $mediumCode in distinct-values($pollutants/ns:MediumCode)
		for $pollutantCode in distinct-values($pollutants[ns:MediumCode = $mediumCode]/ns:PollutantCode)
			let $sum := sum($pollutants[ns:MediumCode = $mediumCode and ns:PollutantCode = $pollutantCode]/ns:TotalQuantity)
			return concat($id,",",$country,",",$year,",",$mediumCode,",",$pollutantCode,",",$sum,"&#10;")
};

declare function local:getPollutantTransfer($facilityReports)
{
	let $pollutants := $facilityReports/ns:PollutantTransfer
	for $pollutantCode in distinct-values($pollutants/ns:PollutantCode)
		let $sum := sum($pollutants[ns:PollutantCode = $pollutantCode]/ns:Quantity)
		return concat($id,",",$country,",",$year,",",$pollutantCode,",",$sum,"&#10;")
};

declare function local:getWasteTransfer($facilityReports)
{
	let $waste := $facilityReports/ns:WasteTransfer
	for $wasteTypeCode in distinct-values($waste/ns:WasteTypeCode)
		let $sum := sum($waste[ns:WasteTypeCode = $wasteTypeCode]/ns:Quantity)
		return concat($id,",",$country,",",$year,",",$wasteTypeCode,",",$sum,"&#10;")
};

(: Get values :)

let $mainNode := doc($source_url)/ns:PollutantReleaseAndTransferReport

(: Count facility reports :)
let $facilityReports := $mainNode/ns:FacilityReport
let $numFReports := count($facilityReports)


(: Count PollutantRelease :)
return (
	$id,",",$country,",",$year,",",$numFReports,"&#10;",
	"######&#10;",
	local:getPollutantRelease($facilityReports),
	"######&#10;",
	local:getPollutantTransfer($facilityReports),
	"######&#10;",
	local:getWasteTransfer($facilityReports)
	)