/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   08_ApiKlijent.sql
**  OPIS:       Kreiranje api_klijent sheme.
**              Sve operacije koje klijent koristi u aplikaciji.
**  AUTOR:      Danilo (DbApiDeveloper)
**  NAPOMENA:   Pokrenuti nakon 07_ApiTrener.sql
*/

USE [treninzi];
GO

-- =====================================================
-- Table-value funkcije
-- =====================================================

-- fnt: api_klijent.MojaPracenja
CREATE FUNCTION api_klijent.MojaPracenja (@id_klijent INT)
RETURNS TABLE AS RETURN
(
    SELECT * FROM spec.VratiPracenjaZaKorisnika(@id_klijent)
);
GO

-- fnt: api_klijent.StavkeMogTreninga
-- Opis: Poziva spec.VratiStavkeTreninga - ne pristupa impl direktno
CREATE FUNCTION api_klijent.StavkeMogTreninga (@idTrening INT)
RETURNS TABLE AS RETURN
(
    SELECT rb, broj_ponavljanja, broj_serija, trajanje, naziv, misicna_grupa
    FROM spec.VratiStavkeTreningaFnt(@idTrening)
);
GO

-- fnt: api_klijent.SviTrenizi
-- Opis: Lista svih dostupnih planova treninga koje klijent moze da vidi
CREATE FUNCTION api_klijent.SviTreninzi ()
RETURNS TABLE AS RETURN
(
    SELECT * FROM spec.SviTreninzi()
);
GO

CREATE FUNCTION api_klijent.VratiKardioVezbe()
RETURNS TABLE AS RETURN
(
    SELECT * FROM spec.VratiKardioVezbe()
);
GO

CREATE FUNCTION api_klijent.VratiVezbeSnage()
RETURNS TABLE AS RETURN
(
    SELECT * FROM spec.VratiVezbeSnage()
);
GO

CREATE OR ALTER FUNCTION api_klijent.Login(@korisnickoIme NVARCHAR(20), @lozinka NVARCHAR(15))
RETURNS TABLE AS RETURN
(
    SELECT * FROM spec.LoginKorisnik(@korisnickoIme, @lozinka)
    WHERE uloga = 'klijent'
);
GO

-- =====================================================
-- Procedure
-- =====================================================


-- upr: api_klijent.RegistrujKorisnika
-- Opis: Registracija novog klijenta
CREATE OR ALTER PROCEDURE api_klijent.RegistrujKlijenta
    @ime            NVARCHAR(30),
    @prezime        NVARCHAR(30),
    @email          NVARCHAR(50),
    @korisnicko_ime NVARCHAR(20),
    @lozinka        NVARCHAR(15)
AS
BEGIN
    EXEC spec.DodajKorisnika
        @ime            = @ime,
        @prezime        = @prezime,
        @email          = @email,
        @uloga          = N'klijent',
        @korisnicko_ime = @korisnicko_ime,
        @lozinka        = @lozinka;
END;
GO




CREATE OR ALTER PROCEDURE api_klijent.PromeniKlijenta
    @id             INT,
    @ime            NVARCHAR(30),
    @prezime        NVARCHAR(30),
    @email          NVARCHAR(50),
    @korisnicko_ime NVARCHAR(20)
AS
BEGIN
    DECLARE @staraLozinka NVARCHAR(15) = spec.VratiLozinku(@id);

    EXEC spec.PromeniKorisnika
        @id             = @id,
        @ime            = @ime,
        @prezime        = @prezime,
        @email          = @email,
        @uloga          = N'klijent',
        @korisnicko_ime = @korisnicko_ime,
        @lozinka        = @staraLozinka;
END;
GO





-- upr: api_klijent.VratiSveTreninge
-- Opis: Svi treninzi sa stavkama - klijent bira trening koji zeli da prati
CREATE  OR ALTER PROCEDURE api_klijent.VratiSveTreninge
AS
BEGIN
    EXEC spec.VratiTreninge;
END;
GO

-- upr: api_klijent.AzurirajPracenja
CREATE PROCEDURE api_klijent.AzurirajPracenja
    @id_klijent INT,
    @NoviPodaci impl.PracenjeTip READONLY
AS
BEGIN
    EXEC spec.PromeniPracenja @id_klijent, @NoviPodaci;
END;
GO



CREATE OR ALTER FUNCTION api_klijent.PostojiEmail(@email NVARCHAR(50))
RETURNS BIT
AS
BEGIN
    RETURN (SELECT spec.PostojiEmail(@email));
END;
GO

CREATE OR ALTER FUNCTION api_klijent.PostojiKorisnickoIme(@korisnicko_ime NVARCHAR(20))
RETURNS BIT
AS
BEGIN
    RETURN (SELECT spec.PostojiKorisnickoIme(@korisnicko_ime));
END;
GO

CREATE OR ALTER FUNCTION api_klijent.PostojiEmail_ID(@email NVARCHAR(50), @id INT)
RETURNS BIT
AS
BEGIN
    RETURN (SELECT spec.PostojiEmail_ID(@email,@id));
END;
GO

CREATE OR ALTER FUNCTION api_klijent.PostojiKorisnickoIme_ID(@korisnicko_ime NVARCHAR(20), @id INT)
RETURNS BIT
AS
BEGIN
    RETURN (SELECT spec.PostojiKorisnickoIme_ID(@korisnicko_ime,@id));
END;
GO








-- Test da li su procedure kreirane
SELECT name, type_desc 
FROM sys.procedures 
WHERE SCHEMA_NAME(schema_id) = 'api_klijent'
ORDER BY name;
GO

PRINT '------------------------------------------------------------------';
PRINT N' api_klijent sema je kreirana';
PRINT '------------------------------------------------------------------';
GO

