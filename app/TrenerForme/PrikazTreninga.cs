using DBBroker;
using Domen;
using Microsoft.Data.SqlClient;
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
    public partial class PrikazTreninga : Form
    {
        private Korisnik ulogovani;
        private BindingList<Domen.Trening> treninzi;
        public PrikazTreninga(Korisnik korisnik)
        {
            ulogovani = korisnik;
            InitializeComponent();
            treninzi = new BindingList<Domen.Trening>(popuniTreninge());
            if (treninzi != null && treninzi.Count > 0)
            {

                dataGridView1.DataSource = treninzi;
                dataGridView1.Columns["trener"].Visible = false;
                //OsveziTreninge();
            }
            else
            {
                MessageBox.Show("Trener još uvek nije kreirao ni jedan trening");
              
            }

            labelTrener.Text = ulogovani.ime + " " + ulogovani.prezime;

        }

        private void buttonPrikaziTrening_Click(object sender, EventArgs e)
        {
            Domen.Trening trening = (Domen.Trening)dataGridView1.CurrentRow.DataBoundItem;
            if (trening != null)
            {
                //List<StavkaTreninga> stavke = Broker.Instance.vratiStavkeTreninga(trening);
                //trening.stavke = stavke;
                KlijentForme.Trening trening1 = new KlijentForme.Trening(trening, ulogovani);
                trening1.Show();
                this.Close();
            }
            else
            {
                MessageBox.Show("Niste izabrali trening za prikaz");
                return;
            }
        }

        public List<Domen.Trening> popuniTreninge()
        {
            List<Domen.Trening> treninziTrenerId = TrenerBroker.Instance.vratiTreningeZaTrenera(ulogovani);
            return treninziTrenerId;
        }

        private void buttonObrisi_Click(object sender, EventArgs e)
        {
            if (dataGridView1.CurrentRow == null)
            {
                MessageBox.Show("Niste izabrali trening");
                return;
            }
            else
            {

                Domen.Trening tr = (Domen.Trening)dataGridView1.CurrentRow.DataBoundItem;

                List<Domen.Pracenje> pracenja = TrenerBroker.Instance.listaPracenjaTrening(tr);
                if (pracenja != null && pracenja.Count > 0)
                {
                    MessageBox.Show("Nije moguće obrisati trening za koji postoje praćenja");
                    return;
                }


                else
                {

                    bool uspesno = TrenerBroker.Instance.obrisiTrening(tr);
                    try
                    {
                        if (uspesno == true)
                        {
                            MessageBox.Show("Uspešno ste obrisali trening");
                            OsveziTreninge();
                            return;
                        }
                        else
                        {
                            MessageBox.Show("Greška prilikom brisanja treninga");
                            return;

                        }
                    }
                    catch (SqlException ex)
                    {
                        MessageBox.Show($"Greška iz baze: {ex.Message}");
                        return;
                    }
                }

            }
        }

        private void OsveziTreninge()
        {
            List<Domen.Trening> trening = Broker.Instance.vratiTreningeZaTrenera(ulogovani);
            dataGridView1.DataSource = null;
            dataGridView1.DataSource = trening;
        }

        private void PrikazTreninga_Load(object sender, EventArgs e)
        {

        }
    }

}
