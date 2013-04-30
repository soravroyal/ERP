<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucWasteTransferSummary.ascx.cs" Inherits="ucWasteTransferSummary" %>

<%@ Register src="~/UserControls/TimeSeries/ucTsWasteTransfersSheet.ascx" tagname="ucTsWasteTransfersSheet" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/Common/ucTreeTableLabel.ascx" tagname="TreeLabel" tagprefix="eprtr" %>
<%@ Register TagPrefix="nfp" TagName="NoFlashPlayer" Src="~/UserControls/Common/ucNoFlashPlayer.ascx" %>

<%-- piechart --%>
<asp:Panel ID="upWasteTransferPiePanel" runat="server">
    <div id="DisplayPieChart" runat="server">
        <div id="piechart" visible="true"></div>
    </div>
</asp:Panel>


<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
    
        <div>
            <asp:ListView ID="lvWasteTransferSummery" runat="server" OnItemCommand="OnItemCommand"
                OnDataBinding="OnDataBinding">
                <LayoutTemplate>
                    <table>
                       <thead>
                        <tr class="generalListStyle_headerRow">
                          <th><div class="WTcolWasteType"><asp:Label ID="lbWasteTransfers" Text="<%$ Resources:Common,WasteTransfers %>" runat="server"></asp:Label></div></th>
                          <th><div class="WTcolFacilities"><asp:Label ID="lbFacilities" Text="<%$ Resources:Pollutant,Facilities %>" runat="server"></asp:Label></div></th>
                          <th id="divHeaderRecovery" runat="server"><div class="WTcolQ" runat="server"><asp:Label ID="lnRecovery" Text="<%$ Resources:Common,Recovery %>" runat="server"></asp:Label></div></th>
                          <th id="divHeaderDisposal" runat="server"><div class="WTcolQ" runat="server"><asp:Label ID="lbDisposal" Text="<%$ Resources:Common,Disposal %>" runat="server"></asp:Label></div></th>
                          <th id="divHeaderUnspecified" runat="server"><div class="WTcolQ" runat="server"><asp:Label ID="lbUnspecified" Text="<%$ Resources:Common,Unspecified %>" runat="server"></asp:Label></div></th>
                          <th id="divHeaderTotal" runat="server"><div class="WTcolQ"><asp:Label ID="lbTotal" Text="<%$ Resources:Common,TotalQuantity %>" runat="server"></asp:Label></div></th>
                        </tr>
                       </thead>
                       <tbody>
                        <asp:PlaceHolder id="itemPlaceholder" runat="server" ></asp:PlaceHolder>
                       </tbody>
                     </table>
                    
                    </LayoutTemplate>
                    
                    <ItemTemplate>
                    
                    <tr id="row" class='<%#GetRowCss(Container.DataItem)%>'>

                      <%-- Waste transfers --%>
                     <td  title='<%# GetName(Container.DataItem)%>' >
                        <div class="WTcolWasteType">
                        
                            <%-- TimeSeries link --%>
                            <asp:ImageButton ID="ImageButton1" 
                                ImageUrl="~/images/timeseries.png" 
                                CommandName='timeseries' 
                                CommandArgument='<%# GetCode(Container.DataItem) %>' 
                                ToolTip="<%# GetToolTipTimeSeries()%>"
                                runat="server" 
                                CssClass="TSLink"/> 
                        
                            <eprtr:TreeLabel ID="ucTreeLabel" 
                                Expanded='<%#IsExpanded(Container.DataItem)%>' 
                                Text='<%# GetName(Container.DataItem)%>' 
                                HasChildren='false' 
                                Level='<%# GetLevel(Container.DataItem) %>'   
                                CommandName='<%# GetCode(Container.DataItem)%>' CommandArgument='<%# GetLevel(Container.DataItem)%>' 
                                runat="server" />
                        </div>
                      </td>
                      
                      
                      <%-- Number of facilities --%>
                      
                      <td title="">
                        <div class="WTcolFacilities"><%# GetFacilities(Container.DataItem)%>
                        <asp:ImageButton ID="newSearchImageButtone" ImageUrl="~/images/newsearch.gif" OnCommand="onNewSearchClick" CommandName='newsearch' CommandArgument='<%# GetCode(Container.DataItem)%>' runat="server" /> 
                        </div>
                      </td>
                      
                      <%-- Quantities --%>
                      
                        <td visible="<%# ShowRecovery %>" runat="server" title='<%# GetRecovery(Container.DataItem)%>'>
                            <div class="WTcolQ">
                                <%# GetRecovery(Container.DataItem)%><br />
                                <div runat="server" visible="<%# ShowTotal %>">
                                    <%# GetRecoveryPercent(Container.DataItem)%>
                                </div>
                            </div>
                        </td>
                        <td visible="<%# ShowDisposal %>" runat="server" title='<%# GetDisposal(Container.DataItem)%>'>
                            <div class="WTcolQ">
                                <%# GetDisposal(Container.DataItem)%><br />
                                <div id="Div1" runat="server" visible="<%# ShowTotal %>">
                                    <%# GetDisposalPercent(Container.DataItem)%></div>
                            </div>
                        </td>
                        <td visible="<%# ShowUnspecified %>" runat="server" title='<%# GetUnspec(Container.DataItem)%>'>
                            <div class="WTcolQ">
                                <%# GetUnspec(Container.DataItem)%><br />
                                <div id="Div2" runat="server" visible="<%# ShowTotal %>">
                                    <%# GetUnspecPercent(Container.DataItem)%>
                                </div>
                            </div>
                        </td>
                        <td visible="<%# ShowTotal %>" runat="server" title='<%# GetTotal(Container.DataItem)%>'>
                            <div class="WTcolQ">
                                <%# GetTotal(Container.DataItem)%></div>
                        </td>
                    </tr>
                    
                    <tr>
                      <td colspan="100" >  <%--spann "all"--%>
                        <div id="subsheet" class="layout_sheetIntable" visible="false" runat="server">
                            <eprtr:ucTsWasteTransfersSheet ID="ucTsWasteTransfersSheet" SheetLevel="1" runat="server" Visible="false" />
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
        
    </ContentTemplate>
</asp:UpdatePanel>
