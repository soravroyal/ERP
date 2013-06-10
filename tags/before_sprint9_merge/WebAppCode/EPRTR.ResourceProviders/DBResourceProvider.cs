using System;
using System.Web.Compilation;
using System.Resources;
using System.Reflection;
using System.Globalization;
using System.Collections.Generic;
using System.Collections;
using System.Diagnostics;
using System.Collections.Specialized;
using System.Configuration;
using System.Web.Configuration;

namespace EPRTR.ResourceProviders
{
    /// <summary>
    /// Resource provider accessing resources from the database.
    /// This type is thread safe.
    /// See http://msdn.microsoft.com/en-us/library/aa905797.aspx#exaspnet20rpm_topic5
    /// </summary>
    public class DBResourceProvider : DisposableBaseType, IResourceProvider, IImplicitResourceProvider 
    {
        
        /// <summary>
        /// Keep track of the 'className' passed by ASP.NET
        /// which is the ResourceType in the database.
        /// </summary>
        private string classKey;
        private StringResourcesLinq dalc;

        // resource cache
        private IDictionary resourceCache;

        private CultureInfo defaultCulture = CultureInfo.GetCultureInfo("en-GB");

        /// <summary>
        /// Constructs this instance of the provider 
        /// supplying a resource type for the instance. 
        /// </summary>
        /// <param name="resourceType">The resource type.</param>
        public DBResourceProvider(string classKey)
        {
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
                culture = CultureInfo.CurrentUICulture;

            return this.getObjectInternal(resourceKey, culture);

        }

        /// <summary>
        /// Manages caching of the Resource Sets. Once loaded the values are loaded from the
        /// cache only.
        /// </summary>
        /// <param name="cultureName"></param>
        /// <returns></returns>
        private IDictionary getResourceCache(string cultureName)
        {

            if (cultureName == null)
            {
                cultureName = "";
            }

            if (this.resourceCache == null)
            {
                this.resourceCache = this.dalc.GetResources(); // new ListDictionary();
            }

            IDictionary resources = this.resourceCache[cultureName] as IDictionary;

            //if (resources == null)
            //{
            //    resources = this.dalc.GetResourcesByCulture(cultureName);
            //    this.resourceCache[cultureName] = resources;
            //}

            return resources;
        }


        /// <summary>
        /// Internal lookup method that handles retrieving a resource
        /// by its resource id and culture. 
        /// </summary>
        /// <param name="ResourceKey"></param>
        /// <param name="CultureName"></param>
        /// <returns></returns>

        private object getObjectInternal(string resourceKey, CultureInfo culture)
        {
            if (culture == null)
            {
                culture = CultureInfo.InvariantCulture;
            }

            IDictionary Resources = this.getResourceCache(culture.Name);

            object value = null;

            if (Resources == null)
                value = null;
            else
                value = Resources[resourceKey];


            // *** If we're at a specific culture (en-Us) and there's no value fall back
            // *** to the generic culture (en)
            //if (value == null && cultureName.Length > 3)
            //{
            //    // *** try again with the 2 letter locale
            //    return GetObjectInternal(resourceKey, cultureName.Substring(0, 2));
            //}

            if (value == null && !string.IsNullOrEmpty(culture.Name))
            {
                // *** try again with fall back culture
                return getObjectInternal(resourceKey, culture.Parent);
            }

            // *** If the value is still null get the default value
            if (value == null)
            {
                Resources = this.getResourceCache(defaultCulture.Name);
                if (Resources == null)
                    value = null;
                else
                    value = Resources[resourceKey];
            }


            // *** If the value is still null and we're at the invariant culture
            // *** let's add a marker that the value is missing
            // *** this also allows the pre-compiler to work and never return null

            if (value == null && string.IsNullOrEmpty(culture.Name))
            {
                // *** No entry there
                value = string.Format("[{0}.{1}]", this.classKey, resourceKey);
            }

            return value;

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
                return new DBResourceReader(this.getResourceCache(CultureInfo.InvariantCulture.Name));
            }

        }



        #endregion


        #region IImplicitResourceProvider Members

        /// <summary>
        /// Called when an ASP.NET Page is compiled asking for a collection
        /// of keys that match a given control name (keyPrefix). This
        /// routine for example returns control.Text,control.ToolTip from the
        /// Resource collection if they exist when a request for "control"
        /// is made as the key prefix.
        /// </summary>
        /// <param name="keyPrefix"></param>
        /// <returns></returns>

        public ICollection GetImplicitResourceKeys(string keyPrefix)
        {
            List<ImplicitResourceKey> keys = new List<ImplicitResourceKey>();

            IDictionaryEnumerator Enumerator = this.ResourceReader.GetEnumerator();

            if (Enumerator == null)
                return keys; // Cannot return null!

            foreach (DictionaryEntry dictentry in this.ResourceReader)
            {
                string key = (string)dictentry.Key;

                if (key.StartsWith(keyPrefix + ".", StringComparison.InvariantCultureIgnoreCase) == true)
                {
                    string keyproperty = String.Empty;

                    if (key.Length > (keyPrefix.Length + 1))
                    {
                        int pos = key.IndexOf('.');
                        if ((pos > 0) && (pos == keyPrefix.Length))
                        {
                            keyproperty = key.Substring(pos + 1);
                            if (String.IsNullOrEmpty(keyproperty) == false)
                            {
                                //Debug.WriteLine("Adding Implicit Key: " + keyPrefix + " - " + keyproperty);

                                ImplicitResourceKey implicitkey = new ImplicitResourceKey(String.Empty, keyPrefix, keyproperty);
                                keys.Add(implicitkey);
                            }
                        }
                    }
                }

            }

            return keys;
        }



        /// <summary>
        /// Returns an Implicit key value from the ResourceSet.
        /// Note this method is called only if a ResourceKey was found in the
        /// ResourceSet at load time. If a resource cannot be located this
        /// method is never called to retrieve it. IOW, GetImplicitResourceKeys
        /// determines which keys are actually retrievable.
        ///
        /// This method simply parses the Implicit key and then retrieves
        /// the value using standard GetObject logic for the ResourceID.
        /// </summary>
        /// <param name="implicitKey"></param>
        /// <param name="culture"></param>
        /// <returns></returns>

        public object GetObject(ImplicitResourceKey implicitKey, CultureInfo culture)
        {
            string ResourceKey = ConstructFullKey(implicitKey);


            if (culture == null)
                culture = CultureInfo.CurrentUICulture;

            return this.getObjectInternal(ResourceKey, culture);

        }





        /// <summary>
        /// Routine that generates a full resource key string from
        /// an Implicit Resource Key value
        /// </summary>
        /// <param name="entry"></param>
        /// <returns></returns>

        private static string ConstructFullKey(ImplicitResourceKey entry)
        {
            string text = entry.KeyPrefix + "." + entry.Property;

            if (entry.Filter.Length > 0)
            {
                text = entry.Filter + ":" + text;
            }

            return text;
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