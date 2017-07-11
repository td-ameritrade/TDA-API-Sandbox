using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;

namespace TDAmeritradeNet
{
    public class EquityOrderResponse
    {
        public string ClientOrderId { get; set; }
        public string OrderString { get; set; }
        public string Result { get; set; }
        public string Error { get; set; }
        public string AccountId { get; set; }
        public string Symbol { get; set; }
        public string Description { get; set; }
        public string AssetType { get; set; }
        public string Exchange { get; set; }
        public string Quantity { get; set; }
        public string OrderId { get; set; }
        public string Action { get; set; }
        public string TradeType { get; set; }
        public string OrderType { get; set; }
        public string LimitPrice { get; set; }
        public string StopPrice { get; set; }

        public void Parse(Stream stream)
        {
            Dictionary<string, string> trade = XmlToDictionary.StreamToDictionary(stream);

            this.ClientOrderId = trade.ContainsKey("client-order-id") ? trade["client-order-id"] : "";
            this.OrderString = trade.ContainsKey("orderstring") ? trade["orderstring"] : "";
            this.Result = trade.ContainsKey("result") ? trade["result"] : "";
            this.Error = trade.ContainsKey("error") ? trade["error"] : "";
            this.AccountId = trade.ContainsKey("account-id") ? trade["account-id"] : "";
            this.Symbol = trade.ContainsKey("symbol") ? trade["symbol"] : "";
            this.Description = trade.ContainsKey("description") ? trade["description"] : "";
            this.AssetType = trade.ContainsKey("asset-type") ? trade["asset-type"] : "";
            this.Exchange = trade.ContainsKey("exchange") ? trade["exchange"] : "";
            this.Quantity = trade.ContainsKey("quantity") ? trade["quantity"] : "";
            this.OrderId = trade.ContainsKey("order-id") ? trade["order-id"] : "";
            this.Action = trade.ContainsKey("action") ? trade["action"] : "";
            this.TradeType = trade.ContainsKey("trade-type") ? trade["trade-type"] : "";
            this.OrderType = trade.ContainsKey("order-type") ? trade["order-type"] : "";
            this.LimitPrice = trade.ContainsKey("limit-price") ? trade["limit-price"] : "";
            this.StopPrice = trade.ContainsKey("stop-price") ? trade["stop-price"] : "";
        }
    }
}
