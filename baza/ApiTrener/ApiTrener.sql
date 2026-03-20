/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   07_ApiTrener.sql
**  OPIS:       Kreiranje api_trener sheme.
**              Sve operacije koje trener koristi u aplikaciji.
**  AUTOR:      Andrijana (DbApiDeveloper)
**  NAPOMENA:   Pokrenuti nakon 06_Spec.sql
*/

USE [treninzi];
GO

-- =====================================================
-- Procedure
-- =====================================================

CREATE PROCEDURE api_trener.KreirajVezbu
    @naziv NVARCHAR(20), @misicna_grupa NVARCHAR(50),
    @intervalni BIT = NULL, @intenzitet NVARCHAR(20) = NULL,
    @prostor NVARCHAR(20) = NULL, @tip_opterecenja NVARCHAR(20) = NULL,
    @oprema BIT = NULL
AS
BEGIN
    EXEC spec.KreirajVezbu @naziv, @misicna_grupa,
         @intervalni, @intenzitet, @prostor, @tip_opterecenja, @oprema;
END;
GO

CREATE PROCEDURE api_trener.KreirajTrening
    @naziv NVARCHAR(50), @cilj NVARCHAR(20),
    @broj_treninga_nedeljno INT, @trener INT,
    @stavke impl.StavkaTrTip READONLY
AS
BEGIN
    EXEC spec.DodajTreningSaStavkama
         @naziv, @cilj, @broj_treninga_nedeljno, @trener, @stavke;
END;
GO

CREATE PROCEDURE api_trener.IzmeniTrening
    @id INT, @naziv NVARCHAR(50), @cilj NVARCHAR(20),
    @broj_treninga_nedeljno INT, @trener INT,
    @stavke impl.StavkaTrTip READONLY
AS
BEGIN
    EXEC spec.PromeniTreningSaStavkama
         @id, @naziv, @cilj, @broj_treninga_nedeljno, @trener, @stavke;
END;
GO

CREATE PROCEDURE api_trener.ObrisiTrening (@id_tr INT)
AS
BEGIN
    EXEC spec.ObrisiTrening @id_tr;
END;
GO

-- upr: api_trener.RegistrujKorisnika
-- Opis: Registracija novog trenera
CREATE OR ALTER PROCEDURE api_trener.RegistrujTrenera
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
        @uloga          = N'trener',
        @korisnicko_ime = @korisnicko_ime,
        @lozinka        = @lozinka;
END;
GO


CREATE OR ALTER PROCEDURE api_trener.PromeniTrenera
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
        @uloga          = N'trener',
        @korisnicko_ime = @korisnicko_ime,
        @lozinka        = @staraLozinka;
END;
GO






-- =====================================================
-- Table-value funkcije
-- =====================================================

-- fnt: api_trener.TreninziTrenera
CREATE FUNCTION api_trener.TreninziTrenera (@idTrener INT)
RETURNS TABLE AS RETURN
(
    SELECT * FROM spec.VratiTreningeZaTrenera(@idTrener)
);
GO

CREATE FUNCTION api_trener.VratiKardioVezbe()
RETURNS TABLE AS RETURN
(
    SELECT * FROM spec.VratiKardioVezbe()
);
GO

CREATE FUNCTION api_trener.VratiVezbeSnage()
RETURNS TABLE AS RETURN
(
    SELECT * FROM spec.VratiVezbeSnage()
);
GO



-- fnt: api_trener.KlijentiTreninga
-- Opis: Poziva spec.ListaPracenjaTreningKlijent - ne pristupa impl direktno
CREATE FUNCTION api_trener.KlijentiTreninga (@idTrening INT)
RETURNS TABLE AS RETURN
(
    SELECT * FROM spec.ListaPracenjaTreningKlijent(@idTrening)
);
GO

-- upr: api_trener.PrijavaKorisnika
-- Opis: Autentikacija trenera pri prijavi

CREATE OR ALTER FUNCTION api_trener.Login(@korisnickoIme NVARCHAR(20), @lozinka NVARCHAR(15))
RETURNS TABLE AS RETURN
(
    SELECT * FROM spec.LoginKorisnik(@korisnickoIme, @lozinka)
    WHERE uloga = 'trener'
);
GO

CREATE FUNCTION api_trener.VratiSveVezbe()
RETURNS TABLE AS RETURN
(
    SELECT * FROM spec.VratiSveVezbe()
);
GO

-- =====================================================
-- Scalar-valued funkcije
-- =====================================================
CREATE OR ALTER FUNCTION api_trener.PostojiEmail(@email NVARCHAR(50))
RETURNS BIT
AS
BEGIN
    RETURN (SELECT spec.PostojiEmail(@email));
END;
GO

CREATE OR ALTER FUNCTION api_trener.PostojiKorisnickoIme(@korisnicko_ime NVARCHAR(20))
RETURNS BIT
AS
BEGIN
    RETURN (SELECT spec.PostojiKorisnickoIme(@korisnicko_ime));
END;
GO

CREATE OR ALTER FUNCTION api_trener.PostojiEmail_ID(@email NVARCHAR(50), @id INT)
RETURNS BIT
AS
BEGIN
    RETURN (SELECT spec.PostojiEmail_ID(@email,@id));
END;
GO

CREATE OR ALTER FUNCTION api_trener.PostojiKorisnickoIme_ID(@korisnicko_ime NVARCHAR(20), @id INT)
RETURNS BIT
AS
BEGIN
    RETURN (SELECT spec.PostojiKorisnickoIme_ID(@korisnicko_ime,@id));
END;
GO

CREATE OR ALTER FUNCTION api_trener.PostojiVezba(@naziv NVARCHAR(20))
RETURNS BIT
AS
BEGIN
    RETURN (SELECT spec.PostojiVezba(@naziv));
END;
GO

CREATE OR ALTER FUNCTION api_trener.PostojiTreningSaNazivom(@id INT, @naziv NVARCHAR(50))
RETURNS BIT
AS
BEGIN
    RETURN (SELECT spec.PostojiTreningSaNazivom(@id,@naziv));
END;
GO

CREATE OR ALTER FUNCTION api_trener.PostojiTrening(@naziv NVARCHAR(50))
RETURNS BIT
AS
BEGIN
    RETURN (SELECT spec.PostojiTrening(@naziv));
END;
GO


-- Test da li su procedure kreirane
SELECT name, type_desc 
FROM sys.procedures 
WHERE SCHEMA_NAME(schema_id) = 'api_trener'
ORDER BY name;
GO

PRINT '------------------------------------------------------------------';
PRINT N' api_trener shema je kreirana';
PRINT '------------------------------------------------------------------';
GO
