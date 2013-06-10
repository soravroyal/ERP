<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPopup.master" CodeFile="PopupFacilityDetails.aspx.cs" Inherits="PopupFacilityDetails" %>

<%@ Register Src="~/UserControls/SearchFacility/ucFacilitySheet.ascx" TagName="FacilitySheet" TagPrefix="eprtr"%>
<%@ Register Src="~/UserControls/SearchFacilityEPER/ucFacilitySheetEPER.ascx" TagName="FacilitySheetEPER" TagPrefix="eprtr"%>

<asp:Content ID="infoarea" ContentPlaceHolderID="ContentInfoArea" runat="server">
    <eprtr:FacilitySheet ID="ucFacilitySheet" runat="server" />
    <eprtr:FacilitySheetEPER ID="ucFacilitySheetEPER" runat="server" />
</asp:Content>


