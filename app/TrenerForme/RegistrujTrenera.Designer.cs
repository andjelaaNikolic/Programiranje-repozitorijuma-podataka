namespace KlijentForme
{
    partial class RegistrujTrenera
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
            label5 = new Label();
            textBoxIme = new TextBox();
            textBoxPrezime = new TextBox();
            textBoxEmail = new TextBox();
            textBoxKorisnickoIme = new TextBox();
            textBoxLozinka = new TextBox();
            button1 = new Button();
            button2 = new Button();
            SuspendLayout();
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new Point(83, 58);
            label1.Name = "label1";
            label1.Size = new Size(37, 20);
            label1.TabIndex = 0;
            label1.Text = "Ime:";
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Location = new Point(83, 119);
            label2.Name = "label2";
            label2.Size = new Size(65, 20);
            label2.TabIndex = 1;
            label2.Text = "Prezime:";
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Location = new Point(83, 177);
            label3.Name = "label3";
            label3.Size = new Size(49, 20);
            label3.TabIndex = 2;
            label3.Text = "Email:";
            // 
            // label4
            // 
            label4.AutoSize = true;
            label4.Location = new Point(83, 230);
            label4.Name = "label4";
            label4.Size = new Size(109, 20);
            label4.TabIndex = 3;
            label4.Text = "Korisničko ime:";
            // 
            // label5
            // 
            label5.AutoSize = true;
            label5.Location = new Point(83, 289);
            label5.Name = "label5";
            label5.Size = new Size(62, 20);
            label5.TabIndex = 4;
            label5.Text = "Lozinka:";
            // 
            // textBoxIme
            // 
            textBoxIme.Location = new Point(150, 55);
            textBoxIme.Name = "textBoxIme";
            textBoxIme.Size = new Size(237, 27);
            textBoxIme.TabIndex = 7;
            // 
            // textBoxPrezime
            // 
            textBoxPrezime.Location = new Point(154, 116);
            textBoxPrezime.Name = "textBoxPrezime";
            textBoxPrezime.Size = new Size(233, 27);
            textBoxPrezime.TabIndex = 8;
            // 
            // textBoxEmail
            // 
            textBoxEmail.Location = new Point(154, 170);
            textBoxEmail.Name = "textBoxEmail";
            textBoxEmail.Size = new Size(233, 27);
            textBoxEmail.TabIndex = 9;
            // 
            // textBoxKorisnickoIme
            // 
            textBoxKorisnickoIme.Location = new Point(198, 227);
            textBoxKorisnickoIme.Name = "textBoxKorisnickoIme";
            textBoxKorisnickoIme.Size = new Size(220, 27);
            textBoxKorisnickoIme.TabIndex = 10;
            // 
            // textBoxLozinka
            // 
            textBoxLozinka.Location = new Point(154, 286);
            textBoxLozinka.Name = "textBoxLozinka";
            textBoxLozinka.Size = new Size(252, 27);
            textBoxLozinka.TabIndex = 11;
            // 
            // button1
            // 
            button1.Location = new Point(93, 367);
            button1.Name = "button1";
            button1.Size = new Size(116, 46);
            button1.TabIndex = 12;
            button1.Text = "Potvrdi";
            button1.UseVisualStyleBackColor = true;
            button1.Click += button1_Click;
            // 
            // button2
            // 
            button2.Location = new Point(274, 367);
            button2.Name = "button2";
            button2.Size = new Size(113, 46);
            button2.TabIndex = 13;
            button2.Text = "Otkaži";
            button2.UseVisualStyleBackColor = true;
            button2.Click += button2_Click;
            // 
            // RegistrujTrenera
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(498, 458);
            Controls.Add(button2);
            Controls.Add(button1);
            Controls.Add(textBoxLozinka);
            Controls.Add(textBoxKorisnickoIme);
            Controls.Add(textBoxEmail);
            Controls.Add(textBoxPrezime);
            Controls.Add(textBoxIme);
            Controls.Add(label5);
            Controls.Add(label4);
            Controls.Add(label3);
            Controls.Add(label2);
            Controls.Add(label1);
            Name = "RegistrujTrenera";
            Text = "Registracija trenera";
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Label label1;
        private Label label2;
        private Label label3;
        private Label label4;
        private Label label5;
        //private ComboBox comboBoxUloga;
        private TextBox textBoxIme;
        private TextBox textBoxPrezime;
        private TextBox textBoxEmail;
        private TextBox textBoxKorisnickoIme;
        private TextBox textBoxLozinka;
        private Button button1;
        private Button button2;
    }
}
