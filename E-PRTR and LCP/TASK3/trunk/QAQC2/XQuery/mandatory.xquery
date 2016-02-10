(:  ======================================================================  :)
(:  =====      E-PRTR MANDATORY  CHECK                               =====  :)
(:  ======================================================================  :)
(:
    This XQuery contains a number of validations of E-PRTR reports to ensure
    compliance with the Guidance Document. As a main rule errors found will
    prevent data from being stored in the database.

    XQuery agency:  The European Commission
    XQuery version: 2.5
    Created:    2016-01-15
  :)

xquery version "1.0";

(:===================================================================:)
(: Namespace declaration                                             :)
(:===================================================================:)
import module namespace xmlutil = "urn:eu:com:env:prtr:converter:standard:2" at "http://converterstest.eionet.europa.eu/queries/LCPandPRTR_utils.xquery";

declare namespace xmlconv="urn:eu:com:env:prtr:converter:standard:2";
declare namespace xsi="http://www.w3.org/2001/XMLSchema-instance";
declare namespace rsm="http://dd.eionet.europa.eu/schemas/LCPandPRTR";
declare namespace p="http://dd.eionet.europa.eu/schemas/LCPandPRTR/LCPandPRTRCommon";
(:===================================================================:)
(: Variable given as an external parameter by the QA service         :)
(:===================================================================:)
(:
declare variable $source_url := 'TestData/TC_Outliers-invalid.xml';


declare variable $source_url as xs:string := 'http://localhost:8080/xml/kopa.xml';
declare variable $source_url as xs:string := 'http://cdr.eionet.europa.eu/lv/eu/eprtrdat/envt3sdpw/KOPA_3.05.12.xml';
declare variable $source_url as xs:string := 'http://cdrtest.eionet.europa.eu/pt/eu/eprtr_data/envuuea3a/test.xml';
declare variable $source_url as xs:string :='TestData/TC_Outliers-invalid.xml';
declare variable $source_url as xs:string := 'TestData/TC_Mandatory4.xml';
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


(:
declare variable $xmlconv:xmlValidatorUrl as xs:string := 'http://converterstest.eionet.europa.eu/api/runQAScript?script_id=-1&amp;url=';
declare variable $xmlconv:xmlValidatorUrl as xs:string := 'http://localhost:8080/xmlconv/api/runQAScript?script_id=-1&amp;url=';
:)
declare variable $xmlconv:xmlValidatorUrl as xs:string := 'http://converters.eionet.europa.eu/api/runQAScript?script_id=-1&amp;url=';

(:===================================================================:)
(: Code lists                                                        :)
(:===================================================================:)

declare variable $xmlconv:XML_HOST as xs:string := "http://converters.eionet.europa.eu/xmlfile/";
(:
declare variable $xmlconv:XML_HOST as xs:string := 'http://localhost:8080/xml/';
:)

declare variable $xmlconv:CHECKS_FAILED_TEXT :=
    <div style="color:red"><b>Mandatory check(s) FAILED. Data delivery is not acceptable. Errors found prevent data being imported to E-PRTR database.</b></div>;
declare variable $xmlconv:CHECKS_FAILED_FEEDBACK_MESSAGE :=
    <span id="feedbackStatus" class="BLOCKER" style="display:none">Mandatory check(s) FAILED. Data delivery is not acceptable. Errors found prevent data being imported to E-PRTR database.</span>;

declare variable $xmlconv:CHECKS_PASSED_FEEDBACK_MESSAGE :=
    <span id="feedbackStatus" class="INFO" style="display:none">All mandatory checks have passed. Data delivery is acceptable.</span>;


declare variable $pcUrl as xs:string := concat($xmlconv:XML_HOST, "EPRTR_PollutantCode_2.xml");
declare variable $ccUrl as xs:string := concat($xmlconv:XML_HOST, "EPRTR_CoordinateSystemCode_1.xml");
declare variable $aacUrl as xs:string := concat($xmlconv:XML_HOST, "EPRTR_AnnexlActivityCode_1.xml");
declare variable $ccrUrl as xs:string := concat($xmlconv:XML_HOST, "EPRTR_CountryCode_1.xml");
declare variable $mcrUrl as xs:string := concat($xmlconv:XML_HOST, "EPRTR_MediumCode_1.xml");
declare variable $mbrUrl as xs:string := concat($xmlconv:XML_HOST, "EPRTR_MethodBasisCode_1.xml");
declare variable $mtrcUrl as xs:string := concat($xmlconv:XML_HOST, "EPRTR_MethodTypeCode_1.xml");
declare variable $ncUrl as xs:string := concat($xmlconv:XML_HOST, "EPRTR_NaceActivityCode_1.xml");
declare variable $ncrUrl as xs:string := concat($xmlconv:XML_HOST, "EPRTR_NutsRegionCode_1.xml");
declare variable $wtcUrl as xs:string := concat($xmlconv:XML_HOST, "EPRTR_WasteTypeCode_1.xml");
declare variable $wtctUrl as xs:string := concat($xmlconv:XML_HOST, "EPRTR_WasteTreatmentCode_1.xml");
declare variable $rbdcrUrl as xs:string := concat($xmlconv:XML_HOST, "EPRTR_RiverBasinDistrictCode_1.xml");
declare variable $cfcrUrl as xs:string := concat($xmlconv:XML_HOST, "EPRTR_ConfidentialCode_1.xml");
declare variable $mucUrl as xs:string := concat($xmlconv:XML_HOST, "EPRTR_UnitCode_1.xml");

declare variable $wUrl as xs:string := concat($xmlconv:XML_HOST, "EPRTR_WasteThreshold_1.xml");
declare variable $pUrl as xs:string := concat($xmlconv:XML_HOST, "EPRTR_PollutantThreshold_2.xml");


(: Error codes :)
declare variable $xmlconv:errCodeXmlSchema := "1";
declare variable $xmlconv:errCodeCompliance := "3";
declare variable $xmlconv:errCodeComplianceFacility := "4";
declare variable $xmlconv:errCodeEnvelope := "2";

declare variable $test := 1;
declare variable $ENV := xmlconv:getENV();

declare variable $envelopeYear := ceiling(year-from-dateTime(data($ENV//envelope/date)));

(:==================================================================:)
(:Functions:)
(:==================================================================:)
declare function xmlconv:getENV() 
{

    if ($test = 1) then
    (
        let $file := doc("http://localhost/envelope_2/gml") 
        return ($file)
    )
    else
    (
      let $file := doc($source_url)
    return $file
    )
};
(:Controls if a string has three significant digits. :)
(:Returns the value if not ok otherwise an empty sequence:)
declare function xmlconv:ControlDigits($value as xs:string)
  {
        if( starts-with($value,"0") = true()  and contains($value,".") = true() and  $value !="0.00" and string-length(
             xmlconv:RemoveLeftZeros(xmlconv:RemoveDot($value)) ) != 3  ) then
           $value
      else  if( starts-with($value,"0") = false()  and  contains($value,".") = false()  and string-length( $value) > 3  and (substring($value,4) castable as xs:double) and
        number(substring($value,4)) > 0)then
           $value
       else if( contains($value,".") = false() and  string-length( $value) < 3 ) then
           $value
        else if (starts-with($value,"-") = true()  and contains($value,".") = true() and string-length($value)  != 5 and string-length(
             xmlconv:RemoveLeftZeros(xmlconv:RemoveDot(substring($value,2))) ) != 3) then
            $value
        else if (starts-with($value,"-") = false()  and starts-with($value,"0") = false() and contains($value,".") = true() and string-length
             ($value)  != 4 ) then
            $value
        else
             ()
  };
  declare function xmlconv:RemoveDot($string as xs:string)
  {
        if( contains($string,".") )   then
             concat (substring-before($string,"."),substring-after($string,".")  )
         else
              $string
  };
  declare function xmlconv:RemoveLeftZeros($s as xs:string){

     if(starts-with($s,"0") = true()  and string-length($s) >0 ) then
           xmlconv:RemoveLeftZeros(substring($s,2) )
       else
          $s
  };
(:==================================================================:)
(: Xquerys:)
(:==================================================================:)
(: #1 reportingYear cannot be after current year and cannot be different to envelope year:)
declare function xmlconv:illegalReportingYear($source_url as xs:string){
    let $reportingYears := doc($source_url)//rsm:LCPandPRTR/rsm:reportingYear[exists(.) and . castable as xs:double]
    let $currentYear := ceiling(year-from-dateTime(current-dateTime()))
    let $illegalYears := $reportingYears[ceiling(.)>$currentYear] 
    let $list := ($illegalYears,$envelopeYear)
    return if(count($illegalYears) != 0 or $reportingYears != $envelopeYear) then(
         $list
    )else()                   
};

(: #2 Same dbFacilityID is not allowed more than once and when the Registry is established,
 a call to the registry service will check that the ID is within the ISs communicated to the Registry:)
declare function xmlconv:controlDuplicateFacilityReports($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport
        let $ii := doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport[rsm:dBFacitilyID = $i/rsm:dBFacitilyID]
        where count($ii) > 1
        return $i
  };

(: #3 Find facilityReports with illegal/missing confidential codes:)
(:Returns a list of facilityReport elements:)
declare function xmlconv:controlConfidentialCodeFacilityReport($source_url as xs:string){
    for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport[rsm:confidentialIndicator=true() and (string-length(rsm:confidentialCode)=0)]
        union doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport[rsm:confidentialIndicator=false() and (string-length(rsm:confidentialCode)>0)]
    return $elems
};

(: #4 WasteTransfer/wasteTreatmentCode Must be reported if element confidentialIndicator is False:)
declare function xmlconv:control_wasteTreatmentCode($source_url as xs:string){
    for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport[rsm:confidentialIndicator=false()]/rsm:WasteTransfer[rsm:wasteTreatmentCode = '']
        return $elems
};

(: #5 WasteTransfer/quantity Must be reported if element confidentialIndicator is False:)
declare function xmlconv:control_quantity($source_url as xs:string){
    for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport[rsm:confidentialIndicator=false()]/rsm:WasteTransfer[rsm:quantity = '']
        return $elems
};

(: #6 Controls digtis of waste transfer - quantity :)
(:Returns a list of WasteTransfer elements:)
declare function xmlconv:control_DigitsQuantityWasteTransfer($source_url as xs:string){
     for $i in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:WasteTransfer[string-length(string(rsm:quantity))>0]
        let $ii :=  xmlconv:ControlDigits(string($i/rsm:quantity) )
        where string-length($ii) >0
        return $i
};

(: #7 WasteTransfer/methodBasisCode Must be reported if element confidentialIndicator is False:)
declare function xmlconv:control_methodBasisCode($source_url as xs:string){
    for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport[rsm:confidentialIndicator=false()]/rsm:WasteTransfer[rsm:methodBasisCode = '']
        return $elems
};

(: #8 WasteTransfer/methodUsed Must be reported if element confidentialIndicator is False and element methodBasis is 'M - Measured' or 'C - Calculated':)
declare function xmlconv:control_methodUsed($source_url as xs:string){
     for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport[rsm:confidentialIndicator=false()]/rsm:WasteTransfer[(rsm:methodBasisCode = 'M - Measured' or rsm:methodBasisCode = 'C - Calculated') and not(exists(rsm:methodUsed))]
        return $elems
};

(: #9 WasteTransfer/methodUsed/designation Must be reported if element methodUsed/MethodTypeCode is "CEN/ISO", "ETS", "IPCC" or "UNECE/EMEP":)
declare function xmlconv:control_methodUsed_designation($source_url as xs:string){
    for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:WasteTransfer[(rsm:methodUsed/p:MethodTypeCode = 'CEN/ISO - Internationally approved measurement standard' or rsm:methodUsed/p:MethodTypeCode = 'ETS - Guidelines for the monitoring and reporting of greenhouse gas emissions under the Emission Trading Scheme' or rsm:methodUsed/p:MethodTypeCode = 'IPCC - IPCC Guidelines' or rsm:methodUsed/p:MethodTypeCode = 'UNECE/EMEP - UNECE/EMEP EMEP/CORINAIR Emission Inventory Guidebook')and rsm:methodUsed/p:Designation = '']
        return $elems
};

(: #10 WasteTransfer/confidentialCode
 Must be reported if element confidentialIndicator is True and empy if is False:)
declare function xmlconv:control_confidentialCode($source_url as xs:string){
    for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:WasteTransfer[rsm:confidentialIndicator=true() and (string-length(rsm:confidentialCode)=0)]
        union doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:WasteTransfer[rsm:confidentialIndicator=false() and (string-length(rsm:confidentialCode)>0)]
            return $elems
};

(: #11 WasteTransfer/WasteHandlerParty Must be reported if element confidentialIndicator is False and element wasteTypeCode is 'HWOC - Harzodous waste outside country" and 
    empty if wasteTypeCode is different:)
declare function xmlconv:control_WasteHandlerParty($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:WasteTransfer[rsm:confidentialIndicator = false() and (
        rsm:wasteTypeCode = 'HWOC - Harzodous waste outside country' and not(exists(rsm:WasteHandlerParty)))]
        union doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:WasteTransfer[rsm:confidentialIndicator = false() and (
           rsm:wasteTypeCode != 'HWOC - Harzodous waste outside country' and exists(rsm:WasteHandlerParty))]
           return $i
};

(: #12 PollutantTransfer/PollutantCode Must be a Pollutant group (GRHGAS, OTHGAS, HEVMET, PEST, CHLORG, OTHORG OR INORG) if confidentialIndicator is True 
    and cannot bet a Pollutant group if confidentialIndicator is False:)
declare function xmlconv:control_pollutantCode($source_url as xs:string){
    for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantTransfer[rsm:confidentialIndicator = true() and (
        rsm:pollutantCode != 'GRHGAS' and rsm:pollutantCode != 'OTHGAS' and  rsm:pollutantCode != 'HEVMET' and rsm:pollutantCode != 'PEST' and rsm:pollutantCode != 'CHLORG'
        and rsm:pollutantCode != 'CHLORG' and rsm:pollutantCode != 'OTHORG' and  rsm:pollutantCode != 'INORG')] 
            union doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantTransfer[rsm:confidentialIndicator = false() and (
                rsm:pollutantCode = 'GRHGAS' or rsm:pollutantCode = 'OTHGAS' or  rsm:pollutantCode = 'HEVMET' or rsm:pollutantCode = 'PEST' or rsm:pollutantCode != 'CHLORG'
                    or rsm:pollutantCode = 'CHLORG' or rsm:pollutantCode = 'OTHORG' or  rsm:pollutantCode = 'INORG')]
                    return $elems
};

(: #13  Same pollutantCode is not allowed more than once:)
declare function xmlconv:controlDuplicatePollutantTransfers($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantTransfer
        let $ii := doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport[rsm:dBFacitilyID = $i/../rsm:dBFacitilyID]/rsm:PollutantTransfer[rsm:pollutantCode = $i/rsm:pollutantCode]
        where count($ii) > 1
        return $i
  };
  
(: #14 methodUsed Must be reported if element confidentialIndicator is False and element methodBasis 
        is 'M - Measured' or 'C - Calculated':)
declare function xmlconv:control_PollulantTransfer_methodUsed($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantTransfer[rsm:confidentialIndicator = false() and
        (rsm:methodBasisCode = 'C - Calculated' or rsm:methodBasisCode = 'M - Measured') and not(exists(rsm:methodUsed))]
        return $i
};

(: #15  'WEIGH - Weighing' is not allowed:)
declare function xmlconv:control_methodUsed_MethodUsedType($source_url as xs:string){
     for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantTransfer[rsm:methodUsed/p:MethodTypeCode = 'WEIGH - Weighing']
     return $elems
};

(: #16 methodUsed/designation Must be reported if element methodUsed/MethodTypeCode is "CEN/ISO", "ETS", "IPCC" or "UNECE/EMEP":)
declare function xmlconv:control_PollulantTransfer_methodUsed_designation($source_url as xs:string){
    for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantTransfer[(rsm:methodUsed/p:MethodTypeCode = 'CEN/ISO - Internationally approved measurement standard' or rsm:methodUsed/p:MethodTypeCode = 'ETS - Guidelines for the monitoring and reporting of greenhouse gas emissions under the Emission Trading Scheme'
        or rsm:methodUsed/p:MethodTypeCode = 'IPCC - IPCC Guidelines' or rsm:methodUsed/p:MethodTypeCode = 'UNECE/EMEP - UNECE/EMEP EMEP/CORINAIR Emission Inventory Guidebook') and not(exists(rsm:methodUsed/p:Designation))]
    return $elems
};

(: #17 confidentialCode Must be reported if element confidentialIndicator is True and empy if is False:)
declare function xmlconv:controlConfidentialCodePollutantTransfer($source_url as xs:string){
    for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantTransfer[rsm:confidentialIndicator=true() and (string-length(rsm:confidentialCode)=0)]
        union doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantTransfer[rsm:confidentialIndicator =false() and (string-length(rsm:confidentialCode)>0)]
            return $elems
};

(: #18 quantity ControlDigits and more than 0:)
declare function xmlconv:control_DigitsQuantityPollulantTransfer($source_url as xs:string){
     for $i in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantTransfer[string-length(string(rsm:quantity))>0]
        let $ii :=  xmlconv:ControlDigits(string($i/rsm:quantity) )
        where string-length($ii) >0
        return $i
};

(: #19 PollutantRelease/PollutantCode Must be a Pollutant group (GRHGAS, OTHGAS, HEVMET, PEST, CHLORG, OTHORG OR INORG) if confidentialIndicator is True 
    and cannot be a Pollutant group if confidentialIndicator is False:)
declare function xmlconv:control_PollulantRealese_pollulantCode($source_url as xs:string){
     for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantRelease[rsm:confidentialIndicator = true() and (
        rsm:pollutantCode != 'GRHGAS' and rsm:pollutantCode != 'OTHGAS' and  rsm:pollutantCode != 'HEVMET' and rsm:pollutantCode != 'PEST' and rsm:pollutantCode != 'CHLORG'
        and rsm:pollutantCode != 'CHLORG' and rsm:pollutantCode != 'OTHORG' and  rsm:pollutantCode != 'INORG')] 
            union doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantRelease[rsm:confidentialIndicator = false() and (
                rsm:pollutantCode = 'GRHGAS' or rsm:pollutantCode = 'OTHGAS' or  rsm:pollutantCode = 'HEVMET' or rsm:pollutantCode = 'PEST' or rsm:pollutantCode != 'CHLORG'
                    or rsm:pollutantCode = 'CHLORG' or rsm:pollutantCode = 'OTHORG' or  rsm:pollutantCode = 'INORG')]
                    return $elems
};

(: #20 Must be reported if element confidentialIndicator is False and element methodBasis is 'M - Measured' or 'C - Calculated':)
declare function xmlconv:control_PollulantRealese_methodUsed($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantRelease[rsm:confidentialIndicator = false() and
        (rsm:methodBasisCode = 'C - Calculated' or rsm:methodBasisCode = 'M - Measured') and not(exists(rsm:methodUsed))]
        return $i
};

(: #21  Must be reported if element methodUsed/MethodTypeCode is "CEN/ISO", "ETS", "IPCC" or "UNECE/EMEP":)
declare function xmlconv:control_PollulantRelease_methodUsed_designation($source_url as xs:string){
    for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantRelease[(rsm:methodUsed/p:MethodTypeCode = 'CEN/ISO - Internationally approved measurement standard' or rsm:methodUsed/p:MethodTypeCode = 'ETS - Guidelines for the monitoring and reporting of greenhouse gas emissions under the Emission Trading Scheme'
        or rsm:methodUsed/p:MethodTypeCode = 'IPCC - IPCC Guidelines' or rsm:methodUsed/p:MethodTypeCode = 'UNECE/EMEP - UNECE/EMEP EMEP/CORINAIR Emission Inventory Guidebook') and not(exists(rsm:methodUsed/p:Designation))]
    return $elems
};

(: #22 WEIGH - Weighing is not allowed:)
declare function xmlconv:control_PollulantRelease_methodUsed_MethodUsedType($source_url as xs:string){
     for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantRelease[rsm:methodUsed/p:MethodTypeCode = 'WEIGH - Weighing']
     return $elems
};

(: #23 Must be reported if element confidentialIndicator is True and empy if is False:)
declare function xmlconv:control_ConfidentialCodePollutantRelease($source_url as xs:string){
    for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantRelease[rsm:confidentialIndicator=true() and (string-length(rsm:confidentialCode)=0)]
        union doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantRelease[rsm:confidentialIndicator =false() and (string-length(rsm:confidentialCode)>0)]
            return $elems
};

(: #24 confidentialCode Element check: Only Article 4(2)(b), ( c ) and ( e ) are allowed:)
declare function xmlconv:control_PollutantRelease_confidentialCode($source_url as xs:string){
    for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantRelease[rsm:confidentialCode != 'A42b - Article 4(2)(b) of Directive 2003/4/EC' and
        rsm:confidentialCode != 'A42c - Article 4(2)(c) of Directive 2003/4/EC' and rsm:confidentialCode != 'A42e - Article 4(2)(e) of Directive 2003/4/EC']
    return $elems
};

(: #25 mediumCode/pollutantCode Same pollutantCode is not allowed for a given medium:)
declare function xmlconv:controlDuplicatePollutantReleases($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantRelease
        let $ii := doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport[rsm:dBFacitilyID = $i/../rsm:dBFacitilyID]/rsm:PollutantRelease[rsm:pollutantCode = $i/rsm:pollutantCode and rsm:mediumCode = $i/rsm:mediumCode]
        where count($ii) > 1
        return $i
};

(: #26 totalQuantity/accidentalQuantity accidentalQuantity cannot be more than totalQuantity:)
  declare function xmlconv:controlTotalQuantityPollutantRelease($source_url as xs:string){
        let  $list := doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantRelease[rsm:totalQuantity castable as xs:double and  rsm:accidentalQuantity castable as xs:double and  number(rsm:totalQuantity) < number(rsm:accidentalQuantity) ]
        return $list
};

(: #27 totalQuantity ControlDigits and more than 0:)
declare function xmlconv:controlDigitsTotalQuantityPollutantRelease($source_url as xs:string){
         for $i in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantRelease[string-length(string(rsm:totalQuantity))>0]
            let $ii :=  xmlconv:ControlDigits(string($i/rsm:totalQuantity) )
            where string-length($ii) >0
            return $i
};

(: #28 accidentalQuantity ControlDigits and more than 0:)
declare function xmlconv:controlDigitsAccQuantityPollutantRelease($source_url as xs:string){
         for $i in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantRelease[string-length(string(rsm:accidentalQuantity))>0]
            let $ii :=  xmlconv:ControlDigits(string($i/rsm:accidentalQuantity) )
            where string-length($ii) >0
            return $i
   };
(:==================================================================:)
(: Xquery  4. Compliance Validation sorted by facilities  :)
(:==================================================================:)

(: #1 reportingYear cannot be after current year and cannot be different to envelope year:)
declare function xmlconv:f_illegalReportingYear($elems){
    let $reportingYears := $elems/../../rsm:reportingYear[exists(.) and . castable as xs:double]
    let $currentYear := ceiling(year-from-dateTime(current-dateTime()))
    let $illegalYears := $reportingYears[ceiling(.)>$currentYear] 
    let $list := ($illegalYears,$envelopeYear)
    return if(count($illegalYears) != 0 or $reportingYears != $envelopeYear) then(
         $list
    )else()                   
};

(: #2 Same dbFacilityID is not allowed more than once and when the Registry is established,
 a call to the registry service will check that the ID is within the ISs communicated to the Registry:)
declare function xmlconv:f_controlDuplicateFacilityReports($elems){
    for $i in $elems
        let $ii := $elems[rsm:dBFacitilyID = $i/rsm:dBFacitilyID]
        where count($ii) > 1
        return $i
  };

(: #3 Find facilityReports with illegal/missing confidential codes:)
(:Returns a list of facilityReport elements:)
declare function xmlconv:f_controlConfidentialCodeFacilityReport($elems){
    for $elem in $elems[rsm:confidentialIndicator=true() and (string-length(rsm:confidentialCode)=0)]
        union $elems[rsm:confidentialIndicator=false() and (string-length(rsm:confidentialCode)>0)]
    return $elem
};

(: #4 WasteTransfer/wasteTreatmentCode Must be reported if element confidentialIndicator is False:)
declare function xmlconv:f_control_wasteTreatmentCode($elems){
    for $elem in $elems[rsm:confidentialIndicator=false()]/rsm:WasteTransfer[rsm:wasteTreatmentCode = '']
        return $elem
};

(: #5 WasteTransfer/quantity Must be reported if element confidentialIndicator is False:)
declare function xmlconv:f_control_quantity($elems){
    for $elem in $elems[rsm:confidentialIndicator=false()]/rsm:WasteTransfer[rsm:quantity = '']
        return $elem
};

(: #6 Controls digtis of waste transfer - quantity :)
(:Returns a list of WasteTransfer elements:)
declare function xmlconv:f_control_DigitsQuantityWasteTransfer($elems){
     for $i in $elems/rsm:WasteTransfer[string-length(string(rsm:quantity))>0]
        let $ii :=  xmlconv:ControlDigits(string($i/rsm:quantity) )
        where string-length($ii) >0
        return $i
};

(: #7 WasteTransfer/methodBasisCode Must be reported if element confidentialIndicator is False:)
declare function xmlconv:f_control_methodBasisCode($elems){
    for $elem in $elems[rsm:confidentialIndicator=false()]/rsm:WasteTransfer[rsm:methodBasisCode = '']
        return $elem
};

(: #8 WasteTransfer/methodUsed Must be reported if element confidentialIndicator is False and element methodBasis is 'M - Measured' or 'C - Calculated':)
declare function xmlconv:f_control_methodUsed($elems){
     for $elem in $elems[rsm:confidentialIndicator=false()]/rsm:WasteTransfer[(rsm:methodBasisCode = 'M - Measured' or rsm:methodBasisCode = 'C - Calculated') and not(exists(rsm:methodUsed))]
        return $elem
};

(: #9 WasteTransfer/methodUsed/designation Must be reported if element methodUsed/MethodTypeCode is "CEN/ISO", "ETS", "IPCC" or "UNECE/EMEP":)
declare function xmlconv:f_control_methodUsed_designation($elems){
    for $elem in $elems/rsm:WasteTransfer[(rsm:methodUsed/p:MethodTypeCode = 'CEN/ISO - Internationally approved measurement standard' or rsm:methodUsed/p:MethodTypeCode = 'ETS - Guidelines for the monitoring and reporting of greenhouse gas emissions under the Emission Trading Scheme' or rsm:methodUsed/p:MethodTypeCode = 'IPCC - IPCC Guidelines' or rsm:methodUsed/p:MethodTypeCode = 'UNECE/EMEP - UNECE/EMEP EMEP/CORINAIR Emission Inventory Guidebook')and rsm:methodUsed/p:Designation = '']
        return $elem
};

(: #10 WasteTransfer/confidentialCode
 Must be reported if element confidentialIndicator is True and empy if is False:)
declare function xmlconv:f_control_confidentialCode($elems){
    for $elem in $elems/rsm:WasteTransfer[rsm:confidentialIndicator=true() and (string-length(rsm:confidentialCode)=0)]
        union $elems//rsm:WasteTransfer[rsm:confidentialIndicator=false() and (string-length(rsm:confidentialCode)>0)]
            return $elem
};

(: #11 WasteTransfer/WasteHandlerParty Must be reported if element confidentialIndicator is False and element wasteTypeCode is 'HWOC - Harzodous waste outside country" and 
    empty if wasteTypeCode is different:)
declare function xmlconv:f_control_WasteHandlerParty($elems){
    for $i in $elems//rsm:WasteTransfer[rsm:confidentialIndicator = false() and (
        rsm:wasteTypeCode = 'HWOC - Harzodous waste outside country' and not(exists(rsm:WasteHandlerParty)))]
        union $elems/rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:WasteTransfer[rsm:confidentialIndicator = false() and (
           rsm:wasteTypeCode != 'HWOC - Harzodous waste outside country' and exists(rsm:WasteHandlerParty))]
           return $i
};

(: #12 PollutantTransfer/PollutantCode Must be a Pollutant group (GRHGAS, OTHGAS, HEVMET, PEST, CHLORG, OTHORG OR INORG) if confidentialIndicator is True 
    and cannot bet a Pollutant group if confidentialIndicator is False:)
declare function xmlconv:f_control_pollutantCode($elems){
    for $elem in $elems/rsm:PollutantTransfer[rsm:confidentialIndicator = true() and (
        rsm:pollutantCode != 'GRHGAS' and rsm:pollutantCode != 'OTHGAS' and  rsm:pollutantCode != 'HEVMET' and rsm:pollutantCode != 'PEST' and rsm:pollutantCode != 'CHLORG'
        and rsm:pollutantCode != 'CHLORG' and rsm:pollutantCode != 'OTHORG' and  rsm:pollutantCode != 'INORG')] 
            union $elems/rsm:PollutantTransfer[rsm:confidentialIndicator = false() and (
                rsm:pollutantCode = 'GRHGAS' or rsm:pollutantCode = 'OTHGAS' or  rsm:pollutantCode = 'HEVMET' or rsm:pollutantCode = 'PEST' or rsm:pollutantCode != 'CHLORG'
                    or rsm:pollutantCode = 'CHLORG' or rsm:pollutantCode = 'OTHORG' or  rsm:pollutantCode = 'INORG')]
                    return $elem
};

(: #13  Same pollutantCode is not allowed more than once:)
declare function xmlconv:f_controlDuplicatePollutantTransfers($elems){
    for $i in $elems/rsm:PollutantTransfer
        let $ii := $elems[rsm:dBFacitilyID = $i/../rsm:dBFacitilyID]/rsm:PollutantTransfer[rsm:pollutantCode = $i/rsm:pollutantCode]
        where count($ii) > 1
        return $i
  };
  
(: #14 methodUsed Must be reported if element confidentialIndicator is False and element methodBasis 
        is 'M - Measured' or 'C - Calculated':)
declare function xmlconv:f_control_PollulantTransfer_methodUsed($elems){
    for $i in $elems/rsm:PollutantTransfer[rsm:confidentialIndicator = false() and
        (rsm:methodBasisCode = 'C - Calculated' or rsm:methodBasisCode = 'M - Measured') and not(exists(rsm:methodUsed))]
        return $i
};

(: #15  'WEIGH - Weighing' is not allowed:)
declare function xmlconv:f_control_methodUsed_MethodUsedType($elems){
     for $elem in $elems/rsm:PollutantTransfer[rsm:methodUsed/p:MethodTypeCode = 'WEIGH - Weighing']
     return $elem
};

(: #16 methodUsed/designation Must be reported if element methodUsed/MethodTypeCode is "CEN/ISO", "ETS", "IPCC" or "UNECE/EMEP":)
declare function xmlconv:f_control_PollulantTransfer_methodUsed_designation($elems){
    for $elem in $elems/rsm:PollutantTransfer[(rsm:methodUsed/p:MethodTypeCode = 'CEN/ISO - Internationally approved measurement standard' or rsm:methodUsed/p:MethodTypeCode = 'ETS - Guidelines for the monitoring and reporting of greenhouse gas emissions under the Emission Trading Scheme'
        or rsm:methodUsed/p:MethodTypeCode = 'IPCC - IPCC Guidelines' or rsm:methodUsed/p:MethodTypeCode = 'UNECE/EMEP - UNECE/EMEP EMEP/CORINAIR Emission Inventory Guidebook') and not(exists(rsm:methodUsed/p:Designation))]
    return $elem
};

(: #17 confidentialCode Must be reported if element confidentialIndicator is True and empy if is False:)
declare function xmlconv:f_controlConfidentialCodePollutantTransfer($elems){
    for $elem in $elems/rsm:PollutantTransfer[rsm:confidentialIndicator=true() and (string-length(rsm:confidentialCode)=0)]
        union $elems//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport/rsm:PollutantTransfer[rsm:confidentialIndicator =false() and (string-length(rsm:confidentialCode)>0)]
            return $elem
};

(: #18 quantity ControlDigits and more than 0:)
declare function xmlconv:f_control_DigitsQuantityPollulantTransfer($elems){
     for $i in $elems/rsm:PollutantTransfer[string-length(string(rsm:quantity))>0]
        let $ii :=  xmlconv:ControlDigits(string($i/rsm:quantity) )
        where string-length($ii) >0
        return $i
};

(: #19 PollutantRelease/PollutantCode Must be a Pollutant group (GRHGAS, OTHGAS, HEVMET, PEST, CHLORG, OTHORG OR INORG) if confidentialIndicator is True 
    and cannot bet a Pollutant group if confidentialIndicator is False:)
declare function xmlconv:f_control_PollulantRealese_pollulantCode($elems){
     for $elem in $elems/rsm:PollutantRelease[rsm:confidentialIndicator = true() and (
        rsm:pollutantCode != 'GRHGAS' and rsm:pollutantCode != 'OTHGAS' and  rsm:pollutantCode != 'HEVMET' and rsm:pollutantCode != 'PEST' and rsm:pollutantCode != 'CHLORG'
        and rsm:pollutantCode != 'CHLORG' and rsm:pollutantCode != 'OTHORG' and  rsm:pollutantCode != 'INORG')] 
            union $elems/rsm:PollutantRelease[rsm:confidentialIndicator = false() and (
                rsm:pollutantCode = 'GRHGAS' or rsm:pollutantCode = 'OTHGAS' or  rsm:pollutantCode = 'HEVMET' or rsm:pollutantCode = 'PEST' or rsm:pollutantCode != 'CHLORG'
                    or rsm:pollutantCode = 'CHLORG' or rsm:pollutantCode = 'OTHORG' or  rsm:pollutantCode = 'INORG')]
                    return $elem
};

(: #20 Must be reported if element confidentialIndicator is False and element methodBasis is 'M - Measured' or 'C - Calculated':)
declare function xmlconv:f_control_PollulantRealese_methodUsed($elems){
    for $i in $elems/rsm:PollutantRelease[rsm:confidentialIndicator = false() and
        (rsm:methodBasisCode = 'C - Calculated' or rsm:methodBasisCode = 'M - Measured') and not(exists(rsm:methodUsed))]
        return $i
};

(: #21  Must be reported if element methodUsed/MethodTypeCode is "CEN/ISO", "ETS", "IPCC" or "UNECE/EMEP":)
declare function xmlconv:f_control_PollulantRelease_methodUsed_designation($elems){
    for $elem in $elems/rsm:PollutantRelease[(rsm:methodUsed/p:MethodTypeCode = 'CEN/ISO - Internationally approved measurement standard' or rsm:methodUsed/p:MethodTypeCode = 'ETS - Guidelines for the monitoring and reporting of greenhouse gas emissions under the Emission Trading Scheme'
        or rsm:methodUsed/p:MethodTypeCode = 'IPCC - IPCC Guidelines' or rsm:methodUsed/p:MethodTypeCode = 'UNECE/EMEP - UNECE/EMEP EMEP/CORINAIR Emission Inventory Guidebook') and not(exists(rsm:methodUsed/p:Designation))]
    return $elem
};

(: #22 WEIGH - Weighing is not allowed:)
declare function xmlconv:f_control_PollulantRelease_methodUsed_MethodUsedType($elems){
     for $elem in $elems/rsm:PollutantRelease[rsm:methodUsed/p:MethodTypeCode = 'WEIGH - Weighing']
     return $elem
};

(: #23 Must be reported if element confidentialIndicator is True and empy if is False:)
declare function xmlconv:f_control_ConfidentialCodePollutantRelease($elems){
    for $elem in $elems/rsm:PollutantRelease[rsm:confidentialIndicator=true() and (string-length(rsm:confidentialCode)=0)]
        union $elems/rsm:PollutantRelease[rsm:confidentialIndicator =false() and (string-length(rsm:confidentialCode)>0)]
            return $elem
};

(: #24 confidentialCode Element check: Only Article 4(2)(b), ( c ) and ( e ) are allowed:)
declare function xmlconv:f_control_PollutantRelease_confidentialCode($elems){
    for $elem in $elems/rsm:PollutantRelease[rsm:confidentialCode != 'A42b - Article 4(2)(b) of Directive 2003/4/EC' and
        rsm:confidentialCode != 'A42c - Article 4(2)(c) of Directive 2003/4/EC' and rsm:confidentialCode != 'A42e - Article 4(2)(e) of Directive 2003/4/EC']
    return $elem
};

(: #25 mediumCode/pollutantCode Same pollutantCode is not allowed for a given medium:)
declare function xmlconv:f_controlDuplicatePollutantReleases($elems){
    for $i in $elems/rsm:PollutantRelease
        let $ii := $elems[rsm:dBFacitilyID = $i/../rsm:dBFacitilyID]/rsm:PollutantRelease[rsm:pollutantCode = $i/rsm:pollutantCode and rsm:mediumCode = $i/rsm:mediumCode]
        where count($ii) > 1
        return $i
};

(: #26 totalQuantity/accidentalQuantity accidentalQuantity cannot be more than totalQuantity:)
  declare function xmlconv:f_controlTotalQuantityPollutantRelease($elems){
        let  $list := $elems/rsm:PollutantRelease[rsm:totalQuantity castable as xs:double and  rsm:accidentalQuantity castable as xs:double and  number(rsm:totalQuantity) < number(rsm:accidentalQuantity) ]
        return $list
};

(: #27 totalQuantity ControlDigits and more than 0:)
declare function xmlconv:f_controlDigitsTotalQuantityPollutantRelease($elems){
         for $i in $elems/rsm:PollutantRelease[string-length(string(rsm:totalQuantity))>0]
            let $ii :=  xmlconv:ControlDigits(string($i/rsm:totalQuantity) )
            where string-length($ii) >0
            return $i
};

(: #28 accidentalQuantity ControlDigits and more than 0:)
declare function xmlconv:f_controlDigitsAccQuantityPollutantRelease($elems){
         for $i in $elems/rsm:PollutantRelease[string-length(string(rsm:accidentalQuantity))>0]
            let $ii :=  xmlconv:ControlDigits(string($i/rsm:accidentalQuantity) )
            where string-length($ii) >0
            return $i
   };  
(:==================================================================:)
(: QA6: Waste transfers:)
(:==================================================================:)
declare function xmlconv:f_controlOfWasteTransfer($elems){
    let $f_control_wasteTreatmentCode := xmlconv:f_control_wasteTreatmentCode($elems)
    let $f_control_quantity := xmlconv:f_control_quantity($elems)
    let $f_digitsQuantity := xmlconv:f_control_DigitsQuantityWasteTransfer($elems)
    let $f_control_methodBasisCode := xmlconv:f_control_methodBasisCode($elems)
    let $f_control_methodUsed := xmlconv:f_control_methodUsed($elems)
    let $f_control_methodUsed_designation := xmlconv:f_control_methodUsed_designation($elems)
    let $f_control_confidentialCode := xmlconv:f_control_confidentialCode($elems)
    let $f_control_WasteHandlerParty := xmlconv:f_control_WasteHandlerParty($elems)
    
    let $message_f_control_wasteTreatmentCode := xmlconv:f_buildWasteTransferErrorMessage($f_control_wasteTreatmentCode, "wasteTreatmentCode NOT reported")
    let $message_f_control_quantity := xmlconv:f_buildWasteTransferErrorMessage($f_control_quantity, "quantity NOT reported")
    let $message_f_digitsQuantity := xmlconv:f_buildWasteTransferErrorMessage($f_digitsQuantity, "quantity ControlDigits")
    let $message_f_control_methodBasisCode := xmlconv:f_buildWasteTransferErrorMessage($f_control_methodBasisCode, "methodBasisCode NOT reported")
    let $message_f_control_methodUsed := xmlconv:f_buildWasteTransferErrorMessage($f_control_methodUsed,"methodUsed NOT reported")
    let $message_f_control_methodUsed_designation := xmlconv:f_buildWasteTransferErrorMessage($f_control_methodUsed_designation,"methodUsed/designation NOT reported")
    let $message_f_control_confidentialCode := xmlconv:f_buildWasteTransferErrorMessage($f_control_confidentialCode,"confidentialCode NOT reported")
    let $message_f_control_WasteHandlerParty := xmlconv:f_buildWasteTransferErrorMessage($f_control_WasteHandlerParty,"WasteHandlerParty NOT reported")
    return
    <div>
         {$message_f_control_wasteTreatmentCode}
         {$message_f_control_quantity}
         {$message_f_digitsQuantity}
         {$message_f_control_methodBasisCode}
         {$message_f_control_methodUsed}
         {$message_f_control_methodUsed_designation}
         {$message_f_control_confidentialCode}
         {$message_f_control_WasteHandlerParty}
    </div>
};

(:==================================================================:)
(: QA5: Pollutant transfers:)
(:==================================================================:)
declare function xmlconv:f_controlOfPollutantTransfer($elems){
    let $f_control_pollutantCode := xmlconv:f_control_pollutantCode($elems)
    let $f_controlDuplicatePollutantTransfers := xmlconv:f_controlDuplicatePollutantTransfers($elems)
    let $f_control_PollulantTransfer_methodUsed := xmlconv:f_control_PollulantTransfer_methodUsed($elems)
    let $f_control_methodUsed_MethodUsedType := xmlconv:f_control_methodUsed_MethodUsedType($elems)
    let $f_control_PollulantTransfer_methodUsed_designation := xmlconv:f_control_PollulantTransfer_methodUsed_designation($elems)
    let $f_controlConfidentialCodePollutantTransfer := xmlconv:f_controlConfidentialCodePollutantTransfer($elems)
    let $f_control_DigitsQuantityPollulantTransfer := xmlconv:f_control_DigitsQuantityPollulantTransfer($elems)
    
    let $message_f_control_pollutantCode := xmlconv:f_buildPollutantTransferErrorMessage($f_control_pollutantCode,"pollutantCode Group")
    let $message_f_controlDuplicatePollutantTransfers := xmlconv:f_buildPollutantTransferErrorMessage($f_controlDuplicatePollutantTransfers,"pollutantCode repeat")
    let $message_f_control_PollulantTransfer_methodUsed := xmlconv:f_buildPollutantTransferErrorMessage($f_control_PollulantTransfer_methodUsed,"methodUsed NOT reported")
    let $message_f_control_methodUsed_MethodUsedType := xmlconv:f_buildPollutantTransferErrorMessage($f_control_methodUsed_MethodUsedType,"methodUsed/MethodUsedType WEIGH NOT allowed")
    let $message_f_control_PollulantTransfer_methodUsed_designation := xmlconv:f_buildPollutantTransferErrorMessage($f_control_PollulantTransfer_methodUsed_designation,"methodUsed/designation NOT reported")
    let $message_f_controlConfidentialCodePollutantTransfer := xmlconv:f_buildPollutantTransferErrorMessage($f_controlConfidentialCodePollutantTransfer,"confidentialCode NOT reported")
    let $message_f_control_DigitsQuantityPollulantTransfer := xmlconv:f_buildPollutantTransferErrorMessage($f_control_DigitsQuantityPollulantTransfer,"quantity ControlDigits")
    return
    <div>
    {$message_f_control_pollutantCode}
    {$message_f_controlDuplicatePollutantTransfers}
    {$message_f_control_PollulantTransfer_methodUsed}
    {$message_f_control_methodUsed_MethodUsedType}
    {$message_f_control_PollulantTransfer_methodUsed_designation}
    {$message_f_controlConfidentialCodePollutantTransfer}
    {$message_f_control_DigitsQuantityPollulantTransfer}
    </div>
};

(:==================================================================:)
(: QA4: Pollutant releases:)
(:==================================================================:)
declare function xmlconv:f_controlOfPollutantRelease($elems){
    let $f_control_PollulantRealese_pollulantCode := xmlconv:f_control_PollulantRealese_pollulantCode($elems)
    let $f_control_PollulantRealese_methodUsed := xmlconv:f_control_PollulantRealese_methodUsed($elems)
    let $f_control_PollulantRelease_methodUsed_designation := xmlconv:f_control_PollulantRelease_methodUsed_designation($elems)
    let $f_control_PollulantRelease_methodUsed_MethodUsedType := xmlconv:f_control_PollulantRelease_methodUsed_MethodUsedType($elems)
    let $f_control_ConfidentialCodePollutantRelease := xmlconv:f_control_ConfidentialCodePollutantRelease($elems)
    let $f_control_PollutantRelease_confidentialCode := xmlconv:f_control_PollutantRelease_confidentialCode($elems)
    let $f_controlDuplicatePollutantReleases := xmlconv:f_controlDuplicatePollutantReleases($elems)
    let $f_controlTotalQuantityPollutantRelease := xmlconv:f_controlTotalQuantityPollutantRelease($elems)
    let $f_controlDigitsTotalQuantityPollutantRelease := xmlconv:f_controlDigitsTotalQuantityPollutantRelease($elems)
    let $f_controlDigitsAccQuantityPollutantRelease := xmlconv:f_controlDigitsAccQuantityPollutantRelease($elems)
    
    let $message_f_control_PollulantRealese_pollulantCode := xmlconv:f_buildPollutantReleaseErrorMessage($f_control_PollulantRealese_pollulantCode,"pollutantCode Group")
    let $message_f_control_PollulantRealese_methodUsed := xmlconv:f_buildPollutantReleaseErrorMessage($f_control_PollulantRealese_methodUsed,"methodUsed NOT reported")
    let $message_f_control_PollulantRelease_methodUsed_designation := xmlconv:f_buildPollutantReleaseErrorMessage($f_control_PollulantRelease_methodUsed_designation,"methodUsed/designation NOT reported")
    let $message_f_control_PollulantRelease_methodUsed_MethodUsedType := xmlconv:f_buildPollutantReleaseErrorMessage($f_control_PollulantRelease_methodUsed_MethodUsedType,"methodUsed/MethodUsedType NOT reported")
    let $message_f_control_ConfidentialCodePollutantRelease := xmlconv:f_buildPollutantReleaseErrorMessage($f_control_ConfidentialCodePollutantRelease,"confidentialCode NOT reported")
    let $message_f_control_PollutantRelease_confidentialCode := xmlconv:f_buildPollutantReleaseErrorMessage($f_control_PollutantRelease_confidentialCode,"confidentialCode option NOT allowed")
    let $message_f_controlDuplicatePollutantReleases := xmlconv:f_buildPollutantReleaseErrorMessage($f_controlDuplicatePollutantReleases,"mediumCode/pollutantCode repeat for a given mediumCode")
    let $message_f_controlTotalQuantityPollutantRelease := xmlconv:f_buildPollutantReleaseErrorMessage($f_controlTotalQuantityPollutantRelease,"totalQuantity/accidentalQuantity MORE than totalQuantity")
    let $message_f_controlDigitsTotalQuantityPollutantRelease := xmlconv:f_buildPollutantReleaseErrorMessage($f_controlDigitsTotalQuantityPollutantRelease,"totalQuantity ControlDigits")
    let $message_f_controlDigitsAccQuantityPollutantRelease := xmlconv:f_buildPollutantReleaseErrorMessage($f_controlDigitsAccQuantityPollutantRelease,"accidentalQuantity ControlDigits")
    return
    <div>
    {$message_f_control_PollulantRealese_pollulantCode}
    {$message_f_control_PollulantRealese_methodUsed}
    {$message_f_control_PollulantRelease_methodUsed_designation}
    {$message_f_control_PollulantRelease_methodUsed_MethodUsedType}
    {$message_f_control_ConfidentialCodePollutantRelease}
    {$message_f_control_PollutantRelease_confidentialCode}
    {$message_f_controlDuplicatePollutantReleases}
    {$message_f_controlTotalQuantityPollutantRelease}
    {$message_f_controlDigitsTotalQuantityPollutantRelease}
    {$message_f_controlDigitsAccQuantityPollutantRelease}
    </div>
};

(:==================================================================:)
(: QA2: Facility Reports:)
(:==================================================================:)
declare function xmlconv:f_controlOfFacility($elems){
    <div>
    {xmlconv:f_controlDuplicateFacilityReports($elems)}
    {xmlconv:f_controlConfidentialCodeFacilityReport($elems)}
    </div>
};


(:==================================================================:)
(: QA1: Legal values:)
(:==================================================================:)
declare function xmlconv:f_controlOfLegalValueHandler($elems){
    let $years := xmlconv:f_illegalReportingYear($elems)
    
    let $messageYears := xmlconv:f_buildilegalYears($years," Year not allowed")
    return
    <div>
    {$messageYears}
    </div>
};

(:==================================================================:)
(: QA6: Waste transfers:)
(:==================================================================:)
declare function xmlconv:controlOfWasteTransfer($source_url){
    let $control_wasteTreatmentCode := xmlconv:control_wasteTreatmentCode($source_url)
    let $control_quantity := xmlconv:control_quantity($source_url)
    let $digitsQuantity := xmlconv:control_DigitsQuantityWasteTransfer($source_url)
    let $control_methodBasisCode := xmlconv:control_methodBasisCode($source_url)
    let $control_methodUsed := xmlconv:control_methodUsed($source_url)
    let $control_methodUsed_designation := xmlconv:control_methodUsed_designation($source_url)
    let $control_confidentialCode := xmlconv:control_confidentialCode($source_url)
    let $control_WasteHandlerParty := xmlconv:control_WasteHandlerParty($source_url)
    
    let $hasErrors :=  exists($control_wasteTreatmentCode) or
                       exists($control_quantity) or
                       exists($digitsQuantity) or
                       exists($control_methodBasisCode) or
                       exists($control_methodUsed) or
                       exists($control_methodUsed_designation) or
                       exists($control_confidentialCode) or
                       exists($control_WasteHandlerParty)
    
    let $hasWarnings := false()
    return
    <div>
        <h3><br />{$xmlconv:errCodeCompliance}.6 Validation of Waste Transfers</h3>
        {xmlutil:buildDescription("")}
        {xmlconv:buildResultMsg($hasErrors, $hasWarnings)}
    
        {
        (:wasteTreatmentCode NOt reported:)
        xmlconv:build_control_wasteTreatmentCode($control_wasteTreatmentCode)
        }
        {
        (:quantity NOt reported:)
        xmlconv:build_control_quantity($control_quantity)
        }
        {
        (:Digits for quantity:)
        xmlconv:build_control_DigitsQuantityWasteTransfer($digitsQuantity )
        }
        {
        (:methodBasisCode not reported:)
        xmlconv:build_control_methodBasisCode($control_methodBasisCode )
        }
        {
        (:methodUsed not reported:)
        xmlconv:build_control_methodUsed($control_methodUsed)
        }
        {
        (:Designation not reported:)
         xmlconv:build_control_methodUsed_designation($control_methodUsed_designation)
        }
        {
        (:confidential not reported:)
        xmlconv:build_control_confidentialCode($control_confidentialCode)
        }
        {
        (:WasteHandlerParty:)
        xmlconv:build_control_WasteHandlerParty($control_WasteHandlerParty)
        }
    </div>
};

(:==================================================================:)
(: QA5: Pollutant transfers:)
(:==================================================================:)

declare function xmlconv:controlOfPollutantTransfer($source_url){
   
    let $control_pollutantCode := xmlconv:control_pollutantCode($source_url)
    let $controlDuplicatePollutantTransfers := xmlconv:controlDuplicatePollutantTransfers($source_url)
    let $control_PollulantTransfer_methodUsed := xmlconv:control_PollulantTransfer_methodUsed($source_url)
    let $control_methodUsed_MethodUsedType := xmlconv:control_methodUsed_MethodUsedType($source_url)
    let $control_PollulantTransfer_methodUsed_designation := xmlconv:control_PollulantTransfer_methodUsed_designation($source_url)
    let $controlConfidentialCodePollutantTransfer := xmlconv:controlConfidentialCodePollutantTransfer($source_url)
    let $control_DigitsQuantityPollulantTransfer := xmlconv:control_DigitsQuantityPollulantTransfer($source_url)
    
    let $hasErrors :=  exists($control_pollutantCode) or
                       exists($controlDuplicatePollutantTransfers) or
                       exists($control_PollulantTransfer_methodUsed) or
                       exists($control_methodUsed_MethodUsedType) or
                       exists($control_PollulantTransfer_methodUsed_designation) or
                       exists($controlConfidentialCodePollutantTransfer) or
                       exists($control_DigitsQuantityPollulantTransfer)
    
    let $hasWarnings := false()
    return
    <div>
        <h3><br />{$xmlconv:errCodeCompliance}.5 Validation of Pollutant Transfers</h3>
        {
        (:pollulant code control:)
        xmlconv:build_control_pollutantCode($control_pollutantCode)
        }
        {
        (:pollulant code duplicated:)
        xmlconv:build_controlDuplicatePollutantTransfers($controlDuplicatePollutantTransfers)
        }
        {
        (:methodUsed not reported:)
        xmlconv:build_control_PollulantTransfer_methodUseds($control_PollulantTransfer_methodUsed)
        }
        {
        (:MethodTypeCode WEIGH - Weighing selected:)
        xmlconv:build_control_methodUsed_MethodUsedType($control_methodUsed_MethodUsedType)
        }
        {
        (:Designation not reported:)
        xmlconv:build_control_methodUsed_Pollulant_designation($control_PollulantTransfer_methodUsed_designation)
        }
        {
        (:confidentialCode bad reported:)
        xmlconv:build_controlConfidentialCodePollutantTransfer($controlConfidentialCodePollutantTransfer)
        }
        {
        (:control_DigitsQuantityPollulantTransfer:)
        xmlconv:build_control_DigitsQuantityPollulantTransfer($control_DigitsQuantityPollulantTransfer)
        }
    </div>
};

(:==================================================================:)
(: QA4: Pollutant releases:)
(:==================================================================:)
declare function xmlconv:controlOfPollutantRelease($source_url){
   let $control_PollulantRealese_pollulantCode := xmlconv:control_PollulantRealese_pollulantCode($source_url)
   let $control_PollulantRealese_methodUsed := xmlconv:control_PollulantRealese_methodUsed($source_url)
   let $control_PollulantRelease_methodUsed_designation := xmlconv:control_PollulantRelease_methodUsed_designation($source_url)
   let $control_PollulantRelease_methodUsed_MethodUsedType := xmlconv:control_PollulantRelease_methodUsed_MethodUsedType($source_url)
   let $control_ConfidentialCodePollutantRelease := xmlconv:control_ConfidentialCodePollutantRelease($source_url)
   let $control_PollutantRelease_confidentialCode := xmlconv:control_PollutantRelease_confidentialCode($source_url)
   let $controlDuplicatePollutantReleases := xmlconv:controlDuplicatePollutantReleases($source_url)
   let $controlTotalQuantityPollutantRelease := xmlconv:controlTotalQuantityPollutantRelease($source_url)
   let $controlDigitsTotalQuantityPollutantRelease := xmlconv:controlDigitsTotalQuantityPollutantRelease($source_url)
   let $controlDigitsAccQuantityPollutantRelease := xmlconv:controlDigitsAccQuantityPollutantRelease($source_url)
   
   let $hasErrors :=  exists($control_PollulantRealese_pollulantCode) or
                      exists($control_PollulantRealese_methodUsed) or
                      exists($control_PollulantRelease_methodUsed_designation) or
                      exists($control_PollulantRelease_methodUsed_MethodUsedType) or
                      exists($control_ConfidentialCodePollutantRelease) or
                      exists($control_PollutantRelease_confidentialCode) or
                      exists($controlDuplicatePollutantReleases) or
                      exists($controlTotalQuantityPollutantRelease) or
                      exists($controlDigitsTotalQuantityPollutantRelease) or
                      exists($controlDigitsAccQuantityPollutantRelease)
   
   let $hasWarnings := false()
   return

    <div>
        <h3><br />{$xmlconv:errCodeCompliance}.4 Validation of Pollutant Releases</h3>
        {
        (:pollulant code contro:)
        xmlconv:buildcontrol_PollulantRealese_pollulantCode($control_PollulantRealese_pollulantCode)
        }
        {
        (:methodUsed control:)
        xmlconv:build_control_PollulantRealese_methodUsed($control_PollulantRealese_methodUsed)
        }
        {
        (:methodUsed_designation control:)
        xmlconv:build_control_PollulantRelease_methodUsed_designation($control_PollulantRelease_methodUsed_designation)
        }
        {
        (:MethodTypeCode WEIGH - Weighing selected:)
        xmlconv:build_control_PollulantRelease_methodUsed_MethodUsedType($control_PollulantRelease_methodUsed_MethodUsedType)
        }
        {
        (: confidential code :)
        xmlconv:build_control_ConfidentialCodePollutantRelease($control_ConfidentialCodePollutantRelease)
        }
        {
        (: confidentialcode only few options allowed:)
        xmlconv:build_control_PollutantRelease_confidentialCode($control_PollutantRelease_confidentialCode)
        }
        {
        (: pollutantCode for a given mediumCode:)
        xmlconv:build_controlDuplicatePollutantReleases($controlDuplicatePollutantReleases)
        }
        {
        (: accidentalQuantity cannot be more than totalQuantity:)
        xmlconv:build_controlTotalQuantityPollutantRelease($controlTotalQuantityPollutantRelease)
        }
        {
        (: totalQuantity ControlDigits and more than 0:)
        xmlconv:build_controlDigitsTotalQuantityPollutantRelease($controlDigitsTotalQuantityPollutantRelease)
        }
        {
        (: AccQuantity  ControlDigits and more than 0:)
        xmlconv:build_controlDigitsAccQuantityPollutantRelease($controlDigitsAccQuantityPollutantRelease)
        }
    </div>
    
};

(:==================================================================:)
(: QA2: Facility Reports:)
(:==================================================================:)
declare function xmlconv:controlOfFacility($source_url){
    let $duplicateList := xmlconv:controlDuplicateFacilityReports($source_url)
    let $illegalConfidentialCodeList := xmlconv:controlConfidentialCodeFacilityReport($source_url)
    
    let $hasErrors :=  exists($duplicateList) or
                       exists($illegalConfidentialCodeList)
    
    let $hasWarnings := false()
    
    return
    <div>
        <h3><br />{$xmlconv:errCodeCompliance}.2 Validation of Facility Reports</h3>
        
        {xmlutil:buildDescription("")}
        {xmlconv:buildResultMsg($hasErrors, $hasWarnings)}
    
        {
        (:Duplicate facilityReports:)
        xmlconv:buildDuplicateFacilityReport($duplicateList)
        }
        {
        (:Illegal confidential codes for facilityReports:)
        xmlconv:buildConfidentialCodeFacilityReport($illegalConfidentialCodeList)
        }
    
    </div>
};

(:==================================================================:)
(: QA1: Legal values:)
(:==================================================================:)
declare function xmlconv:controlOfLegalValueHandler($source_url){
     let $illegalReportingYear :=  xmlconv:illegalReportingYear($source_url)
     
     let $hasErrors :=  exists($illegalReportingYear)
     
     let $hasWarnings := false()
     return
     <div>

     <h3><br />{$xmlconv:errCodeCompliance}.1 Validation of Codes</h3> 
     
      {xmlutil:buildDescription("This validation examines if any codes are illegal according to the code lists.")}
      {xmlconv:buildResultMsg($hasErrors, $hasWarnings)}

      {
        xmlconv:buildIllegalReportingYear($illegalReportingYear) 
      }
    </div>

};

(:Builds a message section for an illegal code:)
(:$list is a list of illegal codes. The list should contain dublets as the number of occurrences will be counted:)
(:$codeName is the name of the code element, e.g MethodTypeCode:)
(:$codeUrl is the url of the list with legal values:)
declare function xmlconv:buildIllegalCodeMsg($list, $codeName, $codeUrl){
    let $header := concat("Illegal ", $codeName)
    let $descr := concat("Legal ", $codeName, " values can be found at: ", $codeUrl)
    let $tableHeader := "The following codes are not legal according to the code list:"
    let $error := concat("Illegal ", $codeName)

    let $colHeaders := ("Code", "No. of occurrences")
    let $tableRows := (for $elem in distinct-values($list) return xmlutil:buildTableRow(($elem,count($list[.=$elem])), $xmlutil:LEVEL_ERROR, 1, $xmlconv:errCodeCompliance))

    let $table := xmlutil:buildTable($xmlutil:LEVEL_ERROR, $error, $colHeaders, $tableRows)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};

(:==================================================================:)
(: Output messages  1:)
(:==================================================================:)



(:Duplicate for facilityReports:)
(:list is a sequence of facilityReport elements:)
declare function xmlconv:buildDuplicateFacilityReport($list){
    let $header := "Controlled for duplicates"
    let $descr := "A specific dBFacitilyID  of a facility is not allowed to be reported more than once."
    let $tableHeader := "The following duplicates were found:"
    let $table := xmlutil:buildTableFacilityReport($xmlutil:LEVEL_ERROR, "Duplicate dBFacitilyIDs", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};

(:Illegal confidential codes for facilityReports:)
declare function xmlconv:buildConfidentialCodeFacilityReport($list){
    let $header := "Controlled reason for confidentiality"
    let $descr := "When claiming confidentiality the reason must be reported. For non-confident facilities no reason must be reported."
    let $tableHeader := "The following errors in reported reason for confidentiality were found:"
    let $table := xmlutil:buildTableFacilityReport($xmlutil:LEVEL_ERROR, "Missing/Illegal ConfidentialCodes for facilityReport", $list, $xmlutil:COL_FR_ConfidentialCode, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};

(:wasteTreatmentCode NOt reported:)
declare function xmlconv:build_control_wasteTreatmentCode($list){
    let $header := "Controlled for not reported"
    let $descr := "When confidentialIndicator is false then wasteTreatmentCode must be reported"
    let $tableHeader := "The following errors in reported reason for confidentiality were found:"
    let $table := xmlutil:buildTableWasteTransfer($xmlutil:LEVEL_ERROR, "wasteTreatmentCode must be reported", $list, $xmlutil:COL_FR_ConfidentialCode, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
 };
 
 (:quantity NOt reported:)
 declare function xmlconv:build_control_quantity($list){
    let $header := "Controlled for not reported"
    let $descr := "When confidentialIndicator is false then WasteTransfer/quantity must be reported"
    let $tableHeader := "The following errors in reported reason for confidentiality were found:"
    let $table := xmlutil:buildTableWasteTransfer($xmlutil:LEVEL_ERROR, "WasteTransfer/quantity must be reported", $list, $xmlutil:COL_FR_ConfidentialCode, $xmlconv:errCodeCompliance)
    
    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
 };


(:Digits for quantity:)
declare function xmlconv:build_control_DigitsQuantityWasteTransfer($list){
    let $header := "Controlled reported digits of quantity"
    let $descr := "The quantity of a waste transfer must be reported with three significant digits."
    let $tableHeader := "The following waste transfers with illegal quantity were found:"
    let $table := xmlutil:buildTableWasteTransfer($xmlutil:LEVEL_ERROR, "WasteTransfer Digits quantity",$list,$xmlutil:COL_WT_Quantity, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};

(:methodBasisCode not reported:)
declare function xmlconv:build_control_methodBasisCode($list){
    let $header := "Controlled for not reported"
    let $descr := "When confidentialIndicator is false then WasteTransfer/methodBasisCode must be reported"
    let $tableHeader := "The following waste transfers with illegal quantity were found:"
    let $table := xmlutil:buildTableWasteTransfer($xmlutil:LEVEL_ERROR, "WasteTransfer methodBasisCode",$list,$xmlutil:COL_WT_Quantity, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};

(:methodUsed not reported:)
declare function xmlconv:build_control_methodUsed($list){
    let $header := "Controlled for not exists"
    let $descr := "When confidentialIndicator is false and  then WasteTransfer/methodBasisCode = C - Calculated or WasteTransfer/methodBasisCode = M - Measured  methodUsed must be reported"
    let $tableHeader := "The following waste transfers with illegal quantity were found:"
    let $table := xmlutil:buildTableWasteTransfer($xmlutil:LEVEL_ERROR, "WasteTransfer methodUsed",$list,$xmlutil:COL_WT_Quantity, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};

(:Designation not reported:)
declare function xmlconv:build_control_methodUsed_designation($list){
    let $header := "Controlled for not reported"
    let $descr := "When methodUsed/MethodTypeCode is CEN/ISO, ETS, IPCC or UNECE/EMEP  methodUsed/Designation must be reported"
    let $tableHeader := "The following waste transfers with illegal quantity were found:"
    let $table := xmlutil:buildTableWasteTransfer($xmlutil:LEVEL_ERROR, "WasteTransfer methodUsed",$list,$xmlutil:COL_WT_Quantity, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(:confidential not reported:)
declare function xmlconv:build_control_confidentialCode($list){
    let $header := "Controlled for not-reported or reported"
    let $descr := "Must be reported if element confidentialIndicator is True and empy if is False "
    let $tableHeader := "The following waste transfers with illegal quantity were found:"
    let $table := xmlutil:buildTableWasteTransfer($xmlutil:LEVEL_ERROR, "WasteTransfer methodUsed",$list,$xmlutil:COL_WT_Quantity, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(:WasteHandlerParty:)
declare function xmlconv:build_control_WasteHandlerParty($list){
    let $header := "Controlled for not-reported or reported"
    let $descr := "Must be reported if element confidentialIndicator is False and element wasteTypeCode is HWOC - Harzodous waste outside country and empty if wasteTypeCode is different "
    let $tableHeader := "The following waste transfers with illegal quantity were found:"
    let $table := xmlutil:buildTableWasteTransfer($xmlutil:LEVEL_ERROR, "WasteTransfer methodUsed",$list,$xmlutil:COL_WT_Quantity, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(:pollulant code control:)
declare function xmlconv:build_control_pollutantCode($list){
    let $header := "Controlled for bad reported in pollulant code"
    let $descr := " Must be a Pollutant group (GRHGAS, OTHGAS, HEVMET, PEST, CHLORG, OTHORG OR INORG) if confidentialIndicator is True and cannot bet a Pollutant group if confidentialIndicator is False"
    let $tableHeader := "The following Pollulant transfers with illegal quantity were found:"
    let $table := xmlutil:buildTablePollutantTransfer($xmlutil:LEVEL_ERROR, "PollulantTransfer pollulantCode",$list,$xmlutil:COL_PT_PollutantCode, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};

(:pollulant code duplicated:)
 declare function xmlconv:build_controlDuplicatePollutantTransfers($list){
    let $header := "Controlled for Duplicated PollulantCode"
    let $descr := "Same pollutantCode is not allowed more than once"
    let $tableHeader := "The following Pollulant transfers with illegal quantity were found:"
    let $table := xmlutil:buildTablePollutantTransfer($xmlutil:LEVEL_ERROR, "PollulantTransfer pollulantCode",$list,$xmlutil:COL_PT_PollutantCode, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
 };

(:methodUsed not reported:)
declare function xmlconv:build_control_PollulantTransfer_methodUseds($list){
    let $header := "Controlled NOT reported"
    let $descr := " Must be reported if element confidentialIndicator is False and element methodBasis is 'M - Measured' or 'C - Calculated'"
    let $tableHeader := "The following Pollulant transfers with illegal quantity were found:"
    let $table := xmlutil:buildTablePollutantTransfer($xmlutil:LEVEL_ERROR, "PollulantTransfer methodUsed",$list,$xmlutil:COL_PT_PollutantCode, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
 };
 
 (:MethodTypeCode WEIGH - Weighing selected:)
 declare function xmlconv:build_control_methodUsed_MethodUsedType($list){
    let $header := "Controlled MethodTypeCode WEIGH reported"
    let $descr := " 'WEIGH - Weighing' is not allowed"
    let $tableHeader := "The following Pollulant transfers with illegal quantity were found:"
    let $table := xmlutil:buildTablePollutantTransfer($xmlutil:LEVEL_ERROR, "PollulantTransfer MethodTypeCode",$list,$xmlutil:COL_PT_PollutantCode, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
 
 };
 
 (:Designation not reported:)
 declare function xmlconv:build_control_methodUsed_Pollulant_designation($list){
    let $header := "Controlled NOT reported"
    let $descr := "Must be reported if element methodUsed/MethodTypeCode is CEN/ISO, ETS, IPCC or UNECE/EMEP"
    let $tableHeader := "The following Pollulant transfers with illegal quantity were found:"
    let $table := xmlutil:buildTablePollutantTransfer($xmlutil:LEVEL_ERROR, "PollulantTransfer methodUsed/Designation",$list,$xmlutil:COL_PT_PollutantCode, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
 };
 
 (:confidentialCode bad reported:)
 declare function xmlconv:build_controlConfidentialCodePollutantTransfer($list){
    let $header := "Controlled bad reported"
    let $descr := "Must be reported if element confidentialIndicator is True and empy if is False"
    let $tableHeader := "The following Pollulant transfers with illegal quantity were found:"
    let $table := xmlutil:buildTablePollutantTransfer($xmlutil:LEVEL_ERROR, "PollulantTransfer confidentialCode",$list,$xmlutil:COL_PT_PollutantCode, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
 };
 
 (:control_DigitsQuantityPollulantTransfer:)
 declare function xmlconv:build_control_DigitsQuantityPollulantTransfer($list){
    let $header := "Controlled reported digits of quantity"
    let $descr := "ControlDigits and more than 0"
    let $tableHeader := "The following Pollulant transfers with illegal quantity were found:"
    let $table := xmlutil:buildTablePollutantTransfer($xmlutil:LEVEL_ERROR, "PollulantTransfer quantity",$list,$xmlutil:COL_PT_PollutantCode, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
 };
 
 (:pollulant code contro:)
 declare function xmlconv:buildcontrol_PollulantRealese_pollulantCode($list){
    let $header := "Controlled for bad reported in pollulant code"
    let $descr := "Must be a Pollutant group (GRHGAS, OTHGAS, HEVMET, PEST, CHLORG, OTHORG OR INORG) if confidentialIndicator is True and cannot bet a Pollutant group if confidentialIndicator is False"
    let $tableHeader := "The following Pollulant Release with illegal Pollutant code were found:"
    let $table := xmlutil:buildTablePollutantRelease($xmlutil:LEVEL_ERROR, "PollulantRelease pollulantCode",$list,$xmlutil:COL_PT_PollutantCode, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
 };
 
(:methodUsed control:)
 declare function xmlconv:build_control_PollulantRealese_methodUsed($list){
    let $header := "Controlled for bad reported methodUsed"
    let $descr := "Must be reported if element confidentialIndicator is False and element methodBasis is 'M - Measured' or 'C - Calculated'"
    let $tableHeader := "The following Pollulant Release with illegal Pollutant methodUsed were found:"
    let $table := xmlutil:buildTablePollutantRelease($xmlutil:LEVEL_ERROR, "PollulantRelease methodUsed",$list,$xmlutil:COL_PT_PollutantCode, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
 };
 
 (:methodUsed_designation control:)
 declare function xmlconv:build_control_PollulantRelease_methodUsed_designation($list){
    let $header := "Controlled NOT reported"
    let $descr := " Must be reported if element methodUsed/MethodTypeCode is CEN/ISO, ETS, IPCC or UNECE/EMEP"
    let $tableHeader := "The following Pollulant Release with illegal Pollutant methodUsed/Designation were found:"
    let $table := xmlutil:buildTablePollutantRelease($xmlutil:LEVEL_ERROR, "PollulantRelease methodUsed/Designation",$list,$xmlutil:COL_PT_PollutantCode, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
 };
 
  (:MethodTypeCode WEIGH - Weighing selected:)
  declare function xmlconv:build_control_PollulantRelease_methodUsed_MethodUsedType($list){
    let $header := "Controlled bad reported"
    let $descr := " WEIGH - Weighing is not allowed"
    let $tableHeader := "The following Pollulant Release with illegal Pollutant methodUsed/MethodTypeCode were found:"
    let $table := xmlutil:buildTablePollutantRelease($xmlutil:LEVEL_ERROR, "PollulantRelease methodUsed/MethodTypeCode",$list,$xmlutil:COL_PT_PollutantCode, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
  };
  
(: confidential code :)
declare function xmlconv:build_control_ConfidentialCodePollutantRelease($list){
    let $header := "Controlled NOT reported"
    let $descr := " Must be reported if element confidentialIndicator is True and empy if is False"
    let $tableHeader := "The following Pollulant Release with illegal Pollutant confidentialCode were found:"
    let $table := xmlutil:buildTablePollutantRelease($xmlutil:LEVEL_ERROR, "PollulantRelease confidentialCode",$list,$xmlutil:COL_PT_PollutantCode, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};

(: confidentialcode only few options allowed:)
declare function xmlconv:build_control_PollutantRelease_confidentialCode($list){
    let $header := "Controlled bad reported"
    let $descr := " Only Article 4(2)(b), ( c ) and ( e ) are allowed"
    let $tableHeader := "The following Pollulant Release with illegal Pollutant confidentialCode were found:"
    let $table := xmlutil:buildTablePollutantRelease($xmlutil:LEVEL_ERROR, "PollulantRelease confidentialCode",$list,$xmlutil:COL_PT_PollutantCode, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};

(: pollutantCode for a given mediumCode:)
declare function xmlconv:build_controlDuplicatePollutantReleases($list){
    let $header := "Controlled bad reported"
    let $descr := " Same pollutantCode is not allowed for a given medium"
    let $tableHeader := "The following Pollulant Release with illegal Pollutant pollutantCode were found:"
    let $table := xmlutil:buildTablePollutantRelease($xmlutil:LEVEL_ERROR, "PollulantRelease pollutantCode",$list,$xmlutil:COL_PT_PollutantCode, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: accidentalQuantity cannot be more than totalQuantity:)
declare function xmlconv:build_controlTotalQuantityPollutantRelease($list){
    let $header := "Controlled bad reported"
    let $descr := "accidentalQuantity cannot be more than totalQuantity"
    let $tableHeader := "The following Pollulant Release with illegal Pollutant accidentalQuantity were found:"
    let $table := xmlutil:buildTablePollutantRelease($xmlutil:LEVEL_ERROR, "PollulantRelease accidentalQuantity",$list,$xmlutil:COL_PT_PollutantCode, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
}; 

 
(: totalQuantity ControlDigits and more than 0:)
declare function xmlconv:build_controlDigitsTotalQuantityPollutantRelease($list){
    let $header := "Controlled bad reported"
    let $descr := "totalQuantity ControlDigits and more than 0"
    let $tableHeader := "The following Pollulant Release with illegal Pollutant totalQuantity were found:"
    let $table := xmlutil:buildTablePollutantRelease($xmlutil:LEVEL_ERROR, "PollulantRelease totalQuantity",$list,$xmlutil:COL_PT_PollutantCode, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
        
(: AccQuantity  ControlDigits and more than 0:)
declare function xmlconv:build_controlDigitsAccQuantityPollutantRelease($list){
    let $header := "Controlled bad reported"
    let $descr := "accidentalQuantity ControlDigits and more than 0"
    let $tableHeader := "The following Pollulant Release with illegal Pollutant accidentalQuantity were found:"
    let $table := xmlutil:buildTablePollutantRelease($xmlutil:LEVEL_ERROR, "PollulantRelease accidentalQuantity",$list,$xmlutil:COL_PT_PollutantCode, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};

(:==================================================================:)
(: Output messages  2:)
(:==================================================================:)              
declare function xmlconv:f_buildWasteTransferErrorMessage($elems, $error){
    for $elem in $elems
    return
    <li style="list-style-type:none"><b>{concat($elem/rsm:wasteTypeCode, '/', $elem/rsm:wasteTreatmentCode, ': ')} </b> {$error}</li>
};      

declare function xmlconv:f_buildPollutantReleaseErrorMessage($elems, $error){
    for $elem in $elems
    return
    (:<li><b>{concat($elem/rsm:MediumCode, '/' , $elem/rsm:PollutantCode , ': ')}</b>{$error}</li>:)
    <li style="list-style-type:none"> <b> {$elem/rsm:mediumCode} {'/'} {$elem/rsm:pollutantCode} {': '} </b> {$error} </li>
};

declare function xmlconv:f_buildPollutantTransferErrorMessage($elems, $error){
    for $elem in $elems
    return
    <li style="list-style-type:none"><b>{concat($elem/rsm:pollutantCode , ': ')} </b> {$error}</li>
};

declare function xmlconv:f_buildilegalYears($elems,$error){
    for $elem in $elems
    return
    <li style="list-style-type:none"><b>{ $elem} </b> {$error}</li>
};

declare function xmlconv:f_buildErrorMessage($error){
    <li style="list-style-type:none">{$error}</li>
};  
(:==================================================================:)
(: Output messages for illegal formats :)
(:==================================================================:)

(:Builds a message section for illegal reporting year:)
declare function xmlconv:buildIllegalReportingYear($list){
    let $header := "Illegal Reporting year"
    let $descr := "The reporting year can not be later than current year or diferent to envelope Year"
    let $tableHeader := "The following reporting years are not legal:"
    let $error := "Illegal Reporting year"

    let $colHeaders := ("Reporting year")

    let $tableRows := (for $elem in distinct-values($list) return xmlutil:buildTableRow($elem, $xmlutil:LEVEL_ERROR, 1, $xmlconv:errCodeCompliance))

    let $table := xmlutil:buildTable($xmlutil:LEVEL_ERROR, $error, $colHeaders, $tableRows)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};






(:==================================================================:)
(: Output messages for illegal formats :)
(:==================================================================:)

(:Builds a message section for illegal reporting year:)
declare function xmlconv:buildResultMsg($hasErrors, $hasWarnings){
 if($hasErrors = true()) then
     xmlutil:buildDescription($xmlutil:LEVEL_ERROR, "The test failed!")
 else if( $hasWarnings = true()) then
     xmlutil:buildDescription($xmlutil:LEVEL_WARNING, "The test passed with warnings.")
 else
     xmlutil:buildDescription($xmlutil:LEVEL_INFO, "The test passed successfully.")
 };

declare function xmlconv:checkEnvelope($source_url as xs:string)
as element(div)
{
   let $envYear := xmlutil:getEnvelopeYear($source_url)
   let $deliveryYear := doc($source_url)//rsm:LCPandPRTR/rsm:reportingYear

   return
   if (normalize-space($envYear) = normalize-space($deliveryYear)) then
   <div>
    {xmlutil:buildSuccessfulMessage()}
   </div>
   else
    <div errorcode='{$xmlconv:errCodeEnvelope}'>
        {xmlconv:buildResultMsg(fn:true(), fn:false())}
        The delivery year ({$deliveryYear}) is different from the envelope year ({$envYear}).
    </div>

};

(:==================================================================:)
(: QA: Main function:)
(:==================================================================:)

declare function xmlconv:checkCompliance($source_url as xs:string) {
<div>

    {xmlutil:buildValidatedFile($source_url)}

    <h2><br /><a name='1'>1. XML Schema Validation</a></h2>
    {if (xmlutil:isLocalFile($source_url)) then
        xmlutil:buildDescription($xmlutil:LEVEL_INFO, "The test is skipped in Validation Tool. XML Schema validation is done separately and if the result contains any errors, then data delivery is not acceptable.")
     else
        xmlconv:validateXmlSchema($source_url)
    }

    <h2><br/><a name='{$xmlconv:errCodeEnvelope}'>2. Envelope Validation</a></h2>
    {
    if (xmlutil:isLocalFile($source_url)) then
        xmlutil:buildDescription($xmlutil:LEVEL_INFO, "The test is skipped in Validation Tool. Envelope validation will be done after uploading the delivery to CDR.")
    else
        xmlconv:checkEnvelope( $source_url)
    }

    <h2><br /><a name='3'>3. Compliance Validation</a></h2>
    {xmlconv:controlOfLegalValueHandler($source_url) }

    {xmlconv:controlOfFacility($source_url) }

   
    {xmlconv:controlOfPollutantRelease($source_url) }

    {xmlconv:controlOfPollutantTransfer($source_url) }

    {xmlconv:controlOfWasteTransfer($source_url) }

    <h2><br/><a name='4'>4. Compliance Validation sorted by facilities</a></h2>
    {xmlconv:FacilityCompilance( $source_url)}
</div>

(:

:)
};


declare function xmlconv:proceed($source_url) {

let $potentialComplianceErrors := xmlconv:checkCompliance($source_url)

let $hasErrors := count($potentialComplianceErrors//*[@errorcode]) >0

return

<div class="feedbacktext" style="font-size:13px;">
<script language="javascript">
    function toggle(divName, linkName) {{
        var elem = document.getElementById(divName);
        var text = document.getElementById(linkName);
        if(elem.style.display == "block") {{
            elem.style.display = "none";
            text.innerHTML = "Show details";
        }}
        else {{
            elem.style.display = "block";
            text.innerHTML = "Hide details";
        }}
        }}
</script>
    <h1>E-PRTR - Mandatory check </h1>
    <p>{if (not($hasErrors)) then
          $xmlconv:CHECKS_PASSED_FEEDBACK_MESSAGE union xmlconv:buildOKBulet()
         else
          $xmlconv:CHECKS_FAILED_FEEDBACK_MESSAGE union $xmlconv:CHECKS_FAILED_TEXT}</p>
    <a id='feedBackLink' href='javascript:toggle("feedBackDiv","feedBackLink")'>{if (not($hasErrors)) then 'Show details' else 'Hide details'}</a>
    <div id="feedBackDiv" style="display:{if ($hasErrors) then 'block' else 'none'}">
    <div>
    {
        xmlutil:buildDescription("The following validations are meant to help the member states to evaluate if all mandatory data is correct. The validation detects missing or incorrect mandatory data by analysing the reported values using 3 different methods:")}
        <ul>{
           xmlutil:buildRuleContentLinks($potentialComplianceErrors//div[string-length(@errorcode) > 0]/@errorcode, xmlconv:getRules()//rule)
           }
        </ul>
    </div>
    {$potentialComplianceErrors
    }
    </div>
</div>

};


declare function xmlconv:getRules()
as element(rules)
{
<rules>
    <rule code="{ $xmlconv:errCodeXmlSchema }">
        <title>XML Schema Validation</title>
        <descr>The test checks if the document delivered conforms to the data model defined in the XML Schema for this data flow. The XML Schema data model specifies the element names, document structure and data types.</descr>
        <message></message>
        <errLevel>{if (xmlutil:isLocalFile($source_url)) then $xmlutil:LEVEL_NONE else $xmlutil:LEVEL_ERROR}</errLevel>
    </rule>
    <rule code="{ $xmlconv:errCodeEnvelope }">
        <title>Envelope Validation</title>
        <descr>checks if the delivery data corresponds with envelope data</descr>
        <message></message>
        <errLevel>{if (xmlutil:isLocalFile($source_url)) then $xmlutil:LEVEL_NONE else $xmlutil:LEVEL_ERROR}</errLevel>
    </rule>
    <rule code="{ $xmlconv:errCodeCompliance }">
        <title>Compliance Validation</title>
        <descr>the reported value is indicated as potential not compliant value.</descr>
        <message></message>
        <errLevel>{$xmlutil:LEVEL_ERROR}</errLevel>
    </rule>
    <rule code="{ $xmlconv:errCodeComplianceFacility }">
        <title>Compliance Validation sorted by facilities</title>
        <descr>the reported value is indicated as potential not compliant value.</descr>
        <message></message>
        <errLevel>{$xmlutil:LEVEL_ERROR}</errLevel>
    </rule>
  </rules>
};

(: FACILITIES SCRIPT <<START>> :)
(:==================================================================:)
(:Facility reports  - Find Facility                                                                                     :)
(:==================================================================:)

(:Returns a list of Facility elements:)


declare function xmlconv:f_findFacility($source_url){

   for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:FacilityReports/rsm:FacilityReport
      let $National := $elems/rsm:dBFacitilyID
     
      let $illegalReportingValues :=  xmlconv:f_controlOfLegalValueHandler($elems)
      let $controlOfFacility :=  xmlconv:f_controlOfFacility($elems)
      let $controlOfPollutantResease := xmlconv:f_controlOfPollutantRelease($elems)
      let $controlOfPollutantTransfer := xmlconv:f_controlOfPollutantTransfer($elems)
      let $controlOfWasteTransfer :=xmlconv:f_controlOfWasteTransfer($elems)

        return
        if ($illegalReportingValues != "" or $controlOfFacility != "" or $controlOfPollutantResease != "" or $controlOfPollutantTransfer != "" or $controlOfWasteTransfer != "") then
        (
          <tr>
            <td>{$National}</td>
            
            <td style="color:red">{xmlutil:buildErrorElementNotEmpty($xmlconv:errCodeComplianceFacility, $illegalReportingValues)}</td>
            <td style="color:red">{xmlutil:buildErrorElementNotEmpty($xmlconv:errCodeComplianceFacility, $controlOfFacility)}</td>
            <td style="color:red">{xmlutil:buildErrorElementNotEmpty($xmlconv:errCodeComplianceFacility, $controlOfPollutantResease)}</td>
            <td style="color:red">{xmlutil:buildErrorElementNotEmpty($xmlconv:errCodeComplianceFacility, $controlOfPollutantTransfer)}</td>
            <td style="color:red">{xmlutil:buildErrorElementNotEmpty($xmlconv:errCodeComplianceFacility, $controlOfWasteTransfer)}</td>
          </tr>
          )
          else
             ()
};



(:==================================================================:)
(: QA1: Facility reports                                            :)
(:==================================================================:)

declare function xmlconv:FacilityCompilance($source_url as xs:string) {

     let $Facility :=  xmlconv:f_findFacility( $source_url)

     let $result :=
     if ($Facility != "") then
    (
    <div>
        {xmlconv:buildResultMsg(fn:true(), fn:false())}
      <table border="1" style="font-size:11px;" class="datatable">
      <tr>
        <th rowspan="2" width="5%">National ID</th>
       
        <th rowspan="2" width="12.5%">(1) Codes</th>
        <th rowspan="2" width="12.5%">(2) Facility Reports</th>
        <th rowspan="2" width="12.5%">(3) PollutantReleases</th>
        <th rowspan="2" width="12.5%">(4) Pollutant Transfers</th>
        <th rowspan="2" width="12.5%">(5) WasteTransfers</th>
      </tr>
      <tr>
   
      </tr>
        {xmlconv:f_findFacility( $source_url)}
      </table>
    </div>
  )
  else (xmlutil:buildDescription($xmlutil:LEVEL_INFO, "The test passed successfully."))


  return
 <div style="font-size:13px;">
    <p>This report shows the results of the validation rules for compliance checking as indicated in the validation manual available at <a href="http://www.eionet.europa.eu/schemas/eprtr/">http://www.eionet.europa.eu/schemas/eprtr/</a>
    The code lists for E-PRTR are available at the same address.</p>
    <p><a href="javascript:toggle('facilityInfoDiv', 'facilityInfoLink')" id="facilityInfoLink" title='Click to see interpretation of columns'>Show Details</a></p>
    <div id='facilityInfoDiv' style='display:none'>

    <p><b>(1) Codes:</b> The only allowed codes are those provided by the Code List (available in EIONET). This compliance validation examines if any codes are illegal according to the code lists. In particular, the validation checks the reporting year and if the code used for the following aspects belongs to the code list:
      <ul style="margin-top:0px;">
        <li>Activity codes according to annex 1, confidentiality codes, country ID, medium codes, method codes, NACE codes, region (NUTS) codes, pollutant codes, River Basin District codes, unit codes, waste treatment codes and waste type codes </li>
      </ul></p>

    <p><b>(2) Facility Reports:</b> This compliance validation examines if any mandatory field of the facility report is missing or wrongly reported. In particular, the validation checks if:
      <ul style="margin-top:0px;">
        <li>the reported competent authority is present in the 'authority list'.</li>
        <li>there is any facility report with no activities reported, with no main activity reported, with duplicated activities and/or with more than one main activity.</li>
        <li>there is any mandatory field for non-confidential facilities which is missing.</li>
        <li>the URL of the website facility is reported in a wrong format</li>
        <li>confidential codes are missing or wrongly attributed</li>
      </ul></p>

    <p><b>(3) Pollutant Releases:</b> This compliance validation examines if:
      <ul style="margin-top:0px;">
        <li>releases or transfer belong to the right group code control</li>
        <li>3-digit rules are properly followed</li>
        <li>total quantities are greater than accidental quantities</li>
        <li>all mandatory data for non-confidential releases is reported</li>
        <li>the method designation is reported according to the rules</li>
        <li>methods are reported according to the code list</li>
        <li>any pollutant is reported more than once</li>
        <li>confidential codes are used according to the rules </li>
      </ul></p>

    <p><b>(4) Pollutant Transfers:</b> This compliance validation examines if:
      <ul style="margin-top:0px;">
        <li>releases or transfer belong to the right group code control</li>
        <li>digit rules are properly followed</li>
        <li>the method designation is reported according to the rules</li>
        <li>methods are reported according to code list</li>
        <li>any pollutant is reported more than once</li>
        <li>confidential codes are used according to the rules </li>
      </ul></p>

    <p><b>(5) Waste Transfers:</b> This compliance validation examines if:
      <ul style="margin-top:0px;">
        <li>any transfer of HWOC has a waste handler</li>
        <li>any non-confidential waste transfer has all mandatory data</li>
        <li>digit rules are properly followed</li>
        <li>confidential codes are used according to the rules </li>
      </ul></p>
      </div>
    </div>
union
    $result

};
(: FACILITIES SCRIPT <<END>> :)

declare function xmlconv:validateXmlSchema($source_url)
{
    let $fullUrl := concat($xmlconv:xmlValidatorUrl, fn:encode-for-uri($source_url))
    let $validateResult := doc($fullUrl)

    let $hasErrors := count($validateResult//*[name()="tr"]) > 1
    let $hasWarnings := count($validateResult//*[name()="p" and starts-with(text(), 'OK') ]) = 0

    let $result := xmlconv:addErrorCodeToElem($validateResult, "td", $xmlconv:errCodeXmlSchema, $hasWarnings)

    return
        <div>
        {xmlconv:buildResultMsg($hasErrors, $hasWarnings)}
        {$result}
        </div>
(:
        $validateResult
    for $row in $validateResult//tr
    return
        <div errorcode='1'>{$row}</div>

    return

 :)

};
declare function xmlconv:buildOKBulet() {
        <span><span style="background-color: green; font-size: 0.8em; color: white; padding-left:7px;padding-right:7px;text-align:center">OK</span> All mandatory checks have passed. Data delivery is acceptable.</span>
};

(:
: message that informs the rules are not checked if local tool
:)
declare function xmlconv:buildNotLocalMessage() {
    xmlutil:buildDescription($xmlutil:LEVEL_INFO, "The test passed successfully.")
};

declare function xmlconv:test($url) {

let $testElem := <test>s</test>


    let $fullUrl := concat($xmlconv:xmlValidatorUrl, $source_url)
    let $testElem :=
     doc($fullUrl)

  return
  xmlconv:addErrorCodeToElem($testElem, "td", '1', fn:true())

};

 declare function xmlconv:addErrorCodeToElem($element, $elemName as xs:string, $errorCode as xs:string, $hasTechErrors as xs:boolean)
 {

  if (lower-case($element/name())=$elemName and
    (upper-case($element/text()) = 'ERROR' or upper-case($element/text()) = 'WARNING')
  )  then
  element {$elemName}{attribute {'style'}{concat("color:", xmlutil:getErrorColor(if(upper-case($element/text())='ERROR') then $xmlutil:LEVEL_ERROR else $xmlutil:LEVEL_WARNING ))},  element div {attribute errorcode {$errorCode},  $element/text()  }}
  else if ($element/name() = 'h2') then
  ()
  else if ($element/name() = 'p' and starts-with($element/text(), "OK")) then
  ()
  else if (not(empty(node-name($element)))) then
  element {node-name($element)}
               {$element/@*,
                for $child in $element/node()
                return
                    if ($child instance of element()) then
                        xmlconv:addErrorCodeToElem($child, $elemName, $errorCode, fn:false())
                    else
                        $child
                }
   else
   (: root node is empty :)
         element {"div"}
               {if ($hasTechErrors) then attribute errorcode {$errorCode} else (), $element/@*,
                for $child in $element/node()
                return
                    if ($child instance of element()) then
                        xmlconv:addErrorCodeToElem($child, $elemName, $errorCode, fn:false())
                    else
                        $child
                }
};

xmlconv:proceed( $source_url )

(:
xmlconv:test($source_url):)
