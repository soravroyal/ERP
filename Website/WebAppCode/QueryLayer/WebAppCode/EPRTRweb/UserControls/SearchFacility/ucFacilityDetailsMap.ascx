<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucFacilityDetailsMap.ascx.cs" Inherits="ucFacilityDetailsMap" %>
<%@ Register TagPrefix="nfp" TagName="NoFlashPlayer" Src="~/UserControls/Common/ucNoFlashPlayer.ascx" %>

<%-- detail map --%>
<asp:Panel ID="detailmapPanel" runat="server"  CssClass="facilityMap">

    <div id="facilitydetailmap" runat="server" visible="true">
        
        <%--<nfp:NoFlashPlayer ID="NoFlashPlayer" runat="server" />--%>

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
        <script type="text/javascript" src="~/JS_Map_Min/javascript/layout.js"></script>
    
        <script type="text/javascript">
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
                    mapName: "map_extended"
                };


                var app = new utilities.App(defaults);
                app.init().then(function (options) {
                    init(options);
                });

            });
            // ]]>
        </script>


        <div class="claroMin">
            <div id="miMapa" style="width:400px;height:400px;"></div>
        </div>

    </div>


  
</asp:Panel>

