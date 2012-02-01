<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master"
    CodeFile="Home.aspx.cs" Inherits="Home" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="infoarea" ContentPlaceHolderID="ContentInfoArea" runat="server">
    <%-- Home page content Title and text--%>
    <asp:UpdatePanel UpdateMode="Conditional" runat="server">
        <ContentTemplate>
            <div id="homeContent">
                <h1>
                    <asp:Literal ID="litHeader" Text="<%$ Resources:Static, HomeHeadline %>" runat="server" />
                </h1>
                <asp:Label Style="color: Gray" ID="litNewsDate" Visible="false" Text="" runat="server" />
                <asp:Literal ID="litTextBody" Text="" Mode="Transform" runat="server" />
            </div>

            <%--News panel--%>
            <div class="news_area" runat="server">
                  <div id="news_icon" class="newsImage"  runat="server">
                    <asp:HyperLink runat="server" Text="<%$ Resources:Static, NewsIconText %>"></asp:HyperLink>
                  </div>
                <br />
                <table width="100%">
                    <asp:Repeater ID="repeaterNews" runat="server" OnItemCommand="lnkNewsItem_Click">
                        <ItemTemplate>
                            <tr class="news_head">
                                <td>
                                    <%# GetTimeStamp(Container.DataItem)%>
                                </td>
                            </tr>
                            <tr class="news_box">
                                <td>
                                    <%-- Pass a concatenated string of Header, Date and Text body as CommandArgument. 
                                        Separated by '¤' --%>
                                    <asp:LinkButton ID="lnkOpenNewsItem" runat="server" 
                                        Text='<%# GetHeaderText(Container.DataItem) %>' CommandArgument='<%# GetCommandArgument(Container.DataItem)%>'></asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </table>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="repeaterNews" EventName="ItemCommand" />        
        </Triggers>
    </asp:UpdatePanel>

</asp:Content>
