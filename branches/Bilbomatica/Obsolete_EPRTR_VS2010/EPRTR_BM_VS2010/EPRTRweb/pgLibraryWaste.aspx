<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="pgLibraryWaste.aspx.cs" Inherits="pgLibraryWaste" %>

<%@ Register Src="~/UserControls/Library/ucLibraryWaste.ascx"  TagName="LibraryWaste" TagPrefix="eprtr"%>

<asp:Content ID="infoarea" ContentPlaceHolderID="ContentInfoArea" runat="server">
    <eprtr:LibraryWaste ID="ucLibraryWaste" runat="server" />
</asp:Content>