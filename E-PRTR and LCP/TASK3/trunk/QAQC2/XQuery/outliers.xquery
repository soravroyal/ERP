(:  ======================================================================  :)
(:  =====      PRTR outlier CHECK                               =====  :)
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
import module namespace xmlutil = "urn:eu:com:env:prtr:converter:standard:2" at "XQuery/utils.xquery";

declare namespace xmlconv="urn:eu:com:env:prtr:converter:standard:2";
declare namespace xsi="http://www.w3.org/2001/XMLSchema-instance";
declare namespace rsm="http://dd.eionet.europa.eu/schemas/LCPandPRTR";
declare namespace p="http://dd.eionet.europa.eu/schemas/LCPandPRTR/LCPandPRTRCommon";
(:===================================================================:)
(: Variable given as an external parameter by the QA service         :)
(:===================================================================:)

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
(: Xquerys:)
(:==================================================================:)

declare function xmlconv:controlOf_EXAMPLE($source_url as xs:string){
    for $i in doc($source_url)//rsm:LCPandPRTR/rsm:PlantReports/rsm:PlantReport
    let $variable := $i
    return $variable
};

(:==================================================================:)
(: Xquery   Compliance Validation sorted by PlantReport  :)
(:==================================================================:)

declare function xmlconv:f_controlOf_EXAMPLE($elems){
    for $elem in $elems
    return $elem
};

(:==================================================================:)
(: Functions to sort by PlantReport  :)
(:==================================================================:)

declare function xmlconv:f_controlOf_EXAMPLE_calledBYsort($elems){
    let $aa := xmlconv:f_controlOf_EXAMPLE($elems)
    let $message := xmlconv:f_buildEXAMPLE($aa," MESSAGE")
    return
    <div>
    {$message}
    </div>
};

(:==================================================================:)
(: Functions to call normal querys  :)
(:==================================================================:)
declare function xmlconv:controlOf_EXAMPLE_call($source_url){
    let $example := xmlconv:controlOf_EXAMPLE($source_url)
    let $hasErrors :=  exists($example)
    
    let $hasWarnings := false()
    
    return
    <div>
        <h3><br />{$xmlconv:errCodeCompliance}. Validation of Plant Reports</h3>
        {xmlutil:buildDescription("")}
        {xmlconv:buildResultMsg($hasErrors, $hasWarnings)}
    
        {
        (:Method description:)
        xmlconv:buildExampleReport($example)
        }
    </div>
};

(:==================================================================:)
(: Output messages  1:)
(:==================================================================:)
declare function xmlconv:buildExampleReport($list){
    let $header := "TODO header"
    let $descr := "TODO description"
    let $tableHeader := "TODO table Header"
    let $table := xmlutil:buildTablePlantReport($xmlutil:LEVEL_ERROR, "Duplicate dBFacitilyIDs", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance)

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
};


(:==================================================================:)
(: Output messages  2:)
(:==================================================================:)              
declare function xmlconv:f_buildEXAMPLE($elems, $error){
    for $elem in $elems
    return
    <li style="list-style-type:none"><b>{concat($elem/rsm:type, '/', $elem/rsm:otherGases, ': ')} </b> {$error}</li>
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
    {xmlconv:controlOf_EXAMPLE_call($source_url) }

    

    <h2><br/><a name='2'>2. Compliance Validation sorted by facilities</a></h2>
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
        <title>Compliance Validation sorted by facilities</title>
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
     
      let $illegalEXAMPLE :=  xmlconv:f_controlOf_EXAMPLE_calledBYsort($elems)
      

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
