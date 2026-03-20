/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   04_ImplFunkcije.sql
**  OPIS:       Kreiranje svih funkcija u semi impl:
**              - skalarne funkcije (fns)
**              - table-value funkcije (fnt)
**              - view-ovi (vw)
**  AUTOR:      Andjela (DbDeveloper)
**  NAPOMENA:   Pokrenuti nakon 02_KreiranjeTabela.sql
*/

USE [treninzi];
GO

-- =====================================================
-- 1. Skalarne funkcije (fns)
-- =====================================================

CREATE FUNCTION impl.PostojiEmail (@email NVARCHAR(50))
RETURNS BIT AS
BEGIN
    RETURN CASE WHEN EXISTS (SELECT 1 FROM impl.korisnik WHERE email = @email)
                THEN 1 ELSE 0 END;
END;
GO

CREATE FUNCTION impl.PostojiEmail_ID (@email NVARCHAR(50), @id INT)
RETURNS BIT AS
BEGIN
    RETURN CASE WHEN EXISTS (SELECT 1 FROM impl.korisnik WHERE email = @email AND id <> @id)
                THEN 1 ELSE 0 END;
END;
GO

CREATE FUNCTION impl.PostojiKorisnickoIme (@korisnicko_ime NVARCHAR(20))
RETURNS BIT AS
BEGIN
    RETURN CASE WHEN EXISTS (SELECT 1 FROM impl.korisnik WHERE korisnicko_ime = @korisnicko_ime)
                THEN 1 ELSE 0 END;
END;
GO

CREATE FUNCTION impl.PostojiKorisnickoIme_ID (@korisnicko_ime NVARCHAR(20), @id INT)
RETURNS BIT AS
BEGIN
    RETURN CASE WHEN EXISTS (SELECT 1 FROM impl.korisnik
                             WHERE korisnicko_ime = @korisnicko_ime AND id <> @id)
                THEN 1 ELSE 0 END;
END;
GO

CREATE FUNCTION impl.PostojiTrening (@naziv NVARCHAR(50))
RETURNS BIT AS
BEGIN
    RETURN CASE WHEN EXISTS (SELECT 1 FROM impl.trening WHERE naziv = @naziv)
                THEN 1 ELSE 0 END;
END;
GO

CREATE FUNCTION impl.PostojiTreningSaNazivom (@id INT, @naziv NVARCHAR(50))
RETURNS BIT AS
BEGIN
    RETURN CASE WHEN EXISTS (SELECT 1 FROM impl.trening WHERE naziv = @naziv AND id <> @id)
                THEN 1 ELSE 0 END;
END;
GO

CREATE FUNCTION impl.PostojiVezba (@naziv NVARCHAR(20))
RETURNS BIT AS
BEGIN
    RETURN CASE WHEN EXISTS (SELECT 1 FROM impl.vezba WHERE naziv = @naziv)
                THEN 1 ELSE 0 END;
END;
GO

PRINT '------------------------------------------------------------------';
PRINT N' impl skalarne funkcije (fns) su kreirane';
PRINT '------------------------------------------------------------------';
GO

-- =====================================================
-- 2. Table-value funkcije (fnt)
-- =====================================================

CREATE FUNCTION impl.LoginKorisnik (@korisnickoIme NVARCHAR(20), @lozinka NVARCHAR(15))
RETURNS TABLE AS RETURN
(
    SELECT id, ime, prezime, email, lozinka, korisnicko_ime, uloga
    FROM   impl.korisnik
    WHERE  korisnicko_ime = @korisnickoIme AND lozinka = @lozinka
);
GO

CREATE FUNCTION impl.VratiSveVezbe ()
RETURNS TABLE AS RETURN
(
    SELECT id, naziv, misicna_grupa
    FROM   impl.vwVezba
);
GO

CREATE FUNCTION impl.VratiKardioVezbe ()
RETURNS TABLE AS RETURN
(
    SELECT id, naziv, misicna_grupa, intervalni, intenzitet, prostor
    FROM   impl.vwVezba
    WHERE  tip_vezbe = N'kardio'
);
GO

CREATE FUNCTION impl.VratiVezbeSnage ()
RETURNS TABLE AS RETURN
(
    SELECT id, naziv, misicna_grupa, tip_opterecenja, oprema
    FROM   impl.vwVezba
    WHERE  tip_vezbe = N'snaga'
);
GO

CREATE FUNCTION impl.VratiPracenjaZaKorisnika (@id_klijent INT)
RETURNS TABLE AS RETURN
(
    SELECT *
    FROM   impl.vwPracenje
    WHERE  id_klijent = @id_klijent
);
GO

CREATE FUNCTION impl.ListaPracenjaTrening (@idTrening INT)
RETURNS TABLE AS RETURN
(
    SELECT id_klijent, id_trening, datum_pocetka, cilj_broj_treninga
    FROM   impl.vwPracenje
    WHERE  id_trening = @idTrening
);
GO

-- fnt: impl.ListaPracenjaTreningKlijent
-- Opis: Lista pracenja za dati trening sa podacima o klijentu
CREATE FUNCTION impl.ListaPracenjaTreningKlijent (@idTrening INT)
RETURNS TABLE AS RETURN
(
    SELECT *
    FROM   impl.vwPracenje
    WHERE  id_trening = @idTrening
);
GO

-- fnt: impl.VratiTreningeZaTrenera
-- Opis: Treninzi za konkretnog trenera sa stavkama
CREATE FUNCTION impl.VratiTreningeZaTrenera (@idTrener INT)
RETURNS TABLE AS RETURN
(
    SELECT *
    FROM   impl.vwTrening
    WHERE  id_trener = @idTrener
);
GO

-- fnt: impl.VratiStavkeTreningaFnt
-- Opis: Table-value funkcija - stavke treninga sa detaljima vezbi
--       Koristi se kroz spec.VratiStavkeTreningaFnt u api_klijent
CREATE FUNCTION impl.VratiStavkeTreningaFnt (@idTrening INT)
RETURNS TABLE AS RETURN
(
    SELECT rb, broj_ponavljanja, broj_serija, trajanje, naziv, misicna_grupa
    FROM   impl.vwStavkaTreninga
    WHERE  id_trening = @idTrening
);
GO



PRINT '------------------------------------------------------------------';
PRINT N' impl table-value funkcije (fnt) su kreirane';
PRINT '------------------------------------------------------------------';
GO

-- =====================================================
-- 3. View-ovi (vw)
-- =====================================================
-- Napomena: view-ovi su izdvojeni u zasebne fajlove
-- po arhitekturnim slojevima:
--   ImplVwKorisnik.sql, ImplVwTrening.sql,
--   ImplVwVezba.sql, ImplVwPracenje.sql,
--   ImplVwStavkaTreninga.sql
-- =====================================================

PRINT '------------------------------------------------------------------';
PRINT N' impl view-ovi (vw) su kreirani u zasebnim fajlovima';
PRINT '------------------------------------------------------------------';
GO