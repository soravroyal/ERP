using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EPRTR.Localization
{
    /// <summary>
    /// Helper class to receive resources
    /// </summary>
    public static class Resources
    {

        /// <summary>
        /// Return a global resource
        /// </summary>
        /// <param name="resourceType">The resource type</param>
        /// <param name="resourceKey">The key to look up</param>
        /// <returns></returns>
        public static string GetGlobal(string resourceType, string resourceKey)
        {
            return HttpContext.GetGlobalResourceObject(resourceType, resourceKey) as string;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="resourceType">The virtual path</param>
        /// <param name="resourceKey">The key to look up</param>
        /// <returns></returns>
        public static string GetLocal(string virtualPath, string resourceKey)
        {
            return HttpContext.GetLocalResourceObject(virtualPath, resourceKey) as string;
        }

    }
}