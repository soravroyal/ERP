namespace XMLDiagnosticsTool
{
    partial class Form1
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
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.chooseXMLToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.label2 = new System.Windows.Forms.Label();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.tbChosen = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.errorTextBox = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.btnSqlRun = new System.Windows.Forms.Button();
            this.lblDate = new System.Windows.Forms.Label();
            this.textBox2 = new System.Windows.Forms.TextBox();
            this.menuStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.chooseXMLToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(1138, 24);
            this.menuStrip1.TabIndex = 2;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // chooseXMLToolStripMenuItem
            // 
            this.chooseXMLToolStripMenuItem.Name = "chooseXMLToolStripMenuItem";
            this.chooseXMLToolStripMenuItem.Size = new System.Drawing.Size(75, 20);
            this.chooseXMLToolStripMenuItem.Text = "choose XML";
            this.chooseXMLToolStripMenuItem.Click += new System.EventHandler(this.chooseXMLToolStripMenuItem_Click);
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.FileName = "openFileDialog1";
            this.openFileDialog1.Filter = "xml files|*.xml";
            this.openFileDialog1.FileOk += new System.ComponentModel.CancelEventHandler(this.openFileDialog1_FileOk);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(12, 106);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(47, 13);
            this.label2.TabIndex = 3;
            this.label2.Text = "result list";
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(12, 122);
            this.textBox1.Multiline = true;
            this.textBox1.Name = "textBox1";
            this.textBox1.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.textBox1.Size = new System.Drawing.Size(531, 496);
            this.textBox1.TabIndex = 7;
            // 
            // tbChosen
            // 
            this.tbChosen.Location = new System.Drawing.Point(12, 49);
            this.tbChosen.Name = "tbChosen";
            this.tbChosen.ReadOnly = true;
            this.tbChosen.Size = new System.Drawing.Size(531, 20);
            this.tbChosen.TabIndex = 12;
            this.tbChosen.TextChanged += new System.EventHandler(this.tbChosen_TextChanged);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 33);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(95, 13);
            this.label1.TabIndex = 13;
            this.label1.Text = "Path of chosen file";
            // 
            // errorTextBox
            // 
            this.errorTextBox.Location = new System.Drawing.Point(549, 122);
            this.errorTextBox.Multiline = true;
            this.errorTextBox.Name = "errorTextBox";
            this.errorTextBox.ReadOnly = true;
            this.errorTextBox.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.errorTextBox.Size = new System.Drawing.Size(577, 505);
            this.errorTextBox.TabIndex = 14;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(546, 106);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(107, 13);
            this.label4.TabIndex = 15;
            this.label4.Text = "database diagnostics";
            // 
            // btnSqlRun
            // 
            this.btnSqlRun.Enabled = false;
            this.btnSqlRun.Location = new System.Drawing.Point(1051, 93);
            this.btnSqlRun.Name = "btnSqlRun";
            this.btnSqlRun.Size = new System.Drawing.Size(75, 23);
            this.btnSqlRun.TabIndex = 18;
            this.btnSqlRun.Text = "RUN sql Statement";
            this.btnSqlRun.UseVisualStyleBackColor = true;
            this.btnSqlRun.Click += new System.EventHandler(this.btnSqlRun_Click);
            // 
            // lblDate
            // 
            this.lblDate.AutoSize = true;
            this.lblDate.Location = new System.Drawing.Point(12, 72);
            this.lblDate.Name = "lblDate";
            this.lblDate.Size = new System.Drawing.Size(118, 13);
            this.lblDate.TabIndex = 19;
            this.lblDate.Text = "Release date input field";
            // 
            // textBox2
            // 
            this.textBox2.Location = new System.Drawing.Point(15, 88);
            this.textBox2.Name = "textBox2";
            this.textBox2.Size = new System.Drawing.Size(149, 20);
            this.textBox2.TabIndex = 20;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1138, 639);
            this.Controls.Add(this.textBox2);
            this.Controls.Add(this.lblDate);
            this.Controls.Add(this.btnSqlRun);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.errorTextBox);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.tbChosen);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.menuStrip1);
            this.MainMenuStrip = this.menuStrip1;
            this.Name = "Form1";
            this.Text = "XML and SQL comparison tool";
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem chooseXMLToolStripMenuItem;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.TextBox tbChosen;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox errorTextBox;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Button btnSqlRun;
        private System.Windows.Forms.Label lblDate;
        private System.Windows.Forms.TextBox textBox2;
    }
}

