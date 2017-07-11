using System;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Xml.Linq;

namespace TDAmeritradeNet
{
    public class TDAClient
    {
        public bool IsLoggedIn { get; set; }
        public string Error { get; set; }

        public string SessionId { get; set; }
        public string UserId { get; set; }
        public string CDI { get; set; }
        public int Timeout { get; set; }
        public DateTime LoginTime { get; set; }
        public string AssociatedAccountId { get; set; }
        public string NYSEQuotes { get; set; }
        public string NASDAQQuotes { get; set; }
        public string OPRAQuotes { get; set; }
        public string AMEXQuotes { get; set; }
        public string ExchangeStatus { get; set; }

        public Account AssociatedAccount { get; set; }

        public ReadOnlyCollection<Account> Accounts { get; set; }

        public class Account
        {
            public string AccountId { get; set; }
            public string DisplayName { get; set; }
            public string CDI { get; set; }
            public string Description { get; set; }
            public bool AssociateAccount { get; set; }
            public string Company { get; set; }
            public string Segment { get; set; }
            public bool Unified { get; set; }

            public Preferences AccountPreferences { get; set; }
            public Authorizations AccountAuthorizations { get; set; }

            public class Preferences
            {
                public bool ExpressTrading { get; set; }
                public bool OptionDirectRouting { get; set; }
                public bool StockDirectRouting { get; set; }
            }

            public class Authorizations
            {
                public bool Apex { get; set; }
                public bool Level2 { get; set; }
                public bool StockTrading { get; set; }
                public bool MarginTrading { get; set; }
                public bool StreamingNews { get; set; }
                public string OptionTrading { get; set; }
                public bool Streamer { get; set; }
                public bool AdvancedMargin { get; set; }
            }
        }

        public TDAClient(Stream stream)
        {
            try
            {
                if (stream != null && stream.CanRead)
                {
                    var xml = XDocument.Load(stream).Root;

                    if (xml.Element("result").Value == "OK")
                    {
                        Error = string.Empty;

                        XElement user = xml.Element("xml-log-in");
                        SessionId = user.Element("session-id").Value;
                        UserId = user.Element("user-id").Value;
                        CDI = user.Element("cdi").Value;
                        Timeout = user.Element("timeout").ToInt();
                        LoginTime = user.Element("login-time").ToDate();
                        AssociatedAccountId = user.Element("associated-account-id").Value;
                        NYSEQuotes = user.Element("nyse-quotes").Value;
                        NASDAQQuotes = user.Element("nasdaq-quotes").Value;
                        OPRAQuotes = user.Element("opra-quotes").Value;
                        AMEXQuotes = user.Element("amex-quotes").Value;
                        ExchangeStatus = user.Element("exchange-status").Value;
                        //this.User.Authorizations.Options360 = user.Element("authorizations").Element("options360").ToBoolean();

                        Accounts = new ReadOnlyCollection<Account>(
                            user.Element("accounts").Elements("account").Select(x =>
                                    {
                                        XElement pref = x.Element("preferences");
                                        XElement auth = x.Element("authorizations");

                                        var account = new Account
                                            {
                                                AccountId = x.Element("account-id").Value,
                                                DisplayName = x.Element("display-name").Value,
                                                Description = x.Element("description").Value,
                                                AssociateAccount = x.Element("associated-account").ToBoolean(),
                                                Company = x.Element("company").Value,
                                                Segment = x.Element("segment").Value,
                                                Unified = x.Element("unified").ToBoolean(),
                                                AccountPreferences = new Account.Preferences
                                                    {
                                                        ExpressTrading = pref.Element("express-trading").ToBoolean(),
                                                        OptionDirectRouting = pref.Element("option-direct-routing").ToBoolean(),
                                                        StockDirectRouting = pref.Element("stock-direct-routing").ToBoolean(),
                                                    },
                                                AccountAuthorizations = new Account.Authorizations
                                                    {
                                                        Apex = auth.Element("apex").ToBoolean(),
                                                        Level2 = auth.Element("level2").ToBoolean(),
                                                        StockTrading = auth.Element("stock-trading").ToBoolean(),
                                                        MarginTrading = auth.Element("margin-trading").ToBoolean(),
                                                        StreamingNews = auth.Element("streaming-news").ToBoolean(),
                                                        OptionTrading = auth.Element("option-trading").Value,
                                                        Streamer = auth.Element("streamer").ToBoolean(),
                                                        AdvancedMargin = auth.Element("advanced-margin").ToBoolean(),
                                                    }
                                            };

                                        return account;
                                    }
                                ).ToList()
                            );

                        this.AssociatedAccount = this.Accounts.FirstOrDefault(x => x.AccountId == AssociatedAccountId);

                        IsLoggedIn = !String.IsNullOrEmpty(SessionId);

                        return;
                    }
                    else
                    {
                        IsLoggedIn = false;
                        Error = xml.Element("error").Value;
                    }

                }
            }
            catch (Exception e)
            {
                Error = string.Format("Exception: {0}", e.Message);
                IsLoggedIn = false;
            }
        }

        public void Invalidate()
        {
            IsLoggedIn = false;
        }
    }
}