using Domen;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DBBroker
{
    public class KlijentBroker
    {


        DBConnection connection;
        private static KlijentBroker instance;
        private KlijentBroker()
        {
            connection = new DBConnection();
        }
        public static KlijentBroker Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = new KlijentBroker();
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
                command.CommandText = "SELECT * FROM api_klijent.Login(@korisnickoIme, @lozinka)";
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
                        uloga = Uloga.klijent
                    };
                }
                return k;
            }
            catch (Exception ex)
            {
                Console.WriteLine("Greška pri prijavi klijenta: " + ex.Message);
                throw;
            }
            finally
            {
                connection.CloseConnection();
            }
        }

        public bool registrujKlijenta(Korisnik korisnik)
        {
            try
            {
                connection.OpenConnection();
                using SqlCommand command = connection.CreateCommand();
                command.CommandType = CommandType.StoredProcedure;
                command.CommandText = "api_klijent.RegistrujKlijenta";

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
                command.CommandText = "SELECT api_klijent.PostojiKorisnickoIme(@korisnicko_ime)";
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
                command.CommandText = "SELECT api_klijent.PostojiEmail(@email)";
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

        public bool promeniKlijenta(Korisnik korisnik)
        {
            try
            {
                connection.OpenConnection();
                using SqlCommand command = connection.CreateCommand();
                command.CommandType = CommandType.StoredProcedure;
                command.CommandText = "api_klijent.PromeniKlijenta";

                command.Parameters.AddWithValue("@id", korisnik.id);
                command.Parameters.AddWithValue("@ime", korisnik.ime);
                command.Parameters.AddWithValue("@prezime", korisnik.prezime);
                command.Parameters.AddWithValue("@email", korisnik.email);
                command.Parameters.AddWithValue("@korisnicko_ime", korisnik.korisnicko_ime);

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
                    throw;

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
                command.CommandText = "SELECT api_klijent.PostojiKorisnickoIme_ID(@korisnicko_ime,@id)";
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
                command.CommandText = "SELECT api_klijent.PostojiEmail_ID(@email,@id)";
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

        public List<Trening> listaTreninga()
        {
            List<Trening> lista = new List<Trening>();

            try
            {
                connection.OpenConnection();

                using SqlCommand cmd = connection.CreateCommand();
                cmd.CommandText = "api_klijent.VratiSveTreninge";
                cmd.CommandType = CommandType.StoredProcedure;
                using SqlDataReader reader = cmd.ExecuteReader();
                {
                    Trening trenutniTrening = null;
                    int poslednjiTreningId = -1;

                    while (reader.Read())
                    {
                        int treningId = (int)reader["id_trening"];
                        if (trenutniTrening == null || treningId != poslednjiTreningId)
                        {
                            trenutniTrening = new Trening
                            {
                                id = treningId,
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
                            lista.Add(trenutniTrening);
                            poslednjiTreningId = treningId;
                        }

                        if (reader["rb_stavke"] != DBNull.Value)
                        {
                            StavkaTreninga stavka = new StavkaTreninga
                            {
                                rb = (int)reader["rb_stavke"],
                                trening = trenutniTrening,
                                broj_ponavljanja = reader["broj_ponavljanja"] != DBNull.Value ? Convert.ToInt32(reader["broj_ponavljanja"]) : 0,
                                broj_serija = reader["broj_serija"] != DBNull.Value ? Convert.ToInt32(reader["broj_serija"]) : 0,
                                trajanje = reader["trajanje"] != DBNull.Value ? Convert.ToInt32(reader["trajanje"]) : 0,
                                vezba = new Vezba
                                {
                                    id = reader["id_vezba"] != DBNull.Value ? Convert.ToInt32(reader["id_vezba"]) : 0,
                                    naziv = reader["naziv_vezba"]?.ToString(),
                                    misicna_grupa = reader["misicna_grupa"]?.ToString()
                                }
                            };
                            trenutniTrening.stavke.Add(stavka);
                        }
                    }
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

        public bool kreirajPromeniPracenje(BindingList<Pracenje> pracenja, Korisnik korisnik)
        {
            DataTable table = new DataTable();
            table.Columns.Add("id_trening", typeof(int));
            table.Columns.Add("datum_pocetka", typeof(DateTime));
            table.Columns.Add("cilj_broj_treninga", typeof(int));

            foreach (Pracenje p in pracenja)
            {
                table.Rows.Add(p.trening.id, p.datum_pocetka, p.cilj_broj_treninga);
            }

            try
            {
                connection.OpenConnection();

                using SqlCommand command = connection.CreateCommand();
                command.CommandType = CommandType.StoredProcedure;
                command.CommandText = "api_klijent.AzurirajPracenja";

                command.Parameters.AddWithValue("@id_klijent", korisnik.id);

                SqlParameter tvpParam = command.Parameters.AddWithValue("@NoviPodaci", table);
                tvpParam.SqlDbType = SqlDbType.Structured;
                tvpParam.TypeName = "impl.PracenjeTip";

                command.ExecuteNonQuery();
                return true;
            }
            catch (SqlException ex)
            {
                connection.Rollback();

                if (ex.Number == 50001)
                    Console.WriteLine("Klijent ne postoji.");
                else if (ex.Number == 50002)
                    Console.WriteLine("Trening ne postoji.");
                else if (ex.Number == 50003)
                    Console.WriteLine("Ciljni broj treninga mora biti veći od 0.");
                else if (ex.Number == 50004)
                    Console.WriteLine("Datum početka je obavezan.");
                else if (ex.Number == 50005)
                    Console.WriteLine("Ne može isti trening da se nađe dva puta u listi.");
                else
                    Console.WriteLine("Greška: " + ex.Message);

                return false;
            }
            catch (Exception ex)
            {
                Console.WriteLine("Greska pri sinhronizaciji: " + ex.Message);
                return false;
            }
            finally
            {
                connection.CloseConnection();
            }
        }

        public List<Pracenje> vratiPracenjaZaKorisnika(Korisnik ulogovani)
        {
            List<Pracenje> lista = new List<Pracenje>();

            try
            {
                connection.OpenConnection();
                using SqlCommand cmd = connection.CreateCommand();
                cmd.CommandText = "SELECT * FROM api_klijent.MojaPracenja(@id_klijent)";
                cmd.CommandType = CommandType.Text;
                cmd.Parameters.AddWithValue("@id_klijent", ulogovani.id);

                using SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    Pracenje p = new Pracenje
                    {
                        korisnik = new Korisnik
                        {
                            id = (int)reader["KorisnikId"],
                            ime = reader["ime"].ToString(),
                            prezime = reader["prezime"].ToString(),
                            email = reader["email"].ToString()
                        },
                        trening = new Trening
                        {
                            id = (int)reader["TreningId"],
                            naziv = reader["naziv"].ToString(),
                            cilj = Enum.Parse<Cilj>(reader["cilj"].ToString()),
                            broj_treninga_nedeljno = (int)reader["broj_treninga_nedeljno"],
                            trener = new Korisnik
                            {
                                id = (int)reader["trener"]
                            }
                        },
                        datum_pocetka = (DateTime)reader["datum_pocetka"],
                        cilj_broj_treninga = (int)reader["cilj_broj_treninga"]
                    };

                    lista.Add(p);
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

        public List<Kardio> listaKardioVezbiKlijent()
        {
            List<Kardio> lista = new List<Kardio>();

            try
            {
                connection.OpenConnection();
                using SqlCommand cmd = connection.CreateCommand();
                cmd.CommandText = "SELECT * FROM api_klijent.VratiKardioVezbe()";
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

        public List<Snaga> listaVezbiSnageKlijent()
        {
            List<Snaga> lista = new List<Snaga>();

            try
            {
                connection.OpenConnection();
                using SqlCommand cmd = connection.CreateCommand();
                cmd.CommandText = "SELECT * FROM api_klijent.VratiVezbeSnage()";
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

       
    }
}
