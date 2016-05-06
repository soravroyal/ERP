(:  ======================================================================  :)
(:  =====      LCP-PRTR ENVELOPE VALIDATIONS CHECK                   =====  :)
(:  ======================================================================  :)
(:
    This XQuery contains a number of validations for LCP and PRTR envelope.

    XQuery agency:  The European Commission
    XQuery version: 1.0
    Created:    2016-05-05
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
declare variable $source_url_no_xml_path := substring($source_url, 1, string-length($source_url) - 3);
declare variable $xsdG_name := 'http://dd.eionet.europa.eu/schemas/LCPandPRTR/LCPandPRTRMain.xsd';
declare variable $test := 2;
declare variable $ENV := xmlconv:getENVExml();
declare variable $control_no_files := xmlconv:getFiles();



(:LOCAL:)
declare variable $Lcp_Prtr_xml := if(exists(data($ENV//envelope/file[@schema=$xsdG_name]/@name))) then(concat($source_url_no_xml_path,data($ENV//envelope/file[@schema=$xsdG_name]/@name)))else();
declare variable $source_url as xs:string external;

(:FME
declare variable $Lcp_Prtr_xml := if(exists({fme:get-attribute("Lcp_Prtr_xml")})) then ({fme:get-attribute("Lcp_Prtr_xml")}) else () ;
declare variable $source_url := {fme:get-attribute("url_envelope")};
:)

 (: Error codes :)
declare variable $xmlconv:errCodeCompliance := "1";

declare variable $xmlconv:CHECKS_FAILED_TEXT :=
    <div style="color:red"><b>ENVELOPE... check(s) FAILED. FILE(s) delivery is not acceptable. Errors found prevent data being imported to LCP database.</b></div>;
declare variable $xmlconv:CHECKS_FAILED_FEEDBACK_MESSAGE :=
    <span id="feedbackStatus" class="BLOCKER" style="display:none">ENVELOPE... check(s) FAILED. FILE(s) delivery is not acceptable. Errors found prevent data being imported to LCP database.</span>;
declare variable $xmlconv:CHECKS_PASSED_FEEDBACK_MESSAGE :=
    <span id="feedbackStatus" class="INFO" style="display:none">All ENVELOPE... checks have passed. Data delivery is acceptable.</span>;

declare function xmlconv:getENVExml() 
{

    if ($test = 1) then
    (
        let $file := doc("http://localhost/envelope_LCP-PRTR/xml") 
        return ($file)
    )
    else
    (
      let $file := doc($source_url)
    return $file
    )
};

declare function xmlconv:getFiles(){
    if(count($ENV//envelope/file[@schema=$xsdG_name]/@name) = 0)then(
        let $control_no_files := 'N/A'
        return $control_no_files
    )else(
        let $control_no_files := ''
        return $control_no_files
    )
};

(:===================================================================:)
(: Envelope Validations                                            :)
(:===================================================================:)

(: #1 Only one xml :)
declare function xmlconv:control_files_in_envelope(){
    let $file := $xsdG_name
    return if (count($ENV//envelope/file[@schema=$file]/@name) > 1)then(
        $ENV//envelope/file[@schema=$file] 
    )else if(count($ENV//envelope/file[@schema=$file]/@name) = 0)then(
         'N/A'
    )else()
};

(:==================================================================:)
(: Functions to call normal querys  :)
(:==================================================================:)

declare function xmlconv:colntrol_of_functions($source_url){
    let $control_files_in_envelope := xmlconv:control_files_in_envelope()
    
    let $hasErrors := exists($control_files_in_envelope)
    
    let $hasWarnings := false()
    
    return
        <div>
            <h3><br />{$xmlconv:errCodeCompliance}. Validation of Plant Reports and Facilities Envelope</h3>
            {xmlutil:buildDescription("")}
            {xmlconv:buildResultMsg($hasErrors, $hasWarnings)}
        
            {
            (: #1 Only one xml :)
            xmlconv:build_control_files_in_envelope($control_files_in_envelope)
            }
        </div>
};

(:==================================================================:)
(: Output messages  :)
(:==================================================================:)


(: #1 :)
declare function xmlconv:build_control_files_in_envelope($list){
    let $header := "Only one XML file per country"
    let $descr := "This envelope only supports one xml. The associated XSD must be LCPandPRTRMain.xsd"
    let $tableHeader := "The following errors were found"
    let $table := xmlutil:buildTableEnvelopeReport($xmlutil:LEVEL_ERROR, "Consistency of envelope", $list, $xmlutil:COL_FR_NationalID, $xmlconv:errCodeCompliance, '')

    return  xmlutil:buildMessageSection($header, $descr, $tableHeader, $table)
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

declare function xmlconv:buildOKBulet() {
        <span><span style="background-color: green; font-size: 0.8em; color: white; padding-left:7px;padding-right:7px;text-align:center">OK</span> All envelope checks have passed. Data delivery is acceptable.</span>
};


(:==================================================================:)
(: QA: Main function:)
(:==================================================================:) 

declare function xmlconv:checkCompliance($source_url as xs:string) {
<div>

    {xmlutil:buildValidatedFile($source_url)}

    <h2><br /><a name='1'>Envelope Validation</a></h2>
    {xmlconv:colntrol_of_functions($source_url) }

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
    <h1>Envelope validations</h1>
    <p>{if (not($hasErrors) and $control_no_files = '') then
          $xmlconv:CHECKS_PASSED_FEEDBACK_MESSAGE union xmlconv:buildOKBulet()
         else
          $xmlconv:CHECKS_FAILED_FEEDBACK_MESSAGE union $xmlconv:CHECKS_FAILED_TEXT}</p>
    <a id='feedBackLink' href='javascript:toggle("feedBackDiv","feedBackLink")'>{if (not($hasErrors)) then 'Show details' else 'Hide details'}</a>
    <div id="feedBackDiv" style="display:{if ($hasErrors) then 'block' else 'none'}">
    <div>
    {
        xmlutil:buildDescription("The following validations are meant to help the member states to evaluate the xml file. The validation detects missing or incorrect Xml file in envelope:")}
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
        <title>Envelope Validation</title>
        <descr>the reported value is indicated as potential not compliant value.</descr>
        <message></message>
        <errLevel>{$xmlutil:LEVEL_ERROR}</errLevel>
    </rule>
  </rules>
};


xmlconv:proceed( $source_url )
