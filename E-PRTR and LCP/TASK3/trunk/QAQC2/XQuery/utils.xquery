(:  ======================================================================  :)
(:  =====      E-PRTR UTILITIES                                      =====  :)
(:  ======================================================================  :)
(:
    This XQuery module contains a number of utility functions to be used in E-PRTR XQueries.

    XQuery agency:  The European Commision
    XQuery version: 2.1
    XQuery date:    2008-12-11
    Revision:       $Revision: 11135 $
    Revision date:  $Date: 2012-01-19 19:25:21 +0200 (Thu, 19 Jan 2012) $
  :)

xquery version "1.0";

(:===================================================================:)
(: Namespace declaration                                             :)
(:===================================================================:)
module namespace xmlutil = "urn:eu:com:env:prtr:converter:standard:2";

declare namespace xsi="http://www.w3.org/2001/XMLSchema-instance";
declare namespace rsm="http://dd.eionet.europa.eu/schemas/LCPandPRTR";
declare namespace p="http://dd.eionet.europa.eu/schemas/LCPandPRTR/LCPandPRTRCommon";

(:==================================================================:)
(: Helper functions for writing output                              :)
(:==================================================================:)
declare variable $xmlutil:LEVEL_NONE as xs:integer := 0;
declare variable $xmlutil:LEVEL_ERROR as xs:integer := 1;
declare variable $xmlutil:LEVEL_WARNING as xs:integer := 2;
declare variable $xmlutil:LEVEL_INFO as xs:integer := 3;

declare variable $xmlutil:SOURCE_URL_PARAM as xs:string := 'source_url=';

(:Builds a summary bullet list for all rules with links:)
declare function xmlutil:buildRuleContentLinks($errCodes as xs:string*, $rules)
as element(li)*
{
    for $rule in $rules
    let $countErrors := count($errCodes[. = data($rule/@code)])
    return
        <li style="list-style-type:none">{ xmlutil:buildErrorBullet($countErrors, $rule) }<span style="padding-left:10px"><b>{ data($rule/@code) }.&#32; <a href="{concat('#',data($rule/@code))}"> { data($rule/title) }</a>:</b>&#32;{ data($rule/descr) }   &#32;{ xmlutil:getElemWithQuotes(data($rule/message)) } </span></li>
};

(:Builds a summary bullet list for all rules:)
declare function xmlutil:buildRuleContents($errCodes as xs:string*, $rules)
as element(li)*
{
    for $rule in $rules
    let $countErrors := count($errCodes[. = data($rule/@code)])
    return
        <li style="list-style-type:none">{ xmlutil:buildErrorBullet($countErrors, $rule) }<span style="padding-left:10px"><b>{ data($rule/@code) }.&#32;{ data($rule/title) }:</b>&#32;{ data($rule/descr) }&#32;&quot;{ data($rule/message) }&quot;. </span></li>
};

declare function xmlutil:buildErrorBullet($countErrors as xs:integer, $rule)
as element(span)
{
  let $ruleTitle := $rule/title
  let $errLevel := data($rule/errLevel)
  let $errCode := data($rule/@code)

  let $strErrType :=
    if($errLevel =  $xmlutil:LEVEL_ERROR) then "error"
    else if($errLevel =  $xmlutil:LEVEL_WARNING) then "warning"
    else if($errLevel =  $xmlutil:LEVEL_INFO) then "info message"
    else  "message"

    let $bulletTitle := if ($countErrors = 0) then
                            concat("No ", $strErrType ,"s within this type of rule - ", $ruleTitle)
                        else if ($countErrors = 1) then
                            concat("1 ", $strErrType ," within this type of rule - ", $ruleTitle)
                        else
                            concat($countErrors, " ", $strErrType ,"s within this type of rule - ", $ruleTitle)

    let $padding := if ($countErrors = 0) then "8" else if ($countErrors = 1) then "11.5" else if ($countErrors < 10) then "12" else if ($countErrors < 100) then "9" else "5"
    let $color := if ($countErrors = 0) then "green" else if ($errLevel = $xmlutil:LEVEL_ERROR) then "red" else if ($errLevel = $xmlutil:LEVEL_INFO)then "blue" else "orange"
    let $style := concat("background-color: ",$color,"; font-size: 0.8em; color: white; padding-left:", $padding ,"px;padding-right:",$padding ,"px;text-align:center")

    return
        if ( $errLevel > $xmlutil:LEVEL_NONE) then
            if ($countErrors = 0) then
            (
                <span style="{ $style }" title="{ $bulletTitle }">OK</span>
            )
            else if($errLevel =  $xmlutil:LEVEL_ERROR) then
            (
                <span style="{ $style }" title="{ $bulletTitle }" error="code:{ $errCode }">{ $countErrors }</span>
            )
            else if($errLevel =  $xmlutil:LEVEL_WARNING) then
            (
                <span style="{ $style }" title="{ $bulletTitle }" warning="code:{ $errCode }">{ $countErrors }</span>
            )
            else if($errLevel =  $xmlutil:LEVEL_INFO) then
            (
                <span style="{ $style }" title="{ $bulletTitle }" info="code:{ $errCode }">{ $countErrors }</span>
            )
            else
            (
                <span style="{ $style }" title="{ $bulletTitle }">{ $countErrors }</span>
            )
        else
            (<span style="background-color:blue;padding-left:12px;padding-right:12px; color: white;font-size: 0.8em" title="The test was skipped">1</span>)
};

(: Builds a section with a message that has a header, a number of descriptions given by description list and a table with a header above :)
declare function xmlutil:buildMessageSection($header, $description, $tableHeader, $table){
    if(exists($table)) then
    (
      <div>

        {xmlutil:buildSubHeader($header)}

        {
            for $d in $description return xmlutil:buildDescription($d)
        }

        {xmlutil:buildDescription($tableHeader)}
        {$table}
      </div>
    )
    else ()
};

(: Builds a table marked with error given :)
declare function xmlutil:buildTable($errLevel as xs:integer, $error as xs:string, $colHeaders, $tableRows ){
   xmlutil:buildTableWithHeaderRows($errLevel, $error, xmlutil:buildTableHeaderRow($colHeaders), $tableRows )
};

declare function xmlutil:buildTableWithHeaderRows($errLevel as xs:integer, $error as xs:string, $headerRows, $tableRows ){
    if (exists($tableRows)) then
    (
        if($errLevel = $xmlutil:LEVEL_ERROR) then
        (
            <table border="1" class="datatable" error="{$error}" style="font-size:11px;">
                {$headerRows}
                {$tableRows}
            </table>
        )
        else if ($errLevel = $xmlutil:LEVEL_WARNING) then
        (
            <table border="1" class="datatable" warning="{$error}" style="font-size:11px;">
                {$headerRows}
                {$tableRows}
            </table>
        )
        else
        (
            <table border="1" class="datatable" style="font-size:11px;">
                {$headerRows}
                {$tableRows}
            </table>
        )
    )
    else ()
};

(: Gets the color corresponding to an error level :)
declare function xmlutil:getErrorColor($errLevel as xs:integer) as xs:string {
    if ($errLevel = $xmlutil:LEVEL_ERROR) then
        "red"
    else if ($errLevel = $xmlutil:LEVEL_WARNING) then
        "blue"
    else if ($errLevel = $xmlutil:LEVEL_INFO) then
        "blue"
    else
        ""
};

(: Builds a table header row from a list of colum headers :)
declare function xmlutil:buildTableHeaderRow($colHeaders){
    <tr align="center">
    {
        for $ch in $colHeaders
            return <th> {$ch} </th>
    }
    </tr>
};
(: Builds a table header row from a list of colum headers :)
declare function xmlutil:buildSuccessfulMessage()
as element(p){
    <p style="color:blue;font-size:1em;">The validation passed successfully</p>
};

(: Builds a table row from a list of colum data. Data in colum with postion in list of errorPos will be marked :)
declare function xmlutil:buildTableRow($colData, $errLevel as xs:integer, $errorPos){
    xmlutil:buildTableRow($colData, $errLevel, $errorPos, '')
};

(: Builds a table row from a list of colum data. Data in colum with postion in list of errorPos will be marked :)
declare function xmlutil:buildTableRow($colData, $errLevel as xs:integer, $errorPos, $errorCode as xs:string){
    <tr>
    {
    (:
        let $color := xmlutil:getErrorColor($errLevel)
        :)
        let $hasColor as xs:boolean := string-length(xmlutil:getErrorColor($errLevel))>0

        for $cd at $pos  in $colData
        let $hasError := index-of($errorPos, $pos)>0

        return
            if($hasError) then
                if ($hasColor) then
                    (
                    <td style="color:{xmlutil:getErrorColor($errLevel)}">{xmlutil:buildErrorElement($errorCode, $cd) }</td>
                    )
                else
                    (
                    <td>{xmlutil:buildErrorElement($errorCode, $cd) }</td>
                    )
            else
            (
                <td> {xmlutil:buildString($cd) }</td>
            )
    }
    </tr>
};

declare function xmlutil:buildErrorElement($errCode as xs:string, $colData){
    if ($errCode != '') then
        <div errorcode="{$errCode}">{xmlutil:buildString($colData)}</div>
    else
        xmlutil:buildString($colData)
};

(:
Colours red and counts as an error if content is not empty
:)
declare function xmlutil:buildErrorElementNotEmpty($errCode as xs:string, $colData){
    if ($errCode != '' and normalize-space($colData) != '') then
        <div errorcode="{$errCode}">{$colData}</div>
    else
        ""
};

(: Builds a table row from a list of colum data. No data colum will be marked :)
declare function xmlutil:buildTableRow($colData){
    xmlutil:buildTableRow($colData, 0, 0)
};

(: If the string given is empty a default string is returned. Otherwise the string itself is returned :)
declare function xmlutil:buildString($var) as xs:string{
    let $str:= string($var)
    return
    if(string-length($str)>0) then
        $str
    else
        string("-Not reported-")
};

(: Builds a subheader :)
declare function xmlutil:buildSubHeader($header as xs:string){
    if(string-length($header)>0) then
    (
        <h3>{$header}</h3>
    )
    else ()
};

(: Builds a description text with color corresponding to the error level given :)
declare function xmlutil:buildDescription($errLevel as xs:integer, $descr as xs:string){
    let $color := xmlutil:getErrorColor($errLevel)
    let $hasColor as xs:boolean := string-length($color) > 0

    return
        if(string-length($descr)>0) then
        (
            if($hasColor) then
            (
                <p style="color:{$color}">{$descr}</p>
            )
            else
            (
                <p>{$descr}</p>
            )
        )
        else ()
};

(: Builds a description text with no special color :)
declare function xmlutil:buildDescription($descr as xs:string){
    xmlutil:buildDescription($xmlutil:LEVEL_NONE, $descr)
};

(: Builds a description of which file is validated :)
declare function xmlutil:buildValidatedFile($source_url){
    if (string-length($source_url) > 0) then
    (
        <p><b>Validated XML file: </b> {xmlutil:getCleanUrl($source_url)}</p>
    )
    else ()
};

(:===================================================================:)
(: Functions for building basic output tables for different elements :)
(:===================================================================:)

declare function xmlutil:buildTablePlantReport($type as xs:integer, $error as xs:string, $elems, $errorIndex){
    xmlutil:buildTablePlantReport($type, $error, $elems, $errorIndex, '')
};

declare function xmlutil:buildTablePlantReport($type as xs:integer, $error as xs:string, $elems, $errorIndex, $errorCode as xs:string){
    let $colHeaders := ("National ID")
    let $tableRows := (for $elem in $elems
                            return xmlutil:buildTableRow(( xmlutil:getElem($elem/rsm:dBPlantId)
                                                         (:, xmlutil:getElem($elem/rsm:FacilityName)
                                                         , xmlutil:getElem($elem/rsm:ParentCompanyName)
                                                           :)),$type, $errorIndex, $errorCode))

    return  xmlutil:buildTable($type, $error, $colHeaders, $tableRows)
};

(: Builds a table from a list of facilityReport elements. Data in colum with number given by errorIndex will be marked :)
declare variable $xmlutil:COL_FR_NationalID as xs:integer := 1;
declare variable $xmlutil:COL_FR_FacilityName as xs:integer := 2;
declare variable $xmlutil:COL_FR_ParentCompanyName as xs:integer := 3;
declare variable $xmlutil:COL_FR_Address as xs:integer := 4;
declare variable $xmlutil:COL_FR_ConfidentialCode as xs:integer := 6;
declare variable $xmlutil:COL_FR_Authority as xs:integer := 7;

declare function xmlutil:buildTableFacilityReport($type as xs:integer, $error as xs:string, $elems, $errorIndex){
    xmlutil:buildTableFacilityReport($type, $error, $elems, $errorIndex, '')
};

declare function xmlutil:buildTableFacilityReport($type as xs:integer, $error as xs:string, $elems, $errorIndex, $errorCode as xs:string){
    let $colHeaders := ("National ID")
    let $tableRows := (for $elem in $elems
                            return xmlutil:buildTableRow(( xmlutil:getElem($elem/rsm:dBFacitilyID)
                                                         (:, xmlutil:getElem($elem/rsm:FacilityName)
                                                         , xmlutil:getElem($elem/rsm:ParentCompanyName)
                                                         , xmlutil:buildAddress($elem/rsm:Address)
                                                         , xmlutil:buildYesNo($elem/rsm:confidentialIndicator)
                                                         , xmlutil:getElem($elem/rsm:confidentialCode)
                                                         , xmlutil:getElem($elem/rsm:CompetentAuthorityPartyName):)),$type, $errorIndex, $errorCode))

    return  xmlutil:buildTable($type, $error, $colHeaders, $tableRows)
};

(: Build a table of facility reports with main data :)
declare variable $xmlutil:COL_FRM_NationalID as xs:integer := 1;
declare variable $xmlutil:COL_FRM_FacilityName as xs:integer := 2;
declare variable $xmlutil:COL_FRM_ParentCompanyName as xs:integer := 3;
declare variable $xmlutil:COL_FRM_Address as xs:integer := 4;
declare variable $xmlutil:COL_FRM_Longitude as xs:integer := 5;
declare variable $xmlutil:COL_FRM_Latitude as xs:integer := 6;
declare variable $xmlutil:COL_FRM_WebSite as xs:integer := 7;
declare function xmlutil:buildTableFacilityReportMain($type as xs:integer, $error as xs:string, $elems, $errorIndex){
    xmlutil:buildTableFacilityReportMain($type, $error, $elems, $errorIndex, '')
};
declare function xmlutil:buildTableFacilityReportMain($type as xs:integer, $error as xs:string, $elems, $errorIndex, $errorCode as xs:string){
    let $colHeaders := ("National ID", "Facility name", "Parent company", "Address", "Longitude", "Latitude", "Web site", "Confidential")
    let $tableRows := (for $elem in $elems
                            return xmlutil:buildTableRow(( xmlutil:getElem($elem/rsm:LCPandPRTR/rsmFacilityReports/rsm:FacilityReport/rsm:dBFacitilyID)
                                                         , xmlutil:getElem($elem/rsm:FacilityName)
                                                         , xmlutil:getElem($elem/rsm:ParentCompanyName)
                                                         , xmlutil:buildAddress($elem/rsm:Address)
                                                         , string($elem/rsm:GeographicalCoordinate/rsm:LongitudeMeasure)
                                                         , string($elem/rsm:GeographicalCoordinate/rsm:LatitudeMeasure)
                                                         , xmlutil:getElem($elem/rsm:WebsiteCommunication/rsm:WebsiteURIID)
                                                         , xmlutil:buildYesNo($elem/rsm:ConfidentialIndicator)), $type, $errorIndex, $errorCode))

    return  xmlutil:buildTable($type, $error, $colHeaders, $tableRows)
};

(: Builds a table from a list of activity elements. Data in colum with number given by errorIndex will be marked :)
declare variable $xmlutil:COL_A_NationalID as xs:integer := 1;
declare variable $xmlutil:COL_A_Ranking as xs:integer := 2;
declare variable $xmlutil:COL_A_Code as xs:integer := 3;
declare function xmlutil:buildTableActivity($type as xs:integer, $error as xs:string, $elems, $errorIndex){
    xmlutil:buildTableActivity($type, $error, $elems, $errorIndex, '')
};
declare function xmlutil:buildTableActivity($type as xs:integer, $error as xs:string, $elems, $errorIndex, $errorCode as xs:string){
    let $colHeaders := ("Facility", "Ranking", "E-PRTR code")
    let $tableRows := (for $elem in $elems
                            return xmlutil:buildTableRow(( xmlutil:getElem($elem/../rsm:NationalID)
                                                         , xmlutil:getElem($elem/rsm:RankingNumeric)
                                                         , xmlutil:getElem($elem/rsm:AnnexIActivityCode)), $type, $errorIndex, $errorCode))

    return  xmlutil:buildTable($type, $error, $colHeaders, $tableRows)
};

(: Builds a table from a list of pollutantRelease elements. Data in colum with number given by errorIndex will be marked :)
declare variable $xmlutil:COL_PR_MediumCode as xs:integer := 2;
declare variable $xmlutil:COL_PR_PollutantCode as xs:integer := 3;
declare variable $xmlutil:COL_PR_MethodBasisCode as xs:integer := 4;
declare variable $xmlutil:COL_PR_Methods as xs:integer := 5;
declare variable $xmlutil:COL_PR_TotalQuantity as xs:integer := 6;
declare variable $xmlutil:COL_PR_AccQuantity as xs:integer := 7;
declare variable $xmlutil:COL_PR_ConfidentialCode as xs:integer := 9;

declare function xmlutil:buildTablePollutantRelease($type as xs:integer, $error as xs:string, $elems, $errorIndex){
    xmlutil:buildTablePollutantRelease($type, $error, $elems, $errorIndex, '')
};
declare function xmlutil:buildTablePollutantRelease($type as xs:integer, $error as xs:string, $elems, $errorIndex, $errorCode as xs:string){
    let $colHeaders := ("Facility", "Medium", "Pollutant", "Method basis", "Method(s)", "Tot. quantity", "Acc. quantity", "Confidential", "Reason for conf.")
    let $tableRows := (for $elem in $elems
                                return xmlutil:buildTableRow((xmlutil:getElem($elem/../rsm:dBFacitilyID), xmlutil:getElem($elem/rsm:mediumCode), xmlutil:getElem($elem/rsm:pollutantCode),xmlutil:getElem($elem/rsm:methodBasisCode), xmlutil:buildMethods($elem/rsm:methodUsed), string($elem/rsm:totalQuantity), string($elem/rsm:accidentalQuantity), xmlutil:buildYesNo($elem/rsm:confidentialIndicator), xmlutil:getElem($elem/rsm:confidentialCode)), $type,  $errorIndex, $errorCode))

    return  xmlutil:buildTable($type, $error, $colHeaders, $tableRows)
};

(: Builds a table from a list of  pollutantTransfer elements. Data in colum with number given by errorIndex will be marked :)
declare variable $xmlutil:COL_PT_PollutantCode as xs:integer := 2;
declare variable $xmlutil:COL_PT_MethodBasisCode as xs:integer := 3;
declare variable $xmlutil:COL_PT_Methods as xs:integer := 4;
declare variable $xmlutil:COL_PT_Quantity as xs:integer := 5;
declare variable $xmlutil:COL_PT_ConfidentialCode as xs:integer := 7;
declare function xmlutil:buildTablePollutantTransfer($type as xs:integer, $error as xs:string, $elems, $errorIndex) {
        xmlutil:buildTablePollutantTransfer($type, $error, $elems, $errorIndex, '')
};
declare function xmlutil:buildTablePollutantTransfer($type as xs:integer, $error as xs:string, $elems, $errorIndex, $errorCode as xs:string){
    let $colHeaders := ("Facility", "Pollutant", "Method basis", "Method(s)", "Quantity",  "Confidential", "Reason for conf.")
    let $tableRows := (for $elem in $elems
                            return xmlutil:buildTableRow(( xmlutil:getElem($elem/../rsm:dBFacitilyID)
                                                         , xmlutil:getElem($elem/rsm:pollutantCode)
                                                         , xmlutil:getElem($elem/rsm:methodBasisCode)
                                                         , xmlutil:buildMethods($elem/rsm:MethodUsed)
                                                         , string($elem/rsm:quantity)
                                                         , xmlutil:buildYesNo($elem/rsm:confidentialIndicator)
                                                         , xmlutil:getElem($elem/rsm:confidentialCode)), $type, $errorIndex, $errorCode))

    return xmlutil:buildTable($type, $error, $colHeaders, $tableRows)
};

(: Builds a table from a list of wasteTransfer elements. Data in colum with number given by errorIndex will be marked :)
declare variable $xmlutil:COL_WT_WasteTypeCode as xs:integer := 2;
declare variable $xmlutil:COL_WT_Quantity as xs:integer := 3;
declare variable $xmlutil:COL_WT_WasteTreatmentCode as xs:integer := 4;
declare variable $xmlutil:COL_WT_MethodBasisCode as xs:integer := 5;
declare variable $xmlutil:COL_WT_Methods as xs:integer := 6;
declare variable $xmlutil:COL_WT_ConfidentialCode as xs:integer := 8;

declare function xmlutil:buildTableWasteTransfer($type as xs:integer, $error as xs:string, $elems, $errorIndex){
    xmlutil:buildTableWasteTransfer($type, $error, $elems, $errorIndex, '')
};

declare function xmlutil:buildTableWasteTransfer($type as xs:integer, $error as xs:string, $elems, $errorIndex, $errorCode as xs:string){
    let $colHeaders := ("Facility", "Waste type", "Quantity", "Waste treatment", "Method Basis", "Method(s)",  "Confidential", "Reason for conf.")
    let $tableRows := (for $elem in $elems
                            return xmlutil:buildTableRow(( xmlutil:getElem($elem/../rsm:dBFacitilyID)
                                                         , xmlutil:getElem($elem/rsm:wasteTypeCode)
                                                         , string($elem/rsm:quantity)
                                                         , xmlutil:getElem($elem/rsm:wasteTreatmentCode)
                                                         , xmlutil:getElem($elem/rsm:methodBasisCode)
                                                         , xmlutil:buildMethods($elem/rsm:methodUsed)
                                                         , xmlutil:buildYesNo($elem/rsm:confidentialIndicator)
                                                         , xmlutil:getElem($elem/rsm:confidentialCode)), $type, $errorIndex, $errorCode))

    return xmlutil:buildTable($type, $error, $colHeaders, $tableRows)
};

(: Builds a table from a list of wasteTransfer elements. Includes yes/no-colum about wastehandler. Data in colum with number given by errorIndex will be marked. :)
declare variable $xmlutil:COL_WT_WasteHandler as xs:integer := 9;

declare function xmlutil:buildTableWasteTransferWH($type as xs:integer, $error as xs:string, $elems, $errorIndex){
    xmlutil:buildTableWasteTransferWH($type, $error, $elems, $errorIndex, '')
};

declare function xmlutil:buildTableWasteTransferWH($type as xs:integer, $error as xs:string, $elems, $errorIndex, $errorCode as xs:string){
    let $colHeaders := ("Facility", "Waste type", "Quantity", "Waste treatment", "Method Basis", "Method(s)",  "Confidential", "Reason for conf.", "Recoverer/disposer")
    let $tableRows := (for $elem in $elems
                            return xmlutil:buildTableRow(( xmlutil:getElem($elem/../rsm:NationalID)
                                                         , xmlutil:getElem($elem/rsm:WasteTypeCode)
                                                         , string($elem/rsm:Quantity)
                                                         , xmlutil:getElem($elem/rsm:WasteTreatmentCode)
                                                         , xmlutil:getElem($elem/rsm:MethodBasisCode)
                                                         , xmlutil:buildMethods($elem/rsm:MethodUsed)
                                                         , xmlutil:buildYesNo($elem/rsm:ConfidentialIndicator)
                                                         , xmlutil:getElem($elem/rsm:ConfidentialCode)
                                                         , xmlutil:buildYesNo(count($elem/rsm:WasteHandlerParty)>0)), $type, $errorIndex ))

    return xmlutil:buildTable($type, $error, $colHeaders, $tableRows)
};


(: Builds a table with wastehandlers from a list of wasteTransfer elements. Data in colum with number given by errorIndex will be marked :)
declare variable $xmlutil:COL_WH_WasteTypeCode as xs:integer := 2;
declare variable $xmlutil:COL_WH_Quantity as xs:integer := 3;
declare variable $xmlutil:COL_WH_WasteTreatmentCode as xs:integer := 4;
declare variable $xmlutil:COL_WH_MethodBasisCode as xs:integer := 5;
declare variable $xmlutil:COL_WH_Methods as xs:integer := 6;
declare variable $xmlutil:COL_WH_WasteHandlerName as xs:integer := 8;
declare variable $xmlutil:COL_WH_WasteHandlerAdress as xs:integer := 9;
declare variable $xmlutil:COL_WH_WasteHandlerSiteAdress as xs:integer := 10;

declare function xmlutil:buildTableWasteHandler($type as xs:integer, $error as xs:string, $elems, $errorIndex){
    xmlutil:buildTableWasteHandler($type, $error, $elems, $errorIndex, '')
};
declare function xmlutil:buildTableWasteHandler($type as xs:integer, $error as xs:string, $elems, $errorIndex, $errorCode as xs:string){
    let $colHeaders := ("Facility", "Waste type", "Quantity", "Waste treatment", "Method Basis", "Method(s)",  "Confidential", "Name of recoverer/disposer", "Address of recoverer/disposer", "Address of actual recoverer/disposer")
    let $tableRows := (for $elem in $elems
                            return xmlutil:buildTableRow(( xmlutil:getElem($elem/../rsm:dBFacitilyID)
                                                         , xmlutil:getElem($elem/rsm:wasteTypeCode)
                                                         , string($elem/rsm:quantity)
                                                         , xmlutil:getElem($elem/rsm:wasteTreatmentCode)
                                                         , xmlutil:getElem($elem/rsm:methodBasisCode)
                                                         , xmlutil:buildMethods($elem/rsm:methodUsed)
                                                         , xmlutil:buildYesNo($elem/rsm:confidentialIndicator)
                                                         , xmlutil:buildWasteHandlerInfo($elem/rsm:WasteHandlerParty)), $type,  $errorIndex, $errorCode))

    return xmlutil:buildTable($type, $error, $colHeaders, $tableRows)
};


(: Build a list with wastehandlerinfo: name, address and siteAddress :)
declare function xmlutil:buildWasteHandlerInfo($wasteHandler){
    if(exists($wasteHandler)) then
    (
        let $name := xmlutil:getElem($wasteHandler/rsm:name)
        let $address := xmlutil:buildAddress($wasteHandler/rsm:address)
        let $siteAddress := xmlutil:buildAddress($wasteHandler/rsm:siteAddress)

        return ($name, $address, $siteAddress)
    )
    else
    (
        ("","","")
    )
};

(: Builds a combined string with all methods in list :)
declare function xmlutil:buildMethods($methodsUsed){
    let $s := (for $m in $methodsUsed
                    return if(string-length($m/rsm:MethodTypeCode)>0 and string-length($m/rsm:Designation)>0) then
                                concat ($m/rsm:MethodTypeCode, " - ", $m/rsm:Designation)
                            else if (string-length($m/rsm:MethodTypeCode)>0) then
                                ($m/rsm:MethodTypeCode)
                            else ($m/rsm:Designation))

    return if (exists($methodsUsed)) then string-join($s, "; ") else ("")

};

(: Builds a table with methods for pollutantReleases from a list of MethodUsed elements. Data in colum with number given by errorIndex will be marked :)
declare variable $xmlutil:COL_M_PR_MediumCode as xs:integer := 2;
declare variable $xmlutil:COL_M_PR_PollutantCode as xs:integer := 3;
declare variable $xmlutil:COL_M_PR_MethodBasisCode as xs:integer := 4;
declare variable $xmlutil:COL_M_PR_MethodTypeCode as xs:integer := 5;
declare variable $xmlutil:COL_M_PR_Designation as xs:integer := 6;
declare function xmlutil:buildTableMethodsPollutantRelease($type as xs:integer, $error as xs:string, $elems, $errorIndex){
    xmlutil:buildTableMethodsPollutantRelease($type, $error, $elems, $errorIndex, '')
};
declare function xmlutil:buildTableMethodsPollutantRelease($type as xs:integer, $error as xs:string, $elems, $errorIndex, $errorCode as xs:string){
    let $colHeaders := ("Facility", "Medium", "Pollutant", "Method basis", "Method type", "Designation")
    let $tableRows := (for $elem in $elems
                            return xmlutil:buildTableRow(( xmlutil:getElem($elem/../../rsm:NationalID)
                                                         , xmlutil:getElem($elem/../rsm:MediumCode)
                                                         , xmlutil:getElem($elem/../rsm:PollutantCode)
                                                         , xmlutil:getElem($elem/../rsm:MethodBasisCode)
                                                         , xmlutil:getElem($elem/rsm:MethodTypeCode)
                                                         , xmlutil:getElem($elem/rsm:Designation)), $type,  $errorIndex, $errorCode))

    return  xmlutil:buildTable($type, $error, $colHeaders, $tableRows)
};

(: Builds a table with methods for pollutantTransfers from a list of methodTypeCode elements. Data in colum with number given by errorIndex will be marked :)
declare variable $xmlutil:COL_M_PT_PollutantCode as xs:integer := 2;
declare variable $xmlutil:COL_M_PT_MethodBasisCode as xs:integer := 3;
declare variable $xmlutil:COL_M_PT_MethodTypeCode as xs:integer := 4;
declare variable $xmlutil:COL_M_PT_Designation as xs:integer := 5;

declare function xmlutil:buildTableMethodsPollutantTransfer($type as xs:integer, $error as xs:string, $elems, $errorIndex){
    xmlutil:buildTableMethodsPollutantTransfer($type, $error, $elems, $errorIndex, '')
};

declare function xmlutil:buildTableMethodsPollutantTransfer($type as xs:integer, $error as xs:string, $elems, $errorIndex, $errorCode as xs:string){
    let $colHeaders := ("Facility", "Pollutant", "Method basis", "Method type", "Designation")
    let $tableRows := (for $elem in $elems
                            return xmlutil:buildTableRow(( xmlutil:getElem($elem/../../rsm:dBFacitilyID)
                                                         , xmlutil:getElem($elem/../rsm:pollutantCode)
                                                         , xmlutil:getElem($elem/../rsm:MethodBasisCode)
                                                         , xmlutil:getElem($elem/rsm:MethodTypeCode)
                                                         , xmlutil:getElem($elem/rsm:Designation)), $type,  $errorIndex, $errorCode))

    return  xmlutil:buildTable($type, $error, $colHeaders, $tableRows)
};

(: Builds a table with methods for wasteTransfers from a list of methodTypeCode elements. Data in colum with number given by errorIndex will be marked :)
declare variable $xmlutil:COL_M_WT_WasteTypeCode as xs:integer := 2;
declare variable $xmlutil:COL_M_WT_WasteTreatmentCode as xs:integer := 3;
declare variable $xmlutil:COL_M_WT_MethodBasisCode as xs:integer := 4;
declare variable $xmlutil:COL_M_WT_MethodTypeCode as xs:integer := 5;
declare variable $xmlutil:COL_M_WT_Designation as xs:integer := 6;
declare function xmlutil:buildTableMethodsWasteTransfer($type as xs:integer, $error as xs:string, $elems, $errorIndex){
    xmlutil:buildTableMethodsWasteTransfer($type, $error, $elems, $errorIndex,'')
};
declare function xmlutil:buildTableMethodsWasteTransfer($type as xs:integer, $error as xs:string, $elems, $errorIndex, $errorCode as xs:string){
    let $colHeaders := ("Facility", "Waste type", "Waste treatment", "Method Basis", "Method type", "Designation")
    let $tableRows := (for $elem in $elems
                            return xmlutil:buildTableRow(( xmlutil:getElem($elem/../../rsm:NationalID)
                                                         , xmlutil:getElem($elem/../rsm:WasteTypeCode)
                                                         , xmlutil:getElem($elem/../rsm:WasteTreatmentCode)
                                                         , xmlutil:getElem($elem/../rsm:MethodBasisCode)
                                                         , xmlutil:getElem($elem/rsm:MethodTypeCode)
                                                         , xmlutil:getElem($elem/rsm:Designation)), $type,  $errorIndex, $errorCode ))

    return xmlutil:buildTable($type, $error, $colHeaders, $tableRows)
};

(: Builds a table with competentAuthorities from a list of competentAuthority elements. Data in colum with number given by errorIndex will be marked :)
declare variable $xmlutil:COL_CA_Name as xs:integer := 1;
declare variable $xmlutil:COL_CA_Address as xs:integer := 2;
declare variable $xmlutil:COL_CA_Phone as xs:integer := 3;
declare variable $xmlutil:COL_CA_Fax as xs:integer := 4;
declare variable $xmlutil:COL_CA_Email as xs:integer := 5;
declare variable $xmlutil:COL_CA_Contact as xs:integer := 6;

declare function xmlutil:buildTableCompetentAuthority($type as xs:integer, $error as xs:string, $elems, $errorIndex){
    xmlutil:buildTableCompetentAuthority($type, $error, $elems, $errorIndex, '')
};

declare function xmlutil:buildTableCompetentAuthority($type as xs:integer, $error as xs:string, $elems, $errorIndex, $errorCode as xs:string){
    let $colHeaders := ("Name", "Address", "Telephone No", "Fax No", "E-mail", "Contact person")
    let $tableRows := (for $elem in $elems
                            return xmlutil:buildTableRow(( xmlutil:getElem($elem/rsm:name)
                                                         , xmlutil:buildAddress($elem/rsm:address)
                                                         , xmlutil:getElem($elem/rsm:TelephoneCommunication/rsm:CompleteNumberText)
                                                         , xmlutil:getElem($elem/rsm:FaxCommunication/rsm:CompleteNumberText)
                                                         , xmlutil:getElem($elem/rsm:EmailCommunication/rsm:EmailURIID)
                                                         , xmlutil:getElem($elem/rsm:ContactPersonName)), $type,  $errorIndex, $errorCode))

    return xmlutil:buildTable($type, $error, $colHeaders, $tableRows)
};

(: Builds a combined string with the address :)
declare function xmlutil:buildAddress($Address) as xs:string{
    let $StreetName := $Address/p:StreetName
    let $BuildingNumber := $Address/p:BuildingNumber
    let $CityName := $Address/p:City
    let $PostcodeCode := $Address/p:PostcodeCode
    let $CountryID := $Address/p:CountryID

    (:Concatenate streetname and building number, if non-empty:)
    let $StreetAddress :=
        if(string-length(string($StreetName))>0 and string-length(string($BuildingNumber))>0) then
        (
            concat($StreetName, " " , $BuildingNumber)
        )
        else if(string-length(string($StreetName))>0) then
        (
            string ($StreetName)
        )
        else if(string-length(string($BuildingNumber))>0) then
        (
            string ($BuildingNumber)
        )
        else
        (
            ""
        )

    (:Concatenate address, sepearate by comma. Only include non-empty elements in concatenation:)
    let $s1 := ()
    let $s2 := if(string-length(string($CountryID)) =0) then ($s1) else (insert-before($s1, 0, $CountryID))
    let $s3 := if(string-length(string($PostcodeCode)) = 0) then ($s2) else (insert-before($s2, 0, $PostcodeCode))
    let $s4 := if(string-length(string($CityName)) = 0) then ($s3) else (insert-before($s3, 0, $CityName))
    let $s5 := if(string-length(string($StreetAddress)) =0) then ($s4) else (insert-before($s4, 0, $StreetAddress))

    return string-join($s5, ", ")
};


(: Returns "yes" if i>0 otherwise "no" :)
declare function xmlutil:buildYesNo($i (:as xs:boolean:)) as xs:string{
    if(empty($i)) then
        ""
    else if($i=true()) then
        string("Yes")
    else
        string("No")
};

(: If the element does not exists an empty string will be returned, otherwise the element will be returned :)
declare function xmlutil:getElem($elem){
    if(exists($elem)) then
        $elem
    else ("")
};

(:~
 : Get the cleaned URL without authorisation info
 : @param $url URL of the source XML file
 : @return String
 :)
declare function xmlutil:getCleanUrl($url)
as xs:string
{
    if ( contains($url, $xmlutil:SOURCE_URL_PARAM)) then
        fn:substring-after($url, $xmlutil:SOURCE_URL_PARAM)
    else
        $url
};


 (:
 : returns string surrounded with quotes if not empty
 : otherwise returns emtpy string
 :)
 declare function xmlutil:getElemWithQuotes($txt) {
    if ($txt!='') then
       concat('"', $txt, '"')
    else
        $txt
 };

 (:~
 : Function removes the file part from the end of URL and appends 'xml' for getting the envelope xml description.
 : @param $url XML File URL.
 : @return Envelope XML URL.
 :)
declare function xmlutil:getEnvelopeXML($url as xs:string)
as xs:string
 {
    let $col := fn:tokenize($url,'/')
    let $col := fn:remove($col, fn:count($col))
    let $ret := fn:string-join($col,'/')
    let $ret := fn:concat($ret,'/xml')
    return
        if (fn:doc-available($ret)) then
            $ret
        else
             ""
};

(:~
 : Function reads year from envelope xml. Returns empty string if envelope XML not found.
 : @param $url XML file URL.
 : @return envelope year.
 :)
declare function xmlutil:getEnvelopeYear($url as xs:string)
as xs:string
{
    let $envelopeUrl := xmlutil:getEnvelopeXML($url)
    let $year := if(string-length($envelopeUrl)>0) then fn:doc($envelopeUrl)/envelope/year else ""
    return
        $year
};


(:~
: Returns true if given url is a local file
: @param $url URl
:)
declare function xmlutil:isLocalFile($url as xs:string)
as xs:boolean
{
    not(starts-with($url, 'http://'))
};
(:~
 : Checks if element value is empty or not.
 : @param $value Element value.
 : @return Boolean value.
 :)
declare function xmlutil:isEmpty($value as xs:string)
as xs:boolean
{
     if (fn:empty($value) or fn:string(fn:normalize-space($value)) = "") then
         fn:true()
    else
        fn:false()
};
(:~
 : Checks if XML element is missing or not.
 : @param $node XML node
 : return Boolean value.
 :)
declare function xmlutil:isMissing($node as node()*)
as xs:boolean
{
    if (fn:count($node) = 0) then
         fn:true()
    else
        fn:false()
};
(:~
 : Checks if XML element is missing or value is empty.
 : @param $node XML element or value
 : return Boolean value.
 :)
declare function xmlutil:isMissingOrEmpty($node as item()*)
as xs:boolean
{
    if (xmlutil:isMissing($node)) then
        fn:true()
    else
        xmlutil:isEmpty(string-join($node, ""))
};