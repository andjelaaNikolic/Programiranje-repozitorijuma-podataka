using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domen
{
    public class Korisnik
    {
        public int id { get; set; }
        public string ime { get; set; }
        public string prezime { get; set; } 
        public string email { get; set; }
        public string lozinka { get; set; }

        public string korisnicko_ime { get; set; }

        public Uloga uloga { get; set; }

        public override string? ToString()
        {
            return $"{ime} {prezime} {korisnicko_ime} {uloga}";

        }


    }
}
