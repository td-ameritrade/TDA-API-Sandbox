using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using TechTrader.Sources;

namespace TechTrader.TDA
{
    public partial class Login : Form
    {
        private TDAmeritrade a;

        public Login(TDAmeritrade a)
        {
            this.a = a;
            InitializeComponent();
            CenterToParent();
            BringToFront();
            Focus();

            username.KeyDown += new KeyEventHandler(KeyRead);
            password.KeyDown += new KeyEventHandler(KeyRead);
            sourceid.KeyDown += new KeyEventHandler(KeyRead);
            equities.KeyDown += new KeyEventHandler(KeyRead);
            options.KeyDown += new KeyEventHandler(KeyRead);
            autoClose.KeyDown += new KeyEventHandler(KeyRead);
            spread.KeyDown += new KeyEventHandler(KeyRead);
            expir.KeyDown += new KeyEventHandler(KeyRead);

            username.Text = a.get("TDA_Username");
            password.Text = a.get("TDA_Password");
            sourceid.Text = a.get("TDA_SourceID");
            equities.Checked = a.get("TDA_Equities?") == "true";
            options.Checked = a.get("TDA_Options?") == "true";
            autoClose.Checked = a.get("TDA_AutoClose?") == "true";
            if (a.get("TDA_Spread") != "") spread.Value = Convert.ToDecimal(a.get("TDA_Spread"));
            if (a.get("TDA_Expiration") != "") expir.Value = Convert.ToDecimal(a.get("TDA_Expiration"));
            if (a.get("TDA_FeePerStockTrade") != "") perStockTradeFee.Value = Convert.ToDecimal(a.get("TDA_FeePerStockTrade"));
            if (a.get("TDA_FeePerOptionTrade") != "") perOptionTradeFee.Value = Convert.ToDecimal(a.get("TDA_FeePerOptionTrade"));
            if (a.get("TDA_FeePerOptionContract") != "") perOptionContractFee.Value = Convert.ToDecimal(a.get("TDA_FeePerOptionContract"));

            ActiveControl = username;
        }

        private void KeyRead(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                Log_Click(null, null);
            }
        }

        private void cancel_Click(object sender, EventArgs e)
        {
            save();
            this.DialogResult = DialogResult.Cancel;
            Close();
        }

        private void Log_Click(object sender, EventArgs e)
        {
            save();
            TDAmeritrade.setLogin(username.Text, password.Text, sourceid.Text, equities.Checked, options.Checked, (int)spread.Value, (int)expir.Value, autoClose.Checked, (double)perStockTradeFee.Value, (double)perOptionTradeFee.Value, (double)perOptionContractFee.Value);
            this.DialogResult = DialogResult.OK;
            Close();
        }

        private void save()
        {
            a.set("TDA_Username", username.Text);
            a.set("TDA_Password", password.Text);
            a.set("TDA_SourceID", sourceid.Text);
            a.set("TDA_Equities?", equities.Checked ? "true" : "false");
            a.set("TDA_Options?", options.Checked ? "true" : "false");
            a.set("TDA_AutoClose?", autoClose.Checked ? "true" : "false");
            a.set("TDA_Spread", spread.Value.ToString());
            a.set("TDA_Expiration", expir.Value.ToString());
            a.set("TDA_FeePerStockTrade", perStockTradeFee.Value.ToString());
            a.set("TDA_FeePerOptionTrade", perOptionTradeFee.Value.ToString());
            a.set("TDA_FeePerOptionContract", perOptionContractFee.Value.ToString());
        }
    }
}
