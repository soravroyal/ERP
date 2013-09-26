<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master"
    CodeFile="pgNews.aspx.cs" Inherits="pgNews" EnableEventValidation="false" %>

<%@ Register Src="~/UserControls/Common/ucNewsPresenter.ascx" TagName="ucNewsPresenter"
    TagPrefix="eprtr" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="infoarea" ContentPlaceHolderID="ContentInfoArea" runat="server">
    <%--Title and subtitle--%>
    <div class="StaticPageStyle">
        <h1>
            <asp:Literal ID="PageHeader" Text="<%$ Resources:Static, NewsPageHeader%>" runat="server" />
        </h1>
        <asp:Literal ID="PageContent" Text="" Mode="Transform" runat="server"></asp:Literal>
        <div id="topNews">
            <br />
            <h2>
                <asp:Literal ID="Literal1" Text="<%$ Resources:Common, NewsHeaderTopNews%>" runat="server" />
            </h2>
            <br />
            <eprtr:ucNewsPresenter ID="newsPresenter" runat="server" />
            <br />
        </div>
        <div id="OtherNews">
            <br />
            <br />
            <h2>
                <asp:Literal ID="Literal2" Text="<%$ Resources:Common, NewsHeaderOtherNews%>" runat="server" />
            </h2>
            <br />
            <eprtr:ucNewsPresenter ID="newsArchivePresenter" runat="server" />
        </div>
    </div>
</asp:Content>
