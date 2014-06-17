using System;
using System.Globalization;
using EPRTR.Localization;

public partial class PopupLibraryActivtiesEPER : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        this.Title = string.Format(Resources.GetGlobal("Common", "ActivityPopupTitleEPER"));
    }
}
