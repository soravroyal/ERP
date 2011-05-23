<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucLanguageSelector.ascx.cs" Inherits="UserControls_Common_ucLanguageSelector" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<div id="langSelector" runat="server">
    
    <asp:Label ID="SelectLanguage" Text="Select language" CssClass="langDropBtnClass"
        runat="server" Width="120" />
    
    <asp:Panel ID="DropPanel1" runat="server" CssClass="langDropPanelClass">
        <asp:ListView ID="LangListView" runat="server">
            <LayoutTemplate>
                <asp:PlaceHolder runat="server" ID="itemPlaceholder"></asp:PlaceHolder>
            </LayoutTemplate>
            <ItemTemplate>
                <asp:LinkButton ID="LinkButton1" runat="server" CssClass="LangList" Text="<%# GetDisplayText(Container.DataItem) %>"
                    langcode="<%# GetCommandArgument(Container.DataItem)%>" OnClientClick="StoreLanguage(this); return false;">  </asp:LinkButton>
                <br />
            </ItemTemplate>
        </asp:ListView>
    </asp:Panel>
    
    <cc1:DropDownExtender ID="DropDownExtender2" TargetControlID="SelectLanguage" DropDownControlID="DropPanel1"
        runat="server" HighlightBackColor="#C6EBF7" DropArrowBackColor="#C6EBF7" DropArrowImageUrl="~/images/7px-ArrowDown_svg.png">
    </cc1:DropDownExtender>
</div>
