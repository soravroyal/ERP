<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucYearCompareSeries.ascx.cs" Inherits="ucYearCompareSeries" %>

<asp:Label ID="lbYearCompare" Text="<%$Resources:Common,TimeSeriesCompareYears%>" runat="server"></asp:Label><br />
<asp:DropDownList ID="cbYear1" AutoPostBack="true" OnSelectedIndexChanged="onYear1Changed" Width="50" runat="server" />
<asp:Label ID="lbAnd" Text="<%$Resources:Common,TimeSeriesCompareAnd%>" runat="server"></asp:Label>
<asp:DropDownList ID="cbYear2" AutoPostBack="true" OnSelectedIndexChanged="onYear2Changed" Width="50" runat="server" />
