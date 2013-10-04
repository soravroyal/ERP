<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="true" MasterPageFile="~/MasterSearchPage.master" CodeFile="FacilityLevels.aspx.cs" Inherits="FacilityLevels" %>

<%@ Register src="~/UserControls/SearchFacility/ucFacilitySearch.ascx" tagname="ucFacilitySearch" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/SearchFacility/ucFacilityListSheet.ascx" tagname="ucFacilityListSheet" tagprefix="eprtr" %>

<asp:Content ID="cSubHeadlineFacility" ContentPlaceHolderID="ContentSubHeadline" runat="server">
    <asp:Literal ID="litHeaderFacility" Text="<%$ Resources:Facility,SubHeadline %>" runat="server" />
</asp:Content>
 
<asp:Content ID="cSearchFormFacility" ContentPlaceHolderID="ContentSearchForm" Runat="Server">
    <eprtr:ucFacilitySearch ID="ucSearchOptions" runat="server" />
</asp:Content>

<asp:Content ID="cResultAreaFacility" ContentPlaceHolderID="ContentResultArea" Runat="Server" >
    <eprtr:ucFacilityListSheet ID="ucFacilityListSheet" runat="server" />
</asp:Content>

<asp:Content ID="divMAPA" ContentPlaceHolderID="JSMap" runat="server"> 
    <script type="text/javascript">
    //<![CDATA[
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
                mapName: "miMapa2"
            };


            var app = new utilities.App(defaults);
            app.init().then(function (options) {
                init(options);
            });

        });
        // ]]>
    </script>

    <div class="claro">
        <div id="miMapa2" style="width:960px;height:750px;"></div>
    </div>

</asp:Content> 