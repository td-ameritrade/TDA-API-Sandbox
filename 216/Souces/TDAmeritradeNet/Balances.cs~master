using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace TDAmeritradeNet
{
    public class Balances
    {
        Dictionary<string, string> balances = new Dictionary<string, string>();

        #region Balance Properties

        public string AmtdResult
        {
            get
            {
                if (balances.ContainsKey("amtd-result"))
                {
                    return balances["amtd-result"];
                }
                return string.Empty;
            }
        }

        public string BalanceError
        {
            get
            {
                if (balances.ContainsKey("balance-error"))
                {
                    return balances["balance-error"];
                }
                return string.Empty;
            }
        }

        [Description("Balance Account Id")]
        public string BalanceAccountId
        {
            get
            {
                if (balances.ContainsKey("balance-account-id"))
                {
                    return balances["balance-account-id"];
                }
                return string.Empty;
            }
        }

        [Description("Is Daytrader")]
        public bool BalanceDayTrader
        {
            get
            {
                if (balances.ContainsKey("balance-day-trader"))
                {
                    return Convert.ToBoolean(balances["balance-day-trader"]);
                }
                return false;
            }
        }

        [Description("Round Trips Count")]
        public int BalanceRoundTrips
        {
            get
            {
                if (balances.ContainsKey("balance-round-trips"))
                {
                    return Convert.ToInt32(balances["balance-round-trips"]);
                }
                return 0;
            }
        }

        public bool BalanceRestictedClosingTransactionsOnly
        {
            get
            {
                if (balances.ContainsKey("balance-resticted-closing-transactions-only"))
                {
                    return Convert.ToBoolean(balances["balance-resticted-closing-transactions-only"]);
                }
                return false;
            }
        }

        public float CashBalanceInitial
        {
            get
            {
                if (balances.ContainsKey("cash-balance-initial"))
                {
                    return Convert.ToSingle(balances["cash-balance-initial"]);
                }
                return 0;
            }
        }

        [Description("Cash Balance")]
        public float CashBalanceCurrent
        {
            get
            {
                if (balances.ContainsKey("cash-balance-current"))
                {
                    return Convert.ToSingle(balances["cash-balance-current"]);
                }
                return 0;
            }
        }

        public float CashBalanceChange
        {
            get
            {
                if (balances.ContainsKey("cash-balance-change"))
                {
                    return Convert.ToSingle(balances["cash-balance-change"]);
                }
                return 0;
            }
        }

        public float MoneyMarketBalanceInitial
        {
            get
            {
                if (balances.ContainsKey("money-market-balance-initial"))
                {
                    return Convert.ToSingle(balances["money-market-balance-initial"]);
                }
                return 0;
            }
        }

        [Description("Money Market Balance")]
        public float MoneyMarketBalanceCurrent
        {
            get
            {
                if (balances.ContainsKey("money-market-balance-current"))
                {
                    return Convert.ToSingle(balances["money-market-balance-current"]);
                }
                return 0;
            }
        }

        public float MoneyMarketBalanceChange
        {
            get
            {
                if (balances.ContainsKey("money-market-balance-change"))
                {
                    return Convert.ToSingle(balances["money-market-balance-change"]);
                }
                return 0;
            }
        }

        [Description("Saving Balance")]
        public float SavingsBalanceCurrent
        {
            get
            {
                if (balances.ContainsKey("savings-balance-current"))
                {
                    return Convert.ToSingle(balances["savings-balance-current"]);
                }
                return 0;
            }
        }

        public float LongStockValueInitial
        {
            get
            {
                if (balances.ContainsKey("long-stock-value-initial"))
                {
                    return Convert.ToSingle(balances["long-stock-value-initial"]);
                }
                return 0;
            }
        }

        [Description("Long Stock Value")]
        public float LongStockValueCurrent
        {
            get
            {
                if (balances.ContainsKey("long-stock-value-current"))
                {
                    return Convert.ToSingle(balances["long-stock-value-current"]);
                }
                return 0;
            }
        }

        public float LongStockValueChange
        {
            get
            {
                if (balances.ContainsKey("long-stock-value-change"))
                {
                    return Convert.ToSingle(balances["long-stock-value-change"]);
                }
                return 0;
            }
        }

        public float LongOptionValueInitial
        {
            get
            {
                if (balances.ContainsKey("long-option-value-initial"))
                {
                    return Convert.ToSingle(balances["long-option-value-initial"]);
                }
                return 0;
            }
        }

        [Description("Long Option Value")]
        public float LongOptionValueCurrent
        {
            get
            {
                if (balances.ContainsKey("long-option-value-current"))
                {
                    return Convert.ToSingle(balances["long-option-value-current"]);
                }
                return 0;
            }
        }

        public float LongOptionValueChange
        {
            get
            {
                if (balances.ContainsKey("long-option-value-change"))
                {
                    return Convert.ToSingle(balances["long-option-value-change"]);
                }
                return 0;
            }
        }

        public float ShortOptionValueInitial
        {
            get
            {
                if (balances.ContainsKey("short-option-value-initial"))
                {
                    return Convert.ToSingle(balances["short-option-value-initial"]);
                }
                return 0;
            }
        }

        [Description("Short Option Value")]
        public float ShortOptionValueCurrent
        {
            get
            {
                if (balances.ContainsKey("short-option-value-current"))
                {
                    return Convert.ToSingle(balances["short-option-value-current"]);
                }
                return 0;
            }
        }

        public float ShortOptionValueChange
        {
            get
            {
                if (balances.ContainsKey("short-option-value-change"))
                {
                    return Convert.ToSingle(balances["short-option-value-change"]);
                }
                return 0;
            }
        }

        public float MutualFundValueInitial
        {
            get
            {
                if (balances.ContainsKey("mutual-fund-value-initial"))
                {
                    return Convert.ToSingle(balances["mutual-fund-value-initial"]);
                }
                return 0;
            }
        }

        [Description("Mutual Fund Value")]
        public float MutualFundValueCurrent
        {
            get
            {
                if (balances.ContainsKey("mutual-fund-value-current"))
                {
                    return Convert.ToSingle(balances["mutual-fund-value-current"]);
                }
                return 0;
            }
        }

        public float MutualFundValueChange
        {
            get
            {
                if (balances.ContainsKey("mutual-fund-value-change"))
                {
                    return Convert.ToSingle(balances["mutual-fund-value-change"]);
                }
                return 0;
            }
        }

        public float BondValueInitial
        {
            get
            {
                if (balances.ContainsKey("bond-value-initial"))
                {
                    return Convert.ToSingle(balances["bond-value-initial"]);
                }
                return 0;
            }
        }

        [Description("Bond Value")]
        public float BondValueCurrent
        {
            get
            {
                if (balances.ContainsKey("bond-value-current"))
                {
                    return Convert.ToSingle(balances["bond-value-current"]);
                }
                return 0;
            }
        }

        public float BondValueChange
        {
            get
            {
                if (balances.ContainsKey("bond-value-change"))
                {
                    return Convert.ToSingle(balances["bond-value-change"]);
                }
                return 0;
            }
        }

        public float AccountValueInitial
        {
            get
            {
                if (balances.ContainsKey("account-value-initial"))
                {
                    return Convert.ToSingle(balances["account-value-initial"]);
                }
                return 0;
            }
        }

        [Description("Account Value")]
        public float AccountValueCurrent
        {
            get
            {
                if (balances.ContainsKey("account-value-current"))
                {
                    return Convert.ToSingle(balances["account-value-current"]);
                }
                return 0;
            }
        }

        public float AccountValueChange
        {
            get
            {
                if (balances.ContainsKey("account-value-change"))
                {
                    return Convert.ToSingle(balances["account-value-change"]);
                }
                return 0;
            }
        }

        public float PendingDepositsInitial
        {
            get
            {
                if (balances.ContainsKey("pending-deposits-initial"))
                {
                    return Convert.ToSingle(balances["pending-deposits-initial"]);
                }
                return 0;
            }
        }

        [Description("Pending Deposit")]
        public float PendingDepositsCurrent
        {
            get
            {
                if (balances.ContainsKey("pending-deposits-current"))
                {
                    return Convert.ToSingle(balances["pending-deposits-current"]);
                }
                return 0;
            }
        }

        public float PendingDepositsChange
        {
            get
            {
                if (balances.ContainsKey("pending-deposits-change"))
                {
                    return Convert.ToSingle(balances["pending-deposits-change"]);
                }
                return 0;
            }
        }

        public bool BalanceInCall
        {
            get
            {
                if (balances.ContainsKey("balance-in-call"))
                {
                    return Convert.ToBoolean(balances["balance-in-call"]);
                }
                return false;
            }
        }

        public bool BalanceInPotentialCall
        {
            get
            {
                if (balances.ContainsKey("balance-in-potential-call"))
                {
                    return Convert.ToBoolean(balances["balance-in-potential-call"]);
                }
                return false;
            }
        }

        public float ShortBalanceInitial
        {
            get
            {
                if (balances.ContainsKey("short-balance-initial"))
                {
                    return Convert.ToSingle(balances["short-balance-initial"]);
                }
                return 0;
            }
        }

        [Description("Short Balance")]
        public float ShortBalanceCurrent
        {
            get
            {
                if (balances.ContainsKey("short-balance-current"))
                {
                    return Convert.ToSingle(balances["short-balance-current"]);
                }
                return 0;
            }
        }

        public float ShortBalanceChange
        {
            get
            {
                if (balances.ContainsKey("short-balance-change"))
                {
                    return Convert.ToSingle(balances["short-balance-change"]);
                }
                return 0;
            }
        }

        public float MarginBalanceInitial
        {
            get
            {
                if (balances.ContainsKey("margin-balance-initial"))
                {
                    return Convert.ToSingle(balances["margin-balance-initial"]);
                }
                return 0;
            }
        }

        [Description("Margin Balance")]
        public float MarginBalanceCurrent
        {
            get
            {
                if (balances.ContainsKey("margin-balance-current"))
                {
                    return Convert.ToSingle(balances["margin-balance-current"]);
                }
                return 0;
            }
        }

        public float MarginBalanceChange
        {
            get
            {
                if (balances.ContainsKey("margin-balance-change"))
                {
                    return Convert.ToSingle(balances["margin-balance-change"]);
                }
                return 0;
            }
        }

        
        public float ShortStockValueInitial
        {
            get
            {
                if (balances.ContainsKey("short-stock-value-initial"))
                {
                    return Convert.ToSingle(balances["short-stock-value-initial"]);
                }
                return 0;
            }
        }

        [Description("Short Stock Value")]
        public float ShortStockValueCurrent
        {
            get
            {
                if (balances.ContainsKey("short-stock-value-current"))
                {
                    return Convert.ToSingle(balances["short-stock-value-current"]);
                }
                return 0;
            }
        }

        public float ShortStockValueChange
        {
            get
            {
                if (balances.ContainsKey("short-stock-value-change"))
                {
                    return Convert.ToSingle(balances["short-stock-value-change"]);
                }
                return 0;
            }
        }

        public float LongMarginableValueInitial
        {
            get
            {
                if (balances.ContainsKey("long-marginable-value-initial"))
                {
                    return Convert.ToSingle(balances["long-marginable-value-initial"]);
                }
                return 0;
            }
        }

        [Description("Long Marginable Value")]
        public float LongMarginableValueCurrent
        {
            get
            {
                if (balances.ContainsKey("long-marginable-value-current"))
                {
                    return Convert.ToSingle(balances["long-marginable-value-current"]);
                }
                return 0;
            }
        }

        public float LongMarginableValueChange
        {
            get
            {
                if (balances.ContainsKey("long-marginable-value-change"))
                {
                    return Convert.ToSingle(balances["long-marginable-value-change"]);
                }
                return 0;
            }
        }

        public float ShortMarginableValueInitial
        {
            get
            {
                if (balances.ContainsKey("short-marginable-value-initial"))
                {
                    return Convert.ToSingle(balances["short-marginable-value-initial"]);
                }
                return 0;
            }
        }

        [Description("Short Marginable Value")]
        public float ShortMarginableValueCurrent
        {
            get
            {
                if (balances.ContainsKey("short-marginable-value-current"))
                {
                    return Convert.ToSingle(balances["short-marginable-value-current"]);
                }
                return 0;
            }
        }

        public float ShortMarginableValueChange
        {
            get
            {
                if (balances.ContainsKey("short-marginable-value-change"))
                {
                    return Convert.ToSingle(balances["short-marginable-value-change"]);
                }
                return 0;
            }
        }

        public float MarginEquityInitial
        {
            get
            {
                if (balances.ContainsKey("margin-equity-initial"))
                {
                    return Convert.ToSingle(balances["margin-equity-initial"]);
                }
                return 0;
            }
        }

        [Description("Margin Equity")]
        public float MarginEquityCurrent
        {
            get
            {
                if (balances.ContainsKey("margin-equity-current"))
                {
                    return Convert.ToSingle(balances["margin-equity-current"]);
                }
                return 0;
            }
        }

        public float MarginEquityChange
        {
            get
            {
                if (balances.ContainsKey("margin-equity-change"))
                {
                    return Convert.ToSingle(balances["margin-equity-change"]);
                }
                return 0;
            }
        }

        public float EquityPercentageInitial
        {
            get
            {
                if (balances.ContainsKey("equity-percentage-initial"))
                {
                    return Convert.ToSingle(balances["equity-percentage-initial"]);
                }
                return 0;
            }
        }

        [Description("Equity Percentage")]
        public float EquityPercentageCurrent
        {
            get
            {
                if (balances.ContainsKey("equity-percentage-current"))
                {
                    return Convert.ToSingle(balances["equity-percentage-current"]);
                }
                return 0;
            }
        }

        public float EquityPercentageChange
        {
            get
            {
                if (balances.ContainsKey("equity-percentage-change"))
                {
                    return Convert.ToSingle(balances["equity-percentage-change"]);
                }
                return 0;
            }
        }

        [Description("Option Buying Power")]
        public float BalanceOptionBuyingPower
        {
            get
            {
                if (balances.ContainsKey("balance-option-buying-power"))
                {
                    return Convert.ToSingle(balances["balance-option-buying-power"]);
                }
                return 0;
            }
        }

        [Description("Stock Buying Power")]
        public float BalanceStockBuyingPower
        {
            get
            {
                if (balances.ContainsKey("balance-stock-buying-power"))
                {
                    return Convert.ToSingle(balances["balance-stock-buying-power"]);
                }
                return 0;
            }
        }

        [Description("Day Trading Buying Power")]
        public float BalanceDayTradingBuyingPower
        {
            get
            {
                if (balances.ContainsKey("balance-day-trading-buying-power"))
                {
                    return Convert.ToSingle(balances["balance-day-trading-buying-power"]);
                }
                return 0;
            }
        }

        [Description("Available Funds for Trading")]
        public float BalanceAvailableFundsForTrading
        {
            get
            {
                if (balances.ContainsKey("balance-available-funds-for-trading"))
                {
                    return Convert.ToSingle(balances["balance-available-funds-for-trading"]);
                }
                return 0;
            }
        }

        public float MaintenanceRequirementInitial
        {
            get
            {
                if (balances.ContainsKey("maintenance-requirement-initial"))
                {
                    return Convert.ToSingle(balances["maintenance-requirement-initial"]);
                }
                return 0;
            }
        }

        [Description("Maintenance Requirement")]
        public float MaintenanceRequirementCurrent
        {
            get
            {
                if (balances.ContainsKey("maintenance-requirement-current"))
                {
                    return Convert.ToSingle(balances["maintenance-requirement-current"]);
                }
                return 0;
            }
        }

        public float MaintenanceRequirementChange
        {
            get
            {
                if (balances.ContainsKey("maintenance-requirement-change"))
                {
                    return Convert.ToSingle(balances["maintenance-requirement-change"]);
                }
                return 0;
            }
        }

        public float MaintenanceCallValueInitial
        {
            get
            {
                if (balances.ContainsKey("maintenance-call-value-initial"))
                {
                    return Convert.ToSingle(balances["maintenance-call-value-initial"]);
                }
                return 0;
            }
        }

        public float MaintenanceCallValueCurrent
        {
            get
            {
                if (balances.ContainsKey("maintenance-call-value-current"))
                {
                    return Convert.ToSingle(balances["maintenance-call-value-current"]);
                }
                return 0;
            }
        }

        public float MaintenanceCallValuePotential
        {
            get
            {
                if (balances.ContainsKey("maintenance-call-value-potential"))
                {
                    return Convert.ToSingle(balances["maintenance-call-value-potential"]);
                }
                return 0;
            }
        }

        public float RegulationTCallValueInitial
        {
            get
            {
                if (balances.ContainsKey("regulation-t-call-value-initial"))
                {
                    return Convert.ToSingle(balances["regulation-t-call-value-initial"]);
                }
                return 0;
            }
        }

        public float RegulationTCallValueCurrent
        {
            get
            {
                if (balances.ContainsKey("regulation-t-call-value-current"))
                {
                    return Convert.ToSingle(balances["regulation-t-call-value-current"]);
                }
                return 0;
            }
        }

        public float RegulationTCallValuePotential
        {
            get
            {
                if (balances.ContainsKey("regulation-t-call-value-potential"))
                {
                    return Convert.ToSingle(balances["regulation-t-call-value-potential"]);
                }
                return 0;
            }
        }

        public float DayTradingCallValuePotential
        {
            get
            {
                if (balances.ContainsKey("day-trading-call-value-potential"))
                {
                    return Convert.ToSingle(balances["day-trading-call-value-potential"]);
                }
                return 0;
            }
        }

        public float DayTradingCallValueInitial
        {
            get
            {
                if (balances.ContainsKey("day-trading-call-value-initial"))
                {
                    return Convert.ToSingle(balances["day-trading-call-value-initial"]);
                }
                return 0;
            }
        }

        public float BalanceDayEquityCallValue
        {
            get
            {
                if (balances.ContainsKey("balance-day-equity-call-value"))
                {
                    return Convert.ToSingle(balances["balance-day-equity-call-value"]);
                }
                return 0;
            }
        }

        #endregion

        public Balances()
        {
            // empty
        }

        public Balances(Stream stream)
        {
            balances = XmlToDictionary.StreamToDictionary2(stream);
        }

        public IDictionary<string, string> GetProperties()
        {
            var results2 = new Dictionary<string, string>();

            var properties = this.GetType().GetProperties();
            foreach (var p in properties)
            {
                if (p.CustomAttributes.Any())
                {
                    // Get property description
                    Attribute attr = p.GetCustomAttribute(typeof (DescriptionAttribute));
                    string description = ((DescriptionAttribute) attr).Description;

                    // get property value
                    object v = p.GetValue(this, null);
                    string valueString = string.Empty;
                    if (v.GetType() == typeof (string))
                    {
                        valueString = v.ToString();
                    }
                    else if (v.GetType() == typeof (bool))
                    {
                        valueString = v.ToString();
                    }
                    else if (v.GetType() == typeof(int))
                    {
                        valueString = Convert.ToInt32(v).ToString("N0");
                    }
                    else if (description.ToLower().Contains("percentage"))
                    {
                        valueString = (Convert.ToSingle(v)/100f).ToString("P2");
                    }
                    else
                    {
                        valueString = Convert.ToSingle(v).ToString("C2");
                    }

                    results2.Add(description, valueString);
                }
            }
            
            return results2;
        }
    }
}
