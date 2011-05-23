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