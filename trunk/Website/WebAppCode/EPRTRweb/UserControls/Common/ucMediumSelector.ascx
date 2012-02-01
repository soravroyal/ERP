<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucMediumSelector.ascx.cs"
    Inherits="ucMediumSelector" %>
<%@ Register Assembly="__code" Namespace="EprtrServerControls" TagPrefix="eprtr" %>
<div id="radiobuttons" class="RadioButtonSelector" runat="server">
    <table>
        <tr>
            <td>
                <asp:Literal ID="litReleasingToMedium" Text="<%$ Resources:Pollutant,ShowFacilitiesReleasingToMedium %>"
                    runat="server"></asp:Literal>
            </td>
            <td>
                <eprtr:TwoLineRadioButtonList ID="rblMediumSelector" RepeatDirection="Horizontal"
                    CellSpacing="5" runat="server" OnSelectedIndexChanged="onSelectedIndexChanged"
                    AutoPostBack="true">
                </eprtr:TwoLineRadioButtonList>
            </td>
        </tr>
    </table>
</div>
<br />
