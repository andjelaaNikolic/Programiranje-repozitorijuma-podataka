namespace KlijentForme
{
    partial class PodaciOTreneru
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
            label1 = new Label();
            label2 = new Label();
            label3 = new Label();
            label4 = new Label();
            textBoxIme = new TextBox();
            textBoxPrezime = new TextBox();
            textBoxEmail = new TextBox();
            textBoxKIme = new TextBox();
            buttonPromeni = new Button();
            buttonSacuvaj = new Button();
            buttonZatvori = new Button();
            buttonOtkazi = new Button();
            SuspendLayout();
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new Point(89, 76);
            label1.Name = "label1";
            label1.Size = new Size(37, 20);
            label1.TabIndex = 0;
            label1.Text = "Ime:";
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Location = new Point(89, 135);
            label2.Name = "label2";
            label2.Size = new Size(65, 20);
            label2.TabIndex = 1;
            label2.Text = "Prezime:";
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Location = new Point(89, 203);
            label3.Name = "label3";
            label3.Size = new Size(49, 20);
            label3.TabIndex = 2;
            label3.Text = "Email:";
            // 
            // label4
            // 
            label4.AutoSize = true;
            label4.Location = new Point(86, 268);
            label4.Name = "label4";
            label4.Size = new Size(109, 20);
            label4.TabIndex = 3;
            label4.Text = "Korisničko ime:";
            // 
            // textBoxIme
            // 
            textBoxIme.Location = new Point(201, 69);
            textBoxIme.Name = "textBoxIme";
            textBoxIme.Size = new Size(188, 27);
            textBoxIme.TabIndex = 4;
            // 
            // textBoxPrezime
            // 
            textBoxPrezime.Location = new Point(201, 135);
            textBoxPrezime.Name = "textBoxPrezime";
            textBoxPrezime.Size = new Size(188, 27);
            textBoxPrezime.TabIndex = 5;
            // 
            // textBoxEmail
            // 
            textBoxEmail.Location = new Point(201, 203);
            textBoxEmail.Name = "textBoxEmail";
            textBoxEmail.Size = new Size(188, 27);
            textBoxEmail.TabIndex = 6;
            // 
            // textBoxKIme
            // 
            textBoxKIme.Location = new Point(201, 265);
            textBoxKIme.Name = "textBoxKIme";
            textBoxKIme.Size = new Size(188, 27);
            textBoxKIme.TabIndex = 7;
            // 
            // buttonPromeni
            // 
            buttonPromeni.Location = new Point(86, 338);
            buttonPromeni.Name = "buttonPromeni";
            buttonPromeni.Size = new Size(141, 60);
            buttonPromeni.TabIndex = 8;
            buttonPromeni.Text = "Promeni";
            buttonPromeni.UseVisualStyleBackColor = true;
            buttonPromeni.Click += buttonPromeni_Click;
            // 
            // buttonSacuvaj
            // 
            buttonSacuvaj.Location = new Point(86, 338);
            buttonSacuvaj.Name = "buttonSacuvaj";
            buttonSacuvaj.Size = new Size(141, 60);
            buttonSacuvaj.TabIndex = 9;
            buttonSacuvaj.Text = "Sačuvaj promene";
            buttonSacuvaj.UseVisualStyleBackColor = true;
            buttonSacuvaj.Click += buttonSacuvaj_Click;
            // 
            // buttonZatvori
            // 
            buttonZatvori.Location = new Point(260, 338);
            buttonZatvori.Name = "buttonZatvori";
            buttonZatvori.Size = new Size(129, 60);
            buttonZatvori.TabIndex = 10;
            buttonZatvori.Text = "Zatvori";
            buttonZatvori.UseVisualStyleBackColor = true;
            buttonZatvori.Click += buttonZatvori_Click;
            // 
            // buttonOtkazi
            // 
            buttonOtkazi.Location = new Point(260, 338);
            buttonOtkazi.Name = "buttonOtkazi";
            buttonOtkazi.Size = new Size(129, 60);
            buttonOtkazi.TabIndex = 11;
            buttonOtkazi.Text = "Otkaži";
            buttonOtkazi.UseVisualStyleBackColor = true;
            buttonOtkazi.Click += buttonOtkazi_Click;
            // 
            // PodaciOTreneru
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(563, 446);
            Controls.Add(buttonOtkazi);
            Controls.Add(buttonZatvori);
            Controls.Add(buttonSacuvaj);
            Controls.Add(buttonPromeni);
            Controls.Add(textBoxKIme);
            Controls.Add(textBoxEmail);
            Controls.Add(textBoxPrezime);
            Controls.Add(textBoxIme);
            Controls.Add(label4);
            Controls.Add(label3);
            Controls.Add(label2);
            Controls.Add(label1);
            Name = "PodaciOTreneru";
            Text = "Podaci";
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Label label1;
        private Label label2;
        private Label label3;
        private Label label4;
        private TextBox textBoxIme;
        private TextBox textBoxPrezime;
        private TextBox textBoxEmail;
        private TextBox textBoxKIme;
        private Button buttonPromeni;
        private Button buttonSacuvaj;
        private Button buttonZatvori;
        private Button buttonOtkazi;
    }
}