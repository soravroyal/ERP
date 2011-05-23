using System;
using System.Web.Compilation;
using System.Resources;
using System.Reflection;
using System.Globalization;
using System.Collections.Generic;
using System.Collections;
using System.Diagnostics;
using System.Collections.Specialized;

namespace EPRTR.ResourceProviders
{
    /// <summary>
    /// Resource provider accessing resources from the database.
    /// This type is thread safe.
    /// See http://msdn.microsoft.com/en-us/library/aa905797.aspx#exaspnet20rpm_topic5
    /// </summary>
    public class DBResourceProvider : DisposableBaseType, IResourceProvider
    {
        
        /// <summary>
        /// Keep track of the 'className' passed by ASP.NET
        /// which is the ResourceType in the database.
        /// </summary>
        private string classKey;
        private StringResourcesLinq dalc;

        // resource cache
        private Dictionary<string, Dictionary<string, string>> resourceCache = new Dictionary<string, Dictionary<string, string>>();

        /// <summary>
        /// Constructs this instance of the provider 
        /// supplying a resource type for the instance. 
        /// </summary>
        /// <param name="resourceType">The resource type.</param>
        public DBResourceProvider(string classKey)
        {
            //Debug.WriteLine(String.Format(CultureInfo.InvariantCulture, "DBResourceProvider.DBResourceProvider({0}", classKey));

            this.classKey = classKey;
            this.dalc = new StringResourcesLinq(classKey);

        }

        #region IResourceProvider Members

        /// <summary>
        /// Retrieves a resource entry based on the specified culture and resource key. The resource type is based on this instance of the
        /// DBResourceProvider as passed to the constructor. To optimize performance, this function caches values in a dictionary per culture.
        /// </summary>
        /// <param name="resourceKey">The resource key to find.</param>
        /// <param name="culture">The culture to search with.</param>
        /// <returns>If found, the resource string is returned. Otherwise an empty string is returned.</returns>
        public object GetObject(string resourceKey, System.Globalization.CultureInfo culture)
        {

            if (Disposed)
            {
                throw new ObjectDisposedException("DBResourceProvider object is already disposed.");
            }

            if (string.IsNullOrEmpty(resourceKey))
            {
                throw new ArgumentNullException("resourceKey");
            }
            
            if (culture == null)
            {
                culture = CultureInfo.CurrentUICulture;
            }
            

            string resourceValue = null;

            // check the cache first
            resourceValue = findInCache(resourceKey, culture);
            
            // if not in the cache, go to the database
            if (resourceValue == null)
            {
                lock (this)
                {

                    // cache was empty before we got the lock, check again inside the lock    

                    resourceValue = findInCache(resourceKey, culture);

                    // cache is still empty, so retreive the value here and store in cache
                    if (resourceValue == null)
                    {
                        resourceValue = this.dalc.GetResourceByCultureAndKey(culture, resourceKey);
                        saveInCache(resourceKey, resourceValue, culture);
                    }
                }
            }
            return resourceValue;
        }

        //finds value in cache
        // find the dictionary for this culture
        // check for the inner dictionary entry for this key
        private string findInCache(string resourceKey, System.Globalization.CultureInfo culture)
        {
            string resourceValue = null;
            if (this.resourceCache.ContainsKey(culture.Name))
            {
                Dictionary<string, string> resCacheByCulture = this.resourceCache[culture.Name];
                if (resCacheByCulture.ContainsKey(resourceKey))
                {
                    resourceValue = resCacheByCulture[resourceKey];
                }
            }
            return resourceValue;
        }

        //saves value in cache
        private void saveInCache(string resourceKey, string resourceValue, System.Globalization.CultureInfo culture)
        {
            Dictionary<string, string> resCacheByCulture = null; 
            
            if (this.resourceCache.ContainsKey(culture.Name))
            {
                resCacheByCulture = this.resourceCache[culture.Name];
            } 
            else
            {
                resCacheByCulture = new Dictionary<string, string>();
                this.resourceCache.Add(culture.Name, resCacheByCulture);
            }
            resCacheByCulture.Add(resourceKey, resourceValue);

        }

        /// <summary>
        /// Returns a resource reader.
        /// </summary>
        public System.Resources.IResourceReader ResourceReader
        {
            get
            {
                //Debug.WriteLine(String.Format(CultureInfo.InvariantCulture, "DBResourceProvider.get_ResourceReader - type:{0}", this.m_classKey));

                if (Disposed)
                {
                    throw new ObjectDisposedException("DBResourceProvider object is already disposed.");
                }

                // this is required for implicit resources 
                // this is also used for the expression editor sheet 

                ListDictionary resourceDictionary = this.dalc.GetResourcesByCulture(CultureInfo.InvariantCulture);

                return new DBResourceReader(resourceDictionary);
            }

        }

        #endregion

        protected override void Cleanup()
        {
            try
            {
                this.dalc.Dispose();
                this.resourceCache.Clear();
            }
            finally
            {
                base.Cleanup();
            }
        }

    }
}