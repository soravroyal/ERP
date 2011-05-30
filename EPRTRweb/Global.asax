<%@ Application Language="C#" %>
<%@ Import Namespace="EPRTR.Localization" %>
<%@ Import Namespace="Microsoft.Practices.EnterpriseLibrary.Logging" %>

<script runat="server">

    void Application_Start(object sender, EventArgs e) 
    {
      // Code that runs on application startup
        //Used for ResourceProvidersCache Dependency
        System.Data.SqlClient.SqlDependency.Start(ConfigurationManager.ConnectionStrings["QueryLayer.Properties.Settings.EPRTRresourceConnectionString"].ConnectionString);

        Microsoft.Practices.EnterpriseLibrary.Logging.LogEntry enlog = new LogEntry();
        enlog.EventId = 100;
        enlog.Message = String.Format("Application started");
        enlog.Severity = System.Diagnostics.TraceEventType.Information;
        enlog.Priority = 1;
        Logger.Write(enlog);
    }
    
    void Application_End(object sender, EventArgs e) 
    {
        //  Code that runs on application shutdown
        //Used for ResourceProvidersCache Dependency
        System.Data.SqlClient.SqlDependency.Stop(ConfigurationManager.ConnectionStrings["QueryLayer.Properties.Settings.EPRTRresourceConnectionString"].ConnectionString);
        Microsoft.Practices.EnterpriseLibrary.Logging.LogEntry enlog = new LogEntry();
        enlog.EventId = 101;
        enlog.Message = String.Format("Application stopped");
        enlog.Severity = System.Diagnostics.TraceEventType.Information;
        enlog.Priority = 1;
        Logger.Write(enlog);
    }
  
    void Application_Error(object sender, EventArgs e) 
    {
        bool enableErrorLog = ConfigurationManager.AppSettings["EnableEventErrorLog"].ToString().ToLower().Equals("true");
        if (enableErrorLog)
      
        {
          // Log error to the Event Log
          if (HttpContext.Current.Server.GetLastError() != null)
          {
              string errMessage = "";
              Exception exception = Server.GetLastError();
              errMessage = "Message:\r\n" + exception.Message + "\r\n\r\n";
              errMessage += "Source:\r\n" + exception.Source + "\r\n\r\n";
              errMessage += "Target site:\r\n" + exception.TargetSite.ToString() + "\r\n\r\n";
              errMessage += "Stack trace:\r\n" + exception.StackTrace + "\r\n\r\n";

              if (exception.InnerException != null)
                  errMessage += "InnerException:\r\n" + exception.StackTrace + "\r\n\r\n";

              
              Microsoft.Practices.EnterpriseLibrary.Logging.LogEntry enlog = new LogEntry();
              enlog.EventId = 999;
              enlog.Message = errMessage;
              enlog.Severity = System.Diagnostics.TraceEventType.Error;
              enlog.Priority = 1;
              Logger.Write(enlog);

              //HttpContext.Current.Server.ClearError();
              //HttpContext.Current.Request.

              //HttpContext.Current.Server.Transfer(Request.Url.ToString());
              
            //string eventLog = "WebEPRTR";
            ////string eventSource = "www.eprtr.ec.europa.eu";
            //string eventSource = "WebEPRTR";
            //string errMessage = "";

            //Exception exception = Server.GetLastError();
            //errMessage = "Message:\r\n" + exception.Message + "\r\n\r\n";
            //errMessage += "Source:\r\n" + exception.Source + "\r\n\r\n";
            //errMessage += "Target site:\r\n" + exception.TargetSite.ToString() + "\r\n\r\n";
            //errMessage += "Stack trace:\r\n" + exception.StackTrace + "\r\n\r\n";

            //if (exception.InnerException != null)
            //  errMessage += "InnerException:\r\n" + exception.StackTrace + "\r\n\r\n";

            //// make sure the Eventlog Exists
            //if (!System.Diagnostics.EventLog.SourceExists(eventSource))
            //  System.Diagnostics.EventLog.CreateEventSource(eventSource, eventLog);

            //// make new log
            //System.Diagnostics.EventLog log = new System.Diagnostics.EventLog(eventLog);
            //log.Source = eventSource;
            //log.WriteEntry("ERROR: " + eventSource + "\r\n\r\n" + errMessage, System.Diagnostics.EventLogEntryType.Error);
          }
        }
        
        // display error page
      //HttpContext.Current.Server.Transfer("ErrorPage.aspx");

        
        HttpCookie reloads = Request.Cookies["Reloads"];
        if (reloads == null)
        {
            reloads = new HttpCookie("Reloads", "0");
        }

        int numberOfReloads = int.Parse(reloads.Value);

        if (numberOfReloads < 2)
        {
            reloads.Value = (numberOfReloads + 1).ToString();
            reloads.Expires = DateTime.Now.AddSeconds(10);
            Response.Cookies.Add(reloads);
            HttpContext.Current.Server.ClearError();

            //Response.AddHeader("REFRESH", "1;URL=" + Request.Url.AbsolutePath);
            Response.Redirect(Request.Url.AbsolutePath);
        }


    }

    void Application_BeginRequest(object sender, EventArgs e)
    {
    }

    void Session_Start(object sender, EventArgs e) 
    {
        // Code that runs when a new session is started
    }

    void Session_End(object sender, EventArgs e) 
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.
    }
       
</script>
