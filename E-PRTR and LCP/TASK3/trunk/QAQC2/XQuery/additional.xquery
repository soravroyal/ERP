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
import module namespace xmlutil = "urn:eu:com:env:prtr:converter:standard:2" at "http://converterstest.eionet.europa.eu/queries/LCPandPRTR_utils.xquery";

declare namespace xmlconv="urn:eu:com:env:prtr:converter:standard:2";
declare namespace xsi="http://www.w3.org/2001/XMLSchema-instance";
declare namespace rsm="http://dd.eionet.europa.eu/schemas/LCPandPRTR";

(:===================================================================:)
(: Variable given as an external parameter by the QA service                                                 :)
(:===================================================================:)
(:
declare variable $source_url as xs:string := "TestData/EPRTR-IE2008.xml";
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
(:                          Standard Variables                           :)
(:To execute Xqueries with an Xquery engine uncomment the following lines:)
(:=======================================================================:)

(::)
declare variable $source_url as xs:string external;


(:===================================================================:)
(: Code lists:)
(:===================================================================:)
declare variable $wUrl as xs:string := "http://converters.eionet.europa.eu/xmlfile/EPRTR_WasteThreshold_1.xml";
declare variable $pUrl as xs:string := "http://converters.eionet.europa.eu/xmlfile/EPRTR_PollutantThreshold_2.xml";
declare variable $pcUrl as xs:string := "http://converters.eionet.europa.eu/xmlfile/EPRTR_PollutantCode_2.xml";

(: Error codes :)
declare variable $xmlconv:errFacilityReports := "1";
declare variable $xmlconv:errThresholds := "2";
declare variable $xmlconv:errThresholdsOnly := "3";
declare variable $xmlconv:errAggregated := "4";

(:Returns a list of Facility elements:)
declare variable $TxtFacilityReports := "Facility without any releases/transfers.";
declare variable $TxtPollutant := "Voluntary reported";
declare variable $TxtOnlyVoluntary := "ONLY Voluntary";

(:==================================================================:)
(: *******  ADDITIONAL VALIDATIONS ************************************************************** :)
(:==================================================================:)

(:==================================================================:)
(:  Validations for missing reporting                                                                                    :)
(:==================================================================:)
(:#29:)
(:Find FacilityReports without any reporting of PollutantReleases, PollutantTransfers or WasteTransfers:)
(:Returns a list of FacilityReport elements:)
declare function xmlconv:getFacilitiesWithNoReleasesOrTransfers($facilityReports as element(rsm:FacilityReport)*){
    for $i in $facilityReports[empty(rsm:PollutantTransfer) and empty(rsm:PollutantRelease) and empty(rsm:WasteTransfer)]
        return $i
};
(: borrar al final de las pruebas aunque esta ya es satisfactoria
declare function xmlconv:getFacilitiesWithNoReleasesOrTransfers($facilityReports){
    for $i in $facilityReports
        return $i
};:)


(:==================================================================:)
(:  Validations for reporting below the threshold                                                                   :)
(:==================================================================:)
(:#30:)
(:Find PollutantReleases with total Quantity below the threshold. Confidential data are considered to be above the threshold:)
(:Returns a list of PollutantRelease elements:)
declare function xmlconv:findBelowThresholdsPollutantRelease($facilityReports as element(rsm:FacilityReport)*){
  for $elem in $facilityReports/rsm:PollutantRelease[rsm:confidentialIndicator=false()]
      let $threshold := xmlconv:findPollutantThreshold($elem/rsm:pollutantCode, $elem/rsm:mediumCode)
      where(xmlconv:belowThreshold(xmlconv:getSumPollutantQuantity($elem/rsm:totalQuantity, $threshold), $threshold))
      return $elem
};

(:#31:)
(:Find rsm:PollutantTransfers with rsm:Quantity below the threshold:)
(:Returns a list of rsm:PollutantTransfer elements:)
declare function xmlconv:findBelowThresholdsPollutantTransfer($facilityReports as element(rsm:FacilityReport)*){
  for $elem in $facilityReports/rsm:PollutantTransfer[rsm:confidentialIndicator=false()]
      let $threshold := xmlconv:findPollutantTransferThreshold($elem/rsm:pollutantCode)
      where(xmlconv:belowThreshold(xmlconv:getSumPollutantQuantity($elem/rsm:quantity, $threshold), $threshold))
      return $elem
};

(:Find sum of Pollutant quantities for the poullutants in the same group as the pollutant given. :)
declare function xmlconv:getSumPollutantQuantity($quantity, $threshold){
    let $pollutant := $quantity/..
    let $tpc := $threshold/@pollutantCode
    let $pc := $quantity/../rsm:pollutantCode
    return
    if($pc != $tpc) then
        if(local-name($pollutant) = "PollutantTransfer") then
            (xmlconv:findSumPollutantTransfer($pollutant))
        else
            (xmlconv:findSumPollutantRelease($pollutant))
    else
        ($quantity)


};

(:Find sum of Pollutant transfer quantities for the poullutants in the same group as the pollutant given. :)
declare function xmlconv:findSumPollutantTransfer($pollutant){
    let $pc := $pollutant/rsm:pollutantCode
    let $ppc :=  doc($pcUrl)//Code[. = $pc]/@parentGroup
    let $codes := distinct-values (doc($pcUrl)//Code[.//@parentGroup = $ppc])

    let $elems := doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport[rsm:InspireIdPRTR = $pollutant/../rsm:InspireIdPRTR]/
            rsm:PollutantTransfer[rsm:confidentialIndicator=false() and exists(index-of($codes, rsm:pollutantCode))]

    let $tot :=  sum($elems/rsm:quantity)
    return ($tot)
};

(:Find sum of Pollutant release quantities for the poullutants in the same group as the pollutant given. :)
declare function xmlconv:findSumPollutantRelease($pollutant){
    let $pc := $pollutant/rsm:pollutantCode
    let $mc :=$pollutant/rsm:mediumCode
    let $ppc :=  doc($pcUrl)//Code[. = $pc]/@parentGroup
    let $codes := distinct-values (doc($pcUrl)//Code[.//@parentGroup = $ppc])

    let $elems := doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport[rsm:InspireIdPRTR = $pollutant/../rsm:InspireIdPRTR]/
            rsm:PollutantRelease[rsm:confidentialIndicator=false() and rsm:mediumCode = $mc and exists(index-of($codes, rsm:pollutantCode))]

    let $tot := sum($elems/rsm:totalQuantity)
    return ($tot)


};

(:#32:)
(:Find WasteTransfers with Quantity below the threshold:)
(:Returns a list of waste elements generated in xmlconv:findBelowThresholdsWasteTransfer(...) :)
declare function xmlconv:findBelowThresholdsWasteTransfer($facilityReports as element(rsm:FacilityReport)*){

          let $w := xmlconv:findBelowThresholdsWasteTransfer($facilityReports,"NON-HW")
                      union
                      xmlconv:findBelowThresholdsWasteTransfer($facilityReports,"HW")

        return for $i in $w order by $i/rsm:InspireIdPRTR return $i
};

(:Find WasteTransfer elements with given wasteTypesCodes below the given threshold. If a wastetransfer is Confidential that wasteType is considered above the threshold. Returns a list of waste elements with aggregated quantities:)
declare function xmlconv:findBelowThresholdsWasteTransfer($facilityReports as element(rsm:FacilityReport)*, $wasteType){

    let $threshold := xmlconv:findWasteTransferThreshold($wasteType)

    for $w in xmlconv:findSumWasteTransfer($facilityReports, $wasteType)
        return $w[xmlconv:ConfidentialIndicator=false() and xmlconv:belowThreshold(xmlconv:Quantity, $threshold)]
};

(:Find sum of WasteTransfer quantities for a given  wasteTypes ("HW" of "NON-HW"). Returns a list of waste elements:)
declare function xmlconv:findSumWasteTransfer($facilityReports as element(rsm:FacilityReport)*, $wasteType){
    let $wasteTypeCodes := (if($wasteType = "NON-HW") then ("NON-HW") else (("HWIC","HWOC")))

(:    let $threshold := xmlconv:findWasteTransferThreshold($wasteType)
:)
    for $ni in distinct-values($facilityReports/rsm:WasteTransfer[index-of($wasteTypeCodes,  rsm:wasteTypeCode)>0]/../rsm:InspireIdPRTR)
       let $wt := $facilityReports[rsm:InspireIdPRTR=$ni]/rsm:WasteTransfer[index-of($wasteTypeCodes,  rsm:wasteTypeCode)>0]
       let $tot := sum($wt/number(rsm:quantity))
       let $conf := $wt[rsm:confidentialIndicator=true()]/rsm:confidentialIndicator
       return
        <xmlconv:Waste>
            <xmlconv:NationalID>{$ni}</xmlconv:NationalID>
            <xmlconv:WasteTypeCode>{$wasteType}</xmlconv:WasteTypeCode>
            <xmlconv:Quantity>{$tot}</xmlconv:Quantity>
            <xmlconv:ConfidentialIndicator>{count($conf)>0}</xmlconv:ConfidentialIndicator>
        </xmlconv:Waste>

};

(:Compares a Quantity with a threshold. Returns true if Quantity is below the threshold. Values that equals the thresholds are considered above:)
declare function xmlconv:belowThreshold($quantity, $threshold) as xs:boolean{
    if(empty($quantity)) then
        false()
    else if(empty($threshold)) then
        true()
    else
    (
        number($quantity) < number($threshold)
    )
};

(:
       :)

(:Finds the threshold value for a pollutant in a given medium (AIR, LAND, WATER, WASTEWATER):)
(:If no thresholds exists an empty sequnece will be returned:)
declare function xmlconv:findPollutantThreshold($code, $medium){
   let $t := doc($pUrl)//Threshold[@pollutantCode =$code and @mediumCode = $medium ]
      return
   if (empty($t)) then
   (
       let $pc :=  doc($pcUrl)//Code[. = $code]/@parentGroup
       return
           if(string-length($pc)>0) then
           (
               xmlconv:findPollutantThreshold($pc, $medium)
           )
           else
               ()
   )
   else ( $t)

};

(:Finds the threshold value for a rsm:PollutantTransfer :)
(:If no thresholds exists an empty sequnece will be returned:)
declare function xmlconv:findPollutantTransferThreshold($code){
    xmlconv:findPollutantThreshold($code, "WASTEWATER")
};

(:Finds the threshold value for a type of wastetransfer (HW or NON-HW):)
(:If no thresholds exists an empty sequnece will be returned:)
declare function xmlconv:findWasteTransferThreshold($code){
    let $t := doc($wUrl)//Threshold[@wasteTypeCode=$code]
    return $t
};

(:==================================================================:)
(:  Validations for reporting ONLY below the threshold                                                         :)
(:==================================================================:)
(:30:)
(:Find rsm:PollutantReleases with only total rsm:Quantity below the threshold. Confidential data are considered to be above the threshold:)
(:Returns a list of rsm:FacilityReport elements:)
declare function xmlconv:findOnlyBelowThresholdsPollutantRelease($facilityReports as element(rsm:FacilityReport)*){
 let $all := (for $elem in $facilityReports/rsm:PollutantRelease return $elem)
 let $below := xmlconv:findBelowThresholdsPollutantRelease($facilityReports)

 return xmlconv:findFacilititesOnlyBelowThresholds($all, $below)
};

(:31:)
(:Find rsm:PollutantTransfers with only rsm:Quantity below the threshold. Confidential data are considered to be above the threshold:)
(:Returns a list of rsm:FacilityReport elements:)
declare function xmlconv:findOnlyBelowThresholdsPollutantTransfer($facilityReports as element(rsm:FacilityReport)*){
 let $all := (for $elem in $facilityReports/rsm:PollutantTransfer return $elem)
 let $below := xmlconv:findBelowThresholdsPollutantTransfer($facilityReports)

 return xmlconv:findFacilititesOnlyBelowThresholds($all, $below)
};

(:Find facility reports with only values below the threshold.:)
(:$all is a list of all rsm:PollutantReleases or rsm:PollutantTransfersfor the facility (only one of the types):)
(:$below is a list of same type as $all with values below the threshold:)
(:Returns a list of rsm:FacilityReport elements:)
declare function xmlconv:findFacilititesOnlyBelowThresholds($all, $below){
    let $above := $all except $below
    let $facilititesOnlyBelow :=  $below/.. except $above/..

    return $facilititesOnlyBelow
};

(:32:)
(:Find WasteTransfers with only total Quantity below the threshold. Confidential data are considered to be above the threshold:)
(:Returns a list of rsm:FacilityReport elements:)
declare function xmlconv:findOnlyBelowThresholdsWasteTransfer($facilityReports as element(rsm:FacilityReport)*){

 let $below := xmlconv:findBelowThresholdsWasteTransfer($facilityReports)
 let $above := xmlconv:findAboveThresholdsWasteTransfer($facilityReports)

 for $nid in distinct-values($below/xmlconv:NationalID)
    where empty(index-of($above/xmlconv:NationalID, $nid))
      return $facilityReports[rsm:InspireIdPRTR = $nid]
};

(:Find WasteTransfers with Quantity above the threshold:)
(:Returns a list of waste elements generated in xmlconv:findSumWasteTransfer:)
declare function xmlconv:findAboveThresholdsWasteTransfer($facilityReports as element(rsm:FacilityReport)*){
    let $w := xmlconv:findAboveThresholdsWasteTransfer($facilityReports, "NON-HW")
              union
              xmlconv:findAboveThresholdsWasteTransfer($facilityReports, "HW")

    return for $i in $w order by $i/xmlconv:NationalID return $i
};

(:Find rsm:WasteTransfer elements with given wasteTypesCodes above the given threshold. If a wastetransfer is rsm:ConfidentialIndicator that wasteType is considered above the threshold. Returns a list of waste elements with aggregated quantities:)
declare function xmlconv:findAboveThresholdsWasteTransfer($facilityReports as element(rsm:FacilityReport)*, $wasteType){

    let $threshold := xmlconv:findWasteTransferThreshold($wasteType)

    for $w in xmlconv:findSumWasteTransfer($facilityReports, $wasteType)
        return $w[rsm:confidentialIndicator=true() or not(xmlconv:belowThreshold(xmlconv:Quantity, $threshold))]
};

(:==================================================================:)
(: *******  OUTPUT MESSAGES ******************************************************************** :)
(:==================================================================:)

(:==================================================================:)
(: Output messages concerning missing reporting                                                               :)
(:==================================================================:)

(:36:)
(:All facility Reports with no reporting of releases/transfers:)
declare function xmlconv:buildFacilitiesWithNoReleasesOrTransfers($list){
    let $errCode := $xmlconv:errFacilityReports

    let $header := "Facilities without releases/transfers"
    let $descr := ""
    let $tableHeader := "The following facilities have no reporting of releases/transfers:"
    let $table := xmlutil:buildTableFacilityReport($xmlutil:LEVEL_WARNING, "Facility reports without releases/transfers", $list, $xmlutil:COL_FR_NationalID, $errCode)

    return
        xmlutil:buildDescription($tableHeader)
        union
        $table
};


(:==================================================================:)
(: Output messages concerning values below the threshold                                                  :)
(:==================================================================:)


(:Builds a table with pollutant relases and thresholds from a list of PollutantRelease elements. Data in colum with number given by errorIndex will be marked:)
declare variable $xmlconv:COL_PRT_TotalQuantity as xs:integer :=  4;

declare function xmlconv:buildTablePollutantReleaseThreshold($errorLevel as xs:integer, $error as xs:string, $elems, $errorIndex){
    let $colHeaders := ("Facility", "Medium", "Pollutant", "Tot. quantity", "Threshold")
    let $tableRows := (for $elem in $elems
                                  let $q := $elem/rsm:totalQuantity
                                  let $pc := $elem/rsm:pollutantCode
                                  let $t := xmlconv:findPollutantThreshold($pc, $elem/rsm:mediumCode)
                                  let $ts := xmlconv:getPollutantThresholdString($pc, $t)
                                  let $qs := xmlconv:getPollutantQuantityString( $q,$t)
                                return xmlutil:buildTableRow((xmlutil:getElem($elem/../rsm:InspireIdPRTR), xmlutil:getElem($elem/rsm:mediumCode), xmlutil:getElem($pc),$qs, $ts), $errorLevel,  $errorIndex, $xmlconv:errThresholds))

    return  xmlutil:buildTable($errorLevel, $error, $colHeaders, $tableRows)
};

(:Builds a table with pollutant transfers and thresholds from a list of PollutantTransfer elements. Data in colum with number given by errorIndex will be marked:)
declare variable $xmlconv:COL_PTT_Quantity as xs:integer :=  3;

declare function xmlconv:buildTablePollutantTransferThreshold($errorLevel as xs:integer, $error as xs:string, $elems, $errorIndex){
    let $colHeaders := ("Facility", "Pollutant", "Quantity", "Threshold")
    let $tableRows := (for $elem in $elems
                                  let $q := $elem/rsm:quantity
                                  let $pc := $elem/rsm:pollutantCode
                                  let $t := xmlconv:findPollutantTransferThreshold($pc)
                                  let $ts := xmlconv:getPollutantThresholdString($pc, $t)
                                  let $qs := xmlconv:getPollutantQuantityString( $q, $t)
                                return xmlutil:buildTableRow((xmlutil:getElem($elem/../rsm:InspireIdPRTR), xmlutil:getElem($pc), $qs, $ts), $errorLevel,  $errorIndex, $xmlconv:errThresholds))

    return  xmlutil:buildTable($errorLevel, $error, $colHeaders, $tableRows)
};

(:Builds a table with waste transfers and thresholds from a list of waste elements (genereated during validation). Data in colum with number given by errorIndex will be marked:)
declare variable $xmlconv:COL_WTT_Quantity as xs:integer :=  3;

declare function xmlconv:buildTableWasteTransferThreshold($errorLevel as xs:integer, $error as xs:string, $elems, $errorIndex){
    let $colHeaders := ("Facility", "Waste type", "Sum (quantity)", "Threshold")
    let $tableRows := (for $elem in $elems
                                return xmlutil:buildTableRow((xmlutil:getElem($elem/xmlconv:NationalID), xmlutil:getElem($elem/xmlconv:WasteTypeCode),string($elem/xmlconv:Quantity), xmlconv:getWasteTransferThresholdString($elem/xmlconv:WasteTypeCode)), $errorLevel,  $errorIndex, $xmlconv:errThresholds))

    return  xmlutil:buildTable($errorLevel, $error, $colHeaders, $tableRows)
};

(:Returns a string for a rsm:WasteTransfer threshold value and handles if no threshold is found:)
declare function xmlconv:getWasteTransferThresholdString($wasteType){
    xmlconv:getThresholdString(xmlconv:findWasteTransferThreshold($wasteType) )
};

(:Returns a string for the pollutant threshold value. If the threshold applies for a group - i.e. not the specific pollutant - the group is added to the string:)
declare function xmlconv:getPollutantThresholdString($pollutantCode, $threshold){
    let $t :=
        if(exists($threshold) and $threshold/@pollutantCode != $pollutantCode)  then
            concat ($threshold, " (as ", $threshold/@pollutantCode ,")")
        else
        ( $threshold)
    return
        xmlconv:getThresholdString($t)
};

(:Returns a string for the threshold value and handles if no threshold is found:)
declare function xmlconv:getThresholdString($threshold){
    if(empty($threshold)) then
        "-"
    else
        string($threshold)

};

(:Returns a string for the pollutant quantity value. :)
(:If the quantity of the specific pollutant does not correspond to the pollutantcode of threshold i tmeans that the threshold applies for a group:)
(:In this case the  total quantity for the group is added to the string - e.g 50.0 (247) :)
declare function xmlconv:getPollutantQuantityString($quantity, $threshold){
    let $t :=
        if($threshold/@pollutantCode != $quantity/../rsm:pollutantCode)  then
        (
            concat ($quantity, " (Sum: ", xmlconv:getSumPollutantQuantity($quantity, $threshold),")")
        )
        else
        (
            string($quantity)
            )
    return
        $t
};


(:35:)
(:All rsm:PollutantReleases with values below the threshold and facilities having only rsm:PollutantReleases below the threshold:)
(:$listBelow is a list of rsm:PollutantReleases below the threshold:)
(:$facilitiesOnlyBelow is a list of rsm:FacilityReports only having rsm:PollutantReleases below the threshold:)
declare function xmlconv:buildBelowThresholdPollutantReleases($listBelow, $facilitiesOnlyBelow){
    let $header := "2.1 Pollutant releases below the threshold"
    let $errCode := $xmlconv:errThresholds

    return

    if(empty($listBelow)) then
    (
        xmlutil:buildSubHeader($header)
        union
        xmlutil:buildDescription(3, "No pollutant releases with total quantity below the threshold are reported")
    )
    else
    (

        let $descr := ("Pollutant releases below threshold are considered voluntary reported." ,"An hyphen in E-PRTR Regulation Annex II  indicates that the parameter and medium in question do not trigger a reporting requirements.", "If confidentiality is claimed the amounts for groups of pollutants are reported instead of the individual pollutants. For each of the pollutants in the group different thresholds apply. Therefore it is assumed that as soon as confidentiality is claimed, the reported amount for a group of pollutants is above the threshold.")
        let $tableHeader := "The following pollutant releases are considered voluntary reported (i.e. below threshold or no reporting requirements):"
        let $errorPos := ($xmlconv:COL_PRT_TotalQuantity)
        let $table := xmlconv:buildTablePollutantReleaseThreshold($xmlutil:LEVEL_WARNING, "PollutantRelease below the threshold",$listBelow,$errorPos)

        let $tableHeaderOnly := "The following facilities have only reported voluntary pollutant releases (i.e. below the threshold or no reporting requirements):"
        let $errorPosOnly := ( $xmlutil:COL_FR_NationalID)
        let $tableFacilitiesOnlyBelow := xmlutil:buildTableFacilityReport($xmlutil:LEVEL_WARNING, "Only PollutantRelease below the threshold",$facilitiesOnlyBelow,$errorPosOnly, $errCode)

        return
            xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
            union
            xmlutil:buildMessageSection("", "", $tableHeaderOnly, $tableFacilitiesOnlyBelow)
    )
};

(:#33:)
(:All PollutantTransfers with values below the threshold and facilities having only PollutantTransfers below the threshold:)
(:$listBelow is a list of PollutantTransfers below the threshold:)
(:$facilitiesOnlyBelow is a list of FacilityReports only having PollutantTransfers below the threshold:)
declare function xmlconv:buildBelowThresholdPollutantTransfers($listBelow, $facilitiesOnlyBelow){
    let $header := "2.2 Pollutant transfers below the threshold"
    let $errCode := $xmlconv:errThresholds

    return

    if(empty($listBelow)) then
    (
        xmlutil:buildSubHeader($header)
        union
        xmlutil:buildDescription(3, "No pollutant transfers with quantity below the threshold are reported")
    )
    else
    (
        let $descr := ("Pollutant transfers below threshold are considered voluntary reported." , "An hyphen in E-PRTR Regulation Annex II  indicates that the parameter and medium in question do not trigger a reporting requirements.","If confidentiality is claimed the amounts for groups of pollutants are reported instead of the individual pollutants. For each of the pollutants in the group different thresholds apply. Therefore it is assumed that as soon as confidentiality is claimed, the reported amount for a group of pollutants is above the threshold.")
        let $tableHeader := "The following pollutant transfers are considered voluntary reported (i.e. below threshold or no reporting requirements):"
        let $errorPos := ($xmlconv:COL_PTT_Quantity)
        let $table := xmlconv:buildTablePollutantTransferThreshold($xmlutil:LEVEL_WARNING, "PollutantTransfer below the threshold",$listBelow,$errorPos)

        let $tableHeaderOnly := "The following facilities have only reported voluntary pollutant transfers (i.e. below the threshold or no reporting requirements):"
        let $errorPosOnly := ( $xmlutil:COL_FR_NationalID)
        let $tableFacilitiesOnlyBelow := xmlutil:buildTableFacilityReport($xmlutil:LEVEL_WARNING, "Only PollutantTransfer below the threshold",$facilitiesOnlyBelow,$errorPosOnly,$errCode)

        return
            xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
            union
            xmlutil:buildMessageSection("", "", $tableHeaderOnly, $tableFacilitiesOnlyBelow)
    )
};

(:34:)
(:All WasteTransfers with values below the threshold and facilities having only WasteTransfers below the threshold:)
(:$listBelow is a list of WasteTransfers below the threshold:)
(:$facilitiesOnlyBelow is a list of FacilityReports only having WasteTransfers below the threshold:)
declare function xmlconv:buildBelowThresholdWasteTransfers($listBelow, $facilitiesOnlyBelow){
    let $header := "2.3 Waste transfers below the threshold"
    let $errCode := $xmlconv:errThresholds

    return

    if(empty($listBelow)) then
    (
        xmlutil:buildSubHeader($header)
        union
        xmlutil:buildDescription(3, "No waste transfers with quantity below the threshold are reported")
    )
    else
    (
        let $descr := ("Waste transfers below threshold are considered voluntary reported.","The threshold for hazardous waste applies to the total amount of waste transferred within and outside the country (HWIC and HWOC). The threshold for non hazardous waste applies to the total amount of waste with waste type NON-HW","In cases where amounts are kept confidential, it is difficult to assess on facility level (where different waste transfers can occur) whether the total amount is above the threshold. Therefore it is assumed that if confidentiality of an amount is claimed, that amount (hazardous waste or non-hazardous waste) is above the threshold.")
        let $tableHeader := "The following waste transfers are considered voluntary reported (i.e. below threshold):"
        let $errorPos := ( $xmlconv:COL_WTT_Quantity )
        let $table := xmlconv:buildTableWasteTransferThreshold($xmlutil:LEVEL_WARNING, "WasteTransfer below the threshold",$listBelow, $errorPos)

        let $tableHeaderOnly := "The following facilities have only reported voluntary waste transfers (i.e. below the threshold):"
        let $errorPosOnly := ( $xmlutil:COL_FR_NationalID)
        let $tableFacilitiesOnlyBelow := xmlutil:buildTableFacilityReport($xmlutil:LEVEL_WARNING, "Only WasteTransfer below the threshold",$facilitiesOnlyBelow,$errorPosOnly, $errCode)

        return
            xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
            union
            xmlutil:buildMessageSection("", "", $tableHeaderOnly, $tableFacilitiesOnlyBelow)
    )
};
(:35:)
(:All rsm:PollutantReleases with values below the threshold and facilities having only rsm:PollutantReleases below the threshold:)
(:$listBelow is a list of rsm:PollutantReleases below the threshold:)
(:$facilitiesOnlyBelow is a list of rsm:FacilityReports only having rsm:PollutantReleases below the threshold:)
declare function xmlconv:buildBelowThresholdPollutantReleasesOnlyVol($facilitiesOnlyBelow){
    let $header := "3.1 Facilities reporting only voluntary pollutant releases"
    let $errCode := $xmlconv:errThresholdsOnly

    return

    if(empty($facilitiesOnlyBelow)) then
    (
        xmlutil:buildSubHeader($header)
        union
        xmlutil:buildDescription(3, "No facilities with only voluntary pollutant releases are reported")
    )
    else
    (

        let $tableHeaderOnly := "The following facilities have only reported voluntary pollutant releases (i.e. below the threshold or no reporting requirements):"
        let $errorPosOnly := ( $xmlutil:COL_FR_NationalID)
        let $tableFacilitiesOnlyBelow := xmlutil:buildTableFacilityReport($xmlutil:LEVEL_WARNING, "Only PollutantRelease below the threshold",$facilitiesOnlyBelow,$errorPosOnly, $errCode)

        return
            xmlutil:buildMessageSection($header,  "", $tableHeaderOnly, $tableFacilitiesOnlyBelow)
    )
};
(:#33:)
(:All PollutantTransfers with values below the threshold and facilities having only PollutantTransfers below the threshold:)
(:$listBelow is a list of PollutantTransfers below the threshold:)
(:$facilitiesOnlyBelow is a list of FacilityReports only having PollutantTransfers below the threshold:)
declare function xmlconv:buildBelowThresholdPollutantTransfersOnlyVol($facilitiesOnlyBelow){
    let $header := "3.2 Facilities reporting only voluntary pollutant transfers"
    let $errCode := $xmlconv:errThresholdsOnly

    return

    if(empty($facilitiesOnlyBelow)) then
    (
        xmlutil:buildSubHeader($header)
        union
        xmlutil:buildDescription(3, "No facilities with only voluntary pollutant transfers are reported")
    )
    else
    (

        let $tableHeaderOnly := "The following facilities have only reported voluntary pollutant transfers (i.e. below the threshold or no reporting requirements):"
        let $errorPosOnly := ( $xmlutil:COL_FR_NationalID)
        let $tableFacilitiesOnlyBelow := xmlutil:buildTableFacilityReport($xmlutil:LEVEL_WARNING, "Only PollutantTransfer below the threshold",$facilitiesOnlyBelow,$errorPosOnly,$errCode)

        return
            xmlutil:buildMessageSection($header,  "", $tableHeaderOnly, $tableFacilitiesOnlyBelow)
    )
};
(:34:)
(:All WasteTransfers with values below the threshold and facilities having only WasteTransfers below the threshold:)
(:$listBelow is a list of WasteTransfers below the threshold:)
(:$facilitiesOnlyBelow is a list of FacilityReports only having WasteTransfers below the threshold:)
declare function xmlconv:buildBelowThresholdWasteTransfersOnlyVol($facilitiesOnlyBelow){
    let $header := "3.3 Facilities reporting only voluntary waste transfers"
    let $errCode := $xmlconv:errThresholdsOnly

    return

    if(empty($facilitiesOnlyBelow)) then
    (
        xmlutil:buildSubHeader($header)
        union
        xmlutil:buildDescription(3, "No facilities with only voluntary waste transfers are reported")
    )
    else
    (

        let $tableHeaderOnly := "The following facilities have only reported voluntary waste transfers (i.e. below the threshold):"
        let $errorPosOnly := ( $xmlutil:COL_FR_NationalID)
        let $tableFacilitiesOnlyBelow := xmlutil:buildTableFacilityReport($xmlutil:LEVEL_WARNING, "Only WasteTransfer below the threshold",$facilitiesOnlyBelow,$errorPosOnly, $errCode)

        return
            xmlutil:buildMessageSection($header,  "", $tableHeaderOnly, $tableFacilitiesOnlyBelow)
    )
};


(:==================================================================:)
(: *******  RUN VALIDATIONS AND GENERATE OUTPUT *************************************** :)
(:==================================================================:)


(:==================================================================:)
(: QA1: Facility Reports                                                                                                    :)
(:==================================================================:)
declare function xmlconv:controlOfFacility($source_url as xs:string){

    let $facilityReports := doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport
    let $facilityWithNoReleaseTransferList := xmlconv:getFacilitiesWithNoReleasesOrTransfers($facilityReports)

return
<div>
<h2><br /><a name='1'>1. Facility reports without releases or transfers</a></h2>

{xmlutil:buildDescription("This validation examines if any facilities without any releases/transfers have been reported.")}

{
    if( empty($facilityWithNoReleaseTransferList) ) then
    (
        <div>
            {xmlutil:buildDescription(3, "The test was passed successfully.")}
        </div>
    )
    else
    (
        <div>
            {
                xmlconv:buildFacilitiesWithNoReleasesOrTransfers($facilityWithNoReleaseTransferList)
            }
        </div>
     )

 }
</div>
};

(:==================================================================:)
(: QA2: Values below the threshold                                                                                    :)
(:==================================================================:)
 declare function xmlconv:controlThresholds( $source_url as xs:string){

      let $facilityReports := doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport
      let $belowThresholdsPollutantRelease := xmlconv:findBelowThresholdsPollutantRelease($facilityReports)
      let $belowThresholdsPollutantTransfer := xmlconv:findBelowThresholdsPollutantTransfer($facilityReports)
      let $belowThresholdsWasteTransfer := xmlconv:findBelowThresholdsWasteTransfer($facilityReports)


      return
      <div>
      <h2><br /><a name='2'>2. Quantities below the thresholds</a></h2>

      {xmlutil:buildDescription("The MS might voluntarily report releases and transfers with quantities below the threshold. This validation examines if any values below the threshold have been reported.")}

     {
        if( empty ($belowThresholdsPollutantRelease) and empty($belowThresholdsPollutantTransfer) and empty($belowThresholdsWasteTransfer)) then
        (
            <div>
                {xmlutil:buildDescription(3, "No values below the threshold have been reported.")}
            </div>
        )
        else
        (
            <div>
            {xmlutil:buildDescription("Below is listed all cases where quantities below the thresholds has been reported for pollutant releases, pollutant transfers and waste transfers respectively. If the value reported equals the threshold, it will be regarded to be above the threshold.")}
            {
                (:rsm:PollutantReleases below the threshold:)
                xmlconv:buildBelowThresholdPollutantReleases($belowThresholdsPollutantRelease, ())
            }
            {
                (:rsm:PollutantTransfers below the threshold:)
                xmlconv:buildBelowThresholdPollutantTransfers($belowThresholdsPollutantTransfer, ())
            }
            {
                (:rsm:WasteTransfers below the threshold:)
                xmlconv:buildBelowThresholdWasteTransfers($belowThresholdsWasteTransfer, ())
            }
        </div>
        )
    }
    </div>
 };
 (:==================================================================:)
(: QA2: Values below the threshold                                                                                    :)
(:==================================================================:)
 declare function xmlconv:controlThresholdsOnlyVol( $source_url as xs:string){

      let $facilityReports := doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport

      let $onlyBelowThresholdsPollutantRelease := xmlconv:findOnlyBelowThresholdsPollutantRelease($facilityReports)
      let $onlyBelowThresholdsPollutantTransfer := xmlconv:findOnlyBelowThresholdsPollutantTransfer($facilityReports)
      let $onlyBelowThresholdsWasteTransfer := xmlconv:findOnlyBelowThresholdsWasteTransfer($facilityReports)


      return
      <div>
      <h2><br /><a name='3'>3. Facility reports with only voluntary releases or transfers</a></h2>

      {xmlutil:buildDescription("The MS might voluntarily report releases and transfers with quantities below the threshold. This validation examines if any facility with only voluntary releases or transfers have been reported.")}

     {
        if( empty ($onlyBelowThresholdsPollutantRelease) and empty($onlyBelowThresholdsPollutantTransfer) and empty($onlyBelowThresholdsWasteTransfer)) then
        (
            <div>
                {xmlutil:buildDescription(3, "No facilities reporting only voluntary releases or transfers have been reported.")}
            </div>
        )
        else
        (
            <div>
            {xmlutil:buildDescription("Below is listed all facilities where all quantities below the thresholds has been reported for pollutant releases, pollutant transfers and waste transfers respectively. If the value reported equals the threshold, it will be regarded to be above the threshold.")}
            {
                (:rsm:PollutantReleases below the threshold:)
                xmlconv:buildBelowThresholdPollutantReleasesOnlyVol($onlyBelowThresholdsPollutantRelease)
            }
            {
                (:rsm:PollutantTransfers below the threshold:)
                xmlconv:buildBelowThresholdPollutantTransfersOnlyVol($onlyBelowThresholdsPollutantTransfer)
            }
            {
                (:rsm:WasteTransfers below the threshold:)
                xmlconv:buildBelowThresholdWasteTransfersOnlyVol($onlyBelowThresholdsWasteTransfer)
            }
        </div>
        )
    }
    </div>
 };
(:==================================================================:)
(: QA 3 - sorted by facilities                                      :)
(:==================================================================:)

declare function xmlconv:findFacility($source_url){

      for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport
            let $National := $elems/rsm:InspireIdPRTR
         

            let $ReleaseTransfer := xmlconv:findRelease($elems)
            let $ThresholdsRelease := xmlconv:controlThresholdsRelease($elems)
            let $ThresholdsTransfer := xmlconv:controlThresholdsTransfer($elems)
            let $ThresholdsWaste := xmlconv:controlThresholdsWaste($elems)

            let $OnlyVolThresholdsRelease := xmlconv:findOnlyBelowThresholdsPollutantRelease($elems)
            let $OnlyVolThresholdsTransfer := xmlconv:findOnlyBelowThresholdsPollutantTransfer($elems)
            let $OnlyVolThresholdsWaste := xmlconv:findOnlyBelowThresholdsWasteTransfer($elems)

            return

                if (not(empty($ReleaseTransfer)) or $ThresholdsRelease != "True" or $ThresholdsTransfer != "True" or $ThresholdsWaste != "True" or $ThresholdsTransfer != "True"
                    or not(empty($OnlyVolThresholdsRelease)) or not(empty($OnlyVolThresholdsTransfer)) or not(empty($OnlyVolThresholdsWaste))) then
                    <tr>
                    <td>{$National}</td>
                    
                    {
                    if (not(empty($ReleaseTransfer))) then
                        <td style="color:blue;text-align:center">{xmlutil:buildErrorElement($xmlconv:errAggregated, $ReleaseTransfer)}</td>
                    else
                        <td style="color:blue;text-align:center">{$ReleaseTransfer}</td>
                    }
                    <td style="color:blue">{$ThresholdsRelease}</td>
                    <td style="color:blue">{$ThresholdsTransfer}</td>
                    <td style="color:blue">{$ThresholdsWaste}</td>
                    {
                    if (not(empty($OnlyVolThresholdsRelease))) then
                        <td style="color:blue;text-align:center">{xmlutil:buildErrorElement($xmlconv:errAggregated, $TxtOnlyVoluntary)}</td>
                    else
                        <td style="color:blue;text-align:center"></td>
                    }
                    {
                    if (not(empty($OnlyVolThresholdsTransfer))) then
                        <td style="color:blue;text-align:center">{xmlutil:buildErrorElement($xmlconv:errAggregated, $TxtOnlyVoluntary)}</td>
                    else
                        <td style="color:blue;text-align:center"></td>
                    }
                    {
                    if (not(empty($OnlyVolThresholdsWaste))) then
                        <td style="color:blue;text-align:center">{xmlutil:buildErrorElement($xmlconv:errAggregated, $TxtOnlyVoluntary)}</td>
                    else
                        <td style="color:blue;text-align:center"></td>
                    }
                    </tr>
                else
                    ()

};
(:
declare function xmlconv:findFacility($source_url){

      for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport
            let $National := $elems/rsm:dBFacitilyID
            let $FacilityName := $elems/rsm:FacilityName
            let $FacilityCompany := $elems/rsm:ParentCompanyName
            let $FacilityCompetent := $elems/rsm:CompetentAuthorityPartyName
            let $FaclityStreet := string($elems/rsm:Address/rsm:StreetName)
            let $FacilityNumber := string($elems/rsm:Address/rsm:BuildingNumber)
            let $FacilityCity := string($elems/rsm:Address/rsm:CityName)
            let $FacilityCode := string($elems/rsm:Address/rsm:PostcodeCode)
            let $FacilityAddress := concat($FaclityStreet, " ", $FacilityNumber, " ", $FacilityCity, " ", $FacilityCode)

            let $ReleaseTransfer := xmlconv:findRelease($elems)
            let $ThresholdsRelease := xmlconv:controlThresholdsRelease($elems)
            let $ThresholdsTransfer := xmlconv:controlThresholdsTransfer($elems)
            let $ThresholdsWaste := xmlconv:controlThresholdsWaste($elems)

            let $OnlyVolThresholdsRelease := xmlconv:findOnlyBelowThresholdsPollutantRelease($elems)
            let $OnlyVolThresholdsTransfer := xmlconv:findOnlyBelowThresholdsPollutantTransfer($elems)
            let $OnlyVolThresholdsWaste := xmlconv:findOnlyBelowThresholdsWasteTransfer($elems)

            return

                if (not(empty($ReleaseTransfer)) or $ThresholdsRelease != "True" or $ThresholdsTransfer != "True" or $ThresholdsWaste != "True" or $ThresholdsTransfer != "True"
                    or not(empty($OnlyVolThresholdsRelease)) or not(empty($OnlyVolThresholdsTransfer)) or not(empty($OnlyVolThresholdsWaste))) then
                    <tr>
                    <td>{$National}</td>
                    <td>{$FacilityName}&#160;</td>
                    <td>{$FacilityCompany}&#160;</td>
                    <td>{$FacilityAddress}&#160;</td>
                    <td>{$FacilityCompetent}&#160;</td>
                    {
                    if (not(empty($ReleaseTransfer))) then
                        <td style="color:blue;text-align:center">{xmlutil:buildErrorElement($xmlconv:errAggregated, $ReleaseTransfer)}&#160;</td>
                    else
                        <td style="color:blue;text-align:center">{$ReleaseTransfer}&#160;</td>
                    }
                    <td style="color:blue">{$ThresholdsRelease}&#160;</td>
                    <td style="color:blue">{$ThresholdsTransfer}&#160;</td>
                    <td style="color:blue">{$ThresholdsWaste}&#160;</td>
                    {
                    if (not(empty($OnlyVolThresholdsRelease))) then
                        <td style="color:blue;text-align:center">{xmlutil:buildErrorElement($xmlconv:errAggregated, $TxtOnlyVoluntary)}&#160;</td>
                    else
                        <td style="color:blue;text-align:center">&#160;</td>
                    }
                    {
                    if (not(empty($OnlyVolThresholdsTransfer))) then
                        <td style="color:blue;text-align:center">{xmlutil:buildErrorElement($xmlconv:errAggregated, $TxtOnlyVoluntary)}&#160;</td>
                    else
                        <td style="color:blue;text-align:center">&#160;</td>
                    }
                    {
                    if (not(empty($OnlyVolThresholdsWaste))) then
                        <td style="color:blue;text-align:center">{xmlutil:buildErrorElement($xmlconv:errAggregated, $TxtOnlyVoluntary)}&#160;</td>
                    else
                        <td style="color:blue;text-align:center">&#160;</td>
                    }
                    </tr>
                else
                    ()

};:)

(:&#160;{xmlconv:builtReleasethreshold($ThresholdsTransfer)}:)

(:==================================================================:)
(: QA1: Facility reports                                            :)
(:==================================================================:)

declare function xmlconv:FacilityReport($source_url as xs:string) {

     let $Facility :=  xmlconv:findFacility( $source_url)

     return
     <div>
    <h2><br /><a name='4'>4. Additional validation sorted by facilities</a></h2>

        <p><b>(1) Facility Reports:</b> This additional validation examines if any facilities without any releases/transfers have been reported. When the column has text "<span style="color:blue">{ $TxtFacilityReports}</span>", it means that the National ID of that entry line has not reported releases or transfers.</p>

        <p><b>(2) Quantities below thresholds: </b> Member States might voluntarily report releases and transfers below the threshold. This validation examines if any values below the threshold have been reported. The result is provided by pollutant releases, pollutant transfers and waste transfers.</p>

        <p><b>(3) Facilities reporting only voluntary releases/transfers: </b> This validation examines if any facilities with only voluntary releases or transfers have been reported. When the column has text "<span style="color:blue">{ $TxtOnlyVoluntary}</span>", then the facility has reported only pollutant releases, pollutant transfers or waste transfers respectively.</p>
{

     if ($Facility != "") then
    <div>
        <table border="1" style="font-size:11px;" class="datatable">
        <tr>
            <th rowspan="2" width="5%">National ID</th>
            
            <th rowspan="2" width="7.5%">(1) Facility Reports</th>
            <th colspan="3" width="37.5%">(2) Quantities below thresholds</th>
            <th colspan="3" width="15%">(3) Facilities reporting ONLY voluntary releases/transfers</th>

        </tr>
        <tr>
           
            <th width="12.5%">Pollutant Releases</th>
            <th width="12.5%">Pollutant Transfers</th>
            <th width="12.5%">Waste Transfers</th>
            <th>Pollutant Releases</th>
            <th>Pollutant Transfers</th>
            <th>Waste Transfers</th>
        </tr>
                {$Facility}
        </table>
    </div>
        else
            xmlutil:buildSuccessfulMessage()

     }
    </div>

};
(:
declare function xmlconv:FacilityReport($source_url as xs:string) {

     let $Facility :=  xmlconv:findFacility( $source_url)

     return
     <div>
    <h2><br /><a name='4'>4. Additional validation sorted by facilities</a></h2>

        <p><b>(1) Facility Reports:</b> This additional validation examines if any facilities without any releases/transfers have been reported. When the column has text "<span style="color:blue">{ $TxtFacilityReports}</span>", it means that the National ID of that entry line has not reported releases or transfers.</p>

        <p><b>(2) Quantities below thresholds: </b> Member States might voluntarily report releases and transfers below the threshold. This validation examines if any values below the threshold have been reported. The result is provided by pollutant releases, pollutant transfers and waste transfers.</p>

        <p><b>(3) Facilities reporting only voluntary releases/transfers: </b> This validation examines if any facilities with only voluntary releases or transfers have been reported. When the column has text "<span style="color:blue">{ $TxtOnlyVoluntary}</span>", then the facility has reported only pollutant releases, pollutant transfers or waste transfers respectively.</p>
{

     if ($Facility != "") then
    <div>
        <table border="1" style="font-size:11px;" class="datatable">
        <tr>
            <th rowspan="2" width="5%">National ID</th>
            <th colspan="4" width="35%">Facility Details</th>
            <th rowspan="2" width="7.5%">(1) Facility Reports</th>
            <th colspan="3" width="37.5%">(2) Quantities below thresholds</th>
            <th colspan="3" width="15%">(3) Facilities reporting ONLY voluntary releases/transfers</th>

        </tr>
        <tr>
            <th>Facility Name</th>
            <th>Parent Company</th>
            <th>Address</th>
            <th>Competent Authority</th>
            <th width="12.5%">Pollutant Releases</th>
            <th width="12.5%">Pollutant Transfers</th>
            <th width="12.5%">Waste Transfers</th>
            <th>Pollutant Releases</th>
            <th>Pollutant Transfers</th>
            <th>Waste Transfers</th>
        </tr>
                {$Facility}
        </table>
    </div>
        else
            xmlutil:buildSuccessfulMessage()

     }
    </div>

};:)

(:==================================================================:)
(: QA1: Facility reports  - Release                                                                                     :)
(:==================================================================:)

declare function xmlconv:findRelease($elems) {
    if (empty($elems/rsm:PollutantTransfer) and empty($elems/rsm:PollutantRelease) and empty($elems/rsm:WasteTransfer)) then
       ($TxtFacilityReports)
    else
       ()
};


(:==================================================================:)
(: QA2: Quantities below the thresholds                                                                                      :)
(:==================================================================:)

 declare function xmlconv:controlThresholdsRelease($facilityReports as element(rsm:FacilityReport)*){
    let $belowThresholdsPollutantRelease := xmlconv:findBelowThresholdsPollutantReleaseAggregated( $facilityReports)

    return
        $belowThresholdsPollutantRelease

};

declare function xmlconv:controlThresholdsTransfer($facilityReports as element(rsm:FacilityReport)*){

     let $belowThresholdsPollutantTransfer := xmlconv:findBelowThresholdsPollutantTransferAggregated($facilityReports)

    return
        $belowThresholdsPollutantTransfer

};

declare function xmlconv:controlThresholdsWaste($facilityReports as element(rsm:FacilityReport)*){

     let $belowThresholdsWasteTransfer := xmlconv:findBelowThresholdsWasteTransferTAggregated($facilityReports)

  return
        $belowThresholdsWasteTransfer

};

declare function xmlconv:findBelowThresholdsPollutantReleaseAggregated($facilityReports as element(rsm:FacilityReport)*){
  for $dato in $facilityReports/rsm:PollutantRelease[rsm:confidentialIndicator=false()]
      let $threshold := xmlconv:findPollutantThreshold($dato/rsm:pollutantCode, $dato/rsm:mediumCode)
       where(xmlconv:belowThreshold(xmlconv:getSumPollutantQuantity($dato/rsm:totalQuantity, $threshold, $facilityReports, "PollutantRelease"), $threshold))

      (:<table border="1" width="100%" style="font-size:12px">
      <td width="35%" style="font-size:11px">{$dato/rsm:PollutantCode}&#160;</td>
      <td width="5%">{$dato/rsm:MediumCode}&#160;</td>
      <td style="color:red" width="20%">{$dato/rsm:Quantity}&#160;</td>
      <td width="15%">{$threshold}&#160;</td>
      <td>{$dato/rsm:Quantity[@unitCode]}&#160;</td>
      </table>:)
      return
      <li style="list-style-type:none"><b>{xmlutil:buildErrorElement($xmlconv:errAggregated, concat($dato/rsm:mediumCode, '/' , $dato/rsm:pollutantCode , ': '))} </b>{$TxtPollutant}</li>
};

declare function xmlconv:buildRelease($belowThresholdsPollutant){
    (:if (not(empty($belowThresholdsPollutantRelease))) then:)
        for $w in $belowThresholdsPollutant
              let $DatoThresholds := concat($w, " , ")

    return $DatoThresholds

};


declare function xmlconv:buildTransfer( $belowThresholdsPollutantTransfer){
    for $w in $belowThresholdsPollutantTransfer
        let $DatoTransfer := concat($w, " , ")

    return concat("Pollutant Transfer: " ,$DatoTransfer)
};

declare function xmlconv:buildWaste( $belowThresholdsWasteTransfer){
     for $w in $belowThresholdsWasteTransfer
         let $DatoWaste := concat($w, ",")

     return concat("Waste Transfer: " ,$DatoWaste)
};

declare function xmlconv:findBelowThresholdsPollutantTransferAggregated($elems){

 for $dato in $elems/rsm:PollutantTransfer[rsm:confidentialIndicator=false()]
      let $threshold := xmlconv:findPollutantTransferThreshold($dato/rsm:pollutantCode)
      where(xmlconv:belowThreshold(xmlconv:getSumPollutantQuantity($dato/rsm:quantity, $threshold, $elems, "PollutantTransfer"), $threshold))

     (:  <table border="1" width="100%" style="font-size:12px">
      <td width="35%">{$dato/rsm:PollutantCode}&#160;</td>
      <td width="5%">{$dato/rsm:MediumCode}&#160;</td>
      <td style="color:red" width="20%">{$dato/rsm:Quantity}&#160;</td>
      <td width="15%">{$threshold}&#160;</td>
      <td>{$dato/rsm:Quantity[@unitCode]}&#160;</td>
      </table>:)
     return
      <li style="list-style-type:none"><b>{xmlutil:buildErrorElement($xmlconv:errAggregated, concat($dato/rsm:pollutantCode , ': '))} </b>{$TxtPollutant}</li>
};



(:Find sum of Pollutant quantities for the poullutants in the same group as the pollutant given. :)
declare function xmlconv:getSumPollutantQuantity($quantity, $threshold, $elems, $tipoPollutant as xs:string){
    let $pollutant := $quantity/..
    let $tpc := $threshold/@pollutantCode
    let $pc := $quantity/../rsm:pollutantCode
    return
    if($pc != $tpc) then
        if ($tipoPollutant = "PollutantTransfer") then
            (xmlconv:findSumPollutantTransferAggregated($pollutant, $elems))
        else
            (xmlconv:findSumPollutantReleaseAggregated($pollutant, $elems))
    else
        ($quantity)

};

(:Find sum of Pollutant quantities for the poullutants in the same group as the pollutant given. :)
declare function xmlconv:getSumPollutantQuantityTransfer($quantity, $threshold, $elems){
    let $pollutant := $quantity/..
    let $tpc := $threshold/@pollutantCode
    let $pc := $quantity/../rsm:pollutantCode
    return
    if($pc != $tpc) then
              (xmlconv:findSumPollutantTransferAggregated($pollutant, $elems))
    else
        ($quantity)

};

(:Find sum of Pollutant transfer quantities for the poullutants in the same group as the pollutant given. :)
declare function xmlconv:findSumPollutantTransferAggregated($pollutant, $elems){
    let $pc := $pollutant/rsm:pollutantCode
    let $ppc :=  doc($pcUrl)//Code[. = $pc]/@parentGroup
    let $codes := distinct-values (doc($pcUrl)//Code[.//@parentGroup = $ppc])

    let $dato := $elems[rsm:InspireIdPRTR = $pollutant/../rsm:InspireIdPRTR]/
            rsm:PollutantTransfer[rsm:confidentialIndicator=false() and exists(index-of($codes, rsm:pollutantCode))]

    let $tot :=  sum($dato/rsm:quantity)
    return ($tot)
};

(:Find sum of Pollutant release quantities for the poullutants in the same group as the pollutant given. :)
declare function xmlconv:findSumPollutantReleaseAggregated($pollutant, $elems){
    let $pc := $pollutant/rsm:pollutantCode
    let $mc :=$pollutant/rsm:mediumCode
    let $ppc :=  doc($pcUrl)//Code[. = $pc]/@parentGroup
    let $codes := distinct-values (doc($pcUrl)//Code[.//@parentGroup = $ppc])

    let $dato := $elems[rsm:InspireIdPRTR = $pollutant/../rsm:InspireIdPRTR]/
            rsm:PollutantRelease[rsm:confidentialIndicator=false() and rsm:mediumCode = $mc and exists(index-of($codes, rsm:pollutantCode))]

    let $tot := sum($dato/rsm:totalQuantity)
    return ($tot)

};

(:Find WasteTransfers with Quantity below the threshold:)
(:Returns a list of waste elements generated in xmlconv:findBelowThresholdsWasteTransferT(...) :)
declare function xmlconv:findBelowThresholdsWasteTransferTAggregated($elems){

          let $w := xmlconv:findBelowThresholdsWasteTransferAggregated($elems,"NON-HW")
                      union
                      xmlconv:findBelowThresholdsWasteTransferAggregated($elems,"HW")

       return for $i in $w order by $i/rsm:InspireIdPRTR

       return
           <li style="list-style-type:none"><b>{xmlutil:buildErrorElement($xmlconv:errAggregated, concat($i/xmlconv:WasteTypeCode , ': '))} </b>{$TxtPollutant}</li>

};

(:Find WasteTransfer elements with given wasteTypesCodes below the given threshold. If a wastetransfer is Confidential that wasteType is considered above the threshold. Returns a list of waste elements with aggregated quantities:)
declare function xmlconv:findBelowThresholdsWasteTransferAggregated($elems, $wasteType){

    let $threshold := xmlconv:findWasteTransferThreshold($wasteType)

    for $w in xmlconv:findSumWasteTransferAggregated($elems, $wasteType)
        return $w[xmlconv:ConfidentialIndicator=false() and xmlconv:belowThreshold(xmlconv:Quantity, $threshold)]
};

(:Find sum of WasteTransfer quantities for a given  wasteTypes ("HW" of "NON-HW"). Returns a list of waste elements:)
declare function xmlconv:findSumWasteTransferAggregated($elems, $wasteType){
    let $wasteTypeCodes := (if($wasteType = "NON-HW") then ("NON-HW") else (("HWIC","HWOC")))

    for $ni in distinct-values($elems/rsm:WasteTransfer[index-of($wasteTypeCodes,  rsm:wasteTypeCode)>0]/../rsm:InspireIdPRTR)
       let $wt := $elems[rsm:InspireIdPRTR=$ni]/rsm:WasteTransfer[index-of($wasteTypeCodes,  rsm:wasteTypeCode)>0]
       let $tot := sum($wt/number(rsm:quantity))
       let $conf := $wt[rsm:confidentialIndicator=true()]/rsm:confidentialIndicator
    return
        <xmlconv:Waste>
            <xmlconv:NationalID>{$ni}</xmlconv:NationalID>
            <xmlconv:WasteTypeCode>{$wasteType}</xmlconv:WasteTypeCode>
            <xmlconv:Quantity>{$tot} </xmlconv:Quantity>
            <xmlconv:ConfidentialIndicator>{count($conf)>0}</xmlconv:ConfidentialIndicator>
        </xmlconv:Waste>


};


(:==================================================================:)
(: RULES                                                            :)
(:==================================================================:)

declare function xmlconv:getRules()
as element(rules)
{
  <rules>
    <rule code="{$xmlconv:errFacilityReports}">
        <title>Facility reports without releases or transfers</title>
        <descr>This validation examines if any facilities without any releases/transfers have been reported.</descr>
        <message></message>
        <errLevel>{$xmlutil:LEVEL_INFO}</errLevel>
    </rule>
    <rule code="{$xmlconv:errThresholds}">
        <title>Quantities below the thresholds</title>
        <descr>This validation examines if any values below the threshold have been reported.</descr>
        <message></message>
        <errLevel>{$xmlutil:LEVEL_INFO}</errLevel>
    </rule>
    <rule code="{$xmlconv:errThresholdsOnly}">
        <title>Facility reports with only voluntary releases or transfers</title>
        <descr>This validation examines if any facilities with only voluntary releases or transfers have been reported.</descr>
        <message></message>
        <errLevel>{$xmlutil:LEVEL_INFO}</errLevel>
    </rule>
    <rule code="{$xmlconv:errAggregated}">
        <title>Additional validation sorted by facilities</title>
        <descr>The validation examines the same rules as in (1),(2) and (3) but presents the results in aggregated table sorted by facilities.</descr>
        <message></message>
        <errLevel>{$xmlutil:LEVEL_INFO}</errLevel>
    </rule>
  </rules>
};

(:==================================================================:)
(: Main function                                                                                                                :)
(:==================================================================:)
declare function xmlconv:proceed($source_url as xs:string) {
    let $controlOfFacility := xmlconv:controlOfFacility($source_url)
    let $controlThresholds := xmlconv:controlThresholds( $source_url)
    let $controlThresholdsOnlyVol := xmlconv:controlThresholdsOnlyVol( $source_url)
    let $sortedByFacilities := xmlconv:FacilityReport( $source_url)
    let $result := $controlOfFacility union $controlThresholds union $controlThresholdsOnlyVol union $sortedByFacilities

    let $infoCount := count($result//div[string-length(@errorcode) > 0])
    let $feedbackMessage :=
        if ($infoCount = 0) then
            "All tests were passed successfully."
        else
            concat($infoCount, ' info message', substring('s ', number(not($infoCount > 1)) * 2), 'generated')

    return

    <div class="feedbacktext">
        <span id="feedbackStatus" class="INFO" style="display:none">{$feedbackMessage}</span>
        <h1>E-PRTR - Additional validation</h1>
        {xmlutil:buildDescription("The following validations are meant to help the member states to evaluate that the data reported are correct. The validations will not prevent data from being stored in the database.")}

        {xmlutil:buildValidatedFile($source_url)}

            <ul>{
                xmlutil:buildRuleContentLinks($result//div[string-length(@errorcode) > 0]/@errorcode, xmlconv:getRules()//rule)
            }
            </ul>{
        $result
        }

</div>
};

xmlconv:proceed( $source_url )