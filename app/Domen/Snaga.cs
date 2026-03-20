namespace Domen
{
    public class  Snaga
    {

        public Vezba vezba { get; set; }
        public TipOpterecenja tip_opterecenja { get; set; }

        public Boolean oprema { get; set; }

        public override string? ToString()
        {
            return $"Tip opterecenja: {tip_opterecenja}, Oprema: {oprema}, Grupa misica: {vezba.misicna_grupa}";

        }



    }
}
