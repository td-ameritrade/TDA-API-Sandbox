using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Xml;
using System.Xml.XPath;

namespace TDAmeritradeNet
{
    public class L1QuoteSnapshot
    {
        public string Error { get; set; }
        public string Symbol { get; set; }
        public string Description { get; set; }
        public float Bid { get; set; }
        public float Ask { get; set; }
        public float Last { get; set; }
        public string BidAskSize { get; set; }
        public int LastTradeSize { get; set; }
        public DateTime LastTradeDate { get; set; }
        public float Open { get; set; }
        public float High { get; set; }
        public float Low { get; set; }
        public float Close { get; set; }
        public float Volume { get; set; }
        public float YearHigh { get; set; }
        public float YearLow { get; set; }
        public bool Realtime { get; set; }
        public string Exchange { get; set; }
        public string AssetType { get; set; }
        public float Change { get; set; }
        public float ChangePercent { get; set; }
        public bool ToBeDeleted
        {
            get { return (DateTime.Today - LastTradeDate.Date).Days >= 7; }
        }
    }
}