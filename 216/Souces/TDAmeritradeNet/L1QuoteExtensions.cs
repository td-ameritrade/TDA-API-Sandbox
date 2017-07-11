using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TDAmeritradeNet
{
    public static class L1QuoteExtensions
    {
        public static void MergeData(this L1QuoteStreaming q1, L1QuoteStreaming q2)
        {
            if (q1.Symbol != q2.Symbol)
            {
                throw new InvalidCastException(string.Format("Can't merge data: {0} because of different symbols", q1.Symbol));
            }

            var properties = typeof (L1QuoteStreaming).GetProperties();

            foreach (var pi in properties)
            {
                System.Type propertyType = pi.PropertyType;
                System.TypeCode typeCode = Type.GetTypeCode(propertyType);

                var type1 = q1.GetType();
                var pi1 = type1.GetProperty(pi.Name);
                var type2 = q2.GetType();
                var pi2 = type2.GetProperty(pi.Name);
                var v1 = pi2.GetValue(q2, null);  // Get value of q2's property

                if (typeCode == TypeCode.Int32 ||
                    typeCode == TypeCode.Int64 ||
                    typeCode == TypeCode.Single ||
                    typeCode == TypeCode.Double)
                {
                    if (Convert.ToDouble(v1) != 0.0)
                    {
                        pi1.SetValue(pi1, Convert.ChangeType(v1, typeCode));  // Set the property value
                    }
                }
                else
                {
                    pi1.SetValue(pi1, Convert.ChangeType(v1, typeCode));  // Set the property value
                }
                
            }
        }
    }
}
