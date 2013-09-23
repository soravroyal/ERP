<%@ Control Language="C#" CodeFile="ucFacilityDetails.ascx.cs" EnableViewState="true" Inherits="ucFacilityDetails" %>

<%@ Register Src="~/UserControls/SearchFacility/ucFacilityDetailsMap.ascx" TagName="ucFacilityDetailsMap" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucInfo.ascx" TagName="Info" TagPrefix="eprtr" %>

<asp:Panel ID="facilityDetailsPanel" runat="server" Width="100%">
        
        <%--<%$ Common:PrintRefresh %>--%>
        <div runat="server" class="printStyles">
        
        <div id="facilityimage">
            <eprtr:ucFacilityDetailsMap ID="ucFacilityDetailsMap" runat="server" />
            <asp:Image id="detailmapprint" ImageUrl="" alt="<%$ Resources:Common,PrintRefresh %>" runat="server" visible="true" CssClass="facilityMapPrint" />
        </div>
        
        <div id="facilityreportdetails">
            <asp:GridView ID="facilityreportDetails" OnRowDataBound="GridView1_RowDataBound"
                runat="server" ShowHeader="false" AutoGenerateColumns="false" GridLines="none"
                EmptyDataRowStyle-Height="0px">
                <Columns>
                    <asp:BoundField DataField="Label" ></asp:BoundField>
                    <asp:BoundField DataField="Value" ></asp:BoundField>
                </Columns>
            </asp:GridView>
        </div>
        
        <%-- activities --%>
        <div id="facilityreportActivity">
           <asp:GridView ID="gdwActivities" runat="server" GridLines="Horizontal"
            ShowHeader="true" AutoGenerateColumns="false" OnRowDataBound="ActivityRowDataBound"
            CssClass="generalListStyle"
            RowStyle-CssClass= "generalListStyle_row" 
            HeaderStyle-CssClass="generalListStyle_headerRow">
                <Columns>
                    <asp:TemplateField>
                        <HeaderTemplate>
                            <eprtr:Info ID="ucActivityInfo" Type="Activity" Text="<%$ Resources:Facility,IndustrialActivities %>" CssClass="facilityActivity" runat="server" />
                        </HeaderTemplate>
                        <ItemTemplate>
                            <div class="<%#GetIndentCss(Container.DataItem) %> facilityActivity">
                                <asp:Literal ID="lblActivity" Text="<%#GetActivityName(Container.DataItem) %>" runat="server"></asp:Literal>
                            </div>                            
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <HeaderTemplate>
                            <div class="facilityIPPC">
                                <asp:Literal ID="lblHeaderIPPC" Text="<%$ Resources:Facility,IPPCcode %>" runat="server"></asp:Literal>
                            </div>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <div class="facilityIPPC">
                                <asp:Literal ID="lblIPPC" Text="<%#GetIPPC(Container.DataItem) %>" runat="server"></asp:Literal>
                            </div>                            
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>  
        <%-- public info --%>
        <div id="publicinfo">
            <asp:Literal ID="litPublicInfo" Text="<%$ Resources:Common,PublicInfo %>" runat="server"></asp:Literal><br />
            <asp:TextBox ID="txPublicInfo" Font-Size="Small" Wrap="true" ReadOnly="true" Height="50" Width="100%" TextMode="MultiLine" runat="server"></asp:TextBox>
        </div>
       
        </div>
      
</asp:Panel>

