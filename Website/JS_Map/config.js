{
	"values": {
	"displaybasemaps": "true",
	"displaylegend": "true",
	"displayshare": "true",
	"displaymeasure": "true",
	"displayelevation": "false",
	"showelevationdifference": "false",
	"theme": "gray",
	"displaydetails": "true",
	"displayeditor": "true",
	"displaylayerlist": "true",
	"displayoverviewmap": "true",
	"displaytimeslider": "true",
	"displayprint": "true",
	"displaysearch": "true",
	"ts_latestData":false,
	"timeslideroffsetunit" : "days",
	"timeslidertmbcount": "2",
	"timeslidersingleinstant":false,
	"timesliderendtoday":false,
	"keepTime":false,
	"hideEmptyValues":false,
	"showLegendToTOC":true,
	"legendInLayers":false
	},
	"configurationSettings":[{
		"category" : "<b>General Settings</b>",
		"fields" : [{
			"label" : "Color Scheme:",
			"fieldName" : "theme",
			"type" : "string",
			"options" : [{
				"value" : "blue",
				"label" : "Blue"
			}, {
				"value" : "gray",
				"label" : "Gray"
			}, {
				"value" : "green",
				"label" : "Green"
			}, {
				"value" : "orange",
				"label" : "Orange"
			}, {
				"value" : "purple",
				"label" : "Purple"
			}],
			"tooltip" : "Color theme to use"
		}, {
			"label" : "Show Title",
			"fieldName" : "displaytitle",
			"type" : "boolean",
			"tooltip" : ""
		}, {
			"placeHolder" : "Defaults to map name",
			"label" : "Title Text:",
			"fieldName" : "title",
			"type" : "string",
			"tooltip" : ""
		}, {
			"placeHolder" : "URL to image",
			"label" : "Logo on map:",
			"fieldName" : "customlogoimage",
			"type" : "string",
			"tooltip" : "Url for image"
		}, {
			"placeHolder" : "URL to image",
			"label" : "Logo on top banner:",
			"fieldName" : "toplogoimage",
			"type" : "string",
			"tooltip" : "Url for image"
		}, {
			"placeHolder" : "link to site",
			"label" : "Link on logo on top banner:",
			"fieldName" : "toplogolink",
			"type" : "string",
			"tooltip" : "link to other site"
		}, {
			"placeHolder" : "facebook link",
			"label" : "Link to facebook:",
			"fieldName" : "facebooklink",
			"type" : "string",
			"tooltip" : "link to your facebook site"
		}, {
			"placeHolder" : "twitter link",
			"label" : "Link to twitter:",
			"fieldName" : "twitterlink",
			"type" : "string",
			"tooltip" : "link to your twitter"
		}, {
			"label" : "Include Overview Map",
			"fieldName" : "displayoverviewmap",
			"type" : "boolean",
			"tooltip" : ""
		}, {
			"type" : "string",
			"fieldName" : "sourceCountry",
			"label" : "Locator Source Country",
			"tooltip" : "Locator Source Country",
			"placeHolder" : ""
		}, {
			"type" : "paragraph",
			"value" : "A value representing the country. Providing this value increases geocoding speed. Country code list: <a href='http://resources.arcgis.com/en/help/arcgis-rest-api/#/Service_coverage/02r300000018000000/' target='_blank'>here</a>"
		}]
	}, {
		"category" : "<b>Menu Items</b>",
		"fields" : [{
			"label" : "Legend *",
			"fieldName" : "displaylegend",
			"type" : "boolean",
			"tooltip" : ""
		},{
			"label" : "Hide layers from TOC *",
			"fieldName" : "showLegendToTOC",
			"type" : "boolean",
			"tooltip" : "Hide layers from TOC which are also hidden from legend (defined in web map layer right click menu)"
		}, {
			"label" : "Show legend in TOC when toc level is higher than 0 *",
			"fieldName" : "legendInLayers",
			"type" : "boolean",
			"tooltip" : ""
		}, {
			"label" : "Details *",
			"fieldName" : "displaydetails",
			"type" : "boolean",
			"tooltip" : ""
		}, {
			"label" : "Editor *",
			"fieldName" : "displayeditor",
			"type" : "boolean",
			"tooltip" : "Display editor if web map contains feature service layer"
		}, {
			"label" : "Time Slider *",
			"fieldName" : "displaytimeslider",
			"type" : "boolean",
			"tooltip" : "Display time slider for time enabled web map"
		}, {
			"label" : "Print",
			"fieldName" : "displayprint",
			"type" : "boolean",
			"tooltip" : ""
		}, {
			"label" : "Layer List *",
			"fieldName" : "displaylayerlist",
			"type" : "boolean",
			"tooltip" : ""
		}, {
			"label" : "Basemaps",
			"fieldName" : "displaybasemaps",
			"type" : "boolean",
			"tooltip" : ""
		}, {
			"label" : "Bookmarks",
			"fieldName" : "displaybookmarks",
			"type" : "boolean",
			"tooltip" : "Display the read-only bookmarks contained in the web map."
		}, {
			"label" : "Measure",
			"fieldName" : "displaymeasure",
			"type" : "boolean",
			"tooltip" : ""
		}, {
			"label" : "Elevation",
			"fieldName" : "displayelevation",
			"type" : "boolean",
			"tooltip" : "Dispay an elevation profile. Note that the measure tool must be active for this tool to work."
		}, {
			"label" : "Show elevation difference",
			"fieldName" : "showelevationdifference",
			"tooltip" : "When true elevation gain loss is shown from the first location to the location under the cursor/finger."
		}, {
			"label" : "Share",
			"fieldName" : "displayshare",
			"type" : "boolean",
			"tooltip" : ""
		}, {
			"label" : "Search",
			"fieldName" : "displaysearch",
			"type" : "boolean",
			"tooltip" : ""
		}, {
			"label" : "TOC level",
			"fieldName" : "tocLevel",
			"type" : "number",
			"title" : "Drill toc level - defaults to 0 - map service level",
			"constraints" : {
				"min" : "0",
				"places" : "0"
			}
		}, {
			"value" : "* These menu items will appear in the application when the web map has layers that require them.",
			"type" : "paragraph"
		}]
	}, {
		"category" : "<b>Time slider settings</b>",
		"fields" : [{
			"type" : "boolean",
			"fieldName" : "keepTime",
			"label" : "Keep Time Extent Enabled",
			"title" : "Keep time enabled when closing time slider"
		}, {
			"type" : "number",
			"placeHolder" : "2000",
			"fieldName" : "timeslidertmbrate",
			"label" : "Thumb moving rate",
			"title" : "",
			"constraints" : {
				"min" : "0",
				"places" : "0"
			}
		}, {
			"type" : "number",
			"placeHolder" : "Calculated",
			"fieldName" : "numberofstops",
			"label" : "Number of stops",
			"title" : "",
			"constraints" : {
				"min" : "0",
				"places" : "0"
			}
		}, {
			"type" : "string",
			"fieldName" : "ts_timestopinterval",
			"label" : "Time stop interval",
			"tooltip" : "Intervals between time stops"
		}, {
			"type" : "boolean",
			"fieldName" : "timeslidersingleinstant",
			"label" : "Single Time Instant Data:",
			"title" : ""
		}, {
			"type" : "options",
			"fieldName" : "timeslidertmbcount",
			"tooltip" : "",
			"label" : "Time slider thumb count:",
			"options" : [{
				"label" : "One",
				"value" : "1"
			}, {
				"label" : "Two",
				"value" : "2"
			}]
		}, {
			"value" : "Time settings only apply when web map has layers with temporal data.",
			"type" : "paragraph"
		}, {
			"type" : "boolean",
			"fieldName" : "ts_latestData",
			"label" : "Show latest data",
			"tooltip" : "Position thumb on latest data in time extent"
		}, {
			"type" : "number",
			"placeHolder" : "0",
			"fieldName" : "timesliderdateoffset",
			"label" : "End date offset",
			"title" : "",
			"constraints" : {
				"min" : "0",
				"places" : "0"
			}
		}, {
			"value" : "End date offset removes the given number of date ticks from time extent, starting from end date, when display latest day is selected",
			"type" : "paragraph"
		}, {
			"type" : "string",
			"fieldName" : "ts_datePattern",
			"label" : "Date pattern",
			"tooltip" : "Date pattern e.g. MMMM yyyy"
		}, {
			"type" : "paragraph",
			"value" : "Set date pattern to override the default pattern which is depending on time slider unit. Supported values: <a href='http://dojotoolkit.org/reference-guide/1.7/dojo/date/locale/format.html'>http://dojotoolkit.org...</a>"
		}]
	}, {
		"category" : "<b>Pop-up value settings</b>",
		"fields" : [{
			"type" : "boolean",
			"fieldName" : "hideEmptyValues",
			"label" : "Hide field in pop-up if the value is empty"
		}, {
			"type" : "string",
			"fieldName" : "excludeValues",
			"label" : "Commaseparated list of values to exclude in pop-up"
		}]
	}]
}