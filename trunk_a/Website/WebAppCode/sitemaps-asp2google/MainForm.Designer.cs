namespace SitemapConverter
{
    partial class _form
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
            this._btnStart = new System.Windows.Forms.Button();
            this.flowLayoutPanel1 = new System.Windows.Forms.FlowLayoutPanel();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this._btnAspSitemap = new System.Windows.Forms.Button();
            this._boxAspSitemap = new System.Windows.Forms.TextBox();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this._boxDomainName = new System.Windows.Forms.TextBox();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this._btnGoogleSitemap = new System.Windows.Forms.Button();
            this._boxGoogleSitemap = new System.Windows.Forms.TextBox();
            this.panel1 = new System.Windows.Forms.Panel();
            this._dlgOpenFile = new System.Windows.Forms.OpenFileDialog();
            this._dlgSaveFile = new System.Windows.Forms.SaveFileDialog();
            this._linkDigizzle = new System.Windows.Forms.LinkLabel();
            this.flowLayoutPanel1.SuspendLayout();
            this.groupBox1.SuspendLayout();
            this.groupBox3.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // _btnStart
            // 
            this._btnStart.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(128)))));
            this._btnStart.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this._btnStart.Font = new System.Drawing.Font("Tahoma", 8.5F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this._btnStart.Location = new System.Drawing.Point(128, 6);
            this._btnStart.Name = "_btnStart";
            this._btnStart.Size = new System.Drawing.Size(75, 23);
            this._btnStart.TabIndex = 0;
            this._btnStart.Text = "Start";
            this._btnStart.UseVisualStyleBackColor = true;
            this._btnStart.Click += new System.EventHandler(this._btnStart_Click);
            // 
            // flowLayoutPanel1
            // 
            this.flowLayoutPanel1.Controls.Add(this.groupBox1);
            this.flowLayoutPanel1.Controls.Add(this.groupBox3);
            this.flowLayoutPanel1.Controls.Add(this.groupBox2);
            this.flowLayoutPanel1.Controls.Add(this.panel1);
            this.flowLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.flowLayoutPanel1.Location = new System.Drawing.Point(0, 0);
            this.flowLayoutPanel1.Name = "flowLayoutPanel1";
            this.flowLayoutPanel1.Size = new System.Drawing.Size(332, 207);
            this.flowLayoutPanel1.TabIndex = 1;
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this._btnAspSitemap);
            this.groupBox1.Controls.Add(this._boxAspSitemap);
            this.groupBox1.Location = new System.Drawing.Point(3, 3);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(324, 51);
            this.groupBox1.TabIndex = 0;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Select existing ASP.NET sitemap";
            // 
            // _btnAspSitemap
            // 
            this._btnAspSitemap.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(128)))));
            this._btnAspSitemap.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this._btnAspSitemap.Font = new System.Drawing.Font("Tahoma", 7F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this._btnAspSitemap.Location = new System.Drawing.Point(286, 16);
            this._btnAspSitemap.Name = "_btnAspSitemap";
            this._btnAspSitemap.Size = new System.Drawing.Size(26, 26);
            this._btnAspSitemap.TabIndex = 1;
            this._btnAspSitemap.Text = "...";
            this._btnAspSitemap.UseVisualStyleBackColor = true;
            this._btnAspSitemap.Click += new System.EventHandler(this._btnAspSitemap_Click);
            // 
            // _boxAspSitemap
            // 
            this._boxAspSitemap.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this._boxAspSitemap.DataBindings.Add(new System.Windows.Forms.Binding("Text", global::SitemapConverter.Properties.Settings.Default, "AspNetSitemap", true, System.Windows.Forms.DataSourceUpdateMode.OnPropertyChanged));
            this._boxAspSitemap.Location = new System.Drawing.Point(9, 19);
            this._boxAspSitemap.Name = "_boxAspSitemap";
            this._boxAspSitemap.Size = new System.Drawing.Size(271, 21);
            this._boxAspSitemap.TabIndex = 0;
            this._boxAspSitemap.Text = global::SitemapConverter.Properties.Settings.Default.AspNetSitemap;
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this._boxDomainName);
            this.groupBox3.Location = new System.Drawing.Point(3, 60);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Size = new System.Drawing.Size(324, 51);
            this.groupBox3.TabIndex = 1;
            this.groupBox3.TabStop = false;
            this.groupBox3.Text = "Enter domain name";
            // 
            // _boxDomainName
            // 
            this._boxDomainName.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this._boxDomainName.DataBindings.Add(new System.Windows.Forms.Binding("Text", global::SitemapConverter.Properties.Settings.Default, "DomainName", true, System.Windows.Forms.DataSourceUpdateMode.OnPropertyChanged));
            this._boxDomainName.Location = new System.Drawing.Point(9, 19);
            this._boxDomainName.Name = "_boxDomainName";
            this._boxDomainName.Size = new System.Drawing.Size(303, 21);
            this._boxDomainName.TabIndex = 0;
            this._boxDomainName.Text = global::SitemapConverter.Properties.Settings.Default.DomainName;
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this._btnGoogleSitemap);
            this.groupBox2.Controls.Add(this._boxGoogleSitemap);
            this.groupBox2.Location = new System.Drawing.Point(3, 117);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(324, 51);
            this.groupBox2.TabIndex = 2;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "Select filename for output Google sitemap";
            // 
            // _btnGoogleSitemap
            // 
            this._btnGoogleSitemap.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(128)))));
            this._btnGoogleSitemap.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this._btnGoogleSitemap.Font = new System.Drawing.Font("Tahoma", 7F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this._btnGoogleSitemap.Location = new System.Drawing.Point(286, 16);
            this._btnGoogleSitemap.Name = "_btnGoogleSitemap";
            this._btnGoogleSitemap.Size = new System.Drawing.Size(26, 26);
            this._btnGoogleSitemap.TabIndex = 1;
            this._btnGoogleSitemap.Text = "...";
            this._btnGoogleSitemap.UseVisualStyleBackColor = true;
            this._btnGoogleSitemap.Click += new System.EventHandler(this._btnGoogleSitemap_Click);
            // 
            // _boxGoogleSitemap
            // 
            this._boxGoogleSitemap.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this._boxGoogleSitemap.DataBindings.Add(new System.Windows.Forms.Binding("Text", global::SitemapConverter.Properties.Settings.Default, "GoogleSitemap", true, System.Windows.Forms.DataSourceUpdateMode.OnPropertyChanged));
            this._boxGoogleSitemap.Location = new System.Drawing.Point(9, 19);
            this._boxGoogleSitemap.Name = "_boxGoogleSitemap";
            this._boxGoogleSitemap.Size = new System.Drawing.Size(271, 21);
            this._boxGoogleSitemap.TabIndex = 0;
            this._boxGoogleSitemap.Text = global::SitemapConverter.Properties.Settings.Default.GoogleSitemap;
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this._linkDigizzle);
            this.panel1.Controls.Add(this._btnStart);
            this.panel1.Location = new System.Drawing.Point(3, 174);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(329, 33);
            this.panel1.TabIndex = 4;
            // 
            // _dlgOpenFile
            // 
            this._dlgOpenFile.Filter = "Sitemap files|*.sitemap|All files|*.*";
            this._dlgOpenFile.Title = "Select ASP.NET sitemap";
            // 
            // _dlgSaveFile
            // 
            this._dlgSaveFile.FileName = "sitemap.xml";
            this._dlgSaveFile.Title = "Set name of output google sitemap";
            // 
            // _linkDigizzle
            // 
            this._linkDigizzle.AccessibleDescription = "";
            this._linkDigizzle.AutoSize = true;
            this._linkDigizzle.Cursor = System.Windows.Forms.Cursors.Hand;
            this._linkDigizzle.Font = new System.Drawing.Font("Tahoma", 7F);
            this._linkDigizzle.Location = new System.Drawing.Point(287, 13);
            this._linkDigizzle.Name = "_linkDigizzle";
            this._linkDigizzle.Size = new System.Drawing.Size(36, 16);
            this._linkDigizzle.TabIndex = 1;
            this._linkDigizzle.TabStop = true;
            this._linkDigizzle.Text = "Digizzle";
            this._linkDigizzle.UseCompatibleTextRendering = true;
            this._linkDigizzle.UseMnemonic = false;
            this._linkDigizzle.Click += new System.EventHandler(this._linkDigizzle_Click);
            // 
            // _form
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(332, 207);
            this.Controls.Add(this.flowLayoutPanel1);
            this.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.Name = "_form";
            this.Text = "Sitemap converter (ASP.NET -> Google)";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this._form_FormClosing);
            this.Load += new System.EventHandler(this._form_Load);
            this.flowLayoutPanel1.ResumeLayout(false);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.groupBox3.ResumeLayout(false);
            this.groupBox3.PerformLayout();
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button _btnStart;
        private System.Windows.Forms.FlowLayoutPanel flowLayoutPanel1;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Button _btnAspSitemap;
        private System.Windows.Forms.TextBox _boxAspSitemap;
        private System.Windows.Forms.OpenFileDialog _dlgOpenFile;
        private System.Windows.Forms.SaveFileDialog _dlgSaveFile;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.Button _btnGoogleSitemap;
        private System.Windows.Forms.TextBox _boxGoogleSitemap;
        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.TextBox _boxDomainName;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.LinkLabel _linkDigizzle;
    }
}

