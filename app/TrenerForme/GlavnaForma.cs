using Domen;
using Microsoft.VisualBasic.Logging;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace KlijentForme
{
    public partial class GlavnaForma : Form
    {
        private Korisnik ulogovani;
        public GlavnaForma(Korisnik korisnik)
        {
            InitializeComponent();
            ulogovani = korisnik;
            lblImePrezimeGlavna.Text = ulogovani.ime + " " + ulogovani.prezime;

        }

        private void GlavnaForma_Load(object sender, EventArgs e)
        {


        }

        private void buttonOdjava_Click(object sender, EventArgs e)
        {
            ulogovani = null;
            this.Close();
            LoginTrener login = new LoginTrener();
            login.Show();
        }

     
    }
}
