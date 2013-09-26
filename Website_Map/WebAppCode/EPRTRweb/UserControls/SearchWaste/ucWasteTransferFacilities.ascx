<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucWasteTransferFacilities.ascx.cs"
    Inherits="ucWasteTransferFacilities" %>
<%@ Register Src="~/UserControls/SearchFacility/ucFacilitySheet.ascx" TagName="ucFacilitySheet"
    TagPrefix="uc1" %>
<%@ Register Src="~/UserControls/Common/ucWasteTypeSelector.ascx" TagName="ucWasteTypeSelector" TagPrefix="eprtr" %>

<%-- Transfer to radio buttons --%>
<eprtr:ucWasteTypeSelector ID="ucWasteTypeSelector"  OnItemSelected="OnSelectedWasteTypeChanged" runat="server" />


<div>
    <asp:ListView ID="lvFacilityResult" runat="server" OnSorting="OnSorting" OnItemCommand="OnItemCommand"
        OnPagePropertiesChanging="OnPageChanging" >
        <LayoutTemplate>
            <table class="TableExtend" >
                <thead>
                    <tr class="generalListStyle_headerRow">
                        <th scope="col">
                            <div>
                                <asp:LinkButton ID="lnkFacility" Text="<%$ Resources:Facility,FacilityName %>" CommandName="Sort"
                                    CommandArgument="FacilityName" runat="server"></asp:LinkButton>
                                <asp:Image ID="upFacility" runat="server" ImageUrl="~/images/arrow_up.gif" Visible="true" />
                                <asp:Image ID="downFacility" runat="server" ImageUrl="~/images/arrow_down.gif" Visible="false" />
                            </div>
                        </th scope="col">
                        <th id="headerQuantityTotal" runat="server">
                            <div class="columnQuantityTotal">
                                <asp:LinkButton ID="_lnkQuantityTotal" Text="<%$ Resources:WasteTransfers,WasteColumnHeaderTotal %>"
                                    CommandName="Sort" CommandArgument="QuantityTotal" runat="server"></asp:LinkButton>
                                <asp:Image ID="upTotal" runat="server" ImageUrl="~/images/arrow_up.gif" Visible="false" />
                                <asp:Image ID="downTotal" runat="server" ImageUrl="~/images/arrow_down.gif" Visible="false" />
                            </div>
                        </th>
                        <th scope="col" id="headerQuantityRecovery" runat="server">
                            <div class="columnQuantityRecovery">
                                <asp:LinkButton ID="_lnkQuantityRecovery" Text="<%$ Resources:WasteTransfers,WasteColumnHeaderRecovery %>"
                                    CommandName="Sort" CommandArgument="QuantityRecovery" runat="server"></asp:LinkButton>
                                <asp:Image ID="upRecovery" runat="server" ImageUrl="~/images/arrow_up.gif" Visible="false" />
                                <asp:Image ID="downRecovery" runat="server" ImageUrl="~/images/arrow_down.gif" Visible="false" />
                            </div>
                        </th>
                        <th scope="col" id="headerQuantityDisposal" runat="server">
                            <div class="columnQuantityDisposal">
                                <asp:LinkButton ID="_lnkQuantityDisposal" Text="<%$ Resources:WasteTransfers,WasteColumnHeaderDisposal %>"
                                    CommandName="Sort" CommandArgument="QuantityDisposal" runat="server"></asp:LinkButton>
                                <asp:Image ID="upDisposal" runat="server" ImageUrl="~/images/arrow_up.gif" Visible="false" />
                                <asp:Image ID="downDisposal" runat="server" ImageUrl="~/images/arrow_down.gif" Visible="false" />
                                </div>
                        </th>
                        <th scope="col" id="headerQuantityUnspecified" runat="server">
                            <div class="columnQuantityUnspecified">
                                <asp:LinkButton ID="_lnkQuantityUnspecified" Text="<%$ Resources:WasteTransfers,WasteColumnHeaderUnspecified %>"
                                    CommandName="Sort" CommandArgument="QuantityUnspec" runat="server"></asp:LinkButton>
                                <asp:Image ID="upUnspecified" runat="server" ImageUrl="~/images/arrow_up.gif" Visible="false" />
                                <asp:Image ID="downUnspecified" runat="server" ImageUrl="~/images/arrow_down.gif"
                                    Visible="false" />
                            </div>
                        </th>
                        <th scope="col">
                            <div class="columnActivityCode">
                                <asp:LinkButton ID="lnkActivity" Text="<%$ Resources:Facility,Activity %>" CommandName="Sort"
                                    CommandArgument="IAActivityCode" runat="server"></asp:LinkButton>
                                <asp:Image ID="upActivity" runat="server" ImageUrl="~/images/arrow_up.gif" Visible="false" />
                                <asp:Image ID="downActivity" runat="server" ImageUrl="~/images/arrow_down.gif" Visible="false" />
                            </div>                                
                        </th>
                        <th scope="col">
                            <div class="columnCountryCode">
                                <asp:LinkButton ID="lnkCountry" Text="<%$ Resources:Common,Country%>" CommandName="Sort"
                                    CommandArgument="CountryCode" runat="server"></asp:LinkButton>
                                <asp:Image ID="upCountry" runat="server" ImageUrl="~/images/arrow_up.gif" Visible="false" />
                                <asp:Image ID="downCountry" runat="server" ImageUrl="~/images/arrow_down.gif" Visible="false" />
                            </div>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <asp:PlaceHolder ID="itemPlaceholder" runat="server"></asp:PlaceHolder>
                </tbody>
            </table>
        </LayoutTemplate>
        <ItemTemplate>
            <tr class="generalListStyle_row">
                <td title="<%# GetFacilityName(Container.DataItem) %>">
                    <div class="columnFacilityName">
                        <asp:LinkButton ID="lnkFacilityClick" ToolTip='<%# GetFacilityName(Container.DataItem) %>'
                            Text='<%# GetFacilityName(Container.DataItem) %>' CommandName='<%# GetFacilityReportId(Container.DataItem) %>'
                            CommandArgument="togglesheet" OnClientClick="ShowWaitIndicator();" runat="server" />
                    </div>
                </td>
                <td runat="server" visible="<%# ShowTreatmentTotal %>" title="<%# GetTotal(Container.DataItem)%>">
                    <div class="columnQuantityTotal" id="QuantityTotal2">
                        <%# GetTotal(Container.DataItem)%></div>
                </td>
                <td runat="server" visible="<%# ShowRecovery %>" title="<%# GetRecovery(Container.DataItem)%>">
                    <div class="columnQuantityRecovery" id="QuantityRecovery2">
                        <%# GetRecovery(Container.DataItem)%>
                </td>
                <td runat="server" visible="<%# ShowDisposal %>" title="<%# GetDisposal(Container.DataItem)%>">
                    <div class="columnQuantityDisposal" id="QuantityDisposal2">
                        <%# GetDisposal(Container.DataItem)%>
                </td>
                <td runat="server" visible="<%# ShowUnspecified %>" title="<%# GetUnspec(Container.DataItem)%>">
                    <div class="columnQuantityUnspecified" id="QuantityUnspecified2">
                        <%# GetUnspec(Container.DataItem)%>
                </td>
                <td><div class="columnActivityCode"><asp:Label Text='<%# GetActivity(Container.DataItem) %>' ToolTip='<%# GetActivityToolTip(Container.DataItem)%>' runat="server"></asp:Label></td>
                <td><div class="columnCountryCode"><asp:Label Text='<%# GetCountry(Container.DataItem)%>' ToolTip='<%# GetCountryToolTip(Container.DataItem)%>' runat="server"></asp:Label></td>
            </tr>
            <tr>
                <td colspan="7" >
                    <div id="subsheet" class="layout_sheetIntable" visible="false" runat="server">
                        <uc1:ucFacilitySheet ID="ucFacilitySheet" runat="server" Visible="false" />
                    </div>
                </td>
            </tr>
        </ItemTemplate>
        <EmptyDataTemplate>
            <div class="noResult">
                <asp:Literal ID="litNoResult" Text="<%$ Resources:Common,NoResultsFound %>" runat="server"></asp:Literal>
            </div>
        </EmptyDataTemplate>
    </asp:ListView>
</div>
<div id="resultSizeDefine">
    <asp:DataPager ID="datapager" PagedControlID="lvFacilityResult" runat="server">
        <Fields>
            <asp:NumericPagerField />
        </Fields>
    </asp:DataPager>
</div>
