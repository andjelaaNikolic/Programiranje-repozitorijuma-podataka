using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domen
{
    public class Pracenje
    {

        public Korisnik korisnik {  get; set; }
        public Trening trening { get; set; }

        public DateTime datum_pocetka { get; set; }

        public int cilj_broj_treninga { get; set; }

        public override string? ToString()
        {
            return $"{trening.naziv} {datum_pocetka} {cilj_broj_treninga}";
        }
    }
}
