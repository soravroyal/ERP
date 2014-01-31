<%@ Control Language="C#" CodeFile="ucFacilityEmissionsEPER.ascx.cs" Inherits="ucFacilityEmissionsEPER" %>

<%@ Register Src="~/UserControls/SearchFacilityEPER/TimeSeries/ucFacilityPollutantReleasesTrendSheetEPER.ascx" TagName="ucFacilityPollutantReleasesTrendSheetEPER" TagPrefix="eprtr" %>

<asp:Panel ID="facilityPollutantReleases" runat="server" Width="100%" Height="100%">
    
    <div>
    <h3><asp:Label ID="Label2" Text="<%$ Resources:Pollutant,EmissionsToAir %>" runat="server"></asp:Label></h3>
        <asp:ListView ID="lvFacilityPollutantReleasesAIR" runat="server" OnItemCommand="OnItemCommandAIR">
            <LayoutTemplate>
                <table cellpadding="1px;" width="100%">
                    <thead>
                        <tr class="generalListStyle_headerRow">
                          <th></th>
                          <th scope="col" width="55%"><div id="headerSpecialPollutantName"><asp:Label ID="lbReleasesTo" Text="<%$ Resources:Pollutant,PollutantName %>" runat="server"></asp:Label></div></th>
                          <th scope="col"><div id="headerQuantityTotal"> <asp:Label ID="lbQuantity" Text="<%$ Resources:Pollutant,Emissions %>" runat="server"></asp:Label> </div></th>
                          <th scope="col"><div id="headerMethod"><asp:Label ID="lbMethod" Text="<%$ Resources:Pollutant,Method %>" runat="server"></asp:Label> </div></th>
                         
                        </tr>
                    </thead>
                    <tbody>
                        <asp:PlaceHolder id="itemPlaceholder" runat="server" >
                        </asp:PlaceHolder>
                    </tbody>
                </table>
            </LayoutTemplate>
            <ItemTemplate>
                <tr class="generalListStyle_row">
                    <td><asp:ImageButton ID="ImageButton" ImageUrl="~/images/timeseries.png" CommandName='toggletimeseries' CommandArgument='<%#GetPollutantCode(Container.DataItem)%>' runat="server"></asp:ImageButton></td>
                    <td width="55%" title="<%# GetPollutantName(Container.DataItem)%>"><div id="SpecialPollutantName" style="width:100%"><%# GetPollutantName(Container.DataItem)%></div></td>
                    <td title="<%# GetTotalQuantity(Container.DataItem)%>"><div id="QuantityTotal"><%# GetTotalQuantity(Container.DataItem)%></div></td>
                  
                    <td title="<%# GetMethodBasisName(Container.DataItem) %>"><div id="Method"><%# GetMethodBasisName(Container.DataItem) %></div></td>
                  
                </tr>
                <tr>
                    <td colspan="100"> <%--span all--%>
                        <div id="subsheet" class="layout_sheetIntable" visible="false" runat="server">
                            <eprtr:ucFacilityPollutantReleasesTrendSheetEPER ID="timeSeries" Visible="false" runat="server"  />
                        </div>
                    </td>
                </tr>
            </ItemTemplate>
            <EmptyDataTemplate>
            <div class="noResult">
              <asp:Literal ID="litNoResult" Text="<%$ Resources:Common,NoResultsFoundAir %>" runat="server"></asp:Literal>
            </div>
            </EmptyDataTemplate>
        </asp:ListView>
        
        <br/>
        <h3><asp:Label ID="Label1" Text="<%$ Resources:Pollutant,EmissionsToWater %>" runat="server"></asp:Label></h3>
        <asp:ListView ID="lvFacilityPollutantReleasesWATER" runat="server" OnItemCommand="OnItemCommandWATER">
            <LayoutTemplate>
                <table width="100%">
                    <thead>
                        <tr class="generalListStyle_headerRow">
                          <th></th>
                          <th scope="col"><div id="headerSpecialPollutantName"><asp:Label ID="lbReleasesTo" Text="<%$ Resources:Pollutant,PollutantName %>" runat="server"></asp:Label> </div></th>
                          <th scope="col"><div id="headerQuantityTotal"> <asp:Label ID="lbQuantity" Text="<%$ Resources:Pollutant,Emissions %>" runat="server"></asp:Label> </div></th>
                          <th scope="col"><div id="headerMethod"><asp:Label ID="lbMethod" Text="<%$ Resources:Pollutant,Method %>" runat="server"></asp:Label> </div></th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:PlaceHolder id="itemPlaceholder" runat="server" >
                        </asp:PlaceHolder>
                    </tbody>
              </table>
            </LayoutTemplate>
            <ItemTemplate>
                <tr class="generalListStyle_row">
                    <td><asp:ImageButton ID="ImageButton" ImageUrl="~/images/timeseries.png" CommandName='toggletimeseries' CommandArgument='<%#GetPollutantCode(Container.DataItem)%>'  runat="server"></asp:ImageButton></td>
                    <td title="<%# GetPollutantName(Container.DataItem)%>"><div id="headerSpecialPollutantName"><%# GetPollutantName(Container.DataItem)%></div></td>
                    <td title="<%# GetTotalQuantity(Container.DataItem)%>"><div id="QuantityTotal"><%# GetTotalQuantity(Container.DataItem)%></div></td>
                    <td title="<%# GetMethodBasisName(Container.DataItem)%>"><div id="Method"><%# GetMethodBasisName(Container.DataItem) %></div></td>
                </tr>
                <tr>
                    <td colspan="100"> <%--span all--%>
                        <div id="subsheet" class="layout_sheetIntable" visible="false" runat="server">
                            <eprtr:ucFacilityPollutantReleasesTrendSheetEPER ID="timeSeries" Visible="false" runat="server"  />
                        </div>
                    </td>
                </tr>
            </ItemTemplate>
            <EmptyDataTemplate>
            <div class="noResult">
              <asp:Literal ID="litNoResult" Text="<%$ Resources:Common,NoResultsFoundWater %>" runat="server"></asp:Literal>
            </div>
            </EmptyDataTemplate>
        </asp:ListView>
       <br />      
    </div>
</asp:Panel>

