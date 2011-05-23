<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucMediumSearchOptionEPER.ascx.cs" Inherits="ucMediumSearchOptionEPER" %>

<asp:Literal ID="litReleasesTo" runat="server" Text="<%$ Resources:Common,EmissionsTo %>"></asp:Literal>
<asp:CheckBox ID="chkAir" Text="<%$ Resources:Common,Air %>" Checked="true" runat="server" />
<asp:CheckBox ID="chkWater" Text="<%$ Resources:Common,WaterDirect %>" Checked="true" runat="server" />
<asp:CheckBox ID="chkSoil" Text="<%$ Resources:Common,WaterIndirect %>"  Checked="true" runat="server" />

