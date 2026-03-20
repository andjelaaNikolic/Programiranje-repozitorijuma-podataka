namespace KlijentForme
{
    partial class Pracenje
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
            dataGridViewPracenje = new DataGridView();
            panel1 = new Panel();
            buttonPromeni = new Button();
            buttonObrisi = new Button();
            textBoxBrTreninga = new TextBox();
            label4 = new Label();
            textBoxDatum = new TextBox();
            label3 = new Label();
            comboBoxTreninzi = new ComboBox();
            buttonDodaj = new Button();
            label1 = new Label();
            labelKlijent = new Label();
            buttonPrikazi = new Button();
            buttonSacuvaj = new Button();
            buttonIzvestaj = new Button();
            buttonOtkazi = new Button();
            ((System.ComponentModel.ISupportInitialize)dataGridViewPracenje).BeginInit();
            panel1.SuspendLayout();
            SuspendLayout();
            // 
            // dataGridViewPracenje
            // 
            dataGridViewPracenje.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewPracenje.Location = new Point(85, 111);
            dataGridViewPracenje.Name = "dataGridViewPracenje";
            dataGridViewPracenje.RowHeadersWidth = 51;
            dataGridViewPracenje.Size = new Size(417, 169);
            dataGridViewPracenje.TabIndex = 0;
            // 
            // panel1
            // 
            panel1.BackColor = SystemColors.ButtonShadow;
            panel1.Controls.Add(buttonPromeni);
            panel1.Controls.Add(buttonObrisi);
            panel1.Controls.Add(textBoxBrTreninga);
            panel1.Controls.Add(label4);
            panel1.Controls.Add(textBoxDatum);
            panel1.Controls.Add(label3);
            panel1.Controls.Add(comboBoxTreninzi);
            panel1.Controls.Add(buttonDodaj);
            panel1.Controls.Add(label1);
            panel1.Location = new Point(660, 28);
            panel1.Name = "panel1";
            panel1.Size = new Size(597, 313);
            panel1.TabIndex = 1;
            // 
            // buttonPromeni
            // 
            buttonPromeni.Location = new Point(324, 236);
            buttonPromeni.Name = "buttonPromeni";
            buttonPromeni.Size = new Size(94, 38);
            buttonPromeni.TabIndex = 9;
            buttonPromeni.Text = "Promeni";
            buttonPromeni.UseVisualStyleBackColor = true;
            buttonPromeni.Click += buttonPromeni_Click;
            // 
            // buttonObrisi
            // 
            buttonObrisi.Location = new Point(178, 236);
            buttonObrisi.Name = "buttonObrisi";
            buttonObrisi.Size = new Size(94, 38);
            buttonObrisi.TabIndex = 8;
            buttonObrisi.Text = "Obriši";
            buttonObrisi.UseVisualStyleBackColor = true;
            buttonObrisi.Click += buttonObrisi_Click;
            // 
            // textBoxBrTreninga
            // 
            textBoxBrTreninga.Location = new Point(303, 176);
            textBoxBrTreninga.Name = "textBoxBrTreninga";
            textBoxBrTreninga.Size = new Size(125, 27);
            textBoxBrTreninga.TabIndex = 7;
            // 
            // label4
            // 
            label4.AutoSize = true;
            label4.Location = new Point(36, 179);
            label4.Name = "label4";
            label4.Size = new Size(261, 20);
            label4.TabIndex = 6;
            label4.Text = "Koliko puta želite da odradite trening:";
            // 
            // textBoxDatum
            // 
            textBoxDatum.Location = new Point(178, 121);
            textBoxDatum.Name = "textBoxDatum";
            textBoxDatum.Size = new Size(271, 27);
            textBoxDatum.TabIndex = 5;
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Location = new Point(36, 124);
            label3.Name = "label3";
            label3.Size = new Size(114, 20);
            label3.TabIndex = 4;
            label3.Text = "Datum početka:";
            // 
            // comboBoxTreninzi
            // 
            comboBoxTreninzi.FormattingEnabled = true;
            comboBoxTreninzi.Location = new Point(178, 68);
            comboBoxTreninzi.Name = "comboBoxTreninzi";
            comboBoxTreninzi.Size = new Size(339, 28);
            comboBoxTreninzi.TabIndex = 3;
            // 
            // buttonDodaj
            // 
            buttonDodaj.Location = new Point(324, 236);
            buttonDodaj.Name = "buttonDodaj";
            buttonDodaj.Size = new Size(94, 38);
            buttonDodaj.TabIndex = 2;
            buttonDodaj.Text = "Dodaj";
            buttonDodaj.UseVisualStyleBackColor = true;
            buttonDodaj.Click += buttonDodaj_Click;
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new Point(36, 71);
            label1.Name = "label1";
            label1.Size = new Size(125, 20);
            label1.TabIndex = 1;
            label1.Text = "Dostupni treninzi:";
            label1.Click += label1_Click;
            // 
            // labelKlijent
            // 
            labelKlijent.AutoSize = true;
            labelKlijent.Location = new Point(21, 28);
            labelKlijent.Name = "labelKlijent";
            labelKlijent.Size = new Size(0, 20);
            labelKlijent.TabIndex = 3;
            // 
            // buttonPrikazi
            // 
            buttonPrikazi.Location = new Point(157, 316);
            buttonPrikazi.Name = "buttonPrikazi";
            buttonPrikazi.Size = new Size(128, 47);
            buttonPrikazi.TabIndex = 4;
            buttonPrikazi.Text = "Prikaži";
            buttonPrikazi.UseVisualStyleBackColor = true;
            buttonPrikazi.Click += buttonPrikazi_Click;
            // 
            // buttonSacuvaj
            // 
            buttonSacuvaj.Location = new Point(307, 316);
            buttonSacuvaj.Name = "buttonSacuvaj";
            buttonSacuvaj.Size = new Size(159, 47);
            buttonSacuvaj.TabIndex = 5;
            buttonSacuvaj.Text = "Sačuvaj promene";
            buttonSacuvaj.UseVisualStyleBackColor = true;
            buttonSacuvaj.Click += buttonSacuvaj_Click;
            // 
            // buttonIzvestaj
            // 
            buttonIzvestaj.Location = new Point(21, 316);
            buttonIzvestaj.Name = "buttonIzvestaj";
            buttonIzvestaj.Size = new Size(106, 47);
            buttonIzvestaj.TabIndex = 6;
            buttonIzvestaj.Text = "Izveštaj";
            buttonIzvestaj.UseVisualStyleBackColor = true;
            buttonIzvestaj.Click += buttonIzvestaj_Click;
            // 
            // buttonOtkazi
            // 
            buttonOtkazi.Location = new Point(489, 316);
            buttonOtkazi.Name = "buttonOtkazi";
            buttonOtkazi.Size = new Size(123, 47);
            buttonOtkazi.TabIndex = 7;
            buttonOtkazi.Text = "Otkaži";
            buttonOtkazi.UseVisualStyleBackColor = true;
            buttonOtkazi.Click += buttonOtkazi_Click;
            // 
            // Pracenje
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(1280, 404);
            Controls.Add(buttonOtkazi);
            Controls.Add(buttonIzvestaj);
            Controls.Add(buttonSacuvaj);
            Controls.Add(buttonPrikazi);
            Controls.Add(labelKlijent);
            Controls.Add(panel1);
            Controls.Add(dataGridViewPracenje);
            Name = "Pracenje";
            Text = "Treninzi";
            ((System.ComponentModel.ISupportInitialize)dataGridViewPracenje).EndInit();
            panel1.ResumeLayout(false);
            panel1.PerformLayout();
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private DataGridView dataGridViewPracenje;
        private Panel panel1;
        private Button buttonDodaj;
        private Label label1;
        private Label labelKlijent;
        private ComboBox comboBoxTreninzi;
        private TextBox textBoxBrTreninga;
        private Label label4;
        private TextBox textBoxDatum;
        private Label label3;
        private Button buttonObrisi;
        private Button buttonPromeni;
        private Button buttonPrikazi;
        private Button buttonSacuvaj;
        private Button buttonIzvestaj;
        private Button buttonOtkazi;
    }
}