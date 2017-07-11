using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.Text;
using System.Linq;
using System.Threading.Tasks;

namespace TDAmeritradeNet
{
    public class EquityOrder
    {
        public int LegId { get; set; }
        public string Symbol { get; set; }
        public float Price { get; set; }
        public float ActPrice { get; set; }
        public float Quantity { get; set; }
        public float TsParam { get; set; }
        public EquityOrderActions Action { get; set; }
        public EquityOrderTypes OrderType { get; set; }
        public EquityOrderRoutings Routing { get; set; }
        public EquityOrderExpires Expire { get; set; }
        public EquityOrderSpecialInstructions SpInstruction { get; set; }
        public string ConfirmMessage { get; set; }
        public string Error { get; set; }

        public EquityOrder(string symbol, float quantity, EquityOrderActions action, EquityOrderTypes orderType)
        {
            Symbol = symbol;
            Action = action;
            Quantity = quantity;
            OrderType = orderType;

            Price = 0;
            ActPrice = 0;
            TsParam = 0;
            Routing = EquityOrderRoutings.auto;
            Expire = EquityOrderExpires.day;
            SpInstruction = EquityOrderSpecialInstructions.none;
        }

        public bool Validate()
        {
            return GetOrderString().ToLower().Contains("error") == false;
        }

        public string GetOrderSummary()
        {
            return string.Empty;
        }

        public string GetOrderString()
        {
            var order = new StringBuilder();
            var error = new StringBuilder();
            var confirmMsg = string.Empty;
            var orderDescription = string.Empty;

            if (TDANET.client == null || string.IsNullOrEmpty(TDANET.client.AssociatedAccountId))
            {
                error.AppendLine("Error: No logged accound ID found. Please check if logged in.");
                return error.ToString();
            }

            string legIdStr = (LegId > 0) ? LegId.ToString() : string.Empty;
            order.AppendFormat("~symbol{0}={1}", legIdStr, Symbol);
            order.AppendFormat("~action{0}={1}", legIdStr, Action.ToString("g"));
            order.AppendFormat("~ordtype{0}={1}", legIdStr, OrderType.ToString("g"));
            order.AppendFormat("~quantity{0}={1}", legIdStr, Quantity.ToString());

            if (Quantity <= 0)
            {
                error.AppendLine("Order Error : Quantity must be greater than 0.");
            }

            switch (OrderType)
            {
                case EquityOrderTypes.market:

                    #region Market

                    if (Expire != EquityOrderExpires.day && Expire != EquityOrderExpires.moc)
                    {
                        error.AppendLine("Market Order Error : Expire must be day or moc.");
                    }

                    Routing = EquityOrderRoutings.auto;
                    SpInstruction = EquityOrderSpecialInstructions.none;

                    order.AppendFormat("~spinstructions{0}={1}", legIdStr, SpInstruction.ToString("g"));

                    confirmMsg = string.Format("Please confirm your {0} {1} order.\r\n\r\nShares: {2:N0}", this.OrderType, this.Action, this.Quantity);

                    break;

                    #endregion

                case EquityOrderTypes.limit:

                    #region Limit

                    if (Price <= 0)
                    {
                        error.AppendLine("Limit Order Error: Price must be a valid value.");
                    }
                    else
                    {
                        order.AppendFormat("~price{0}={1}", legIdStr, Price);
                    }
                    if (Expire == EquityOrderExpires.day)
                    {
                        if (SpInstruction != EquityOrderSpecialInstructions.none &&
                            SpInstruction != EquityOrderSpecialInstructions.aon &&
                            SpInstruction != EquityOrderSpecialInstructions.fok)
                        {
                            error.AppendLine("Limit Order Error: SpInstruction must be none, aon, fok.");
                        }
                    }
                    else if (Expire == EquityOrderExpires.day_ext &&
                             Expire == EquityOrderExpires.gtc_ext &&
                             Expire == EquityOrderExpires.am &&
                             Expire == EquityOrderExpires.pm)
                    {
                        if (SpInstruction != EquityOrderSpecialInstructions.none)
                        {
                            error.AppendLine("Limit Order Error : SpInstruction must be none.");
                        }
                    }
                    else if (Expire == EquityOrderExpires.gtc)
                    {
                        if (SpInstruction != EquityOrderSpecialInstructions.none &&
                            SpInstruction != EquityOrderSpecialInstructions.aon &&
                            SpInstruction != EquityOrderSpecialInstructions.dnr &&
                            SpInstruction != EquityOrderSpecialInstructions.aon_dnr)
                        {
                            error.AppendLine("Limit Order Error : SpInstruction must be none, aon, dnr, aon_dnr.");
                        }
                    }
                    else
                    {
                        order.AppendFormat("~spinstructions{0}={1}", legIdStr, SpInstruction.ToString("g"));
                    }


                    if (this.Action == EquityOrderActions.buy)
                    {
                        orderDescription = string.Format("The {0} order will be executed when the price <= {1}", this.Action.ToString().ToUpper(), this.Price);
                    }
                    else if (this.Action == EquityOrderActions.sell)
                    {
                        orderDescription = string.Format("The {0} order will be executed when the price >= {1}", this.Action.ToString().ToUpper(), this.Price);
                    }
                    
                    confirmMsg = string.Format("Please confirm your {0} {1} order.\r\n\r\nLimit: {2:$0.00##},  Shares: {3:N0}\r\n\r\nEstimated Total: {4:C2}\r\n\r\n{5}", this.OrderType, this.Action, this.Price, this.Quantity, this.Price * this.Quantity, orderDescription);
                    
                    break;

                    #endregion

                case EquityOrderTypes.stop_limit:

                    #region Stop Limit

                    if (Price <= 0 || ActPrice <= 0)
                    {
                        error.AppendLine("Stop Limit Order Error : Price or ActPrice must be a valid value.");
                    }
                    else
                    {
                        order.AppendFormat("~price{0}={1}", legIdStr, Price);
                        order.AppendFormat("~actprice{0}={1}", legIdStr, ActPrice);
                    }

                    if (Expire != EquityOrderExpires.day && Expire != EquityOrderExpires.gtc)
                    {
                        error.AppendLine("Stop Limit Order Error : Expire must be day or gtc.");
                    }
                    else if (Expire != EquityOrderExpires.day && SpInstruction != EquityOrderSpecialInstructions.none)
                    {
                        error.AppendLine("Stop Limit Order Error : SpInstruction must be none.");
                    }
                    else
                    {
                        order.AppendFormat("~spinstructions{0}={1}", legIdStr, SpInstruction.ToString("g"));
                    }


                    if (this.Action == EquityOrderActions.buy)
                    {
                        orderDescription = string.Format("The {0} order will be executed when the stop price >= {2} and then the limt price <= {1}", this.Action.ToString().ToUpper(), this.Price, this.ActPrice);
                    }
                    else if (this.Action == EquityOrderActions.sell)
                    {
                        orderDescription = string.Format("The {0} order will be executed when the stop price <= {2} and then the limit price >= {1}", this.Action.ToString().ToUpper(), this.Price, this.ActPrice);
                    }

                    confirmMsg = string.Format("Please confirm your {0} {1} order.\r\n\r\nLimit: {2:$0.00##}, Stop: {3:$0.00##},  Shares: {4:N0}\r\n\r\nEstimated Total: {5:C2}\r\n\r\n{6}", this.OrderType, this.Action, this.Price, this.ActPrice, this.Quantity, this.Price * this.Quantity, orderDescription);

                    break;

                    #endregion

                case EquityOrderTypes.stop_market:

                    #region Stop Market

                    if (ActPrice <= 0)
                    {
                        error.AppendLine("Stop Market Order Error : ActPrice must be a valid value.");
                    }
                    else
                    {
                        order.AppendFormat("~actprice{0}={1}", legIdStr, ActPrice);
                    }

                    if (Expire != EquityOrderExpires.day && Expire != EquityOrderExpires.gtc)
                    {
                        error.AppendLine("Stop Market Order Error : Expire must be day or gtc.");
                    }


                    if (this.Action == EquityOrderActions.buy)
                    {
                        orderDescription = string.Format("The {0} order will be executed when the market price >= {1}", this.Action.ToString().ToUpper(), this.ActPrice);
                    }
                    else if (this.Action == EquityOrderActions.sell)
                    {
                        orderDescription = string.Format("The {0} order will be executed when the market price <= {1}", this.Action.ToString().ToUpper(), this.ActPrice);
                    }

                    confirmMsg = string.Format("Please confirm your {0} {1} order.\r\n\r\nStop: {2:$0.00##},  Shares: {3:N0}\r\n\r\nEstimated Total: {4:C2}\r\n\r\n{5}", this.OrderType, this.Action, this.ActPrice, this.Quantity, this.ActPrice * this.Quantity, orderDescription);

                    break;

                    #endregion

                case EquityOrderTypes.tstoppercent:

                    #region TsTopPercent

                    if (TsParam < 1 || TsParam > 99)
                    {
                        error.AppendLine("TsTopPercent Order Error : TsParam must be a whole number 1 and 99: 5 means 5 percent (%).");
                    }
                    else
                    {
                        order.AppendFormat("~tsparam{0}={1}", legIdStr, TsParam);
                    }

                    if (Expire != EquityOrderExpires.day && Expire != EquityOrderExpires.gtc)
                    {
                        error.AppendLine("TsTopPercent Order Error : Expire must be day or gtc.");
                    }

                    confirmMsg = string.Format("Please confirm your {0} {1} order.\r\n\r\nTsTopPercent: {2:P2}", this.OrderType, this.Action, Convert.ToDouble(this.ActPrice) / 100.0d);

                    break;

                    #endregion

                case EquityOrderTypes.tstopdollar:

                    #region TsTopDollar

                    if (TsParam <= 0)
                    {
                        error.AppendLine("TsTopPercent Order Error : TsParam must be greater than 0 and a decimal value (#.##).");
                    }
                    else
                    {
                        order.AppendFormat("~tsparam{0}={1}", legIdStr, TsParam);
                    }

                    if (Expire != EquityOrderExpires.day && Expire != EquityOrderExpires.gtc)
                    {
                        error.AppendLine("TsTopPercent Order Error : Expire must be day or gtc.");
                    }

                    confirmMsg = string.Format("Please confirm your {0} {1} order.\r\n\r\nTsTopDollar: {2:$0.00##}", this.OrderType, this.Action, this.ActPrice);

                    break;

                    #endregion

                default:
                    error.AppendLine("Invalid Order Type.");
                    break;
            }
            order.AppendFormat("~expire{0}={1}", legIdStr, Expire.ToString("g"));

            if (ConditionalyOrderType == ConditionalOrderTypes.single)
            {
                order.AppendFormat("~routing{0}={1}", legIdStr, Routing.ToString("g") + "~");
            }

            string errorString = error.ToString();
            if (string.IsNullOrEmpty(errorString))
            {
                this.ConfirmMessage = confirmMsg;
                string orderString = order.ToString();
                return orderString.Replace("~~", "~");
            }
            else
            {
                Error = errorString;
                return errorString;
            }
        }


        #region Static Method Here

        private static List<EquityOrder> _orders = new List<EquityOrder>();

        public static ConditionalOrderTypes ConditionalyOrderType = ConditionalOrderTypes.single;

        public static string AccountIdString
        {
            get
            {
                return string.Format("accountid={0}", TDANET.client.AssociatedAccountId);
            }
        }

        public static void AddOrder(EquityOrder order)
        {
            if (!_orders.Contains(order))
            {
                _orders.Add(order);
            }
        }

        public static void ClearOrders()
        {
            _orders.Clear();   // flush the order;
        }

        public static async Task<EquityOrderResponse> SubmitOrder()
        {
            if (_orders.Count > 0)
            {
                string accountIdStr = string.Format("accountid={0}", TDANET.client.AssociatedAccountId);
                string orderString = accountIdStr;

                if (ConditionalyOrderType == ConditionalOrderTypes.single && _orders.Count == 1)
                {
                    orderString += _orders[0].GetOrderString();
                }
                else
                {
                    // this is for conditional orders
                    orderString += "~ordticket=" + ConditionalyOrderType.ToString("g");
                    orderString += "~totlegs=" + _orders.Count;

                    var orders = _orders.OrderBy(o => o.LegId).ToList();
                    foreach (var order in orders)
                    {
                        orderString += order.GetOrderString();
                    }
                }

                Debug.Print("Order String: {0}", orderString);

                EquityOrderResponse response = await TDANET.SubmitOrder(orderString);

                if (response.Result.ToUpper() == "OK")
                {
                    ConditionalyOrderType = ConditionalOrderTypes.single;
                    ClearOrders(); 
                }
                
                return response;
            }

            return new EquityOrderResponse(){Error = "Order queue is empty"};
        }

        #endregion

    }

    public enum EquityOrderActions
    {
        [Description("Buy")] buy,
        [Description("Sell")] sell,
        [Description("Buy to Cover")] buytocover,
        [Description("Sell Short")] sellshort,
    }

    public enum EquityOrderTypes
    {
        /*
            Market
            Limit
            Stop Loss
            Stop Limit
            Trailing Stop Loss $
            Trailing Stop Loss %
            One Cancels All (OCA)
            One Triggers All (OTA)
            One Triggers Two (OTT)
            One Triggers One Cancels All (OTOCA)
            One Triggers One Triggers All (OTOTA)
        */

        [Description("Limit Order")] limit,
        [Description("Market Order")] market,
        [Description("Stop Market Order")] stop_market,
        [Description("Stop Limit Order")] stop_limit,
        [Description("Top Percent(%) Order")] tstoppercent,
        [Description("Top Dollar($) Order")] tstopdollar,
    }

    public enum ConditionalOrderTypes
    {
        [Description("Single Order")] single,
        [Description("One Cancels All (OCA)")] oca,
        [Description("One Triggers All (OTA)")] ota,
        [Description("One Triggers Two (OTT)")] ott,
        [Description("One Triggers One Cancels All (OTOCA)")] otoca,
        [Description("One Triggers One Triggers All (OTOTA)")] otota
    }

    public enum EquityOrderExpires
    {
        [Description("Market Hours")] day,
        [Description("Market On Close")] moc,
        [Description("Market + Extended Hours")] day_ext,
        [Description("Good to Cancel(Market Hours Only)")] gtc,
        [Description("Good to Cancel(Market + Extended Hours)")] gtc_ext,
        [Description("AM: 8:00AM-9:15AM EST")] am,
        [Description("PM: 4:15PM-8:00PM EST")] pm
    }

    public enum EquityOrderRoutings
    {
        [Description("Auto")] auto,
        [Description("INET")] inet,
        [Description("ECN ARCA")] ecn_arca
    }

    public enum EquityOrderSpecialInstructions
    {
        [Description("None")] none,
        [Description("Fill or Kill")] fok,
        [Description("All or None")] aon,
        [Description("Do Not Reduce")] dnr,
        [Description("AON_DNR")] aon_dnr
    }
}