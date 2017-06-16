using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TDAmeritradeNet
{
    public class AccountActivity
    {
        public string AccountId { get; set; }
        public AccountActivityType MessageType { get; set; }
        public string MessageData { get; set; }

        // basic information
        public string Symbol { get; set; }
        public string OrderNumber { get; set; } // 75239494
        public string OrderAction { get; set; }  // buy, sell ...
        public string OrderType { get; set; }  // market, limit, stop ...
        public float OrderQuantity { get; set; }

        // only returned for Message Types: OrderPartialFill and OrderFill
        public string ExecutionType { get; set; }
        public float ExecutionPrice { get; set; }
        public float ExecutionQuantity { get; set; }
        public float QuantityRemaining { get; set; }
        
        public AccountActivity()
        {
            // EMPTY
        }

        public AccountActivity(byte[] b)
        {
            var byteLength = b.Length;
            var i = 0;

            try
            {
                var headerId = b.ConvertToByte(ref i);
                var msgLength = b.ConvertToShort(ref i);
                var sid = b.ConvertToShort(ref i);
                var colNum = b.ConvertToColumnNumber(ref i);
                var keyLength = b.ConvertToShort(ref i);
                var subscriptionKey = b.ConvertToString(ref i, keyLength);
                var colNum2 = b.ConvertToColumnNumber(ref i);
                var accountLength = b.ConvertToShort(ref i);
                this.AccountId = b.ConvertToString(ref i, accountLength);
                var colNum3 = b.ConvertToColumnNumber(ref i);
                var msgTypeLength = b.ConvertToShort(ref i);
                string messageTypeString = b.ConvertToString(ref i, msgTypeLength);
                this.MessageType = GetMessageType(messageTypeString);
                var colNum4 = b.ConvertToColumnNumber(ref i);
                var msgDataLength = b.ConvertToShort(ref i);
                this.MessageData = b.ConvertToString(ref i, msgDataLength);

                if (!string.IsNullOrEmpty(this.MessageData))
                {
                    XDocument xDocument = XDocument.Parse(this.MessageData);

                    var element = xDocument.Descendants().FirstOrDefault(e => e.Name.LocalName == "Symbol");
                    if (element != null)
                    {
                        this.Symbol = element.Value;
                    }

                    element = xDocument.Descendants().FirstOrDefault(e => e.Name.LocalName == "OrderKey");
                    if (element != null)
                    {
                        this.OrderNumber = element.Value;
                    }

                    element = xDocument.Descendants().FirstOrDefault(e => e.Name.LocalName == "OrderType");
                    if (element != null)
                    {
                        this.OrderType = element.Value;
                    }

                    element = xDocument.Descendants().FirstOrDefault(e => e.Name.LocalName == "OrderInstructions");
                    if (element != null)
                    {
                        this.OrderAction = element.Value;
                    }

                    element = xDocument.Descendants().FirstOrDefault(e => e.Name.LocalName == "OriginalQuantity");
                    if (element != null)
                    {
                        this.OrderQuantity = Convert.ToSingle(element.Value);
                    }

                    if (this.MessageType == AccountActivityType.OrderFill ||
                        this.MessageType == AccountActivityType.OrderPartialFill)
                    {
                        element = xDocument.Descendants().LastOrDefault(e => e.Name.LocalName == "Type");
                        if (element != null)
                        {
                            this.ExecutionType = element.Value;
                        }

                        element = xDocument.Descendants().LastOrDefault(e => e.Name.LocalName == "Quantity");
                        if (element != null)
                        {
                            this.ExecutionQuantity = Convert.ToSingle(element.Value);
                        }

                        element = xDocument.Descendants().LastOrDefault(e => e.Name.LocalName == "ExecutionPrice");
                        if (element != null)
                        {
                            this.ExecutionPrice = Convert.ToSingle(element.Value);
                        }

                        element = xDocument.Descendants().LastOrDefault(e => e.Name.LocalName == "LeavesQuantity");
                        if (element != null)
                        {
                            this.QuantityRemaining = Convert.ToSingle(element.Value);
                        }
                    }
                }
                
                Debug.Print("--------------------------------------");
                Debug.Print("MessageType: {0}", this.MessageType);
                Debug.Print("MessageContent: {0}\r\n", this.MessageData);
                Debug.Print("Symbol: {0}", this.Symbol);
                Debug.Print("Order Number: {0}", this.OrderNumber);
                Debug.Print("Order Action: {0}", this.OrderAction);
                Debug.Print("Order Type: {0}", this.OrderType);
                Debug.Print("Order Quantity: {0}", this.OrderQuantity);
                Debug.Print("--------------------------------------");
            }
            catch (Exception e)
            {
                throw new InvalidCastException("Account Activie Parse Failed...");
            }
        }

        private AccountActivityType GetMessageType(string msgType)
        {
            try
            {
                var messageType = (AccountActivityType)Enum.Parse(typeof(AccountActivityType), msgType);
                return messageType;
            }
            catch (Exception)
            {
                return AccountActivityType.NotFound;
            }
            
        }
    }
}
