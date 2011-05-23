<%@ Control Language="C#" AutoEventWireup="false" CodeFile="ucDownloadPrint.ascx.cs" Inherits="ucDownloadPrint" %>


<%-- Download and print icons --%>
<asp:UpdatePanel ID="dowloadbuttons" runat="server" >
  <ContentTemplate>
        <asp:ImageButton title="<%$ Resources:Web.sitemap,Download %>" ID="btndownload" ImageUrl="~/images/download.gif" OnClick="OnSave" runat="server" />
        <asp:ImageButton title="<%$ Resources:Common,Print %>" ID="btnPrint" ImageUrl="~/images/ico-print.gif" OnClientClick="" runat="server" />
  </ContentTemplate>
  <Triggers> 
    <asp:PostBackTrigger ControlID="btndownload"/>
  </Triggers>
</asp:UpdatePanel>
