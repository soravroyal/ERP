<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPopupEPER.master" CodeFile="PopupLibraryActivitiesEPER.aspx.cs" Inherits="PopupLibraryActivtiesEPER" %>

<%@ Register Src="~/UserControls/Library/ucLibraryActivitiesEPER.ascx"  TagName="LibraryActivitiesEPER" TagPrefix="eprtr"%>

<asp:Content ID="infoarea" ContentPlaceHolderID="ContentInfoArea" runat="server">
    <eprtr:LibraryActivitiesEPER ID="ucLibraryActivitiesEPER" runat="server" />
</asp:Content>
