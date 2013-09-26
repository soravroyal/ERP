<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucPollutantTransfersFacilities.ascx.cs"
    Inherits="ucPollutantTransfersFacilities" %>

<%@ Register Src="~/UserControls/SearchFacility/ucFacilitySheet.ascx" TagName="ucFacilitySheet"
    TagPrefix="uc1" %>
<div>
    <asp:ListView ID="lvFacilityResult" runat="server" OnSorting="OnSorting" OnItemCommand="OnItemCommand"
        OnPagePropertiesChanging="OnPageChanging">
        <LayoutTemplate>
            <table>
                <thead>
                    <tr class="generalListStyle_headerRow">
                        <th scope="col">
                            <div id="headerFacilityPT">
                                <asp:LinkButton ID="lnkFacility" Text="<%$ Resources:Facility,FacilityName %>" CommandName="Sort"
                                    CommandArgument="FacilityName" runat="server"></asp:LinkButton>
                                <asp:Image ID="upFacility" runat="server" ImageUrl="~/images/arrow_up.gif" Visible="true" />
                                <asp:Image ID="downFacility" runat="server" ImageUrl="~/images/arrow_down.gif" Visible="false" />
                            </div>
                        </th>
                        <th scope="col">
                            <div id="headerQuantityTotal">
                                <asp:LinkButton ID="lnkQuantity" Text="<%$ Resources:Common,Quantity %>" CommandName="Sort"
                                    CommandArgument="Quantity" runat="server"></asp:LinkButton>
                                <asp:Image ID="upQuantity" runat="server" ImageUrl="~/images/arrow_up.gif" Visible="false" />
                                <asp:Image ID="downQuantity" runat="server" ImageUrl="~/images/arrow_down.gif" Visible="false" />
                            </div>
                        </th>
                        <th scope="col">
                            <div id="headerActivityCode">
                                <asp:LinkButton ID="lnkActivity" Text="<%$ Resources:Facility,Activity %>" CommandName="Sort"
                                    CommandArgument="IAActivityCode" runat="server"></asp:LinkButton>
                                <asp:Image ID="upActivity" runat="server" ImageUrl="~/images/arrow_up.gif" Visible="false" />
                                <asp:Image ID="downActivity" runat="server" ImageUrl="~/images/arrow_down.gif" Visible="false" />
                            </div>
                        </th>
                        <th scope="col">
                            <div id="headerCountryCode">
                                <asp:LinkButton ID="lnkCountry" Text="<%$ Resources:Facility,Country %>" CommandName="Sort"
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

                <td title="<%# GetFacilityName(Container.DataItem)%>">
                    <div id="FacilityPT">
                        <asp:LinkButton ID="lnkFacilityClick" Text='<%# GetFacilityName(Container.DataItem) %>'
                            CommandName='<%# GetFacilityReportId(Container.DataItem) %>' CommandArgument="togglesheet" OnClientClick="ShowWaitIndicator();" runat="server"></asp:LinkButton>
                    </div>
                </td>
                <td title=""><div id="QuantityTotal"><%# GetQuantity(Container.DataItem)%></div></td>
                <td><div id="ActivityCode"><asp:Label Text='<%# GetActivityCode(Container.DataItem) %>' ToolTip='<%# GetActivityName(Container.DataItem)%>' runat="server"></asp:Label></div></td>
                <td><div id="CountryCode"><asp:Label Text='<%# GetCountryCode(Container.DataItem)%>' ToolTip='<%# GetCountryName(Container.DataItem)%>' runat="server"></asp:Label></div>
                </td>
            </tr>
            <tr>
                <td colspan="6">
                    <div id="subsheet" class="layout_sheetIntable" visible="false" runat="server">
                        <uc1:ucFacilitySheet ID="ucFacilitySheet" runat="server" Visible="false" />
                    </div>
                </td>
            </tr>
        </ItemTemplate>
    </asp:ListView>
</div>
<div id="resultSizeDefine">
    <asp:DataPager ID="datapager" PagedControlID="lvFacilityResult" runat="server">
        <Fields>
            <asp:NumericPagerField />
        </Fields>
    </asp:DataPager>
</div>
