using System;
using System.Collections.Generic;
using System.Text;

namespace SPPerformanceTester
{
    public sealed class ServiceLocator
    {
        private Dictionary<Type, object> services = new Dictionary<Type, object>();

        private ServiceLocator()
        {
        }

        public static ServiceLocator Instance
        {
            get { return ServiceLocatorHolder.instance; }
        }

        class ServiceLocatorHolder
        {
            static ServiceLocatorHolder()
            {
            }
            internal static readonly ServiceLocator instance = new ServiceLocator();
        }

        public void AddService(Type type, object implementation)
        {
            if (implementation == null)
                throw new ArgumentNullException("The implementation can not be null!");
            if (this.services.ContainsKey(type))
                throw new ArgumentException("The requested type is already in the ServiceLocator.");
            Type implementationType = implementation.GetType();
            Type[] myInterfaces = implementation.GetType().FindInterfaces(MyInterfaceFilter, type.FullName);
            if (myInterfaces == null || myInterfaces.Length == 0)
                throw new ArgumentException("The type does not match the interface.");
            this.services.Add(type, implementation);
        }
        private static bool MyInterfaceFilter(Type typeObj, Object criteriaObj)
        {
            if (typeObj.ToString() == criteriaObj.ToString())
                return true;
            else
                return false;
        }
        public object GetService(Type type)
        {
            if (!this.services.ContainsKey(type))
                throw new ArgumentException("The requested type does not exist.");
            return this.services[type];
        }
        public void RemoveService(Type type)
        {
            if (!this.services.ContainsKey(type))
                throw new ArgumentException("The requested type does not exist.");
            this.services.Remove(type);

        }
    }

}
