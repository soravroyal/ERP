(:  ======================================================================  :)
(:  =====      E-PRTR ADDITIONAL VALIDATION                          =====  :)
(:  ======================================================================  :)
(:
    This XQuery contains a number of validations of E-PRTR reports to
    help MS evaluate data. The validations are for inforamtion only and
    will not prevent data from being stored in the database.

    XQuery agency:  The European Commission
    XQuery version: 2.5
    XQuery date:    2009-09-04
    Revision:       $Revision$
    Revision date:  $Date$
  :)

xquery version "1.0";

(:===================================================================:)
(: Namespace declaration                                             :)
(:===================================================================:)



(:
import module namespace xmlutil = "urn:eu:com:env:prtr:converter:standard:2" at "http://www.eionet.europa.eu/schemas/eprtr/EPRTR_util_2p1.xquery";
:)
import module namespace xmlutil = "urn:eu:com:env:prtr:converter:standard:2" at "http://converterstest.eionet.europa.eu/queries/LCPandPRTR_utils.xquery";

declare namespace xmlconv="urn:eu:com:env:prtr:converter:standard:2";
declare namespace xsi="http://www.w3.org/2001/XMLSchema-instance";
declare namespace rsm="http://dd.eionet.europa.eu/schemas/LCPandPRTR";
declare namespace s="urn:eu:com:env:prtr:data:standard:2";
declare namespace p="http://dd.eionet.europa.eu/schemas/LCPandPRTR/LCPandPRTRCommon";

(:===================================================================:)
(: Variable given as an external parameter by the QA service         :)
(:===================================================================:)
(:
declare variable $source_url as xs:string := "TestData/EPRTR-IE2008.xml";
declare variable $source_url as xs:string := "http://cdr.eionet.europa.eu/at/eu/eprtrdat/envt0up1a/EU_Report_2009_201202Feb24.xml";
declare variable $source_url as xs:string external;
:)
(:=======================================================================:)
(:                             FME Variables                             :)
(:     To execute Xqueries in FME uncomment the following lines          :)
(:=======================================================================:)

(:
declare variable $source_url := {fme:get-attribute("_source_xml")};
:)

(:=======================================================================:)
(:                          Standard Variables                            :)
(:To execute Xqueries with an Xquery engine uncomment the following lines:)
(:=======================================================================:)

(::)
declare variable $source_url as xs:string external;


(:===================================================================:)
(: Code lists                                                        :)
(:===================================================================:)
declare variable $designationUrl as xs:string := "http://converters.eionet.europa.eu/xmlfile/EPRTR_MethodDesignation_1.xml";

(: Error codes :)
declare variable $xmlconv:errConfReasons := "1";
declare variable $xmlconv:errConfClaims := "2";
declare variable $xmlconv:errConfClaimsFacility := "3";

(:==================================================================:)
(: *******  RUN VALIDATIONS AND GENERATE OUTPUT *************************************** :)
(:==================================================================:)
declare function xmlconv:ConfidentialityReasons($source_url as xs:string){
    let $findFacilityReports := xmlconv:findFacilityReports($source_url)
    let $findPollutantReleases := xmlconv:findPollutantReleases($source_url)
    let $findPollutantTransfers := xmlconv:findPollutantTransfers($source_url)
    let $findWasteTransfers :=  xmlconv:findWasteTransfers($source_url)

    let $facilityReports := xmlconv:FacilityReports($source_url, $findFacilityReports)
    let $pollutantReleases := xmlconv:PollutantReleases($source_url, $findPollutantReleases)
    let $pollutantTransfers := xmlconv:PollutantTransfers($source_url, $findPollutantTransfers)
    let $wasteTransfers :=  xmlconv:WasteTransfers($source_url, $findWasteTransfers)

    return
    <div>
        <div>
            <h2><br /><a name='1'>1. Reporting of confidentiality reasons</a></h2>
            <p>This complementary validation examines if a reason is provided for claiming confidentiality. If confidentiality is not claimed mandatory fields have to be reported. </p>
        </div>
        {
        if (empty($findFacilityReports) and empty($findPollutantReleases) and empty($findPollutantTransfers) and empty($findWasteTransfers)) then
            xmlutil:buildSuccessfulMessage()
        else
        <div>
            <div>
                <h3>1.1 Facility Reports </h3>
                <p>This complementary validation examines if a reason is provided for claiming confidentiality on facility details. If confidentiality is not claimed facility details have to be reported</p>
            </div>
            {$facilityReports}

            <div>
                <h3>1.2 Pollutant Releases </h3>
                <p>This complementary validation examines if a reason is provided for claiming confidentiality on pollutant releases. If confidentiality is not claimed a method has to be reported.</p>
            </div>
            {$pollutantReleases}

            <div>
                <h3>1.3 Pollutant Transfers </h3>
                <p>This complementary validation examines if a reason is provided for claiming confidentiality on pollutant transfers. If confidentiality is not claimed a method has to be reported.</p>
            </div>
            {$pollutantTransfers }

            <div>
                <h3>1.4 Waste Transfers </h3>
                <p>This complementary validation examines if a reason is provided for claiming confidentiality on pollutant transfers. If confidentiality is not claimed, all information on waste transfers is to be reported.</p>
            </div>
            {$wasteTransfers}
        </div>
        }
    </div>
};
(:==================================================================:)
(: Table 1.1. Facility Reports                                                                                                 :)
(:==================================================================:)
declare function xmlconv:FacilityReports($source_url as xs:string, $Facility) {

     if ($Facility != "") then
    <div>
        <table border="1" style="font-size:13px;" class="datatable">
        <tr>
            <th rowspan="2" width="5%">Facility ID</th>
            
            <th colspan="2" width="50%">Facility Reports</th>
        </tr>
        <tr>
           
            <th>Confidentiality</th>
            <th>Confidentiality Reason</th>
            <!-- <th>Empty fields</th>-->
        </tr>
            {$Facility}
        </table>
    </div>
        else
            xmlutil:buildSuccessfulMessage()
};


declare function xmlconv:findFacilityReports($source_url){
    let $errCode := $xmlconv:errConfReasons
    let $errLevel := data(xmlconv:getRules()//rule[@code = $errCode]/errLevel[1])
    let $errColor := xmlutil:getErrorColor($errLevel)
    return

      for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport
            let $National := $elems/rsm:InspireIdPRTR
            (:let $FacilityName := $elems/rsm:FacilityName
            let $FacilityCompany := $elems/rsm:ParentCompanyName
            let $FacilityCompetent := $elems/rsm:CompetentAuthorityParty
            let $FaclityStreet := string($elems/rsm:Address/rsm:StreetName)
            let $FacilityNumber := string($elems/rsm:Address/rsm:BuildingNumber)
            let $FacilityCity := string($elems/rsm:Address/rsm:CityName)
            let $FacilityCode := string($elems/rsm:Address/rsm:PostcodeCode)
            let $FacilityAddress := concat($FaclityStreet, " ", $FacilityNumber):)

            let $FacilityReportsConfidentiality := $elems/rsm:confidentialIndicator
            let $FacilityReportsConfidentialityReason := xmlconv:findFacilityReportConfidentialityReason($elems)
           (: let $FacilityReportsEmptyFields := xmlconv:findFacilityReportsEmptyFields($elems):)

            let $isInvalidReason := $FacilityReportsConfidentiality = true() and xmlutil:isMissingOrEmpty($elems/rsm:confidentialCode)
            let $isInvalidMandatoryFields := $FacilityReportsConfidentiality != true()(: and $FacilityReportsEmptyFields != "":)

            return
            if ($isInvalidReason or $isInvalidMandatoryFields) then
                  <tr>
                      <td>{$National}</td>{
                    if ($FacilityReportsConfidentiality = true()) then
                        <td style="color:{xmlutil:getErrorColor($xmlutil:LEVEL_INFO)};">YES</td>
                    else
                        <td style="color:{xmlutil:getErrorColor($xmlutil:LEVEL_INFO)};">NO</td>
                    }
                    {
                    if  ($isInvalidReason) then
                        <td style="color:{$errColor};">{xmlutil:buildErrorElement($errCode, $FacilityReportsConfidentialityReason)}</td>
                    else
                        <td>{$FacilityReportsConfidentialityReason}</td>
                    }
                    {()
                    (:
                    if  ($FacilityReportsEmptyFields != "" and $FacilityReportsConfidentiality = "true") then
                        <td style="color:{xmlutil:getErrorColor($xmlutil:LEVEL_INFO)};">{$FacilityReportsEmptyFields}&#160;</td>
                    else if  ($isInvalidMandatoryFields) then
                        <td style="color:{$errColor};">{$FacilityReportsEmptyFields}&#160;</td>
                    else
                        <td>{$FacilityReportsEmptyFields}&#160;</td>
                    :)}
                  </tr>
            else()
};
declare function xmlconv:checkEmptyField($value, $isMandatory as xs:boolean, $errCode as xs:string, $errLevel as xs:integer, $displayValue as xs:string)
as element(td){
    let $isInvalid := normalize-space($value)="" and $isMandatory
    let $displayValue := if ($displayValue = "") then $value else $displayValue

    return
        if ($isInvalid) then
            <td style="color:{xmlutil:getErrorColor($errLevel)};">{xmlutil:buildErrorElement($errCode, "-Not Reported-")}</td>
        else if (normalize-space($value)="") then
            <td>-Not Reported-</td>
        else
            <td>{$displayValue}</td>

};


declare function xmlconv:findFacilityReportConfidentialityReason($elems)
{
    let $isConfidential := $elems/rsm:confidentialIndicator
    let $confidentialCode := $elems/rsm:confidentialCode

    return
    if ($isConfidential = true()) then
    (
         if ($confidentialCode != "") then
              $confidentialCode
         else
             "-Not Reported-"
    )
    else
    ()
};
(:
declare function xmlconv:findFacilityReportsEmptyFields($elems)
{
     <div>
     {if (string($elems/rsm:FacilityName) = "") then
                          <li>Facility Name </li>
                         else()}
     {if (string($elems/rsm:ParentCompanyName) = "") then
                               <li>Facility Company</li>
                            else()}
     {if (string($elems/rsm:Address/rsm:StreetName) = "") then
                               <li>Address</li>
                            else()}
    {if (string($elems/rsm:Address/rsm:CityName) = "") then
                            <li>City</li>
                         else()}
    {if (string($elems/rsm:Address/rsm:PostcodeCode) = "") then
                            <li>Postcode</li>
                         else()}
    </div>
};:)

(:==================================================================:)
(: Table 1.2. Pollutant Releases                                                                                                 :)
(:==================================================================:)
declare function xmlconv:PollutantReleases($source_url as xs:string, $Facility) {
     if ($Facility != "") then
    <div>
        <table border="1" style="font-size:13px;" class="datatable">
        <tr>
            <th rowspan="2" width="5%">Facility ID</th>
            
            <th colspan="7" width="50%">Pollutant Releases</th>
        </tr>
        <tr>
           

            <th>Medium</th>
            <th>Pollutant / Pollutant Group</th>
            <th>Method Basis Code</th>
            <th>Confidentiality</th>
            <th>Confidentiality Reason</th>
            <th>Method Type Code</th>
            <th>Method Designation</th>
        </tr>
            {$Facility}
        </table>
    </div>
        else
            xmlutil:buildSuccessfulMessage()

};

declare function xmlconv:findPollutantReleases($source_url){
    for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport
         let $pollutantReleases :=  xmlconv:findPollutantReleasesByFacilities($elems)

    return
       $pollutantReleases
};

declare function xmlconv:findPollutantReleasesByFacilities($elems){

    let $errCode := $xmlconv:errConfReasons
    let $errLevel := data(xmlconv:getRules()//rule[@code = $errCode]/errLevel[1])
    let $errColor := xmlutil:getErrorColor($errLevel)

      let $National := $elems/rsm:InspireIdPRTR
      (:let $FacilityName := $elems/rsm:FacilityName
      let $FacilityCompany := $elems/rsm:ParentCompanyName
      let $FacilityCompetent := $elems/rsm:CompetentAuthorityParty
      let $FaclityStreet := string($elems/rsm:Address/rsm:StreetName)
      let $FacilityNumber := string($elems/rsm:Address/rsm:BuildingNumber)
      let $FacilityCity := string($elems/rsm:Address/rsm:CityName)
      let $FacilityCode := string($elems/rsm:Address/rsm:PostcodeCode)
      let $FacilityAddress := concat($FaclityStreet, " ", $FacilityNumber, " ", $FacilityCity, " ", $FacilityCode):)

      for $pollutantRelease in $elems/rsm:PollutantRelease

            let $medium := $pollutantRelease/rsm:mediumCode
            let $pollutantCode := $pollutantRelease/rsm:pollutantCode
            let $Confidentiality := $pollutantRelease/rsm:confidentialIndicator
            let $ConfidentialityReason := xmlconv:findPollutantConfidentialityReason($pollutantRelease)

            let $MethodDesignation := xmlconv:findPollutantMethodDesignation($pollutantRelease)
            let $methodBasisCode := $pollutantRelease/rsm:methodBasisCode

            let $isInvalidReason := $Confidentiality = true() and xmlutil:isMissingOrEmpty($pollutantRelease/rsm:confidentialCode)
            let $isInvalidMethodBasis := $Confidentiality != true() and xmlutil:isMissingOrEmpty($methodBasisCode)
            let $isInvalidMethodType := $Confidentiality != true() and xmlutil:isMissingOrEmpty($pollutantRelease/rsm:methodUsed/rsm:MethodTypeCode) and
                ($methodBasisCode = "C" or $methodBasisCode="M")
            let $isInvalidMethodDesignation := $Confidentiality != true() and xmlutil:isMissingOrEmpty($pollutantRelease/rsm:methodUsed/rsm:Designation) and
                $MethodDesignation = "Mandatory"

            return
            if ($isInvalidReason or $isInvalidMethodBasis or $isInvalidMethodType or $isInvalidMethodDesignation) then
                  <tr>
                      <td>{$National}</td>
                      
                    <td>{$medium}</td>
                    <td>{$pollutantCode}</td>
                    {xmlconv:checkEmptyField($pollutantRelease/rsm:methodBasisCode, $isInvalidMethodBasis, $errCode, $errLevel, "")}
                    {
                    if ($Confidentiality = true()) then
                        <td style="color:{xmlutil:getErrorColor($xmlutil:LEVEL_INFO)};">YES</td>
                    else
                        <td style="color:{xmlutil:getErrorColor($xmlutil:LEVEL_INFO)};">NO</td>
                    }
                    {
                    if  ($isInvalidReason) then
                        <td style="color:{$errColor};">{xmlutil:buildErrorElement($errCode, $ConfidentialityReason)}</td>
                    else
                        <td>{$ConfidentialityReason}</td>
                    }
                    {xmlconv:checkEmptyField($pollutantRelease/rsm:methodUsed/p:MethodTypeCode, $isInvalidMethodType, $errCode, $errLevel, "")}
                    {xmlconv:checkEmptyField($pollutantRelease/rsm:methodUsed/p:Designation, $isInvalidMethodDesignation, $errCode, $errLevel, "")}
                  </tr>
            else()
};

declare function xmlconv:findPollutantConfidentialityReason($pollutant)
{
     let $isConfidential := $pollutant/rsm:confidentialIndicator
     let $confidentialCode := $pollutant/rsm:confidentialCode

     return
        if ($isConfidential = true()) then
        (
             if ($confidentialCode != "") then
                  $confidentialCode
             else
                 "-Not Reported-"
        )
        else
        ()
};

declare function xmlconv:findPollutantMethodDesignation($pollutant)
{
    let $methodBasicCode := $pollutant/rsm:methodBasisCode
    let $methodTypeCode := $pollutant/rsm:methodUsed/rsm:MethodTypeCode
    let $designation := doc($designationUrl)//Designation[@methodBasicCode =$methodBasicCode and @methodTypeCode = $methodTypeCode ]

    return $designation
};



(:==================================================================:)
(: Table 1.3. Pollutant Transfers                                   :)
(:==================================================================:)
declare function xmlconv:PollutantTransfers($source_url as xs:string, $Facility) {
     if ($Facility != "") then
    <div>
        <table border="1" style="font-size:13px;" class="datatable">
        <tr>
            <th rowspan="2" width="5%">Facility ID</th>
           
            <th colspan="6" width="50%">Pollutant Transfers</th>
        </tr>
        <tr>
          

            <th>Pollutant / Pollutant Group</th>
            <th>Method Basis Code</th>
            <th>Confidentiality</th>
            <th>Confidentiality Reason</th>
            <th>Method</th>
            <th>Method Designation</th>
        </tr>
            {$Facility}
        </table>
    </div>
        else
            xmlutil:buildSuccessfulMessage()

};

declare function xmlconv:findPollutantTransfers($source_url){
    for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport
         let $pollutantTransfers :=  xmlconv:findPollutantTransfersByFacilities($elems)

    return
       $pollutantTransfers
};

declare function xmlconv:findPollutantTransfersByFacilities($elems){

    let $errCode := $xmlconv:errConfReasons
    let $errLevel := data(xmlconv:getRules()//rule[@code = $errCode]/errLevel[1])
    let $errColor := xmlutil:getErrorColor($errLevel)

      let $National := $elems/rsm:InspireIdPRTR
      (:let $FacilityName := $elems/rsm:FacilityName
      let $FacilityCompany := $elems/rsm:ParentCompanyName
      let $FacilityCompetent := $elems/rsm:CompetentAuthorityParty
      let $FaclityStreet := string($elems/rsm:Address/rsm:StreetName)
      let $FacilityNumber := string($elems/rsm:Address/rsm:BuildingNumber)
      let $FacilityCity := string($elems/rsm:Address/rsm:CityName)
      let $FacilityCode := string($elems/rsm:Address/rsm:PostcodeCode)
      let $FacilityAddress := concat($FaclityStreet, " ", $FacilityNumber, " ", $FacilityCity, " ", $FacilityCode)
:)

      for $pollutantTransfer in $elems/rsm:PollutantTransfer

            let $pollutantCode := $pollutantTransfer/rsm:pollutantCode
            let $Confidentiality := $pollutantTransfer/rsm:confidentialIndicator
            let $ConfidentialityReason := xmlconv:findPollutantConfidentialityReason($pollutantTransfer)

            let $MethodDesignation := xmlconv:findPollutantMethodDesignation($pollutantTransfer)
            let $methodBasisCode := $pollutantTransfer/rsm:methodBasisCode

            let $isInvalidReason := $Confidentiality = true() and xmlutil:isMissingOrEmpty($pollutantTransfer/rsm:confidentialCode)
            let $isInvalidMethodBasis := $Confidentiality != true() and xmlutil:isMissingOrEmpty($methodBasisCode)
            let $isInvalidMethodType := $Confidentiality != true() and xmlutil:isMissingOrEmpty($pollutantTransfer/rsm:methodUsed/p:MethodTypeCode) and
                ($methodBasisCode = "C - Calculated" or $methodBasisCode="M - Measured")
            let $isInvalidMethodDesignation := $Confidentiality != true() and xmlutil:isMissingOrEmpty($pollutantTransfer/rsm:methodUsed/p:Designation) and
                $MethodDesignation = "Mandatory"

            return
            if ($isInvalidReason or $isInvalidMethodBasis or $isInvalidMethodType or $isInvalidMethodDesignation) then
                  <tr>
                      <td>{$National}</td>
                   
                      <td>{$pollutantCode}</td>
                    {xmlconv:checkEmptyField($pollutantTransfer/rsm:methodBasisCode, $isInvalidMethodBasis, $errCode, $errLevel, "")}
                    {
                    if ($Confidentiality = true()) then
                        <td style="color:{xmlutil:getErrorColor($xmlutil:LEVEL_INFO)};">YES</td>
                    else
                        <td style="color:{xmlutil:getErrorColor($xmlutil:LEVEL_INFO)};">NO</td>
                    }
                    {
                    if  ($isInvalidReason) then
                        <td style="color:{$errColor};">{xmlutil:buildErrorElement($errCode, $ConfidentialityReason)}</td>
                    else
                        <td>{$ConfidentialityReason}</td>
                    }
                    {xmlconv:checkEmptyField($pollutantTransfer/rsm:methodUsed/p:MethodTypeCode, $isInvalidMethodType, $errCode, $errLevel, "")}
                    {xmlconv:checkEmptyField($pollutantTransfer/rsm:methodUsed/p:Designation, $isInvalidMethodDesignation, $errCode, $errLevel, "")}
                  </tr>
            else()
};



(:==================================================================:)
(: Table 1.4. Waste Transfers                                                                                                :)
(:==================================================================:)
declare function xmlconv:WasteTransfers($source_url as xs:string, $Facility) {
     if ($Facility != "") then
    <div>
        <table border="1" style="font-size:13px;" class="datatable">
        <tr>
            <th rowspan="2" width="5%">Facility ID</th>
            
            <th colspan="10" width="65%">Waste Transfers</th>
        </tr>
        <tr>
           

            <th>Waste Type</th>
            <th>Method Basis Code</th>
            <th>Confidentiality</th>
            <th>Confidentiality Reason</th>
            <th>Method</th>
            <th>Method Designation</th>
            <th>Waste Treatment</th>
            <th>Waste Transfer Quantity</th>
            <th>Waste Handler</th>
            <th>Waste Handler Address</th>
        </tr>
            {$Facility}
        </table>
    </div>
        else
            xmlutil:buildSuccessfulMessage()

};

declare function xmlconv:findWasteTransfers($source_url){
    for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport
         let $wasteTransfers :=  xmlconv:findWasteTransfersByFacilities($elems)

    return
       $wasteTransfers
};

declare function xmlconv:findWasteTransfersByFacilities($elems){

    let $errCode := $xmlconv:errConfReasons
    let $errLevel := data(xmlconv:getRules()//rule[@code = $errCode]/errLevel[1])
    let $errColor := xmlutil:getErrorColor($errLevel)

      let $National := $elems/rsm:InspireIdPRTR
      (:let $FacilityName := $elems/rsm:FacilityName
      let $FacilityCompany := $elems/rsm:ParentCompanyName
      let $FacilityCompetent := $elems/rsm:CompetentAuthorityParty
      let $FaclityStreet := string($elems/rsm:Address/rsm:StreetName)
      let $FacilityNumber := string($elems/rsm:Address/rsm:BuildingNumber)
      let $FacilityCity := string($elems/rsm:Address/rsm:CityName)
      let $FacilityCode := string($elems/rsm:Address/rsm:PostcodeCode)
      let $FacilityAddress := concat($FaclityStreet, " ", $FacilityNumber, " ", $FacilityCity, " ", $FacilityCode)
      :)

      for $wasteTransfer in $elems/rsm:WasteTransfer

            let $WasteTypeCode := $wasteTransfer/rsm:wasteTypeCode
            let $Confidentiality := $wasteTransfer/rsm:confidentialIndicator
            let $ConfidentialityReason := xmlconv:findPollutantConfidentialityReason($wasteTransfer)

            let $MethodDesignation := xmlconv:findPollutantMethodDesignation($wasteTransfer)
            let $WasteTreatment := $wasteTransfer/rsm:wasteTreatmentCode
            let $Quantity := $wasteTransfer/rsm:quantity
            let $WasteHandler := $wasteTransfer/rsm:WasteHandlerParty/rsm:name
            let $WasteHandlerStreet := $wasteTransfer/rsm:WasteHandlerParty/rsm:address/p:StreetName
            let $WasteHandlerNumber := $wasteTransfer/rsm:WasteHandlerParty/rsm:address/p:BuildingNumber
            let $WasteHandlerCity := $wasteTransfer/rsm:WasteHandlerParty/rsm:address/p:City
            let $WasteHandlerPostCode := $wasteTransfer/rsm:WasteHandlerParty/rsm:address/p:PostcodeCode
            let $WasteHandlerAddress :=  concat($WasteHandlerStreet, " ", $WasteHandlerNumber, " ", $WasteHandlerCity, " ", $WasteHandlerPostCode)
            let $methodBasisCode := $wasteTransfer/rsm:methodBasisCode

            let $isInvalidReason := $Confidentiality = true() and xmlutil:isMissingOrEmpty($wasteTransfer/rsm:confidentialCode)

            let $isInvalidMethodBasis := $Confidentiality != true() and xmlutil:isMissingOrEmpty($methodBasisCode)
            let $isInvalidMethodType := $Confidentiality != true() and xmlutil:isMissingOrEmpty($wasteTransfer/rsm:methodUsed/p:MethodTypeCode) and
                ($methodBasisCode = "C" or $methodBasisCode="M")
            let $isInvalidMethodDesignation := $Confidentiality != true() and xmlutil:isMissingOrEmpty($wasteTransfer/rsm:methodUsed/p:Designation) and
                $MethodDesignation = "Mandatory"

            return
            if ($isInvalidReason or $isInvalidMethodBasis or $isInvalidMethodType or $isInvalidMethodDesignation) then
                  <tr>
                      <td>{$National}</td>
                      
                    <td>{$WasteTypeCode}</td>
                    {xmlconv:checkEmptyField($wasteTransfer/rsm:methodBasisCode, $isInvalidMethodBasis, $errCode, $errLevel, "")}
                    {
                    if ($Confidentiality = true()) then
                        <td style="color:{xmlutil:getErrorColor($xmlutil:LEVEL_INFO)};">YES</td>
                    else
                        <td style="color:{xmlutil:getErrorColor($xmlutil:LEVEL_INFO)};">NO</td>
                    }
                    {
                    if  ($isInvalidReason) then
                        <td style="color:{$errColor};">{xmlutil:buildErrorElement($errCode, $ConfidentialityReason)}</td>
                    else
                        <td>{$ConfidentialityReason}</td>
                    }
                    {xmlconv:checkEmptyField($wasteTransfer/rsm:methodUsed/p:MethodTypeCode, $isInvalidMethodType, $errCode, $errLevel, "")}
                    {xmlconv:checkEmptyField($wasteTransfer/rsm:methodUsed/p:Designation, $isInvalidMethodDesignation, $errCode, $errLevel, "")}
                    <td>{$WasteTreatment}</td>
                    <td>{$Quantity}</td>
                    <td>{$WasteHandler}</td>
                    <td>{$WasteHandlerAddress}</td>
                  </tr>
            else()
};

(:==================================================================:)
(: QA3: Confidentiality                                                                                                      :)
(:==================================================================:)
 declare function xmlconv:controlConfidentiality( $source_url as xs:string){
      let $confidentialFacilityReports := xmlconv:findConfidentialFacilityReports($source_url)
      let $confidentialPollutantReleases := xmlconv:findConfidentialPollutantReleases($source_url)
      let $confidentialPollutantTransfers := xmlconv:findConfidentialPollutantTransfers($source_url)
      let $confidentialWasteTransfers := xmlconv:findConfidentialWasteTransfers($source_url)

      (:let $confidentialFacilityReportsWithMandatoryData := xmlconv:findMandatoryDataConfidentialFacilityReport($source_url):)
      let $confidentialPollutantReleasesWithMandatoryData := xmlconv:findMandatoryDataConfidentialPollutantRelease($source_url)
      let $confidentialPollutantTransfersWithMandatoryData := xmlconv:findMandatoryDataConfidentialPollutantTransfer($source_url)
      let $confidentialWasteTransfersWithMandatoryData := xmlconv:findMandatoryDataConfidentialWasteTransfer($source_url)


      return
      <div>
      <h2><br /><a name='2'>2. Confidentiality claims</a></h2>

       {xmlutil:buildDescription("Companies subject to reporting or competent authorities in the Member States can decide to classify parts of the mandatory data as confidential. This validation examines if confidentiality has been claimed in any case.")}

      {
        if( empty ($confidentialFacilityReports) and empty($confidentialPollutantReleases) and empty($confidentialPollutantTransfers) and empty($confidentialWasteTransfers)) then
        (
            <div>
                {xmlutil:buildDescription(3, "Confidentiality is not claimed in any cases.")}
            </div>
        )
        else
        (
            <div>
             {xmlutil:buildDescription("Below is listed all cases where confidentiality is claimed for facility reports, pollutant releases, pollutant transfers and waste transfers respectively.")}
            {
                (:Confidential PollutantReleases:)
                xmlconv:buildConfidentialPollutantReleases($confidentialPollutantReleases, $confidentialPollutantReleasesWithMandatoryData)
            }
            {
                (:Confidential PollutantTransfers:)
                xmlconv:buildConfidentialPollutantTransfers($confidentialPollutantTransfers, $confidentialPollutantTransfersWithMandatoryData)
            }
            {
                (:Confidential WasteTransfers:)
                xmlconv:buildConfidentialWasteTransfers($confidentialWasteTransfers, $confidentialWasteTransfersWithMandatoryData)
            }
        </div>
        )
    }
    </div>
 };
 (:==================================================================:)
(: Output messages concerning rsm:ConfidentialIndicator data                                             :)
(:==================================================================:)


(:All facility Reports claiming Confidentiality and facility reports claiming Confidentiality but having mandatory data :)
declare function xmlconv:buildConfidentialFacilityReports($list, $listMandatory){
    let $header := "2.1 Facility reports claiming confidentiality"

    let $errCode := $xmlconv:errConfClaims
    let $errLevel := data(xmlconv:getRules()//rule[@code = $errCode]/errLevel[1])

    return

    if(empty($list)) then
    (
        xmlutil:buildSubHeader($header)
        union
        xmlutil:buildDescription($xmlutil:LEVEL_INFO, "No facilities claim confidentiality on facility level")
    )
    else
    (

        let $descr := ""
        let $tableHeader := "Confidentiality has been claimed for data on facility report level for the following facilities:"
        let $table := xmlutil:buildTableFacilityReport($xmlutil:LEVEL_INFO, "Confidential FacilityReports", $list,5, $errCode)

        let $tableHeaderMandatory := "Data that can be withheld due to confidentiality is: The name of the parent company, the name of the facility, the address of the facility. For the following facilities, one or more of these groups of data have been reported on facility report level even though confidentiality was claimed:"
        let $errorPos := ( $xmlutil:COL_FR_FacilityName, $xmlutil:COL_FR_ParentCompanyName, $xmlutil:COL_FR_Address)
        let $tableMandatory := xmlutil:buildTableFacilityReport($errLevel, "Confidential FacilityReports with mandatory main data", $listMandatory, $errorPos, $errCode)

        return
            xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
            union
            xmlutil:buildMessageSection("", "", $tableHeaderMandatory, $tableMandatory)
    )
};


(:All PollutantReleases claiming Confidentiality and PollutantReleases claiming Confidentiality but having mandatory data:)
declare function xmlconv:buildConfidentialPollutantReleases($list, $listMandatory){
    let $header := "2.2 Pollutant releases claiming confidentiality"
    let $errCode := $xmlconv:errConfClaims
    let $errLevel := data(xmlconv:getRules()//rule[@code = $errCode]/errLevel[1])

    return

    if(empty($list)) then
    (
        xmlutil:buildSubHeader($header)
        union
        xmlutil:buildDescription($xmlutil:LEVEL_INFO, "No pollutant releases claim confidentiality")
    )
    else
    (
        let $descr := ""
        let $tableHeader := "Confidentiality has been claimed for the following pollutant releases:"
        let $table := xmlutil:buildTablePollutantRelease($xmlutil:LEVEL_INFO, "Confidential PollutantRelease", $list,8, $errCode)

        let $tableHeaderMandatory := "Data that can be withheld due to confidentiality is: The methods used. For the following pollutant releases the method(s) have been reported even though confidentiality was claimed:"
        let $errorPos := ( $xmlutil:COL_PR_Methods)
        let $tableMandatory := xmlutil:buildTablePollutantRelease($errLevel, "Confidential PollutantReleases with mandatory data", $listMandatory, $errorPos, $errCode)

        return
            xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
            union
            xmlutil:buildMessageSection("", "", $tableHeaderMandatory, $tableMandatory)
    )
};

(:All PollutantTransfers claiming Confidentiality and PollutantTransfers claiming Confidentiality but having mandatory data::)
declare function xmlconv:buildConfidentialPollutantTransfers($list, $listMandatory){
    let $header := "2.3 Pollutant transfers claiming confidentiality"
    let $errCode := $xmlconv:errConfClaims
    let $errLevel := data(xmlconv:getRules()//rule[@code = $errCode]/errLevel[1])

    return

    if(empty($list)) then
    (
        xmlutil:buildSubHeader($header)
        union
        xmlutil:buildDescription($xmlutil:LEVEL_INFO, "No pollutant transfers claim confidentiality")
    )
    else
    (
        let $descr := ""
        let $tableHeader := "Confidentiality has been claimed for the following pollutant transfers:"
        let $table := xmlutil:buildTablePollutantTransfer($xmlutil:LEVEL_INFO, "Confidential PollutantTransfer", $list,4,$errCode)

        let $tableHeaderMandatory := "Data that can be withheld due to confidentiality is: The methods used. For the following pollutant transfers the method(s) have been reported even though confidentiality was claimed:"
        let $errorPos := ($xmlutil:COL_PT_Methods)
        let $tableMandatory := xmlutil:buildTablePollutantTransfer($errLevel, "Confidential PollutantTransfers with mandatory data", $listMandatory, $errorPos, $errCode)

        return
            xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
            union
            xmlutil:buildMessageSection("", "", $tableHeaderMandatory, $tableMandatory)
    )
};

(:All rsm:WasteTransfers claiming Confidentiality and WasteTransfers claiming Confidentiality but having mandatory data::)
declare function xmlconv:buildConfidentialWasteTransfers($list, $listMandatory){
    let $header := "2.4 Waste transfers claiming confidentiality"
    let $errCode := $xmlconv:errConfClaims
    let $errLevel := data(xmlconv:getRules()//rule[@code = $errCode]/errLevel[1])

    return

    if(empty($list)) then
    (
        xmlutil:buildSubHeader($header)
        union
        xmlutil:buildDescription($xmlutil:LEVEL_INFO, "No waste transfers claim confidentiality")
    )
    else
    (

        let $descr := ""
        let $tableHeader := "Confidentiality has been claimed for the following waste transfers:"
        let $table := xmlutil:buildTableWasteTransfer($xmlutil:LEVEL_INFO, "Confidential WasteTransfer", $list,7, $errCode)

        let $tableHeaderMandatory := "Data that can be withheld due to confidentiality is: The type of waste treatment, the quantity, the method basis, the method used and any information about the recoverer/disposer. For the following waste transfers, one or more of these groups of data have been reported even though confidentiality was claimed:"
        let $errorPos := ( $xmlutil:COL_WH_Quantity , $xmlutil:COL_WH_WasteTreatmentCode, $xmlutil:COL_WH_MethodBasisCode, $xmlutil:COL_WH_Methods, $xmlutil:COL_WH_WasteHandlerName, $xmlutil:COL_WH_WasteHandlerAdress, $xmlutil:COL_WH_WasteHandlerSiteAdress)
        let $tableMandatory := xmlutil:buildTableWasteHandler($errLevel, "Confidential WasteTransfers with mandatory main data", $listMandatory, $errorPos,$errCode)


        return
            xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
            union
            xmlutil:buildMessageSection("", "", $tableHeaderMandatory, $tableMandatory)
    )
};


(:==================================================================:)
(:  Validations for reporting of Confidentiality                                                                       :)
(:==================================================================:)

(:Find FacilityReports claiming Confidentiality on facility level:)
(:Returns a list of FacilityReport elements:)
declare function xmlconv:findConfidentialFacilityReports($source_url){
    for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport[rsm:confidentialIndicator=true()]
        return $elems
};

(:Find PollutantReleases claiming Confidentiality:)
(:Returns a list of PollutantRelease elements:)
declare function xmlconv:findConfidentialPollutantReleases($source_url){
       for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantRelease[rsm:confidentialIndicator=true()]
        return $elems
};

(:Find PollutantTransfers claiming Confidentiality:)
(:Returns a list of PollutantTransfer elements:)
declare function xmlconv:findConfidentialPollutantTransfers($source_url){
       for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantTransfer[rsm:confidentialIndicator=true()]
        return $elems
};

(:Find WasteTransfers claiming Confidentiality:)
(:Returns a list of WasteTransfer elements:)
declare function xmlconv:findConfidentialWasteTransfers($source_url){
       for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:WasteTransfer[rsm:confidentialIndicator=true()]
        return $elems
};

(:==================================================================:)
(: Validations rules for reporting of mandatory data for confidential elements                          :)
(:==================================================================:)

(:Find confidential FacilityReports with reported mandatory data on facility level:)
(:Only data that can be kept confidential are examined (i.e. ParentCompanyName, FacilityName and address):)
(:Returns a list of FacilityReport elements
declare function xmlconv:findMandatoryDataConfidentialFacilityReport($source_url){
    for $elem in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport[rsm:confidentialIndicator=true() and (
                string-length(rsm:ParentCompanyName) >0
                or string-length(rsm:FacilityName) >0
                or string-length(rsm:Address/p:StreetName) >0
                or string-length(rsm:Address/p:CityName) >0
                or string-length(rsm:Address/p:PostcodeCode) >0
                )]

            return ($elem)
};:)


(:Find Confidential pollutant Releases with reported mandatory data.:)
(:Only data that can be kept Confidential (i.e. methods) are examined:)
(:Returns a list of PollutantRelease elements:)
declare function xmlconv:findMandatoryDataConfidentialPollutantRelease($source_url){
for $elem in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantRelease[rsm:confidentialIndicator=true() and (
        string-length(xmlutil:buildMethods(rsm:methodUsed)) > 0
        )]
        return ($elem)
};

(:Find Confidential pollutant Transfers with reported mandatory data.:)
(:Only data that can be kept Confidential (i.e. methods) are examined:)
(:Returns a list of PollutantTransfer elements:)
declare function xmlconv:findMandatoryDataConfidentialPollutantTransfer($source_url){
for $elem in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantTransfer[rsm:confidentialIndicator=true() and (
        string-length(xmlutil:buildMethods(rsm:methodUsed)) > 0
        )]
        return ($elem)
};


(:Find Confidential WasteTransfers with reported mandatory data. For waste of type HWOC the data of the wastehandler is examined too:)
(:Only data that can be kept Confidential  (i.e. WasteTreatmentCode, Quantity, methods and information about the wastehandler) are examined:)
(:Returns a list of WasteTransfer elements:)
declare function xmlconv:findMandatoryDataConfidentialWasteTransfer($source_url){
for $i in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:WasteTransfer[rsm:confidentialIndicator=true() and (
                string-length(rsm:wasteTreatmentCode) > 0
                or string-length(string(rsm:quantity)) > 0
                or string-length(xmlutil:buildMethods(rsm:methodUsed)) > 0
                or(rsm:WasteTypeCode = "HWOC" and xmlconv:findMandatoryDataWasteHandler(rsm:WasteHandlerParty))
                )]
            return ($i)
};

(: Find mandatory data for a waste handler. Return true if data are reported otherwise false:)
(:Only data that can be kept Confidential (i.e. all data) are examined:)
declare function xmlconv:findMandatoryDataWasteHandler($WasteHandler) as xs:boolean{

    (string-length($WasteHandler/rsm:name) > 0
    or string-length($WasteHandler/rsm:address/p:StreetName) > 0
    or string-length($WasteHandler/rsm:address/p:City) > 0
    or string-length($WasteHandler/rsm:address/p:PostalCode) > 0
    or string-length($WasteHandler/rsm:address/p:CountryID) > 0
    or string-length($WasteHandler/rsm:siteAddress/p:StreetName) > 0
    or string-length($WasteHandler/rsm:siteAddress/p:City) > 0
    or string-length($WasteHandler/rsm:siteAddress/p:PostalCode) > 0
    or string-length($WasteHandler/rsm:siteAddress/p:CountryID) > 0
    )
};

(:==================================================================:)
(: QA3: Confidentiality Claims sorted by Facility                                                                                                     :)
(:==================================================================:)
declare function xmlconv:ClaimingOfConfidentialityByFacility($source_url as xs:string) {
    let $FacilityConfidentiality :=  xmlconv:findFacilityConfidentiality($source_url)

    return
    <div>
        <h2><br /><a name='3'>3. Confidentiality claims sorted by facilities</a></h2>

        <p>Companies subjected to reporting or Competent Authorities in Member States can decide to classify parts of the mandatory data as confidential. This validation examines if confidentiality has been claimed and signals where by an X. </p>

        <p>The table below lists all cases where confidentiality is claimed for facility reports, pollutant releases, pollutant transfers and waste transfers respectively. </p>
        {
        if ($FacilityConfidentiality != "") then
            <div>
                <table border="1" style="font-size:11px;" class="datatable">
                <tr>
                    <th rowspan="2" width="5%">National ID</th>
                    
                    <th colspan="4" width="50%">(3) Confidentiality</th>
                </tr>
                <tr>
                   
                    <th with="12.5%">Facility Reports</th>
                    <th with="12.5%">Pollutant Release</th>
                    <th with="12.5%">Pollutant Transfer</th>
                    <th with="12.5%">Waste Transfer</th>
                </tr>
                {$FacilityConfidentiality}
                </table>
            </div>
        else
            xmlutil:buildDescription(3, "Confidentiality is not claimed in any facility.")
        }
    </div>
};
declare function  xmlconv:findFacilityConfidentiality($source_url){
          for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport
            let $National := $elems/rsm:InspireIdPRTR
            (:let $FacilityName := $elems/rsm:FacilityName
            let $FacilityCompany := $elems/rsm:ParentCompanyName
            let $FacilityCompetent := $elems/rsm:CompetentAuthorityPartyName
            let $FaclityStreet := string($elems/rsm:Address/rsm:StreetName)
            let $FacilityNumber := string($elems/rsm:Address/rsm:BuildingNumber)
            let $FacilityCity := string($elems/rsm:Address/rsm:CityName)
            let $FacilityCode := string($elems/rsm:Address/rsm:PostcodeCode)
            let $FacilityAddress := concat($FaclityStreet, " ", $FacilityNumber, " ", $FacilityCity, " ", $FacilityCode):)

            let $FacilityReportConfidentiality := xmlconv:facilityReportConfidentiality($elems)
            let $PollutantReleaseConfidentiality := xmlconv:pollutantReleaseConfidentiality($elems)
            let $PollutantTransferConfidentiality := xmlconv:pollutantTransferConfidentiality($elems)
            let $WasteTransferConfidentiality := xmlconv:wasteTransferConfidentiality($elems)


            return

                if ($FacilityReportConfidentiality != "" or $PollutantReleaseConfidentiality != "" or $PollutantTransferConfidentiality != "" or $WasteTransferConfidentiality != "") then
                    <tr>
                    <td>{$National}</td>
                    
                    <td style="color:blue;text-align:center">
                    {
                        if ($FacilityReportConfidentiality != "") then
                            <p>{xmlutil:buildErrorElement($xmlconv:errConfClaimsFacility, "X")}</p>
                        else (<p></p>)
                    }
                    </td>

                    <td style="color:blue">{$PollutantReleaseConfidentiality}</td>
                    <td style="color:blue">{$PollutantTransferConfidentiality}</td>
                    <td style="color:blue">{$WasteTransferConfidentiality}</td>

                    </tr>
                else
                    ()
};

declare function xmlconv:facilityReportConfidentiality($elems){
    let $confidentialFacilityReports := $elems[rsm:confidentialIndicator=true()]

    return
        $confidentialFacilityReports

};

declare function xmlconv:pollutantReleaseConfidentiality($elems){
    for $dato in $elems/rsm:PollutantRelease[rsm:confidentialIndicator=true()]

    return
        <li style="list-style-type:none"><b>{concat($dato/rsm:mediumCode, ' / ' , $dato/rsm:pollutantCode , ': ')} </b>{xmlutil:buildErrorElement($xmlconv:errConfClaimsFacility, "X")}</li>
};

declare function xmlconv:pollutantTransferConfidentiality($elems){
    for $dato in $elems/rsm:PollutantTransfer[rsm:confidentialIndicator=true()]

    return
        <li style="list-style-type:none"><b>{concat($dato/rsm:pollutantCode , ': ')} </b>{xmlutil:buildErrorElement($xmlconv:errConfClaimsFacility, "X")}</li>
};

declare function xmlconv:wasteTransferConfidentiality($elems){
    for $dato in $elems/rsm:WasteTransfer[rsm:confidentialIndicator=true()]

    return
        <li style="list-style-type:none"><b>{concat($dato/rsm:wasteTypeCode,' / ', $dato/rsm:wasteTreatmentCode , ': ')} </b>{xmlutil:buildErrorElement($xmlconv:errConfClaimsFacility, "X")}</li>
};

(:==================================================================:)
(: RULES                                                            :)
(:==================================================================:)

declare function xmlconv:getRules()
as element(rules)
{
  <rules>
    <rule code="{$xmlconv:errConfReasons}">
        <title>Check reporting of confidentiality reasons </title>
        <descr>This complementary validation examines if a reason is provided for claiming confidentiality. If confidentiality is not claimed mandatory fields have to be reported.</descr>
        <message></message>
        <errLevel>{$xmlutil:LEVEL_ERROR}</errLevel>
    </rule>
    <rule code="{$xmlconv:errConfClaims}">
        <title>Information about confidentiality claims</title>
        <descr>This validation examines if confidentiality has been claimed in any case and the validation returns information about reported values that could be withheld even though confidentiality was claimed.</descr>
        <message></message>
        <errLevel>{$xmlutil:LEVEL_INFO}</errLevel>
    </rule>
    <rule code="{$xmlconv:errConfClaimsFacility}">
        <title>Information about confidentiality claims sorted by facilities</title>
        <descr>This validation examines if confidentiality has been claimed for any facility and signals where by an <strong>X</strong>. </descr>
        <message></message>
        <errLevel>{$xmlutil:LEVEL_INFO}</errLevel>
    </rule>
  </rules>
};

(:==================================================================:)
(: Main function                                                                                                                :)
(:==================================================================:)

declare function xmlconv:proceed($source_url as xs:string)
as element(div){

    let $confidentialityResults := xmlconv:ConfidentialityReasons($source_url)
    let $confidentialityClaims := xmlconv:controlConfidentiality( $source_url)
    let $confidentialityClaimsByFacility := xmlconv:ClaimingOfConfidentialityByFacility($source_url)

    let $result := $confidentialityResults union $confidentialityClaims union $confidentialityClaimsByFacility
    let $errorCount := count($result//div[@errorcode = 1])
    let $infoCount := count($result//div[@errorcode > 1])

    let $errorLevel :=
        if ($errorCount = 0) then
            "INFO"
        else
            "ERROR"

    let $feedbackMessage :=
        if ($errorCount > 0) then
            concat($errorCount, ' error message', substring('s ', number(not($errorCount > 1)) * 2), 'generated')
        else if ($infoCount > 0) then
            concat($infoCount, ' info message', substring('s ', number(not($infoCount > 1)) * 2), 'generated')
        else
            "All tests were passed successfully."
    
    return
        <div class="feedbacktext">
            <span id="feedbackStatus" class="{$errorLevel}" style="display:none">{$feedbackMessage}</span>
            <h1>E-PRTR - Complementary Validation - Confidentiality </h1>
            <div style="font-size:13px;">
                <p>The following complementary validations are meant to help the Member States to check that the data reported are correct. The complementary validations will not prevent data from being stored in the database. More details on the validation rules are available in the validation manual at <a href="http://www.eionet.europa.eu/schemas/eprtr/">http://www.eionet.europa.eu/schemas/eprtr/</a></p>
                <p>Companies subject to reporting or competent authorities in the Member States can decide to classify parts of the mandatory data as confidential. The following 3 checks  examine if confidentiality has been claimed in any case and if mandatory data is reported correctly. Additionally they check which data are withhold.</p>
            </div>
            <ul>{
                xmlutil:buildRuleContentLinks($result//div[string-length(@errorcode) > 0]/@errorcode, xmlconv:getRules()//rule)
            }
            </ul>{
                $result
            }
        </div>

};

xmlconv:proceed( $source_url )