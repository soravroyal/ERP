using System;
using System.Web.Compilation;
using System.Web;
using System.Diagnostics;
using System.Globalization;

namespace EPRTR.ResourceProviders
{
    /// <summary>
    /// ResourceProvider factory for DB resources.
    /// </summary>
    public class DBResourceProviderFactory : ResourceProviderFactory
    {

        /// <summary>
        /// Creates a DBReourceProvider for global resources based on the classKey given.
        /// See http://msdn.microsoft.com/en-us/library/aa905797.aspx#exaspnet20rpm_topic5
        /// </summary>
        public override IResourceProvider CreateGlobalResourceProvider(string classKey)
        {
            //Debug.WriteLine(String.Format(CultureInfo.InvariantCulture, "DBResourceProviderFactory.CreateGlobalResourceProvider({0})", classKey));
            return new DBResourceProvider(classKey); 
        }

        /// <summary>
        /// Creates a DBReourceProvider for local resources based on the virtual path given.
        /// local resources are stored using a classKey that represents the relative path of the page, without the application directory
        /// </summary>
        /// <param name="virtualPath"></param>
        /// <returns></returns>
        public override IResourceProvider CreateLocalResourceProvider(string virtualPath)
        {
            //Debug.WriteLine(String.Format(CultureInfo.InvariantCulture, "DBResourceProviderFactory.CreateLocalResourceProvider({0}", virtualPath));

            // we should always get a path from the runtime
            //TODO Virtual path might need to be calculated differently to work for both review website and public website?
            string classKey = virtualPath;


            if (!string.IsNullOrEmpty(virtualPath) && !VirtualPathUtility.IsAppRelative(virtualPath))
            {
                virtualPath = virtualPath.Remove(0, 1);
                classKey = virtualPath.Remove(0, virtualPath.IndexOf('/') + 1);
            }

            return new DBResourceProvider(classKey);
        }
    }
}