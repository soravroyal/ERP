using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Configuration;
using System.Data;

namespace EPRTRcms
{
    public partial class FileCatalog : System.Web.UI.Page
    {
        protected void Page_PageLoad(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                StatusLabel.Visible = false;
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            // Get information about the files in the specified folder
            var folder = new DirectoryInfo(GetUploadPath());
            var fileList = folder.GetFiles();

            List<FileDataRow> customFileList = new List<FileDataRow>();
            foreach (var f in fileList)
            {
                customFileList.Add(
                    new FileDataRow(f.Name, f.Extension, f.Length,
                        f.LastWriteTime, f.IsReadOnly, GetUploadVirtualDirectoryName()));
            }

            DataListFiles.DataSource = customFileList;
            DataListFiles.DataBind();
        }

        protected void UploadButton_Click(object sender, EventArgs e)
        {
            if (FileUploadControl.HasFile)
            {
                try
                {
                    string filename = Path.GetFileName(FileUploadControl.FileName);
                    StatusLabel.Visible = true;
                    FileUploadControl.SaveAs(GetUploadPath() + filename);
                    
                    StatusLabel.Text = "Upload status: Files has been uploaded.";
                    StatusLabel.ForeColor = System.Drawing.Color.Black;

                }
                catch (Exception ex)
                {
                    // remove physical file path from message
                    string modifiedMessage = ex.Message.Replace(GetUploadPath(), String.Concat(GetUploadVirtualDirectoryName(), "/"));

                    StatusLabel.Text = String.Format("Upload status: The file could not be uploaded. The following error occured: {0}", modifiedMessage);
                    StatusLabel.ForeColor = System.Drawing.Color.Red;
                }
            }
        }

        protected string GetHrefURL(object obj)
        {
            FileDataRow file = (FileDataRow)obj;
            return file.RelativePath;
        }

        protected string GetUploadPath()
        {
            return (string)ConfigurationManager.AppSettings["FileUploadPath"];
        }

        protected string GetUploadVirtualDirectoryName()
        {
            return (string)ConfigurationManager.AppSettings["FileUploadVirtualDirectoryName"];
        }

        public class FileDataRow
        {
            public string Name { get; set; }
            public string Extension { get; set; }
            public long Size { get; set; }
            public DateTime ModifiedDate { get; set; }
            public bool IsReadOnly { get; set; }
            public string RelativePath { get; set; }


            public FileDataRow(
                string name, string extension, long size, DateTime modifiedDate,
                bool isReadOnly, string VirtualDirectoryName)
            {
                Name = name;
                Extension = extension;
                Size = size;
                ModifiedDate = modifiedDate;
                IsReadOnly = isReadOnly;

                RelativePath = VirtualDirectoryName + "/" + Name;

            }
        }
    }
}
