using System;
using System.Globalization;
using System.IO;
using System.Xml.Xsl;
using System.Web.Caching;
using System.Collections.Generic;
using System.Collections;
using System.Security.Policy;

public partial class PopupLibraryEmissionsEPER : BasePage
{
    protected void Page_PreInit(object sender, EventArgs e)
    {
        if (Request.QueryString["mpage"] == "pop")
        {
            this.MasterPageFile = "~/MasterPopupEPER.master";
        }
        else
        {
            this.MasterPageFile = "~/MasterPage.master";
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {

    }
}

