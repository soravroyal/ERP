
<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucAreaOverviewPollutantTransfers.ascx.cs" Inherits="ucAreaOverviewPollutantTransfers" %>
<%@ Register src="~/UserControls/Common/ucTreeTableLabel.ascx" tagname="TreeLabel" tagprefix="eprtr" %>


<div id="divPollutantGroup"  class="aoPollutantGroup" runat="server">
    <asp:Label ID="litPollutantGroup"  runat="server" Text="<%$ Resources:Common,PollutantGroup %>"></asp:Label>:
    <asp:DropDownList ID="cbPollutantGroup" runat="server" OnSelectedIndexChanged="OnPollutantGroupChanged" AutoPostBack="true"></asp:DropDownList>
</div>

<div class="clearBoth">
    <asp:ListView ID="lvPollutantTransfers" runat="server" OnItemCreated="rows_OnItemCreated" OnItemCommand="rows_OnItemCommand" OnItemDataBound="rows_OnItemDataBound" OnPreRender="lv_OnPreRender">

        <LayoutTemplate>
            <div class="pagingTextPollutant">            
                <asp:Label runat="server" ID="lbPagingtext" />
            </div>
                        
            <div class = "pagingPollutant">                      
                <asp:DataPager ID="pgColHeaders"  PagedControlID="lvColHeaders" PageSize="4"  OnPreRender="pgHeader_PreRender" runat="server">
                    <Fields>
                        <asp:NextPreviousPagerField PreviousPageText="<%$ Resources:AreaOverview,PagingPrevious %>" ShowNextPageButton="False"  Visible="true"/> 
                        <asp:NumericPagerField ButtonCount="100" ButtonType="Link"  Visible="true"/>
                        <asp:NextPreviousPagerField NextPageText="<%$ Resources:AreaOverview,PagingNext %>" ShowPreviousPageButton="False" Visible="true"/> 
                    </Fields>
                </asp:DataPager>
            </div> 

            <div class="clearBoth">
                <table width="100%">
                    <thead>
                        <tr class="generalListStyle_headerRow">
                            <asp:ListView ID="lvColHeaders"  runat="server"  OnPagePropertiesChanging="OnPageChanging" OnDataBinding="lvColHeaders_OnDataBinding" >
                                <LayoutTemplate>
                                    <th><div class="AOcolNameExpanding"><asp:Label ID="lbActivity" runat="server"></asp:Label></div></th>
                                    <th><div class="AOcolLegend"><asp:Label ID="lnTotalAccidental" Text="" runat="server"></asp:Label></div></th>
                                    <asp:PlaceHolder id="itemPlaceholder" runat="server" ></asp:PlaceHolder>
                                </LayoutTemplate>
                                <ItemTemplate>
                                    <th title="<%# GetColNameToolTip(Container.DataItem)%>" ><div id="divHeaderPol" class="AOcolPollutant" runat="server"><asp:Label ID="lbPol" Text="<%# GetColName(Container.DataItem)%>"  runat="server"></asp:Label></div></th>
                                </ItemTemplate>
                            </asp:ListView>
                        </tr>
                    </thead>

                    <tbody>
                        <asp:PlaceHolder id="itemPlaceholder" runat="server" ></asp:PlaceHolder>
                    </tbody>

                </table>
            </div>
        </LayoutTemplate>


        <ItemTemplate>

            <asp:DataPager ID="pgColData"  PagedControlID="lvColData" PageSize="4"  OnDataBinding="pgColData_OnLoad"  runat="server" />

            <tr id="row" class='<%#GetRowCss(Container.DataItem)%>'>

                <%-- Tree --%>                   
                <td  title='<%# GetName(Container.DataItem)%>' >
                    <eprtr:TreeLabel ID="ucTreeLabel" 
                    Expanded='<%#IsExpanded(Container.DataItem)%>' 
                    Text='<%# GetName(Container.DataItem)%>' 
                    HasChildren='<%# HasChildren(Container.DataItem)%>' 
                    Level='<%# GetLevel(Container.DataItem) %>'   
                    CommandName='<%# GetCode(Container.DataItem)%>' CommandArgument='expand' 
                    CssClass="AOcolNameExpanding" 
                    runat="server" />
                </td>
                
          <td>
            <div class="AOcolLegend">
                <asp:Literal ID="qtotal" runat="server" Text="<%$ Resources:AreaOverview,Quantity %>" /><br />
                <asp:Literal ID="atotal" runat="server" Text="<%$ Resources:AreaOverview,Facilities %>" />
            </div>
          </td>
                

                <asp:ListView id="lvColData" DataSource="<%# GetPollutantList(Container.DataItem)%>" runat="server">
                    <LayoutTemplate>
                        <asp:PlaceHolder id="itemPlaceholder" runat="server" ></asp:PlaceHolder>
                    </LayoutTemplate>
                    <ItemTemplate>
                        <td >
                            <div class="AOcolPollutant"  runat="server">
                            <%# GetTotal(Container.DataItem)%><br />
                            <%# GetFacilities(Container.DataItem)%>
                            </div>
                        </td>
                    </ItemTemplate>
                </asp:ListView>
            </tr>

        </ItemTemplate>

        <EmptyDataTemplate>
            <div class="noResult">
                <asp:Literal ID="litNoResult" Text="<%$ Resources:AreaOverview,NoPollutantTransfersFound %>" runat="server"></asp:Literal>
            </div>
        </EmptyDataTemplate>

    </asp:ListView>
  
  </div>
  
  
