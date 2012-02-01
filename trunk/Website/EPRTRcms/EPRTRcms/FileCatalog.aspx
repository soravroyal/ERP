<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FileCatalog.aspx.cs" MasterPageFile="~/MasterPage/MasterPage.Master"
    Inherits="EPRTRcms.FileCatalog" %>

<asp:Content ID="UploadCatalogContent" ContentPlaceHolderID="ContentDisplayArea"
    runat="server">
    <div class="contentArea" runat="server">
        <h1>
            File Catalog</h1>
        <p>
            The File catalog is used to upload documents to the E-PRTR website.</p>
        <p>
            Uploaded files can be linked to internally from static pages or news stories using
            the relative paths shown in the right side of the table.</p>
        <p>
            Upload only files that naturally belong with the E-PRTR website. Documents that
            originate outside the context of E-PRTR, should be externally linked to at the original
            sources.</p>
        <p>
            Typical file types are PDF and Word.</p>
    <br /><br />
        <asp:FileUpload ID="FileUploadControl" runat="server" Width="500" />
        <asp:Button runat="server" ID="UploadButton" Text="Upload" OnClick="UploadButton_Click"
            Height="20" />
        <br />
        <br />
        <asp:Label runat="server" ID="StatusLabel" Text="Upload status: " />
        <br />
        <br />
        <asp:UpdatePanel ID="FileListUpdatePanel" runat="server">
            <Triggers>
                <asp:PostBackTrigger ControlID="UploadButton" />
            </Triggers>
            <ContentTemplate>
                <asp:GridView ID="DataListFiles" runat="server" Width="70%" CellPadding="3" RowStyle-BackColor="LightGray"
                    AlternatingRowStyle-BackColor="White" AutoGenerateColumns="false">
                    <Columns>
                        <asp:BoundField DataField="Name" HeaderText="Filename" />
                        <asp:BoundField DataField="Extension" HeaderText="File extension" />
                        <asp:BoundField DataField="Size" HeaderText="File size" />
                        <asp:BoundField DataField="ModifiedDate" HeaderText="Date modified" />
                        <asp:CheckBoxField DataField="IsReadOnly" HeaderText="Read only" />
                        <asp:TemplateField>
                            <HeaderTemplate>
                                Relative path</HeaderTemplate>
                            <ItemTemplate>
                                <a href="<%# GetHrefURL(Container.DataItem) %>" target="_blank">
                                    <%# DataBinder.Eval(Container.DataItem, "RelativePath") %></a>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
