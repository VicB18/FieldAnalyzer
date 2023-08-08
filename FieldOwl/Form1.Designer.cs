
namespace FieldOwl
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
            this.SelectImagesBTN = new System.Windows.Forms.Button();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.StatusLabel = new System.Windows.Forms.Label();
            this.MapPicB = new System.Windows.Forms.PictureBox();
            ((System.ComponentModel.ISupportInitialize)(this.MapPicB)).BeginInit();
            this.SuspendLayout();
            // 
            // SelectImagesBTN
            // 
            this.SelectImagesBTN.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.SelectImagesBTN.Location = new System.Drawing.Point(12, 12);
            this.SelectImagesBTN.Name = "SelectImagesBTN";
            this.SelectImagesBTN.Size = new System.Drawing.Size(137, 41);
            this.SelectImagesBTN.TabIndex = 0;
            this.SelectImagesBTN.Text = "Select images";
            this.SelectImagesBTN.UseVisualStyleBackColor = true;
            this.SelectImagesBTN.Click += new System.EventHandler(this.SelectImagesBTN_Click);
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.FileName = "openFileDialog1";
            // 
            // StatusLabel
            // 
            this.StatusLabel.AutoSize = true;
            this.StatusLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.StatusLabel.Location = new System.Drawing.Point(164, 22);
            this.StatusLabel.Name = "StatusLabel";
            this.StatusLabel.Size = new System.Drawing.Size(19, 20);
            this.StatusLabel.TabIndex = 1;
            this.StatusLabel.Text = "--";
            // 
            // MapPicB
            // 
            this.MapPicB.Location = new System.Drawing.Point(12, 72);
            this.MapPicB.Name = "MapPicB";
            this.MapPicB.Size = new System.Drawing.Size(419, 396);
            this.MapPicB.TabIndex = 2;
            this.MapPicB.TabStop = false;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 497);
            this.Controls.Add(this.MapPicB);
            this.Controls.Add(this.StatusLabel);
            this.Controls.Add(this.SelectImagesBTN);
            this.Name = "Form1";
            this.Text = "Field owl";
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.MapPicB)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button SelectImagesBTN;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private System.Windows.Forms.Label StatusLabel;
        private System.Windows.Forms.PictureBox MapPicB;
    }
}

