using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TDAmeritradeNet
{
    public class OrderCancel
    {
        public string Result { get; set; }
        public string AccountId { get; set; }
        public string OrderId { get; set; }
        public string Message { get; set; }
        public string Error { get; set; }

        public void Parse(Stream stream)
        {
            Dictionary<string, string> cancel = XmlToDictionary.StreamToDictionary(stream);

            this.Result = cancel.ContainsKey("result") ? cancel["result"] : "";
            this.AccountId = cancel.ContainsKey("account-id") ? cancel["account-id"] : "";
            this.OrderId = cancel.ContainsKey("order-id") ? cancel["order-id"] : "";
            this.Message = cancel.ContainsKey("message") ? cancel["message"] : "";
            this.Error = cancel.ContainsKey("error") ? cancel["error"] : "";
        }
    }
}
