<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucPollutantReleasesFacilities.ascx.cs" Inherits="ucPollutantReleasesFacilities" %>
<%@ Register Src="~/UserControls/SearchFacility/ucFacilitySheet.ascx" TagName="ucFacilitySheet" TagPrefix="uc1" %>
<%@ Register Src="~/UserControls/Common/ucMediumSelector.ascx" TagName="ucMediumSelector" TagPrefix="eprtr" %>



<%-- Releases to radio buttons --%>
<eprtr:ucMediumSelector ID="ucMediumSelector"  OnItemSelected="OnSelectedMediumChanged" runat="server" />

<div class="clearBoth1">
    <asp:ListView ID="lvFacilityResult" runat="server" OnSorting="OnSorting" OnItemCommand="OnItemCommand"
        OnPagePropertiesChanging="OnPageChanging">
        <LayoutTemplate>
            <table>
                <thead>
                    <tr class="generalListStyle_headerRow">
                        <th scope="col">
                            <div id="headerFacilityPR">
                                <asp:LinkButton ID="lnkFacility" Text="<%$ Resources:Facility,FacilityName %>" CommandName="Sort"
                                    CommandArgument="FacilityName" runat="server"></asp:LinkButton>
                                <asp:Image ID="upFacility" runat="server" ImageUrl="~/images/arrow_up.gif" Visible="true" />
                                <asp:Image ID="downFacility" runat="server" ImageUrl="~/images/arrow_down.gif" Visible="false" />
                            </div>
                        </th>
                        <th scope="col">
                            <div id="headerQuantityTotal">
                                <asp:LinkButton ID="lnkQuantity" Text="<%$ Resources:Common,Quantity %>" CommandName="Sort"
                                    CommandArgument="QuantityTotal" runat="server"></asp:LinkButton>
                                <asp:Image ID="upQuantity" runat="server" ImageUrl="~/images/arrow_up.gif" Visible="false" />
                                <asp:Image ID="downQuantity" runat="server" ImageUrl="~/images/arrow_down.gif" Visible="false" />
                            </div>
                        </th>
                        <th scope="col">
                            <div id="headerAccidental">
                                <asp:LinkButton ID="lnkAccidental" Text="<%$ Resources:Pollutant,AccidentalQuantity %>"
                                    CommandName="Sort" CommandArgument="QuantityAccidental" runat="server"></asp:LinkButton>
                                <asp:Image ID="upAccidental" runat="server" ImageUrl="~/images/arrow_up.gif" Visible="false" />
                                <asp:Image ID="downAccidental" runat="server" ImageUrl="~/images/arrow_down.gif"
                                    Visible="false" />
                            </div>
                        </th>
                        <th scope="col">
                            <div id="headerAccidentalPercent">
                                <asp:LinkButton ID="lnkAccidentalPercentage" Text="<%$ Resources:Pollutant,AccidentalPercentage %>"
                                    CommandName="Sort" CommandArgument="PercentAccidental" runat="server"></asp:LinkButton>
                                <asp:Image ID="upPercentageAccidental" runat="server" ImageUrl="~/images/arrow_up.gif"
                                    Visible="false" />
                                <asp:Image ID="downPercentageAccidental" runat="server" ImageUrl="~/images/arrow_down.gif"
                                    Visible="false" />
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
                <td title="<%# GetFacilityName(Container.DataItem)%>">
                    <div id="FacilityPR">
                      <asp:LinkButton ID="lnkFacilityClick" Text='<%# GetFacilityName(Container.DataItem)%>' CommandName='<%# GetFacilityReportId(Container.DataItem) %>' CommandArgument="togglesheet" OnClientClick="ShowWaitIndicator();" runat="server"></asp:LinkButton>
                      </div>
                </td>
                <td title=""><div id="QuantityTotal"><%# GetQuantityTotal(Container.DataItem)%></div></td>
                <td title=""><div id="Accidental"><%# GetQuantityAccidental(Container.DataItem)%></div></td>
                <td title=""><div id="AccidentalPercent"><%# GetPercentage(Container.DataItem)%></div></td>
                <td><div id="ActivityCode"><asp:Label ID="Label1" Text='<%# GetActivity(Container.DataItem) %>' ToolTip='<%# GetActivityToolTip(Container.DataItem)%>' runat="server"></asp:Label></div></td>
                <td><div id="CountryCode"><asp:Label ID="Label2" Text='<%# GetCountry(Container.DataItem) %>' ToolTip='<%# GetCountryToolTip(Container.DataItem)%>' runat="server"></asp:Label></div>
                </td>
            </tr>
            <tr>
                <td colspan="6">
                    <div id="subsheet" class="layout_sheetIntable"  visible="false" runat="server">
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
