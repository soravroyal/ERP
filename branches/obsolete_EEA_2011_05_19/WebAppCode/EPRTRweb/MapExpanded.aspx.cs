﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using EPRTR.Utilities;
using EPRTR.Localization;

public partial class MapExpanded : BasePage
{
    private const string MAPID = "mapExpandId"; //The mapid must correspond to the id of the div

    /// <summary>
    /// Page load, get map input parameters request param
    /// </summary>
    protected void Page_Load(object sender, EventArgs e)
    {
        // set title of expand vindow
        string headline = Global.base64ToText(Request.Params["headline"]);
        this.Title = String.Format(Resources.GetGlobal("Common", "ExpandedMapTitle"), headline);

        //if (!IsPostBack)
        //{
        //    // get params from request
        //    string searchpage = Request.Params["searchpage"];
            
        //    // convert
        //    string query = Global.base64ToText(Request.Params["query"]);
        //    string sector = Global.base64ToText(Request.Params["sector"]);
        //    string header = Global.base64ToText(Request.Params["header"]);
        //    string visibleLayers = Global.base64ToText(Request.Params["visible"]);
            
        //    string extent = Request.Params["extent"];

        //    // create expanded map. 
        //    MapUtils.CreateExpandedMap(MAPID, this.formMapExpand, searchpage, query, sector, header, extent, Request.ApplicationPath, visibleLayers);
        //}
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        createMap();
        //base.OnPreRender(e);
    }

    

    private void createMap(){
        
        if (!IsPostBack)
        {
            // get params from request
            string searchpage = Request.Params["searchpage"];
            
            // convert
            string query = Global.base64ToText(Request.Params["query"]);
            string sector = Global.base64ToText(Request.Params["sector"]);
            string header = Global.base64ToText(Request.Params["header"]);
            string visibleLayers = Global.base64ToText(Request.Params["visible"]);
            
            string extent = Request.Params["extent"];

            // create expanded map. 
            MapUtils.CreateExpandedMap(MAPID, this.formMapExpand, searchpage, query, sector, header, extent, Request.ApplicationPath, visibleLayers);
        }
    
    }


    
    
}