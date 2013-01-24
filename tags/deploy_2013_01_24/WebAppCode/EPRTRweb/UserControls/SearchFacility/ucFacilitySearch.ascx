<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucFacilitySearch.ascx.cs" Inherits="ucFacilitySearch" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Src="~/UserControls/SearchOptions/ucAreaSearchOption.ascx" TagName="AreaSearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchOptions/ucYearSearchOption.ascx" TagName="YearSearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchOptions/ucFacilityLocationSearchOption.ascx" TagName="FacilityLocationSearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchOptions/ucAdvancedActivitySearchOption.ascx" TagName="AdvancedActivitySearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchOptions/ucAdvancedPollutantSearchOption.ascx" TagName="AdvancedPollutantSearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchOptions/ucAdvancedWasteSearchOption.ascx" TagName="AdvancedWasteSearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucInfo.ascx" TagName="Info" TagPrefix="eprtr" %>

<asp:UpdatePanel ID="upSearchFacility" runat="server" UpdateMode="Conditional">

    <ContentTemplate>
        <asp:Panel ID="pnlSearch" DefaultButton="btnSearch"  runat="server" >
        
            <%--Help button has two css classes--%>
            <eprtr:Info ID="infoSearchHelp" CssClass="searchHelpIcon infoIcon" Type="FacilitySearchHelp"  runat="server" />
            
        
            <%--Area search option--%>
            <div class="searchOption_area">
                <eprtr:AreaSearchOption ID="ucAreaSearchOption" runat="server" />
            </div>
            
            <%--Year search option--%>
            <div class="searchOption_year">
                <eprtr:YearSearchOption ID="ucYearSearchOption"   runat="server" />
            </div>
            
            <%--Facility name and town--%>
            <eprtr:FacilityLocationSearchOption ID="ucFacilityLocationSearchOption"  runat="server" />
            
            <eprtr:AdvancedActivitySearchOption ID="ucAdvancedActivitySearchOption"  runat="server" />
            
            <eprtr:AdvancedPollutantSearchOption ID="ucAdvancedPollutantSearchOption"  runat="server" />
            
            <eprtr:AdvancedWasteSearchOption ID="ucAdvancedWasteSearchOption"  runat="server" />

            
            <asp:Panel ID="plButton" runat="server">
              <%-- search button --%>
              <asp:Button ID="btnSearch" runat="server" Text="<%$ Resources:Common,SearchButton %>" OnClick="btnSearch_Click" CssClass="search_button" OnClientClick="ShowWaitIndicator();" />
              
              <%-- Wait icon --%>
              <img id="waitindicator" class="search_indicator" alt="" src="images/loader.gif" />      
            </asp:Panel>
    
        </asp:Panel>
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
    </Triggers>

</asp:UpdatePanel>


