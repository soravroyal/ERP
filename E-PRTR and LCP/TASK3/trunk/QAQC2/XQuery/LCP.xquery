(:  ======================================================================  :)
(:  =====      LCP BATCH 1 CHECK                               =====  :)
(:  ======================================================================  :)
(:
    This XQuery contains a number of validations of LCP reports to ensure
    compliance with the Guidance Document. As a main rule errors found will
    prevent data from being stored in the database.

    XQuery agency:  The European Commission
    XQuery version: 2.5
    Created:    2012-09-05
    Revision:       $Id$
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

declare variable $xmlconv:CHECKS_FAILED_TEXT :=
    <div style="color:red"><b>LCP... check(s) FAILED. Data delivery is not acceptable. Errors found prevent data being imported to LCP database.</b></div>;
declare variable $xmlconv:CHECKS_FAILED_FEEDBACK_MESSAGE :=
    <span id="feedbackStatus" class="BLOCKER" style="display:none">LCP... check(s) FAILED. Data delivery is not acceptable. Errors found prevent data being imported to LCP database.</span>;

declare variable $xmlconv:CHECKS_PASSED_FEEDBACK_MESSAGE :=
    <span id="feedbackStatus" class="INFO" style="display:none">All LCP... checks have passed. Data delivery is acceptable.</span>;

    
 (: Error codes :)

declare variable $xmlconv:errCodeCompliance := "1";
declare variable $xmlconv:errCodeCompliancePlantReport := "2";
declare variable $xmlconv:errCodeEnvelope := "3";   

(:==================================================================:)
(: Functions:)
(:==================================================================:)

(: for multiply the fuel quantity per his enum SO2:)
declare function xmlconv:multiplyWithEnumSO2($type as xs:string, $quantity2 as xs:double){
    let $num := 0
    let $quantity := $quantity2
    return if($type = 'Biomass')then(
        $quantity * 0.0084 
    )else if($type = 'HardCoal')then(
        $quantity * 0.3463
    )else if($type = 'Lignite')then(
        $quantity * 0.3463
    )else if($type = 'LiquidFuels')then(
        $quantity * 0.1999
    )else if($type = 'NaturalGas')then(
        $quantity * 0.0007
    )else if($type = 'OtherGases')then(
        $quantity * 0.0111
    )else if($type = 'OtherSolidFuels')then(
        $quantity * 0.3463
    )else if($type = 'Peat')then(
        $quantity * 0.1157
    )else()
};

declare function xmlconv:multiplyWithEnumSO2($elems){
    let $num := 0
    for $i at $pos in $elems
        let $num := xmlconv:multiplyWithEnumSO2($i/rsm:type,$i/rsm:quantity)
        return if($pos >= count($elems)-1)then(
            $num
        )else()
};

(: for multiply the fuel quantity per his enum NOx:)
declare function xmlconv:multiplyWithEnumNOx($type as xs:string, $quantity2 as xs:double){
    let $num := 0
    let $quantity := $quantity2
    return if($type = 'Biomass')then(
        $quantity * 0.0703 
    )else if($type = 'HardCoal')then(
        $quantity * 0.1087
    )else if($type = 'Lignite')then(
        $quantity * 0.1087
    )else if($type = 'LiquidFuels')then(
        $quantity * 0.1108
    )else if($type = 'NaturalGas')then(
        $quantity * 0.0297
    )else if($type = 'OtherGases')then(
        $quantity * 0.0369
    )else if($type = 'OtherSolidFuels')then(
        $quantity * 0.1598
    )else if($type = 'Peat')then(
        $quantity * 0.1157
    )else()
};

declare function xmlconv:multiplyWithEnumNOx($elems){
    let $num := 0
    for $i at $pos in $elems
        let $num := xmlconv:multiplyWithEnumNOx($i/rsm:type,$i/rsm:quantity)
        return if($pos >= count($elems)-1)then(
            $num
        )else()
};


(: for multiply the fuel quantity per his enum DUST:)
declare function xmlconv:multiplyWithEnumDust($type as xs:string, $quantity2 as xs:double){
    let $num := 0
    let $quantity := $quantity2
    return if($type = 'Biomass')then(
        $quantity * 0.0042 
    )else if($type = 'HardCoal')then(
        $quantity * 0.0109
    )else if($type = 'Lignite')then(
        $quantity * 0.0109
    )else if($type = 'LiquidFuels')then(
        $quantity * 0.0089
    )else if($type = 'NaturalGas')then(
        $quantity * 0.0006
    )else if($type = 'OtherGases')then(
        $quantity * 0.0007
    )else if($type = 'OtherSolidFuels')then(
        $quantity * 0.0202
    )else if($type = 'Peat')then(
        $quantity * 0.0077
    )else()
};

declare function xmlconv:multiplyWithEnumDust($elems){
    let $num := 0
    for $i at $pos in $elems
        let $num := xmlconv:multiplyWithEnumDust($i/rsm:type,$i/rsm:quantity)
        return if($pos >= count($elems)-1)then(
            $num
        )else()
};

(: Sum all the elems:)
declare function xmlconv:totalSum($elems){
    let $total := sum($elems)
    return $total
};

(:Controls if a string has three significant digits. :)
(:Returns the value if not ok otherwise an empty sequence:)
declare function xmlconv:ControlDigits($value as xs:string)
  {
       if( starts-with($value,"0") = true()  and contains($value,".") = true() and  $value !="0.00" and string-length(
             xmlconv:RemoveLeftZeros(xmlconv:RemoveDot($value)) ) != 3  ) then
           $value
      else  if( starts-with($value,"0") = false()  and  contains($value,".") = false()  and string-length( $value) > 3  and (substring($value,4) castable as xs:double) and
        (substring($value,4)castable as xs:double) > 0)then
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
  (: called in xmlconv:ControlDigits:)
  declare function xmlconv:RemoveDot($string as xs:string)
  {
        if( contains($string,".") )   then
             concat (substring-before($string,"."),substring-after($string,".")  )
         else
              $string
  };
  (: called in xmlconv:ControlDigits:)
  declare function xmlconv:RemoveLeftZeros($s as xs:string){

     if(starts-with($s,"0") = true()  and string-length($s) >0 ) then
           xmlconv:RemoveLeftZeros(substring($s,2) )
       else
          $s
  };
  
(: Total of Plantype/thermalInput :)
declare function xmlconv:get_Plantype_thermalInput_per_PLantREport($plantReport){
    let $total := 0
    let $i := $plantReport/rsm:PlantType/rsm:thermalInput/p:Quantity
    let $total := xmlconv:totalSum($i)
    return 
        $total
    
};

(: Total of EnergyInput/quantity :)
declare function xmlconv:get_EnergyInput_quantity_per_PLantREport($plantReport){
    let $total := 0
    let $i := $plantReport/rsm:EnergyInput/rsm:quantity
    let $total :=xmlconv:totalSum($i)
    return 
        $total
    
};

(:==================================================================:)
(: Xquerys:)
(:==================================================================:)


(: #1 Conditional check: Must be 'Art 30(2) - existing plants under IED' if dateOfStartOperation is before 07.01.2014 and 'Art 30(3) - new plants under IED' if it is after :)
declare function xmlconv:control_statusOFthePlant($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
    return if (($i/rsm:dateOfStartOperation < '2014-01-07' or $i/rsm:dateOfStartOperation = '2014-01-07') and $i/rsm:statusOfThePlant !='Art 30(2) - existing plants under IED')then(
        $i
    )else if($i/rsm:dateOfStartOperation > '2014-01-07' and $i/rsm:statusOfThePlant !='Art 30(3) - new plants under IED')then(
        $i
    )else()
};

(: #2 Element check: If rated thermal input is  below 50 MWth (< 50 MWth) return PlantReport:)
declare function xmlconv:control_thermalInput($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
    return if($i/rsm:PlantType/rsm:thermalInput[p:Quantity < '50.0'] )then(
        $i
    )else()
};

(: #3 Element check: If rated thermal input is greater than 8500 MWth (> 8500 MWth) return PlantReport:)
declare function xmlconv:control_thermalInput_great($source_url){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
    return if($i/rsm:PlantType/rsm:thermalInput[p:Quantity > '8500.0'] )then(
        $i
    )else()
};

(: #4 The ratio of fuel input/thermal input cannot be larger than 35 TJ / (MW yr) return PlantReport:)
declare function xmlconv:control_EnergyInput_quantity($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
        let $thermalInput := xmlconv:get_Plantype_thermalInput_per_PLantREport($i)
        let $quantity := xmlconv:get_EnergyInput_quantity_per_PLantREport($i)
        return if($thermalInput != 0 and ($quantity div $thermalInput) > 35)then(
            $i
        )else()
};

(: #5 Conditional check: Must be greater than 50 (>= 50) if extensionBy50MWOrMore is True return PlantReport :)
declare function xmlconv:control_capacityAddedMW($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport[rsm:extensionBy50MWOrMore = 'true']
        return if($i/rsm:capacityAddedMW/p:Quantity < 50)then(
            $i
        )else()

};

(: #6 Conditional check: Must be greater than 0 (> 0) if substantialChange is True return PlantReport :)
declare function xmlconv:control_capacityAffectedMW($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport[rsm:substantialChange = 'true']
        return if($i/rsm:capacityAffectedMW[p:Quantity = 0.0] )then(
            $i
        )else()

};

(: #7 The total emission to air for SO2 cannot be more than 5 times the estimated emission return PlantReport:)
declare function xmlconv:control_TotalEmissionsToAir_quantity_1($source_url as xs:string){
     let $fuel := 0
     for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
        let  $totalEmisions := xmlconv:totalSum($i/rsm:TotalEmissionsToAir[rsm:type = 'SO2']/rsm:quantity)
        let $fuel := xmlconv:multiplyWithEnumSO2($i//rsm:EnergyInput)
        return if(count($i/rsm:TotalEmissionsToAir[rsm:type = 'SO2']/rsm:quantity) != 0 and $totalEmisions > 5 * sum($fuel) and count(doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport/rsm:EnergyInput[rsm:type != 'NaturalGas']) > 0) then(
            $i
        )else()
};

(: #8 The total emission to air for SO2 cannot be more than 50 times less than the estimated emission :)
declare function xmlconv:control_TotalEmissionsToAir_quantity_2($source_url as xs:string){
     let $fuel := 0
     for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
        let  $totalEmisions := xmlconv:totalSum($i/rsm:TotalEmissionsToAir[rsm:type = 'SO2']/rsm:quantity)
        let $fuel := xmlconv:multiplyWithEnumSO2($i//rsm:EnergyInput)
        return if(count($i/rsm:TotalEmissionsToAir[rsm:type = 'SO2']/rsm:quantity) != 0 and $totalEmisions <  sum($fuel) div 50 and count(doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport/rsm:EnergyInput[rsm:type != 'NaturalGas']) > 0) then(
            $i
        )else()
};

(: #9 The total emission to air for NOx cannot be more than 15 times the estimated emission :)
declare function xmlconv:control_TotalEmissionsToAir_quantity_3($source_url as xs:string){
    let $fuel := 0
     for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
        let  $totalEmisions := xmlconv:totalSum($i/rsm:TotalEmissionsToAir[rsm:type = 'NOx']/rsm:quantity)
        let $fuel := xmlconv:multiplyWithEnumNOx($i/rsm:EnergyInput)
        return if(count($i/rsm:TotalEmissionsToAir[rsm:type = 'NOx']/rsm:quantity) != 0 and $totalEmisions > 15 * sum($fuel)) then(
            $i
        )else()
};

(: #10 The total emission to air for NOx cannot be more than 7 times less than the estimated emission :)
declare function xmlconv:control_TotalEmissionsToAir_quantity_4($source_url as xs:string){
    let $fuel := 0
     for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
        let  $totalEmisions := xmlconv:totalSum($i/rsm:TotalEmissionsToAir[rsm:type = 'NOx']/rsm:quantity)
        let $fuel := xmlconv:multiplyWithEnumNOx($i/rsm:EnergyInput)
        return if(count($i/rsm:TotalEmissionsToAir[rsm:type = 'NOx']/rsm:quantity) != 0 and $totalEmisions <  sum($fuel) div 7) then(
            $i
        )else()
};

(: #11 The total emission to air for Dust cannot be more than 15 times the estimated emission :)
declare function xmlconv:control_TotalEmissionsToAir_quantity_5($source_url as xs:string){
    let $fuel := 0
     for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
        let  $totalEmisions := xmlconv:totalSum($i/rsm:TotalEmissionsToAir[rsm:type = 'Dust']/rsm:quantity)
        let $fuel := xmlconv:multiplyWithEnumDust($i/rsm:EnergyInput)
        return if(count($i/rsm:TotalEmissionsToAir[rsm:type = 'Dust']/rsm:quantity) != 0 and $totalEmisions > 15 * sum($fuel)) then(
            $i
        )else()
};

(: #12 The total emission to air for Dust cannot be more than 100 times less than the estimated emission :)
declare function xmlconv:control_TotalEmissionsToAir_quantity_6($source_url as xs:string){
    let $fuel := 0
     for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
        let  $totalEmisions := xmlconv:totalSum($i/rsm:TotalEmissionsToAir[rsm:type = 'Dust']/rsm:quantity)
        let $fuel := xmlconv:multiplyWithEnumDust($i/rsm:EnergyInput)
        return if(count($i/rsm:TotalEmissionsToAir[rsm:type = 'Dust']/rsm:quantity) != 0 and $totalEmisions <  sum($fuel) div 100) then(
            $i
        )else()
};

(: #28 Element check: operationsHours cannot exceed 8760 hours/year :)
declare function xmlconv:control_operationsHours_1($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
        return if($i/rsm:operationHours > 8760)then(
            $i
        )else()
};

(: #29 Element check: controlDigits and more than 0 :)
declare function xmlconv:control_operationsHours_2($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
        let $hours := xmlconv:ControlDigits($i/rsm:operationHours)
        return if($hours != '')then(
            $i
        )else()
};

(: #31 Element check: Same type is not allowed more than once for a PlantReport :)
declare function xmlconv:control_EmisionToAir_type($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
        for $ii in $i/rsm:TotalEmissionsToAir/rsm:type
        let $iii := $i/rsm:TotalEmissionsToAir[rsm:type = $ii]
            return if(count($iii) > 1)then(
                $i
            )else()
};

(: #32 TotalEmissionsToAir quantity controlDigits :)
declare function xmlconv:control_totalEmissionsToAir_quantity_controlDigits($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
        for $ii in $i/rsm:TotalEmissionsToAir
            let $control := xmlconv:ControlDigits($ii/rsm:quantity)
            return if($control != '')then(
                $i
            )else()
};

(: #33 Conditional check: Must be reported if type is OtherGases :)
declare function xmlconv:control_OtherGases($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
        return if($i/rsm:EnergyInput[rsm:type = 'OtherGases'] and (not(exists($i/rsm:EnergyInput/rsm:otherGases)) or $i/rsm:EnergyInput[rsm:otherGases = '']))then(
            $i
        )else()
};

(: #34 Conditional check: Must be reporterd if type is OtherSolidFuels :)
declare function xmlconv:control_otherSolidFuels($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
        return if($i/rsm:EnergyInput[rsm:type = 'OtherSolidFuels'] and (not(exists($i/rsm:EnergyInput/rsm:otherSolidFuels)) or $i/rsm:EnergyInput[rsm:otherSolidFuels = '']))then(
            $i
        )else()
};

(: #35 Element check: Same type is not allowed more than once for a PlantReport (except OtherGases and OtherSolidFuels) :)
declare function xmlconv:control_energyInput_type($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
        for $ii in $i/rsm:EnergyInput/rsm:type
            let $iii := $i/rsm:EnergyInput[rsm:type = $ii]
                return if(count($iii) > 1 and $iii[rsm:type != 'OtherGases'] and $iii[rsm:type != 'OtherSolidFuels'])then(
                    $i
                )else()
};

(: #36  Element check: Same type is not allowed more than once for a PlantReport :)
declare function xmlconv:control_OtherGases_same($source_url as xs:string){
     for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
        for $ii in $i/rsm:EnergyInput/rsm:otherGases 
            let $iii := $i/rsm:EnergyInput[rsm:otherGases = $ii]
            return if(count($iii) > 1 )then(
                $i
            )else()
};

(: #37  Element check: Same type is not allowed more than once for a PlantReport :)
declare function xmlconv:control_otherSolidFuels_same($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
        for $ii in $i/rsm:EnergyInput/rsm:otherSolidFuels 
            let $iii := $i/rsm:EnergyInput[rsm:otherSolidFuels = $ii]
            return if(count($iii) > 1 )then(
                $i
            )else()
};

(: #38 EnergyInput quantity controlDigits :)
declare function xmlconv:control_energyInput_quantity_controlDigits($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
        for $ii in $i/rsm:EnergyInput
            let $control := xmlconv:ControlDigits($ii/rsm:quantity)
            return if($control != '')then(
                $i
            )else()
};

(: #39 Element check: Same type is not allowed more than once for a PlantReport :)
declare function xmlconv:control_combustionPlantType($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
        for $ii in $i/rsm:PlantType/rsm:combustionPlantType 
            let $iii := $i/rsm:PlantType[rsm:combustionPlantType = $ii]
            return if(count($iii) > 1 )then(
                $i
            )else()
};

(: #40 Element check: Same type is not allowed more than once for a PlantReport :)
declare function xmlconv:control_SO2_month($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
        for $ii in $i/rsm:IEDArt72/rsm:SO2/rsm:month 
            let $iii := $i/rsm:IEDArt72/rsm:SO2[rsm:month = $ii]
            return if(count($iii) > 1 )then(
                    $i
                )else()
};

(: #41 Element check: Same type is not allowed more than once for a PlantReport :)
declare function xmlconv:control_DesulphurisationRate_month($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
        for $ii in $i/rsm:IEDArt72/rsm:DesulphurisationRate/rsm:month 
        let $iii :=  $i/rsm:IEDArt72/rsm:DesulphurisationRate[rsm:month = $ii]
        return if(count($iii) > 1 )then(
                $i
            )else()
};

(: #42 Conditional check: Must be reported if iedArt72_4a is True and not reported if False. If TRUE there must be 12 elements :)
declare function xmlconv:control_iedArt72_4a_SO2($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
        return if($i/rsm:IEDArt72[rsm:iEDArt72_4a = 'true'] and count($i/rsm:IEDArt72/rsm:SO2) != 12)then(
            $i
        )else if($i/rsm:IEDArt72[rsm:iEDArt72_4a = 'false'] and count($i/rsm:IEDArt72/rsm:SO2) != 0)then(
            $i
        )else()
};

(: #43 Conditional check: Must be reported if iedArt72_4a is True and not reported if False. If TRUE there must be 12 elements :)
declare function xmlconv:control_iedArt72_4a_DesulphurisationRate($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
        return if($i/rsm:IEDArt72[rsm:iEDArt72_4a = 'true'] and count($i/rsm:IEDArt72/rsm:DesulphurisationRate) != 12)then(
            $i
        )else if($i/rsm:IEDArt72[rsm:iEDArt72_4a = 'false'] and count($i/rsm:IEDArt72/rsm:DesulphurisationRate) != 0)then(
            $i
        )else()
};

(:==================================================================:)
(: Xquery   Compliance Validation sorted by PlantReport  :)
(:==================================================================:)


(: #1 Conditional check: Must be 'Art 30(2) - existing plants under IED' if dateOfStartOperation is before 07.01.2014 and 'Art 30(3) - new plants under IED' if it is after :)
declare function xmlconv:f_control_statusOFthePlant($elems){
    for $i in $elems
     return if (($i/rsm:dateOfStartOperation < '2014-01-07'or $i/rsm:dateOfStartOperation = '2014-01-07') and $i/rsm:statusOfThePlant !='Art 30(2) - existing plants under IED')then(
        $i
    )else if($i/rsm:dateOfStartOperation > '2014-01-07' and $i/rsm:statusOfThePlant !='Art 30(3) - new plants under IED')then(
        $i
    )else()
};

(: #2 Element check: If rated thermal input is  below 50 MWth (< 50 MWth):)
declare function xmlconv:f_control_thermalInput($elems){
    for $i in $elems
    return if($i/rsm:PlantType/rsm:thermalInput[p:Quantity < '50.0'] )then(
        $i
    )else()
};

(: #3 Element check: If rated thermal input is greater than 8500 MWth (> 8500 MWth):)
declare function xmlconv:f_control_thermalInput_great($elems){
    for $i in $elems
    return if($i/rsm:PlantType/rsm:thermalInput[p:Quantity > '8500.0'] )then(
        $i
    )else()
};

(: #4 The ratio of fuel input/thermal input cannot be larger than 35 TJ / (MW yr) :)
declare function xmlconv:f_control_EnergyInput_quantity($elems){
    for $i in $elems
        let $thermalInput := xmlconv:get_Plantype_thermalInput_per_PLantREport($i)
        let $quantity := xmlconv:get_EnergyInput_quantity_per_PLantREport($i)
        return if($thermalInput != 0 and ($quantity div $thermalInput) > 35)then(
            $i
        )else()
};

(: #5 Conditional check: Must be greater than 50 (>= 50) if extensionBy50MWOrMore is True return PlantReport :)
declare function xmlconv:f_control_capacityAddedMW($elems){
    for $i in $elems[rsm:extensionBy50MWOrMore = 'true']
        return if($i/rsm:capacityAddedMW/p:Quantity < 50)then(
            $i
        )else()

};

(: #6 Conditional check: Must be greater than 0 (> 0) if substantialChange is True return PlantReport :)
declare function xmlconv:f_control_capacityAffectedMW($elems){
    for $i in $elems[rsm:substantialChange = 'true']
        return if($i/rsm:capacityAffectedMW[p:Quantity = 0])then(
            $i
        )else()

};

(: #7 The total emission to air for SO2 cannot be more than 5 times the estimated emission return PlantReport:)
declare function xmlconv:f_control_TotalEmissionsToAir_quantity_1($elems){
     let $fuel := 0
     for $i in $elems
        let  $totalEmisions := xmlconv:totalSum($i/rsm:TotalEmissionsToAir[rsm:type = 'SO2']/rsm:quantity)
        let $fuel := xmlconv:multiplyWithEnumSO2($i/rsm:EnergyInput)
        return if(count($i/rsm:TotalEmissionsToAir[rsm:type = 'SO2']/rsm:quantity) != 0 and $totalEmisions > 5 * sum($fuel) and count(doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport/rsm:EnergyInput[rsm:type != 'NaturalGas']) > 0) then(
            $i
        )else()
};

(: #8 The total emission to air for SO2 cannot be more than 50 times less than the estimated emission :)
declare function xmlconv:f_control_TotalEmissionsToAir_quantity_2($elems){
     let $fuel := 0
     for $i in $elems
        let  $totalEmisions := xmlconv:totalSum($i/rsm:TotalEmissionsToAir[rsm:type = 'SO2']/rsm:quantity)
        let $fuel := xmlconv:multiplyWithEnumSO2($i/rsm:EnergyInput)
        return if(count($i/rsm:TotalEmissionsToAir[rsm:type = 'SO2']/rsm:quantity) != 0 and $totalEmisions <  sum($fuel) div 50 and count(doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport/rsm:EnergyInput[rsm:type != 'NaturalGas']) > 0) then(
            $i
        )else()
};

(: #9 The total emission to air for NOx cannot be more than 15 times the estimated emission :)
declare function xmlconv:f_control_TotalEmissionsToAir_quantity_3($elems){
    let $fuel := 0
     for $i in $elems
        let  $totalEmisions := xmlconv:totalSum($i/rsm:TotalEmissionsToAir[rsm:type = 'NOx']/rsm:quantity)
        let $fuel := xmlconv:multiplyWithEnumNOx($i/rsm:EnergyInput)
        return if(count($i/rsm:TotalEmissionsToAir[rsm:type = 'NOx']/rsm:quantity) != 0 and $totalEmisions > 15 * sum($fuel)) then(
            $i
        )else()
};

(: #10 The total emission to air for NOx cannot be more than 7 times less than the estimated emission :)
declare function xmlconv:f_control_TotalEmissionsToAir_quantity_4($elems){
    let $fuel := 0
     for $i in $elems
        let  $totalEmisions := xmlconv:totalSum($i/rsm:TotalEmissionsToAir[rsm:type = 'NOx']/rsm:quantity)
        let $fuel := xmlconv:multiplyWithEnumNOx($i/rsm:EnergyInput)
        return if(count($i/rsm:TotalEmissionsToAir[rsm:type = 'NOx']/rsm:quantity) != 0 and $totalEmisions <  sum($fuel) div 7) then(
            $i
        )else()
};

(: #11 The total emission to air for Dust cannot be more than 15 times the estimated emission :)
declare function xmlconv:f_control_TotalEmissionsToAir_quantity_5($elems){
    let $fuel := 0
     for $i in $elems
        let  $totalEmisions := xmlconv:totalSum($i/rsm:TotalEmissionsToAir[rsm:type = 'Dust']/rsm:quantity)
        let $fuel := xmlconv:multiplyWithEnumDust($i/rsm:EnergyInput)
        return if(count($i/rsm:TotalEmissionsToAir[rsm:type = 'Dust']/rsm:quantity) != 0 and $totalEmisions > 15 * sum($fuel)) then(
            $i
        )else()
};

(: #12 The total emission to air for Dust cannot be more than 100 times less than the estimated emission :)
declare function xmlconv:f_control_TotalEmissionsToAir_quantity_6($elems){
    let $fuel := 0
     for $i in $elems
        let  $totalEmisions := xmlconv:totalSum($i/rsm:TotalEmissionsToAir[rsm:type = 'Dust']/rsm:quantity)
        let $fuel := xmlconv:multiplyWithEnumDust($i/rsm:EnergyInput)
        return if(count($i/rsm:TotalEmissionsToAir[rsm:type = 'Dust']/rsm:quantity) != 0 and $totalEmisions <  sum($fuel) div 100) then(
            $i
        )else()
};

(: #28 Element check: operationsHours cannot exceed 8760 hours/year :)
declare function xmlconv:f_control_operationsHours_1($elems){
    for $i in $elems
        return if($i/rsm:operationHours > 8760)then(
            $i
        )else()
};

(: #29 Element check: controlDigits and more than 0 :)
declare function xmlconv:f_control_operationsHours_2($elems){
    for $i in $elems
        let $hours := xmlconv:ControlDigits($i/rsm:operationHours)
        return if($hours != '')then(
            $i
        )else()
};

(: #31 Element check: Same type is not allowed more than once for a PlantReport :)
declare function xmlconv:f_control_EmisionToAir_type($elems){
    for $i in $elems
        for $ii in $elems/rsm:TotalEmissionsToAir[rsm:type = $i/rsm:TotalEmissionsToAir/rsm:type]
            return if(count($ii) > 1)then(
                $i
            )else()
};

(: #32 TotalEmissionsToAir quantity controlDigits :)
declare function xmlconv:f_control_totalEmissionsToAir_quantity_controlDigits($elems){
    for $i in $elems
        for $ii in $i/rsm:TotalEmissionsToAir
            let $control := xmlconv:ControlDigits($ii/rsm:quantity)
            return if($control != '')then(
                $i
            )else()
};

(: #33 Conditional check: Must be reported if type is OtherGases :)
declare function xmlconv:f_control_OtherGases($elems){
    for $i in $elems
        return if($i/rsm:EnergyInput[rsm:type = 'OtherGases'] and (not(exists($i/rsm:EnergyInput/rsm:otherGases)) or $i/rsm:EnergyInput[rsm:otherGases = '']))then(
            $i
        )else()
};

(: #34 Conditional check: Must be reporterd if type is OtherSolidFuels :)
declare function xmlconv:f_control_otherSolidFuels($elems){
    for $i in $elems
        return if($i/rsm:EnergyInput[rsm:type = 'OtherSolidFuels'] and (not(exists($i/rsm:EnergyInput/rsm:otherSolidFuels)) or $i/rsm:EnergyInput[rsm:otherSolidFuels = '']))then(
            $i
        )else()
};

(: #35 Element check: Same type is not allowed more than once for a PlantReport (except OtherGases and OtherSolidFuels) :)
declare function xmlconv:f_control_energyInput_type($elems){
    for $i in $elems
        for $ii in $i/rsm:EnergyInput/rsm:type
            let $iii := $i/rsm:EnergyInput[rsm:type = $ii]
                return if(count($iii) > 1 and $iii[rsm:type != 'OtherGases'] and $iii[rsm:type != 'OtherSolidFuels'])then(
                    $i
                )else()
};

(: #36  Element check: Same type is not allowed more than once for a PlantReport :)
declare function xmlconv:f_control_OtherGases_same($elems){
     for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
         for $ii in $i/rsm:EnergyInput/rsm:otherGases 
            let $iii := $i/rsm:EnergyInput[rsm:otherGases = $ii]
            return if(count($iii) > 1 )then(
                $i
            )else()
};

(: #37  Element check: Same type is not allowed more than once for a PlantReport :)
declare function xmlconv:f_control_otherSolidFuels_same($elems){
    for $i in $elems
        for $ii in $i/rsm:EnergyInput/rsm:otherSolidFuels 
            let $iii := $i/rsm:EnergyInput[rsm:otherSolidFuels = $ii]
            return if(count($iii) > 1 )then(
                $i
            )else()
};

(: #38 EnergyInput quantity controlDigits :)
declare function xmlconv:f_control_energyInput_quantity_controlDigits($elems){
    for $i in $elems
        for $ii in $i/rsm:EnergyInput
            let $control := xmlconv:ControlDigits($ii/rsm:quantity)
            return if($control != '')then(
                $i
            )else()
};

(: #39 Element check: Same type is not allowed more than once for a PlantReport :)
declare function xmlconv:f_control_combustionPlantType($elems){
    for $i in $elems
        for $ii in $i/rsm:PlantType/rsm:combustionPlantType 
            let $iii := $i/rsm:PlantType[rsm:combustionPlantType = $ii]
            return if(count($iii) > 1 )then(
                $i
            )else()
};

(: #40 Element check: Same type is not allowed more than once for a PlantReport MAL :)
declare function xmlconv:f_control_SO2_month($elems){
    for $i in $elems
         for $ii in $i/rsm:IEDArt72/rsm:SO2/rsm:month 
            let $iii := $i/rsm:IEDArt72/rsm:SO2[rsm:month = $ii]
            return if(count($iii) > 1 )then(
                    $i
                )else()
};

(: #41 Element check: Same type is not allowed more than once for a PlantReport MAL :)
declare function xmlconv:f_control_DesulphurisationRate_month($elems){
    for $i in $elems
        for $ii in $i/rsm:IEDArt72/rsm:DesulphurisationRate/rsm:month 
        let $iii :=  $i/rsm:IEDArt72/rsm:DesulphurisationRate[rsm:month = $ii]
        return if(count($iii) > 1 )then(
                $i
            )else()
};

(: #42 Conditional check: Must be reported if iedArt72_4a is True and not reported if False. If TRUE there must be 12 elements :)
declare function xmlconv:f_control_iedArt72_4a_SO2($elems){
    for $i in $elems
        return if($i/rsm:IEDArt72[rsm:iEDArt72_4a = 'true'] and count($i/rsm:IEDArt72/rsm:SO2) != 12)then(
            $i
        )else if($i/rsm:IEDArt72[rsm:iEDArt72_4a = 'false'] and count($i/rsm:IEDArt72/rsm:SO2) != 0)then(
            $i
        )else()
};

(: #43 Conditional check: Must be reported if iedArt72_4a is True and not reported if False. If TRUE there must be 12 elements :)
declare function xmlconv:f_control_iedArt72_4a_DesulphurisationRate($elems){
    for $i in $elems
        return if($i/rsm:IEDArt72[rsm:iEDArt72_4a = 'true'] and count($i/rsm:IEDArt72/rsm:DesulphurisationRate) != 12)then(
            $i
        )else if($i/rsm:IEDArt72[rsm:iEDArt72_4a = 'false'] and count($i/rsm:IEDArt72/rsm:DesulphurisationRate) != 0)then(
            $i
        )else()
};

(:==================================================================:)
(: Functions to sort by PlantReport  :)
(:==================================================================:)

declare function xmlconv:f_controlOf_PlantReport($elems){
    let $f_control_statusOFthePlant := xmlconv:f_control_statusOFthePlant($elems)
    let $f_control_thermalInput := xmlconv:f_control_thermalInput($elems)
    let $f_control_thermalInput_great := xmlconv:f_control_thermalInput_great($elems)
    let $f_control_EnergyInput_quantity := xmlconv:f_control_EnergyInput_quantity($elems)
    let $f_control_capacityAddedMW := xmlconv:f_control_capacityAddedMW($elems)
    let $f_control_capacityAffectedMW := xmlconv:f_control_capacityAffectedMW($elems)
    let $f_control_TotalEmissionsToAir_quantity_1 := xmlconv:f_control_TotalEmissionsToAir_quantity_1($elems)
    let $f_control_TotalEmissionsToAir_quantity_2 := xmlconv:f_control_TotalEmissionsToAir_quantity_2($elems)
    let $f_control_TotalEmissionsToAir_quantity_3 := xmlconv:f_control_TotalEmissionsToAir_quantity_3($elems)
    let $f_control_TotalEmissionsToAir_quantity_4 := xmlconv:f_control_TotalEmissionsToAir_quantity_4($elems)
    let $f_control_TotalEmissionsToAir_quantity_5 := xmlconv:f_control_TotalEmissionsToAir_quantity_5($elems)
    let $f_control_TotalEmissionsToAir_quantity_6 := xmlconv:f_control_TotalEmissionsToAir_quantity_6($elems)
    let $f_control_operationsHours_1 := xmlconv:f_control_operationsHours_1($elems)
    let $f_control_operationsHours_2 := xmlconv:f_control_operationsHours_2($elems)
    let $f_control_EmisionToAir_type := xmlconv:f_control_EmisionToAir_type($elems)
    let $f_control_totalEmissionsToAir_quantity_controlDigits :=  xmlconv:f_control_totalEmissionsToAir_quantity_controlDigits($elems)
    let $f_control_OtherGases := xmlconv:f_control_OtherGases($elems)
    let $f_control_otherSolidFuels := xmlconv:f_control_otherSolidFuels($elems)
    let $f_control_energyInput_type := xmlconv:f_control_energyInput_type($elems)
    let $f_control_OtherGases_same := xmlconv:f_control_OtherGases_same($elems)
    let $f_control_otherSolidFuels_same := xmlconv:f_control_otherSolidFuels_same($elems)
    let $f_control_energyInput_quantity_controlDigits := xmlconv:f_control_energyInput_quantity_controlDigits($elems)
    let $f_control_combustionPlantType := xmlconv:f_control_combustionPlantType($elems)
    let $f_control_SO2_month := xmlconv:f_control_SO2_month($elems)
    let $f_control_DesulphurisationRate_month := xmlconv:f_control_DesulphurisationRate_month($elems)
    let $f_control_iedArt72_4a_SO2 := xmlconv:f_control_iedArt72_4a_SO2($elems)
    let $f_control_iedArt72_4a_DesulphurisationRate := xmlconv:f_control_iedArt72_4a_DesulphurisationRate($elems)
    
    
    let $message_f_control_statusOFthePlant := xmlconv:f_buildPlantsErrorMessage($f_control_statusOFthePlant,"1-The field legal status of the plant shall be consistent with the date of start of operation")
    let $message_f_control_thermalInput := xmlconv:f_buildPlantsErrorMessage($f_control_thermalInput,"2-Rated thermal input < 50 MWth")
    let $message_f_control_thermalInput_great := xmlconv:f_buildPlantsErrorMessage($f_control_thermalInput_great,"3-Rated thermal input > 8500 MWth")
    let $message_f_control_EnergyInput_quantity := xmlconv:f_buildPlantsErrorMessage($f_control_EnergyInput_quantity,"4-Cases where total fuel input is larger than rated thermal input are flagged")
    let $message_f_control_capacityAddedMW := xmlconv:f_buildPlantsErrorMessage($f_control_capacityAddedMW,"5-When Extension by 50 MW is true, Capacity added [MW] needs to be filled in and be greater than 50MWth.")
    let $message_f_control_capacityAffectedMW := xmlconv:f_buildPlantsErrorMessage($f_control_capacityAffectedMW,"6-When Substantial change is true, Capacity affected [MW] needs to be reported.")
    let $message_f_control_TotalEmissionsToAir_quantity_1 := xmlconv:f_buildPlantsErrorMessage($f_control_TotalEmissionsToAir_quantity_1,"7-SO2 emission outlier test")
    let $message_f_control_TotalEmissionsToAir_quantity_2 := xmlconv:f_buildPlantsErrorMessage($f_control_TotalEmissionsToAir_quantity_2,"8-SO2 emission outlier test")
    let $message_f_control_TotalEmissionsToAir_quantity_3 := xmlconv:f_buildPlantsErrorMessage($f_control_TotalEmissionsToAir_quantity_3,"9-NOx emission outlier test ")
    let $message_f_control_TotalEmissionsToAir_quantity_4 := xmlconv:f_buildPlantsErrorMessage($f_control_TotalEmissionsToAir_quantity_4,"10-NOx emission outlier test ")
    let $message_f_control_TotalEmissionsToAir_quantity_5 := xmlconv:f_buildPlantsErrorMessage($f_control_TotalEmissionsToAir_quantity_5,"11-Dust emission outlier test")
    let $message_f_control_TotalEmissionsToAir_quantity_6 := xmlconv:f_buildPlantsErrorMessage($f_control_TotalEmissionsToAir_quantity_6,"12-Dust emission outlier test")
    let $message_f_control_operationsHours_1 := xmlconv:f_buildPlantsErrorMessage($f_control_operationsHours_1,"28-Plausibility of operated time")
    let $message_f_control_operationsHours_2 := xmlconv:f_buildPlantsErrorMessage($f_control_operationsHours_2,"29-Plausibility of operated time")
    let $message_f_control_EmisionToAir_type := xmlconv:f_buildPlantsErrorMessage($f_control_EmisionToAir_type,"31-Unique values")
    let $message_f_control_totalEmissionsToAir_quantity_controlDigits :=  xmlconv:f_buildPlantsErrorMessage($f_control_totalEmissionsToAir_quantity_controlDigits,"32-TotalEmissionsToAir quantity controlDigits")
    let $message_f_control_OtherGases := xmlconv:f_buildPlantsErrorMessage($f_control_OtherGases,"33-OtherGases")
    let $message_f_control_otherSolidFuels := xmlconv:f_buildPlantsErrorMessage($f_control_otherSolidFuels,"34-OtherSolidFuels")
    let $message_f_control_energyInput_type := xmlconv:f_buildPlantsErrorMessage($f_control_energyInput_type,"35-Unique values")
    let $message_f_control_OtherGases_same := xmlconv:f_buildPlantsErrorMessage($f_control_OtherGases_same,"36-Unique values")
    let $message_f_control_otherSolidFuels_same := xmlconv:f_buildPlantsErrorMessage($f_control_otherSolidFuels_same,"37-Unique values")
    let $message_f_control_energyInput_quantity_controlDigits := xmlconv:f_buildPlantsErrorMessage($f_control_energyInput_quantity_controlDigits,"38-EnergyInput quantity controlDigits")
    let $message_f_control_combustionPlantType := xmlconv:f_buildPlantsErrorMessage($f_control_combustionPlantType,"39-Unique values")
    let $message_f_control_SO2_month := xmlconv:f_buildPlantsErrorMessage($f_control_SO2_month,"40-Unique values")
    let $message_f_control_DesulphurisationRate_month := xmlconv:f_buildPlantsErrorMessage($f_control_DesulphurisationRate_month,"41-Unique values")
    let $message_f_control_iedArt72_4a_SO2 := xmlconv:f_buildPlantsErrorMessage($f_control_iedArt72_4a_SO2,"42-IEDArt72")
    let $message_f_control_iedArt72_4a_DesulphurisationRate := xmlconv:f_buildPlantsErrorMessage($f_control_iedArt72_4a_DesulphurisationRate,"43-IEDArt72")
    
    return
    <div>
    {$message_f_control_statusOFthePlant}
    {$message_f_control_thermalInput}
    {$message_f_control_thermalInput_great}
    {$message_f_control_EnergyInput_quantity}
    {$message_f_control_capacityAddedMW}
    {$message_f_control_capacityAffectedMW}
    {$message_f_control_TotalEmissionsToAir_quantity_1}
    {$message_f_control_TotalEmissionsToAir_quantity_2}
    {$message_f_control_TotalEmissionsToAir_quantity_3}
    {$message_f_control_TotalEmissionsToAir_quantity_4}
    {$message_f_control_TotalEmissionsToAir_quantity_5}
    {$message_f_control_TotalEmissionsToAir_quantity_6}
    {$message_f_control_operationsHours_1}
    {$message_f_control_operationsHours_2}
    {$message_f_control_EmisionToAir_type}
    {$message_f_control_totalEmissionsToAir_quantity_controlDigits}
    {$message_f_control_OtherGases}
    {$message_f_control_otherSolidFuels}
    {$message_f_control_energyInput_type}
    {$message_f_control_OtherGases_same}
    {$message_f_control_otherSolidFuels_same}
    {$message_f_control_energyInput_quantity_controlDigits}
    {$message_f_control_combustionPlantType}
    {$message_f_control_SO2_month}
    {$message_f_control_DesulphurisationRate_month}
    {$message_f_control_iedArt72_4a_SO2}
    {$message_f_control_iedArt72_4a_DesulphurisationRate}
    </div>
};



(:==================================================================:)
(: Functions to call normal querys  :)
(:==================================================================:)
declare function xmlconv:controlOf_PlantReport($source_url){
    let $control_statusOFthePlant := xmlconv:control_statusOFthePlant($source_url)
    let $control_thermalInput := xmlconv:control_thermalInput($source_url)
    let $control_thermalInput_great := xmlconv:control_thermalInput_great($source_url)
    let $control_EnergyInput_quantity := xmlconv:control_EnergyInput_quantity($source_url)
    let $control_capacityAddedMW := xmlconv:control_capacityAddedMW($source_url)
    let $control_capacityAffectedMW := xmlconv:control_capacityAffectedMW($source_url)
    let $control_TotalEmissionsToAir_quantity_1 := xmlconv:control_TotalEmissionsToAir_quantity_1($source_url)
    let $control_TotalEmissionsToAir_quantity_2 := xmlconv:control_TotalEmissionsToAir_quantity_2($source_url)
    let $control_TotalEmissionsToAir_quantity_3 := xmlconv:control_TotalEmissionsToAir_quantity_3($source_url)
    let $control_TotalEmissionsToAir_quantity_4 := xmlconv:control_TotalEmissionsToAir_quantity_4($source_url)
    let $control_TotalEmissionsToAir_quantity_5 := xmlconv:control_TotalEmissionsToAir_quantity_5($source_url)
    let $control_TotalEmissionsToAir_quantity_6 := xmlconv:control_TotalEmissionsToAir_quantity_6($source_url)
    let $control_operationsHours_1 := xmlconv:control_operationsHours_1($source_url)
    let $control_operationsHours_2 := xmlconv:control_operationsHours_2($source_url)
    let $control_EmisionToAir_type := xmlconv:control_EmisionToAir_type($source_url)
    let $control_totalEmissionsToAir_quantity_controlDigits :=  xmlconv:control_totalEmissionsToAir_quantity_controlDigits($source_url)
    let $control_OtherGases := xmlconv:control_OtherGases($source_url)
    let $control_otherSolidFuels := xmlconv:control_otherSolidFuels($source_url)
    let $control_energyInput_type := xmlconv:control_energyInput_type($source_url)
    let $control_OtherGases_same := xmlconv:control_OtherGases_same($source_url)
    let $control_otherSolidFuels_same := xmlconv:control_otherSolidFuels_same($source_url)
    let $control_energyInput_quantity_controlDigits := xmlconv:control_energyInput_quantity_controlDigits($source_url)
    let $control_combustionPlantType := xmlconv:control_combustionPlantType($source_url)
    let $control_SO2_month := xmlconv:control_SO2_month($source_url)
    let $control_DesulphurisationRate_month := xmlconv:control_DesulphurisationRate_month($source_url)
    let $control_iedArt72_4a_SO2 := xmlconv:control_iedArt72_4a_SO2($source_url)
    let $control_iedArt72_4a_DesulphurisationRate := xmlconv:control_iedArt72_4a_DesulphurisationRate($source_url)
    
    
    let $hasErrors :=  exists($control_statusOFthePlant) or
                       exists($control_thermalInput) or
                       exists($control_thermalInput_great) or
                       exists($control_EnergyInput_quantity) or
                       exists($control_capacityAddedMW) or
                       exists($control_capacityAffectedMW) or
                       exists($control_TotalEmissionsToAir_quantity_1) or
                       exists($control_TotalEmissionsToAir_quantity_2) or
                       exists($control_TotalEmissionsToAir_quantity_3) or
                       exists($control_TotalEmissionsToAir_quantity_4) or
                       exists($control_TotalEmissionsToAir_quantity_5) or
                       exists($control_TotalEmissionsToAir_quantity_6) or
                       exists($control_operationsHours_1) or
                       exists($control_operationsHours_2) or
                       exists($control_EmisionToAir_type) or
                       exists($control_totalEmissionsToAir_quantity_controlDigits) or
                       exists($control_OtherGases) or
                       exists($control_otherSolidFuels) or
                       exists($control_energyInput_type) or
                       exists($control_OtherGases_same) or
                       exists($control_otherSolidFuels_same) or
                       exists($control_energyInput_quantity_controlDigits) or
                       exists($control_combustionPlantType) or
                       exists($control_SO2_month) or
                       exists($control_DesulphurisationRate_month) or
                       exists($control_iedArt72_4a_SO2) or
                       exists($control_iedArt72_4a_DesulphurisationRate)
    
    let $hasWarnings := false()
    
    return
    <div>
        <h3><br />{$xmlconv:errCodeCompliance}. Validation of Plant Reports</h3>
        {xmlutil:buildDescription("")}
        {xmlconv:buildResultMsg($hasErrors, $hasWarnings)}
    
        {
        (: #1 Conditional check: Must be 'Art 30(2) - existing plants under IED' if dateOfStartOperation is before 07.01.2014 and 'Art 30(3) - new plants under IED' if it is after :)
        xmlconv:build_control_statusOFthePlant($control_statusOFthePlant)
        }
        {
        (: #2 Element check: If rated thermal input is  below 50 MWth (< 50 MWth) return PlantReport:)
        xmlconv:build_control_thermalInput($control_thermalInput)
        }
        {
        (: #3 Element check: If rated thermal input is greater than 8500 MWth (> 8500 MWth) return PlantReport:)
        xmlconv:build_control_thermalInput_great($control_thermalInput_great)
        }
        {
        (: #4 The ratio of fuel input/thermal input cannot be larger than 35 TJ / (MW yr) return PlantReport:)
        xmlconv:build_control_EnergyInput_quantity($control_EnergyInput_quantity)
        }
        {
        (: #5 Conditional check: Must be greater than 50 (>= 50) if extensionBy50MWOrMore is True return PlantReport :)
        xmlconv:build_control_capacityAddedMW($control_capacityAddedMW)
        }
        {
        (: #6 Conditional check: Must be greater than 0 (> 0) if substantialChange is True return PlantReport :)
        xmlconv:build_control_capacityAffectedMW($control_capacityAffectedMW)
        }
        {
        (: #7 The total emission to air for SO2 cannot be more than 5 times the estimated emission return PlantReport:)
        xmlconv:build_control_TotalEmissionsToAir_quantity_1($control_TotalEmissionsToAir_quantity_1)
        }
        {
        (: #8 The total emission to air for SO2 cannot be more than 50 times less than the estimated emission :)
        xmlconv:build_control_TotalEmissionsToAir_quantity_2($control_TotalEmissionsToAir_quantity_2)
        }
        {
        (: #9 The total emission to air for NOx cannot be more than 15 times the estimated emission :)
        xmlconv:build_control_TotalEmissionsToAir_quantity_3($control_TotalEmissionsToAir_quantity_3)
        }
        {
        (: #10 The total emission to air for NOx cannot be more than 7 times less than the estimated emission :)
        xmlconv:build_control_TotalEmissionsToAir_quantity_4($control_TotalEmissionsToAir_quantity_4)
        }
        {
        (: #11 The total emission to air for Dust cannot be more than 15 times the estimated emission :)
        xmlconv:build_control_TotalEmissionsToAir_quantity_5($control_TotalEmissionsToAir_quantity_5)
        }
        {
        (: #12 The total emission to air for Dust cannot be more than 100 times less than the estimated emission :)
        xmlconv:build_control_TotalEmissionsToAir_quantity_6($control_TotalEmissionsToAir_quantity_6)
        }
        {
        (: #28 Element check: operationsHours cannot exceed 8760 hours/year :)
        xmlconv:build_control_operationsHours_1($control_operationsHours_1)
        }
        {
        (: #29 Element check: controlDigits and more than 0 :)
        xmlconv:build_control_operationsHours_2($control_operationsHours_2)
        }
        {
        (: #31 Element check: Same type is not allowed more than once for a PlantReport :)
        xmlconv:build_control_EmisionToAir_type($control_EmisionToAir_type)
        }
        {
        (: #32 TotalEmissionsToAir quantity controlDigits :)
        xmlconv:build_control_totalEmissionsToAir_quantity_controlDigits($control_totalEmissionsToAir_quantity_controlDigits)
        }
        {
        (: #33 Conditional check: Must be reported if type is OtherGases :)
        xmlconv:build_control_OtherGases($control_OtherGases)
        }
        {
        (: #34 Conditional check: Must be reporterd if type is OtherSolidFuels :)
        xmlconv:build_control_otherSolidFuels($control_otherSolidFuels)
        }
        {
        (: #35 Element check: Same type is not allowed more than once for a PlantReport (except OtherGases and OtherSolidFuels) :)
        xmlconv:build_control_energyInput_type($control_energyInput_type)
        }
        {
        (: #36  Element check: Same type is not allowed more than once for a PlantReport :)
        xmlconv:build_control_OtherGases_same($control_OtherGases_same)
        }
        {
        (: #37  Element check: Same type is not allowed more than once for a PlantReport :)
        xmlconv:build_control_otherSolidFuels_same($control_otherSolidFuels_same)
        }
        {
        (: #38 EnergyInput quantity controlDigits :)
        xmlconv:build_control_energyInput_quantity_controlDigits($control_energyInput_quantity_controlDigits)
        }
        {
        (: #39 Element check: Same type is not allowed more than once for a PlantReport :)
        xmlconv:build_control_combustionPlantType($control_combustionPlantType)
        }
        {
        (: #40 Element check: Same type is not allowed more than once for a PlantReport MAL:)
        xmlconv:build_control_SO2_month($control_SO2_month)
        }
        {
        (: #41 Element check: Same type is not allowed more than once for a PlantReport MAL:)
        xmlconv:build_control_DesulphurisationRate_month($control_DesulphurisationRate_month)
        }
        {
        (: #42 Conditional check: Must be reported if iedArt72_4a is True and not reported if False. If TRUE there must be 12 elements :)
        xmlconv:build_control_iedArt72_4a_SO2($control_iedArt72_4a_SO2)
        }
        {
        (: #43 Conditional check: Must be reported if iedArt72_4a is True and not reported if False. If TRUE there must be 12 elements :)
        xmlconv:build_control_iedArt72_4a_DesulphurisationRate($control_iedArt72_4a_DesulphurisationRate)
        }
    </div>
};

(:==================================================================:)
(: Output messages  1:)
(:==================================================================:)
(: #1 :)
declare function xmlconv:build_control_statusOFthePlant($list){
    let $header := "Consistency of plants legal status-1"
    let $descr := "The field legal status of the plant shall be consistent with the date of start of operation"
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "Consistency of plants legal status", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #2 :)
declare function xmlconv:build_control_thermalInput($list){
    let $header := "Rated thermal input value-2"
    let $descr := "Rated thermal input < 50 MWth "
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "Rated thermal input value", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #3 :)
declare function xmlconv:build_control_thermalInput_great($list){
    let $header := "Rated thermal input value-3"
    let $descr := "Rated thermal input > 8500 MWth "
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "Rated thermal input value", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #4 :)
declare function xmlconv:build_control_EnergyInput_quantity($list){
    let $header := "Plausibility of fuel input-4"
    let $descr := "Cases where total fuel input is larger than rated thermal input are flagged"
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "Plausibility of fuel input", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #5 :)
declare function xmlconv:build_control_capacityAddedMW($list){
    let $header := "Plausibility of capacity added-5"
    let $descr := "When Extension by 50 MW is true, Capacity added [MW] needs to be filled in and be greater than 50MWth."
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "Plausibility of capacity added", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #6 :)
declare function xmlconv:build_control_capacityAffectedMW($list){
    let $header := "Plausible reporting of substantial change-6"
    let $descr := "When Substantial change is true, Capacity affected [MW] needs to be reported."
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "Plausible reporting of substantial change", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #7 :)
declare function xmlconv:build_control_TotalEmissionsToAir_quantity_1($list){
    let $header := "SO2 emission outlier test-7 "
    let $descr := "SO2 emissions are estimated from fuel input, using average emission factors, and compared to actual reported emissions"
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "SO2 emission outlier test ", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #8 :)
declare function xmlconv:build_control_TotalEmissionsToAir_quantity_2($list){
    let $header := "SO2 emission outlier test-8 "
    let $descr := "SO2 emissions are estimated from fuel input, using average emission factors, and compared to actual reported emissions"
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "SO2 emission outlier test ", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #9 :)
declare function xmlconv:build_control_TotalEmissionsToAir_quantity_3($list){
    let $header := "NOx emission outlier test-9 "
    let $descr := "NOx emissions are estimated from fuel input, using average emission factors, and compared to actual reported emissions."
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "NOx emission outlier test ", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #10 :)
declare function xmlconv:build_control_TotalEmissionsToAir_quantity_4($list){
    let $header := "NOx emission outlier test-10 "
    let $descr := "NOx emissions are estimated from fuel input, using average emission factors, and compared to actual reported emissions."
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "NOx emission outlier test ", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #11 :)
declare function xmlconv:build_control_TotalEmissionsToAir_quantity_5($list){
    let $header := "Dust emission outlier test -11"
    let $descr := "Dust emissions are estimated from fuel input, using average emission factors, and compared to actual reported emissions."
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "Dust emission outlier test ", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #12 :)
declare function xmlconv:build_control_TotalEmissionsToAir_quantity_6($list){
    let $header := "Dust emission outlier test -12"
    let $descr := "Dust emissions are estimated from fuel input, using average emission factors, and compared to actual reported emissions."
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "Dust emission outlier test ", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #28 :)
declare function xmlconv:build_control_operationsHours_1($list){
    let $header := "Plausibility of operated time-28"
    let $descr := "Check for number of operating hours for the combustion plants. To be set a maximum of 8760 hrs/year."
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "Plausibility of operated time", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #29 :)
declare function xmlconv:build_control_operationsHours_2($list){
    let $header := "Plausibility of operated time-29"
    let $descr := "Element check: controlDigits and more than 0"
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "Plausibility of operated time", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #31 :)
declare function xmlconv:build_control_EmisionToAir_type($list){
    let $header := "Unique values-31"
    let $descr := "Some elements cannot have repeated values for each plant"
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "Unique values", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #32 :)
declare function xmlconv:build_control_totalEmissionsToAir_quantity_controlDigits($list){
    let $header := "TotalEmissionsToAir quantity controlDigits-32"
    let $descr := "controlDigits"
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "TotalEmissionsToAir quantity controlDigits", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #33 :)
declare function xmlconv:build_control_OtherGases($list){
    let $header := "OtherGases-33"
    let $descr := "onditional check: Must be reported if type is OtherGases"
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "OtherGases", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #34 :)
declare function xmlconv:build_control_otherSolidFuels($list){
    let $header := "OtherSolidFuels-34"
    let $descr := "Conditional check: Must be reporterd if type is OtherSolidFuels"
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "OtherSolidFuels", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #35 :)
declare function xmlconv:build_control_energyInput_type($list){
    let $header := "Unique values-35"
    let $descr := "Some elements cannot have repeated values for each plant"
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "Unique values", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #36 :)
declare function xmlconv:build_control_OtherGases_same($list){
    let $header := "Unique values-36"
    let $descr := "Some elements cannot have repeated values for each plant"
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "Unique values", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #37 :)
declare function xmlconv:build_control_otherSolidFuels_same($list){
    let $header := "Unique values-37"
    let $descr := "Some elements cannot have repeated values for each plant"
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "Unique values", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #38 :)
declare function xmlconv:build_control_energyInput_quantity_controlDigits($list){
    let $header := "EnergyInput quantity controlDigits-38"
    let $descr := "controlDigits"
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "EnergyInput quantity controlDigits", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #39 :)
declare function xmlconv:build_control_combustionPlantType($list){
    let $header := "Unique values-39"
    let $descr := "Some elements cannot have repeated values for each plant"
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "Unique values", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #40 :)
declare function xmlconv:build_control_SO2_month($list){
    let $header := "Unique values-40"
    let $descr := "Some elements cannot have repeated values for each plant"
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "Unique values", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #41 :)
declare function xmlconv:build_control_DesulphurisationRate_month($list){
    let $header := "Unique values-41"
    let $descr := "Some elements cannot have repeated values for each plant"
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "Unique values", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #42 :)
declare function xmlconv:build_control_iedArt72_4a_SO2($list){
    let $header := "IEDArt72-42"
    let $descr := "Check if SO2 are reported if plant is IEDArt72_4a type"
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "IEDArt72", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(: #43 :)
declare function xmlconv:build_control_iedArt72_4a_DesulphurisationRate($list){
    let $header := "IEDArt72-43"
    let $descr := "Check if DesulphurisationRate are reported if plant is IEDArt72_4a type"
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "IEDArt72", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};
(:==================================================================:)
(: Output messages  2:)
(:==================================================================:)              
declare function xmlconv:f_buildPlantsErrorMessage($elems, $error){
    for $elem in $elems
    return
    <li style="list-style-type:none"><b>{concat($elem/rsm:dBPlantId, ': ')} </b> {$error}</li>
}; 

(:==================================================================:)
(:Builds a message section  :)
(:==================================================================:)

declare function xmlconv:buildResultMsg($hasErrors, $hasWarnings){
 if($hasErrors = true()) then
     xmlutil:buildDescription($xmlutil:LEVEL_ERROR, "The test failed!")
 else if( $hasWarnings = true()) then
     xmlutil:buildDescription($xmlutil:LEVEL_WARNING, "The test passed with warnings.")
 else
     xmlutil:buildDescription($xmlutil:LEVEL_INFO, "The test passed successfully.")
 };

(:==================================================================:)
(: QA: Main function:)
(:==================================================================:) 

declare function xmlconv:checkCompliance($source_url as xs:string) {
<div>

    {xmlutil:buildValidatedFile($source_url)}

    <h2><br /><a name='1'>1. Compliance Validation</a></h2>
    {xmlconv:controlOf_PlantReport($source_url) }

    

    <h2><br/><a name='2'>2. Compliance Validation sorted by plants</a></h2>
    {xmlconv:PlantCompilance( $source_url)}
</div>
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
    <h1>LCP batch 1 check </h1>
    <p>{if (not($hasErrors)) then
          $xmlconv:CHECKS_PASSED_FEEDBACK_MESSAGE union xmlconv:buildOKBulet()
         else
          $xmlconv:CHECKS_FAILED_FEEDBACK_MESSAGE union $xmlconv:CHECKS_FAILED_TEXT}</p>
    <a id='feedBackLink' href='javascript:toggle("feedBackDiv","feedBackLink")'>{if (not($hasErrors)) then 'Show details' else 'Hide details'}</a>
    <div id="feedBackDiv" style="display:{if ($hasErrors) then 'block' else 'none'}">
    <div>
    {
        xmlutil:buildDescription("The following validations are meant to help the member states to evaluate if all batch 1 data is correct. The validation detects missing or incorrect mandatory data by analysing the reported values using 3 different methods:")}
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
    <rule code="{ $xmlconv:errCodeCompliance }">
        <title>Compliance Validation</title>
        <descr>the reported value is indicated as potential not compliant value.</descr>
        <message></message>
        <errLevel>{$xmlutil:LEVEL_ERROR}</errLevel>
    </rule>
    <rule code="{ $xmlconv:errCodeCompliancePlantReport }">
        <title>Compliance Validation sorted by Plants</title>
        <descr>the reported value is indicated as potential not compliant value.</descr>
        <message></message>
        <errLevel>{$xmlutil:LEVEL_ERROR}</errLevel>
    </rule>
  </rules>
};




(:Returns a list of Plants elements:)
declare function xmlconv:f_findPlants($source_url){

   for $elems in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
      let $National := $elems/rsm:dBPlantId
     
      let $illegalEXAMPLE :=  xmlconv:f_controlOf_PlantReport($elems)
      

        return
        if ($illegalEXAMPLE != "" ) then
        (
          <tr>
            <td>{$National}</td>
            
            <td style="color:red">{xmlutil:buildErrorElementNotEmpty($xmlconv:errCodeCompliancePlantReport, $illegalEXAMPLE)}</td>
           
          </tr>
          )
          else
             ()
};

declare function xmlconv:PlantCompilance($source_url as xs:string) {

     let $Facility :=  xmlconv:f_findPlants( $source_url)

     let $result :=
     if ($Facility != "") then
    (
    <div>
        {xmlconv:buildResultMsg(fn:true(), fn:false())}
      <table border="1" style="font-size:11px;" class="datatable">
      <tr>
        <th rowspan="2" width="5%">National ID</th>
       
        <th rowspan="2" width="12.5%">(1) Plants Reports</th>
        
      </tr>
      <tr>
   
      </tr>
        {xmlconv:f_findPlants( $source_url)}
      </table>
    </div>
  )
  else (xmlutil:buildDescription($xmlutil:LEVEL_INFO, "The test passed successfully."))


  return
 <div style="font-size:13px;">
    <p>This report shows the results of the validation rules for compliance checking as indicated in the validation manual available at <a href="http://www.eionet.europa.eu/schemas/eprtr/">http://www.eionet.europa.eu/schemas/eprtr/</a>
    The code lists for LCP are available at the same address.</p>
    <p><a href="javascript:toggle('facilityInfoDiv', 'facilityInfoLink')" id="facilityInfoLink" title='Click to see interpretation of columns'>Show Details</a></p>
    <div id='facilityInfoDiv' style='display:none'>

    <p><b>(1) Plants Reports:</b> The only allowed.. TODO
      <ul style="margin-top:0px;">
        <li>Literal HERE TODO</li>
      </ul></p>

   
      </div>
    </div>
union
    $result
};

declare function xmlconv:buildOKBulet() {
        <span><span style="background-color: green; font-size: 0.8em; color: white; padding-left:7px;padding-right:7px;text-align:center">OK</span> All mandatory checks have passed. Data delivery is acceptable.</span>
};

declare function xmlconv:buildNotLocalMessage() {
    xmlutil:buildDescription($xmlutil:LEVEL_INFO, "The test passed successfully.")
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
