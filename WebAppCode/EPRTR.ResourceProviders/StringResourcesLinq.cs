using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Specialized;
using System.Globalization;
using System.Threading;
using System.Data;
using System.Runtime.Remoting.Contexts;
using System.Runtime.CompilerServices;
using System.Linq;
using EPRTR.ResourceProviders.Properties;
using System.Diagnostics;

namespace EPRTR.ResourceProviders
{
    /// <summary>
    /// Data access component for the StringResources table. 
    /// This type is thread safe.
    /// See http://msdn.microsoft.com/en-us/library/aa905797.aspx#exaspnet20rpm_topic5
    /// </summary>
    public class StringResourcesLinq: IDisposable
    {
        private string defaultResourceCulture = "en-GB"; //default language
        private string resourceType = "";

        /// <summary>
        /// Constructs this instance of the data access 
        /// component supplying a resource type for the instance. 
        /// </summary>
        /// <param name="resourceType">The resource type.</param>
        public StringResourcesLinq(string resourceType)
        {
            // save the resource type for this instance
            this.resourceType = resourceType;
        }

        /// <summary>
        /// Uses an open database connection to recurse looking for the resource.
        /// Retrieves a resource entry based on the specified culture and resource key. The resource type is based on this instance of the
        /// StringResourceDALC as passed to the constructor. Resource fallback follows the same mechanism 
        /// of the .NET ResourceManager. Ultimately falling back to the default resource
        /// specified in this class.
        /// </summary>
        /// <param name="culture">The culture to search with.</param>
        /// <param name="resourceKey">The resource key to find.</param>
        /// <returns>If found, the resource string is returned. Otherwise an empty string is returned.</returns>
        private string GetResourceByCultureAndKeyInternal(CultureInfo culture, string resourceKey)
        {
            Debug.WriteLine(String.Format("StringResourcesLinq.GetResourceByCultureAndKeyInternal({2} - {1}:{0})", resourceKey, this.resourceType, culture));
            
            // we should only get one back, but just in case, we'll iterate reader results
            StringCollection resources = new StringCollection();
            string resourceValue = null;


            // set up LINQ expression and get resource from database
            DBResourceDataClassesDataContext db = new DBResourceDataClassesDataContext();
            IEnumerable<StringResource> res = db.StringResources.Where(m => m.CultureCode.Equals(culture.Name) && m.ResourceKey.Equals(resourceKey) && m.ResourceType.Equals(this.resourceType));

            foreach (StringResource r in res)
            {
                resources.Add(r.ResourceValue);
            }

            // we should only get 1 back, this is just to verify the tables aren't incorrect
            if (resources.Count == 0)
            {
                // is this already fallback location?
                if (culture.Name == this.defaultResourceCulture)
                {
                    string debug = ConfigurationManager.AppSettings["DBResourceDebugMode"];

                    //if not debug the key is returned if no value was found. Otherwise an exeption is thrown
                    if (!string.IsNullOrEmpty(debug) && !Boolean.Parse(debug))
                    {
                        //TODO log error
                        resourceValue = string.Format("[{0}.{1}]", this.resourceType, resourceKey);
                    }
                    else
                    {
                        throw new InvalidOperationException(String.Format(Thread.CurrentThread.CurrentUICulture, Resource.RM_DefaultResourceNotFound, resourceKey));
                    }

                }
                else
                {
                    // try to get parent culture
                    culture = culture.Parent;
                    if (culture.Name.Length == 0)
                    {
                        // there isn't a parent culture, change to neutral
                        culture = new CultureInfo(this.defaultResourceCulture);
                    }
                    resourceValue = this.GetResourceByCultureAndKeyInternal(culture, resourceKey);
                }
            }
            else if (resources.Count == 1)
            {
                resourceValue = resources[0];
            }
            else
            {
                // if > 1 row returned, log an error, we shouldn't have > 1 value for a resourceKey!
                throw new DataException(String.Format(Thread.CurrentThread.CurrentUICulture, Resource.RM_DuplicateResourceFound, resourceKey));
            }

            return resourceValue;
        }

        /// <summary>
        /// Returns a dictionary type containing all resources for a particular resource type and culture.
        /// The resource type is based on this instance of the StringResourceDALC as passed to the constructor.
        /// </summary>
        /// <param name="culture">The culture to search for.</param>
        /// <param name="resourceKey">The resource key to 
        /// search for.</param>
        /// <returns>If found, the dictionary contains key/value pairs for each resource for the specified culture.</returns>
        [MethodImpl(MethodImplOptions.Synchronized)]
        public ListDictionary GetResourcesByCulture(CultureInfo culture)
        {
            Debug.WriteLine(String.Format("StringResourcesLinq.GetResourceByCulture({1}:{0})", culture.Name, this.resourceType));

            // make sure we have a default culture at least
            if (culture == null || culture.Name.Length == 0)
            {
                culture = new CultureInfo(this.defaultResourceCulture);
            }

            // create the dictionary
            ListDictionary resourceDictionary = new ListDictionary();

            // set up LINQ expression and get resource from database
            DBResourceDataClassesDataContext db = new DBResourceDataClassesDataContext();
            IEnumerable<StringResource> res = db.StringResources.Where(m => m.CultureCode.Equals(culture.Name) && m.ResourceType.Equals(this.resourceType));

            foreach (StringResource r in res)
            {
                string k = r.ResourceKey;
                string v = r.ResourceValue;

                resourceDictionary.Add(k, v);
            }

            return resourceDictionary;
        }

        /// <summary>
        /// Retrieves a resource entry based on the specified culture and 
        /// resource key. The resource type is based on this instance of the
        /// StringResourceDALC as passed to the constructor.
        /// To optimize performance, this function opens the database connection 
        /// before calling the internal recursive function. 
        /// </summary>
        /// <param name="culture">The culture to search with.</param>
        /// <param name="resourceKey">The resource key to find.</param>
        /// <returns>If found, the resource string is returned. Otherwise an empty string is returned.</returns>
        [MethodImpl(MethodImplOptions.Synchronized)]
        public string GetResourceByCultureAndKey(CultureInfo culture, string resourceKey)
        {
            string resourceValue = string.Empty;

            try
            {

                // make sure we have a default culture at least
                if (culture == null || culture.Name.Length == 0)
                {
                    culture = new CultureInfo(this.defaultResourceCulture);
                }

                resourceValue = this.GetResourceByCultureAndKeyInternal(culture, resourceKey);
            }
            finally
            {
            }
            return resourceValue;
        }

        #region IDisposable Members

            public void  Dispose()
            {
            }

        #endregion
    }

    public class ResourceRecord
    {
        public string ResourceType {get; set;}

        public string CultureCode {get; set;}

        public string ResourceKey{get; set;}

        public string ResourceValue{get; set;}
    }
}
