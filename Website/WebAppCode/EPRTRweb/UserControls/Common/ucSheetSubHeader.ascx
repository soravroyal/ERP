<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucSheetSubHeader.ascx.cs" Inherits="ucSheetSubHeader" %>
<%@ Register Src="~/UserControls/Common/ucInfo.ascx" TagName="Info" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucConfidentialDisclaimer.ascx" TagName="ConfidentialDisclaimer" TagPrefix="eprtr" %>


<%--<asp:GridView ID="subheadlineGridView" runat="server" 
    AutoGenerateColumns="false" 
    GridLines="None" 
    ShowHeader="false" 
    Visible="true" 
    CssClass=""
    RowStyle-BorderStyle="None">
    <Columns>
      <asp:TemplateField >
        <ItemTemplate >
            <div id="resultSheet_subHeader_label">
                <%#GetLabel(Container.DataItem)%>
            </div>
        </ItemTemplate>
      </asp:TemplateField>
      <asp:TemplateField>
        <ItemTemplate>
            <div id="resultSheet_subHeader_value">
                <%#GetValue(Container.DataItem)%>
            </div>
        </ItemTemplate>
      </asp:TemplateField>
    </Columns>
</asp:GridView>--%>


<asp:GridView ID="subheadlineGridView"
    AutoGenerateColumns="false" GridLines="None" ShowHeader="false" Visible="true" 
    CssClass="" RowStyle-BorderStyle="None"
    runat="server" 
    RowHeaderColumn="Label">
    <Columns>
        <asp:BoundField DataField="Label" ItemStyle-CssClass="resultSheet_subHeader_label detailsTitleColor"></asp:BoundField>
        <asp:BoundField DataField="Value" ItemStyle-CssClass="resultSheet_subHeader_value"></asp:BoundField>
    </Columns>
</asp:GridView>



<asp:Label ID="lblText" CssClass="resultSheet_txt" runat="server" Visible="false"></asp:Label>

<eprtr:ConfidentialDisclaimer ID="ucConfidentialDisclaimer" CssClass="resultSheet_alert" runat="server"  Visible="false"/> 




