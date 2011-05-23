<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucAdvancedActivitySearchOptionEPER.ascx.cs" Inherits="ucAdvancedActivitySearchOptionEPER" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Src="~/UserControls/SearchOptionsEPER/ucActivitySearchOptionEPER.ascx" TagName="ActivitySearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucInfoEPER.ascx" TagName="Info" TagPrefix="eprtr" %>

<%--Activity search option--%>

<asp:UpdatePanel ID="upActivity" runat="server">
    <ContentTemplate>

    <ajaxToolkit:CollapsiblePanelExtender ID="cpeActivity" runat="Server" 
        TargetControlID="plActivityContent" 
        ExpandControlID="imgControlActivity" 
        CollapseControlID="imgControlActivity"
        CollapsedSize="0"
        ExpandedText="<%$Resources:Common,Collapse%>"
        CollapsedText="<%$Resources:Common,Expand%>"
        ImageControlID="imgControlActivity" 
        ExpandedImage="~/images/collapse_blue.jpg"
        CollapsedImage="~/images/expand_blue.jpg" 
        Collapsed="true">
    </ajaxToolkit:CollapsiblePanelExtender>

    <asp:Panel ID="plActivityOptions" GroupingText="<%$Resources:Common,Activity%>" runat="server" CssClass="searchOption_activity" >
        <%--Icons--%>
        <div class="panelIcons">
            <asp:ImageButton ID="imgControlActivity" CssClass="collapseIcon" runat="server" ImageUrl="~/images/expand_blue.jpg" OnClick="expandActivityClick"/>
            <eprtr:Info ID="infoActivity" CssClass="infoIcon" Type="Activity"  runat="server" />
        </div>
        
        <%--expand label--%>
        <asp:Label ID="lblActivity" Text="<%$Resources:Common,Expand%>" runat="server" CssClass="cpeTextLabel"></asp:Label>

        <%-- activity content --%>
        <asp:Panel ID="plActivityContent" runat="server" CssClass="cpeContent">
            <eprtr:ActivitySearchOption ID="ucActivitySearchOption" runat="server" />
        </asp:Panel>
    </asp:Panel>

</ContentTemplate>

</asp:UpdatePanel>
