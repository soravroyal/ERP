<%@ Control Language="C#" CodeFile="ucFacilityDetailsEPER.ascx.cs" EnableViewState="true" Inherits="ucFacilityDetails" %>

<%@ Register Src="~/UserControls/SearchFacility/ucFacilityDetailsMap.ascx" TagName="ucFacilityDetailsMap" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucInfoEPER.ascx" TagName="InfoEPER" TagPrefix="eprtr" %>

<asp:Panel ID="facilityDetailsPanel" runat="server" Width="100%" Height="100%">
        
        <%--<%$ Common:PrintRefresh %>--%>
        <div id="facilityimage">
           <!-- <eprtr:ucFacilityDetailsMap ID="ucFacilityDetailsMap" runat="server" />-->
             <div class="facilityMap">
                <script type="text/javascript">
                    //<![CDATA[
                    var path_location = location.pathname.replace(/\/[^/]+$/, '');            
                     path_location +='/JS_Map_Min';          
                     var dojoConfig = {
                        parseOnLoad: true,
                        packages: [ { 
                                name: "utilities",
                                location: path_location + '/javascript' 
                             },{
                                name: "templateConfig",
                                location: path_location 
                             }
                        ],
		                modulePaths: {
                            'agsjs': path_location + '/javascript/agsjs'
                        }
                      };
                    // ]]>
                </script>
                <script type="text/javascript" src="//serverapi.arcgisonline.com/jsapi/arcgis/3.5"></script>
                <script type="text/javascript" src="JS_Map_Min/javascript/layout.js"></script>
    
                <script type="text/javascript">
                    $(document).ready(function () {
                        // NOT DELETE - Necesary to create the map_details with the filter of FacilityReportID
                        var facilityReportID = $('#ctl00_ContentPlaceHolderMaster_ContentInfoArea_ucFacilitySheetEPER_TextBox1').val();

                        //<![CDATA[
                        dojo.require("utilities.app");
                        dojo.require("templateConfig.commonConfig");

                        dojo.ready(function () {

                            var defaults = {
                                //webmap: "40c4c1892d5a45539b0ee95a0cae7b65",
                                webmap: "29ca3f3396f34d19b612c18870f6efb9",
                                bingmapskey: commonConfig.bingMapsKey,
                                sharingurl: "",
                                proxyurl: "",
                                helperServices: commonConfig.helperServices,
                                autoquery: "false",
                                zoomto: "true",
                                mapName: "map_details",
                                reportid: facilityReportID,
                                serviceName: "http://discomap.eea.europa.eu/ArcGIS/rest/services/Air/EprtrFacilities_Dyna_WGS84/MapServer/1",
                                layerID: "EprtrFacilities_Dyna_WGS84_1098"

                            };


                            var app = new utilities.App(defaults);
                            app.init().then(function (options) {
                                init(options);
                            });

                        });
                    });
                    // ]]>

                </script>


                <div class="claroMin">
                    <div id="map_details" style="width:400px;height:400px;"></div>
                </div>
            </div> 

            <asp:Image id="detailmapprint" ImageUrl="" alt="<%$ Resources:Common,PrintRefresh %>" runat="server" visible="true" CssClass="facilityMapPrint" />
        </div>
        
        
        <div id="facilityreportdetails">
            <asp:GridView ID="facilityreportDetails" OnRowDataBound="GridView1_RowDataBound"
                runat="server" ShowHeader="false" AutoGenerateColumns="false" GridLines="none"
                EmptyDataRowStyle-Height="0px" RowHeaderColumn="Label">
                <Columns>
                    <asp:BoundField DataField="Label" ></asp:BoundField>
                    <asp:BoundField DataField="Value" ></asp:BoundField>
                </Columns>
            </asp:GridView>
        </div>
        
        <%-- activities --%>
        <div id="facilityreportActivity">
           <asp:GridView ID="gdwActivities" runat="server" GridLines="Horizontal"
            ShowHeader="true" AutoGenerateColumns="false" OnRowDataBound="ActivityRowDataBound"
            CssClass="generalListStyle"
            RowStyle-CssClass= "generalListStyle_row" 
            HeaderStyle-CssClass="generalListStyle_headerRow"
            UseAccessibleHeader="true">
                <Columns>
                    <asp:TemplateField>
                        <HeaderTemplate>
                            <eprtr:InfoEPER ID="ucActivityInfo" Type="Activity" Text="<%$ Resources:Facility,IndustrialActivities %>" CssClass="facilityActivity" runat="server" />
                        </HeaderTemplate>
                        <ItemTemplate>
                            <div class="<%#GetIndentCss(Container.DataItem) %> facilityActivity">
                                <asp:Literal ID="lblActivity" Text="<%#GetActivityName(Container.DataItem) %>" runat="server"></asp:Literal>
                            </div>                            
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <HeaderTemplate>
                            <div class="facilityIPPC">
                                <asp:Literal ID="lblHeaderIPPC" Text="<%$ Resources:Facility,IPPCcode %>" runat="server"></asp:Literal>
                            </div>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <div class="facilityIPPC">
                                <asp:Literal ID="lblIPPC" Text="<%#GetIPPC(Container.DataItem) %>" runat="server"></asp:Literal>
                            </div>                            
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>  
        <%-- public info --%>
        <div id="publicinfo">
            <asp:Literal ID="litPublicInfo" Text="<%$ Resources:Common,PublicInfo %>" runat="server"></asp:Literal><br />
            <asp:TextBox ID="txPublicInfo" Font-Size="Small" Wrap="true" ReadOnly="true" Height="50" Width="100%" TextMode="MultiLine" runat="server"></asp:TextBox>
        </div>
      
</asp:Panel>
