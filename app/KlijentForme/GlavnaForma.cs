using Domen;
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

    }
}
