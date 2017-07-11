using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using TDAmeritradeNet;

namespace XTrader
{
    public partial class ucEquityOrder : UserControl
    {
        private string _symbol;
        private const string _divider = " - ";
        private double _orderPrice = 0;
        private double quantity = 0;
        private double _totalCost = 0;

        public string Symbol
        {
            get { return _symbol; }
            set
            {
                txtSymbol.Text = value;
                txtSymbol_Leave(null, EventArgs.Empty);
            }
        }

        public ucEquityOrder()
        {
            InitializeComponent();

            ResetBasicControls();
            ResetOptionalControls();
        }

        public void CleanResources()
        {
        }

        public void ResetBasicControls()
        {
            // Reset Quantity
            txtQuantity.Text = "0";

            // Reset Order Actions
            cmbActions.Items.Clear();
            IEnumerable<EquityOrderActions> actions = EnumHelper.ToList<EquityOrderActions>();
            foreach (var action in actions)
            {
                cmbActions.Items.Add(action);
            }
            cmbActions.Text = string.Empty;
            cmbActions.SelectedItem = null;

            // Reset Order Types
            cmbOrderTypes.Items.Clear();
            IEnumerable<EquityOrderTypes> orderTypes = EnumHelper.ToList<EquityOrderTypes>();
            foreach (var orderType in orderTypes)
            {
                cmbOrderTypes.Items.Add(orderType);
            }
            cmbOrderTypes.Text = string.Empty;
            cmbOrderTypes.SelectedItem = null;
        }

        private async void bttnSubmit_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(_symbol))
            {
                MessageBox.Show("The symbols is empty", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            if (cmbActions.SelectedItem == null ||
                cmbOrderTypes.SelectedItem == null)
            {
                MessageBox.Show("Please select an action and order type", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            string symbol = _symbol;
            int quantity = (!string.IsNullOrEmpty(txtQuantity.Text)) ? Convert.ToInt32(txtQuantity.Text.Trim()) : 0;
            EquityOrderActions action = (cmbActions.SelectedItem != null) ? (EquityOrderActions) cmbActions.SelectedItem : EquityOrderActions.buy;
            EquityOrderTypes orderType = (cmbOrderTypes.SelectedItem != null) ? (EquityOrderTypes) cmbOrderTypes.SelectedItem : EquityOrderTypes.market;
            EquityOrderExpires expire = (cmbExpires.SelectedItem != null) ? (EquityOrderExpires) cmbExpires.SelectedItem : EquityOrderExpires.day;
            EquityOrderSpecialInstructions spInst = (cmbSpInstructions.SelectedItem != null) ? (EquityOrderSpecialInstructions) cmbSpInstructions.SelectedItem : EquityOrderSpecialInstructions.none;
            float price = (!string.IsNullOrEmpty(txtPrice.Text)) ? Convert.ToSingle(txtPrice.Text.Trim()) : 0;
            float actPrice = (!string.IsNullOrEmpty(txtActPrice.Text)) ? Convert.ToSingle(txtActPrice.Text.Trim()) : 0;

            // Check if quantity is greater than 0
            if (quantity == 0)
            {
                MessageBox.Show("Quantity must be greater than 0.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }


            var newOrder = new EquityOrder(symbol, quantity, action, orderType);

            string orderDescription = string.Empty;

            string confirmMsg = string.Empty;

            switch (orderType)
            {
                case EquityOrderTypes.market:
                    newOrder.Expire = expire;
                    newOrder.SpInstruction = spInst;

                    break;

                case EquityOrderTypes.limit:
                    newOrder.Price = price;
                    newOrder.Expire = expire;
                    newOrder.SpInstruction = spInst;

                    break;

                case EquityOrderTypes.stop_limit:
                    newOrder.Price = price;
                    newOrder.ActPrice = actPrice;
                    newOrder.Expire = expire;

                    break;

                case EquityOrderTypes.stop_market:
                    newOrder.ActPrice = actPrice;
                    newOrder.Expire = expire;

                    break;

                case EquityOrderTypes.tstopdollar:
                    float dollar = Convert.ToSingle(txtTsParam.Text.Trim());
                    newOrder.TsParam = dollar;
                    newOrder.Expire = expire;

                    break;

                case EquityOrderTypes.tstoppercent:
                    int percent = Convert.ToInt32(txtTsParam.Text.Trim());
                    newOrder.TsParam = percent;
                    newOrder.Expire = expire;

                    break;
            }

            string orderString = EquityOrder.AccountIdString + newOrder.GetOrderString();

            if (newOrder.Validate())
            {
                Debug.Print(orderString);

                var result = MessageBox.Show(newOrder.ConfirmMessage, "Confirm Order", MessageBoxButtons.YesNo, MessageBoxIcon.Asterisk, MessageBoxDefaultButton.Button2);

                if (result == DialogResult.Yes)
                {
                    EquityOrder.AddOrder(newOrder);

                    EquityOrderResponse response = await EquityOrder.SubmitOrder();

                    if (!string.IsNullOrEmpty(response.Error))
                    {
                        MessageBox.Show(response.Error, "Server Response", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        return;
                    }
                    else
                    {
                        MessageBox.Show("The order submitted successfully.\r\nOrder Id: " + response.OrderId, "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
                        ResetBasicControls();
                        ResetOptionalControls();
                        return;
                    }
                }
                else
                {
                    return;
                }
            }
            else
            {
                MessageBox.Show(orderString, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }

        private void ResetOptionalControls()
        {
            // Reset Price
            lblPrice.Visible = false;
            txtPrice.Text = "0";
            txtPrice.Visible = false;


            // Reset ActPrice
            lblActPrice.Visible = false;
            txtActPrice.Text = "0";
            txtActPrice.Visible = false;


            // Reset TsParam
            lblTsParam.Visible = false;
            txtTsParam.Text = "0";
            txtTsParam.Visible = false;


            // Reset Expires
            lblExpire.Visible = false;
            cmbExpires.Items.Clear();
            cmbExpires.Text = string.Empty;
            cmbExpires.Visible = false;


            // Reset SpInstructions
            lblSpInstruction.Visible = false;
            cmbSpInstructions.Items.Clear();
            cmbSpInstructions.Text = string.Empty;
            cmbSpInstructions.Visible = false;

            // Reset Submit Button
            bttnSubmit.Visible = false;
        }

        private void cmbOrderTypes_SelectedIndexChanged(object sender, EventArgs e)
        {
            object selectedItem = ((ComboBox) sender).SelectedItem;

            if (selectedItem != null)
            {
                ResetOptionalControls();

                var orderType = (EquityOrderTypes) selectedItem;

                switch (orderType)
                {
                    case EquityOrderTypes.market:
                        lblPrice.Visible = false;
                        txtPrice.Visible = false;

                        lblActPrice.Visible = false;
                        txtActPrice.Visible = false;

                        lblExpire.Visible = true;
                        cmbExpires.Visible = true;
                        cmbExpires.Items.Clear();
                        cmbExpires.Items.Add(EquityOrderExpires.day);
                        cmbExpires.Items.Add(EquityOrderExpires.moc);
                        cmbExpires.SelectedItem = EquityOrderExpires.day;

                        lblSpInstruction.Visible = true;
                        cmbSpInstructions.Visible = true;
                        cmbSpInstructions.Items.Clear();
                        cmbSpInstructions.Items.Add(EquityOrderSpecialInstructions.none);
                        cmbSpInstructions.SelectedItem = EquityOrderSpecialInstructions.none;

                        break;


                    case EquityOrderTypes.limit:

                        lblPrice.Visible = true;
                        txtPrice.Visible = true;

                        lblExpire.Visible = true;
                        cmbExpires.Visible = true;
                        cmbExpires.Items.Clear();
                        cmbExpires.Items.Add(EquityOrderExpires.day);
                        cmbExpires.Items.Add(EquityOrderExpires.day_ext);
                        cmbExpires.Items.Add(EquityOrderExpires.gtc);
                        cmbExpires.Items.Add(EquityOrderExpires.gtc_ext);
                        cmbExpires.Items.Add(EquityOrderExpires.am);
                        cmbExpires.Items.Add(EquityOrderExpires.pm);
                        cmbExpires.SelectedItem = EquityOrderExpires.day;

                        lblSpInstruction.Visible = true;
                        cmbSpInstructions.Visible = true;
                        cmbSpInstructions.Items.Clear();
                        IEnumerable<EquityOrderSpecialInstructions> spInstructions = EnumHelper.ToList<EquityOrderSpecialInstructions>();
                        foreach (var inst in spInstructions)
                        {
                            cmbSpInstructions.Items.Add(inst);
                        }
                        cmbSpInstructions.SelectedItem = EquityOrderSpecialInstructions.none;

                        break;


                    case EquityOrderTypes.stop_limit:

                        lblPrice.Visible = true;
                        txtPrice.Visible = true;

                        lblActPrice.Visible = true;
                        txtActPrice.Visible = true;

                        lblExpire.Visible = true;
                        cmbExpires.Visible = true;
                        cmbExpires.Items.Clear();
                        cmbExpires.Items.Add(EquityOrderExpires.day);
                        cmbExpires.Items.Add(EquityOrderExpires.gtc);
                        cmbExpires.SelectedItem = EquityOrderExpires.day;

                        break;


                    case EquityOrderTypes.stop_market:
                        lblActPrice.Visible = true;
                        txtActPrice.Visible = true;

                        lblExpire.Visible = true;
                        cmbExpires.Visible = true;
                        cmbExpires.Items.Clear();
                        cmbExpires.Items.Add(EquityOrderExpires.day);
                        cmbExpires.Items.Add(EquityOrderExpires.gtc);
                        cmbExpires.SelectedItem = EquityOrderExpires.day;

                        break;


                    case EquityOrderTypes.tstopdollar:
                        lblTsParam.Visible = true;
                        txtTsParam.Visible = true;

                        lblExpire.Visible = true;
                        cmbExpires.Visible = true;
                        cmbExpires.Items.Clear();
                        cmbExpires.Items.Add(EquityOrderExpires.day);
                        cmbExpires.Items.Add(EquityOrderExpires.gtc);
                        cmbExpires.SelectedItem = EquityOrderExpires.day;

                        break;


                    case EquityOrderTypes.tstoppercent:
                        lblTsParam.Visible = true;
                        txtTsParam.Visible = true;

                        lblExpire.Visible = true;
                        cmbExpires.Visible = true;
                        cmbExpires.Items.Clear();
                        cmbExpires.Items.Add(EquityOrderExpires.day);
                        cmbExpires.Items.Add(EquityOrderExpires.gtc);
                        cmbExpires.SelectedItem = EquityOrderExpires.day;

                        break;
                }

                bttnSubmit.Visible = true;
            }
        }

        private async void txtSymbol_Leave(object sender, EventArgs e)
        {
            _symbol = txtSymbol.Text.ToUpper();
        }

        private void txtSymbol_TextChanged(object sender, EventArgs e)
        {

        }

        public void ClearPanel()
        {
            bttnClear_Click(null, EventArgs.Empty);
        }

        private void bttnClear_Click(object sender, EventArgs e)
        {
            _symbol = string.Empty;
            txtSymbol.Text = string.Empty;

            ResetBasicControls();
            ResetOptionalControls();

            txtSymbol.Focus();
        }

        private void txtQuantity_TextChanged(object sender, EventArgs e)
        {

        }

        private void txtSymbol_DragDrop(object sender, DragEventArgs e)
        {

        }

        private void ucEquityOrder_DragDrop(object sender, DragEventArgs e)
        {
        }

        private void ucEquityOrder_DragEnter(object sender, DragEventArgs e)
        {
            // change the mouse cursor
            e.Effect = DragDropEffects.All;
        }

        private void txtQuickLimitBuy_TextChanged(object sender, EventArgs e)
        {

        }

        // find focused control currently
        private static Control FindFocusedControl(Control control)
        {
            var container = control as ContainerControl;
            while (container != null)
            {
                control = container.ActiveControl;
                container = control as ContainerControl;
            }
            return control;
        }

        private void txtPrice_TextChanged(object sender, EventArgs e)
        {

        }

        private void UpdateTotal()
        {

        }

        private void txtActPrice_TextChanged(object sender, EventArgs e)
        {

        }

        private void lblCost_MouseHover(object sender, EventArgs e)
        {

        }

        private void lblCost_MouseLeave(object sender, EventArgs e)
        {
            // hide display
        }


        private void ucEquityOrder_MouseLeave(object sender, EventArgs e)
        {

        }
    }
}