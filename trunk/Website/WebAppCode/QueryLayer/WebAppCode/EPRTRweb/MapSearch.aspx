<%@ Page Language="C#" AutoEventWireup="true"  MasterPageFile="~/MasterPage.master"
 CodeFile="MapSearch.aspx.cs" Inherits="MapJavascriptSearch" %>

<asp:Content ID="infoarea" ContentPlaceHolderID="ContentInfoArea" runat="server">
    <%--Java Script functions --%>

    <script type="text/javascript" src="Scripts/map.js"></script>

    <div class="StaticPageStyle">
        <h1>
            <asp:Literal ID="PageHeader" Text="<%$ Resources:MapSearch, MapSearchPageHeader%>" runat="server" />
        </h1>
        <p>
            <asp:Literal ID="PageContent" Text="<%$ Resources:MapSearch, MapSearchPageContent %>"
                runat="server"></asp:Literal>
        </p>
    <table>   
    <tr><td>
    <asp:Panel ID="mapSearchPanel" runat="server" Visible="true">
        <div id="mapSearch" visible="true" style="height:546px">
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
        <script type="text/javascript" src="//js.arcgis.com/3.7"></script>
        <script type="text/javascript" src="JS_Map_Min/javascript/layout.js"></script>
   
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
                        mapName: "map_viewer"
                    };


                    var app = new utilities.App(defaults);
                    app.init().then(function (options) {
                        init(options);
                    });

                });
                // ]]>
        </script>

    <div class="claro">
         
        <div id="map_viewer" style="width:750px;height:550px;position:absolute">
            <div id="floater">
                      <div id="searchDiv" style="width:600px;height:200px;">
					        <!--<img src="images/i_draw_point.png" id="btnPoint"  onMouseOver="this.style.cursor='pointer'" onClick="searchByPoint()"/>-->
					        <!--<img src="images/i_draw_poly.png" id="btnPolygon" onMouseOver="this.style.cursor='pointer'" onClick="searchByPolygon()"/>-->
			          </div>
             </div>
             <div id="search"></div> 
	         <div id="LocateButton"></div>
               <div style="position:absolute; left:20px; top:4px; z-Index:999;" id="basemapDiv">
          <div data-dojo-type="dijit/TitlePane" 
              data-dojo-props="title:'Basemap', closable:true,  open:false" class="dijitButtonNode">
           <div data-dojo-type="dijit/layout/ContentPane" style="width:380px; height:280px; overflow:auto;">
           <div id="basemapGallery" ></div></div>
         </div>
       </div>        
        </div>
    </div>
        </div>
    </asp:Panel>
    </td>
    </tr>
    </table>
    </div>
</asp:Content>

