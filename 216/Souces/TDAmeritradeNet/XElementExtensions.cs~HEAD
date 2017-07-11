using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TDAmeritradeNet
{
    /// <summary>
    /// Extension methods for <see cref="XElement"/>.
    /// </summary>
    public static class XElementExtensions
    {
        /// <summary>
        /// Converts the <see cref="XElement"/>'s value string into <see cref="Boolean"/> value.
        /// </summary>
        /// <param name="element">The <see cref="XElement"/> object containing 'true' or 'false' string value.</param>
        /// <returns>true or false</returns>
        public static bool ToBoolean(this XElement element)
        {
            return Boolean.Parse(element.Value);
        }

        /// <summary>
        /// Converts the <see cref="XElement"/>'s value string into <see cref="DateTime"/>.
        /// </summary>
        /// <param name="element">The <see cref="XElement"/> object containing a date and time string.</param>
        /// <returns>The <see cref="DateTime"/> object.</returns>
        public static DateTime ToDate(this XElement element)
        {
            var date = element.Value;
            date = date.Substring(0, 10) + "T" + date.Substring(11, 8) + ".000" + date.Substring(20, 3).Replace("EDT", "-04:00").Replace("EST", "-05:00");
            return DateTime.Parse(date, CultureInfo.InvariantCulture);
        }

        /// <summary>
        /// Converts the <see cref="XElement"/>'s value string into <see cref="Int32"/>.
        /// </summary>
        /// <param name="element"></param>
        /// <returns></returns>
        public static int ToInt(this XElement element)
        {
            int num;
            bool success = Int32.TryParse(element.Value, out num);
            if (success)
            {
                return num;
            }
            else
            {
                return 0;
            }
        }


        /// <summary>
        /// Converts the <see cref="XElement"/>'s value string into <see cref="float"/>.
        /// </summary>
        /// <param name="element"></param>
        /// <returns></returns>
        public static float ToFloat(this XElement element)
        {
            float num;
            bool success = Single.TryParse(element.Value, out num);
            if (success)
            {
                return num;
            }
            else
            {
                return 0;
            }
        }

        /// <summary>
        /// Converts the <see cref="XElement"/>'s value string into <see cref="double"/>.
        /// </summary>
        /// <param name="element"></param>
        /// <returns></returns>
        public static double ToDouble(this XElement element)
        {
            double num;
            bool success = double.TryParse(element.Value, out num);
            if (success)
            {
                return num;
            }
            else
            {
                return 0;
            }
        }

        /// <summary>
        /// Converts the <see cref="XElement"/>'s value into <see cref="TimeSpan"/>.
        /// </summary>
        /// <param name="element">The <see cref="XElement"/>'s object containing time span value in minutes.</param>
        /// <returns>The <see cref="TimeSpan"/>.</returns>
        public static TimeSpan ToTimeSpan(this XElement element)
        {
            return TimeSpan.FromMinutes(Double.Parse(element.Value, CultureInfo.InvariantCulture));
        }

        /// <summary>
        /// Converts the <see cref="XElement"/>'s value into Boolean based on whether it's value equals 'realtime' or 'delayed'.
        /// </summary>
        /// <param name="element">The <see cref="XElement"/> object containing 'realtime' or 'delayed' string value.</param>
        /// <returns>true if real-time; false if delayed.</returns>
        /// <exception cref="ArgumentOutOfRangeException">The XDocument's value neither 'realtime' nor a 'delayed'.</exception>
        public static bool IsRealtime(this XElement element)
        {
            switch (element.Value)
            {
                case "realtime":
                    return true;
                case "delayed":
                    return false;
                default:
                    throw new ArgumentOutOfRangeException("element", String.Format("Expected 'realtime' or 'delayed' but actual value was '{0}'.", element.Value));
            }
        }
    }
}
