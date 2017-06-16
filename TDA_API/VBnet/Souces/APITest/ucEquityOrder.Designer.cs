namespace XTrader
{
    partial class ucEquityOrder
    {
        /// <summary> 
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary> 
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            CleanResources();

            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.cmbActions = new System.Windows.Forms.ComboBox();
            this.lblAction = new System.Windows.Forms.Label();
            this.txtQuantity = new System.Windows.Forms.TextBox();
            this.lblQuantity = new System.Windows.Forms.Label();
            this.cmbOrderTypes = new System.Windows.Forms.ComboBox();
            this.lblOrderType = new System.Windows.Forms.Label();
            this.lblSymbol = new System.Windows.Forms.Label();
            this.txtSymbol = new System.Windows.Forms.TextBox();
            this.lblPrice = new System.Windows.Forms.Label();
            this.txtPrice = new System.Windows.Forms.TextBox();
            this.lblActPrice = new System.Windows.Forms.Label();
            this.txtActPrice = new System.Windows.Forms.TextBox();
            this.lblTsParam = new System.Windows.Forms.Label();
            this.txtTsParam = new System.Windows.Forms.TextBox();
            this.lblSpInstruction = new System.Windows.Forms.Label();
            this.cmbSpInstructions = new System.Windows.Forms.ComboBox();
            this.lblExpire = new System.Windows.Forms.Label();
            this.cmbExpires = new System.Windows.Forms.ComboBox();
            this.bttnSubmit = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // cmbActions
            // 
            this.cmbActions.BackColor = System.Drawing.Color.White;
            this.cmbActions.Font = new System.Drawing.Font("Verdana", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.cmbActions.FormattingEnabled = true;
            this.cmbActions.ImeMode = System.Windows.Forms.ImeMode.Disable;
            this.cmbActions.Location = new System.Drawing.Point(90, 30);
            this.cmbActions.Name = "cmbActions";
            this.cmbActions.Size = new System.Drawing.Size(122, 21);
            this.cmbActions.TabIndex = 1;
            // 
            // lblAction
            // 
            this.lblAction.AutoSize = true;
            this.lblAction.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblAction.ForeColor = System.Drawing.Color.Black;
            this.lblAction.Location = new System.Drawing.Point(10, 34);
            this.lblAction.Name = "lblAction";
            this.lblAction.Size = new System.Drawing.Size(78, 15);
            this.lblAction.TabIndex = 1;
            this.lblAction.Text = "Order Action:";
            // 
            // txtQuantity
            // 
            this.txtQuantity.BackColor = System.Drawing.Color.White;
            this.txtQuantity.Font = new System.Drawing.Font("Verdana", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtQuantity.ImeMode = System.Windows.Forms.ImeMode.Disable;
            this.txtQuantity.Location = new System.Drawing.Point(90, 74);
            this.txtQuantity.Name = "txtQuantity";
            this.txtQuantity.Size = new System.Drawing.Size(103, 21);
            this.txtQuantity.TabIndex = 3;
            this.txtQuantity.Text = "0";
            this.txtQuantity.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.txtQuantity.TextChanged += new System.EventHandler(this.txtQuantity_TextChanged);
            // 
            // lblQuantity
            // 
            this.lblQuantity.AutoSize = true;
            this.lblQuantity.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblQuantity.ForeColor = System.Drawing.Color.Black;
            this.lblQuantity.Location = new System.Drawing.Point(32, 78);
            this.lblQuantity.Name = "lblQuantity";
            this.lblQuantity.Size = new System.Drawing.Size(56, 15);
            this.lblQuantity.TabIndex = 3;
            this.lblQuantity.Text = "Quantity:";
            // 
            // cmbOrderTypes
            // 
            this.cmbOrderTypes.BackColor = System.Drawing.Color.White;
            this.cmbOrderTypes.Font = new System.Drawing.Font("Verdana", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.cmbOrderTypes.FormattingEnabled = true;
            this.cmbOrderTypes.ImeMode = System.Windows.Forms.ImeMode.Disable;
            this.cmbOrderTypes.Location = new System.Drawing.Point(90, 52);
            this.cmbOrderTypes.Name = "cmbOrderTypes";
            this.cmbOrderTypes.Size = new System.Drawing.Size(122, 21);
            this.cmbOrderTypes.TabIndex = 2;
            this.cmbOrderTypes.SelectedIndexChanged += new System.EventHandler(this.cmbOrderTypes_SelectedIndexChanged);
            // 
            // lblOrderType
            // 
            this.lblOrderType.AutoSize = true;
            this.lblOrderType.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblOrderType.ForeColor = System.Drawing.Color.Black;
            this.lblOrderType.Location = new System.Drawing.Point(19, 56);
            this.lblOrderType.Name = "lblOrderType";
            this.lblOrderType.Size = new System.Drawing.Size(69, 15);
            this.lblOrderType.TabIndex = 5;
            this.lblOrderType.Text = "Order Type:";
            // 
            // lblSymbol
            // 
            this.lblSymbol.AutoSize = true;
            this.lblSymbol.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblSymbol.ForeColor = System.Drawing.Color.Black;
            this.lblSymbol.Location = new System.Drawing.Point(38, 11);
            this.lblSymbol.Name = "lblSymbol";
            this.lblSymbol.Size = new System.Drawing.Size(50, 15);
            this.lblSymbol.TabIndex = 7;
            this.lblSymbol.Text = "Symbol:";
            // 
            // txtSymbol
            // 
            this.txtSymbol.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.Suggest;
            this.txtSymbol.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.CustomSource;
            this.txtSymbol.BackColor = System.Drawing.Color.White;
            this.txtSymbol.CharacterCasing = System.Windows.Forms.CharacterCasing.Upper;
            this.txtSymbol.Font = new System.Drawing.Font("Verdana", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtSymbol.ForeColor = System.Drawing.Color.Red;
            this.txtSymbol.ImeMode = System.Windows.Forms.ImeMode.Disable;
            this.txtSymbol.Location = new System.Drawing.Point(90, 7);
            this.txtSymbol.Name = "txtSymbol";
            this.txtSymbol.Size = new System.Drawing.Size(103, 22);
            this.txtSymbol.TabIndex = 0;
            this.txtSymbol.TextChanged += new System.EventHandler(this.txtSymbol_TextChanged);
            this.txtSymbol.DragDrop += new System.Windows.Forms.DragEventHandler(this.txtSymbol_DragDrop);
            this.txtSymbol.Leave += new System.EventHandler(this.txtSymbol_Leave);
            // 
            // lblPrice
            // 
            this.lblPrice.AutoSize = true;
            this.lblPrice.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblPrice.ForeColor = System.Drawing.Color.Black;
            this.lblPrice.Location = new System.Drawing.Point(48, 98);
            this.lblPrice.Name = "lblPrice";
            this.lblPrice.Size = new System.Drawing.Size(36, 15);
            this.lblPrice.TabIndex = 9;
            this.lblPrice.Text = "Price:";
            // 
            // txtPrice
            // 
            this.txtPrice.BackColor = System.Drawing.Color.White;
            this.txtPrice.Font = new System.Drawing.Font("Verdana", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtPrice.ImeMode = System.Windows.Forms.ImeMode.Disable;
            this.txtPrice.Location = new System.Drawing.Point(90, 96);
            this.txtPrice.Name = "txtPrice";
            this.txtPrice.Size = new System.Drawing.Size(103, 21);
            this.txtPrice.TabIndex = 4;
            this.txtPrice.Text = "0";
            this.txtPrice.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.txtPrice.TextChanged += new System.EventHandler(this.txtPrice_TextChanged);
            // 
            // lblActPrice
            // 
            this.lblActPrice.AutoSize = true;
            this.lblActPrice.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblActPrice.ForeColor = System.Drawing.Color.Black;
            this.lblActPrice.Location = new System.Drawing.Point(34, 122);
            this.lblActPrice.Name = "lblActPrice";
            this.lblActPrice.Size = new System.Drawing.Size(54, 15);
            this.lblActPrice.TabIndex = 11;
            this.lblActPrice.Text = "ActPrice:";
            // 
            // txtActPrice
            // 
            this.txtActPrice.BackColor = System.Drawing.Color.White;
            this.txtActPrice.Font = new System.Drawing.Font("Verdana", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtActPrice.ImeMode = System.Windows.Forms.ImeMode.Disable;
            this.txtActPrice.Location = new System.Drawing.Point(90, 118);
            this.txtActPrice.Name = "txtActPrice";
            this.txtActPrice.Size = new System.Drawing.Size(103, 21);
            this.txtActPrice.TabIndex = 5;
            this.txtActPrice.Text = "0";
            this.txtActPrice.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.txtActPrice.TextChanged += new System.EventHandler(this.txtActPrice_TextChanged);
            // 
            // lblTsParam
            // 
            this.lblTsParam.AutoSize = true;
            this.lblTsParam.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblTsParam.ForeColor = System.Drawing.Color.Black;
            this.lblTsParam.Location = new System.Drawing.Point(32, 144);
            this.lblTsParam.Name = "lblTsParam";
            this.lblTsParam.Size = new System.Drawing.Size(56, 15);
            this.lblTsParam.TabIndex = 13;
            this.lblTsParam.Text = "TsParam:";
            // 
            // txtTsParam
            // 
            this.txtTsParam.BackColor = System.Drawing.Color.White;
            this.txtTsParam.Font = new System.Drawing.Font("Verdana", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtTsParam.ImeMode = System.Windows.Forms.ImeMode.Disable;
            this.txtTsParam.Location = new System.Drawing.Point(90, 140);
            this.txtTsParam.Name = "txtTsParam";
            this.txtTsParam.Size = new System.Drawing.Size(103, 21);
            this.txtTsParam.TabIndex = 6;
            this.txtTsParam.Text = "0";
            this.txtTsParam.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            // 
            // lblSpInstruction
            // 
            this.lblSpInstruction.AutoSize = true;
            this.lblSpInstruction.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblSpInstruction.ForeColor = System.Drawing.Color.Black;
            this.lblSpInstruction.Location = new System.Drawing.Point(8, 190);
            this.lblSpInstruction.Name = "lblSpInstruction";
            this.lblSpInstruction.Size = new System.Drawing.Size(80, 15);
            this.lblSpInstruction.TabIndex = 15;
            this.lblSpInstruction.Text = "SpInstruction:";
            // 
            // cmbSpInstructions
            // 
            this.cmbSpInstructions.BackColor = System.Drawing.Color.White;
            this.cmbSpInstructions.Font = new System.Drawing.Font("Verdana", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.cmbSpInstructions.FormattingEnabled = true;
            this.cmbSpInstructions.ImeMode = System.Windows.Forms.ImeMode.Disable;
            this.cmbSpInstructions.Location = new System.Drawing.Point(90, 186);
            this.cmbSpInstructions.Name = "cmbSpInstructions";
            this.cmbSpInstructions.Size = new System.Drawing.Size(122, 21);
            this.cmbSpInstructions.TabIndex = 8;
            // 
            // lblExpire
            // 
            this.lblExpire.AutoSize = true;
            this.lblExpire.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblExpire.ForeColor = System.Drawing.Color.Black;
            this.lblExpire.Location = new System.Drawing.Point(42, 167);
            this.lblExpire.Name = "lblExpire";
            this.lblExpire.Size = new System.Drawing.Size(46, 15);
            this.lblExpire.TabIndex = 17;
            this.lblExpire.Text = "Expires:";
            // 
            // cmbExpires
            // 
            this.cmbExpires.BackColor = System.Drawing.Color.White;
            this.cmbExpires.Font = new System.Drawing.Font("Verdana", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.cmbExpires.FormattingEnabled = true;
            this.cmbExpires.ImeMode = System.Windows.Forms.ImeMode.Disable;
            this.cmbExpires.Location = new System.Drawing.Point(90, 163);
            this.cmbExpires.Name = "cmbExpires";
            this.cmbExpires.Size = new System.Drawing.Size(122, 21);
            this.cmbExpires.TabIndex = 7;
            // 
            // bttnSubmit
            // 
            this.bttnSubmit.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.bttnSubmit.ForeColor = System.Drawing.SystemColors.HotTrack;
            this.bttnSubmit.Location = new System.Drawing.Point(13, 213);
            this.bttnSubmit.Name = "bttnSubmit";
            this.bttnSubmit.Size = new System.Drawing.Size(199, 24);
            this.bttnSubmit.TabIndex = 9;
            this.bttnSubmit.Text = "Submit Order";
            this.bttnSubmit.UseVisualStyleBackColor = true;
            this.bttnSubmit.Visible = false;
            this.bttnSubmit.Click += new System.EventHandler(this.bttnSubmit_Click);
            // 
            // ucEquityOrder
            // 
            this.AllowDrop = true;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.bttnSubmit);
            this.Controls.Add(this.lblExpire);
            this.Controls.Add(this.cmbExpires);
            this.Controls.Add(this.lblSpInstruction);
            this.Controls.Add(this.cmbSpInstructions);
            this.Controls.Add(this.lblTsParam);
            this.Controls.Add(this.txtTsParam);
            this.Controls.Add(this.lblActPrice);
            this.Controls.Add(this.txtActPrice);
            this.Controls.Add(this.lblPrice);
            this.Controls.Add(this.txtPrice);
            this.Controls.Add(this.lblSymbol);
            this.Controls.Add(this.txtSymbol);
            this.Controls.Add(this.lblOrderType);
            this.Controls.Add(this.cmbOrderTypes);
            this.Controls.Add(this.lblQuantity);
            this.Controls.Add(this.txtQuantity);
            this.Controls.Add(this.lblAction);
            this.Controls.Add(this.cmbActions);
            this.Name = "ucEquityOrder";
            this.Size = new System.Drawing.Size(231, 256);
            this.DragDrop += new System.Windows.Forms.DragEventHandler(this.ucEquityOrder_DragDrop);
            this.DragEnter += new System.Windows.Forms.DragEventHandler(this.ucEquityOrder_DragEnter);
            this.MouseLeave += new System.EventHandler(this.ucEquityOrder_MouseLeave);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ComboBox cmbActions;
        private System.Windows.Forms.Label lblAction;
        private System.Windows.Forms.TextBox txtQuantity;
        private System.Windows.Forms.Label lblQuantity;
        private System.Windows.Forms.ComboBox cmbOrderTypes;
        private System.Windows.Forms.Label lblOrderType;
        private System.Windows.Forms.Label lblSymbol;
        private System.Windows.Forms.TextBox txtSymbol;
        private System.Windows.Forms.Label lblPrice;
        private System.Windows.Forms.TextBox txtPrice;
        private System.Windows.Forms.Label lblActPrice;
        private System.Windows.Forms.TextBox txtActPrice;
        private System.Windows.Forms.Label lblTsParam;
        private System.Windows.Forms.TextBox txtTsParam;
        private System.Windows.Forms.Label lblSpInstruction;
        private System.Windows.Forms.ComboBox cmbSpInstructions;
        private System.Windows.Forms.Label lblExpire;
        private System.Windows.Forms.ComboBox cmbExpires;
        private System.Windows.Forms.Button bttnSubmit;
    }
}
