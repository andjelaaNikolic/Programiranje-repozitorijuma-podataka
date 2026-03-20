using Domen;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DBBroker
{
    public class TrenerBroker
    {

        DBConnection connection;
        private static TrenerBroker instance;
        private TrenerBroker()
        {
            connection = new DBConnection();
        }
        public static TrenerBroker Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = new TrenerBroker();
                }
                return instance;
            }
        }


        public Korisnik login(string korisnickoIme, string lozinka)
        {
            Korisnik k = null;
            try
            {
                connection.OpenConnection();
                using SqlCommand command = connection.CreateCommand();
                command.CommandText = "SELECT * FROM api_trener.Login(@korisnickoIme, @lozinka)";
                command.Parameters.AddWithValue("@korisnickoIme", korisnickoIme);
                command.Parameters.AddWithValue("@lozinka", lozinka);

                using SqlDataReader reader = command.ExecuteReader();
                if (reader.Read())
                {
                    k = new Korisnik
                    {
                        id = (int)reader["id"],
                        ime = reader["ime"].ToString(),
                        prezime = reader["prezime"].ToString(),
                        email = reader["email"].ToString(),
                        korisnicko_ime = reader["korisnicko_ime"].ToString(),
                        uloga = Uloga.trener
                    };
                }
                return k;
            }
            catch (Exception ex)
            {
                Console.WriteLine("Greška pri prijavi trenera: " + ex.Message);
                throw;
            }
            finally
            {
                connection.CloseConnection();
            }
        }

        public bool registrujTrenera(Korisnik korisnik)
        {
            try
            {
                connection.OpenConnection();
                using SqlCommand command = connection.CreateCommand();
                command.CommandType = CommandType.StoredProcedure;
                command.CommandText = "api_trener.RegistrujTrenera";

                command.Parameters.AddWithValue("@ime", korisnik.ime);
                command.Parameters.AddWithValue("@prezime", korisnik.prezime);
                command.Parameters.AddWithValue("@email", korisnik.email);
                command.Parameters.AddWithValue("@korisnicko_ime", korisnik.korisnicko_ime);
                command.Parameters.AddWithValue("@lozinka", korisnik.lozinka);

                command.ExecuteNonQuery();
                return true;
            }
            catch (SqlException ex)
            {
                if (ex.Number == 51001)
                    Console.WriteLine("Ime je obavezno.");
                else if (ex.Number == 51002)
                    Console.WriteLine("Prezime je obavezno.");
                else if (ex.Number == 51003)
                    Console.WriteLine("Korisničko ime je obavezno.");
                else if (ex.Number == 51004)
                    Console.WriteLine("Email je obavezan.");
                else if (ex.Number == 51007)
                    Console.WriteLine("Korisničko ime već postoji.");
                else if (ex.Number == 51008)
                    Console.WriteLine("Email već postoji.");
                else
                    Console.WriteLine("Greška: " + ex.Message);

                return false;
            }
            finally
            {
                connection.CloseConnection();
            }
        }

        public bool postojiKorisnickoIme(string korisnicko_ime)
        {
            bool postoji = false;

            try
            {
                connection.OpenConnection();
                using SqlCommand command = connection.CreateCommand();
                command.CommandText = "SELECT api_trener.PostojiKorisnickoIme(@korisnicko_ime)";
                command.Parameters.AddWithValue("@korisnicko_ime", korisnicko_ime);

                bool result = (bool)command.ExecuteScalar();
                if (result == true)
                {

                    postoji = true;

                }



            }
            catch (Exception ex)
            {
                Console.WriteLine("Greska: " + ex);
                throw;
            }
            finally
            {
                connection.CloseConnection();
            }

            return postoji;
        }

        public bool postojiEmail(string email)
        {
            bool postoji = false;

            try
            {
                connection.OpenConnection();
                using SqlCommand command = connection.CreateCommand();
                command.CommandText = "SELECT api_trener.PostojiEmail(@email)";
                command.Parameters.AddWithValue("@email", email);

                bool result = (bool)command.ExecuteScalar();
                if (result == true)
                {

                    postoji = true;

                }



            }
            catch (Exception ex)
            {
                Console.WriteLine("Greska: " + ex);
                throw;
            }
            finally
            {
                connection.CloseConnection();
            }

            return postoji;
        }

        public bool promeniTrenera(Korisnik korisnik)
        {
            try
            {
                connection.OpenConnection();
                using SqlCommand command = connection.CreateCommand();
                command.CommandType = CommandType.StoredProcedure;
                command.CommandText = "api_trener.PromeniTrenera";

                command.Parameters.AddWithValue("@id", korisnik.id);
                command.Parameters.AddWithValue("@ime", korisnik.ime);
                command.Parameters.AddWithValue("@prezime", korisnik.prezime);
                command.Parameters.AddWithValue("@email", korisnik.email);
                command.Parameters.AddWithValue("@korisnicko_ime", korisnik.korisnicko_ime);
                //command.Parameters.AddWithValue("@lozinka", korisnik.lozinka);

                command.ExecuteNonQuery();
                return true;
            }
            catch (SqlException ex)
            {
                if (ex.Number == 51006)
                    Console.WriteLine("Korisnik ne postoji.");
                else if (ex.Number == 51001)
                    Console.WriteLine("Ime je obavezno.");
                else if (ex.Number == 51002)
                    Console.WriteLine("Prezime je obavezno.");
                else if (ex.Number == 51003)
                    Console.WriteLine("Korisničko ime je obavezno.");
                else if (ex.Number == 51004)
                    Console.WriteLine("Email je obavezan.");
                else if (ex.Number == 51007)
                    Console.WriteLine("Korisničko ime već postoji.");
                else if (ex.Number == 51008)
                    Console.WriteLine("Email već postoji.");
                else if (ex.Number == 51009)
                    Console.WriteLine("Nije moguće ažurirati korisnika.");
                else
                    throw;//Console.WriteLine("Greška: " + ex.Message);

                return false;
            }
            finally
            {
                connection.CloseConnection();
            }
        }

        public bool postojiKorisnickoImeID(string korisnicko_ime, int id)
        {

            try
            {
                connection.OpenConnection();
                using SqlCommand command = connection.CreateCommand();
                command.CommandText = "SELECT api_trener.PostojiKorisnickoIme_ID(@korisnicko_ime,@id)";
                command.Parameters.AddWithValue("@korisnicko_ime", korisnicko_ime);
                command.Parameters.AddWithValue("@id", id);

                object result = command.ExecuteScalar();

                if (result != null && result != DBNull.Value)
                {
                    return Convert.ToBoolean(result);
                }

                return false;



            }
            catch (Exception ex)
            {
                Console.WriteLine("Greska: " + ex);
                throw;
            }
            finally
            {
                connection.CloseConnection();
            }

        }

        public bool postojiEmailID(string email, int id)
        {

            try
            {
                connection.OpenConnection();
                using SqlCommand command = connection.CreateCommand();
                command.CommandText = "SELECT api_trener.PostojiEmail_ID(@email,@id)";
                command.Parameters.AddWithValue("@email", email);
                command.Parameters.AddWithValue("@id", id);

                object result = command.ExecuteScalar();

                if (result != null && result != DBNull.Value)
                {
                    return Convert.ToBoolean(result);
                }

                return false;



            }
            catch (Exception ex)
            {
                Console.WriteLine("Greska: " + ex);
                throw;
            }
            finally
            {
                connection.CloseConnection();
            }

        }

        public bool obrisiTrening(Trening tr)
        {
            bool uspesno = false;
            try
            {
                connection.OpenConnection();
                connection.BeginTransaction();
                using SqlCommand command = connection.CreateCommand();
                command.CommandType = CommandType.StoredProcedure;
                command.CommandText = "api_trener.ObrisiTrening";
                command.Parameters.Clear();
                command.Parameters.AddWithValue("@id_tr", tr.id);

                command.ExecuteNonQuery();

                uspesno = true;
                connection.Commit();


            }
            catch (SqlException ex)
            {
                connection.Rollback();
                if (ex.Number == 50001)
                    Console.WriteLine("Ne može da se obriše trening jer postoje praćenja.");
                else
                    Console.WriteLine("Greška: " + ex.Message);

                uspesno = false;
            }
            finally
            {
                connection.CloseConnection();
            }
            return uspesno;
        }

        public List<Pracenje> listaPracenjaTrening(Trening tr)
        {
            List<Pracenje> pracenja = new List<Pracenje>();
            try
            {
                connection.OpenConnection();
                using SqlCommand command = connection.CreateCommand();

                command.CommandText = "SELECT * FROM api_trener.KlijentiTreninga(@idTrening)";
                command.Parameters.AddWithValue("@idTrening", tr.id);

                using SqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    Pracenje pr = new Pracenje
                    {
                        datum_pocetka = (DateTime)reader["datum_pocetka"],
                        cilj_broj_treninga = (int)reader["cilj_broj_treninga"],
                        trening = new Trening
                        {
                            id = (int)reader["id_trening"]
                        },
                        korisnik = new Korisnik
                        {
                            id = (int)reader["id_klijent"],
                            ime = reader["ime"].ToString(),
                            prezime = reader["prezime"].ToString(),
                            email = reader["email"].ToString()
                        }
                    };
                    pracenja.Add(pr);
                }
                return pracenja;
            }
            catch (Exception ex)
            {
                Console.WriteLine("Greska: " + ex);
                throw;
            }
            finally
            {
                connection.CloseConnection();
            }
        }

        public List<Snaga> listaVezbiSnageTrener()
        {
            List<Snaga> lista = new List<Snaga>();

            try
            {
                connection.OpenConnection();
                using SqlCommand cmd = connection.CreateCommand();
                cmd.CommandText = "SELECT * FROM api_trener.VratiVezbeSnage()";
                cmd.CommandType = CommandType.Text;

                using SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    Snaga s = new Snaga
                    {
                        vezba = new Vezba
                        {
                            id = (int)reader["id"],
                            naziv = reader["naziv"].ToString(),
                            misicna_grupa = reader["misicna_grupa"].ToString()
                        },
                        tip_opterecenja = Enum.Parse<TipOpterecenja>(reader["tip_opterecenja"].ToString()),
                        oprema = (bool)reader["oprema"]
                    };

                    lista.Add(s);
                }

                return lista;
            }
            catch (Exception ex)
            {
                Console.WriteLine("Greska: " + ex.Message);
                throw;
            }
            finally
            {
                connection.CloseConnection();
            }
        }

        public List<Kardio> listaKardioVezbiTrener()
        {
            List<Kardio> lista = new List<Kardio>();

            try
            {
                connection.OpenConnection();
                using SqlCommand cmd = connection.CreateCommand();
                cmd.CommandText = "SELECT * FROM api_trener.VratiKardioVezbe()";
                cmd.CommandType = CommandType.Text;

                using SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    Kardio k = new Kardio
                    {
                        vezba = new Vezba
                        {
                            id = (int)reader["id"],
                            naziv = reader["naziv"].ToString(),
                            misicna_grupa = reader["misicna_grupa"].ToString()
                        },
                        intervalni = (bool)reader["intervalni"],
                        intenzitet = Enum.Parse<Intenzitet>(reader["intenzitet"].ToString()),
                        prostor = Enum.Parse<Prostor>(reader["prostor"].ToString())
                    };

                    lista.Add(k);
                }

                return lista;
            }
            catch (Exception ex)
            {
                Console.WriteLine("Greska: " + ex.Message);
                throw;
            }
            finally
            {
                connection.CloseConnection();
            }
        }

        public List<Vezba> vratiSveVezbe()
        {
            List<Vezba> vezbe = new List<Vezba>();

            try
            {
                connection.OpenConnection();

                using SqlCommand command = connection.CreateCommand();
                command.CommandText = "SELECT * FROM api_trener.VratiSveVezbe()";
                using SqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    Vezba v = new Vezba
                    {
                        id = (int)reader["id"],
                        naziv = reader["naziv"].ToString(),
                        misicna_grupa = reader["misicna_grupa"].ToString()
                    };
                    vezbe.Add(v);
                }

                return vezbe;
            }
            catch (Exception ex)
            {
                Console.WriteLine("Greska: " + ex.Message);
                throw;
            }
            finally
            {
                connection.CloseConnection();
            }
        }

        public List<Trening> vratiTreningeZaTrenera(Korisnik ulogovani)
        {
            List<Trening> treninzi = new List<Trening>();
            try
            {
                connection.OpenConnection();

                using SqlCommand command = connection.CreateCommand();
                command.CommandText = "SELECT * FROM api_trener.TreninziTrenera(@idTrener)";
                command.Parameters.AddWithValue("@idTrener", ulogovani.id);

                using SqlDataReader reader = command.ExecuteReader();
                Trening trenutniTrening = null;
                int poslednjiTreningId = -1;

                while (reader.Read())
                {
                    int idTreninga = (int)reader["id_trening"];

                    if (trenutniTrening == null || idTreninga != poslednjiTreningId)
                    {
                        trenutniTrening = new Trening
                        {
                            id = idTreninga,
                            naziv = reader["naziv_trening"].ToString(),
                            cilj = Enum.Parse<Cilj>(reader["cilj"].ToString()),
                            broj_treninga_nedeljno = (int)reader["broj_treninga_nedeljno"],
                            trener = new Korisnik
                            {
                                id = (int)reader["id_trener"],
                                ime = reader["trener_ime"].ToString(),
                                prezime = reader["trener_prezime"].ToString(),
                                email = reader["trener_email"].ToString()
                            },
                            stavke = new List<StavkaTreninga>()
                        };
                        treninzi.Add(trenutniTrening);
                        poslednjiTreningId = idTreninga;
                    }

                    if (reader["rb_stavke"] != DBNull.Value)
                    {
                        StavkaTreninga stavka = new StavkaTreninga
                        {
                            rb = (int)reader["rb_stavke"],
                            trening = trenutniTrening,
                            vezba = new Vezba
                            {
                                id = (int)reader["id_vezba"],
                                naziv = reader["naziv_vezba"].ToString(),
                                misicna_grupa = reader["misicna_grupa"].ToString()
                            },
                            broj_ponavljanja = reader["broj_ponavljanja"] != DBNull.Value ? (int)reader["broj_ponavljanja"] : 0,
                            broj_serija = reader["broj_serija"] != DBNull.Value ? (int)reader["broj_serija"] : 0,
                            trajanje = reader["trajanje"] != DBNull.Value ? (int)reader["trajanje"] : 0
                        };

                        trenutniTrening.stavke.Add(stavka);
                    }
                }

                return treninzi;
            }
            catch (Exception ex)
            {
                Console.WriteLine("Greska: " + ex.Message);
                throw;
            }
            finally
            {
                connection.CloseConnection();
            }
        }

        public bool promeniTrening(Trening trening)
        {
            bool uspesno = false;

            try
            {
                connection.OpenConnection();

                using (SqlCommand cmd = connection.CreateCommand())
                {
                    cmd.CommandText = "api_trener.IzmeniTrening";
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@id", trening.id);
                    cmd.Parameters.AddWithValue("@naziv", trening.naziv);
                    cmd.Parameters.AddWithValue("@cilj", Enum.GetName(typeof(Cilj), trening.cilj));
                    cmd.Parameters.AddWithValue("@broj_treninga_nedeljno", trening.broj_treninga_nedeljno);
                    cmd.Parameters.AddWithValue("@trener", trening.trener.id);

                    DataTable dtStavke = new DataTable();
                    dtStavke.Columns.Add("rb", typeof(int));
                    dtStavke.Columns.Add("broj_ponavljanja", typeof(int));
                    dtStavke.Columns.Add("broj_serija", typeof(int));
                    dtStavke.Columns.Add("trajanje", typeof(int));
                    dtStavke.Columns.Add("id_vezba", typeof(int));

                    if (trening.stavke != null)
                    {
                        foreach (StavkaTreninga stavka in trening.stavke)
                        {
                            dtStavke.Rows.Add(
                                stavka.rb,
                                stavka.broj_ponavljanja,
                                stavka.broj_serija,
                                stavka.trajanje,
                                stavka.vezba.id
                            );
                        }
                    }

                    SqlParameter param = cmd.Parameters.AddWithValue("@stavke", dtStavke);
                    param.SqlDbType = SqlDbType.Structured;
                    param.TypeName = "impl.StavkaTrTip";
                    cmd.ExecuteNonQuery();
                }

                uspesno = true;
            }
            catch (SqlException ex)
            {
                if (ex.Number == 53001)
                    Console.WriteLine("Naziv treninga je obavezan.");
                else if (ex.Number == 53003)
                    Console.WriteLine("Broj treninga mora biti između 1 i 7.");
                else if (ex.Number == 54001)
                    Console.WriteLine("Trener ne postoji.");
                else if (ex.Number == 53002)
                    Console.WriteLine("Trening sa tim nazivom već postoji.");
                else if (ex.Number == 53004)
                    Console.WriteLine("Ista vežba ne sme biti više puta u treningu.");
                else
                    Console.WriteLine("Greška: " + ex.Message);

                uspesno = false;
            }
            catch (Exception ex)
            {
                Console.WriteLine("Greska prilikom promene treninga: " + ex.Message);
                uspesno = false;
            }
            finally
            {
                connection.CloseConnection();
            }

            return uspesno;
        }

        public bool postojiVezba(string naziv)
        {
            try
            {
                connection.OpenConnection();
                using SqlCommand command = connection.CreateCommand();
                command.CommandText = "SELECT api_trener.PostojiVezba(@naziv)";
                command.Parameters.AddWithValue("@naziv", naziv);
                object result = command.ExecuteScalar();

                if (result != null && result != DBNull.Value)
                {
                    return Convert.ToBoolean(result);
                }
                return false;
            }
            catch (Exception ex)
            {
                connection.Rollback();
                Console.WriteLine("Greška: " + ex.Message);
                return false;
            }
            finally
            {
                connection.CloseConnection();
            }
        }

        public int kreirajVezbu(Vezba v, Kardio k = null, Snaga s = null)
        {
            int novaVezbaId = 0;

            try
            {
                connection.OpenConnection();
                connection.BeginTransaction();

                using (SqlCommand cmd = connection.CreateCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "api_trener.KreirajVezbu";

                    cmd.Parameters.AddWithValue("@naziv", v.naziv);
                    cmd.Parameters.AddWithValue("@misicna_grupa", v.misicna_grupa);

                    if (k != null)
                    {
                        cmd.Parameters.AddWithValue("@intervalni", k.intervalni);
                        cmd.Parameters.AddWithValue("@intenzitet", Enum.GetName(typeof(Intenzitet), k.intenzitet));
                        cmd.Parameters.AddWithValue("@prostor", Enum.GetName(typeof(Prostor), k.prostor));

                        cmd.Parameters.AddWithValue("@tip_opterecenja", DBNull.Value);
                        cmd.Parameters.AddWithValue("@oprema", DBNull.Value);
                    }
                    else if (s != null)
                    {
                        cmd.Parameters.AddWithValue("@tip_opterecenja", Enum.GetName(typeof(TipOpterecenja), s.tip_opterecenja));
                        cmd.Parameters.AddWithValue("@oprema", s.oprema);

                        cmd.Parameters.AddWithValue("@intervalni", DBNull.Value);
                        cmd.Parameters.AddWithValue("@intenzitet", DBNull.Value);
                        cmd.Parameters.AddWithValue("@prostor", DBNull.Value);
                    }
                    else
                    {
                        throw new Exception("Vežba mora biti ili kardio ili snaga!");
                    }

                    novaVezbaId = Convert.ToInt32(cmd.ExecuteScalar());
                }

                connection.Commit();
                return novaVezbaId;
            }
            catch (SqlException ex)
            {
                connection.Rollback();

                if (ex.Number == 52001)
                    Console.WriteLine("Naziv vežbe je obavezan.");
                else if (ex.Number == 52002)
                    Console.WriteLine("Naziv mišićne grupe je obavezan.");
                else if (ex.Number == 52003)
                    Console.WriteLine("Vežba sa tim nazivom već postoji.");
                else if (ex.Number == 52004)
                    Console.WriteLine("Vežba ne može biti istovremeno kardio i snaga.");
                else if (ex.Number == 52005)
                    Console.WriteLine("Vežba mora biti ili kardio ili snaga.");
                else
                    Console.WriteLine("Greška: " + ex.Message);

                return 0;
            }

            finally
            {
                connection.CloseConnection();
            }
        }

        public bool postojiTrening(string naziv)
        {
            try
            {
                connection.OpenConnection();
                using SqlCommand command = connection.CreateCommand();
                command.CommandText = "SELECT api_trener.PostojiTrening(@naziv)";
                command.Parameters.AddWithValue("@naziv", naziv);

                object result = command.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                {
                    return Convert.ToBoolean(result);
                }
                return false;


            }
            catch (Exception ex)
            {
                Console.WriteLine("Greška u radu sa bazom: " + ex.Message);
                throw;
            }
            finally
            {
                connection.CloseConnection();
            }
        }

        public int dodajTrening(Trening trening)
        {
            int noviId = -1;

            try
            {

                connection.OpenConnection();

                using SqlCommand cmd = connection.CreateCommand();
                cmd.CommandText = "api_trener.KreirajTrening";
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@naziv", trening.naziv);
                cmd.Parameters.AddWithValue("@cilj", Enum.GetName(typeof(Cilj), trening.cilj));
                cmd.Parameters.AddWithValue("@broj_treninga_nedeljno", trening.broj_treninga_nedeljno);
                cmd.Parameters.AddWithValue("@trener", trening.trener.id);

                DataTable stavkeTable = new DataTable();
                stavkeTable.Columns.Add("rb", typeof(int));
                stavkeTable.Columns.Add("broj_ponavljanja", typeof(int));
                stavkeTable.Columns.Add("broj_serija", typeof(int));
                stavkeTable.Columns.Add("trajanje", typeof(int));
                stavkeTable.Columns.Add("id_vezba", typeof(int));

                foreach (StavkaTreninga stavka in trening.stavke)
                {
                    stavkeTable.Rows.Add(stavka.rb, stavka.broj_ponavljanja, stavka.broj_serija, stavka.trajanje, stavka.vezba.id);
                }

                SqlParameter tvpParam = cmd.Parameters.AddWithValue("@stavke", stavkeTable);
                tvpParam.SqlDbType = SqlDbType.Structured;
                tvpParam.TypeName = "impl.StavkaTrTip";

                noviId = Convert.ToInt32(cmd.ExecuteScalar());
                trening.id = noviId;

                Console.WriteLine("Uspesno sacuvan trening sa svim stavkama. Novi ID: " + noviId);
            }
            catch (SqlException ex)
            {

                if (ex.Number == 53001)
                    Console.WriteLine("Naziv treninga je obavezan.");
                else if (ex.Number == 53002)
                    Console.WriteLine("Trening sa tim nazivom već postoji.");
                else if (ex.Number == 53003)
                    Console.WriteLine("Broj treninga nedeljno mora biti između 1 i 7.");
                else if (ex.Number == 54001)
                    Console.WriteLine("Trener ne postoji.");
                else
                    Console.WriteLine("Greška: " + ex.Message);

            }
            catch (Exception e)
            {
                Console.WriteLine("Greska: " + e.Message);
                Console.WriteLine("StackTrace: " + e.StackTrace);
            }

            finally
            {
                connection.CloseConnection();
            }

            return noviId;
        }

        public bool postojiTreningSaNazivom(int id, string naziv)
        {
            bool postoji = false;

            try
            {
                connection.OpenConnection();
                using SqlCommand cmd = connection.CreateCommand();
                cmd.CommandText = "SELECT api_trener.PostojiTreningSaNazivom(@id, @naziv)";
                cmd.CommandType = CommandType.Text;

                cmd.Parameters.AddWithValue("@id", id);
                cmd.Parameters.AddWithValue("@naziv", naziv);
                object result = cmd.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                {
                    postoji = Convert.ToBoolean(result);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Greska prilikom provere treninga: " + ex.Message);
                throw;
            }
            finally
            {
                connection.CloseConnection();
            }

            return postoji;
        }

    }
}
