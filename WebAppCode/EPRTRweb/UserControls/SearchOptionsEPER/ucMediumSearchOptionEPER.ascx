<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucMediumSearchOptionEPER.ascx.cs" Inherits="ucMediumSearchOptionEPER" %>

<asp:Literal ID="litReleasesTo" runat="server" Text="<%$ Resources:Common,EmissionsTo %>"></asp:Literal>
<asp:CheckBox ID="chkAir" Text="<%$ Resources:Common,Air %>" Checked="true" runat="server"  />
<input type="hidden" id="clIDchkAir" value="<%=chkAir.ClientID %>" />
<asp:CheckBox ID="chkWater" Text="<%$ Resources:Common,WaterDirect %>" Checked="true" runat="server" />
<input type="hidden" id="clIDchkWater" value="<%=chkWater.ClientID %>" />
<asp:CheckBox ID="chkSoil" Text="<%$ Resources:Common,WaterIndirect %>"  Checked="true" runat="server" />
<input type="hidden" id="clIDchkSoil" value="<%=chkSoil.ClientID %>" />
