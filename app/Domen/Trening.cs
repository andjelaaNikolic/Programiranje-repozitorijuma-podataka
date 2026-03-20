using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domen
{
    public class Trening
    {

        public int id { get; set; }

        public string naziv { get; set; }
        public Cilj cilj { get; set; }
        public int broj_treninga_nedeljno { get; set; }
        public  Korisnik trener { get; set; }

        public List<StavkaTreninga> stavke { get; set; } = new List<StavkaTreninga>();
        public override string? ToString()
        {
            if(trener!=null && trener.ime!=null && trener.prezime!=null)
            return $"{naziv} - {cilj} - {broj_treninga_nedeljno} - {trener.ime} - {trener.prezime}";
            else
            {
                return $"{naziv} - {cilj} - {broj_treninga_nedeljno}";
            }

        }


    }
}
