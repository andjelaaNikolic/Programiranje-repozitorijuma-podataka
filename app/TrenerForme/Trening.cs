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
using DBBroker;

namespace KlijentForme
{
    public partial class Trening : Form
    {
        private int brojac = 1;
        private int rbIzabranog;
        private StavkaTreninga izabrana;
        private Domen.Trening treningZaIzmenu;
        private Korisnik ulogovani;
        private Vezba vezbaZaIzmenu;
        private BindingList<StavkaTreninga> stavke;
        private BindingList<Kardio> kardioV;
        private BindingList<Snaga> snagaV;
        public Trening(Korisnik korisnik)
        {
            InitializeComponent();
            buttonIzmeni.Visible = false;
            buttonIzmeni.Enabled = false;

            buttonKreiraj.Visible = true;
            buttonKreiraj.Enabled = true;

            buttonPromeniStavku.Enabled = false;
            buttonPromeniStavku.Visible = false;

            buttonPrikazi.Visible = false;
            buttonPrikazi.Enabled = false;

            buttonObrisi.Visible = false;
            buttonObrisi.Enabled = false;

            buttonDodaj.Visible = true;
            buttonDodaj.Enabled = true;

            buttonPromenaDodaj.Visible = false;
            buttonPromenaDodaj.Enabled = false;

            buttonObrisiKreiraj.Visible = false;
            buttonObrisiKreiraj.Enabled = false;

            ulogovani = korisnik;
            textBoxTrener.Text = ulogovani.ime + " " + ulogovani.prezime;
            textBoxTrener.Enabled = false;
            stavke = new BindingList<StavkaTreninga>();

            kardioV = new BindingList<Kardio>(popuniKardio());
            snagaV = new BindingList<Snaga>(popuniSnagu());



            dataGridView2.DataSource = stavke;
            dataGridView2.Columns["trening"].Visible = false;
            comboBoxCilj.DataSource = Enum.GetValues(typeof(Cilj));
            comboBoxCilj.SelectedIndex = 0;
            popuniVezbe();
            comboBoxVezba.SelectedIndex = 0;



        }

      

        public Trening(Domen.Trening trening, Korisnik korisnik)
        {
            InitializeComponent();

            buttonIzmeni.Visible = true;
            buttonIzmeni.Enabled = true;

            buttonKreiraj.Visible = false;
            buttonKreiraj.Enabled = false;

            buttonPromeniStavku.Enabled = false;
            buttonPromeniStavku.Visible = false;

            buttonPrikazi.Visible = true;
            buttonPrikazi.Enabled = true;

            buttonDodaj.Visible = false;
            buttonDodaj.Enabled = false;

            buttonObrisi.Visible = false;
            buttonObrisi.Enabled = false;

            buttonPromenaDodaj.Visible = true;
            buttonPromenaDodaj.Enabled = true;

            buttonObrisiKreiraj.Visible = false;
            buttonObrisiKreiraj.Enabled = false;

            ulogovani = korisnik;
            treningZaIzmenu = trening;

            kardioV = new BindingList<Kardio>(popuniKardio());
            snagaV = new BindingList<Snaga>(popuniSnagu());

            textBoxTrener.Text = ulogovani.ime + " " + ulogovani.prezime;
            textBoxTrener.Enabled = false;
            textBoxNayiv.Text = trening.naziv;
            stavke = new BindingList<StavkaTreninga>(trening.stavke);
            dataGridView2.DataSource = stavke;
            dataGridView2.Columns["trening"].Visible = false;
            comboBoxCilj.DataSource = Enum.GetValues(typeof(Cilj));
            comboBoxCilj.SelectedItem = trening.cilj;
            textBoxBrojTreninga.Text = trening.broj_treninga_nedeljno.ToString();
            popuniVezbe();
            comboBoxVezba.SelectedIndex = 0;


        }


        private void buttonDodaj_Click_1(object sender, EventArgs e)
        {

            Vezba vezba = (Vezba)comboBoxVezba.SelectedItem;
            int brojSerija;
            int brojPonavljanja;
            int trajanje;

            foreach (StavkaTreninga st in stavke)
            {
                if (vezba.id == st.vezba.id)
                {
                    MessageBox.Show("Vežba već postoji u treningu");
                    return;
                }
            }

            if (textBoxPonavljanja.Text.Length == 0 && textBoxSerije.Text.Length == 0 && textBoxTrajanje.Text.Length == 0)
            {

                MessageBox.Show("Morate popuniti broj ponavljanja ili broj serija ili trajanje");
                return;

            }

            if (textBoxSerije.Text.Length > 0)
            {
                String brojSerije = textBoxSerije.Text.Trim();
                if (!int.TryParse(brojSerije, out brojSerija))
                {
                    MessageBox.Show("Broj serija sme sadržati samo cifre");
                    return;
                }
            }
            else
            {
                brojSerija = 0;
            }
            if (textBoxPonavljanja.Text.Length > 0)
            {
                String ponavljanja = textBoxPonavljanja.Text.Trim();
                if (!int.TryParse(ponavljanja, out brojPonavljanja))
                {
                    MessageBox.Show("Broj ponavljanja sme sadržati samo cifre");
                    return;
                }
            }
            else
            {
                brojPonavljanja = 0;
            }
            if (textBoxTrajanje.Text.Length > 0)
            {
                String trajanje1 = textBoxTrajanje.Text.Trim();
                if (!int.TryParse(trajanje1, out trajanje))
                {
                    MessageBox.Show("Trajanje sme sadržati samo cifre");
                    return;
                }
            }
            else
            {
                trajanje = 0;
            }

            


            StavkaTreninga stavka = new StavkaTreninga
            {
                rb = brojac++,
                vezba = vezba,
                broj_serija = brojSerija,
                broj_ponavljanja = brojPonavljanja,
                trajanje = trajanje
            };

            stavke.Add(stavka);

            isprazniPolja();
            buttonObrisiKreiraj.Visible = true;
            buttonObrisiKreiraj.Enabled = true;


        }

        private void buttonKreiraj_Click(object sender, EventArgs e)
        {

            String naziv = textBoxNayiv.Text.Trim();
            Cilj cilj = (Cilj)comboBoxCilj.SelectedItem;

            int brojTreningaNedeljno;

            if (textBoxBrojTreninga.Text.Trim().Length > 0)
            {
                String brtr = textBoxBrojTreninga.Text.Trim();
                for (int i = 0; i < brtr.Length; i++)
                {
                    if (!char.IsDigit(brtr[i]))
                    {
                        MessageBox.Show("Broj treninga nedeljno sme sadržati samo cifre");
                        return;
                    }
                }

                brojTreningaNedeljno = int.Parse(brtr);


            }
            else
            {
                MessageBox.Show("Broj treninga ne sme da bude prazno polje");
                return;
            }

            for (int i = 0; i < naziv.ToLower().Length; i++)
            {
                if (!char.IsLetter(naziv[i]) && !char.IsWhiteSpace(naziv[i]))
                {
                    MessageBox.Show("Naziv treninga sme sadržati samo slova i razmake");
                    return;
                }
            }



            Domen.Trening trening = new Domen.Trening
            {
                naziv = naziv,
                cilj = cilj,
                broj_treninga_nedeljno = brojTreningaNedeljno,
                trener = ulogovani,
                stavke = stavke.ToList()

            };


            bool postoji = TrenerBroker.Instance.postojiTrening(naziv);
            if (postoji == true)
            {
                MessageBox.Show("Trening sa tim nazivom već postoji");
                return;
            }
            else
            {
                int uspesno = TrenerBroker.Instance.dodajTrening(trening);
                if (uspesno > -1)
                {
                    MessageBox.Show("Uspešno ste kreirali trening");
                    this.Close();
                }
                else
                {
                    MessageBox.Show("Došlo je do greške prilikom kreiranja treninga");
                    return;
                }
            }
            isprazniPolja();

        }

        public void popuniVezbe()
        {
            List<Vezba> vezbe = TrenerBroker.Instance.vratiSveVezbe();
            comboBoxVezba.DataSource = vezbe;

        }

        private void buttonObrisi_Click(object sender, EventArgs e)
        {
            StavkaTreninga stavka = (StavkaTreninga)dataGridView2.CurrentRow.DataBoundItem;
            stavke.Remove(stavka);
            MessageBox.Show("Uspešno ste obrisali stavku treninga");
            buttonPromenaDodaj.Visible = true;
            buttonPromenaDodaj.Enabled = true;
            comboBoxVezba.Enabled = true;
            return;
        }

        private void buttonPrikazi_Click(object sender, EventArgs e)
        {
            if (dataGridView2.CurrentRow == null)
            {

                MessageBox.Show("Niste izabrali stavku");
                comboBoxVezba.Enabled = true;
                textBoxSerije.Text = "";
                textBoxPonavljanja.Text = "";
                textBoxTrajanje.Text = "";

                buttonPromeniStavku.Visible = false;
                buttonPromeniStavku.Enabled = false;

                buttonObrisi.Visible = false;
                buttonObrisi.Enabled = false;

                buttonPromenaDodaj.Visible = true;
                buttonPromenaDodaj.Enabled = true;

                return;
            }


            StavkaTreninga stavka = (StavkaTreninga)dataGridView2.CurrentRow.DataBoundItem;


            foreach (Vezba vezba in comboBoxVezba.Items)
            {
                if (vezba != null && vezba.id == stavka.vezba.id)
                {
                    comboBoxVezba.SelectedItem = vezba;
                    break;
                }
            }
            comboBoxVezba.Enabled = false;
            textBoxSerije.Text = stavka.broj_serija.ToString();
            textBoxPonavljanja.Text = stavka.broj_ponavljanja.ToString();
            textBoxTrajanje.Text = stavka.trajanje.ToString();

            buttonPromeniStavku.Visible = true;
            buttonPromeniStavku.Enabled = true;

            buttonObrisi.Visible = true;
            buttonObrisi.Enabled = true;

            buttonPromenaDodaj.Visible = false;
            buttonPromenaDodaj.Enabled = false;

            rbIzabranog = stavka.rb;
            izabrana = stavka;
            vezbaZaIzmenu = stavka.vezba;
        }

        private void buttonPromeniStavku_Click(object sender, EventArgs e)
        {

            comboBoxVezba.Enabled = false;



            int brojSerija;
            int brojPonavljanja;
            int trajanje;

            if (textBoxPonavljanja.Text.Length == 0 && textBoxSerije.Text.Length == 0 && textBoxTrajanje.Text.Length == 0)
            {

                MessageBox.Show("Morate popuniti broj ponavljanja ili broj serija ili trajanje");
                return;

            }

            if (textBoxSerije.Text.Length > 0)
            {
                String brojSerije = textBoxSerije.Text.Trim();
                for (int i = 0; i < brojSerije.Length; i++)
                {
                    if (!char.IsDigit(brojSerije.ToString()[i]))
                    {
                        MessageBox.Show("Broj serija sme sadržati samo cifre");
                        return;
                    }
                }
                brojSerija = int.Parse(brojSerije);
            }

            else
            {
                brojSerija = 0;
            }

            if (textBoxPonavljanja.Text.Length > 0)
            {
                String ponavljanja = textBoxPonavljanja.Text.Trim();
                for (int i = 0; i < ponavljanja.Length; i++)
                {
                    if (!char.IsDigit(ponavljanja[i]))
                    {
                        MessageBox.Show("Broj ponavljanja sme sadržati samo cifre");
                        return;
                    }
                }

                brojPonavljanja = int.Parse(textBoxPonavljanja.Text.Trim());

            }
            else
            {
                brojPonavljanja = 0;
            }



            if (textBoxTrajanje.Text.Length > 0)
            {
                String trajanje1 = textBoxTrajanje.Text.Trim();
                for (int i = 0; i < trajanje1.Length; i++)
                {
                    if (!char.IsDigit(trajanje1[i]))
                    {
                        MessageBox.Show("Trajanje sme sadržati samo cifre");
                        return;
                    }
                }
                trajanje = int.Parse(textBoxTrajanje.Text.Trim());
            }
            else
            {
                trajanje = 0;
            }

            if (brojPonavljanja == 0 && brojSerija == 0 && trajanje == 0)
            {

                MessageBox.Show("Ne mogu svi parametri da budu jednaki nuli");
                return;
            }

            stavke.Remove(izabrana);

            StavkaTreninga stavka = new StavkaTreninga
            {
                trening = treningZaIzmenu,
                rb = rbIzabranog,
                vezba = vezbaZaIzmenu,
                broj_serija = brojSerija,
                broj_ponavljanja = brojPonavljanja,
                trajanje = trajanje
            };



            stavke.Add(stavka);

            buttonPromenaDodaj.Visible = true;
            buttonPromenaDodaj.Enabled = true;
            comboBoxVezba.Enabled = true;

            isprazniPolja();

        }

        private void buttonIzmeni_Click(object sender, EventArgs e)
        {

            if (textBoxNayiv.Text.Trim().Length == 0 || textBoxBrojTreninga.Text.Trim().Length == 0)
            {
                MessageBox.Show("Polja ne smeju biti prazna");
            }

            String naziv = textBoxNayiv.Text.Trim();

            for (int i = 0; i < naziv.ToLower().Length; i++)
            {
                if (!char.IsLetter(naziv[i]) && !char.IsWhiteSpace(naziv[i]))
                {
                    MessageBox.Show("Naziv treninga sme sadržati samo slova i razmake");
                    return;
                }
            }


            bool postoji = TrenerBroker.Instance.postojiTreningSaNazivom(treningZaIzmenu.id, naziv);
            if (postoji == true)
            {
                MessageBox.Show("Trening sa tim nazivom već postoji");
                return;
            }

            Cilj cilj = (Cilj)comboBoxCilj.SelectedItem;

            int brojTreningaNedeljno;

            if (textBoxBrojTreninga.Text.Trim().Length > 0)
            {
                String brtr = textBoxBrojTreninga.Text.Trim();
                for (int i = 0; i < brtr.Length; i++)
                {
                    if (!char.IsDigit(brtr[i]))
                    {
                        MessageBox.Show("Broj treninga nedeljno sme sadržati samo cifre");
                        return;
                    }
                }

                brojTreningaNedeljno = int.Parse(brtr);


            }

            else
            {
                MessageBox.Show("Broj treninga ne sme da bude prazno polje");
                return;
            }
            if (brojTreningaNedeljno == 0)
            {
                MessageBox.Show("Broj treninga mora da bude veći od 0");
                return;
            }

            for (int i = 0; i < naziv.ToLower().Length; i++)
            {
                if (!char.IsLetter(naziv[i]) && !char.IsWhiteSpace(naziv[i]))
                {
                    MessageBox.Show("Naziv treninga sme sadržati samo slova i razmake");
                    return;
                }
            }


            Domen.Trening trening = new Domen.Trening
            {
                id = treningZaIzmenu.id,
                naziv = naziv,
                cilj = cilj,
                broj_treninga_nedeljno = brojTreningaNedeljno,
                trener = ulogovani,
                stavke = stavke.ToList()
            };


            bool uspesno = TrenerBroker.Instance.promeniTrening(trening);
            if (uspesno)
            {
                MessageBox.Show("Uspešno ste izmenili trening");
                this.Close();
                PrikazTreninga prikazTr = new PrikazTreninga(ulogovani);
                prikazTr.Show();
            }
            else
            {
                MessageBox.Show("Došlo je do greške prilikom izmene treninga");
                return;
            }



        }

        private void buttonPromenaDodaj_Click(object sender, EventArgs e)
        {
            Vezba vezba = (Vezba)comboBoxVezba.SelectedItem;

            int brojSerija;
            int brojPonavljanja;
            int trajanje;


            foreach (StavkaTreninga st in stavke)
            {
                if (vezba.id == st.vezba.id)
                {
                    MessageBox.Show("Vežba već postoji u treningu");
                    return;
                }
            }

            if (textBoxPonavljanja.Text.Length == 0 && textBoxSerije.Text.Length == 0 && textBoxTrajanje.Text.Length == 0)
            {

                MessageBox.Show("Morate popuniti broj ponavljanja ili broj serija ili trajanje");
                return;

            }


            if (textBoxSerije.Text.Length > 0)
            {
                String brojSerije = textBoxSerije.Text.Trim();
                if (!int.TryParse(brojSerije, out brojSerija))
                {
                    MessageBox.Show("Broj serija sme sadržati samo cifre");
                    return;
                }
            }
            else
            {
                brojSerija = 0;
            }
            if (textBoxPonavljanja.Text.Length > 0)
            {
                String ponavljanja = textBoxPonavljanja.Text.Trim();
                if (!int.TryParse(ponavljanja, out brojPonavljanja))
                {
                    MessageBox.Show("Broj ponavljanja sme sadržati samo cifre");
                    return;
                }
            }
            else
            {
                brojPonavljanja = 0;
            }
            if (textBoxTrajanje.Text.Length > 0)
            {
                String trajanje1 = textBoxTrajanje.Text.Trim();
                if (!int.TryParse(trajanje1, out trajanje))
                {
                    MessageBox.Show("Trajanje sme sadržati samo cifre");
                    return;
                }
            }
            else
            {
                trajanje = 0;
            }



            if (brojPonavljanja == 0 && brojSerija == 0 && trajanje == 0)
            {
                MessageBox.Show("Brojevi moraju da budu veći od 0");
                return;
            }

            int brojac = 0;
            if (treningZaIzmenu.stavke.Count > 0)
            {
                brojac = 1;
                for (int i = 1; i <= treningZaIzmenu.stavke.Count; i++)
                {
                    brojac++;
                }
            }
          
            int rbPoslednjeg = brojac+1;

            StavkaTreninga stavka = new StavkaTreninga
            {
                trening = treningZaIzmenu,
                rb = rbPoslednjeg,
                vezba = vezba,
                broj_serija = brojSerija,
                broj_ponavljanja = brojPonavljanja,
                trajanje = trajanje
            };

            stavke.Add(stavka);

            isprazniPolja();
        }
        

        private void buttonDetalji_Click(object sender, EventArgs e)
        {
            Vezba vezba = (Vezba)comboBoxVezba.SelectedItem;

            bool kardio = false;

            foreach (Kardio k in kardioV)
            {
                if (k.vezba.id == vezba.id)
                {
                    kardio = true;
                    textBoxDetalji.Text = k.ToString();
                    textBoxDetalji.ReadOnly = true;
                    break;
                }
            }

            if (kardio == false)
            {
                foreach (Snaga s in snagaV)
                {
                    if (s.vezba.id == vezba.id)
                    {
                        textBoxDetalji.Text = s.ToString();
                        textBoxDetalji.ReadOnly = true;
                        break;
                    }
                }
            }


        }

        public List<Kardio> popuniKardio()
        {
            List<Kardio> kardioVezbe = Broker.Instance.listaKardioVezbiTrener();
            if (kardioVezbe != null && kardioVezbe.Count > 0)
            {
                return kardioVezbe;
            }
            return null;
        }

        public List<Snaga> popuniSnagu()
        {
            List<Snaga> snagaVezbe = Broker.Instance.listaVezbiSnageTrener();
            if (snagaVezbe != null && snagaVezbe.Count > 0)
            {
                return snagaVezbe;
            }
            return null;

        }

        private void buttonObrisiKreiraj_Click(object sender, EventArgs e)
        {
            StavkaTreninga stavka = (StavkaTreninga)dataGridView2.CurrentRow.DataBoundItem;
            if (stavka != null)
            {
                stavke.Remove(stavka);
                MessageBox.Show("Obrisali ste stavku treninga");
                isprazniPolja();
            }
            else
            {
                MessageBox.Show("Niste izabrali stavku za brisanje");
                return;
            }

            buttonDodaj.Visible = true;
            buttonDodaj.Enabled = true;

            buttonObrisiKreiraj.Visible = false;
            buttonObrisiKreiraj.Enabled = false;

        }

        public void isprazniPolja()
        {
            textBoxPonavljanja.Text = "";
            textBoxSerije.Text = "";
            textBoxDetalji.Text = "";
            textBoxTrajanje.Text = "";
            comboBoxVezba.SelectedIndex = 0;
        }

    }
}

