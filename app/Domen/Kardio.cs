namespace Domen
{
    public class  Kardio
    {
        
        public Vezba vezba { get; set; }
        public Boolean intervalni { get; set; }

        public Intenzitet intenzitet { get; set; }

        public Prostor prostor { get; set; }

        public override string? ToString()
        {
            return $"Intenzitet: {intenzitet}, Intervalni:{intervalni}, Prostor: {prostor}, Grupa misica: {vezba.misicna_grupa}";

        }

    }
}
