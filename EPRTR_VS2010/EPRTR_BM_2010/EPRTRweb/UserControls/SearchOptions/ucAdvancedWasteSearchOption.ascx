<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucAdvancedWasteSearchOption.ascx.cs" Inherits="ucAdvancedWasteSearchOption" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Src="~/UserControls/SearchOptions/ucWasteTypeSearchOption.ascx" TagName="WasteTypeSearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchOptions/ucWasteTreatmentSearchOption.ascx" TagName="WasteTreatmentSearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchOptions/ucWasteReceiverSearchOption.ascx" TagName="WasteReceiverSearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucInfo.ascx" TagName="Info" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucMsgWasteValidation.ascx" TagName="msgWaste" TagPrefix="eprtr" %>

<asp:UpdatePanel ID="upWaste" runat="server">
    <ContentTemplate>

        <%--Waste search option--%>
        <ajaxToolkit:CollapsiblePanelExtender ID="cpeWaste" runat="Server" 
            TargetControlID="plWasteContent" 
            ExpandControlID="imgControlWaste" 
            CollapseControlID="imgControlWaste"
            CollapsedSize="0"
            ExpandedText="<%$Resources:Common,Collapse%>"
            CollapsedText="<%$Resources:Common,Expand%>"
            ImageControlID="imgControlWaste" 
            ExpandedImage="~/images/collapse_blue.jpg"
            CollapsedImage="~/images/expand_blue.jpg" 
            Collapsed="true">
        </ajaxToolkit:CollapsiblePanelExtender>

        <asp:Panel ID="plWasteOptions" GroupingText="<%$Resources:Common,WasteTransfers%>" CssClass="searchOption_waste"  runat="server">
            <%--icons--%>
            <div class="panelIcons">
                <asp:ImageButton ID="imgControlWaste" CssClass="collapseIcon" runat="server" ImageUrl="~/images/expand_blue.jpg" OnClick="expandWasteClick" />
                <eprtr:Info ID="infoWaste"  CssClass="infoIcon" Type="Waste" runat="server" />
            </div>
            
            <%--expand label--%>
            <asp:Label ID="lblWaste2" Text="<%$Resources:Common,CurrentlyNotIncluded%>" runat="server" CssClass="cpeTextLabel2"></asp:Label>
            <asp:Label ID="lblWaste" Text="<%$Resources:Common,Expand%>" runat="server" CssClass="cpeTextLabel"></asp:Label>

            <%--content--%>
            <asp:Panel ID="plWasteContent" runat="server" CssClass="cpeContent">
                <eprtr:WasteTypeSearchOption ID="ucWasteTypeSearchOption" runat="server" />
                <eprtr:WasteTreatmentSearchOption ID="ucWasteTreatmenSearchOption" runat="server" />
                <eprtr:WastereceiverSearchOption ID="ucWasteReceiverSearchOption" runat="server" />
                <eprtr:msgWaste ID="ucMsgWaste" runat="server" /> 
            </asp:Panel>
        </asp:Panel>

    </ContentTemplate>
</asp:UpdatePanel>
