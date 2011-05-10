<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucWasteTransferHazRecieverTreatment.ascx.cs"
    Inherits="ucWasteTransferHazRecieverTreatment" %>

<div>
    <asp:ListView ID="_lvTreaterResult" runat="server" OnItemCommand="OnItemCommand"
        OnSorting="OnSorting" OnPagePropertiesChanging="OnPageChanging">
        <LayoutTemplate>
            <table>
                <thead>
                    <tr class="generalListStyle_headerRow">
                        <th>
                            <div id="headerFromFacilityName">
                                <asp:LinkButton ID="_lnkFromFacility" Text="<%$ Resources:Facility,TransferedFrom %>"
                                    CommandName="Sort" CommandArgument="FacilityName" runat="server"></asp:LinkButton>
                                <asp:Image ID="upFacility" runat="server" ImageUrl="~/images/arrow_up.gif" Visible="false" />
                                <asp:Image ID="downFacility" runat="server" ImageUrl="~/images/arrow_down.gif" Visible="false" />
                            </div>
                        </th>
                        <th><div class="ColLink"></div></th>
                        <th>
                            <div id="headerTreatment">
                                <asp:LinkButton ID="_lnkTreatment" Text="<%$ Resources:Common,Treatment%>" CommandName="Sort"
                                    CommandArgument="WasteTreatmentCode" runat="server"></asp:LinkButton>
                                <asp:Image ID="upTreatment" runat="server" ImageUrl="~/images/arrow_up.gif" Visible="false" />
                                <asp:Image ID="downTreatment" runat="server" ImageUrl="~/images/arrow_down.gif"
                                    Visible="false" />
                            </div>
                        </th>
                        <th>
                            <div id="headerTreaterName">
                                <asp:LinkButton ID="_lnkTreaterName" Text="<%$ Resources:Facility,TreaterName %>"
                                    CommandName="Sort" CommandArgument="WHPName" runat="server"></asp:LinkButton>
                                <asp:Image ID="upTreaterName" runat="server" ImageUrl="~/images/arrow_up.gif" Visible="false" />
                                <asp:Image ID="downTreaterName" runat="server" ImageUrl="~/images/arrow_down.gif"
                                    Visible="false" />
                            </div>
                        </th>
                        <th>
                            <div id="headerTeaterAddress">
                                <asp:Literal ID="_lnkTreaterAddress" Text="<%$ Resources:Common,Address %>" runat="server"></asp:Literal>
                            </div>
                        </th>
                        <th>
                            <div id="headerSiteAddress">
                                <asp:Literal ID="_lnkSiteAddress" Text="<%$ Resources:Facility,SiteAddress%>"
                                    runat="server"></asp:Literal>
                            </div>
                        </th>
                        <th>
                            <div id="headerQuantity">
                                <asp:LinkButton ID="_lnkQuantity" Text="<%$ Resources:Common,Quantity %>" CommandName="Sort"
                                    CommandArgument="Quantity" runat="server"></asp:LinkButton>
                                <asp:Image ID="upQuantity" runat="server" ImageUrl="~/images/arrow_up.gif" Visible="false" />
                                <asp:Image ID="downQuantity" runat="server" ImageUrl="~/images/arrow_down.gif" Visible="false" />
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
                <td title="<%# GetFromFacilityName(Container.DataItem) %>">
                    <div id="Facility"><%# GetFromFacilityName(Container.DataItem)%></div>
                </td>
                
                <td title='<%# GetToolTipFacilitySearch()%>' >
                  <div class="ColLink">
                    <asp:ImageButton ID="newSearchActivity" Visible="<%# ShowFacilityLink(Container.DataItem) %>" ImageUrl="~/images/newsearch.gif" OnCommand="onFacilitySearchClick" CommandName='' CommandArgument='<%# GetFacilityCommand(Container.DataItem)%>' runat="server" /> 
                    <asp:Image ID="newSearchPlaceholder" Visible="<%# !ShowFacilityLink(Container.DataItem) %>" ImageUrl="~/images/newsearch-placeholder.png" runat="server" /> 
                  </div>
                </td>
                <td title="">
                    <div id="Treatment"> <%# GetTreatment(Container.DataItem)%> </div>
                </td>
                <td title="<%# GetTreaterName(Container.DataItem) %>">
                    <div id="TreaterName"> <%# GetTreaterName(Container.DataItem)%> </div>
                </td>
                <td title="<%# GetTreaterAddress(Container.DataItem) %>">
                    <div id="TeaterAddress"> <%# GetTreaterAddress(Container.DataItem)%> </div>
                </td>
                <td title="<%# GetTreaterSiteAddress(Container.DataItem) %>">
                    <div id="TreaterAddressSite"> <%# GetTreaterSiteAddress(Container.DataItem)%> </div>
                </td>
                <td>
                    <div id="Quantity"><%# GetQuantity(Container.DataItem)%></div>
                </td>
            </tr>
        </ItemTemplate>
    </asp:ListView>
</div>
<div id="resultSizeDefine">
    <asp:DataPager ID="datapager" PagedControlID="_lvTreaterResult" runat="server">
        <Fields>
            <asp:NumericPagerField />
        </Fields>
    </asp:DataPager>
</div>
