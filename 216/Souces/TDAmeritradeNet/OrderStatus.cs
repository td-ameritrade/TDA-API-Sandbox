using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace TDAmeritradeNet
{
    public class OrderStatus
    {
        public string OrderNumber { get; set; }
        public bool Cancelable { get; set; }
        public bool Editable { get; set; }
        public bool ComplexOption { get; set; }
        public bool EnhancedOrder { get; set; }
        public string DisplayStatus { get; set; }
        public string OrderRoutingStatus { get; set; }
        public string OrderReceivedDateTime { get; set; }
        public string ReportedTime { get; set; }
        public string CancelDateTime { get; set; }
        public float RemainingQuantity { get; set; }
        public float TrailingActivationPrice { get; set; }
        public string AccountId { get; set; }
        public string Symbol { get; set; }
        public string SymbolWithTypePrefix { get; set; }
        public string Description { get; set; }
        public string AssetType { get; set; }
        public float Quantity { get; set; }
        public string OrderId { get; set; }
        public string Action { get; set; }
        public string TradeType { get; set; }
        public string RoutingMode { get; set; }
        public string OptionExchange { get; set; }
        public string ResponseDescription { get; set; }
        public float RoutingDisplaySize { get; set; }
        public string OrderType { get; set; }
        public float LimitPrice { get; set; }
        public float StopPrice { get; set; }
        public string SpecialConditions { get; set; }
        public string Session { get; set; }
        public string Expiration { get; set; }


        public static List<OrderStatus> Parse(Stream stream)
        {
            var items = new List<OrderStatus>();

            if (stream == null || !stream.CanRead) return items;
            
            var stopwatch = new Stopwatch();
            stopwatch.Start();

            var settings = new XmlReaderSettings();
            settings.IgnoreWhitespace = true;
            settings.IgnoreComments = true;


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
                
                string lastElementName = string.Empty;
                OrderStatus oStatus = null;

                while (reader.Read())
                {
                    if (reader.NodeType == XmlNodeType.Element && reader.NodeType != XmlNodeType.EndElement)
                    {
                        lastElementName = reader.LocalName;

                        if (reader.LocalName.Equals("orderstatus"))
                        {
                            oStatus = new OrderStatus();
                        }
                    }

                    if (reader.NodeType == XmlNodeType.Text)
                    {
                        if (oStatus != null)
                        {

                            switch (lastElementName)
                            {
                                case "order-number":
                                    oStatus.OrderNumber = reader.Value;
                                    break;
                                case "cancelable":
                                    oStatus.Cancelable = Convert.ToBoolean(reader.Value);
                                    break;
                                case "editable":
                                    oStatus.Editable = Convert.ToBoolean(reader.Value);
                                    break;
                                case "complex-option":
                                    oStatus.ComplexOption = Convert.ToBoolean(reader.Value);
                                    break;
                                case "enhanced-order":
                                    oStatus.EnhancedOrder = Convert.ToBoolean(reader.Value);
                                    break;
                                case "display-status":
                                    oStatus.DisplayStatus = reader.Value;
                                    break;
                                case "order-routing-status":
                                    oStatus.OrderRoutingStatus = reader.Value;
                                    break;
                                case "order-received-date-time":
                                    oStatus.OrderReceivedDateTime = reader.Value;
                                    break;
                                case "cancel-date-time":
                                    oStatus.CancelDateTime = reader.Value;
                                    break;
                                case "reported-time":
                                    oStatus.ReportedTime = reader.Value;
                                    break;
                                case "remaining-quantity":
                                    oStatus.RemainingQuantity = Convert.ToSingle(reader.Value);
                                    break;
                                case "trailing-activation-price":
                                    oStatus.TrailingActivationPrice = Convert.ToSingle(reader.Value);
                                    break;
                                case "account-id":
                                    oStatus.AccountId = reader.Value;
                                    break;
                                case "symbol":
                                    oStatus.Symbol = reader.Value;
                                    break;
                                case "symbol-with-type-prefix":
                                    oStatus.SymbolWithTypePrefix = reader.Value;
                                    break;
                                case "description":
                                    oStatus.Description = reader.Value;
                                    break;
                                case "asset-type":
                                    oStatus.AssetType = reader.Value;
                                    break;
                                case "quantity":
                                    oStatus.Quantity = Convert.ToSingle(reader.Value);
                                    break;
                                case "order-id":
                                    oStatus.OrderId = reader.Value;
                                    break;
                                case "action":
                                    oStatus.Action = reader.Value;
                                    break;
                                case "trade-type":
                                    oStatus.TradeType = reader.Value;
                                    break;
                                case "routing-mode":
                                    oStatus.RoutingMode = reader.Value;
                                    break;
                                case "option-exchange":
                                    oStatus.OptionExchange = reader.Value;
                                    break;
                                case "response-description":
                                    oStatus.ResponseDescription = reader.Value;
                                    break;
                                case "routing-display-size":
                                    oStatus.RoutingDisplaySize = Convert.ToSingle(reader.Value);
                                    break;
                                case "order-type":
                                    oStatus.OrderType = reader.Value;
                                    break;
                                case "limit-price":
                                    oStatus.LimitPrice = Convert.ToSingle(reader.Value);
                                    break;
                                case "stop-price":
                                    oStatus.StopPrice = Convert.ToSingle(reader.Value);
                                    break;
                                case "session":
                                    oStatus.Session = reader.Value;
                                    break;
                                case "expiration":
                                    oStatus.Expiration = reader.Value;
                                    break;
                                default:
                                    Debug.Print("Not processed: {0}", lastElementName);
                                    break;
                            }
                        }
                    }

                    if (reader.NodeType == XmlNodeType.EndElement)
                    {
                        if (reader.LocalName.Equals("orderstatus"))
                        {
                            items.Add(oStatus);
                        }
                    }
                }
            }

            return items;
        }
    }
}
