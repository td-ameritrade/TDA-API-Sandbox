using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml;

namespace TDAmeritradeNet
{
    public class OrderHistory
    {
        public string AccoundId { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string SearchTransactionType { get; set; }
        public string RequestType { get; set; }
        public DateTime LastParseTime { get; set; }

        public string Error { get; set; }
        public DateTime ExecutedDate { get; set; }
        public string OrderNumber { get; set; }
        public string OrderDateTime { get; set; }
        public string BuySellCode { get; set; }
        public string Type { get; set; }
        public string SubType { get; set; }
        public string AssetType { get; set; }
        public string Symbol { get; set; }
        public string Description { get; set; }
        public string CUSIP { get; set; }
        public float Price { get; set; }
        public float Quantity { get; set; }
        public string TransactionId { get; set; }
        public float Value { get; set; }
        public float Commission { get; set; }
        public float Fees { get; set; }
        public float AdditionalFees { get; set; }
        public string CashBalanceEffect { get; set; }
        public string OpenClose { get; set; }
        public string OptionExpireDate { get; set; }
        public string OptionType { get; set; }
        public float OptionStrike { get; set; }
        public float AccruedInterest { get; set; }
        public string ParentChildIndicator { get; set; }
        public float SharesBefore { get; set; }
        public float SharesAfter { get; set; }
        public float OtherChanges { get; set; }
        public float RedemptionFee { get; set; }
        public float CDSCFee { get; set; }
        public float BondInterestRate { get; set; }
        public string SplitRatio { get; set; }
        public string BankingStatus { get; set; }
        public string AccountType { get; set; }

        // Custom Fields
        public float TotalCost { get { return Price * Quantity; } }
        public float CurrentPrice { get; set; }
        public float ChangeSince { get; set; }

        public List<OrderHistory> Parse(Stream stream)
        {
            var items = new List<OrderHistory>();

            if (stream == null || !stream.CanRead) return items;
            
            var stopwatch = new Stopwatch();
            stopwatch.Start();

            var settings = new XmlReaderSettings();
            settings.IgnoreWhitespace = true;
            settings.IgnoreComments = true;

            try
            {
                using (XmlReader reader = XmlReader.Create(stream, settings))
                {
                    /*
                     * Get result
                     */
                    reader.ReadToFollowing("result");
                    var result = reader.ReadElementContentAsString();
                    Debug.Print("result: {0}", result);

                    if (result != "OK")
                    {
                        return items;
                    }
                    
                    while (reader.Read())
                    {
                        if (reader.NodeType == XmlNodeType.Element &&
                            reader.LocalName.Equals("transaction-list"))
                        {
                            var trans = new OrderHistory();
                            bool endItem = false;

                            while (!endItem && reader.Read())  // condition order is important because reader.Read() won't be executed if endQuote = true
                            {
                                if (reader.NodeType == XmlNodeType.Element &&
                                    reader.NodeType != XmlNodeType.EndElement)
                                {
                                    switch (reader.LocalName)
                                    {
                                        case "error":
                                            reader.Read();
                                            trans.Error = reader.Value;
                                            break;
                                        case "executedDate":
                                            reader.Read();
                                            if (!string.IsNullOrEmpty(reader.Value) && reader.Value.Contains("EDT"))
                                            {
                                                trans.ExecutedDate = DateTime.ParseExact(reader.Value, "yyyy-MM-dd HH:mm:ss EDT", CultureInfo.InvariantCulture).ToUniversalTime().ToLocalTime();
                                            }
                                            else if (!string.IsNullOrEmpty(reader.Value) && reader.Value.Contains("EST"))
                                            {
                                                trans.ExecutedDate = DateTime.ParseExact(reader.Value, "yyyy-MM-dd HH:mm:ss EST", CultureInfo.InvariantCulture).ToUniversalTime().ToLocalTime();
                                            }
                                            break;
                                        case "orderNumber":
                                            reader.Read();
                                            trans.OrderNumber = reader.Value;
                                            break;
                                        case "orderDateTime":
                                            reader.Read();
                                            trans.OrderDateTime = reader.Value;
                                            break;
                                        case "buySellCode":
                                            reader.Read();
                                            trans.BuySellCode = reader.Value;
                                            break;
                                        case "assetType":
                                            reader.Read();
                                            trans.AssetType = reader.Value;
                                            break;
                                        case "type":
                                            reader.Read();
                                            trans.Type = reader.Value;
                                            break;
                                        case "subType":
                                            reader.Read();
                                            trans.SubType = reader.Value;
                                            break;
                                        case "symbol":
                                            reader.Read();
                                            trans.Symbol = reader.Value;
                                            break;
                                        case "description":
                                            reader.Read();
                                            trans.Description = reader.Value;
                                            break;
                                        case "cusip":
                                            reader.Read();
                                            trans.CUSIP = reader.Value;
                                            break;
                                        case "price":
                                            reader.Read();
                                            trans.Price = (!string.IsNullOrEmpty(reader.Value))
                                                              ? Convert.ToSingle(reader.Value)
                                                              : 0;
                                            break;
                                        case "quantity":
                                            reader.Read();
                                            trans.Quantity = (!string.IsNullOrEmpty(reader.Value))
                                                                 ? Convert.ToSingle(reader.Value)
                                                                 : 0;
                                            break;
                                        case "transactionId":
                                            reader.Read();
                                            trans.TransactionId = reader.Value;
                                            break;
                                        case "value":
                                            reader.Read();
                                            trans.Value = (!string.IsNullOrEmpty(reader.Value))
                                                              ? Convert.ToSingle(reader.Value)
                                                              : 0;
                                            break;
                                        case "commission":
                                            reader.Read();
                                            trans.Commission = (!string.IsNullOrEmpty(reader.Value))
                                                                   ? Convert.ToSingle(reader.Value)
                                                                   : 0;
                                            break;
                                        case "fees":
                                            reader.Read();
                                            trans.Fees = (!string.IsNullOrEmpty(reader.Value))
                                                             ? Convert.ToSingle(reader.Value)
                                                             : 0;
                                            break;
                                        case "additionalFees":
                                            reader.Read();
                                            trans.AdditionalFees = (!string.IsNullOrEmpty(reader.Value))
                                                                       ? Convert.ToSingle(reader.Value)
                                                                       : 0;
                                            break;
                                        case "cashBalanceEffect":
                                            reader.Read();
                                            trans.CashBalanceEffect = reader.Value;
                                            break;
                                        case "openClose":
                                            reader.Read();
                                            trans.TransactionId = reader.Value;
                                            break;
                                        case "optionType":
                                            reader.Read();
                                            trans.OptionType = reader.Value;
                                            break;
                                        case "optionExpireDate":
                                            reader.Read();
                                            trans.OptionExpireDate = reader.Value;
                                            break;
                                        case "optionStrike":
                                            reader.Read();
                                            trans.OptionStrike = (!string.IsNullOrEmpty(reader.Value))
                                                                     ? Convert.ToSingle(reader.Value)
                                                                     : 0;
                                            break;
                                        case "accruedInterest":
                                            reader.Read();
                                            trans.AccruedInterest = (!string.IsNullOrEmpty(reader.Value))
                                                                        ? Convert.ToSingle(reader.Value)
                                                                        : 0;
                                            break;
                                        case "parentChildIndicator":
                                            reader.Read();
                                            trans.ParentChildIndicator = reader.Value;
                                            break;
                                        case "sharesBefore":
                                            reader.Read();
                                            trans.SharesBefore = (!string.IsNullOrEmpty(reader.Value))
                                                                     ? Convert.ToSingle(reader.Value)
                                                                     : 0;
                                            break;
                                        case "sharesAfter":
                                            reader.Read();
                                            trans.SharesAfter = (!string.IsNullOrEmpty(reader.Value))
                                                                    ? Convert.ToSingle(reader.Value)
                                                                    : 0;
                                            break;
                                        case "otherCharges":
                                            reader.Read();
                                            trans.OtherChanges = (!string.IsNullOrEmpty(reader.Value))
                                                                     ? Convert.ToSingle(reader.Value)
                                                                     : 0;
                                            break;
                                        case "redemptionFee":
                                            reader.Read();
                                            trans.RedemptionFee = (!string.IsNullOrEmpty(reader.Value))
                                                                      ? Convert.ToSingle(reader.Value)
                                                                      : 0;
                                            break;
                                        case "cdscFee":
                                            reader.Read();
                                            trans.CDSCFee = (!string.IsNullOrEmpty(reader.Value))
                                                                ? Convert.ToSingle(reader.Value)
                                                                : 0;
                                            break;
                                        case "bondInterestRate":
                                            reader.Read();
                                            trans.BondInterestRate = (!string.IsNullOrEmpty(reader.Value))
                                                                         ? Convert.ToSingle(reader.Value)
                                                                         : 0;
                                            break;
                                        case "SplitRatio":
                                            reader.Read();
                                            trans.SplitRatio = reader.Value;
                                            break;
                                        case "bankingStatus":
                                            reader.Read();
                                            trans.AccountType = reader.Value;
                                            break;
                                        case "accountType":
                                            reader.Read();
                                            trans.AccountType = reader.Value;
                                            break;
                                        default:
                                            Debug.Print("Not processed: {0}", reader.LocalName);
                                            break;
                                    }
                                }
                                else if (reader.NodeType == XmlNodeType.EndElement &&
                                         reader.LocalName == "transaction-list")
                                {
                                    //Debug.Print("Symbol: {0}, Change: {1}, Change(%): {2:P2}", quote.Symbol, quote.Change, quote.ChangePercent);
                                    items.Add(trans);
                                    endItem = true;
                                }
                            }
                        }
                        else if (reader.NodeType == XmlNodeType.Element &&
                                 reader.LocalName.Equals("account-id"))
                        {
                            reader.Read();
                            AccoundId = reader.Value;
                        }
                        else if (reader.NodeType == XmlNodeType.Element &&
                                 reader.LocalName.Equals("startDate"))
                        {
                            reader.Read();
                            StartDate = reader.Value;
                        }
                        else if (reader.NodeType == XmlNodeType.Element &&
                                 reader.LocalName.Equals("endDate"))
                        {
                            reader.Read();
                            EndDate = reader.Value;
                        }
                        else if (reader.NodeType == XmlNodeType.Element &&
                                 reader.LocalName.Equals("searchTransactionType"))
                        {
                            reader.Read();
                            SearchTransactionType = reader.Value;
                        }
                        else if (reader.NodeType == XmlNodeType.Element &&
                                 reader.LocalName.Equals("requestType"))
                        {
                            reader.Read();
                            RequestType = reader.Value;
                        }
                    }
                }
            }
            catch (Exception e)
            {
                Debug.Print("Reading Xml Error: {0}",e.Message);
            }

            stopwatch.Stop();

            Debug.Print("Time Elasped: {0} miliseconds, Count={1}", stopwatch.ElapsedMilliseconds, items.Count);

            if (items.Count > 0)
            {
                LastParseTime = DateTime.Now;
            }
            else
            {
                LastParseTime = DateTime.MinValue;
            }

            return items;
        }
    }
}
