<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucWasteTypeSelector.ascx.cs"
    Inherits="ucWasteTypeSelector" %>
<%@ Register Assembly="__code" Namespace="EprtrServerControls" TagPrefix="eprtr" %>
<div id="radiobuttons" class="RadioButtonSelector" runat="server">
    <table>
        <tr>
            <td>
                <div class="WasteTypeSelectorLabel">
                    <asp:Literal ID="litTransferOfWasteType" runat="server" Text="<%$ Resources:WasteTransfers,ShowFacilitiesWithTransferOfWasteType %>"></asp:Literal>
                </div>
            </td>
            <td>
                <eprtr:TwoLineRadioButtonList CssClass="SelectorList" ID="rblWasteTypeSelector" runat="server"
                    CellSpacing="2" RepeatDirection="Horizontal" OnSelectedIndexChanged="onSelectedIndexChanged"
                    AutoPostBack="true">
                </eprtr:TwoLineRadioButtonList>
            </td>
        </tr>
    </table>
</div>
<br />
