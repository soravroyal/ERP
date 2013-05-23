<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPopup.master" CodeFile="PopupLibraryPollutants.aspx.cs" Inherits="PopupLibraryPollutants" %>

<%@ Register Src="~/UserControls/Library/ucLibraryPollutants.ascx"  TagName="LibraryPollutants" TagPrefix="eprtr"%>

<asp:Content ID="infoarea" ContentPlaceHolderID="ContentInfoArea" runat="server">
    <eprtr:LibraryPollutants ID="ucLibraryPollutants" runat="server" />
</asp:Content>
