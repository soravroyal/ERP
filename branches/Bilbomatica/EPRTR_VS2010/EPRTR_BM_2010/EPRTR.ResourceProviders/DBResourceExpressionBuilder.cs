using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;
using System.Globalization;
using System.Web.Compilation;
using System.Threading;
using System.CodeDom;
using System.Web.UI;

namespace EPRTR.ResourceProviders
{
    /// <summary>
    /// Custom expression builder support for $DBResources expressions.
    /// See http://msdn.microsoft.com/en-us/library/aa905797.aspx#exaspnet20rpm_topic5
    /// </summary>
    public class DBResourceExpressionBuilder : ResourceExpressionBuilder
    {
        private static ResourceProviderFactory s_resourceProviderFactory;

        public DBResourceExpressionBuilder():base()
        {
            Debug.WriteLine("DBResourceExpressionBuilder");

        }

        /// <summary>
        /// Helper method that instantiates the GlobalDBResourceProvider and retrieves the resource entry
        /// </summary>
        public static object GetGlobalResourceObject(string classKey, string resourceKey)
        {
            Debug.WriteLine(String.Format(CultureInfo.InvariantCulture, "DBResourceExpressionBuilder.GetGlobalResourceObject({0}, {1})", classKey, resourceKey));

            return DBResourceExpressionBuilder.GetGlobalResourceObject(classKey, resourceKey, null);
        }

        /// <summary>
        /// Helper method that instantiates the GlobalDBResourceProvider and retrieves the resource entry
        /// </summary>
        public static object GetGlobalResourceObject(string classKey, string resourceKey, CultureInfo culture)
        {
            Debug.WriteLine(String.Format(CultureInfo.InvariantCulture, "DBResourceExpressionBuilder.GetGlobalResourceObject({0}, {1}, {2})", classKey, resourceKey, culture));

            DBResourceExpressionBuilder.EnsureResourceProviderFactory();
            IResourceProvider provider = DBResourceExpressionBuilder.s_resourceProviderFactory.CreateGlobalResourceProvider(classKey);
            return provider.GetObject(resourceKey, culture);
        }


        /// <summary>
        /// Helper method that instantiates the LocalDBResourceProvider and retrieves the resource entry
        /// </summary>
        public static object GetLocalResourceObject(string classKey, string resourceKey)
        {
            Debug.WriteLine(String.Format(CultureInfo.InvariantCulture, "DBResourceExpressionBuilder.GetGlobalResourceObject({0}, {1})", classKey, resourceKey));

            return DBResourceExpressionBuilder.GetLocalResourceObject(classKey, resourceKey, null);
        }

        /// <summary>
        /// Helper method that instantiates the LocalDBResourceProvider and retrieves the resource entry
        /// </summary>
        public static object GetLocalResourceObject(string classKey, string resourceKey, CultureInfo culture)
        {
            Debug.WriteLine(String.Format(CultureInfo.InvariantCulture, "DBResourceExpressionBuilder.GetGlobalResourceObject({0}, {1}, {2})", classKey, resourceKey, culture));

            DBResourceExpressionBuilder.EnsureResourceProviderFactory();
            IResourceProvider provider = DBResourceExpressionBuilder.s_resourceProviderFactory.CreateLocalResourceProvider(classKey);
            return provider.GetObject(resourceKey, culture);
        }
        
        /// <summary>
        /// Returns the resource value for an ExternalResource expression in non-compiled pages
        /// NB! For non-compiled pages, expressions are evaluated at run time.
        /// </summary>
        public override object EvaluateExpression(object target, BoundPropertyEntry entry, object parsedData, ExpressionBuilderContext context)
        {
            Debug.WriteLine(String.Format(CultureInfo.InvariantCulture, "DBResourceExpressionBuilder.EvaluateExpression({0}, {1}, {2}, {3})", target, entry, parsedData, context));

            DBResourceExpressionFields fields = parsedData as DBResourceExpressionFields;

            DBResourceExpressionBuilder.EnsureResourceProviderFactory();
            IResourceProvider provider = DBResourceExpressionBuilder.s_resourceProviderFactory.CreateGlobalResourceProvider(fields.ClassKey);

            return provider.GetObject(fields.ResourceKey, null);
        }


        /// <summary>
        /// Returns the code to be emitted for an DBResource expression. This code will invoke the custom resource provider, GlobalDBResourceProvider.
        /// NB! Called at runtime
        /// </summary>
        /// <returns></returns>
        public override System.CodeDom.CodeExpression GetCodeExpression(BoundPropertyEntry entry, object parsedData, ExpressionBuilderContext context)
        {
            Debug.WriteLine(String.Format(CultureInfo.InvariantCulture, "DBResourceExpressionBuilder.GetCodeExpression({0}, {1}, {2})", entry, parsedData, context));

            DBResourceExpressionFields fields = parsedData as DBResourceExpressionFields;

            CodeMethodInvokeExpression exp = new CodeMethodInvokeExpression(new CodeTypeReferenceExpression(typeof(DBResourceExpressionBuilder)), "GetGlobalResourceObject", new CodePrimitiveExpression(fields.ClassKey), new CodePrimitiveExpression(fields.ResourceKey));

            return exp;
        }

        /// <summary>
        /// Validates an DBResource expression by attempting to access resources for the expression. Page parsing will fail if the resource cannot be found.
        /// NB! Expressions are parsed at design time, and prior to compilation
        /// TODO HES Skip DB look-up to avoid DB access to be required 
        /// </summary>
        public override object ParseExpression(string expression, Type propertyType, ExpressionBuilderContext context)
        {
            Debug.WriteLine(String.Format(CultureInfo.InvariantCulture, "DBResourceExpressionBuilder.ParseExpression({0}, {1}, {2})", expression, propertyType, context));

            if (string.IsNullOrEmpty(expression))
            {
                throw new ArgumentException(String.Format(Thread.CurrentThread.CurrentUICulture, Properties.Resource.Expression_TooFewParameters, expression));
            }

            DBResourceExpressionFields fields = null;
            string classKey = null;
            string resourceKey = null;

            string[] expParams = expression.Split(new char[] { ',' });
            if (expParams.Length > 2)
            {
                throw new ArgumentException(String.Format(Thread.CurrentThread.CurrentUICulture, Properties.Resource.Expression_TooManyParameters, expression));
            }
            if (expParams.Length == 1)
            {
                classKey = context.VirtualPath;

                string vp = context.VirtualPath.Remove(0, 1);
                classKey = vp.Remove(0, vp.IndexOf('/') + 1); 
                resourceKey = expParams[0].Trim();
                //throw new ArgumentException(String.Format(Thread.CurrentThread.CurrentUICulture, Properties.Resource.Expression_TooFewParameters, expression));
            }
            else
            {
                classKey = expParams[0].Trim();
                resourceKey = expParams[1].Trim();
            }

            fields = new DBResourceExpressionFields(classKey, resourceKey);

            DBResourceExpressionBuilder.EnsureResourceProviderFactory();
            IResourceProvider rp = DBResourceExpressionBuilder.s_resourceProviderFactory.CreateGlobalResourceProvider(fields.ClassKey);

            object res = rp.GetObject(fields.ResourceKey, CultureInfo.InvariantCulture);
            if (res == null)
            {
                throw new ArgumentException(String.Format(Thread.CurrentThread.CurrentUICulture, Properties.Resource.RM_ResourceNotFound, fields.ResourceKey));
            }
            return fields;
        }


        private static void EnsureResourceProviderFactory()
        {
            if (DBResourceExpressionBuilder.s_resourceProviderFactory == null)
            {
                DBResourceExpressionBuilder.s_resourceProviderFactory = new DBResourceProviderFactory();
            }
        }


        /// <summary>
        /// Indicates if non-compiled page evaluation is supported. In this implementation, returns true.
        /// </summary>
        public override bool SupportsEvaluate
        {
            get
            {
                Debug.WriteLine("DBResourceExpressionBuilder.SupportsEvaluate");
                return true;
            }
        }

    }

        public class DBResourceExpressionFields
        {
            internal DBResourceExpressionFields(string classKey, string resourceKey)
            {
                this.m_classKey = classKey;
                this.m_resourceKey = resourceKey;
            }

            public string ClassKey
            {
                get
                {
                    return this.m_classKey;
                }
            }

            public string ResourceKey
            {
                get
                {
                    return this.m_resourceKey;
                }
            }

            private string m_classKey;
            private string m_resourceKey;


        }

    
}
