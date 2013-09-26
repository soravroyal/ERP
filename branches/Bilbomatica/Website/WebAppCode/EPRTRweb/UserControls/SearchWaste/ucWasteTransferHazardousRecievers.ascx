<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucWasteTransferHazardousRecievers.ascx.cs"
    Inherits="ucWasteTransferHazardousRecievers" %>

<%@ Register Src="~/UserControls/SearchWaste/ucWasteTransferHazRecieverSheet.ascx" TagName="ucWasteTransferHazRecieverSheet"
    TagPrefix="eprtr" %>
<div>
    <asp:ListView ID="_lvCountryResult" runat="server" OnSorting="OnSorting" OnItemCommand="OnItemCommand" OnDataBinding="OnDataBinding">
        <LayoutTemplate>
            <table>
                <thead>
                    <%--Text="<%$ Resources:Facility,FacilityName %>"--%>
                    <tr class="generalListStyle_headerRow">
                        <th scope="col">
                            <div id="headerWasteReceivingCountry">
                                <asp:Label ID="_lnkReceivingCountry" Text="<%$ Resources:Common,Country %>" runat="server"></asp:Label>
                            </div>
                        </th>
                        <th scope="col">
                            <div id="headerWasteNFac">
                                <asp:Label ID="_lnkNumOfFacilities" Text="<%$ Resources:Common,Facilities %>" runat="server"></asp:Label>
                            </div>
                        </th>
                        <th scope="col" id="divHeaderWasteQT" runat="server">
                            <div class="headerWasteQT"">
                                <asp:Label ID="_lnkQuantityTotal" Text="<%$ Resources:Common,Total %>" runat="server"></asp:Label>
                            </div>
                        </th>
                        <th scope="col" id="divHeaderWasteQR" runat="server">
                            <div class="headerWasteQR">
                                <asp:Label ID="_lnkQuantityRecovery" Text="<%$ Resources:Common,TreatmentRecovery %>" runat="server"></asp:Label>
                            </div>
                        </th>
                        <th scope="col" id="divHeaderWasteQD" runat="server">
                            <div class="headerWasteQD" >
                                <asp:Label ID="_lnkQuantityDisposal" Text="<%$ Resources:Common,TreatmentDisposal %>" runat="server"></asp:Label>
                            </div>
                        </th>
                        <th scope="col" id="divHeaderWasteU" runat="server">
                            <div class="headerWasteU">
                                <asp:Label ID="_lnkQuantityUnspecified" Text="<%$ Resources:Common,TreatmentUnspecified %>" runat="server"></asp:Label>
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
                <td>
                    <div id="WasteReceivingCountry">
                        <asp:LinkButton ID="lnkCountryClick" Enabled='<%# ShowAsLink(Container.DataItem) %>' CssClass="DontShowAsLink" Text='<%# GetCountryName(Container.DataItem)%>'
                            CommandName='<%# GetCountryCode(Container.DataItem) %>' CommandArgument="togglesheet" runat="server" OnClientClick="ShowWaitIndicator();"></asp:LinkButton>
                    </div>
                </td>
                <td>
                    <div id="WasteNFac">
                        <%# GetFacilities(Container.DataItem)%>
                        <asp:ImageButton ID="newSearchImageButton" Visible='<%# ShowFacilityLink(Container.DataItem) %>' ImageUrl="~/images/newsearch.gif" OnCommand="onNewSearchClick"
                            CommandName='newsearch' CommandArgument='<%# GetCountryCommandArg(Container.DataItem)%>'
                            runat="server" />
                        <asp:Image ID="Image1" Visible='<%# !ShowFacilityLink(Container.DataItem) %>' ImageUrl="~/images/newsearch-placeholder.png" runat="server" />
                            
                    </div>
                </td>
                <td runat="server" visible="<%# ShowTreatmentTotal %>"><div id="WasteQT" ><%# GetQuantityTotal(Container.DataItem)%></div></td>
                <td runat="server" visible="<%# ShowRecovery %>"><div id="WasteQR" ><%# GetQuantityRecovery(Container.DataItem)%></div></td>
                <td runat="server" visible="<%# ShowDisposal %>"><div id="WasteQD" ><%# GetQuantityDisposal(Container.DataItem)%></div></td>
                <td runat="server" visible="<%# ShowUnspecified %>"><div id="WasteU" ><%# GetQuantityUnspecified(Container.DataItem)%></div></td>
            </tr>
            <tr>
                <td colspan="6" >
                    <div id="_subsheet" class="layout_sheetIntable" visible="false" runat="server">
                        <eprtr:ucWasteTransferHazRecieverSheet ID="_ucWasteTransferHazRecieverSheet" runat="server"
                            Visible="false" />
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
<div>
