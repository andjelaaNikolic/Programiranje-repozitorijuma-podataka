
using Microsoft.VisualBasic.Logging;

namespace KlijentForme
{
    partial class GlavnaForma
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
            menuStrip1 = new MenuStrip();
            treningToolStripMenuItem = new ToolStripMenuItem();
            prikaziTreningeToolStripMenuItem = new ToolStripMenuItem();
            praćenjaToolStripMenuItem = new ToolStripMenuItem();
            podaciOKlijentuToolStripMenuItem = new ToolStripMenuItem();
            label1 = new Label();
            lblImePrezimeGlavna = new Label();
            buttonOdjava = new Button();
            menuStrip1.SuspendLayout();
            SuspendLayout();
            // 
            // menuStrip1
            // 
            menuStrip1.ImageScalingSize = new Size(20, 20);
            menuStrip1.Items.AddRange(new ToolStripItem[] { treningToolStripMenuItem, praćenjaToolStripMenuItem, podaciOKlijentuToolStripMenuItem });
            menuStrip1.Location = new Point(0, 0);
            menuStrip1.Name = "menuStrip1";
            menuStrip1.Size = new Size(464, 28);
            menuStrip1.TabIndex = 0;
            menuStrip1.Text = "menuStrip1";
            // 
            // treningToolStripMenuItem
            // 
            treningToolStripMenuItem.DropDownItems.AddRange(new ToolStripItem[] { prikaziTreningeToolStripMenuItem });
            treningToolStripMenuItem.Name = "treningToolStripMenuItem";
            treningToolStripMenuItem.Size = new Size(72, 24);
            treningToolStripMenuItem.Text = "Trening";
            // 
            // prikaziTreningeToolStripMenuItem
            // 
            prikaziTreningeToolStripMenuItem.Name = "prikaziTreningeToolStripMenuItem";
            prikaziTreningeToolStripMenuItem.Size = new Size(194, 26);
            prikaziTreningeToolStripMenuItem.Text = "Prikazi treninge";
            prikaziTreningeToolStripMenuItem.Click += prikaziTreningeToolStripMenuItem_Click;
            // 
            // praćenjaToolStripMenuItem
            // 
            praćenjaToolStripMenuItem.Name = "praćenjaToolStripMenuItem";
            praćenjaToolStripMenuItem.Size = new Size(79, 24);
            praćenjaToolStripMenuItem.Text = "Praćenja";
            praćenjaToolStripMenuItem.Click += praćenjaToolStripMenuItem_Click;
            // 
            // podaciOKlijentuToolStripMenuItem
            // 
            podaciOKlijentuToolStripMenuItem.Name = "podaciOKlijentuToolStripMenuItem";
            podaciOKlijentuToolStripMenuItem.Size = new Size(132, 24);
            podaciOKlijentuToolStripMenuItem.Text = "Podaci o klijentu";
            podaciOKlijentuToolStripMenuItem.Click += podaciOKlijentuToolStripMenuItem_Click;
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new Point(22, 56);
            label1.Name = "label1";
            label1.Size = new Size(63, 20);
            label1.TabIndex = 1;
            label1.Text = "Zdravo, ";
            // 
            // lblImePrezimeGlavna
            // 
            lblImePrezimeGlavna.AutoSize = true;
            lblImePrezimeGlavna.Location = new Point(91, 56);
            lblImePrezimeGlavna.Name = "lblImePrezimeGlavna";
            lblImePrezimeGlavna.Size = new Size(0, 20);
            lblImePrezimeGlavna.TabIndex = 2;
            // 
            // buttonOdjava
            // 
            buttonOdjava.Location = new Point(262, 320);
            buttonOdjava.Name = "buttonOdjava";
            buttonOdjava.Size = new Size(172, 44);
            buttonOdjava.TabIndex = 3;
            buttonOdjava.Text = "Odjavite se";
            buttonOdjava.UseVisualStyleBackColor = true;
            buttonOdjava.Click += buttonOdjava_Click;
            // 
            // GlavnaForma
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(464, 409);
            Controls.Add(buttonOdjava);
            Controls.Add(lblImePrezimeGlavna);
            Controls.Add(label1);
            Controls.Add(menuStrip1);
            Name = "GlavnaForma";
            Text = "Glavna forma";
            menuStrip1.ResumeLayout(false);
            menuStrip1.PerformLayout();
            ResumeLayout(false);
            PerformLayout();
        }

        private void buttonOdjava_Click(object sender, EventArgs e)
        {
            ulogovani = null;
            this.Close();
            LoginKlijent login = new LoginKlijent();
            login.Show();
        }

        private void praćenjaToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Pracenje pracenje = new Pracenje(ulogovani);
            pracenje.Show();
        }

        private void podaciOKlijentuToolStripMenuItem_Click(object sender, EventArgs e)
        {
            PodaciOKlijentu podaciOKorisniku1 = new PodaciOKlijentu(ulogovani);
            if (podaciOKorisniku1.ShowDialog() == DialogResult.OK)
            {

                OsveziPrikazNaGlavnojFormi();
            }
        }

        private void prikaziTreningeToolStripMenuItem_Click(object sender, EventArgs e)
        {
            SviTreninzi sviTreninzi = new SviTreninzi(ulogovani);
            sviTreninzi.Show();
        }


        private void OsveziPrikazNaGlavnojFormi()
        {

            lblImePrezimeGlavna.Text = ulogovani.ime + " " + ulogovani.prezime;

        }

        #endregion

        private MenuStrip menuStrip1;
        private ToolStripMenuItem treningToolStripMenuItem;
        private ToolStripMenuItem prikaziTreningeToolStripMenuItem;
        private Label label1;
        private Label lblImePrezimeGlavna;
        private Button buttonOdjava;
        //private ToolStripMenuItem podaciOTreneruToolStripMenuItem;
        private ToolStripMenuItem praćenjaToolStripMenuItem;
        private ToolStripMenuItem podaciOKlijentuToolStripMenuItem;
    }
}