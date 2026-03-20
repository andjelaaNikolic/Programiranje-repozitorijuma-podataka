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
    public partial class DetaljiTrening : Form
    {
        private Domen.Trening trening;
        private List<StavkaTreninga> stavke;

        public DetaljiTrening(Domen.Trening tr)
        {
            InitializeComponent();
            trening = tr;
            if (trening.stavke != null && trening.stavke.Count > 0)
            {
                stavke = trening.stavke;
            }
            else
            {
                MessageBox.Show("Trening nema stavke");
                this.Close();
            }
            dataGridViewStavke.DataSource = stavke;
            dataGridViewStavke.Columns["trening"].Visible = false;


        }

        private void dataGridViewStavke_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void buttonPrikazi_Click(object sender, EventArgs e)
        {
            if (dataGridViewStavke.CurrentRow != null)
            {
                StavkaTreninga st = (StavkaTreninga)dataGridViewStavke.CurrentRow.DataBoundItem;
                Vezba vezba = st.vezba;

                List<Kardio> kardioV = popuniKardio();
                List<Snaga> snagaV = popuniSnagu();

                bool kardio = false;

                foreach (Kardio k in kardioV)
                {
                    if (k.vezba.id == vezba.id)
                    {
                        kardio = true;
                        textBoxVezba.Text = k.ToString();
                        textBoxVezba.ReadOnly = true;
                        break;
                    }
                }

                if (kardio == false)
                {
                    foreach (Snaga s in snagaV)
                    {
                        if (s.vezba.id == vezba.id)
                        {
                            textBoxVezba.Text = s.ToString();
                            textBoxVezba.ReadOnly = true;
                            break;
                        }
                    }
                }

            }
            else
            {
                MessageBox.Show("Niste izabrali stavku");
                return;
            }
        }



        public List<Kardio> popuniKardio()
        {
            List<Kardio> kardioVezbe = Broker.Instance.listaKardioVezbiKlijent();
            if (kardioVezbe != null && kardioVezbe.Count > 0)
            {
                return kardioVezbe;
            }
            return null;
        }

        public List<Snaga> popuniSnagu()
        {
            List<Snaga> snagaVezbe = Broker.Instance.listaVezbiSnageKlijent();
            if (snagaVezbe != null && snagaVezbe.Count > 0)
            {
                return snagaVezbe;
            }
            return null;

        }


    }
}
