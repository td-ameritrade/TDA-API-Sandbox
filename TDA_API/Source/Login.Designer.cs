namespace TechTrader.TDA
{
    partial class Login
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
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.label1 = new System.Windows.Forms.Label();
            this.username = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.password = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.sourceid = new System.Windows.Forms.TextBox();
            this.Log = new System.Windows.Forms.Button();
            this.cancel = new System.Windows.Forms.Button();
            this.label5 = new System.Windows.Forms.Label();
            this.equities = new System.Windows.Forms.RadioButton();
            this.options = new System.Windows.Forms.RadioButton();
            this.spreadLabel = new System.Windows.Forms.Label();
            this.spread = new System.Windows.Forms.NumericUpDown();
            this.label6 = new System.Windows.Forms.Label();
            this.expir = new System.Windows.Forms.NumericUpDown();
            this.optionsSettings = new System.Windows.Forms.GroupBox();
            this.perOptionContractFee = new System.Windows.Forms.NumericUpDown();
            this.label9 = new System.Windows.Forms.Label();
            this.perOptionTradeFee = new System.Windows.Forms.NumericUpDown();
            this.label7 = new System.Windows.Forms.Label();
            this.perStockTradeFee = new System.Windows.Forms.NumericUpDown();
            this.label8 = new System.Windows.Forms.Label();
            this.autoClose = new System.Windows.Forms.CheckBox();
            ((System.ComponentModel.ISupportInitialize)(this.spread)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.expir)).BeginInit();
            this.optionsSettings.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.perOptionContractFee)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.perOptionTradeFee)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.perStockTradeFee)).BeginInit();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.Anchor = System.Windows.Forms.AnchorStyles.Top;
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(84, 19);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(116, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "Login to TDAmeritrade:";
            // 
            // username
            // 
            this.username.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.username.Location = new System.Drawing.Point(95, 46);
            this.username.Name = "username";
            this.username.Size = new System.Drawing.Size(164, 20);
            this.username.TabIndex = 1;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(19, 49);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(58, 13);
            this.label2.TabIndex = 2;
            this.label2.Text = "Username:";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(19, 75);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(56, 13);
            this.label3.TabIndex = 4;
            this.label3.Text = "Password:";
            // 
            // password
            // 
            this.password.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.password.Location = new System.Drawing.Point(95, 72);
            this.password.Name = "password";
            this.password.PasswordChar = '*';
            this.password.Size = new System.Drawing.Size(164, 20);
            this.password.TabIndex = 3;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(19, 101);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(58, 13);
            this.label4.TabIndex = 6;
            this.label4.Text = "Source ID:";
            // 
            // sourceid
            // 
            this.sourceid.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.sourceid.Location = new System.Drawing.Point(95, 98);
            this.sourceid.Name = "sourceid";
            this.sourceid.Size = new System.Drawing.Size(164, 20);
            this.sourceid.TabIndex = 5;
            // 
            // Log
            // 
            this.Log.Location = new System.Drawing.Point(64, 324);
            this.Log.Name = "Log";
            this.Log.Size = new System.Drawing.Size(75, 23);
            this.Log.TabIndex = 7;
            this.Log.Text = "Login";
            this.Log.UseVisualStyleBackColor = true;
            this.Log.Click += new System.EventHandler(this.Log_Click);
            // 
            // cancel
            // 
            this.cancel.Location = new System.Drawing.Point(145, 324);
            this.cancel.Name = "cancel";
            this.cancel.Size = new System.Drawing.Size(75, 23);
            this.cancel.TabIndex = 8;
            this.cancel.Text = "Cancel";
            this.cancel.UseVisualStyleBackColor = true;
            this.cancel.Click += new System.EventHandler(this.cancel_Click);
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(19, 124);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(63, 13);
            this.label5.TabIndex = 9;
            this.label5.Text = "Auto-Trade:";
            // 
            // equities
            // 
            this.equities.AutoSize = true;
            this.equities.Location = new System.Drawing.Point(100, 122);
            this.equities.Name = "equities";
            this.equities.Size = new System.Drawing.Size(62, 17);
            this.equities.TabIndex = 10;
            this.equities.TabStop = true;
            this.equities.Text = "Equities";
            this.equities.UseVisualStyleBackColor = true;
            // 
            // options
            // 
            this.options.AutoSize = true;
            this.options.Location = new System.Drawing.Point(180, 122);
            this.options.Name = "options";
            this.options.Size = new System.Drawing.Size(61, 17);
            this.options.TabIndex = 11;
            this.options.TabStop = true;
            this.options.Text = "Options";
            this.options.UseVisualStyleBackColor = true;
            // 
            // spreadLabel
            // 
            this.spreadLabel.AutoSize = true;
            this.spreadLabel.Location = new System.Drawing.Point(19, 94);
            this.spreadLabel.Name = "spreadLabel";
            this.spreadLabel.Size = new System.Drawing.Size(75, 13);
            this.spreadLabel.TabIndex = 12;
            this.spreadLabel.Text = "Max.Spread%:";
            // 
            // spread
            // 
            this.spread.Location = new System.Drawing.Point(100, 92);
            this.spread.Name = "spread";
            this.spread.Size = new System.Drawing.Size(38, 20);
            this.spread.TabIndex = 13;
            this.spread.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.spread.Value = new decimal(new int[] {
            10,
            0,
            0,
            0});
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(144, 94);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(76, 13);
            this.label6.TabIndex = 14;
            this.label6.Text = "Min.Expiration:";
            // 
            // expir
            // 
            this.expir.Location = new System.Drawing.Point(221, 92);
            this.expir.Name = "expir";
            this.expir.Size = new System.Drawing.Size(38, 20);
            this.expir.TabIndex = 15;
            this.expir.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.expir.Value = new decimal(new int[] {
            14,
            0,
            0,
            0});
            // 
            // optionsSettings
            // 
            this.optionsSettings.Anchor = System.Windows.Forms.AnchorStyles.Top;
            this.optionsSettings.Controls.Add(this.perOptionContractFee);
            this.optionsSettings.Controls.Add(this.label9);
            this.optionsSettings.Controls.Add(this.perOptionTradeFee);
            this.optionsSettings.Controls.Add(this.label7);
            this.optionsSettings.Controls.Add(this.perStockTradeFee);
            this.optionsSettings.Controls.Add(this.label8);
            this.optionsSettings.Controls.Add(this.expir);
            this.optionsSettings.Controls.Add(this.label6);
            this.optionsSettings.Controls.Add(this.spread);
            this.optionsSettings.Controls.Add(this.spreadLabel);
            this.optionsSettings.Location = new System.Drawing.Point(0, 140);
            this.optionsSettings.Name = "optionsSettings";
            this.optionsSettings.Size = new System.Drawing.Size(290, 122);
            this.optionsSettings.TabIndex = 16;
            this.optionsSettings.TabStop = false;
            // 
            // perOptionContractFee
            // 
            this.perOptionContractFee.DecimalPlaces = 2;
            this.perOptionContractFee.Location = new System.Drawing.Point(206, 65);
            this.perOptionContractFee.Name = "perOptionContractFee";
            this.perOptionContractFee.Size = new System.Drawing.Size(53, 20);
            this.perOptionContractFee.TabIndex = 21;
            this.perOptionContractFee.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.perOptionContractFee.Value = new decimal(new int[] {
            75,
            0,
            0,
            131072});
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(19, 67);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(124, 13);
            this.label9.TabIndex = 20;
            this.label9.Text = "Option Per-Contract Fee:";
            // 
            // perOptionTradeFee
            // 
            this.perOptionTradeFee.DecimalPlaces = 2;
            this.perOptionTradeFee.Location = new System.Drawing.Point(206, 40);
            this.perOptionTradeFee.Name = "perOptionTradeFee";
            this.perOptionTradeFee.Size = new System.Drawing.Size(53, 20);
            this.perOptionTradeFee.TabIndex = 19;
            this.perOptionTradeFee.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.perOptionTradeFee.Value = new decimal(new int[] {
            10,
            0,
            0,
            0});
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(19, 42);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(112, 13);
            this.label7.TabIndex = 18;
            this.label7.Text = "Option Per-Trade Fee:";
            // 
            // perStockTradeFee
            // 
            this.perStockTradeFee.DecimalPlaces = 2;
            this.perStockTradeFee.Location = new System.Drawing.Point(206, 14);
            this.perStockTradeFee.Name = "perStockTradeFee";
            this.perStockTradeFee.Size = new System.Drawing.Size(53, 20);
            this.perStockTradeFee.TabIndex = 17;
            this.perStockTradeFee.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.perStockTradeFee.Value = new decimal(new int[] {
            10,
            0,
            0,
            0});
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(19, 16);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(109, 13);
            this.label8.TabIndex = 16;
            this.label8.Text = "Stock Per-Trade Fee:";
            // 
            // autoClose
            // 
            this.autoClose.AutoSize = true;
            this.autoClose.Location = new System.Drawing.Point(22, 285);
            this.autoClose.Name = "autoClose";
            this.autoClose.Size = new System.Drawing.Size(244, 17);
            this.autoClose.TabIndex = 16;
            this.autoClose.Text = "Automatically close positions I don\'t recognize.";
            this.autoClose.UseVisualStyleBackColor = true;
            // 
            // Login
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(284, 362);
            this.ControlBox = false;
            this.Controls.Add(this.autoClose);
            this.Controls.Add(this.optionsSettings);
            this.Controls.Add(this.options);
            this.Controls.Add(this.equities);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.cancel);
            this.Controls.Add(this.Log);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.sourceid);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.password);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.username);
            this.Controls.Add(this.label1);
            this.MaximumSize = new System.Drawing.Size(300, 400);
            this.MinimumSize = new System.Drawing.Size(300, 400);
            this.Name = "Login";
            this.Text = "Login";
            ((System.ComponentModel.ISupportInitialize)(this.spread)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.expir)).EndInit();
            this.optionsSettings.ResumeLayout(false);
            this.optionsSettings.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.perOptionContractFee)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.perOptionTradeFee)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.perStockTradeFee)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox username;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox password;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox sourceid;
        private System.Windows.Forms.Button Log;
        private System.Windows.Forms.Button cancel;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.RadioButton equities;
        private System.Windows.Forms.RadioButton options;
        private System.Windows.Forms.Label spreadLabel;
        private System.Windows.Forms.NumericUpDown spread;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.NumericUpDown expir;
        private System.Windows.Forms.GroupBox optionsSettings;
        private System.Windows.Forms.CheckBox autoClose;
        private System.Windows.Forms.NumericUpDown perOptionContractFee;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.NumericUpDown perOptionTradeFee;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.NumericUpDown perStockTradeFee;
        private System.Windows.Forms.Label label8;
    }
}