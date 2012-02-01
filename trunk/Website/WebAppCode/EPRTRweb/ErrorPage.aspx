<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="ErrorPage.aspx.cs" Inherits="ErrorPage" %>

<asp:Content ID="infoarea" ContentPlaceHolderID="ContentInfoArea" runat="server">
<br />
<asp:Literal ID="litErrorHeader" runat="server" Text="<%$ Resources:Common,DefaultErrorMessage %>" />
<br />
<br />
<div style="color:Red;">
<asp:Literal ID="litErrorMessage" runat="server"></asp:Literal>
<br />
<br />
<asp:Literal ID="litStackTrace" runat="server"></asp:Literal>
</div>
<br />
<br />
</asp:Content>
