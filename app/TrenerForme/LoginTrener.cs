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
    public partial class LoginTrener : Form
    {
        public LoginTrener()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            String korisnickoIme1 = textBoxKorisnickoIme.Text;
            String lozinka1 = textBoxLozinka.Text;

            Korisnik korisnik = TrenerBroker.Instance.login(korisnickoIme1, lozinka1);
            if (korisnik != null)
            {
                MessageBox.Show("Uspešno ste se prijavili");

                GlavnaForma glavnaForma = new GlavnaForma(korisnik);
                glavnaForma.Show();
                this.Hide();

            }
            else
            {
                MessageBox.Show("Pogrešno korisničko ime ili lozinka");
                return;
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            RegistrujTrenera registracija = new RegistrujTrenera();
            registracija.Show();
            this.Hide();
        }
    }
}
