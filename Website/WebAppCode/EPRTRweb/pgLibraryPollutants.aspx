<%@ Page Language="C#" AutoEventWireup="true" CodeFile="pgLibraryPollutants.aspx.cs" Inherits="pgLibraryPollutants" %>

<%@ Register Src="~/UserControls/Library/ucLibraryPollutants.ascx"  TagName="LibraryPollutants" TagPrefix="eprtr"%>

<asp:Content ID="ContentInfoArea" ContentPlaceHolderID="ContentInfoArea" runat="server">


   
    <div id="content"><eprtr:LibraryPollutants ID="ucLibraryPollutants" runat="server" /></div>

</asp:Content>
