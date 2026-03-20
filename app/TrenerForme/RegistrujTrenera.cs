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
    public partial class RegistrujTrenera : Form
    {
        public RegistrujTrenera()
        {
            InitializeComponent();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            
            MessageBox.Show("Otkazali ste registraciju");
            this.Close();
        }

        private void button1_Click(object sender, EventArgs e)
        {

            String ime = textBoxIme.Text.Trim();
            String prezime = textBoxPrezime.Text.Trim();
            String korisnickoIme = textBoxKorisnickoIme.Text.Trim();
            String email = textBoxEmail.Text.Trim();
            String lozinka = textBoxLozinka.Text.Trim();

            if (ime.Length == 0 || prezime.Length == 0 || korisnickoIme.Length == 0 || lozinka.Length == 0 || email.Length == 0)
            {
                MessageBox.Show("Ni jedno polje ne sme biti prazno");
                return;
            }
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
            if (korisnickoIme.Length > 20)
            {
                MessageBox.Show("Korisničko ime ne sme biti duže od 20 karaktera");
                return;
            }
            if (lozinka.Length > 15 || lozinka.Length < 8)
            {
                MessageBox.Show("Lozinka ne sme biti kraća od 8 i duža od 15 karaktera");
                return;
            }

            if (!email.Contains("@"))
            {
                MessageBox.Show("Email mora sadržati karakter @");
                return;
            }

            for (int i = 0; i < ime.ToLower().Length; i++)
            {
                if (!char.IsLetter(ime[i]) && !char.IsWhiteSpace(ime[i]))
                {
                    MessageBox.Show("Ime sme da sadrži samo slova i razmak");
                    return;
                }
            }

            for (int i = 0; i < prezime.ToLower().Length; i++)
            {
                if (!char.IsLetter(prezime[i]) && !char.IsWhiteSpace(prezime[i]))
                {
                    MessageBox.Show("Prezime sme da sadrži samo slova");
                    return;
                }
            }

            bool korisnickoImePostoji = TrenerBroker.Instance.postojiKorisnickoIme(korisnickoIme);
            bool emailPostoji = TrenerBroker.Instance.postojiEmail(email);

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

            Korisnik korisnik = new Korisnik
            {
                ime = ime,
                prezime = prezime,
                email = email,
                lozinka = lozinka,
                korisnicko_ime = korisnickoIme,
            };

            bool uspesno1 = TrenerBroker.Instance.registrujTrenera(korisnik);

            if (uspesno1)
            {
                MessageBox.Show("Uspešno ste se registrovali");
                LoginTrener login = new LoginTrener();
                login.Show();
                this.Close();


            }
            else
            {
                MessageBox.Show("Došlo je do greške prilikom registracije");
                return;


            }

        }
    }
}
