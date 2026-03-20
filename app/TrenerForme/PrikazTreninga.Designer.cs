namespace KlijentForme
{
    partial class PrikazTreninga
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
            dataGridView1 = new DataGridView();
            label1 = new Label();
            labelTrener = new Label();
            label2 = new Label();
            buttonPrikaziTrening = new Button();
            buttonObrisi = new Button();
            ((System.ComponentModel.ISupportInitialize)dataGridView1).BeginInit();
            SuspendLayout();
            // 
            // dataGridView1
            // 
            dataGridView1.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridView1.Location = new Point(26, 124);
            dataGridView1.Name = "dataGridView1";
            dataGridView1.RowHeadersWidth = 51;
            dataGridView1.Size = new Size(535, 191);
            dataGridView1.TabIndex = 0;
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new Point(56, 46);
            label1.Name = "label1";
            label1.Size = new Size(271, 20);
            label1.TabIndex = 1;
            label1.Text = "Lista svih treninga koje je kreirao trener:";
            // 
            // labelTrener
            // 
            labelTrener.AutoSize = true;
            labelTrener.Location = new Point(66, 84);
            labelTrener.Name = "labelTrener";
            labelTrener.Size = new Size(0, 20);
            labelTrener.TabIndex = 2;
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Location = new Point(66, 134);
            label2.Name = "label2";
            label2.Size = new Size(0, 20);
            label2.TabIndex = 3;
            // 
            // buttonPrikaziTrening
            // 
            buttonPrikaziTrening.Location = new Point(601, 134);
            buttonPrikaziTrening.Name = "buttonPrikaziTrening";
            buttonPrikaziTrening.Size = new Size(140, 53);
            buttonPrikaziTrening.TabIndex = 4;
            buttonPrikaziTrening.Text = "Prikaži trening";
            buttonPrikaziTrening.UseVisualStyleBackColor = true;
            buttonPrikaziTrening.Click += buttonPrikaziTrening_Click;
            // 
            // buttonObrisi
            // 
            buttonObrisi.Location = new Point(601, 214);
            buttonObrisi.Name = "buttonObrisi";
            buttonObrisi.Size = new Size(140, 48);
            buttonObrisi.TabIndex = 5;
            buttonObrisi.Text = "Obriši";
            buttonObrisi.UseVisualStyleBackColor = true;
            buttonObrisi.Click += buttonObrisi_Click;
            // 
            // PrikazTreninga
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(806, 344);
            Controls.Add(buttonObrisi);
            Controls.Add(buttonPrikaziTrening);
            Controls.Add(label2);
            Controls.Add(labelTrener);
            Controls.Add(label1);
            Controls.Add(dataGridView1);
            Name = "PrikazTreninga";
            Text = "Prikaz treninga";
            Load += PrikazTreninga_Load;
            ((System.ComponentModel.ISupportInitialize)dataGridView1).EndInit();
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private DataGridView dataGridView1;
        private Label label1;
        private Label labelTrener;
        private Label label2;
        private Button buttonPrikaziTrening;
        private Button buttonObrisi;
    }
}