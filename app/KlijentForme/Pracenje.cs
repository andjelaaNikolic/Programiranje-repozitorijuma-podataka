using DBBroker;
using Domen;
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static System.Windows.Forms.AxHost;

namespace KlijentForme
{
    public partial class Pracenje : Form
    {
        private Korisnik ulogovani;
        private BindingList<Domen.Pracenje> pracenja;
        private BindingList<Domen.Trening> treninzi;
        private Domen.Pracenje zaPromenu;

        public Pracenje(Korisnik korisnik)
        {
            InitializeComponent();
            ulogovani = korisnik;

            labelKlijent.Text = ulogovani.ime + " " + ulogovani.prezime;

            if (popuniTreninge() != null)
            {
                treninzi = new BindingList<Domen.Trening>(popuniTreninge());
                comboBoxTreninzi.DataSource = treninzi;

            }
            else
            {
                MessageBox.Show("Nema treninga u sistemu");
                this.Close();
            }
            comboBoxTreninzi.SelectedIndex = 0;
            

            if (popuniPracenja() != null)
            {
                pracenja = new BindingList<Domen.Pracenje>(popuniPracenja());
                dataGridViewPracenje.DataSource = pracenja;
                dataGridViewPracenje.Columns["korisnik"].Visible = false;
            }
            else
            {
                pracenja = new BindingList<Domen.Pracenje>();
                dataGridViewPracenje.DataSource = pracenja;
                dataGridViewPracenje.Columns["korisnik"].Visible = false;
            }

                buttonDodaj.Visible = true;
            buttonDodaj.Enabled = true;

            buttonPromeni.Visible = false;
            buttonPromeni.Enabled = false;

            buttonObrisi.Visible = false;
            buttonObrisi.Enabled = false;

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }


        public List<Domen.Trening> popuniTreninge()
        {
            List<Domen.Trening> trening = KlijentBroker.Instance.listaTreninga();
            if (trening != null && trening.Count > 0)
            {
                return trening;
            }
            else
            {
                return null;
            }

        }

        public List<Domen.Pracenje> popuniPracenja()
        {
            List<Domen.Pracenje> lista = KlijentBroker.Instance.vratiPracenjaZaKorisnika(ulogovani);
            if (lista == null || lista.Count == 0)
            {
                MessageBox.Show("Klijent još uvek nije izabrao treninge");
                return null;
            }
            return lista;
        }

        private void buttonDodaj_Click(object sender, EventArgs e)
        {
            Domen.Trening tr = (Domen.Trening)comboBoxTreninzi.SelectedItem;

            foreach (Domen.Trening t in treninzi)
            {
                if (t.id == tr.id)
                {
                    tr = t;
                    break;
                }
            }

            if (pracenja != null)
            {

                foreach (Domen.Pracenje p in pracenja)
                {
                    if (tr.id == p.trening.id)
                    {
                        MessageBox.Show("Trening je vec dodat");
                        return;
                    }

                }
            }

            if (textBoxDatum.Text == null || textBoxDatum.Text.Trim().Length == 0)
            {
                MessageBox.Show("Morate da unesete datum pocetka");
                return;
            }

            string datum = textBoxDatum.Text.Trim();
            DateTime datumPocetka;
            string[] formats = { "yyyy-MM-dd", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-ddTHH:mm:ss" };

            if (!System.DateTime.TryParseExact(datum, formats, System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None, out datumPocetka))
            {
                if (!System.DateTime.TryParse(datum, System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.AssumeLocal, out datumPocetka))
                {
                    MessageBox.Show("Neispravan format datuma. Očekivani: yyyy-MM-dd (npr. 2026-03-18) ili yyyy-MM-dd HH:mm:ss");
                    return;
                }
            }

            if (datumPocetka.Date < DateTime.Today)
            {
                MessageBox.Show("Datum početka ne može biti u prošlosti!");
                return;
            }


            int ciljaniBrojTreninga;
            if (textBoxBrTreninga.Text != null && textBoxBrTreninga.Text.Trim().Length > 0)
            {
                String ciljBr = textBoxBrTreninga.Text.Trim();

                for (int i = 0; i < ciljBr.Length; i++)
                {
                    if (!char.IsDigit(ciljBr[i]))
                    {
                        MessageBox.Show("Broj treninga sme sadržati samo cifre");
                        return;
                    }

                }
                ciljaniBrojTreninga = int.Parse(ciljBr);

            }
            else
            {
                MessageBox.Show("Morate uneti željeni broj treninga");
                return;
            }
            if (ciljaniBrojTreninga == 0)
            {
                MessageBox.Show("Željeni broj treninga mora da bude veći od 0");
                return;
            }



            Domen.Pracenje pr = new Domen.Pracenje
            {
                trening = tr,
                korisnik = ulogovani,
                datum_pocetka = datumPocetka,
                cilj_broj_treninga = ciljaniBrojTreninga,

            };

            pracenja.Add(pr);

            textBoxBrTreninga.Text = "";
            textBoxDatum.Text = "";


        }

        private void buttonPrikazi_Click(object sender, EventArgs e)
        {

            if (dataGridViewPracenje.CurrentRow == null)
            {
                MessageBox.Show("Niste izabrali stavku");
                textBoxBrTreninga.Text = "";
                textBoxDatum.Text = "";

                comboBoxTreninzi.Enabled = true;

                textBoxDatum.ReadOnly = false;

                buttonDodaj.Enabled = true;
                buttonDodaj.Visible = true;

                buttonObrisi.Enabled = false;
                buttonObrisi.Visible = false;

                buttonPromeni.Enabled = false;
                buttonPromeni.Visible = false;

                return;
            }

            buttonObrisi.Enabled = true;
            buttonObrisi.Visible = true;

            buttonPromeni.Enabled = true;
            buttonPromeni.Visible = true;

            Domen.Pracenje pracenje = (Domen.Pracenje)dataGridViewPracenje.CurrentRow.DataBoundItem;

            Domen.Trening t = pracenje.trening;

            foreach (Domen.Trening tr in comboBoxTreninzi.Items)
            {
                if (tr != null && tr.id == t.id)
                {
                    comboBoxTreninzi.SelectedItem = tr;
                    break;
                }
            }


            comboBoxTreninzi.Enabled = false;
            comboBoxTreninzi.SelectedItem = pracenje.trening;

            textBoxDatum.Text = pracenje.datum_pocetka.ToString();
            //textBoxDatum.ReadOnly = true;

            textBoxBrTreninga.Text = pracenje.cilj_broj_treninga.ToString();

            zaPromenu = pracenje;

        }

        private void buttonObrisi_Click(object sender, EventArgs e)
        {
            if (dataGridViewPracenje.CurrentRow == null)
            {
                MessageBox.Show("Niste izabrali stavku");
                return;
            }

            Domen.Pracenje p = (Domen.Pracenje)dataGridViewPracenje.CurrentRow.DataBoundItem;
            pracenja.Remove(p);
            MessageBox.Show("Uspešno ste obrisali trening");


            buttonPromeni.Enabled = false;
            buttonPromeni.Visible = false;

            buttonDodaj.Enabled = true;
            buttonDodaj.Visible = true;

            comboBoxTreninzi.Enabled = true;

            buttonObrisi.Enabled = false;
            buttonObrisi.Visible = false;

            return;


        }

        private void buttonPromeni_Click(object sender, EventArgs e)
        {

            Domen.Trening tr = zaPromenu.trening;
            foreach (Domen.Trening t in comboBoxTreninzi.Items)
            {
                if (tr.id == t.id)
                {
                    comboBoxTreninzi.SelectedItem = t;
                    comboBoxTreninzi.Enabled = false;
                }
            }


            String brTreninga;
            int ciljBrTreninga;
            if (textBoxBrTreninga.Text != null || textBoxBrTreninga.Text.Trim().Length > 0)
            {
                brTreninga = textBoxBrTreninga.Text.ToString();

                for (int i = 0; i < brTreninga.Length; i++)
                {
                    if (!char.IsDigit(brTreninga[i]))
                    {
                        MessageBox.Show("Ciljani broj treninga sme da sadrži samo brojeve");
                        return;
                    }
                }

                ciljBrTreninga = int.Parse(brTreninga);

            }
            else
            {
                MessageBox.Show("Morate uneti željeni broj treninga");
                return;
            }

            if (ciljBrTreninga == 0)
            {
                MessageBox.Show("Željeni broj treninga mora da bude veći od 0");
                return;
            }

            if (textBoxDatum.Text == null || textBoxDatum.Text.Trim().Length == 0)
            {
                MessageBox.Show("Morate da unesete datum početka");
                return;
            }


            string datum = textBoxDatum.Text.Trim();
            DateTime datumPocetka;
            string[] formats = { "yyyy-MM-dd", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-ddTHH:mm:ss" };

            if (!System.DateTime.TryParseExact(datum, formats, System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None, out datumPocetka))
            {
                if (!System.DateTime.TryParse(datum, System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.AssumeLocal, out datumPocetka))
                {
                    MessageBox.Show("Neispravan format datuma. Očekivani: yyyy-MM-dd (npr. 2026-03-18)");
                    return;
                }
            }

            if (datumPocetka.Date < DateTime.Today)
            {
                MessageBox.Show("Datum početka ne može biti u prošlosti!");
                return;
            }




            Domen.Pracenje pracenje = new Domen.Pracenje
            {

                trening = zaPromenu.trening,
                korisnik = ulogovani,
                cilj_broj_treninga = ciljBrTreninga,
                datum_pocetka = datumPocetka,

            };

            pracenja.Add(pracenje);
            pracenja.Remove(zaPromenu);

            buttonPromeni.Visible = false;
            buttonPromeni.Enabled = false;

            buttonDodaj.Visible = true;
            buttonDodaj.Enabled = true;

            buttonObrisi.Visible = false;
            buttonObrisi.Enabled = false;

            textBoxBrTreninga.Text = "";
            textBoxDatum.Text = "";

            comboBoxTreninzi.Enabled = true;



        }

        private void buttonSacuvaj_Click(object sender, EventArgs e)
        {


            bool uspesno = KlijentBroker.Instance.kreirajPromeniPracenje(pracenja, ulogovani);
            if (uspesno == true)
            {

                MessageBox.Show("Uspešno ste izvrsili promene");
                this.Close();

            }
            else
            {
                MessageBox.Show("Greška prilikom čuvanja promena");
                return;
            }





        }

        private void buttonIzvestaj_Click(object sender, EventArgs e)
        {
            if (pracenja == null || pracenja.Count == 0)
            {
                MessageBox.Show("Nema podataka za izvoz u izveštaj.");
                return;
            }

            SaveFileDialog saveFileDialog = new SaveFileDialog();
            saveFileDialog.Filter = "Text files (*.txt)|*.txt|All files (*.*)|*.*";
            saveFileDialog.Title = "Sačuvaj izveštaj o treninzima";
            saveFileDialog.FileName = $"Izvestaj_{ulogovani.ime}_{ulogovani.prezime}.txt";

            if (saveFileDialog.ShowDialog() == DialogResult.OK)
            {
                try
                {
                    using (System.IO.StreamWriter writer = new System.IO.StreamWriter(saveFileDialog.FileName))
                    {

                        writer.WriteLine("==================================================");
                        writer.WriteLine("        IZVEŠTAJ O PRAĆENJU TRENINGA");
                        writer.WriteLine("==================================================");
                        writer.WriteLine($"Klijent: {ulogovani.ime} {ulogovani.prezime}");
                        writer.WriteLine($"Datum generisanja: {DateTime.Now.ToString("dd.MM.yyyy. HH:mm")}");
                        writer.WriteLine("--------------------------------------------------");
                        writer.WriteLine();


                        int brojac = 1;
                        foreach (Domen.Pracenje p in pracenja)
                        {
                            writer.WriteLine($"{brojac}. TRENING: {p.trening.naziv}");
                            writer.WriteLine($"   Datum početka: {p.datum_pocetka.ToString("dd.MM.yyyy.")}");
                            writer.WriteLine($"   Ciljani broj treninga: {p.cilj_broj_treninga}");
                            writer.WriteLine("--------------------------------------------------");
                            brojac++;
                        }

                        writer.WriteLine();
                        writer.WriteLine("KRAJ IZVEŠTAJA");
                    }

                    MessageBox.Show("Izveštaj je uspešno generisan!", "Uspeh", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Greška prilikom upisa u datoteku: " + ex.Message, "Greška", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
        }

        private void buttonOtkazi_Click(object sender, EventArgs e)
        {
            comboBoxTreninzi.SelectedIndex = 0;
            comboBoxTreninzi.Enabled = true;
            textBoxBrTreninga.Text = "";
            textBoxDatum.Text = "";

            buttonDodaj.Visible = true;
            buttonDodaj.Enabled = true;

            buttonPromeni.Visible = false;
            buttonPromeni.Enabled = false;

            buttonObrisi.Visible = false;
            buttonObrisi.Enabled = false;
        }
    }
}
