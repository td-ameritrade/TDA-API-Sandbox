using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Xml.Linq;
using TDAmeritradeNet.Annotations;

namespace TDAmeritradeNet
{
    public class Positions
    {
        //Dictionary<string, string> data = new Dictionary<string, string>(); 
        public string AccountId { get; set; }
        public List<Position> Stocks { get; set; }
        public List<Position> Options { get; set; }
        public List<Position> Funds { get; set; }
        public List<Position> Bonds { get; set; }
        public List<Position> MoneyMarkets { get; set; }
        public List<Position> Savings { get; set; }


        public Positions()
        {
            Stocks = new List<Position>();
            Options = new List<Position>();
            Funds = new List<Position>();
            Bonds = new List<Position>();
            MoneyMarkets = new List<Position>();
            Savings = new List<Position>();
        }

        public Positions(Stream stream)
        {
            Stocks = new List<Position>();
            Options = new List<Position>();
            Funds = new List<Position>();
            Bonds = new List<Position>();
            MoneyMarkets = new List<Position>();
            Savings = new List<Position>();

            var streamReader = new StreamReader(stream);
            string xmlString = streamReader.ReadToEnd();

            XDocument xDocument = XDocument.Parse(xmlString);

            AccountId = xDocument.Descendants("account-id").First().Value;

            List<Position> securities = (from items in xDocument.Descendants("position")
                                         select new Position()
                                                    {
                                                        CUSIP = (items.Element("security").Element("cusip") != null) ? items.Element("security").Element("cusip").Value.Trim() : "",
                                                        AssetType = (items.Element("security").Element("asset-type") != null) ? items.Element("security").Element("asset-type").Value.Trim() : "",
                                                        AccountType = (items.Element("account-type") != null) ? items.Element("account-type").Value.Trim() : "",
                                                        Error = (items.Element("error") != null) ? items.Element("error").Value.Trim() : "",
                                                        Symbol = (items.Element("security").Element("symbol") != null) ? items.Element("security").Element("symbol").Value.Trim() : "",
                                                        Description = (items.Element("security").Element("description") != null) ? items.Element("security").Element("description").Value.Trim() : "",
                                                        PositionType = (items.Element("position-type") != null) ? items.Element("position-type").Value : "",
                                                        Quantity = (items.Element("quantity") != null) ? Convert.ToSingle(items.Element("quantity").Value.Trim()) : 0,
                                                        AveragePrice = (items.Element("average-price") != null) ? Convert.ToSingle(items.Element("average-price").Value.Trim()) : 0,
                                                        CurrentValue = (items.Element("current-value") != null) ? Convert.ToSingle(items.Element("current-value").Value.Trim()) : 0,
                                                        PutCallIndicator = (items.Element("put-call-indicator") != null) ? items.Element("put-call-indicator").Value.Trim() : "",
                                                    }).ToList();

            Stocks.AddRange(securities.Where(o => o.AssetType == "E"));
            Options.AddRange(securities.Where(o => o.AssetType == "O"));
            Funds.AddRange(securities.Where(o => o.AssetType == "F"));
            Bonds.AddRange(securities.Where(o => o.AssetType == "B"));
            MoneyMarkets.AddRange(securities.Where(o => o.AssetType == "M"));
            Savings.AddRange(securities.Where(o => o.AssetType == "V"));
        }
    }

    public class Position : INotifyPropertyChanged 
    {
        public string CUSIP { get; set; }
        public string AssetType { get; set; } // E-Equity, F-Mutual Fund, O-Option, B-Bond, M-Money Market, V-Saving
        public string AccountType { get; set; } // 1-Cash, 2-Margin, 3-Short, 4-Dividend/Interest
        public string Error { get; set; }
        public string Symbol { get; set; }
        public string Description { get; set; }
        public string PositionType { get; set; } // long or short
        public float Quantity { get; set; }
        public float AveragePrice { get; set; }
        public float CurrentValue { get; set; }
        public string PutCallIndicator { get; set; }

        // non API properties
        private float last;
        private float profitChange;
        private float profitChangePercent;
        private Color lastColor;

        public float Last
        {
            get { return last; }
            set 
            { 
                last = value;
                NotifyPropertyChanged("Last");
            }
        }
        public float TotalCost
        {
            get { return Quantity*AveragePrice; }
        }
        public float ProfitChange
        {
            get { return profitChange; }
            set
            {
                profitChange = value;
                NotifyPropertyChanged("ProfitChange");
            }
        }
        public float ProfitChangePercent
        {
            get { return profitChangePercent; }
            set
            {
                profitChangePercent = value;
                NotifyPropertyChanged("ProfitChangePercent");
            }
        }
        public Color LastColor
        {
            get { return lastColor; }
            set
            {
                lastColor = value;
                NotifyPropertyChanged("LastColor");
            }
        }

        public event PropertyChangedEventHandler PropertyChanged;

        private void NotifyPropertyChanged(string name)
        {
            try
            {
                if (PropertyChanged != null)
                {
                    PropertyChanged(this, new PropertyChangedEventArgs(name));
                }
            }
            catch (InvalidOperationException e)
            {
                //EMPTY
            }
        }
    }
}