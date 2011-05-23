<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucAdvancedPollutantSearchOption.ascx.cs" Inherits="ucAdvancedPollutantSearchOption" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Src="~/UserControls/SearchOptions/ucPollutantSearchOption.ascx" TagName="PollutantSearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchOptions/ucMediumSearchOption.ascx" TagName="MediumSearchOption" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucInfo.ascx" TagName="Info" TagPrefix="eprtr" %>

<asp:UpdatePanel ID="upPollutant" runat="server"  >
    <ContentTemplate>

            <%--Pollutant search option--%>
            <ajaxToolkit:CollapsiblePanelExtender ID="cpePollutant" runat="Server" 
                TargetControlID="plPollutantContent" 
                ExpandControlID="imgControlPollutant" 
                CollapseControlID="imgControlPollutant"
                CollapsedSize="0"
                ExpandedText="<%$Resources:Common,Collapse%>"
                CollapsedText="<%$Resources:Common,Expand%>"
                ImageControlID="imgControlPollutant" 
                ExpandedImage="~/images/collapse_blue.jpg"
                CollapsedImage="~/images/expand_blue.jpg" 
                Collapsed="true"
                >
            </ajaxToolkit:CollapsiblePanelExtender>

            <asp:Panel ID="plPollutantOptions" GroupingText="<%$Resources:Common,PollutantReleasesAndTransfers%>" CssClass="searchOption_pollutant" runat="server">
                <%--icons--%>
                <div class="panelIcons">
                    <asp:ImageButton ID="imgControlPollutant" CssClass="collapseIcon" runat="server" ImageUrl="~/images/expand_blue.jpg" OnClick="expandPollutantClick" />
                    <eprtr:Info ID="infoPollutant" CssClass="infoIcon" Type="Pollutant" runat="server" />
                </div>
                
                <%--expand label--%>
                <asp:Label ID="lblPollutant2" Text="<%$Resources:Common,CurrentlyNotIncluded%>" runat="server" CssClass="cpeTextLabel2"></asp:Label>
                <asp:Label ID="lblPollutant" Text="<%$Resources:Common,Expand%>" runat="server" CssClass="cpeTextLabel"></asp:Label>

                
                <%--content--%>
                <asp:Panel ID="plPollutantContent" runat="server" CssClass="cpeContent">
                    <eprtr:PollutantSearchOption ID="ucPollutantSearchOption" IncludeAll="true"  runat="server" />
                    <eprtr:MediumSearchOption ID="ucMediumSearchOption" IncludeTransfers="true" runat="server" />
                </asp:Panel>
          </asp:Panel>

</ContentTemplate>

</asp:UpdatePanel>
