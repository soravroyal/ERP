<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="true" MasterPageFile="~/MasterSearchPageEPER.master" CodeFile="FacilityLevelsEPER.aspx.cs" Inherits="FacilityLevelsEPER" %>

<%@ Register src="~/UserControls/SearchFacilityEPER/ucFacilitySearchEPER.ascx" tagname="ucFacilitySearchEPER" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/SearchFacilityEPER/ucFacilityListSheetEPER.ascx" tagname="ucFacilityListSheetEPER" tagprefix="eprtr" %>


<asp:Content ID="cSubHeadlineFacility" ContentPlaceHolderID="ContentSubHeadline" runat="server">
    <asp:Literal ID="litHeaderFacility" Text="<%$ Resources:Facility,SubHeadlineEPER %>" runat="server" />
</asp:Content>
 
<asp:Content ID="cSearchFormFacility" ContentPlaceHolderID="ContentSearchForm" Runat="Server">
    <eprtr:ucFacilitySearchEPER ID="ucSearchOptionsEPER" runat="server" />
</asp:Content>

<asp:Content ID="cResultAreaFacility" ContentPlaceHolderID="ContentResultArea" Runat="Server" >
    <eprtr:ucFacilityListSheetEPER ID="ucFacilityListSheetEPER" runat="server" />
</asp:Content>

<asp:Content ID="divMAPA" ContentPlaceHolderID="JSMap" runat="server"> 
    <script type="text/javascript">
    //<![CDATA[
        function mapLoad() {

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

            document.getElementById("map_extended").style.top = "-10000px";

        }
        // ]]>
    </script>

    <div class="claro">    
        <div id="map_extended"  style="position:absolute">
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

</asp:Content> 