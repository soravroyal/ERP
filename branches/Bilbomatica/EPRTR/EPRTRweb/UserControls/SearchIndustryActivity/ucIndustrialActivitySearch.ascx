<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucIndustrialActivitySearch.ascx.cs" Inherits="ucIndustrialActivitySearch" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Src="~/UserControls/SearchOptions/ucAreaSearchOption.ascx" TagName="AreaSearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchOptions/ucActivitySearchOption.ascx" TagName="ActivitySearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchOptions/ucYearSearchOption.ascx" TagName="YearSearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucInfo.ascx" TagName="Info" TagPrefix="eprtr" %>

<asp:UpdatePanel ID="upIndustrialActivity" runat="server">

    <ContentTemplate>
        
        <%--Help button has two css classes--%>
        <eprtr:Info ID="infoSearchHelp" CssClass="searchHelpIcon infoIcon" Type="FacilitySearchHelp"  runat="server" />
                    
        <%--Area search option--%>
        <div class="searchOption_area">
            <eprtr:AreaSearchOption ID="ucAreaSearchOption" runat="server" />
        </div>
        
        <%--Year search option--%>
        <div class="searchOption_year">
            <eprtr:YearSearchOption ID="ucYearSearchOption" runat="server" />
        </div>
        
        
        <asp:Panel ID="plActivityOptions" GroupingText="<%$Resources:Common,Activity%>" runat="server" CssClass="searchOption_activity">
            <%--Icons--%>
            <div class="panelIcons">
                <eprtr:Info ID="infoActivity" CssClass="infoIcon" Type="Activity" runat="server" />
            </div>
        
            <%-- activity content --%>
            <eprtr:ActivitySearchOption ID="ucActivitySearchOption" runat="server" />
        </asp:Panel>
        
        
    <asp:Panel ID="plButton" runat="server">
      <%-- search button --%>
      <asp:Button ID="btnSearch" runat="server" Text="<%$ Resources:Common,SearchButton %>" OnClick="btnSearch_Click"  CssClass="search_button" OnClientClick="ShowWaitIndicator();" />
      <%-- Wait icon, source is set by javascript --%>
      <img id="waitindicator" class="search_indicator" alt="" src="images/loader.gif" />         
    </asp:Panel>
    
    </ContentTemplate>
    <Triggers><asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" /></Triggers>

</asp:UpdatePanel>
