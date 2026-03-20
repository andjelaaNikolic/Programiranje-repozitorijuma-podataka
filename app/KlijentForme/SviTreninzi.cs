using DBBroker;
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
    public partial class SviTreninzi : Form
    {
        private List<Domen.Trening> treninzi;
        private Korisnik ulogovani;
        public SviTreninzi(Korisnik korisnik)
        {
            InitializeComponent();
            ulogovani = korisnik;
        }

        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void buttonSviTreninzi_Click(object sender, EventArgs e)
        {
            treninzi = KlijentBroker.Instance.listaTreninga();
            if (treninzi != null && treninzi.Count > 0)
            {
                dataGridViewTreninzi.DataSource = treninzi;
            }
            else
            {
                MessageBox.Show("Nema treninga u sistemu");
                return;
            }

        }

        private void buttonTrening_Click(object sender, EventArgs e)
        {
            if (dataGridViewTreninzi.CurrentRow == null)
            {
                MessageBox.Show("Niste izabrali trening");
                return;
            }
            Domen.Trening t = (Domen.Trening)dataGridViewTreninzi.CurrentRow.DataBoundItem;

            DetaljiTrening dt = new DetaljiTrening(t);
            dt.Show();


        }

        
    }
}
