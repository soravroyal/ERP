<%@ Control Language="C#" CodeFile="ucFacilityPollutantReleases.ascx.cs" Inherits="ucFacilityPollutantReleases" %>

<%@ Register Src="~/UserControls/SearchFacility/TimeSeries/ucFacilityPollutantReleasesTrendSheet.ascx" TagName="ucFacilityPollutantReleasesTrendSheet" TagPrefix="eprtr" %>

<asp:Panel ID="facilityPollutantReleases" runat="server" Width="100%">
    
    <div runat="server" class="printStyles">
    <h3><asp:Label ID="Label2" Text="<%$ Resources:Pollutant,ReleasesToAir %>" runat="server"></asp:Label></h3>
        <asp:ListView ID="lvFacilityPollutantReleasesAIR" runat="server" OnItemCommand="OnItemCommandAIR">
            <LayoutTemplate>
                <table cellpadding="1px;">
                    <thead>
                        <tr class="generalListStyle_headerRow">
                          <th></th>
                          <th><div id="headerSpecialPollutantName"><asp:Label ID="lbReleasesTo" Text="<%$ Resources:Pollutant,PollutantName %>" runat="server"></asp:Label></div></th>
                          <th><div id="headerQuantityTotal"> <asp:Label ID="lbQuantity" Text="<%$ Resources:Pollutant,TotalQuantity %>" runat="server"></asp:Label> </div></th>
                          <th><div id="headerAccidental"> <asp:Label ID="lbAccidental" Text="<%$ Resources:Pollutant,ReleasesAccidental %>" runat="server"></asp:Label> </div></th>
                          <th><div id="headerAccidentalPercent"><asp:Label ID="lbAccidentalPercent" Text="<%$ Resources:Pollutant,ReleasesAccidentalPercent %>" runat="server"></asp:Label> </div></th>
                          <th><div id="headerMethod"><asp:Label ID="lbMethod" Text="<%$ Resources:Pollutant,Method %>" runat="server"></asp:Label> </div></th>
                          <th><div id="headerMethodUsed"><asp:Label ID="lbMethodUsed" Text="<%$ Resources:Pollutant,MethodUsed %>" runat="server"></asp:Label> </div></th>
                          <th><div id="headerReason"><asp:Label ID="lbReason" Text="<%$ Resources:Pollutant,Confidentiality%>" runat="server"></asp:Label> </div></th>
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
                    <td title="<%# GetPollutantName(Container.DataItem)%>"><div id="SpecialPollutantName"><%# GetPollutantName(Container.DataItem)%></div></td>
                    <td title="<%# GetTotalQuantity(Container.DataItem)%>"><div id="QuantityTotal"><%# GetTotalQuantity(Container.DataItem)%></div></td>
                    <td title="<%# GetAccidentalQuantity(Container.DataItem)%>"><div id="Accidental"><%# GetAccidentalQuantity(Container.DataItem)%></div></td>
                    <td title="<%# GetAccidentalPercent(Container.DataItem)%>"><div id="AccidentalPercent"><%# GetAccidentalPercent(Container.DataItem)%></div></td>
                    <td title="<%# GetMethodBasisName(Container.DataItem) %>"><div id="Method"><%# GetMethodBasisName(Container.DataItem) %></div></td>
                    <td ><div id="MethodUsed"><%# GetMethodUsed(Container.DataItem)%></div></td>
                    <td title="<%# GetConfidentialityReason(Container.DataItem)%>"><div id="Reason"> <%# GetConfidentialCode(Container.DataItem)%> </div></td>
                </tr>
                <tr>
                    <td colspan="100"> <%--span all--%>
                        <div id="subsheet" class="layout_sheetIntable" visible="false" runat="server">
                            <eprtr:ucFacilityPollutantReleasesTrendSheet ID="timeSeries" Visible="false" runat="server"  />
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
        <h3><asp:Label ID="Label1" Text="<%$ Resources:Pollutant,ReleasesToWater %>" runat="server"></asp:Label></h3>
        <asp:ListView ID="lvFacilityPollutantReleasesWATER" runat="server" OnItemCommand="OnItemCommandWATER">
            <LayoutTemplate>
                <table>
                    <thead>
                        <tr class="generalListStyle_headerRow">
                          <th></th>
                          <th><div id="headerSpecialPollutantName"><asp:Label ID="lbReleasesTo" Text="<%$ Resources:Pollutant,PollutantName %>" runat="server"></asp:Label> </div></th>
                          <th><div id="headerQuantityTotal"> <asp:Label ID="lbQuantity" Text="<%$ Resources:Pollutant,TotalQuantity %>" runat="server"></asp:Label> </div></th>
                          <th><div id="headerAccidental"> <asp:Label ID="lbAccidental" Text="<%$ Resources:Pollutant,ReleasesAccidental %>" runat="server"></asp:Label> </div></th>
                          <th><div id="headerAccidentalPercent"><asp:Label ID="lbAccidentalPercent" Text="<%$ Resources:Pollutant,ReleasesAccidentalPercent %>" runat="server"></asp:Label> </div></th>
                          <th><div id="headerMethod"><asp:Label ID="lbMethod" Text="<%$ Resources:Pollutant,Method %>" runat="server"></asp:Label> </div></th>
                          <th><div id="headerMethodUsed"><asp:Label ID="lbMethodUsed" Text="<%$ Resources:Pollutant,MethodUsed %>" runat="server"></asp:Label> </div></th>
                          <th><div id="headerReason"><asp:Label ID="lbReason" Text="<%$ Resources:Pollutant,Confidentiality%>" runat="server"></asp:Label> </div></th>
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
                    <td title="<%# GetAccidentalQuantity(Container.DataItem)%>"><div id="Accidental"><%# GetAccidentalQuantity(Container.DataItem)%></div></td>
                    <td title="<%# GetAccidentalPercent(Container.DataItem)%>"><div id="AccidentalPercent"><%# GetAccidentalPercent(Container.DataItem)%></div></td>
                    <td title="<%# GetMethodBasisName(Container.DataItem)%>"><div id="Method"><%# GetMethodBasisName(Container.DataItem) %></div></td>
                    <td ><div id="MethodUsed"><%# GetMethodUsed(Container.DataItem)%></div></td>
                    <td title="<%# GetConfidentialityReason(Container.DataItem)%>"><div id="Reason"> <%# GetConfidentialCode(Container.DataItem)%> </div></td>
                </tr>
                <tr>
                    <td colspan="100"> <%--span all--%>
                        <div id="subsheet" class="layout_sheetIntable" visible="false" runat="server">
                            <eprtr:ucFacilityPollutantReleasesTrendSheet ID="timeSeries" Visible="false" runat="server"  />
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
        
        <br/>
        <h3><asp:Label ID="lbHeader1" Text="<%$ Resources:Pollutant,ReleasesToSoil %>" runat="server"></asp:Label></h3>
        <asp:ListView ID="lvFacilityPollutantReleasesSOIL" runat="server" OnItemCommand="OnItemCommandSOIL">
            <LayoutTemplate>
                <table>
                    <thead>
                        <tr class="generalListStyle_headerRow">
                            <th></th>
                            <th><div id="headerSpecialPollutantName"><asp:Label ID="lbReleasesTo" Text="<%$ Resources:Pollutant,PollutantName %>" runat="server"></asp:Label></div></th>
                            <th><div id="headerQuantityTotal"> <asp:Label ID="lbQuantity" Text="<%$ Resources:Pollutant,TotalQuantity %>" runat="server"></asp:Label> </div></th>
                            <th><div id="headerAccidental"> <asp:Label ID="lbAccidental" Text="<%$ Resources:Pollutant,ReleasesAccidental %>" runat="server"></asp:Label> </div></th>
                            <th><div id="headerAccidentalPercent"><asp:Label ID="lbAccidentalPercent" Text="<%$ Resources:Pollutant,ReleasesAccidentalPercent %>" runat="server"></asp:Label> </div></th>
                            <th><div id="headerMethod"><asp:Label ID="lbMethod" Text="<%$ Resources:Pollutant,Method %>" runat="server"></asp:Label> </div></th>
                            <th><div id="headerMethodUsed"><asp:Label ID="lbMethodUsed" Text="<%$ Resources:Pollutant,MethodUsed %>" runat="server"></asp:Label> </div></th>
                            <th><div id="headerReason"><asp:Label ID="lbReason" Text="<%$ Resources:Pollutant,Confidentiality%>" runat="server"></asp:Label> </div></th>
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
                    <td title="<%# GetAccidentalQuantity(Container.DataItem)%>"><div id="Accidental"><%# GetAccidentalQuantity(Container.DataItem)%></div></td>
                    <td title="<%# GetAccidentalPercent(Container.DataItem)%>"><div id="AccidentalPercent"><%# GetAccidentalPercent(Container.DataItem)%></div></td>
                    <td title="<%# GetMethodBasisName(Container.DataItem) %>"><div id="Method"><%# GetMethodBasisName(Container.DataItem)%></div></td>
                    <td><div id="MethodUsed"><%# GetMethodUsed(Container.DataItem)%></div></td>
                    <td title="<%# GetConfidentialityReason(Container.DataItem)%>"><div id="Reason"> <%# GetConfidentialCode(Container.DataItem)%> </div></td>
                </tr>
                <tr>
                    <td colspan="100"> <%--span all--%>
                        <div id="subsheet" class="layout_sheetIntable" visible="false" runat="server">
                            <eprtr:ucFacilityPollutantReleasesTrendSheet ID="timeSeries" Visible="false" runat="server"  />
                        </div>
                    </td>
                </tr>
            </ItemTemplate>
            <EmptyDataTemplate>
            <div class="noResult">
              <asp:Literal ID="litNoResult" Text="<%$ Resources:Common,NoResultsFoundSoil %>" runat="server"></asp:Literal>
            </div>
            </EmptyDataTemplate>
        </asp:ListView>
        <br/>
    </div>
</asp:Panel>

