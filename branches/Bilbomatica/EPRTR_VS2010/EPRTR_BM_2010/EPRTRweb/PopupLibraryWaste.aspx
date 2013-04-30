<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPopup.master" CodeFile="PopupLibraryWaste.aspx.cs" Inherits="PopupLibraryWaste" %>

<%@ Register Src="~/UserControls/Library/ucLibraryWaste.ascx"  TagName="LibraryWaste" TagPrefix="eprtr"%>

<asp:Content ID="infoarea" ContentPlaceHolderID="ContentInfoArea" runat="server">
    <eprtr:LibraryWaste ID="ucLibraryWaste" runat="server" />
</asp:Content>