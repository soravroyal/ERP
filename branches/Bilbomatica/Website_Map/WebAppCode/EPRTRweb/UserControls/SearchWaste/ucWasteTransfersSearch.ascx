<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucWasteTransfersSearch.ascx.cs" Inherits="ucWasteTransfersSearch" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Src="~/UserControls/SearchOptions/ucAreaSearchOption.ascx" TagName="AreaSearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchOptions/ucYearSearchOption.ascx" TagName="YearSearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchOptions/ucAdvancedActivitySearchOption.ascx" TagName="AdvancedActivitySearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchOptions/ucWasteTypeSearchOption.ascx" TagName="WasteTypeSearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchOptions/ucWasteTreatmentSearchOption.ascx" TagName="WasteTreatmentSearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucInfo.ascx" TagName="Info" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucMsgWasteValidation.ascx" TagName="msgWaste" TagPrefix="eprtr" %>

<asp:UpdatePanel ID="upWasteTransfers" runat="server">

    <ContentTemplate>
        <%--Help button has two css classes--%>
        <eprtr:Info ID="infoSearchHelp" CssClass="searchHelpIcon infoIcon" Type="FacilitySearchHelp"  runat="server" />
        
        <%--Area search option--%>
        <div class="searchOption_area">
            <eprtr:AreaSearchOption ID="ucAreaSearchOption" runat="server" />
        </div>
        
        <%--Year search option--%>
        <div class="searchOption_year">
            <eprtr:YearSearchOption ID="ucYearSearchOption" IncludeEPER="true" runat="server" />
        </div>
        
        <%--Waste search option--%>
        <asp:Panel ID="plWasteOptions" GroupingText="<%$Resources:Common,WasteTransfers%>" CssClass="searchOption_waste" runat="server">
            <%--icons--%>
            <div class="panelIcons">
                <eprtr:Info ID="infoWaste" CssClass="infoIcon" Type="Waste" runat="server" />
            </div>
         
            <eprtr:WasteTypeSearchOption ID="ucWasteTypeSearchOption" runat="server" />
            <eprtr:WasteTreatmentSearchOption ID="ucWasteTreatmenSearchOption" runat="server" />
            <eprtr:msgWaste ID="ucMsgWaste" runat="server" /> 

      </asp:Panel>

        
        <%--Activity search option--%>
        <eprtr:AdvancedActivitySearchOption ID="ucAdvancedActivitySearchOption"  runat="server" />

    <asp:Panel ID="plButton" runat="server">
      <%-- search button --%>
      <asp:Button ID="btnSearch" runat="server" Text="<%$ Resources:Common,SearchButton %>" OnClick="btnSearch_Click" CssClass="search_button" OnClientClick="ShowWaitIndicator();" />
      
      <%-- Wait icon --%>
      <img id="waitindicator" class="search_indicator" alt="" src="images/loader.gif" />      
    </asp:Panel>
    
    </ContentTemplate>

</asp:UpdatePanel>
