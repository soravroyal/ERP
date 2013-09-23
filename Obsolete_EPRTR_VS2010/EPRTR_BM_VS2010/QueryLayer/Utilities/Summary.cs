using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using QueryLayer.Filters;
using QueryLayer.LinqFramework;
using QueryLayer.Enums;

namespace QueryLayer.Utilities
{
    public static class Summary
    {
        static string CODE_TNE = EnumUtil.GetStringValue(QuantityUnit.Tonnes);

        [Serializable]
        public class Quantity
        {
            private string code;
            private double quantityValue;

            public Quantity(string code, double? quantity)
            {
                this.code = code;
                this.quantityValue = quantity.HasValue ? quantity.Value : 0;
            }

            public string Name { get; set; }
            public string Code { get { return this.code; } }
            public double QuantityValue { get { return this.quantityValue; } }
        }


        public class WasteSummaryTreeListRow:TreeListRow
        {
            public WasteSummaryTreeListRow(string code, 
                         double? recovery,
                         double? disposal,
                         double? unspecified,
                         double? total,
                         int level, bool hasChildren)
                : this(code, 0, recovery, disposal, unspecified, total, level, hasChildren)
            { }

            
            public WasteSummaryTreeListRow(string code,
                                     int facilities,
                                     double? recovery,
                                     double? disposal,
                                     double? unspecified,
                                     double? total,
                                     int level, bool hasChildren):base(code, null, level, hasChildren)
            {
                this.Facilities = facilities;

                this.Recovery = recovery;
                this.Disposal = disposal;
                this.Unspecified = unspecified;
                this.TotalQuantity = total;

                this.RecoveryPercent = null;
                this.DisposalPercent = null;
                this.UnspecifiedPercent = null;
                
                //waste is always reported in t
                this.Unit = CODE_TNE;

                if (this.TotalQuantity.HasValue && this.TotalQuantity > 0)
                {
                    this.RecoveryPercent = this.Recovery.HasValue ? (this.Recovery / this.TotalQuantity) * 100.0 : null;
                    this.DisposalPercent = this.Disposal.HasValue ? (this.Disposal / this.TotalQuantity) * 100.0 : null;
                    this.UnspecifiedPercent = this.Unspecified.HasValue ? (this.Unspecified / this.TotalQuantity) * 100.0 : null;
                }
            }

            public int Facilities{ get; set; }
            public double? Recovery { get; private set; }
            public double? Disposal { get; private set; }
            public double? Unspecified { get; private set; }
            public double? TotalQuantity { get; private set; }
            public string Unit { get; private set; }

            public double? RecoveryPercent { get; private set; }
            public double? DisposalPercent { get; private set; }
            public double? UnspecifiedPercent { get; private set; }

        }


        public class WastePieChart
        {
            public double Percent { get; set; }
            public string Text { get; set; }
            public string Id { get; set; }

            public WastePieChart(double? percent, string text)
            {
                this.Text = text;
                this.Percent = percent.HasValue ? (double)percent : 0.0f;
            }
            
        }


        public static List<Summary.Quantity> GetTop10(List<Summary.Quantity> list, double total)
        {
            if (list.Count > 10)
            {
                double sumFirst9 = 0;
                List<Summary.Quantity> sortedResult = new List<Summary.Quantity>();

                var sorted = list.OrderByDescending(x => x.QuantityValue);
                foreach (Summary.Quantity sq in sorted)
                {
                    if (sq.QuantityValue > 0)
                    {
                        sumFirst9 += sq.QuantityValue;
                        sortedResult.Add(new Summary.Quantity(sq.Code, sq.QuantityValue));
                        if (sortedResult.Count() == 9)
                            break;
                    }
                }
                sortedResult.Add(new Summary.Quantity("OTHER", total - sumFirst9));
                return sortedResult;
            }
            return list;
        }


    }
}
