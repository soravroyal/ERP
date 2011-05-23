<%@ Control Language="C#" CodeFile="ucFacilityWaste.ascx.cs" EnableViewState="true" Inherits="ucFacilityWaste" %>

<%@ Register Src="~/UserControls/SearchFacility/TimeSeries/ucFacilityWasteTrendSheet.ascx" TagName="ucFacilityWasteTrendSheet" TagPrefix="eprtr" %>


<asp:Panel ID="facilityWastePanel" runat="server" Width="100%" Height="100%">
    <div>

    <h3>    
        <asp:ImageButton ID="btnNonhazardouswaste" ImageUrl="~/images/timeseries.png" OnClick="onClickNonhazardouswaste" runat="server" />
        <asp:Label ID="nonhazardouswasteID" Text="<% $Resources:WasteTransfers, Nonhazardouswaste %>" runat="server"></asp:Label>
    </h3>
    
    <asp:Panel ID="nonHazardouswastePanel" CssClass="layout_sheetInsheet" runat="server" Visible="false">
        <%--<asp:Literal ID="lbConfidentiallityText" Text="<%$Resources:Common, WasteTimeSeriesNoData%>" runat="server" Visible="true"/>--%>
        <eprtr:ucFacilityWasteTrendSheet ID="nonhazardousTimeSeries" Visible="false" runat="server" /><br />
    </asp:Panel>
    
    <asp:ListView ID="GridView1" runat="server">
        <LayoutTemplate>
            <table>
                <thead>
                    <tr class="generalListStyle_headerRow">
                        <th><div id="headerQuantityTotal">  <asp:Label ID="lbQuantity" Text="<%$Resources:Common, Quantity%>" runat="server"/>          </div></th>
                        <th><div id="headerSpecialTreatment">      <asp:Label ID="lbTreatment" Text="<%$Resources:Common, Treatment%>" runat="server"/>        </div></th>
                        <th><div id="headerSpecialMethod">         <asp:Label ID="lbMethod" Text="<%$Resources:Common, Method%>" runat="server"/>             </div></th>
                        <th><div id="headerSpecialMethodUsed">     <asp:Label ID="lbMethodUsed" Text="<%$Resources:Common, MethodUsed%>" runat="server"/>      </div></th>
                        <th><div id="headerReason">         <asp:Label ID="lbReason" Text="<%$ Resources:Pollutant,Confidentiality%>" runat="server"/>  </div></th>
                    </tr>
                </thead>
                <tbody>
                    <asp:PlaceHolder ID="itemPlaceholder" runat="server"></asp:PlaceHolder>
                </tbody>
            </table>
        </LayoutTemplate>
        <ItemTemplate>
            <tr class="generalListStyle_row">
                <td title="<%# GetQuantity(Container.DataItem)%>"><div id="QuantityTotal"><%# GetQuantity(Container.DataItem)%></div></td>
                <td title=" <%# GetTreatment(Container.DataItem)%>"><div id="SpecialTreatment"><%# GetTreatment(Container.DataItem)%></div></td>
                <td title="<%# GetMethodBasis(Container.DataItem)%>"><div id="SpecialMethod"><%# GetMethodBasis(Container.DataItem)%></div></td>
                <td title="<%# GetMethodUsedTitle(Container.DataItem)%>"><div id="SpecialMethodUsed"><%# GetMethodUsed(Container.DataItem)%></div></td>
                <td title="<%# GetConfidentialReason(Container.DataItem)%>"><div id="Reason"><%# GetConfidentialCode(Container.DataItem)%></div></td>
            </tr>
        </ItemTemplate>
        <EmptyDataTemplate>
            <div class="noResult">
                <asp:Literal ID="litNoResultNONHW" Text="<%$ Resources:Common,NothingReported %>" runat="server"/>
            </div>
        </EmptyDataTemplate>
    </asp:ListView>
    
    <br />
    
    <h3>
        <asp:ImageButton ID="btnHazardouswastewithincountry" ImageUrl="~/images/timeseries.png" OnClick="onClickHazardouswastewithincountry" runat="server" />
        <asp:Label ID="hazardouswastewithincountryID" Text="<% $Resources:WasteTransfers, Hazardouswastewithincountry %>" runat="server"/>
    </h3>
    <asp:Panel ID="hazardouswasteCountryPanel" CssClass="layout_sheetInsheet" runat="server" Visible="false">
        <%--<asp:Literal ID="Literal1" Text="<%$Resources:Common, WasteTimeSeriesNoData%>" runat="server" Visible="true"></asp:Literal>--%>
        <eprtr:ucFacilityWasteTrendSheet ID="hazardouswasteCountryTimeSeries" Visible="false" runat="server"  /><br />
    </asp:Panel>
    
    <asp:ListView ID="GridView2" runat="server">
        <LayoutTemplate>
            <table>
                <thead>
                    <tr class="generalListStyle_headerRow">
                        <th><div id="headerQuantityTotal">  <asp:Label ID="lbQuantity" Text="<%$Resources:Common, Quantity%>" runat="server"/>          </div></th>
                        <th><div id="headerSpecialTreatment">      <asp:Label ID="lbTreatment" Text="<%$Resources:Common, Treatment%>" runat="server"/>        </div></th>
                        <th><div id="headerSpecialMethod">         <asp:Label ID="lbMethod" Text="<%$Resources:Common, Method%>" runat="server" />             </div></th>
                        <th><div id="headerSpecialMethodUsed">     <asp:Label ID="lbMethodUsed" Text="<%$Resources:Common, MethodUsed%>" runat="server"/>      </div></th>
                        <th><div id="headerReason">         <asp:Label ID="lbReason" Text="<%$ Resources:Pollutant,Confidentiality%>" runat="server"/>  </div></th>
                    </tr>
                </thead>
                <tbody>
                    <asp:PlaceHolder ID="itemPlaceholder" runat="server"></asp:PlaceHolder>
                </tbody>
            </table>
        </LayoutTemplate>
        <ItemTemplate>
            <tr class="generalListStyle_row">
                <td title="<%# GetQuantity(Container.DataItem)%>"><div id="QuantityTotal"><%# GetQuantity(Container.DataItem)%></div></td>
                <td title="<%# GetTreatment(Container.DataItem)%>"><div id="SpecialTreatment"><%# GetTreatment(Container.DataItem)%></div></td>
                <td title="<%# GetMethodBasis(Container.DataItem) %>"><div id="SpecialMethod"><%# GetMethodBasis(Container.DataItem)%></div></td>
                <td title="<%# GetMethodUsedTitle(Container.DataItem)%>"><div id="SpecialMethodUsed"><%# GetMethodUsed(Container.DataItem)%></div></td>
                <td title="<%# GetConfidentialReason(Container.DataItem)%>"><div id="Reason"><%# GetConfidentialCode(Container.DataItem)%></div></td>
            </tr>
        </ItemTemplate>
        <EmptyDataTemplate>
            <div class="noResult">
                <asp:Literal ID="litNoResultHWIC" Text="<%$ Resources:Common,NothingReported %>" runat="server"></asp:Literal>
            </div>
        </EmptyDataTemplate>
    </asp:ListView>
    
    <br />
    <h3>
        <asp:ImageButton ID="btnHazardouswastetransboundary" ImageUrl="~/images/timeseries.png" OnClick="onClickHazardouswastetransboundary" runat="server" />
        <asp:Label ID="hazardouswastetransboundaryID" Text="<% $Resources:WasteTransfers, hazardouswastetransboundary %>" runat="server"/>
    </h3>
    <asp:Panel ID="hazardousTransboundaryPanel" CssClass="layout_sheetInsheet" runat="server" Visible="false">
        <%--<asp:Literal ID="Literal2" Text="<%$Resources:Common, WasteTimeSeriesNoData%>" runat="server" Visible="true"/>--%>
        <eprtr:ucFacilityWasteTrendSheet ID="hazardousTransboundaryTimeSeries" Visible="false" runat="server"  /><br />
    </asp:Panel>
        
    <asp:ListView ID="GridView3" runat="server">
        <LayoutTemplate>
            <table>
                <thead>
                    <tr class="generalListStyle_headerRow">
                        <th><div id="headerQuantityTotal">      <asp:Label ID="lbQuantity" Text="<%$Resources:Common, Quantity%>" runat="server"/>                      </div></th>
                        <th><div id="headerTreatment">          <asp:Label ID="lbTreatment" Text="<%$Resources:Common, Treatment%>" runat="server"/>                    </div></th>
                        <th><div id="headerMethod">             <asp:Label ID="lbMethod" Text="<%$Resources:Common, Method%>" runat="server"/>                          </div></th>
                        <th><div id="headerMethodUsed">         <asp:Label ID="lbMethodUsed" Text="<%$Resources:Common, MethodUsed%>" runat="server"/>                  </div></th>
                        <th><div id="headerReceivingCountry">   <asp:Label ID="lbReceivingCountry" Text="<%$Resources:Common, ReceivingCountry%>" runat="server"/>      </div></th>
                        <th><div id="headerRecoverer">          <asp:Label ID="lbRecoverer" Text="<%$ Resources:WasteTransfers, RecovererDisposer %>" runat="server"/>  </div></th>
                        <th><div id="headerActual">             <asp:Label ID="lbActual" Text="<%$ Resources:Facility, SiteAddress %>" runat="server"/>                  </div></th>
                        <th><div id="headerReason">             <asp:Label ID="lbReason" Text="<%$ Resources:Pollutant,Confidentiality%>" runat="server"/>              </div></th>
                    </tr>
                </thead>
                <tbody>
                    <asp:PlaceHolder ID="itemPlaceholder" runat="server"></asp:PlaceHolder>
                </tbody>
            </table>
        </LayoutTemplate>
        <ItemTemplate>
            <tr class="generalListStyle_row">
                <td title=" <%# GetQuantity(Container.DataItem)%>"><div id="QuantityTotal"><%# GetQuantity(Container.DataItem)%></div></td>
                <td title="<%# GetTreatment(Container.DataItem)%>"><div id="Treatment"><%# GetTreatment(Container.DataItem)%></div></td>
                <td title=" <%# GetMethodBasis(Container.DataItem)%>"><div id="Method"><%# GetMethodBasis(Container.DataItem)%></div></td>
                <td title="<%# GetMethodUsedTitle(Container.DataItem)%>"><div id="MethodUsed"><%# GetMethodUsed(Container.DataItem)%></div></td>
                <td title="<%# GetReceivingCountry(Container.DataItem)%>"><div id="ReceivingCountry"><%# GetReceivingCountry(Container.DataItem)%></div></td>
                <td title=" <%# GetWHPNameAndAddress(Container.DataItem)%>"><div id="Recoverer"><%# GetWHPNameAndAddress(Container.DataItem)%></div></td>
                <td title=" <%# GetWHPSiteAddress(Container.DataItem)%>"><div id="Actual"><%# GetWHPSiteAddress(Container.DataItem)%></div></td>
                <td title=" <%# GetConfidentialReason(Container.DataItem)%>"><div id="Reason"><%# GetConfidentialCode(Container.DataItem)%></div></td>
            </tr>
        </ItemTemplate>
        <EmptyDataTemplate>
            <div class="noResult">
                <asp:Literal ID="litNoResultHWIC" Text="<%$ Resources:Common,NothingReported %>" runat="server"></asp:Literal>
            </div>
        </EmptyDataTemplate>
    </asp:ListView>

    <br />
    </div>
</asp:Panel>
