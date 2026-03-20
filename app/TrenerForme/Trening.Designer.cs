
namespace KlijentForme
{
    partial class Trening
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
            label14 = new Label();
            labelNaziv = new Label();
            label16 = new Label();
            label17 = new Label();
            panel2 = new Panel();
            buttonObrisiKreiraj = new Button();
            textBoxDetalji = new TextBox();
            label15 = new Label();
            buttonDetalji = new Button();
            buttonPromenaDodaj = new Button();
            buttonPromeniStavku = new Button();
            buttonDodaj = new Button();
            textBoxTrajanje = new TextBox();
            buttonObrisi = new Button();
            label4 = new Label();
            comboBoxVezba = new ComboBox();
            textBoxSerije = new TextBox();
            textBoxPonavljanja = new TextBox();
            label1 = new Label();
            label3 = new Label();
            label2 = new Label();
            labelVezba = new Label();
            dataGridView2 = new DataGridView();
            textBoxTrener = new TextBox();
            textBoxNayiv = new TextBox();
            comboBoxCilj = new ComboBox();
            textBoxBrojTreninga = new TextBox();
            buttonKreiraj = new Button();
            buttonIzmeni = new Button();
            buttonPrikazi = new Button();
            panel2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)dataGridView2).BeginInit();
            SuspendLayout();
            // 
            // label14
            // 
            label14.AutoSize = true;
            label14.Location = new Point(25, 62);
            label14.Name = "label14";
            label14.Size = new Size(50, 20);
            label14.TabIndex = 0;
            label14.Text = "Trener";
            // 
            // labelNaziv
            // 
            labelNaziv.AutoSize = true;
            labelNaziv.Location = new Point(25, 116);
            labelNaziv.Name = "labelNaziv";
            labelNaziv.Size = new Size(108, 20);
            labelNaziv.TabIndex = 1;
            labelNaziv.Text = "Naziv treninga:";
            // 
            // label16
            // 
            label16.AutoSize = true;
            label16.Location = new Point(25, 171);
            label16.Name = "label16";
            label16.Size = new Size(160, 20);
            label16.TabIndex = 2;
            label16.Text = "Broj treninga nedeljno:";
            // 
            // label17
            // 
            label17.AutoSize = true;
            label17.Location = new Point(25, 231);
            label17.Name = "label17";
            label17.Size = new Size(30, 20);
            label17.TabIndex = 3;
            label17.Text = "Cilj";
            // 
            // panel2
            // 
            panel2.BackColor = SystemColors.AppWorkspace;
            panel2.Controls.Add(buttonObrisiKreiraj);
            panel2.Controls.Add(textBoxDetalji);
            panel2.Controls.Add(label15);
            panel2.Controls.Add(buttonDetalji);
            panel2.Controls.Add(buttonPromenaDodaj);
            panel2.Controls.Add(buttonPromeniStavku);
            panel2.Controls.Add(buttonDodaj);
            panel2.Controls.Add(textBoxTrajanje);
            panel2.Controls.Add(buttonObrisi);
            panel2.Controls.Add(label4);
            panel2.Controls.Add(comboBoxVezba);
            panel2.Controls.Add(textBoxSerije);
            panel2.Controls.Add(textBoxPonavljanja);
            panel2.Controls.Add(label1);
            panel2.Controls.Add(label3);
            panel2.Controls.Add(label2);
            panel2.Controls.Add(labelVezba);
            panel2.Location = new Point(459, 15);
            panel2.Name = "panel2";
            panel2.Size = new Size(604, 321);
            panel2.TabIndex = 4;
            // 
            // buttonObrisiKreiraj
            // 
            buttonObrisiKreiraj.Location = new Point(447, 249);
            buttonObrisiKreiraj.Name = "buttonObrisiKreiraj";
            buttonObrisiKreiraj.Size = new Size(122, 45);
            buttonObrisiKreiraj.TabIndex = 17;
            buttonObrisiKreiraj.Text = "Obriši";
            buttonObrisiKreiraj.UseVisualStyleBackColor = true;
            buttonObrisiKreiraj.Click += buttonObrisiKreiraj_Click;
            // 
            // textBoxDetalji
            // 
            textBoxDetalji.Location = new Point(150, 120);
            textBoxDetalji.Name = "textBoxDetalji";
            textBoxDetalji.Size = new Size(419, 27);
            textBoxDetalji.TabIndex = 16;
            // 
            // label15
            // 
            label15.AutoSize = true;
            label15.Location = new Point(36, 123);
            label15.Name = "label15";
            label15.Size = new Size(108, 20);
            label15.TabIndex = 15;
            label15.Text = "Detalji o vežbi:";
            // 
            // buttonDetalji
            // 
            buttonDetalji.Location = new Point(466, 59);
            buttonDetalji.Name = "buttonDetalji";
            buttonDetalji.Size = new Size(103, 45);
            buttonDetalji.TabIndex = 14;
            buttonDetalji.Text = "Detalji";
            buttonDetalji.UseVisualStyleBackColor = true;
            buttonDetalji.Click += buttonDetalji_Click;
            // 
            // buttonPromenaDodaj
            // 
            buttonPromenaDodaj.Location = new Point(299, 250);
            buttonPromenaDodaj.Name = "buttonPromenaDodaj";
            buttonPromenaDodaj.Size = new Size(116, 43);
            buttonPromenaDodaj.TabIndex = 12;
            buttonPromenaDodaj.Text = "Dodaj";
            buttonPromenaDodaj.UseVisualStyleBackColor = true;
            buttonPromenaDodaj.Click += buttonPromenaDodaj_Click;
            // 
            // buttonPromeniStavku
            // 
            buttonPromeniStavku.Location = new Point(299, 250);
            buttonPromeniStavku.Name = "buttonPromeniStavku";
            buttonPromeniStavku.Size = new Size(114, 44);
            buttonPromeniStavku.TabIndex = 11;
            buttonPromeniStavku.Text = "Promeni";
            buttonPromeniStavku.UseVisualStyleBackColor = true;
            buttonPromeniStavku.Click += buttonPromeniStavku_Click;
            // 
            // buttonDodaj
            // 
            buttonDodaj.Location = new Point(299, 251);
            buttonDodaj.Name = "buttonDodaj";
            buttonDodaj.Size = new Size(116, 43);
            buttonDodaj.TabIndex = 9;
            buttonDodaj.Text = "Dodaj";
            buttonDodaj.UseVisualStyleBackColor = true;
            buttonDodaj.Click += buttonDodaj_Click_1;
            // 
            // textBoxTrajanje
            // 
            textBoxTrajanje.Location = new Point(424, 174);
            textBoxTrajanje.Name = "textBoxTrajanje";
            textBoxTrajanje.Size = new Size(125, 27);
            textBoxTrajanje.TabIndex = 8;
            // 
            // buttonObrisi
            // 
            buttonObrisi.Location = new Point(447, 249);
            buttonObrisi.Name = "buttonObrisi";
            buttonObrisi.Size = new Size(122, 44);
            buttonObrisi.TabIndex = 10;
            buttonObrisi.Text = "Obrisi";
            buttonObrisi.UseVisualStyleBackColor = true;
            buttonObrisi.Click += buttonObrisi_Click;
            // 
            // label4
            // 
            label4.AutoSize = true;
            label4.Location = new Point(275, 177);
            label4.Name = "label4";
            label4.Size = new Size(143, 20);
            label4.TabIndex = 7;
            label4.Text = "Trajanje u minutima:";
            // 
            // comboBoxVezba
            // 
            comboBoxVezba.FormattingEnabled = true;
            comboBoxVezba.Location = new Point(94, 68);
            comboBoxVezba.Name = "comboBoxVezba";
            comboBoxVezba.Size = new Size(333, 28);
            comboBoxVezba.TabIndex = 6;
            //comboBoxVezba.SelectedIndexChanged += comboBoxVezba_SelectedIndexChanged;
            // 
            // textBoxSerije
            // 
            textBoxSerije.Location = new Point(130, 222);
            textBoxSerije.Name = "textBoxSerije";
            textBoxSerije.Size = new Size(107, 27);
            textBoxSerije.TabIndex = 5;
            // 
            // textBoxPonavljanja
            // 
            textBoxPonavljanja.Location = new Point(162, 174);
            textBoxPonavljanja.Name = "textBoxPonavljanja";
            textBoxPonavljanja.Size = new Size(75, 27);
            textBoxPonavljanja.TabIndex = 4;
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new Point(38, 227);
            label1.Name = "label1";
            label1.Size = new Size(78, 20);
            label1.TabIndex = 3;
            label1.Text = "Broj serija:";
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Location = new Point(36, 177);
            label3.Name = "label3";
            label3.Size = new Size(120, 20);
            label3.TabIndex = 2;
            label3.Text = "Broj ponavljanja:";
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Location = new Point(36, 71);
            label2.Name = "label2";
            label2.Size = new Size(52, 20);
            label2.TabIndex = 1;
            label2.Text = "Vežba:";
            // 
            // labelVezba
            // 
            labelVezba.AutoSize = true;
            labelVezba.Location = new Point(264, 22);
            labelVezba.Name = "labelVezba";
            labelVezba.Size = new Size(49, 20);
            labelVezba.TabIndex = 0;
            labelVezba.Text = "Vežba";
            // 
            // dataGridView2
            // 
            dataGridView2.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridView2.Location = new Point(25, 354);
            dataGridView2.Name = "dataGridView2";
            dataGridView2.RowHeadersWidth = 51;
            dataGridView2.Size = new Size(670, 214);
            dataGridView2.TabIndex = 5;
            // 
            // textBoxTrener
            // 
            textBoxTrener.Location = new Point(150, 62);
            textBoxTrener.Name = "textBoxTrener";
            textBoxTrener.Size = new Size(232, 27);
            textBoxTrener.TabIndex = 6;
            // 
            // textBoxNayiv
            // 
            textBoxNayiv.Location = new Point(150, 113);
            textBoxNayiv.Name = "textBoxNayiv";
            textBoxNayiv.Size = new Size(232, 27);
            textBoxNayiv.TabIndex = 7;
            // 
            // comboBoxCilj
            // 
            comboBoxCilj.FormattingEnabled = true;
            comboBoxCilj.Location = new Point(71, 231);
            comboBoxCilj.Name = "comboBoxCilj";
            comboBoxCilj.Size = new Size(211, 28);
            comboBoxCilj.TabIndex = 8;
            // 
            // textBoxBrojTreninga
            // 
            textBoxBrojTreninga.Location = new Point(197, 168);
            textBoxBrojTreninga.Name = "textBoxBrojTreninga";
            textBoxBrojTreninga.Size = new Size(116, 27);
            textBoxBrojTreninga.TabIndex = 9;
            // 
            // buttonKreiraj
            // 
            buttonKreiraj.Location = new Point(747, 443);
            buttonKreiraj.Name = "buttonKreiraj";
            buttonKreiraj.Size = new Size(127, 45);
            buttonKreiraj.TabIndex = 10;
            buttonKreiraj.Text = "Kreiraj";
            buttonKreiraj.UseVisualStyleBackColor = true;
            buttonKreiraj.Click += buttonKreiraj_Click;
            // 
            // buttonIzmeni
            // 
            buttonIzmeni.Location = new Point(747, 443);
            buttonIzmeni.Name = "buttonIzmeni";
            buttonIzmeni.Size = new Size(127, 45);
            buttonIzmeni.TabIndex = 11;
            buttonIzmeni.Text = "Sačuvaj izmene";
            buttonIzmeni.UseVisualStyleBackColor = true;
            buttonIzmeni.Click += buttonIzmeni_Click;
            // 
            // buttonPrikazi
            // 
            buttonPrikazi.Location = new Point(747, 373);
            buttonPrikazi.Name = "buttonPrikazi";
            buttonPrikazi.Size = new Size(127, 44);
            buttonPrikazi.TabIndex = 12;
            buttonPrikazi.Text = "Prikaži stavku";
            buttonPrikazi.UseVisualStyleBackColor = true;
            buttonPrikazi.Click += buttonPrikazi_Click;
            // 
            // Trening
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(1079, 580);
            Controls.Add(buttonPrikazi);
            Controls.Add(buttonIzmeni);
            Controls.Add(buttonKreiraj);
            Controls.Add(textBoxBrojTreninga);
            Controls.Add(comboBoxCilj);
            Controls.Add(textBoxNayiv);
            Controls.Add(textBoxTrener);
            Controls.Add(dataGridView2);
            Controls.Add(panel2);
            Controls.Add(label17);
            Controls.Add(label16);
            Controls.Add(labelNaziv);
            Controls.Add(label14);
            Name = "Trening";
            Text = "Trening";
            Load += Trening_Load;
            panel2.ResumeLayout(false);
            panel2.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)dataGridView2).EndInit();
            ResumeLayout(false);
            PerformLayout();
        }

        private void Trening_Load(object sender, EventArgs e)
        {
           
        }

        #endregion

        private Label labelVezba;
        private Label label2;
        private Label label3;
        private Label label4;
        private ComboBox comboBoxCilj;
        private TextBox textBoxNaziv;
        private TextBox textBoxBrojTreninga;
        private TextBox textBoxTrajanje;
        private ComboBox comboBoxVezba;
        private TextBox textBoxSerije;
        private TextBox textBoxPonavljanja;
        private Label label1;
        private Button buttonKreiraj;
        private Panel panel1;
        private Button buttonDodaj;
        private Label label5;
        private Label Vezba;
        private TextBox textBoxTrener;
        private DataGridView dataGridView1;
        private Label label10;
        private Label label9;
        private Label label7;
        private Label label6;
        private Label label8;
        private Label label11;
        private Label label13;
        private TextBox textBoxBrojSerija;
        private Label label12;
        private TextBox textBoxBrojPonavljanja;
        private PaintEventHandler panel1_Paint;
        private EventHandler buttonDodaj_Click;
        private EventHandler label1_Click;
        private Label label14;
        private Label labelNaziv;
        private Label label16;
        private Label label17;
        private Panel panel2;
        private DataGridView dataGridView2;
        private TextBox textBoxNayiv;
        private Button buttonObrisi;
        private Button buttonIzmeni;
        private Button buttonPrikazi;
        private Button buttonPromeniStavku;
        private Button buttonPromenaDodaj;
        private Button buttonDetalji;
        private TextBox textBoxDetalji;
        private Label label15;
        private Button buttonObrisiKreiraj;
    }
}