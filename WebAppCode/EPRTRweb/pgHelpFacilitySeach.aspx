<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPopup.master"
    CodeFile="pgHelpFacilitySeach.aspx.cs" Inherits="pgLibraryWaste" %>

<%--<%@ Register Src="~/UserControls/Library/ucLibraryWaste.ascx"  TagName="LibraryWaste" TagPrefix="eprtr"%>--%>



<asp:Content ID="infoarea" ContentPlaceHolderID="ContentInfoArea" runat="server">
    <%--Title and subtitle--%>
    <div class="StaticPageStyle">
        <h1>
            <asp:Literal ID="PageHeader" Text="" runat="server" />
        </h1>
        <p>
            <asp:Literal ID="PageContent" Text="" Mode="Transform" runat="server" />
        </p>
    </div>
</asp:Content>
