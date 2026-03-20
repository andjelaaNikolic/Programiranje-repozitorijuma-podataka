using Domen;
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
            kreirajTreningToolStripMenuItem = new ToolStripMenuItem();
            prikaziTreningeToolStripMenuItem = new ToolStripMenuItem();
            toolStripMenuItem1 = new ToolStripMenuItem();
            podaciOTreneruToolStripMenuItem = new ToolStripMenuItem();
            label1 = new Label();
            lblImePrezimeGlavna = new Label();
            buttonOdjava = new Button();
            menuStrip1.SuspendLayout();
            SuspendLayout();
            // 
            // menuStrip1
            // 
            menuStrip1.ImageScalingSize = new Size(20, 20);
            menuStrip1.Items.AddRange(new ToolStripItem[] { treningToolStripMenuItem, toolStripMenuItem1, podaciOTreneruToolStripMenuItem });
            menuStrip1.Location = new Point(0, 0);
            menuStrip1.Name = "menuStrip1";
            menuStrip1.Size = new Size(464, 28);
            menuStrip1.TabIndex = 0;
            menuStrip1.Text = "menuStrip1";
            // 
            // treningToolStripMenuItem
            // 
            treningToolStripMenuItem.DropDownItems.AddRange(new ToolStripItem[] { kreirajTreningToolStripMenuItem, prikaziTreningeToolStripMenuItem });
            treningToolStripMenuItem.Name = "treningToolStripMenuItem";
            treningToolStripMenuItem.Size = new Size(72, 24);
            treningToolStripMenuItem.Text = "Trening";
            // 
            // kreirajTreningToolStripMenuItem
            // 
            kreirajTreningToolStripMenuItem.Name = "kreirajTreningToolStripMenuItem";
            kreirajTreningToolStripMenuItem.Size = new Size(194, 26);
            kreirajTreningToolStripMenuItem.Text = "Kreiraj trening";
            kreirajTreningToolStripMenuItem.Click += kreirajTreningToolStripMenuItem_Click_1;
            // 
            // prikaziTreningeToolStripMenuItem
            // 
            prikaziTreningeToolStripMenuItem.Name = "prikaziTreningeToolStripMenuItem";
            prikaziTreningeToolStripMenuItem.Size = new Size(194, 26);
            prikaziTreningeToolStripMenuItem.Text = "Prikazi treninge";
            prikaziTreningeToolStripMenuItem.Click += prikaziTreningeToolStripMenuItem_Click_1;
            // 
            // toolStripMenuItem1
            // 
            toolStripMenuItem1.Name = "toolStripMenuItem1";
            toolStripMenuItem1.Size = new Size(109, 24);
            toolStripMenuItem1.Text = "Kreiraj vezbu";
            toolStripMenuItem1.Click += toolStripMenuItem1_Click;
            // 
            // podaciOTreneruToolStripMenuItem
            // 
            podaciOTreneruToolStripMenuItem.Name = "podaciOTreneruToolStripMenuItem";
            podaciOTreneruToolStripMenuItem.Size = new Size(131, 24);
            podaciOTreneruToolStripMenuItem.Text = "Podaci o treneru";
            podaciOTreneruToolStripMenuItem.Click += podaciOTreneruToolStripMenuItem_Click;
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
            buttonOdjava.Click += buttonOdjava_Click_1;
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
            Load += GlavnaForma_Load;
            menuStrip1.ResumeLayout(false);
            menuStrip1.PerformLayout();
            ResumeLayout(false);
            PerformLayout();
        }

        private void buttonOdjava_Click_1(object sender, EventArgs e)
        {
            ulogovani = null;
            this.Close();
            LoginTrener login = new LoginTrener();
            login.Show();
        }

        private void podaciOTreneruToolStripMenuItem_Click(object sender, EventArgs e)
        {
            PodaciOTreneru podaciOTr = new PodaciOTreneru(ulogovani);
            if (podaciOTr.ShowDialog() == DialogResult.OK)
            {

                OsveziPrikazNaGlavnojFormi();
            }
        }

        private void toolStripMenuItem1_Click(object sender, EventArgs e)
        {
            KreirajVezbu kreirajVezbu = new KreirajVezbu();
            kreirajVezbu.Show();
        }

        private void kreirajTreningToolStripMenuItem_Click_1(object sender, EventArgs e)
        {
            KlijentForme.Trening trening = new KlijentForme.Trening(ulogovani);
            trening.Show();
        }

        private void prikaziTreningeToolStripMenuItem_Click_1(object sender, EventArgs e)
        {
            PrikazTreninga prikazTreninga = new PrikazTreninga(ulogovani);
            prikazTreninga.Show();
        }

 

        private void OsveziPrikazNaGlavnojFormi()
        {

            lblImePrezimeGlavna.Text = ulogovani.ime + " " + ulogovani.prezime;

        }

        #endregion

        private MenuStrip menuStrip1;
        private ToolStripMenuItem treningToolStripMenuItem;
        private ToolStripMenuItem kreirajTreningToolStripMenuItem;
        private ToolStripMenuItem prikaziTreningeToolStripMenuItem;
        private Label label1;
        private Label lblImePrezimeGlavna;
        private Button buttonOdjava;
        private ToolStripMenuItem toolStripMenuItem1;
        private ToolStripMenuItem podaciOTreneruToolStripMenuItem;
    }
}