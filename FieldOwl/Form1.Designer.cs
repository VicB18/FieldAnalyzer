
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
            this.ImagePicB = new System.Windows.Forms.PictureBox();
            ((System.ComponentModel.ISupportInitialize)(this.MapPicB)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.ImagePicB)).BeginInit();
            this.SuspendLayout();
            // 
            // SelectImagesBTN
            // 
            this.SelectImagesBTN.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.SelectImagesBTN.Location = new System.Drawing.Point(18, 18);
            this.SelectImagesBTN.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.SelectImagesBTN.Name = "SelectImagesBTN";
            this.SelectImagesBTN.Size = new System.Drawing.Size(206, 63);
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
            this.StatusLabel.Location = new System.Drawing.Point(246, 34);
            this.StatusLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.StatusLabel.Name = "StatusLabel";
            this.StatusLabel.Size = new System.Drawing.Size(29, 29);
            this.StatusLabel.TabIndex = 1;
            this.StatusLabel.Text = "--";
            // 
            // MapPicB
            // 
            this.MapPicB.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.MapPicB.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.MapPicB.Location = new System.Drawing.Point(18, 111);
            this.MapPicB.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.MapPicB.Name = "MapPicB";
            this.MapPicB.Size = new System.Drawing.Size(694, 609);
            this.MapPicB.TabIndex = 2;
            this.MapPicB.TabStop = false;
            // 
            // ImagePicB
            // 
            this.ImagePicB.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.ImagePicB.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.ImagePicB.Location = new System.Drawing.Point(722, 111);
            this.ImagePicB.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.ImagePicB.Name = "ImagePicB";
            this.ImagePicB.Size = new System.Drawing.Size(636, 468);
            this.ImagePicB.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.ImagePicB.TabIndex = 3;
            this.ImagePicB.TabStop = false;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(9F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1376, 765);
            this.Controls.Add(this.ImagePicB);
            this.Controls.Add(this.MapPicB);
            this.Controls.Add(this.StatusLabel);
            this.Controls.Add(this.SelectImagesBTN);
            this.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.Name = "Form1";
            this.Text = "Field owl";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.SizeChanged += new System.EventHandler(this.Form1_SizeChanged);
            ((System.ComponentModel.ISupportInitialize)(this.MapPicB)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.ImagePicB)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button SelectImagesBTN;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private System.Windows.Forms.Label StatusLabel;
        private System.Windows.Forms.PictureBox MapPicB;
        private System.Windows.Forms.PictureBox ImagePicB;
    }
}

