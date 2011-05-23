<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PopupLibraryEmissionsEPER.aspx.cs" Inherits="PopupLibraryEmissionsEPER" %>

<%@ Register Src="~/UserControls/Library/ucLibraryPollutantsEPER.ascx"  TagName="LibraryPollutantsEPER" TagPrefix="eprtr"%>

<asp:Content ID="ContentInfoArea" ContentPlaceHolderID="ContentInfoArea" runat="server">


   
    <div id="content"><eprtr:LibraryPollutantsEPER ID="ucLibraryPollutantsEPER" runat="server" /></div>

</asp:Content>
