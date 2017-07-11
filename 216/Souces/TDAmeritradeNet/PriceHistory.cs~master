using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using TDAmeritradeNet;

namespace TDAmeritradeNet
{
    public class PriceHistory: IDisposable
    {
        public string Symbol { get; set; }
        public string ErrorText { get; set; }
        public double[] TimeStamps { get; set; }
        public double[] Opens { get; set; }
        public double[] Highs { get; set; }
        public double[] Lows { get; set; }
        public double[] Closes { get; set; }
        public double[] Volumes { get; set; }
        public bool IsDaily { get; set; }

        public int Count
        {
            get
            {
                if (TimeStamps == null)
                    return 0;

                return TimeStamps.Length;
            }
        }

        public DateTime LastDate
        {
            get
            {
                if (TimeStamps == null)
                    return DateTime.MinValue;

                return DateTime.FromOADate(TimeStamps.Max()).Date;
            }
        }

        public void Dispose()
        {
            Symbol = null;
            ErrorText = null;
            TimeStamps = null;
            Opens = null;
            Highs = null;
            Lows = null;
            Closes = null;
            Volumes = null;
        }
    }
}