namespace KlijentForme
{
    partial class DetaljiTrening
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
            dataGridViewStavke = new DataGridView();
            buttonPrikazi = new Button();
            label1 = new Label();
            textBoxVezba = new TextBox();
            ((System.ComponentModel.ISupportInitialize)dataGridViewStavke).BeginInit();
            SuspendLayout();
            // 
            // dataGridViewStavke
            // 
            dataGridViewStavke.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewStavke.Location = new Point(26, 124);
            dataGridViewStavke.Name = "dataGridViewStavke";
            dataGridViewStavke.RowHeadersWidth = 51;
            dataGridViewStavke.Size = new Size(648, 219);
            dataGridViewStavke.TabIndex = 0;
            dataGridViewStavke.CellContentClick += dataGridViewStavke_CellContentClick;
            // 
            // buttonPrikazi
            // 
            buttonPrikazi.Location = new Point(716, 206);
            buttonPrikazi.Name = "buttonPrikazi";
            buttonPrikazi.Size = new Size(136, 79);
            buttonPrikazi.TabIndex = 1;
            buttonPrikazi.Text = "Prikaži više informacija o vežbi";
            buttonPrikazi.UseVisualStyleBackColor = true;
            buttonPrikazi.Click += buttonPrikazi_Click;
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new Point(26, 42);
            label1.Name = "label1";
            label1.Size = new Size(52, 20);
            label1.TabIndex = 2;
            label1.Text = "Vežba:";
            // 
            // textBoxVezba
            // 
            textBoxVezba.Location = new Point(105, 39);
            textBoxVezba.Name = "textBoxVezba";
            textBoxVezba.Size = new Size(711, 27);
            textBoxVezba.TabIndex = 3;
            // 
            // DetaljiTrening
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(941, 405);
            Controls.Add(textBoxVezba);
            Controls.Add(label1);
            Controls.Add(buttonPrikazi);
            Controls.Add(dataGridViewStavke);
            Name = "DetaljiTrening";
            Text = "Detalji o treningu";
            ((System.ComponentModel.ISupportInitialize)dataGridViewStavke).EndInit();
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private DataGridView dataGridViewStavke;
        private Button buttonPrikazi;
        private Label label1;
        private TextBox textBoxVezba;
    }
}