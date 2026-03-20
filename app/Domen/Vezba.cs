namespace Domen
{
    public class Vezba
    {

            public int id { get; set; }
            public string naziv { get; set; }
            public string misicna_grupa { get; set; }

        public override string? ToString()
        {
            return $"{naziv}"; 
            
        }
    }
}
