using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Drawing.Imaging;
using System.Drawing;

public partial class pngcreate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            Request.ValidateInput();
            string action = Request["action"];
            string filename = Request["filename"];
            
            if (String.IsNullOrEmpty(filename))
                filename = "image";
            
            if (!filename.ToLower().EndsWith(".png"))
                filename = filename + ".png";
            
            byte[] data = Convert.FromBase64String(Request["image"]);
            
            switch (action.ToLower())
            {
                case "save":
                    {
                        cleanUpOldImgs("./img/");
                        MemoryStream ms = new MemoryStream(data);                      
                        Bitmap png = new Bitmap(ms);
                        png.Save(Server.MapPath("./img/" + filename), ImageFormat.Png);
                        png.Dispose();                        
                        ms.Flush();
                        ms.Close();
                        break;
                    }
                default:
                    {
                        Response.ContentType = "application/png";
                        Response.AddHeader("Content-Length", data.Length.ToString());
                        Response.AddHeader("Content-disposition", "attachment; filename=" + filename);
                        Response.BinaryWrite(data);
                        break;
                    }
            }
            Response.Flush();
            Response.End();
        }
        catch(Exception ex) 
        {
            string s = ex.ToString();
        }
    }


    /// <summary>
    /// Delete img's more than 6 hours old
    /// </summary>
    private void cleanUpOldImgs(string folder)
    {
        DirectoryInfo dir = new DirectoryInfo(Server.MapPath(folder));
        FileInfo[] file_arr = dir.GetFiles();
        for (int i = 0; i < file_arr.Length; i++)
        {
            FileInfo fileInfo = file_arr[i];
            if (fileInfo.CreationTime < DateTime.Now.AddHours(-6) && fileInfo.Name.ToLower().EndsWith(".png"))        
            {
                try
                {
                    File.Delete(Server.MapPath(folder + fileInfo.Name));
                }
                catch { /*reach here if file is used by other process, just skip*/ }
            }
        }
    }

}
