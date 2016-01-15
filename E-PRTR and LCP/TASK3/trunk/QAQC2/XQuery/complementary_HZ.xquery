xquery version "1.0";

(:===================================================================:)
(: Namespace declaration                                             :)
(:===================================================================:)
(:
import module namespace xmlutil = "urn:eu:com:env:prtr:converter:standard:2" at "http://www.eionet.europa.eu/schemas/eprtr/EPRTR_util_2p1.xquery";
:)
import module namespace xmlutil = "urn:eu:com:env:prtr:converter:standard:2" at "XQuery/utils.xquery";

declare namespace xmlconv="urn:eu:com:env:prtr:converter:standard:2";
declare namespace xsi="http://www.w3.org/2001/XMLSchema-instance";
declare namespace rsm="http://dd.eionet.europa.eu/schemas/LCPandPRTR";
declare namespace p="http://dd.eionet.europa.eu/schemas/LCPandPRTR/LCPandPRTRCommon";

(:===================================================================:)
(: Variable given as an external parameter by the QA service         :)
(:===================================================================:)
(:
declare variable $source_url := 'TestData/TC_Outliers-invalid.xml';
declare variable $source_url := 'TestData/TC_Mandatory4.xml';
:)
declare variable $source_url as xs:string external;

declare variable $xmlconv:errCodeFacilities as xs:string := "1";
declare variable $xmlconv:errCodeCompAuthorities as xs:string := "2";
(:==================================================================:)
(: *******  RUN VALIDATIONS AND GENERATE OUTPUT *************************************** :)
(:==================================================================:)
declare variable $TextCompetentAuthorityParty_Name:="  Name  ";
declare variable $TexCompetentAuthorityParty_Address_StreetName:="  StreetName  ";
declare variable $TexCompetentAuthorityParty_Address_BuildingNumber:="  BuildingNumber  ";
declare variable $TextCompetentAuthorityParty_Address_CityName:="  CityName  ";
declare variable $TextCompetentAuthorityParty_Address_PostcodeCode:="  PostcodeCode  ";
declare variable $TextCompetentAuthorityParty_TelephoneCommunication_CompleteNumberText:="  TelephoneNumber  ";
declare variable $TextCompetentAuthorityParty_FaxCommunication_CompleteNumberText:="  FaxNumber  ";
declare variable $TextCompetentAuthorityParty_EmailCommunication_EmailURIID:="  EmailURIID  ";
declare variable $TextCompetentAuthorityParty_ContactPersonName:="  ContactName  ";
declare variable $TextNationalID := "  dBFacitilyID  " ;
declare variable $TextPreviousNationalIDNationalID:= "  PreviousNationalID " ;
declare variable $TextParentCompanyName:= "  ParentCompanyName  ";
declare variable $TextFacilityName:= "  FacilityName  ";
declare variable $TextAddressStreetName:= "  Address_StreetName  ";
declare variable $TextAddressBuildingNumber :="  Address_BuildingNumber  ";
declare variable $TextAddressCityName:= "  Address_CityName  ";
declare variable $TextAddressPostcodeCode:= "  Address_PostcodeCode  ";
declare variable $TextLongitudeMeasure := " LongitudeMeasure ";
declare variable $TextLatitudeMeasure :=" LatitudeMeasure ";
declare variable $TextRiverBasinDistrictID:= "  RiverBasinDistrictID  ";
declare variable $TextNACEMainEconomicActivityCode:= "  EconomicActivityCode  ";
declare variable $TextMainEconomicActivityName:= " EconomicActivityName  ";
declare variable $TextCompetentAuthorityPartyName:= "  PartyName  ";
declare variable $TextProductionVolumeProductName :="  ProductName  ";
declare variable $TextProductionVolumeQuantity :="  Quantity  ";
declare variable $TextTotalIPPCInstallationQuantity :="  TotalIPPCQuantity  ";
declare variable $TextOperationHours :="  OperationHours  ";
declare variable $TextTotalEmployeeQuantity :="  TotalQuantity  ";
declare variable $TextNutsRegionID :="  NutsRegionID  /";
declare variable $TextWebsiteCommunucationWebsiteURIID:="  WebsiteURIID  ";
declare variable $TextPublicInformation:="  PublicInformation  ";
declare variable $TextConfidentialCode :="  ConfidentialCode  ";
declare variable $TextAERemarkText :="  RemarkText  ";
declare variable $TextActivityRankingNumeric:="  RankingNumeric  ";
declare variable $TextActivityAnnexIActivityCode:="  AnnexlActivityCode  ";
declare variable $TextPRMediumCode :="  MediumCode  ";
declare variable $TextPRPollutantCode :="  PollutantCode  ";
declare variable $TextPRMethodBasisCode :="  MethodBasisCode  ";
declare variable $TextPRMethodUsedMethodTypeCode :="  MethodTypeCode  ";
declare variable $TextPRMethodUsedDesignation :="  Designation  ";
declare variable $TextPRTotalQuantity :="  TotalQuantity  ";
declare variable $TextPRAccidentalQuantity :="  AccidentalQuantity  ";
declare variable $TextPRConfidentialIndicator :="  ConfidentialIndicator  ";
declare variable $TextPRConfidentialCode :="  ConfidentialCode  ";
declare variable $TextPRRemarkText :="  RemarkText ";
declare variable $TextPRWasteTypeCode :="  WasteTypeCode  ";
declare variable $TextPRWasteTreatmentCode :="  WasteTypeCode  ";
declare variable $TextPRQuantity :="  WasteTypeCode  ";
declare variable $TextPRWasteHandlerParty :="  WasteTypeCode  ";
declare variable $TextCompetentAuthorityParty_Email := " Email ";
declare variable $TextIssue := " No issues found ";

(:==================================================================:)
(: *******  RUN VALIDATIONS AND GENERATE OUTPUT *************************************** :)
(:==================================================================:)
(:
declare function xmlconv:findFacilityCompetentAuthorityParty($source_url){

      for $elems in doc($source_url)//rsm:PollutantReleaseAndTransferReport/rsm:CompetentAuthorityParty
        let $NameCompetent := $elems/rsm:Name
        let $AddressCompetent := $elems/rsm:Address/rsm:StreetName
        let $PhoneCompetent := $elems/rsm:TelephoneCommunication/rsm:CompleteNumberText
        let $EmailCompetent := $elems/rsm:EmailCommunication/rsm:EmailURIID
        let $RealeseNameCompetent :=  xmlconv:findCheckElement( $elems/rsm:Name,$TextCompetentAuthorityPartyName, $xmlconv:errCodeCompAuthorities )
        let $RealeseStreetCompetent :=  xmlconv:findCheckElement( $elems/rsm:Address/rsm:StreetName,$TextAddressStreetName, $xmlconv:errCodeCompAuthorities )
        let $ReleaseBuildingNumber := xmlconv:findCheckElement($elems/rsm:Address/rsm:BuildingNumber,$TextAddressBuildingNumber, $xmlconv:errCodeCompAuthorities )
        let $ReleaseCityName := xmlconv:findCheckElement($elems/rsm:Address/rsm:CityName,$TextAddressCityName, $xmlconv:errCodeCompAuthorities )
        let $ReleasePostcodeCode := xmlconv:findCheckElement($elems/rsm:Address/rsm:PostcodeCode,$TextAddressPostcodeCode, $xmlconv:errCodeCompAuthorities )
        let $ReleaseTelephoneCommunicationCompleteNumberText := xmlconv:findCheckElement($elems/rsm:TelephoneCommunication/rsm:CompleteNumberText,$TextCompetentAuthorityParty_TelephoneCommunication_CompleteNumberText, $xmlconv:errCodeCompAuthorities)
          let $ReleaseFaxCommunicationCompleteNumberText := xmlconv:findCheckElement($elems/rsm:FaxCommunication/rsm:CompleteNumberText,$TextCompetentAuthorityParty_FaxCommunication_CompleteNumberText, $xmlconv:errCodeCompAuthorities)
        let $ReleaseCompetentEmailCommunicationEmailURIID := xmlconv:findCheckElement($elems/rsm:EmailCommunication/rsm:EmailURIID,$TextCompetentAuthorityParty_Email, $xmlconv:errCodeCompAuthorities )
        let $ReleaseCompetentContactPersonName := xmlconv:findCheckElement($elems/rsm:ContactPersonName,$TextCompetentAuthorityParty_ContactPersonName, $xmlconv:errCodeCompAuthorities )

        return
          if (empty ($RealeseNameCompetent) and  empty($RealeseStreetCompetent) and empty($ReleaseBuildingNumber )
          and empty($ReleaseCityName)
          and empty( $ReleasePostcodeCode) and empty($ReleaseTelephoneCommunicationCompleteNumberText)
          and empty($ReleaseFaxCommunicationCompleteNumberText ) and empty($ReleaseCompetentEmailCommunicationEmailURIID)
          and empty($ReleaseCompetentContactPersonName)) then
          (xmlutil:buildDescription(""))
          else
          <tr>
                    <td><div align="center">{$NameCompetent}</div></td>
              <td><div align="center">{$AddressCompetent}</div></td>
              <td><div align="center">{$PhoneCompetent }</div></td>
              <td><div align="center">{$EmailCompetent}</div></td>
              <td style="color:blue"><div align="center">
              {$RealeseNameCompetent } {$RealeseStreetCompetent } {$ReleaseBuildingNumber}
              {$ReleaseCityName}{$ReleasePostcodeCode}{$ReleaseCompetentContactPersonName}
              {$ReleaseTelephoneCommunicationCompleteNumberText}{$ReleaseFaxCommunicationCompleteNumberText }
              &#160;</div>
              </td>
          </tr>
};
:)
declare function xmlconv:findFacilityReport($source_url){
    (:let $FacilityReportActivity := xmlconv:findFacilityReportActivity( $source_url) :)
  for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport
          let $FacilityID  :=$elems/rsm:dBFacitilyID
        (:let $FacilityName:=$elems /rsm:FacilityName
        let $ParentCompany:=$elems/rsm:ParentCompanyName
        let $Address := $elems/rsm:Address/rsm:StreetName
        let $Competent :=$elems/rsm:CompetentAuthorityPartyName:)
        (:let $FacilityReportActivity := xmlconv:findFacilityReportActivity( $elems):)
        let $FacilityReportPollutantRelease := xmlconv:findFacilityReportPollutantRelease( $elems)
        let $FacilityReportPollutantTransfer := xmlconv:findFacilityReportPollutantransfer( $elems)
        let $FacilityReportWasteTransfer:= xmlconv:findFacilityReportWasteTransfer( $elems)
        let $ReleaseNationalID := xmlconv:findCheckElementHyphens($elems/rsm:dBFacitilyID,$TextNationalID,$xmlconv:errCodeFacilities )
       (: let $ReleasePreviousNationalIDNationalID := xmlconv:findCheckElement($elems/rsm:PreviousNationalID/rsm:NationalID,$TextPreviousNationalIDNationalID,$xmlconv:errCodeFacilities)
        let $ReleaseParentCompanyName := xmlconv:findCheckElement($elems/rsm:ParentCompanyName ,$TextParentCompanyName )
        let $ReleaseFacilityName := xmlconv:findCheckElement($elems/rsm:FacilityName,$TextFacilityName)
        let $ReleaseAddressStreetName := xmlconv:findCheckElement($elems/rsm:Address/rsm:StreetName,$TextAddressStreetName )
        let $ReleaseAddressBuildingNumber:= xmlconv:findCheckElement($elems/rsm:Address/rsm:BuildingNumber,$TextAddressBuildingNumber )
        let $ReleaseAddressCityName := xmlconv:findCheckElement($elems/rsm:Address/rsm:CityName,$TextAddressCityName )
        let $ReleaseAddressPostcodeCode := xmlconv:findCheckElement($elems/rsm:Address/rsm:PostcodeCode,$TextAddressPostcodeCode )
        let $ReleaseLongitudeMeasure := xmlconv:findCheckElement($elems/rsm:GeographicalCoordinate/rsm:LongitudeMeasure,$TextLongitudeMeasure)
        let $ReleaseLongitudeMeasure1 := xmlconv:findCheckElementZeroes($elems/rsm:GeographicalCoordinate/rsm:LongitudeMeasure,$TextLongitudeMeasure,$xmlconv:errCodeFacilities)
        let $ReleaseLatitudeMeasure := xmlconv:findCheckElement($elems/rsm:GeographicalCoordinate/rsm:LatitudeMeasure,$TextLongitudeMeasure)
        let $ReleaseLatitudeMeasure1 := xmlconv:findCheckElementZeroes($elems/rsm:GeographicalCoordinate/rsm:LatitudeMeasure,$TextLongitudeMeasure,$xmlconv:errCodeFacilities)
        let $ReleaseRiverBasinDistrictID := xmlconv:findCheckElement($elems/rsm:RiverBasinDistrictID,$TextRiverBasinDistrictID )
        let $ReleaseNACEMainEconomicActivityCode := xmlconv:findCheckElement($elems/rsm:NACEMainEconomicActivityCode,$TextNACEMainEconomicActivityCode )
        let $ReleaseMainEconomicActivityName := xmlconv:findCheckElement($elems/rsm:MainEconomicActivityName,$TextMainEconomicActivityName )
        let $ReleaseCompetentAuthorityPartyName := xmlconv:findCheckElement($elems/rsm:CompetentAuthorityPartyName,$TextCompetentAuthorityPartyName ):)
        let $ReleaseProductionVolumeProductName  := xmlconv:findCheckElement ($elems/rsm:productionVolume/rsm:productName,$TextProductionVolumeProductName )
        let $ReleaseProductionVolumeQuantity := xmlconv:findCheckElement($elems/rsm:productionVolume/rsm:quantity,$TextProductionVolumeQuantity  )
       (: let $ReleaseNutsRegionID := xmlconv:findCheckElement($elems/rsm:NutsRegionID,$TextNutsRegionID ):)
           (:  let $ReleaseWebsiteCommunucationWebsiteURIID := xmlconv:findCheckElement($elems/rsm:WebsiteCommunucation/rsm:WebsiteURIID,$TextWebsiteCommunucationWebsiteURIID ):)
        let $ReleasePublicInformation := xmlconv:findCheckElement($elems/rsm:publicInformation,$TextPublicInformation )
        let $ReleaseConfidentialCode := xmlconv:findCheckElement($elems/rsm:confidentialCode,$TextConfidentialCode )
        let $ReleaseAERemarkText := xmlconv:findCheckElement($elems/rsm:remarkText,$TextAERemarkText )

        return
          if (empty($ReleaseNationalID) 

and empty($ReleaseProductionVolumeProductName) and empty($ReleaseProductionVolumeQuantity)

 and empty($ReleasePublicInformation)  and
empty($ReleaseConfidentialCode) and empty($ReleaseAERemarkText)
(:and empty($FacilityReportActivity):)
and empty($FacilityReportPollutantRelease) and empty($FacilityReportPollutantTransfer) 


) then
            (xmlutil:buildDescription(""))
            else
            <tr>
                    <td><div align="center">{$FacilityID}</div></td>
           
            
              <td valign="middle"><div align="center">
                         {
                  if(empty($FacilityReportPollutantRelease)) then
                   (<p style="color:blue;align:center">{$TextIssue}</p>)
                    else($FacilityReportPollutantRelease)
                  }
              </div></td>
              <td valign="middle"><div align="center">
                {
                  if(empty($FacilityReportPollutantTransfer)) then
                    (<p style="color:blue;align:center">{$TextIssue}</p>)
                    else($FacilityReportPollutantTransfer)
                  }
              </div></td>
              <td valign="middle"><div align="center">
                  {
                  if(empty($FacilityReportWasteTransfer)) then
                   (<p style="color:blue">{$TextIssue}</p>)
                    else($FacilityReportWasteTransfer)
                  }

              </div></td>
              <td style="color:blue"><div align="center">{$ReleaseNationalID}
              
             
           
              {$ReleaseProductionVolumeProductName}{$ReleaseProductionVolumeQuantity}
              {$ReleasePublicInformation}
              {$ReleaseConfidentialCode}{$ReleaseAERemarkText}
              </div></td>
          </tr>
};
(:
declare function xmlconv:findFacilityReportActivity($elems)
{
  for $elems in $elems/rsm:Activity
        let $AnnexIActivityCode  :=$elems/rsm:AnnexIActivityCode
      let $RankingNumeric  :=$elems/rsm:RankingNumeric
      let $Name := concat($TextActivityAnnexIActivityCode," - ", $RankingNumeric)
      let $ReleaseActivityAnnexIActivityCode := xmlconv:findCheckElement($elems/rsm:AnnexIActivityCode,$TextActivityAnnexIActivityCode )

        return
            if (empty($ReleaseActivityAnnexIActivityCode)) then
            (xmlutil:buildDescription(""))
            else
            (
            <table border="1" class="datatable" style="font-size:11px;" >
                <tr>
                <td>{$Name} &#160;</td>
                <td style="color:red;width:22">{xmlconv:wrapErrorDiv($AnnexIActivityCode,$xmlconv:errCodeFacilities)}&#160;</td>
                </tr>
            </table>
            )

};:)

declare function xmlconv:findFacilityReportPollutantRelease($elems)
{
  for $elem in $elems/rsm:PollutantRelease
        let $MediumCode  :=$elem/rsm:mediumCode
      let $PollutantCode  :=$elem/rsm:pollutantCode
      let $Name := concat($MediumCode," - ", $PollutantCode)
      let $ReleasePRMediumCode := xmlconv:findCheckElement($elem/rsm:mediumCode,$TextPRMediumCode )
      let $ReleasePRPollutantCode := xmlconv:findCheckElement($elem/rsm:pollutantCode,$TextPRPollutantCode )
      let $ReleasePRMethodBasisCode := xmlconv:findCheckElement($elem/rsm:methodBasisCode,$TextPRMethodBasisCode )
      let $ReleasePRMethodUsedMethodTypeCode := xmlconv:findCheckElement($elem/rsm:methodUsed/p:MethodTypeCode,$TextPRMethodUsedMethodTypeCode )
      let $ReleasePRMethodUsedDesignation := xmlconv:findCheckElement($elem/rsm:methodUsed/p:Designation,$TextPRMethodUsedDesignation )
      let $ReleasePRConfidentialCode := xmlconv:findCheckElement($elem/rsm:confidentialCode,$TextPRConfidentialCode )
      let $ReleasePRRemarkText := xmlconv:findCheckElement($elem/rsm:remarkText,$TextPRRemarkText )

      return
            if (empty($ReleasePRMethodBasisCode)) then
            (xmlutil:buildDescription(""))
            else
            (
            <table border="1" class="datatable" style="font-size:11px;">
                <tr>
                <td><center><strong>Medium/Pollutant Code</strong></center></td>
                <td ><center><strong>Elements</strong></center></td>
                </tr>
                 <tr>
                <td >{$Name}</td>
                <td style="color:blue">{$ReleasePRMediumCode}{$ReleasePRPollutantCode}{$ReleasePRMethodBasisCode}
                {$ReleasePRMethodUsedMethodTypeCode}{$ReleasePRMethodUsedDesignation}
                {$ReleasePRConfidentialCode}{$ReleasePRRemarkText}</td>
                </tr>
            </table>
            )
};

declare function xmlconv:findFacilityReportWasteTransfer($elems)
{
  for $elem in $elems/rsm:WasteTransfer
      let $WasteTypeCode  :=$elem/rsm:wasteTypeCode
      let $Name := $WasteTypeCode
      let $ReleasePRWasteTypeCode := xmlconv:findCheckElement($elem/rsm:wasteTypeCode,$TextPRWasteTypeCode )
      let $ReleasePRWasteTreatmentCode := xmlconv:findCheckElement($elem/rsm:wasteTreatmentCode,$TextPRWasteTreatmentCode )
      let $ReleasePRWasteHandlerParty := xmlconv:findCheckElement($elem/rsm:WasteHandlerParty,$TextPRWasteHandlerParty )
      let $ReleasePRMethodUsedMethodTypeCode := xmlconv:findCheckElement($elem/rsm:methodUsed/p:MethodTypeCode,$TextPRMethodUsedMethodTypeCode )
      let $ReleasePRMethodUsedDesignation := xmlconv:findCheckElement($elem/rsm:MethodUsed/p:Designation,$TextPRMethodUsedDesignation )
      let $ReleasePRConfidentialCode := xmlconv:findCheckElement($elem/rsm:confidentialCode,$TextPRConfidentialCode )
      let $ReleasePRRemarkText := xmlconv:findCheckElement($elem/rsm:remarkText,$TextPRRemarkText  )

      return
        if (empty($ReleasePRWasteTypeCode) and empty($ReleasePRWasteTreatmentCode)
        and empty($ReleasePRWasteHandlerParty)  and empty($ReleasePRMethodUsedMethodTypeCode)
        and empty($ReleasePRMethodUsedDesignation) and empty($ReleasePRConfidentialCode) and empty($ReleasePRRemarkText) ) then
            (xmlutil:buildDescription(""))
            else
            (
            <table border="1" class="datatable" style="font-size:11px;" align="center">
                <tr>
                <td><center><strong>WasteTypeCode</strong></center></td>
                <td ><center><strong>Elements</strong></center></td>
                </tr>
                 <tr>
                <td >{$Name}</td>
                <td style="color:blue">{$ReleasePRWasteTypeCode}{$ReleasePRWasteTreatmentCode}
                {$ReleasePRWasteHandlerParty}
                {$ReleasePRMethodUsedMethodTypeCode}
                {$ReleasePRMethodUsedDesignation}{$ReleasePRConfidentialCode}{$ReleasePRRemarkText}</td>
                </tr>
            </table>
            )
};

declare function xmlconv:findFacilityReportPollutantransfer($elems){

  for $elem in $elems/rsm:PollutantTransfer

      let $PollutantCode  :=$elem/rsm:pollutantCode
      let $Name := $PollutantCode
      let $ReleasePRPollutantCode := xmlconv:findCheckElement($elem/rsm:pollutantCode,$TextPRPollutantCode )
      let $ReleasePRMethodBasisCode := xmlconv:findCheckElement($elem/rsm:methodBasisCode,$TextPRMethodBasisCode )
      let $ReleasePRMethodUsedMethodTypeCode := xmlconv:findCheckElement($elem/rsm:methodUsed/rsm:methodTypeCode,$TextPRMethodUsedMethodTypeCode )
      let $ReleasePRMethodUsedDesignation := xmlconv:findCheckElement($elem/rsm:methodUsed/p:Designation,$TextPRMethodUsedDesignation )
      let $ReleasePRConfidentialCode := xmlconv:findCheckElement($elem/rsm:confidentialCode,$TextPRConfidentialCode )
      let $ReleasePRRemarkText := xmlconv:findCheckElement($elem/rsm:remarkText,$TextPRRemarkText )

      return
        if (empty($ReleasePRMethodBasisCode) and empty($ReleasePRPollutantCode) and empty($ReleasePRMethodUsedMethodTypeCode)
        and empty($ReleasePRMethodUsedDesignation) and empty($ReleasePRConfidentialCode) and empty($ReleasePRRemarkText) ) then
            (xmlutil:buildDescription(""))
            else
            (
            <table border="1" class="datatable" style="font-size:11px;">
                <tr>
                <td><center><strong>Pollutant Code</strong></center></td>
                <td ><center><strong>Elements</strong></center></td>
                </tr>
                 <tr>
                <td >{$Name}</td>
                <td style="color:blue">{$ReleasePRPollutantCode}{$ReleasePRMethodBasisCode}
                {$ReleasePRMethodUsedMethodTypeCode}{$ReleasePRMethodUsedDesignation}
                {$ReleasePRConfidentialCode}{$ReleasePRRemarkText}</td>
                </tr>
            </table>
            )
};
(:
declare function xmlconv:FacilityReportCompetent($source_url as xs:string) {
let $FacilityCompetent :=  xmlconv:findFacilityCompetentAuthorityParty( $source_url)

return
 if (empty($FacilityCompetent)) then
 ()
 else
<div>
         <br/>

        <table border="1" class="datatable" style="font-size:11px;">
          <tr>
            <th width="261"><div align="center"><strong>Name</strong></div></th>
            <th width="188"><div align="center"><strong>Address</strong></div></th>
            <th width="126"><div align="center"><strong>Phone Number </strong></div></th>
            <th width="135"><div align="center"><strong>E-mail Address </strong></div></th>
            <th width="205"><div align="center"><strong>Elements with Hyphens or Zeroes</strong></div></th>
          </tr>
          { $FacilityCompetent}
         </table>
</div>
};
:)
declare function xmlconv:FacilityReport($source_url as xs:string) {
    let $FacilityReport := xmlconv:findFacilityReport( $source_url)

 return
 if (empty($FacilityReport)) then
 ()
 else
 (
 <div>

  <table border="1"  class="datatable" style="font-size:11px;">
  <tr>
    <th rowspan="2">National ID</th>
   
    
    <th rowspan="2">PollutantRelease</th>
    <th rowspan="2">PollutantTransfer</th>
    <th rowspan="2">WasteTransfer</th>
    <th rowspan="2">Elements with Hyphens or Zeroes</th>
  </tr>
  <tr>
   
  </tr>
  {$FacilityReport}
</table>

</div>
)
};

(:=========================================================================
Element Function
=========================================================================:)
declare function xmlconv:findCheckElementHyphens($elems,$TextShow,$errCode) {
  if  ($elems="-") then
     <div errorcode='{$errCode}' style='color:red'>{$TextShow}</div>
  else ()
};


declare function xmlconv:findCheckElement($elems,$TextShow) {
    xmlconv:findCheckElement($elems,$TextShow,$xmlconv:errCodeFacilities)
};

 declare function xmlconv:findCheckElement($elems,$TextShow,$errCode) {
  if (($elems ="0") or  ($elems="-")) then
     <div errorcode='{$errCode}' style='color:red'>{$TextShow}</div>
  else ()
};

 declare function xmlconv:findCheckElementZeroes($elems,$TextShow,$errCode) {
  if ((substring($elems,1,3)="0,0")  or (substring($elems,1,4)="0,00")) then
       <div errorcode='{$errCode}' style='color:red'>{$TextShow}</div>
  else ()
};

(:Builds a message section for illegal reporting year:)
declare function xmlconv:buildResultMsg($hasErrors, $hasWarnings){
 if($hasErrors = true()) then
     xmlutil:buildDescription($xmlutil:LEVEL_ERROR, "The test failed!")
 else if( $hasWarnings = true()) then
     xmlutil:buildDescription($xmlutil:LEVEL_WARNING, "The test passed with warnings.")
 else
     xmlutil:buildDescription($xmlutil:LEVEL_INFO, "The test passed successfully.")
 };


declare function xmlconv:checkRules($source_url as xs:string) {
let $facilityReport := xmlconv:FacilityReport($source_url)
(:let $compAuthReport := xmlconv:FacilityReportCompetent($source_url):)

return
<div>
    <h2><a name='1'>1. Misuse of hyphens/zeroes in Facilities</a></h2>
    {xmlconv:buildResultMsg(not(empty($facilityReport)), fn:false())}
    {$facilityReport}
    
</div>
};
(:==================================================================:)
(: Main function                                                                                                                :)
(:==================================================================:)
declare function xmlconv:getRules()
as element(rules)
{
<rules>
    <rule code="{ $xmlconv:errCodeFacilities }">
        <title>Misuse of hyphens/zeroes in Facilities</title>
        <descr>This validation  identifies the misuse of hyphens/zeroes. The Facilities table indicate the fields which have either a zero or a hyphen as the  only piece of data stored in the relevant field.</descr>
        <message></message>
        <errLevel>{$xmlutil:LEVEL_ERROR}</errLevel>
    </rule>
   
  </rules>
};
declare function xmlconv:proceed($source_url as xs:string) {

let $results := xmlconv:checkRules($source_url)
let $errorCount := count($results//div[string-length(@errorcode) > 0])
let $errorLevel :=
    if ($errorCount = 0) then
        "INFO"
    else
        "ERROR"
let $feedbackMessage :=
    if ($errorCount = 0) then
        "All tests were passed successfully."
    else
        concat($errorCount, ' error message', substring('s ', number(not($errorCount > 1)) * 2), 'generated')

return

<div class="feedbacktext" style="font-size:13px;">
    <span id="feedbackStatus" class="{$errorLevel}" style="display:none">{$feedbackMessage}</span>

    <h1>E-PRTR - Complementary validation  use of hyphens/zeroes</h1>
        <p>The following validations are  meant to help the Member States to evaluate that the data reported are correct  and complete. The complementary validations will not prevent data from being  stored in the database. More details on the validation rules are available in  the validation manual at <a href="http://www.eionet.europa.eu/schemas/eprtr/" target="_blank">http://www.eionet.europa.eu/schemas/eprtr/</a><br /><br/></p>
        <ul>{
           xmlutil:buildRuleContentLinks($results//div[string-length(@errorcode) > 0]/@errorcode, xmlconv:getRules()//rule)
           }
        </ul>
    {$results}
</div>

};
declare function xmlconv:wrapErrorDiv($elem, $errCode as xs:string)
{
   <div style='color:red' errorcode='{$errCode}'>{$elem}</div>
};

xmlconv:proceed( $source_url )