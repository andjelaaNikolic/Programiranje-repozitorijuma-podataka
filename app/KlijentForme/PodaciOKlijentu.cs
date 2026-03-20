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
    public partial class PodaciOKlijentu : Form
    {
        private Korisnik ulogovani;
        public PodaciOKlijentu(Korisnik korisnik)
        {
            InitializeComponent();
            ulogovani = korisnik;

            textBoxIme.Text = ulogovani.ime;
            textBoxPrezime.Text = ulogovani.prezime;
            textBoxEmail.Text = ulogovani.email;
            textBoxKIme.Text = ulogovani.korisnicko_ime;

            textBoxIme.Enabled = false;
            textBoxPrezime.Enabled = false;
            textBoxEmail.Enabled = false;
            textBoxKIme.Enabled = false;


            buttonPromeni.Visible = true;
            buttonPromeni.Enabled = true;

            buttonSacuvaj.Enabled = false;
            buttonSacuvaj.Visible = false;

            buttonZatvori.Visible = true;
            buttonZatvori.Enabled = true;

            buttonOtkazi.Visible = false;
            buttonOtkazi.Enabled = false;


        }

        private void buttonSacuvaj_Click(object sender, EventArgs e)
        {


            try
            {
                int id = ulogovani.id;
                String ime;
                String prezime;
                String email;
                String korisnicko_ime;

                ime = textBoxIme.Text.Trim();
                for (int i = 0; i < ime.ToLower().Length; i++)
                {
                    if (!char.IsLetter(ime[i]) && !char.IsWhiteSpace(ime[i]))
                    {
                        MessageBox.Show("Ime sme da sadrži samo slova i razmak");
                        return;
                    }


                }

                prezime = textBoxPrezime.Text.Trim();
                for (int i = 0; i < prezime.ToLower().Length; i++)
                {
                    if (!char.IsLetter(prezime[i]) && !char.IsWhiteSpace(prezime[i]))
                    {
                        MessageBox.Show("Prezime sme da sadrži samo slova");
                        return;
                    }
                }


                korisnicko_ime = textBoxKIme.Text.Trim();
                email = textBoxEmail.Text.Trim();

                if (ime.Length > 30 || prezime.Length > 30 || ime.Length < 3 || prezime.Length < 3)
                {
                    MessageBox.Show("Ime i prezime ne sme biti duže od 30 karaktera i kraće od 3 karaktera");
                    return;
                }
                if (email.Length > 50)
                {
                    MessageBox.Show("Email ne sme biti duži od 50 karaktera");
                    return;
                }
                if (korisnicko_ime.Length > 20)
                {
                    MessageBox.Show("Korisničko ime ne sme biti duže od 20 karaktera");
                    return;
                }

                if (!email.Contains("@"))
                {
                    MessageBox.Show("Email mora sadržati karakter @");
                    return;
                }

                bool korisnickoImePostoji = KlijentBroker.Instance.postojiKorisnickoImeID(korisnicko_ime, id);
                bool emailPostoji = KlijentBroker.Instance.postojiEmailID(email, id);

                if (korisnickoImePostoji == true)
                {
                    MessageBox.Show("Korisničko ime već postoji, izaberite drugo");
                    return;
                }

                if (emailPostoji == true)
                {
                    MessageBox.Show("Email već postoji u sistemu");
                    return;
                }


                ulogovani.ime = ime;
                ulogovani.prezime = prezime;
                ulogovani.email = email;
                ulogovani.korisnicko_ime = korisnicko_ime;

                try
                {
                    bool uspesno = KlijentBroker.Instance.promeniKlijenta(ulogovani);
                    if (uspesno)
                    {
                        MessageBox.Show("Uspešno su izmenjeni podaci o klijentu");
                        this.DialogResult = DialogResult.OK;
                    }
                }
                catch (SqlException ex)
                {
                    MessageBox.Show("SQL greška broj: " + ex.Number + "\n" + ex.Message);
                }

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }

        }


        private void buttonOtkazi_Click_1(object sender, EventArgs e)
        {
            textBoxIme.Text = ulogovani.ime;
            textBoxPrezime.Text = ulogovani.prezime;
            textBoxEmail.Text = ulogovani.email;
            textBoxKIme.Text = ulogovani.korisnicko_ime;

            textBoxIme.Enabled = false;
            textBoxPrezime.Enabled = false;
            textBoxEmail.Enabled = false;
            textBoxKIme.Enabled = false;


            buttonPromeni.Visible = true;
            buttonPromeni.Enabled = true;

            buttonSacuvaj.Enabled = false;
            buttonSacuvaj.Visible = false;

            buttonZatvori.Visible = true;
            buttonZatvori.Enabled = true;

            buttonOtkazi.Visible = false;
            buttonOtkazi.Enabled = false;

        }

        private void buttonZatvori_Click_1(object sender, EventArgs e)
        {
            this.Close();
        }

        private void buttonPromeni_Click_1(object sender, EventArgs e)
        {
            buttonPromeni.Visible = false;
            buttonPromeni.Enabled = false;

            buttonSacuvaj.Enabled = true;
            buttonSacuvaj.Visible = true;

            buttonZatvori.Visible = false;
            buttonZatvori.Enabled = false;

            buttonOtkazi.Visible = true;
            buttonOtkazi.Enabled = true;

            textBoxIme.Enabled = true;
            textBoxPrezime.Enabled = true;
            textBoxEmail.Enabled = true;
            textBoxKIme.Enabled = true;

        }
    }
}
