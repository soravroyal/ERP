<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPopup.master" CodeFile="PopupLibraryActivities.aspx.cs" Inherits="PopupLibraryActivties" %>

<%@ Register Src="~/UserControls/Library/ucLibraryActivities.ascx"  TagName="LibraryActivities" TagPrefix="eprtr"%>

<asp:Content ID="infoarea" ContentPlaceHolderID="ContentInfoArea" runat="server">
    <eprtr:LibraryActivities ID="ucLibraryActivities" runat="server" />
</asp:Content>
