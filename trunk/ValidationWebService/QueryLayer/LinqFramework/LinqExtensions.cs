using System.Linq;
using System;
using System.Linq.Expressions;
using System.Collections.Generic;

namespace QueryLayer.LinqFramework
{


    /// <summary>
    /// Summary description for LinqExtensions
    /// </summary>

    public static class LinqExtensions
    {
        /// <summary>
        /// Perform custom paging using LINQ to SQL
        /// </summary>
        /// <typeparam name="T">Type of the Datasource to be paged</typeparam>
        /// <typeparam name="TResult"></typeparam>
        /// <param name="obj">Object to be paged through</param>
        /// <param name="page">Page Number to fetch</param>
        /// <param name="pageSize">Number of rows per page</param>
        /// <param name="keySelector">Sorting Expression</param>
        /// <param name="asc">Sort ascending if true. Otherwise descending</param>
        /// <param name="rowsCount">Output parameter hold total number of rows</param>
        /// <returns>Page of result from the paged object</returns>
        public static IQueryable<T> Page<T, TResult>(this IQueryable<T> obj, int page, int pageSize, System.Linq.Expressions.Expression<Func<T, TResult>> keySelector, bool asc, out int rowsCount)
        {
            rowsCount = obj.Count();
            int innerRows = rowsCount - (page * pageSize);
            if (asc)
                return obj.OrderByDescending(keySelector).Take(innerRows).OrderBy(keySelector).Take(pageSize).AsQueryable();
            else
                return obj.OrderBy(keySelector).Take(innerRows).OrderByDescending(keySelector).Take(pageSize).AsQueryable();
        }


        /// <summary>
        /// Dynamic order by
        /// </summary>
        public static IQueryable<TEntity> orderBy<TEntity>(this IQueryable<TEntity> source, string columnName, bool descending) where TEntity : class
        {
            return source.orderBy(new SortColumn(columnName, descending));

            //string command = (descending) ? "OrderByDescending" : "OrderBy";
            //var type = typeof(TEntity);

            //// get property according to column name
            //var property = type.GetProperty(columnName);

            //// create a new parameter
            //var parameter = Expression.Parameter(type, "p");

            //// create lambda with memberaccess
            //var propertyAccess = Expression.MakeMemberAccess(parameter, property);
            //var orderByExpression = Expression.Lambda(propertyAccess, parameter);

            //var resultExpression = Expression.Call(typeof(Queryable),
            //                                       command, // ascending/decending
            //                                       new Type[] { type, property.PropertyType },
            //                                       source.Expression,
            //                                       Expression.Quote(orderByExpression));

            //return source.Provider.CreateQuery<TEntity>(resultExpression);
        }


        /// <summary>
        /// Dynamic order by - then by. Orders by the columns given by the sortColumns.
        /// </summary>
        public static IQueryable<TEntity> orderBy<TEntity>(this IQueryable<TEntity> source, params SortColumn[]sortColumns) where TEntity : class
        {
            if (sortColumns == null || sortColumns.Count() == 0)
            {
                throw new ArgumentException("At least one SortColumn must be given", "sortColumns");
            }

            var type = typeof(TEntity);

            //First sort column = OrderBy

            // get property and sortorder according to first column name
            var property = type.GetProperty(sortColumns[0].ColumnName);
            string command = (sortColumns[0].Descending) ? "OrderByDescending" : "OrderBy";

            // create a new parameter
            var parameter = Expression.Parameter(type, "p");

            // create lambda with memberaccess
            var propertyAccess = Expression.MakeMemberAccess(parameter, property);
            var orderByExpression = Expression.Lambda(propertyAccess, parameter);

            var resultExpression = Expression.Call(typeof(Queryable),
                                                   command, // ascending/decending
                                                   new Type[] { type, property.PropertyType },
                                                   source.Expression,
                                                   Expression.Quote(orderByExpression));

            //next columns = ThenBy
            for (int i = 1; i < sortColumns.Count(); i++)
            {
                property = type.GetProperty(sortColumns[i].ColumnName);
                command = (sortColumns[i].Descending) ? "ThenByDescending" : "ThenBy";

                propertyAccess = Expression.MakeMemberAccess(parameter, property);
                var thenByExpression = Expression.Lambda(propertyAccess, parameter);

                resultExpression = Expression.Call(typeof(Queryable),
                                       command, 
                                       new Type[] { type, property.PropertyType },
                                       resultExpression,
                                       Expression.Quote(thenByExpression));
            }

            return source.Provider.CreateQuery<TEntity>(resultExpression);
        }

        /// <summary>
        /// Sums the values. If all values are null, null will be returned.
        /// Notice: This method should only be used on lists already read from the database. Does not translate into SQL.
        /// </summary>
        public static double? SumOrNull<T>(this IEnumerable<T> values, Func<T, double?> selector)
        {
            double? d = null;

            IEnumerable<double?> list = values.Select(selector);

            foreach (double? v in list)
            {
                if (v.HasValue)
                {
                    d = d.HasValue ? d += v : v;
                }
            }
            return d;
        }
    }

    public class SortColumn
    {
        public string ColumnName  { get; private set; }
        public bool Descending { get; private set; }

        public SortColumn(string columnName, bool descending)
        {
            ColumnName = columnName;
            Descending = descending;
        }
    }
}
