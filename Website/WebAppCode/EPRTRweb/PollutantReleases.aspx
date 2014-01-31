<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="true" MasterPageFile="~/MasterSearchPage.master" CodeFile="PollutantReleases.aspx.cs" Inherits="PollutantReleases" %>

<%@ Register Src="~/UserControls/SearchPollutantReleases/ucPollutantReleasesSearch.ascx" TagName="PollutantReleasesSearch" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchPollutantReleases/ucPollutantReleasesSheet.ascx" TagName="ucPollutantReleasesSheet" TagPrefix="eprtr" %>


<asp:Content ID="cSubHeadline" ContentPlaceHolderID="ContentSubHeadline" runat="server">
    <asp:Literal ID="litHeader" Text="<%$ Resources:Pollutant,PollutantReleasesSubHeadline %>" runat="server" />
</asp:Content>

<asp:Content ID="cSearchForm" ContentPlaceHolderID="ContentSearchForm" Runat="Server">
    <eprtr:PollutantReleasesSearch ID="ucSearchOptions" runat="server" />
</asp:Content>

<asp:Content ID="cResultArea" ContentPlaceHolderID="ContentResultArea" Runat="Server" >
  <eprtr:ucPollutantReleasesSheet ID="ucPollutantReleasesSheet" runat="server" />   
</asp:Content>
<asp:Content ID="divMAPA" ContentPlaceHolderID="JSMap" runat="server"> 
    <script type="text/javascript">
        // Function that loads the full size map in the collapse div
        function mapLoad(strYears) {
            var defaults = {
                //webmap: "40c4c1892d5a45539b0ee95a0cae7b65",
                webmap: "29ca3f3396f34d19b612c18870f6efb9",
                bingmapskey: commonConfig.bingMapsKey,
                sharingurl: "",
                proxyurl: "",
                helperServices: commonConfig.helperServices,
                autoquery: "false",
                zoomto: "true",
                years: strYears,
                mapName: "map_extended"
            };

            var app = new utilities.App(defaults);
            app.init().then(function (options) {
                init(options);
            });

            //document.getElementById("map_extended").style.top = "-10000px";
        }
    </script>

    <div class="claro">   
       <div id="map_extended" style="position:absolute;top:-10000px">
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

