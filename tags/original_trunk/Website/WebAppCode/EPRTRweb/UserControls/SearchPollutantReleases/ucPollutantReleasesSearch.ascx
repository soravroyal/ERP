<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucPollutantReleasesSearch.ascx.cs" Inherits="ucPollutantReleasesSearch" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Src="~/UserControls/SearchOptions/ucAreaSearchOption.ascx" TagName="AreaSearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchOptions/ucYearSearchOption.ascx" TagName="YearSearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchOptions/ucAdvancedActivitySearchOption.ascx" TagName="AdvancedActivitySearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchOptions/ucPollutantSearchOption.ascx" TagName="PollutantSearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchOptions/ucMediumSearchOption.ascx" TagName="MediumSearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucInfo.ascx" TagName="Info" TagPrefix="eprtr" %>

<asp:UpdatePanel ID="upPollutantReleases" runat="server">

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
        
        <%--Pollutant search option--%>
        <asp:Panel ID="plPollutantOptions" GroupingText="<%$Resources:Common,PollutantReleases%>" CssClass="searchOption_pollutant" runat="server">
            <div class="panelIcons">
                <eprtr:Info ID="infoPollutant" CssClass="infoIcon" Type="Pollutant" runat="server" />
            </div>
            <%--search option--%>
            <eprtr:PollutantSearchOption ID="ucPollutantSearchOption" runat="server" />
            <eprtr:MediumSearchOption ID="ucMediumSearchOption" runat="server" />
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
    <Triggers><asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" /></Triggers>

</asp:UpdatePanel>

