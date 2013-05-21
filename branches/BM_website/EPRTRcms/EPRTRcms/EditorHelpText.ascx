<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditorHelpText.ascx.cs"
    Inherits="EPRTRcms.EditorHelpText" %>
    
<asp:Label ID="Label1" runat="server">
    <h2>Basic text editing</h2>
    <ul>
        <li>Enter the desired content, and press the submit button below the text editor to upload changes.</li>
        <li>Note that your changes become online on the E-PRTR website (and Review) immediately when you click the submit button.</li>
        <li>To cancel the current changes select a different text entry from the left side tree view or close the browser window if you are done.</li>
    </ul>
    <h2>Styling&nbsp;guideline, keep in mind, i.e.:</h2>
    <ul>
        <li>Please don't use Heading1; it reserved for the actual page titles.</li>
        <li>Use Heading2 as the high level of titles within the page.</li>
        <li>You can use Heading3 for sub-titles.</li>
        <li>Bold and Italic can be used to emphasize minor parts.</li>
    </ul>
    <h2>Inserting links</h2>
    <ul>
        <li>Select the text you want to turn into a link.</li>
        <li>Click the "Insert/edit URL" button to open the link dialog.</li>
        <li>Type the URL   
            <ul>
                <li>If you link to external sources, type the entire URL including "http://". I.e.&nbsp;<a href="http://www.unece.org">http://www.unece.org</a>.</li>
                <li>If you link internally to an E-PRTR webpage, simply copy the page name from the address field, i.e. "pgNews.aspx" or "FacilityLevels.aspx".</li>
                <li>If you link&nbsp;to a document in the E-PRTR document folder, type&nbsp;"docs/" in front of the filename, i.e. "docs/EN_E-PRTR_fin.pdf"&nbsp;in order to link to the English&nbsp;version of the&nbsp;E-PRTR Guidance Document&nbsp;in PDF format.</li>
            </ul>
        </li>
        <li>As Target select either "open in this window" or "open in new window".</li>
    </ul>
</asp:Label>