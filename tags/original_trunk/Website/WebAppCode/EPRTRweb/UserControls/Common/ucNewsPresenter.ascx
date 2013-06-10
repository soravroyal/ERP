<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucNewsPresenter.ascx.cs"
    Inherits="ucNewsPresenter" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Repeater ID="repNews" runat="server">
    <ItemTemplate>
        <ajaxToolkit:CollapsiblePanelExtender ID="cpeNews" runat="Server" Collapsed="true"
            TargetControlID="PanelContent" ExpandControlID="PanelHeader" CollapseControlID="PanelHeader"
            SuppressPostBack="true">
        </ajaxToolkit:CollapsiblePanelExtender>
        <div id="timeStamp">
            <%# GetTimeStamp(Container.DataItem)%>
            <div id="PanelHeaderStyle">
                <asp:Panel ID="PanelHeader" runat="server">
                    <%# GetHeaderText(Container.DataItem)%>
                </asp:Panel>
            </div>
        </div>
        <div id="contentPanelArea">
            <div id="PanelContentStyle">
                <asp:Panel ID="PanelContent" runat="server">
                    <div id="contentBorderSettings">
                        <asp:Literal ID="Literal3" Text='<%# GetBodyText(Container.DataItem) %>' Mode="Transform"
                            runat="server" />
                    </div>
                </asp:Panel>
            </div>
        </div>
    </ItemTemplate>
</asp:Repeater>

<asp:Label ID="lbNoNews" Text="<%$ Resources:Common, NoNewsInCategory%>" runat="server" Visible="false"/>
