<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucFacilitySearchEPER.ascx.cs" Inherits="ucFacilitySearchEPER" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Src="~/UserControls/SearchOptionsEPER/ucAreaSearchOptionEPER.ascx" TagName="AreaSearchOptionEPER" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchOptionsEPER/ucYearSearchOptionEPER.ascx" TagName="YearSearchOptionEPER" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchOptions/ucFacilityLocationSearchOption.ascx" TagName="FacilityLocationSearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchOptionsEPER/ucAdvancedActivitySearchOptionEPER.ascx" TagName="AdvancedActivitySearchOptionEPER" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchOptionsEPER/ucAdvancedPollutantSearchOptionEPER.ascx" TagName="AdvancedPollutantSearchOptionEPER" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucInfoEPER.ascx" TagName="Info" TagPrefix="eprtr" %>


<asp:UpdatePanel ID="upSearchFacility" runat="server" UpdateMode="Conditional">

    <ContentTemplate>
        <asp:Panel ID="pnlSearch" DefaultButton="btnSearch"  runat="server" >
        
            <%--Area search option--%>
            <div class="searchOption_area">
                <eprtr:AreaSearchOptionEPER ID="ucAreaSearchOptionEPER" runat="server" />
            </div>
            
            <%--Year search option--%>
            <div class="searchOption_year">
                <eprtr:YearSearchOptionEPER ID="ucYearSearchOptionEPER"   runat="server" />
            </div>
            
            <%--Facility name and town--%>
            <eprtr:FacilityLocationSearchOption ID="ucFacilityLocationSearchOption"  runat="server" />
            
            <eprtr:AdvancedActivitySearchOptionEPER ID="ucAdvancedActivitySearchOptionEPER"  runat="server" />
            
            <eprtr:AdvancedPollutantSearchOptionEPER ID="ucAdvancedPollutantSearchOptionEPER"  runat="server" />
            
                   
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

