<?xml version='1.0'?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes" />
  <!--Desired language is passed in as a string parameter - ISO2 Code for the langauge-->
  <xsl:param name="language"/>

  <!--Populate lookup information for phrases, labels, names etc. this results in a hashtable being constructed by the XSL engine-->
  <!--XML Files picked depend on language parameter sent in, if files for language do not exist, transformation will work, but no language specific data will be available, generated page will effectively be empty.-->
  <xsl:variable name="LabelLookups" select ="document(concat('../XML/Labels_',$language,'.xml'))"/>
  <xsl:variable name="PhraseLookups" select ="document(concat('../XML/Lookups_',$language,'.xml'))"/>
  <xsl:variable name="NameLookups" select ="document(concat('../XML/LanguageSpecific_',$language,'.xml'))"/>

  <!--Define some keys for using the hashed valued defined above-->
  <xsl:key name="labelKey" match="label" use="@id"/>
  <xsl:key name="classificationKey" match="phrase" use="@classification_id"/>
  <xsl:key name="sphraseKey" match="phrase" use="@s_phrase_id"/>
  <xsl:key name="rphraseKey" match="phrase" use="@r_phrase_id"/>
  <xsl:key name="clpphraseKey" match="phrase" use="@clp_phrase_id"/>
  <xsl:key name="ghsphraseKey" match="phrase" use="@ghs_phrase_id"/>
  <xsl:key name="propphraseKey" match="phrase" use="@id"/>
  <xsl:key name="groupKey" match="phrase" use="@groupId"/>
  <xsl:key name="groupTipKey" match="phrase" use="@groupIdtip"/>
  <xsl:key name="provOthtitleKey" match="phrase" use="@other_provision_title"/>
  <xsl:key name="provOthInstKey" match="phrase" use="@other_provision_instrument"/>
  <xsl:key name="provOthOverviewKey" match="phrase" use="@other_provision_overview"/>
  <xsl:key name="provOthtargetKey" match="phrase" use="@other_provision_target"/>
  <xsl:key name="provOthlegalKey" match="phrase" use="@other_provision_legal"/>
  <xsl:key name="provOthreportKey" match="phrase" use="@other_provision_reporting"/>
  <xsl:key name="LanguageSpecificKey" match="pollutant" use="@id"/>

  <!--Template for handling markupd tags within text content (sub and b tags)-->
  <xsl:template match="sub|b">
    <xsl:element name="{name()}">
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <!--Main Page Creation-->
  <xsl:template match="/">
    <!--Header for the search box-->
    <div class="info_box_search">
      <!--Header Text For the Search Area-->
      <h1>
        <xsl:for-each select="$LabelLookups">
          <xsl:value-of select="key('labelKey', 'pollutanthead')"/>
        </xsl:for-each>
      </h1>
      <!--Header Notes for the search area-->
      <div class="pollutant_data_item">
        <xsl:for-each select="$LabelLookups">
          <xsl:value-of select="key('labelKey', 'pollutantheadnotes')"/>
        </xsl:for-each>
      </div>
      <div class="pollutant_data_item">
        <xsl:for-each select="$LabelLookups">
          <xsl:value-of select="key('labelKey', 'pollutantheadnotes2')"/>
        </xsl:for-each>
        <a target="_blank">
          <xsl:attribute name="href">
            <xsl:for-each select="$LabelLookups">
              <xsl:value-of select="key('labelKey', 'pollutantheadlink')"/>
            </xsl:for-each>
            <xsl:value-of select="$language"/>
            <xsl:for-each select="$LabelLookups">
              <xsl:value-of select="key('labelKey', 'pollutantheadlink2')"/>
            </xsl:for-each>
          </xsl:attribute>
          <xsl:for-each select="$LabelLookups">
            <xsl:value-of select="key('labelKey', 'pollutantheadlinkLabel')"/>
          </xsl:for-each>
        </a>
      </div>
      <div class="pollutant_data_item" style="font-style:italic">
        <xsl:for-each select="$LabelLookups">
          <xsl:copy-of select="key('labelKey', 'pollutantheadnotes3')"/>
        </xsl:for-each>
      </div>
    </div>
    <!--Pollutant Search Box-->
    <div class="search_form">
      <table width="100%">
        <tr>
          <td valign="top">
            <div class="search_block">
              <!--Pollutant Group Dropdown Label-->
              <xsl:for-each select="$LabelLookups">
                <xsl:value-of select="key('labelKey', 'Group')"/>
              </xsl:for-each>
              <!--Pollutant Group Filter Dropdown uses a select tag, populated with a list of groups, with 'all' option added-->
              <select id="groupFilter">
                <option value="0">
                  <xsl:for-each select="$LabelLookups">
                    <xsl:value-of select="key('labelKey', 'All')"/>
                  </xsl:for-each>
                </option>
                <xsl:for-each select="pollutants/pollutantGroups/pullutant_Group">
                  <xsl:variable name="groupId" select="@id"/>
                  <xsl:for-each select="$PhraseLookups">
                    <option>
                      <xsl:attribute name="value">
                        <xsl:value-of select='$groupId'/>
                      </xsl:attribute>
                      <xsl:value-of select="key('groupKey', $groupId)"/>
                    </option>
                  </xsl:for-each>
                </xsl:for-each>
              </select>
            </div>
          </td>
          <td valign="top">
            <div class="search_block">
              <!--Pollutant Filter Label-->
              <xsl:for-each select="$LabelLookups">
                <xsl:value-of select="key('labelKey', 'Pollutant')"/>
              </xsl:for-each>
              <!--Pollutant Filter Dropdown - uses a select tag populated with pollutant names, with 'all' option added-->
              <select id="pollutantFilter">
                <option value="0">
                  <xsl:for-each select="$LabelLookups">
                    <xsl:value-of select="key('labelKey', 'All')"/>
                  </xsl:for-each>
                </option>
                <xsl:for-each select="pollutants/pollutantGroups/pullutant_Group/pollutant">
                  <xsl:sort select="pollutant_no"/>
                  <xsl:variable name="pollutantId" select="pollutant_no"/>
                  <xsl:variable name="pollutant_group" select="pollutant_group"/>
                  <xsl:for-each select="$NameLookups">
                    <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                      <option>
                        <xsl:attribute name="value" >
                          <xsl:value-of select='$pollutant_group'/>
                        </xsl:attribute>
                        <xsl:value-of select="pollutant_name"/>
                      </option>
                    </xsl:for-each>
                  </xsl:for-each>
                </xsl:for-each>
              </select>
              <!--Pollutant filter master list, allows the list of available pollutants to be restored as filtering by groups removes pollutants from the visible dropdown list-->
              <select id="pollutantFilterMaster" style="visibility:hidden">
                <option value="0">
                  <xsl:for-each select="$LabelLookups">
                    <xsl:value-of select="key('labelKey', 'All')"/>
                  </xsl:for-each>
                </option>
                <xsl:for-each select="pollutants/pollutantGroups/pullutant_Group/pollutant">
                  <xsl:sort select="pollutant_no"/>
                  <xsl:variable name="pollutantId" select="pollutant_no"/>
                  <xsl:variable name="pollutant_group" select="pollutant_group"/>
                  <xsl:for-each select="$NameLookups">
                    <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                      <option>
                        <xsl:attribute name="value" >
                          <xsl:value-of select='$pollutant_group'/>
                        </xsl:attribute>
                        <xsl:value-of select="pollutant_name"/>
                      </option>
                    </xsl:for-each>
                  </xsl:for-each>
                </xsl:for-each>
              </select>
            </div>
          </td>
        </tr>
      </table>
      <div style="clear:left">
        <!--Search Button-->
        <input class="search_button" type="button">
          <xsl:attribute name="value">
            <xsl:for-each select="$LabelLookups">
              <xsl:value-of select="key('labelKey', 'Search')"/>
            </xsl:for-each>
          </xsl:attribute>
        </input>
      </div>
    </div>
    <!--Search Result Area-->
    <!--This area contains the complete set of pollutant information in a table
        Information for each pollutant is held in two table rows
        The first holds the pollutant name and the pollutant grup as labels
        The pollutant name acts as a hyperling to initiate the display of information for the specific pollutant
        Clicking the link toggles the visibility of the row containing the pollutant markup
        
        The second table row contains the pollutant information, visibility of the row is controlled by a css class
        This class is switched via jQuery to toggle the visibility of the row and its contents
        
        The markup for each pollutant display section consists of 9 sub-sections
        1. Header section containing the Name/Group           (always visible)
        2. Menu Display for switching the visible sub-section (always visible)
        
        The remaining sections are visible one section at a time, switchable by clicking on the corresponding menu link
        Switching of the sub-sectons is controlled by adding removing a display attribute on the containing div element
        
        3. Summary information, including molecule display using jMol
        4. Synonyms
        5. Pollutant Group Information
        6. Hazard Information
        7. Reporting Requirements
        8. Provisions under PRTR
        9. MEasurements and Calculations
        -->
    <div class="result_area">
      <div class="pollutant_resultSheet_content">
        <!--Table to hold pollutants-->
        <table id="pollutants" style="width: 100%;">
          <!--Table Header-->
          <thead>
            <!--Pollutant Header row-->
            <tr class="generalListStyle_headerRow hide">
              <th>
                <!--Pollutant Name Header-->
                <div class="headerPollutant">
                  <xsl:for-each select="$LabelLookups">
                    <xsl:value-of select="key('labelKey', 'Pollutant')"/>
                  </xsl:for-each>
                </div>
              </th>
              <th>
                <!--Poolutant Group Header-->
                <div class="headerPollutantGroup">
                  <xsl:for-each select="$LabelLookups">
                    <xsl:value-of select="key('labelKey', 'Group')"/>
                  </xsl:for-each>
                </div>
              </th>
            </tr>
          </thead>
          <!--Table Body-->
          <tbody>
            <!--Loop though all groups/pollutants-->
            <xsl:for-each select="pollutants/pollutantGroups/pullutant_Group/pollutant">
              <!--Put the pollutant Id into a variable-->
              <xsl:variable name="pollutantId" select="pollutant_no"/>
              <!--Put the pollutant group Id into a variable-->
              <xsl:variable name="groupId" select="pollutant_group"/>
              <!--Row for table display-->
              <tr class="generalListStyle_row hide">
                <!--Pollutant Name Column-->
                <td>
                  <div class="pollutantToggle">
                    <a target="_blank" class="pollutant">
                      <xsl:for-each select="$NameLookups">
                        <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                          <xsl:value-of select="pollutant_name"/>
                        </xsl:for-each>
                      </xsl:for-each>
                    </a>
                  </div>
                </td>
                <!--Pollutant Group Column-->
                <td>
                  <div class="pollutantGroup">
                    <xsl:for-each select="$PhraseLookups">
                      <xsl:value-of select="key('groupKey', $groupId)"/>
                    </xsl:for-each>
                  </div>
                </td>
              </tr>
              <!--Row for pollutant display content - all initially hidden-->
              <tr class="hide">
                <!--Single column spanning 2 columns-->
                <td class="padCol" colspan="2">
                  <!--Main pollutant containder, 'hide' class used by jQuery to hide all tags-->
                  <div class="backgroundSetting hide">
                    <!--Header for ALL sections-->
                    <div class="second_resultSheet_header">
                      <!--Pollutant Name Label-->
                      <div class="pollutant_head">
                        <xsl:for-each select="$LabelLookups">
                          <xsl:value-of select="key('labelKey', 'Pollutant')"/>
                        </xsl:for-each>
                      </div>
                      <!--Pollutant Name-->
                      <div class="pollutant_item">
                        <xsl:for-each select="$NameLookups">
                          <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                            <xsl:value-of select="pollutant_name"/>
                          </xsl:for-each>
                        </xsl:for-each>
                      </div>
                      <!--Pollutant Group Label-->
                      <div class="pollutant_head">
                        <xsl:for-each select="$LabelLookups">
                          <xsl:value-of select="key('labelKey', 'Group')"/>
                        </xsl:for-each>
                      </div>
                      <!--Pollutany Group-->
                      <div class="pollutant_item">
                        <xsl:for-each select="$PhraseLookups">
                          <xsl:value-of select="key('groupKey', $groupId)"/>
                        </xsl:for-each>
                      </div>
                    </div>
                    <!--Contents Box - use std styling from main site-->
                    <div class="second_contentBoxStyler">
                      <a class="pollutantPrint" title="Printer friendly version">
                        <img src="images/ico-print.gif" alt="Printer friendly version" style="cursor:hand;"></img>
                      </a>
                      <div class="resultSheet_contentsBox">
                        <span class="contentsBox_header">
                          <xsl:for-each select="$LabelLookups">
                            <xsl:value-of select="key('labelKey', 'Contents')"/>
                          </xsl:for-each>:
                        </span>
                        <br />
                        <!--Summary-->
                        <a class="contentsBox_item pollutantSummary contentsBox_item_selected">
                          <xsl:for-each select="$LabelLookups">
                            <xsl:value-of select="key('labelKey', 'Summary')"/>
                          </xsl:for-each>
                        </a>
                        <!--Pollutant Group-->
                        <a class="contentsBox_item pollutantGroupInfo">
                          <xsl:for-each select="$LabelLookups">
                            <xsl:value-of select="key('labelKey', 'Group')"/>
                          </xsl:for-each>
                        </a>
                        <!--Pollutant Thresholds (eprtr provisions)-->
                        <a class="contentsBox_item eprtrProvisions">
                          <xsl:for-each select="$LabelLookups">
                            <xsl:value-of select="key('labelKey', 'eprtrProvisions')"/>
                          </xsl:for-each>
                        </a>
                        <!--Measurement & calculation methods (iso provisions)-->
                        <a class="contentsBox_item measurement">
                          <xsl:for-each select="$LabelLookups">
                            <xsl:value-of select="key('labelKey', 'measurement')"/>
                          </xsl:for-each>
                        </a>
                        <!--Synonyms-->
                        <a class="contentsBox_item pollutantNames">
                          <xsl:for-each select="$LabelLookups">
                            <xsl:value-of select="key('labelKey', 'synonyms')"/>
                          </xsl:for-each>
                        </a>
                        <!--Other relevant reporting requirements (other Provisions)-->
                        <a class="contentsBox_item pollutantProvisions">
                          <xsl:for-each select="$LabelLookups">
                            <xsl:value-of select="key('labelKey', 'provisions')"/>
                          </xsl:for-each>
                        </a>
                        <!--Hazards and other technical characteristics-->
                        <a class="contentsBox_item hazards">
                          <xsl:for-each select="$LabelLookups">
                            <xsl:value-of select="key('labelKey', 'hazards')"/>
                          </xsl:for-each>
                        </a>
                      </div>
                    </div>
                    <!--Summary Section-->
                    <div class="second_resultSheet_content pollutantSummary" >
                      <div class="molecule_display">
                        <div class="tabArea">
                          <a class="tab jmol">3D</a>
                          <a class="tab image activeTab">2D</a>
                        </div>
                        <!--Test for 'hasNoData' element, if so show 'noData' value-->
                        <xsl:choose>
                          <xsl:when test="chemspider/hasNoData">
                            <div class="tabMain jmol" style="display: none;">
                              <!--Data-->
                              <xsl:for-each select="$LabelLookups">
                                <xsl:value-of select="key('labelKey', 'noData')"/>
                              </xsl:for-each>
                            </div>
                          </xsl:when>
                          <xsl:otherwise>
                            <div class="tabMain jmol" style="display: none;">
                              <!--Data-->
                              <script type="text/javascript" visible="false">
                                jmolInitialize("Jmol");
                                jmolApplet(150, "load Molecules/<xsl:value-of select="chemspider/id"/>.txt; set disablePopupMenu TRUE; spin on");
                              </script>
                            </div>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="chemspider/hasNoData">
                            <div class="tabMain image" style="display: block;">
                              <xsl:for-each select="$LabelLookups">
                                <xsl:value-of select="key('labelKey', 'noData')"/>
                              </xsl:for-each>
                            </div>
                          </xsl:when>
                          <xsl:otherwise>
                            <div class="tabMain image" style="display: block;">
                              <img alt="Methane">
                                <xsl:attribute name="src">
                                  Molecules/<xsl:value-of select="chemspider/id"/>.gif
                                </xsl:attribute>
                                <xsl:attribute name="alt">
                                  <xsl:for-each select="$NameLookups">
                                    <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                                      <xsl:value-of select="pollutant_name"/>
                                    </xsl:for-each>
                                  </xsl:for-each>
                                </xsl:attribute>
                              </img>
                            </div>
                          </xsl:otherwise>
                        </xsl:choose>
                      </div>
                      <!--Block right of mole display-->
                      <div class="container_500px">
                        <!--Pollutant Id-->
                        <div class="pollutant_info">
                          <div class="pollutant_info_label">
                            <xsl:for-each select="$LabelLookups">
                              <xsl:value-of select="key('labelKey', 'PollutantId')"/>
                            </xsl:for-each>:
                          </div>
                          <div class="pollutant_info_value">
                            <xsl:value-of select="pollutant_no"/>
                          </div>
                        </div>
                        <!--IUPAC Name-->
                        <div class="pollutant_info">
                          <div class="pollutant_info_label tooltip">
                            <xsl:for-each select="$LabelLookups">
                              <xsl:value-of select="key('labelKey', 'IUPAC')"/>
                            </xsl:for-each>:
                            <span>
                              <xsl:for-each select="$LabelLookups">
                                <xsl:value-of select="key('labelKey', 'IUPACTooltip')"/>
                              </xsl:for-each>
                            </span>
                          </div>
                          <div class="pollutant_info_value">
                            <xsl:value-of select="IUPAC_Name"/>
                          </div>
                        </div>
                        <!--CAS Number-->
                        <div class="pollutant_info">
                          <div class="pollutant_info_label tooltip">
                            <xsl:for-each select="$LabelLookups">
                              <xsl:value-of select="key('labelKey', 'CASNumber')"/>
                            </xsl:for-each>:
                            <span>
                              <xsl:for-each select="$LabelLookups">
                                <xsl:value-of select="key('labelKey', 'CASToolTip')"/>
                              </xsl:for-each>
                            </span>
                          </div>
                          <div class="pollutant_info_value">
                            <xsl:value-of select="cas_no"/>
                          </div>
                        </div>
                        <!--EC Number-->
                        <div class="pollutant_info">
                          <div class="pollutant_info_label tooltip">
                            <xsl:for-each select="$LabelLookups">
                              <xsl:value-of select="key('labelKey', 'ECNumber')"/>
                            </xsl:for-each>:
                            <span>
                              <xsl:for-each select="$LabelLookups">
                                <xsl:value-of select="key('labelKey', 'ECToolTip')"/>
                              </xsl:for-each>
                            </span>
                          </div>
                          <div class="pollutant_info_value">
                            <xsl:value-of select="ec_no"/>
                          </div>
                        </div>
                        <!--SMILES-->
                        <div class="pollutant_info">
                          <div class="pollutant_info_label tooltip">
                            SMILES:
                            <span>
                              <xsl:for-each select="$LabelLookups">
                                <xsl:value-of select="key('labelKey', 'smiles')"/>
                              </xsl:for-each>
                            </span>
                          </div>
                          <div class="pollutant_info_value">
                            <xsl:value-of select="smiles_code"/>
                          </div>
                        </div>
                        <!--ChemSpider-->
                        <div class="pollutant_info">
                          <div class="pollutant_info_label">ChemSpider Id:</div>
                          <div class="pollutant_info_value">
                            <a href="" target="_blank">
                              <xsl:attribute name="href">
                                http://<xsl:value-of select="chemspider/url"/>
                              </xsl:attribute>
                              <xsl:value-of select="chemspider/id"/>
                            </a>
                          </div>
                        </div>
                        <!--Formula-->
                        <div class="pollutant_info">
                          <div class="pollutant_info_label">
                            <xsl:for-each select="$LabelLookups">
                              <xsl:value-of select="key('labelKey', 'Formula')"/>
                            </xsl:for-each>:
                          </div>
                          <div class="pollutant_info_value">
                            <xsl:copy-of select="molecular_formula"/>
                          </div>
                        </div>
                        <!--Classification-->
                        <div class="pollutant_info">
                          <div class="pollutant_info_label tooltip">
                            <xsl:for-each select="$LabelLookups">
                              <xsl:value-of select="key('labelKey', 'Classification')"/>
                            </xsl:for-each>:
                            <span>
                              <xsl:for-each select="$LabelLookups">
                                <xsl:value-of select="key('labelKey', 'ClassificationTooltip')"/>
                              </xsl:for-each>
                            </span>
                          </div>
                          <div class="pollutant_info_value">
                            <xsl:for-each select="classifications/classification">
                              <xsl:variable name="classId" select="."/>
                              <a class="tooltip">
                                <xsl:value-of select="."/>,
                                <span>
                                  (<xsl:value-of select="."/>)
                                  <xsl:for-each select="$PhraseLookups">
                                    <xsl:value-of select="key('classificationKey', $classId)"/>
                                  </xsl:for-each>
                                </span>
                              </a>
                            </xsl:for-each>
                          </div>
                        </div>
                      </div>
                      <!--Block Below mole display-->
                      <div class="container_99pct" style="margin: 5px 10px 5px 5px">
                        <!--Description-->
                        <div class="pollutant_sub_head">
                          <xsl:for-each select="$LabelLookups">
                            <xsl:value-of select="key('labelKey', 'description')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_data_item">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="description"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                        <!--Main Uses-->
                        <div class="pollutant_sub_head">
                          <xsl:for-each select="$LabelLookups">
                            <xsl:value-of select="key('labelKey', 'mainuses')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_data_item">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="main_uses"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                        <!--Main methods of release-->
                        <div class="pollutant_sub_head">
                          <xsl:for-each select="$LabelLookups">
                            <xsl:value-of select="key('labelKey', 'mainmethodsrelease')"/>
                          </xsl:for-each>
                        </div>
                        <xsl:for-each select="$NameLookups">
                          <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                            <xsl:for-each select="main_methods_of_release/text">
                              <div class="pollutant_data_item">
                                <xsl:value-of select="."/>
                              </div>
                            </xsl:for-each>
                            <!--<xsl:value-of select="main_methods_of_release"/>-->
                          </xsl:for-each>
                        </xsl:for-each>
                        <!--Health Affects-->
                        <div class="pollutant_sub_head">
                          <xsl:for-each select="$LabelLookups">
                            <xsl:value-of select="key('labelKey', 'healthAffects')"/>
                          </xsl:for-each>
                        </div>
                        <xsl:for-each select="$NameLookups">
                          <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                            <xsl:for-each select="health_affects/text">
                              <div class="pollutant_data_item">
                                <xsl:value-of select="."/>
                              </div>
                            </xsl:for-each>
                          </xsl:for-each>
                        </xsl:for-each>
                      </div>
                      <!--Just a spacer-->
                      <div class="pollutant_sub_head">
                        <br />
                      </div>
                    </div>
                    <!--Synonyms Section-->
                    <div class="second_resultSheet_content pollutantNames" style="display:none;">
                      <div class="pollutant_sub_head">
                        <xsl:for-each select="$LabelLookups">
                          <xsl:value-of select="key('labelKey', 'synonyms')"/>
                        </xsl:for-each>
                      </div>
                      <xsl:for-each select="synonyms/synonym">
                        <div class="pollutant_data_item">
                          <xsl:value-of select="."/>
                        </div>
                      </xsl:for-each>
                      <div class="pollutant_sub_head">
                        <br />
                      </div>
                    </div>
                    <!--Pollutant Group Members Section-->
                    <div class="second_resultSheet_content pollutantGroupInfo" style="display:none;">
                      <div class="pollutant_sub_head">
                        <xsl:for-each select="$LabelLookups">
                          <xsl:value-of select="key('labelKey', 'Group')"/>
                        </xsl:for-each>
                        -
                        <xsl:for-each select="$PhraseLookups">
                          <xsl:value-of select="key('groupKey', $groupId)"/>
                        </xsl:for-each>
                      </div>
                      <div class="pollutant_data_item">
                        <xsl:for-each select="$PhraseLookups">
                          <xsl:value-of select="key('groupTipKey', $groupId)"/>
                        </xsl:for-each>
                      </div>
                      <div class="pollutant_sub_head">
                        <br />
                      </div>
                      <xsl:for-each select="pollutant_group_info/group_member">
                        <div class="pollutant_data_item">
                          <xsl:variable name="memberId" select="polluantno"/>
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $memberId)">
                              <xsl:value-of select="pollutant_name"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:for-each>
                      <div class="pollutant_sub_head">
                        <br />
                      </div>
                    </div>
                    <!--Hazards and other technical characteristics-->
                    <div class="second_resultSheet_content hazards" style="display:none;">
                      <!--R Phrases-->
                      <div class="pollutant_sub_head">
                        <xsl:for-each select="$LabelLookups">
                          <xsl:value-of select="key('labelKey', 'rands')"/>
                        </xsl:for-each>
                      </div>
                      <div class="pollutant_data_item">
                        <xsl:for-each select="$LabelLookups">
                          <xsl:value-of select="key('labelKey', 'randsex')"/>
                        </xsl:for-each>
                      </div>
                      <xsl:for-each select="r_phrases/r_phrase">
                        <xsl:variable name="rphraseId" select="."/>
                        <div class="pollutant_phrase_label">
                          <xsl:value-of select="."/>
                        </div>
                        <div class="pollutant_phrase">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('rphraseKey', $rphraseId)"/>
                          </xsl:for-each>
                        </div>
                      </xsl:for-each>
                      <!--S Phrases-->
                      <xsl:for-each select="s_phrases/s_phrase">
                        <xsl:variable name="sphraseId" select="."/>
                        <!--Special case for if no R & S phrases - should add single s_phrase code 'V1'-->
                        <xsl:if test="$sphraseId != 'V1'">
                          <div class="pollutant_phrase_label">
                            <xsl:value-of select="."/>
                          </div>
                        </xsl:if>
                        <div class="pollutant_phrase">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('sphraseKey', $sphraseId)"/>
                          </xsl:for-each>
                        </div>
                      </xsl:for-each>
                      <!--Spacer-->
                      <div class="pollutant_sub_head">
                        <br />
                      </div>
                      <!--Classification and Labelling (clp/ghs)-->
                      <div class="pollutant_sub_head">
                        <xsl:for-each select="$LabelLookups">
                          <xsl:value-of select="key('labelKey', 'clpghs')"/>
                        </xsl:for-each>
                      </div>
                      <!--Classification and Labelling notes (clp/ghs)-->
                      <div class="pollutant_data_item">
                        <xsl:for-each select="$LabelLookups">
                          <xsl:value-of select="key('labelKey', 'clpex')"/>
                        </xsl:for-each>
                      </div>
                      <!--Classification and Labelling link to regulation (clp/ghs)-->
                      <div class="pollutant_data_item">
                        <a target="_blank">
                          <xsl:attribute name="href">
                            <xsl:for-each select="$LabelLookups">
                              <xsl:value-of select="key('labelKey', 'clpLinkUrl')"/>
                            </xsl:for-each>
                            <xsl:value-of select="$language"/>
                            <xsl:for-each select="$LabelLookups">
                              <xsl:value-of select="key('labelKey', 'clpLinkUrl2')"/>
                            </xsl:for-each>
                          </xsl:attribute>
                          <xsl:for-each select="$LabelLookups">
                            <xsl:value-of select="key('labelKey', 'clpLinkText')"/>
                          </xsl:for-each>
                        </a>
                      </div>
                      <!--Hazard Class (CLP)-->
                      <div class="pollutant_sub_head tooltip">
                        <xsl:for-each select="$LabelLookups">
                          <xsl:value-of select="key('labelKey', 'clp')"/>
                        </xsl:for-each>
                        <span>
                          <xsl:for-each select="$LabelLookups">
                            <xsl:value-of select="key('labelKey', 'clpLinkText')"/>
                          </xsl:for-each>
                        </span>
                      </div>
                      <xsl:for-each select="clp/clp_phrase">
                        <xsl:variable name="clpPhraseId" select="."/>
                        <xsl:if test="$clpPhraseId != 'NoData'">
                          <div class="pollutant_phrase_label">
                            <xsl:value-of select="."/>
                          </div>
                        </xsl:if>
                        <div class="pollutant_phrase">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('clpphraseKey', $clpPhraseId)"/>
                          </xsl:for-each>
                        </div>
                      </xsl:for-each>
                      <!--Hazard Statements (GHS)-->
                      <div class="pollutant_sub_head tooltip" >
                        <xsl:for-each select="$LabelLookups">
                          <xsl:value-of select="key('labelKey', 'ghs')"/>
                        </xsl:for-each>
                        <span>
                          <xsl:for-each select="$LabelLookups">
                            <xsl:value-of select="key('labelKey', 'clpLinkText')"/>
                          </xsl:for-each>
                        </span>
                      </div>
                      <xsl:for-each select="ghs/ghs_phrase">
                        <xsl:variable name="ghsPhraseId" select="."/>
                        <xsl:if test="$ghsPhraseId != 'NoData'">
                          <div class="pollutant_phrase_label">
                            <xsl:value-of select="."/>
                          </div>
                        </xsl:if>
                        <div class="pollutant_phrase">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('ghsphraseKey', $ghsPhraseId)"/>
                          </xsl:for-each>
                        </div>
                      </xsl:for-each>
                      <!--Spacer-->
                      <div class="pollutant_sub_head">
                        <br />
                      </div>
                      <!--Physical Properties-->
                      <div class="pollutant_sub_head">
                        <xsl:for-each select="$LabelLookups">
                          <xsl:value-of select="key('labelKey', 'physical')"/>
                        </xsl:for-each>
                      </div>
                      <xsl:if test="properties/state">
                        <div class="pollutant_property_label">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('propphraseKey', 'state')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_property_value">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="state"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:if>
                      <xsl:if test="properties/melt_freeze_point">
                        <div class="pollutant_property_label">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('propphraseKey', 'melt_freeze_point')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_property_value">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="melt_freeze_point"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:if>
                      <xsl:if test="properties/boiling_point">
                        <div class="pollutant_property_label">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('propphraseKey', 'boiling_point')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_property_value">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="boiling_point"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:if>
                      <xsl:if test="properties/vapour_pressure">
                        <div class="pollutant_property_label">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('propphraseKey', 'vapour_pressure')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_property_value">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="vapour_pressure"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:if>
                      <xsl:if test="properties/water_solubility">
                        <div class="pollutant_property_label">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('propphraseKey', 'water_solubility')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_property_value">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="water_solubility"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:if>
                      <xsl:if test="properties/partition_coeff">
                        <div class="pollutant_property_label">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('propphraseKey', 'partition_coeff')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_property_value">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="partition_coeff"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:if>
                      <xsl:if test="properties/dissocation_const">
                        <div class="pollutant_property_label">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('propphraseKey', 'dissocation_const')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_property_value">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="dissocation_const"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:if>
                      <xsl:if test="properties/ph">
                        <div class="pollutant_property_label">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('propphraseKey', 'ph')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_property_value">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="ph"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:if>
                      <xsl:if test="properties/flammable_limits">
                        <div class="pollutant_property_label">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('propphraseKey', 'flammable_limits')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_property_value">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="flammable_limits"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:if>
                      <xsl:if test="properties/flash_point">
                        <div class="pollutant_property_label">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('propphraseKey', 'flash_point')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_property_value">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="flash_point"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:if>
                      <xsl:if test="properties/autoignition_temp">
                        <div class="pollutant_property_label">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('propphraseKey', 'autoignition_temp')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_property_value">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="autoignition_temp"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:if>
                      <xsl:if test="properties/density">
                        <div class="pollutant_property_label">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('propphraseKey', 'density')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_property_value">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="density"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:if>
                      <xsl:if test="properties/vapour_density">
                        <div class="pollutant_property_label">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('propphraseKey', 'vapour_density')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_property_value">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="vapour_density"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:if>
                      <!--Spacer-->
                      <div class="pollutant_sub_head">
                        <br />
                      </div>
                      <!--Health and Environment Section-->
                      <div class="pollutant_sub_head">
                        <xsl:for-each select="$LabelLookups">
                          <xsl:value-of select="key('labelKey', 'impacts')"/>
                        </xsl:for-each>
                      </div>
                      <xsl:if test="health_and_environment/aquatic_tox_ec50">
                        <div class="pollutant_property_label">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('propphraseKey', 'aquatic_tox_ec50')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_property_value">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="aquatic_tox_ec50"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:if>
                      <xsl:if test="health_and_environment/aquatic_tox_lc50">
                        <div class="pollutant_property_label">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('propphraseKey', 'aquatic_tox_lc50')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_property_value">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="aquatic_tox_lc50"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:if>
                      <xsl:if test="health_and_environment/aquatic_tox_lclod">
                        <div class="pollutant_property_label">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('propphraseKey', 'aquatic_tox_lclod')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_property_value">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="aquatic_tox_lclod"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:if>
                      <xsl:if test="health_and_environment/aquatic_tox_lg50">
                        <div class="pollutant_property_label">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('propphraseKey', 'aquatic_tox_lg50')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_property_value">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="aquatic_tox_lg50"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:if>
                      <xsl:if test="health_and_environment/bioaccumulation">
                        <div class="pollutant_property_label">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('propphraseKey', 'bioaccumulation')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_property_value">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="bioaccumulation"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:if>
                      <xsl:if test="health_and_environment/biological_ox_demand">
                        <div class="pollutant_property_label">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('propphraseKey', 'biological_ox_demand')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_property_value">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="biological_ox_demand"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:if>
                      <xsl:if test="health_and_environment/carcinogenicity">
                        <div class="pollutant_property_label">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('propphraseKey', 'carcinogenicity')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_property_value">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="carcinogenicity"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:if>
                      <xsl:if test="health_and_environment/marine_tox">
                        <div class="pollutant_property_label">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('propphraseKey', 'marine_tox')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_property_value">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="marine_tox"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:if>
                      <xsl:if test="health_and_environment/mutagenicity">
                        <div class="pollutant_property_label">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('propphraseKey', 'mutagenicity')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_property_value">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="mutagenicity"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:if>
                      <xsl:if test="health_and_environment/persistence">
                        <div class="pollutant_property_label">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('propphraseKey', 'persistence')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_property_value">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="persistence"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:if>
                      <xsl:if test="health_and_environment/toxicity">
                        <div class="pollutant_property_label">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('propphraseKey', 'toxicity')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_property_value">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="toxicity"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:if>
                      <xsl:if test="health_and_environment/WEL_OEL">
                        <div class="pollutant_property_label">
                          <xsl:for-each select="$PhraseLookups">
                            <xsl:value-of select="key('propphraseKey', 'WEL_OEL')"/>
                          </xsl:for-each>
                        </div>
                        <div class="pollutant_property_value">
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:value-of select="WEL_OEL"/>
                            </xsl:for-each>
                          </xsl:for-each>
                        </div>
                      </xsl:if>
                      <!--Spacer-->
                      <div class="pollutant_sub_head">
                        <br />
                      </div>
                    </div>
                    <!--Other relevant reporting requirements (other Provisions)-->
                    <div class="second_resultSheet_content pollutantProvisions" style="display:none;">
                      <!--Other Regulations Section Header Text-->
                      <div class="pollutant_sub_head">
                        <xsl:for-each select="$LabelLookups">
                          <xsl:value-of select="key('labelKey', 'provother')"/>
                        </xsl:for-each>
                      </div>
                      <!--Other Regulations Data - loop through the 'other_provisions' entries for the pollutant-->
                      <xsl:for-each select="other_provisions/other_provision">
                        <xsl:variable name="phraseId" select="."/>
                        <!--Title/Instrument-->
                        <xsl:for-each select="$PhraseLookups">
                          <xsl:if test="key('provOthInstKey', $phraseId)">
                            <div class="pollutant_sub_head">
                              <xsl:value-of select="key('provOthInstKey', $phraseId)"/>
                            </div>
                          </xsl:if>
                        </xsl:for-each>
                        <!--Overview-->
                        <xsl:for-each select="$PhraseLookups">
                          <xsl:if test="key('provOthOverviewKey', $phraseId)">
                            <!--<b>Overview </b>-->
                            <div class="pollutant_sub_head">
                              <xsl:for-each select="$LabelLookups">
                                <xsl:value-of select="key('labelKey', 'provOverview')"/>
                              </xsl:for-each>
                            </div>
                            <div class="pollutant_data_item">
                              <xsl:copy-of select="key('provOthOverviewKey', $phraseId)"/>
                            </div>
                          </xsl:if>
                        </xsl:for-each>
                        <!--Reporting-->
                        <xsl:for-each select="$PhraseLookups">
                          <xsl:if test="key('provOthreportKey', $phraseId)">
                            <!--Variable to get specific reporting requirements - provisionId.pollutantId-->
                            <xsl:variable name="varName" select="concat($phraseId,'.', $pollutantId)"/>
                            <!--<b>Generic Reporting </b>-->
                            <div class="pollutant_sub_head">
                              <xsl:for-each select="$LabelLookups">
                                <xsl:value-of select="key('labelKey', 'provReportGeneric')"/>
                              </xsl:for-each>
                            </div>
                            <div class="pollutant_data_item">
                              <xsl:copy-of select="key('provOthreportKey', $phraseId)"/>
                            </div>
                            <xsl:if test="key('provOthreportKey', $varName)">
                              <!--<b>Specific Reporting </b>-->
                              <div class="pollutant_sub_head">
                                <xsl:for-each select="$LabelLookups">
                                  <xsl:value-of select="key('labelKey', 'provReportSpecific')"/>
                                </xsl:for-each>
                              </div>
                              <div class="pollutant_data_item">
                                <xsl:copy-of select="key('provOthreportKey', $varName)"/>
                              </div>
                            </xsl:if>
                          </xsl:if>
                        </xsl:for-each>
                      </xsl:for-each>
                      <!--Spacer-->
                      <div class="pollutant_sub_head">
                        <br />
                      </div>
                    </div>
                    <!--Provisions Under PRTR Section-->
                    <div class="second_resultSheet_content eprtrProvisions" style="display:none;">
                      <!--PRTR Regulation Section header-->
                      <div class="pollutant_sub_head">
                        <xsl:for-each select="$LabelLookups">
                          <xsl:value-of select="key('labelKey', 'provprtr')"/>
                        </xsl:for-each>
                      </div>
                      <!--PRTR Data Section-->
                      <div class="pollutant_data_item">
                        <!--Table for Data-->
                        <table width="99%">
                          <tr>
                            <!--Header For Table-->
                            <td colspan="3" align="center">
                              <b>
                                <xsl:for-each select="$LabelLookups">
                                  <xsl:value-of select="key('labelKey', 'threshold')"/>
                                </xsl:for-each>
                              </b>
                            </td>
                          </tr>
                          <!--Headings Row-->
                          <tr style="font-weight:bold">
                            <td align="center" style="border: solid 1px black">
                              <xsl:for-each select="$LabelLookups">
                                <xsl:value-of select="key('labelKey', 'air')"/>
                              </xsl:for-each>
                            </td>
                            <td align="center" style="border: solid 1px black">
                              <xsl:for-each select="$LabelLookups">
                                <xsl:value-of select="key('labelKey', 'water')"/>
                              </xsl:for-each>
                            </td>
                            <td align="center" style="border: solid 1px black">
                              <xsl:for-each select="$LabelLookups">
                                <xsl:value-of select="key('labelKey', 'land')"/>
                              </xsl:for-each>
                            </td>
                          </tr>
                          <!--Data Row-->
                          <tr >
                            <xsl:for-each select="prtr_provisions/prtr_provision">
                              <td align="center" style="border: solid 1px black">
                                <xsl:value-of select="."/>
                              </td>
                            </xsl:for-each>
                          </tr>
                        </table>
                        <br />
                        <div class="pollutant_data_item">
                          <xsl:for-each select="$LabelLookups">
                            <xsl:value-of select="key('labelKey', 'provprtrNote')"/>
                          </xsl:for-each>
                        </div>
                        <xsl:if test="prtr_provisions/btex">
                          <div class="pollutant_data_item">
                            <xsl:for-each select="$LabelLookups">
                              <xsl:value-of select="key('labelKey', 'provprtrNote2')"/>
                            </xsl:for-each>
                          </div>
                        </xsl:if>
                      </div>
                      <!--Spacer-->
                      <div class="pollutant_sub_head">
                        <br />
                      </div>
                    </div>
                    <!--Measurement & calculation methods (iso)-->
                    <div class="second_resultSheet_content measurement" style="display:none;">
                      <!--ISO HEader-->
                      <div class="pollutant_sub_head">
                        <xsl:for-each select="$LabelLookups">
                          <xsl:value-of select="key('labelKey', 'proviso')"/>
                        </xsl:for-each>
                      </div>
                      <!--ISO Data-->
                      <div class="pollutant_data_item">
                        <table width="99%">
                          <tr style="border: solid thin black;font-weight:bold">
                            <td align="center" style="border: solid 1px black">
                              <xsl:for-each select="$LabelLookups">
                                <xsl:value-of select="key('labelKey', 'isostandard')"/>
                              </xsl:for-each>
                            </td>
                            <td align="center" style="border: solid 1px black">
                              <xsl:for-each select="$LabelLookups">
                                <xsl:value-of select="key('labelKey', 'isotitle')"/>
                              </xsl:for-each>
                            </td>
                            <td align="center" style="border: solid 1px black">
                              <xsl:for-each select="$LabelLookups">
                                <xsl:value-of select="key('labelKey', 'isotarget')"/>
                              </xsl:for-each>
                            </td>
                            <td align="center" style="border: solid 1px black">
                              <xsl:for-each select="$LabelLookups">
                                <xsl:value-of select="key('labelKey', 'isouncert')"/>
                              </xsl:for-each>
                            </td>
                          </tr>
                          <xsl:for-each select="$NameLookups">
                            <xsl:for-each select="key('LanguageSpecificKey', $pollutantId)">
                              <xsl:choose>
                                <xsl:when test="iso_provisions/provision">
                                  <xsl:for-each select="iso_provisions/provision">
                                    <tr style="border: solid 1px black">
                                      <td align="center" style="border: solid 1px black">
                                        <xsl:choose>
                                          <xsl:when test="standard">
                                            <xsl:value-of select="standard"/>
                                          </xsl:when>
                                          <xsl:otherwise>-</xsl:otherwise>
                                        </xsl:choose>
                                      </td>
                                      <td align="center" style="border: solid 1px black">
                                        <xsl:choose>
                                          <xsl:when test="title">
                                            <xsl:value-of select="title"/>
                                          </xsl:when>
                                          <xsl:otherwise>-</xsl:otherwise>
                                        </xsl:choose>
                                      </td>
                                      <td align="center" style="border: solid 1px black">
                                        <xsl:choose>
                                          <xsl:when test="target">
                                            <xsl:value-of select="target"/>
                                          </xsl:when>
                                          <xsl:otherwise>-</xsl:otherwise>
                                        </xsl:choose>
                                      </td>
                                      <td align="center" style="border: solid 1px black">
                                        <xsl:choose>
                                          <xsl:when test="uncertainty">
                                            <xsl:value-of select="uncertainty"/>
                                          </xsl:when>
                                          <xsl:otherwise>-</xsl:otherwise>
                                        </xsl:choose>
                                      </td>
                                    </tr>
                                  </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                  <tr style="border: solid 1px black">
                                    <td align="center" style="border: solid 1px black">-</td>
                                    <td align="center" style="border: solid 1px black">-</td>
                                    <td align="center" style="border: solid 1px black">-</td>
                                    <td align="center" style="border: solid 1px black">-</td>
                                  </tr>
                                </xsl:otherwise>
                              </xsl:choose>
                            </xsl:for-each>
                          </xsl:for-each>
                        </table>
                      </div>
                      <!--ISO Provisions Footer Info-->

                      <div class="pollutant_data_item">
                        <xsl:for-each select="$LabelLookups">
                          <xsl:value-of select="key('labelKey', 'isoFootNoteTitle')"/>
                        </xsl:for-each>
                      </div>
                      <div class="pollutant_data_item">
                        <xsl:for-each select="$LabelLookups">
                          <xsl:value-of select="key('labelKey', 'isoFootNote1')"/>
                        </xsl:for-each>
                      </div>
                      <div class="pollutant_data_item">
                        <xsl:for-each select="$LabelLookups">
                          <xsl:value-of select="key('labelKey', 'isoFootNote2')"/>
                        </xsl:for-each>
                      </div>
                      <div class="pollutant_data_item">
                        <xsl:for-each select="$LabelLookups">
                          <xsl:value-of select="key('labelKey', 'isoFootNote3')"/>
                        </xsl:for-each>
                        <a target="_blank">
                          <xsl:attribute name="href">
                            <xsl:for-each select="$LabelLookups">
                              <xsl:value-of select="key('labelKey', 'isoFootNoteLink1')"/>
                            </xsl:for-each>
                          </xsl:attribute>
                          <xsl:for-each select="$LabelLookups">
                            <xsl:value-of select="key('labelKey', 'isoFootNoteLink1')"/>
                          </xsl:for-each>
                        </a>
                        <xsl:for-each select="$LabelLookups">
                          <xsl:value-of select="key('labelKey', 'isoFootNote4')"/>
                        </xsl:for-each>
                        <a target="_blank">
                          <xsl:attribute name="href">
                            <xsl:for-each select="$LabelLookups">
                              <xsl:value-of select="key('labelKey', 'isoFootNoteLink2')"/>
                            </xsl:for-each>
                          </xsl:attribute>
                          <xsl:for-each select="$LabelLookups">
                            <xsl:value-of select="key('labelKey', 'isoFootNoteLink2')"/>
                          </xsl:for-each>
                        </a>
                        <xsl:for-each select="$LabelLookups">
                          <xsl:value-of select="key('labelKey', 'isoFootNote5')"/>
                        </xsl:for-each>
                      </div>
                      <div class="pollutant_data_item">
                        <xsl:for-each select="$LabelLookups">
                          <xsl:value-of select="key('labelKey', 'isoFootNote6')"/>
                        </xsl:for-each>
                      </div>
                      <!--Spacer-->
                      <div class="pollutant_sub_head">
                        <br />
                      </div>
                    </div>
                  </div>
                </td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>