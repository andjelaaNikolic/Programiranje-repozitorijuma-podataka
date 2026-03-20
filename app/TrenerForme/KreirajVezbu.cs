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
    public partial class KreirajVezbu : Form
    {
        public KreirajVezbu()
        {
            InitializeComponent();
            comboBoxIntenzitet.DataSource = Enum.GetValues(typeof(Intenzitet));
            comboBoxProstor.DataSource = Enum.GetValues(typeof(Prostor));
            comboBoxTipOpterecenja.DataSource = Enum.GetValues(typeof(TipOpterecenja));
            comboBoxIntenzitet.SelectedIndex = 0;
            comboBoxProstor.SelectedIndex = 0;
            comboBoxTipOpterecenja.SelectedIndex = 0;

            checkBoxKardio.CheckedChanged += checkBoxKardio_CheckedChanged;
            checkBoxSnaga.CheckedChanged += checkBoxSnaga_CheckedChanged;


            checkBoxKardio.Enabled = true;
            checkBoxSnaga.Enabled = true;
                checkBoxIntervalni.Enabled = false;
                checkBoxOprema.Enabled = false;
                comboBoxIntenzitet.Enabled = false;
                comboBoxProstor.Enabled = false;
                comboBoxTipOpterecenja.Enabled = false;
            



        }

        private void checkBoxKardio_CheckedChanged(object sender, EventArgs e)
        {
            AzurirajIzbor();
        }

        private void checkBoxSnaga_CheckedChanged(object sender, EventArgs e)
        {
            AzurirajIzbor();
        }




        private void AzurirajIzbor()
        {

            if (checkBoxKardio.Checked)
            {
                checkBoxSnaga.Enabled = false;
                checkBoxIntervalni.Enabled = true;
                checkBoxOprema.Enabled = false;
                comboBoxIntenzitet.Enabled = true;
                comboBoxProstor.Enabled = true;
                comboBoxTipOpterecenja.Enabled = false;

            }
            else if (checkBoxSnaga.Checked)
            {
                checkBoxKardio.Enabled = false;
                checkBoxIntervalni.Enabled = false;
                checkBoxOprema.Enabled = true;
                comboBoxIntenzitet.Enabled = false;
                comboBoxProstor.Enabled = false;
                comboBoxTipOpterecenja.Enabled = true;

            }
            else if (!checkBoxKardio.Checked && !checkBoxSnaga.Checked)
            {
                checkBoxKardio.Enabled = true;
                checkBoxSnaga.Enabled = true;
                checkBoxIntervalni.Enabled = false;
                checkBoxOprema.Enabled = false;
                comboBoxIntenzitet.Enabled = false;
                comboBoxProstor.Enabled = false;
                comboBoxTipOpterecenja.Enabled = false;

            }
            else
            {
                checkBoxIntervalni.Enabled = false;
                checkBoxOprema.Enabled = false;
                comboBoxIntenzitet.Enabled = false;
                comboBoxProstor.Enabled = false;
                comboBoxTipOpterecenja.Enabled = false;

            }
        }


        private void buttonKreiraj_Click(object sender, EventArgs e)
        {
            String naziv = textBoxNazivVezbe.Text.Trim();
            String misicnaGrupa = textBoxMisicnaGrupa.Text.Trim();

            if (naziv.Length == 0 || misicnaGrupa.Length == 0)
            {
                MessageBox.Show("Ni jedno polje ne sme da bude prazno");
                return;
            }

            for (int i = 0; i < naziv.ToLower().Length; i++)
            {
                if (!char.IsLetter(naziv[i]) && !char.IsWhiteSpace(naziv[i]))
                {
                    MessageBox.Show("Naziv sme da sadrži samo slova i razmake");
                    return;
                }
            }

            for (int i = 0; i < misicnaGrupa.ToLower().Length; i++)
            {
                if (!char.IsLetter(misicnaGrupa[i]) && !char.IsWhiteSpace(misicnaGrupa[i]))
                {
                    MessageBox.Show("Misicna grupa sme da sadrži samo slova i razmake");
                    return;
                }
            }

            Vezba v1 = new Vezba
            {

                naziv = naziv,
                misicna_grupa = misicnaGrupa


            };


            bool postoji = TrenerBroker.Instance.postojiVezba(naziv);

            if (postoji == true)
            {
                MessageBox.Show("Već postoji vežba sa tim nazivom");
                return;
            }

          

            if (checkBoxKardio.Checked)
            {

                bool intervalni;
                if (checkBoxIntervalni.Checked)
                {
                    intervalni = true;
                }
                else
                {
                    intervalni = false;
                }

                Intenzitet intenzitet = (Intenzitet)comboBoxIntenzitet.SelectedItem;
                Prostor prostor = (Prostor)comboBoxProstor.SelectedItem;
                
                Kardio k = new Kardio
                {
                    vezba = v1,
                    intervalni = intervalni,
                    intenzitet = intenzitet,
                    prostor = prostor

                };


                int uspesno = TrenerBroker.Instance.kreirajVezbu(v1,k,null);
                if (uspesno !=-1)
                {
                    MessageBox.Show("Uspešno ste kreirali kardio vežbu");
                    this.Close();
                }
                else
                {
                    MessageBox.Show("Došlo je do greške prilikom kreiranja vežbe");
                    return;
                }
            }
            else if (checkBoxSnaga.Checked)
            {
                bool oprema;
                if (checkBoxOprema.Checked)
                {
                    oprema = true;
                }
                else
                {
                    oprema = false;
                }
                TipOpterecenja tipOpterecenja = (TipOpterecenja)comboBoxTipOpterecenja.SelectedItem;
               
                Snaga s = new Snaga
                {
                    vezba = v1,
                    oprema = oprema,
                    tip_opterecenja = tipOpterecenja
                };

                int uspesno1 = TrenerBroker.Instance.kreirajVezbu(v1,null,s);
                if (uspesno1 >-1)
                {
                    MessageBox.Show("Uspešno ste kreirali vežbu snage");
                    this.Close();
                }
                else
                {
                    MessageBox.Show("Došlo je do greške prilikom kreiranja vežbe");
                    return;
                }

            }
            else if(!checkBoxKardio.Checked && !checkBoxSnaga.Checked)
            {
                MessageBox.Show("Morate izabrati tip vežbe");
                return;
            }


        }

     
    }
}

