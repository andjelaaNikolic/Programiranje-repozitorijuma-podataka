namespace KlijentForme
{
    partial class LoginKlijent
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
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
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            button1 = new Button();
            textBoxKorisnickoIme = new TextBox();
            label1 = new Label();
            label2 = new Label();
            textBoxLozinka = new TextBox();
            button2 = new Button();
            label3 = new Label();
            SuspendLayout();
            // 
            // button1
            // 
            button1.BackColor = SystemColors.ButtonHighlight;
            button1.Location = new Point(190, 203);
            button1.Name = "button1";
            button1.Size = new Size(129, 39);
            button1.TabIndex = 0;
            button1.Text = "Potvrdi";
            button1.UseVisualStyleBackColor = false;
            button1.Click += button1_Click;
            // 
            // textBoxKorisnickoIme
            // 
            textBoxKorisnickoIme.Location = new Point(229, 86);
            textBoxKorisnickoIme.Name = "textBoxKorisnickoIme";
            textBoxKorisnickoIme.Size = new Size(241, 27);
            textBoxKorisnickoIme.TabIndex = 1;
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new Point(75, 89);
            label1.Name = "label1";
            label1.Size = new Size(109, 20);
            label1.TabIndex = 2;
            label1.Text = "Korisničko ime:";
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Location = new Point(75, 153);
            label2.Name = "label2";
            label2.Size = new Size(62, 20);
            label2.TabIndex = 3;
            label2.Text = "Lozinka:";
            // 
            // textBoxLozinka
            // 
            textBoxLozinka.Location = new Point(229, 146);
            textBoxLozinka.Name = "textBoxLozinka";
            textBoxLozinka.Size = new Size(241, 27);
            textBoxLozinka.TabIndex = 4;
            // 
            // button2
            // 
            button2.BackColor = SystemColors.ButtonHighlight;
            button2.Location = new Point(261, 268);
            button2.Name = "button2";
            button2.Size = new Size(129, 39);
            button2.TabIndex = 5;
            button2.Text = "Registrujte se";
            button2.UseVisualStyleBackColor = false;
            button2.Click += button2_Click;
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Location = new Point(134, 277);
            label3.Name = "label3";
            label3.Size = new Size(111, 20);
            label3.TabIndex = 6;
            label3.Text = "Nemate nalog?";
            // 
            // LoginKlijent
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(636, 378);
            Controls.Add(label3);
            Controls.Add(button2);
            Controls.Add(textBoxLozinka);
            Controls.Add(label2);
            Controls.Add(label1);
            Controls.Add(textBoxKorisnickoIme);
            Controls.Add(button1);
            Name = "LoginKlijent";
            Text = "Login ";
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Button button1;
        private TextBox textBoxKorisnickoIme;
        private Label label1;
        private Label label2;
        private TextBox textBoxLozinka;
        private Button button2;
        private Label label3;
    }
}