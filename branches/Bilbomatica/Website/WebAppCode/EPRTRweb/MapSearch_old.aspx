<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master"
    CodeFile="MapSearch_old.aspx.cs" Inherits="MapSearch" %>
    <%@ Register TagPrefix="nfp" TagName="NoFlashPlayer" Src="~/UserControls/Common/ucNoFlashPlayer.ascx" %>

<asp:Content ID="infoarea" ContentPlaceHolderID="ContentInfoArea" runat="server">
    <%--Java Script functions --%>

    <script type="text/javascript" src="Scripts/map.js"></script>

    <div class="StaticPageStyle">
        <h1>
            <asp:Literal ID="PageHeader" Text="<%$ Resources:MapSearch, MapSearchPageHeader%>" runat="server" />
        </h1>
        <p>
            <asp:Literal ID="PageContent" Text="<%$ Resources:MapSearch, MapSearchPageContent %>"
                runat="server"></asp:Literal>
        </p>
    <table>
    <tr><td id="expand_btn_topbar">
    <div id="expand_btn_mapsearch">
        <asp:ImageButton ID="btnExpand" ImageUrl="~/images/i_maximize.gif" runat="server"
            CssClass="expandbutton_mapsearch" ImageAlign="Right" Visible="true" ToolTip="<%$ Resources:Common,ShowExpandedMapSearch %>" />
    </div>
    </td>
    </tr>
    <tr><td>
    <asp:Panel ID="mapSearchPanel" runat="server" Visible="true">
        <div id="mapSearch" visible="true">
         <nfp:NoFlashPlayer ID="NoFlashPlayer" runat="server" />
        </div>
    </asp:Panel>
    </td>
    </tr>
    </table>
    </div>
</asp:Content>
