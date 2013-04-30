<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="pgLibraryActivities.aspx.cs" Inherits="pgLibraryActivties" %>

<%@ Register Src="~/UserControls/Library/ucLibraryActivities.ascx"  TagName="LibraryActivities" TagPrefix="eprtr"%>

<asp:Content ID="infoarea" ContentPlaceHolderID="ContentInfoArea" runat="server">
    <eprtr:LibraryActivities ID="ucLibraryActivities" runat="server" />
</asp:Content>
