/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ImplProcedureKorisnik.sql
**  OPIS:       Kreiranje stored procedura za entitet KORISNIK.
**              Osnovna verzija — bez pomocnih procedura (SRP).
**              Validacija i strukturna ogranicenja su direktno
**              u procedurama. Greske se prijavljuju pomocu
**              RAISERROR i upisuju direktno u tblErrorLog.
**                в.1. impl.DodajKorisnika
**                в.2. impl.PromeniKorisnika
**  AUTOR:      Andjela (DbDeveloper)
**  NAPOMENA:   Pokrenuti nakon 02_KreiranjeTabela.sql
*/

USE [treninzi];
GO

-- =====================================================
-- в.1. impl.DodajKorisnika
--    Procedura za unos novog korisnika.
--    Proverava vrednosna i strukturna ogranicenja
--    direktno u proceduri (bez pomocnih procedura).
--    Greske se upisuju u impl.tblErrorLog.
-- =====================================================
CREATE OR ALTER PROCEDURE impl.DodajKorisnika
    @ime            NVARCHAR(30),
    @prezime        NVARCHAR(30),
    @email          NVARCHAR(50),
    @uloga          NVARCHAR(10),
    @korisnicko_ime NVARCHAR(20),
    @lozinka        NVARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    -- Vrednosna ogranicenja
    IF @ime IS NULL OR @ime = ''
    BEGIN
        RAISERROR(N'Ime je obavezno.', 16, 1);
        RETURN;
    END;

    IF @prezime IS NULL OR @prezime = ''
    BEGIN
        RAISERROR(N'Prezime je obavezno.', 16, 1);
        RETURN;
    END;

    IF @korisnicko_ime IS NULL OR @korisnicko_ime = ''
    BEGIN
        RAISERROR(N'Korisničko ime je obavezno.', 16, 1);
        RETURN;
    END;

    IF @email IS NULL OR @email = ''
    BEGIN
        RAISERROR(N'Email je obavezan.', 16, 1);
        RETURN;
    END;

    -- Strukturna ogranicenja
    IF EXISTS (SELECT 1 FROM impl.korisnik WHERE email = @email)
    BEGIN
        RAISERROR(N'Email već postoji.', 16, 1);
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM impl.korisnik WHERE korisnicko_ime = @korisnicko_ime)
    BEGIN
        RAISERROR(N'Korisničko ime već postoji.', 16, 1);
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;
            INSERT INTO impl.korisnik
                (ime, prezime, email, uloga, korisnicko_ime, lozinka)
            VALUES
                (@ime, @prezime, @email, @uloga, @korisnicko_ime, @lozinka);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        INSERT INTO impl.tblErrorLog (ErrorNumber, ErrorMessage, ProcedureName)
        VALUES (ERROR_NUMBER(), ERROR_MESSAGE(), OBJECT_NAME(@@PROCID));
        THROW;
    END CATCH
END;
GO

-- =====================================================
-- в.2. impl.PromeniKorisnika
--    Procedura za izmenu postojeceg korisnika.
--    Proverava vrednosna i strukturna ogranicenja
--    direktno u proceduri (bez pomocnih procedura).
-- =====================================================
CREATE OR ALTER PROCEDURE impl.PromeniKorisnika
    @id             INT,
    @ime            NVARCHAR(30),
    @prezime        NVARCHAR(30),
    @email          NVARCHAR(50),
    @lozinka        NVARCHAR(15),
    @korisnicko_ime NVARCHAR(20),
    @uloga          NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    -- Provera da korisnik postoji
    IF NOT EXISTS (SELECT 1 FROM impl.korisnik WHERE id = @id)
    BEGIN
        RAISERROR(N'Korisnik sa datim ID ne postoji.', 16, 1);
        RETURN;
    END;

    -- Vrednosna ogranicenja
    IF @ime IS NULL OR @ime = ''
    BEGIN
        RAISERROR(N'Ime je obavezno.', 16, 1);
        RETURN;
    END;

    IF @prezime IS NULL OR @prezime = ''
    BEGIN
        RAISERROR(N'Prezime je obavezno.', 16, 1);
        RETURN;
    END;

    IF @email IS NULL OR @email = ''
    BEGIN
        RAISERROR(N'Email je obavezan.', 16, 1);
        RETURN;
    END;

    -- Strukturna ogranicenja
    IF EXISTS (SELECT 1 FROM impl.korisnik WHERE email = @email AND id <> @id)
    BEGIN
        RAISERROR(N'Email već postoji.', 16, 1);
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM impl.korisnik WHERE korisnicko_ime = @korisnicko_ime AND id <> @id)
    BEGIN
        RAISERROR(N'Korisničko ime već postoji.', 16, 1);
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;
            UPDATE impl.korisnik
            SET ime = @ime, prezime = @prezime, email = @email,
                lozinka = @lozinka, korisnicko_ime = @korisnicko_ime, uloga = @uloga
            WHERE id = @id;

            IF @@ROWCOUNT = 0
            BEGIN
                RAISERROR(N'Ažuriranje nije uspelo.', 16, 1);
            END;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        INSERT INTO impl.tblErrorLog (ErrorNumber, ErrorMessage, ProcedureName)
        VALUES (ERROR_NUMBER(), ERROR_MESSAGE(), OBJECT_NAME(@@PROCID));
        THROW;
    END CATCH
END;
GO

-- =====================================================
-- TESTOVI
-- =====================================================

-- Priprema
DELETE FROM impl.korisnik WHERE email = N'test.korisnik@test.com';
GO

-- Test 1: Ispravan unos
PRINT N'Test 1: Ispravan unos korisnika';
EXEC impl.DodajKorisnika
    @ime = N'Test', @prezime = N'Korisnik',
    @email = N'test.korisnik@test.com', @uloga = N'klijent',
    @korisnicko_ime = N'testkorisnik1', @lozinka = N'lozinka123';
PRINT N'  Test 1 prosao';
GO

-- Test 2: Prazno ime
PRINT N'Test 2: Prazno ime';
BEGIN TRY
    EXEC impl.DodajKorisnika
        @ime = N'', @prezime = N'Korisnik',
        @email = N'test2@test.com', @uloga = N'klijent',
        @korisnicko_ime = N'testkorisnik2', @lozinka = N'lozinka123';
END TRY
BEGIN CATCH
    PRINT N'  Greska (' + CAST(ERROR_NUMBER() AS NVARCHAR) + N'): ' + ERROR_MESSAGE();
END CATCH;
GO

-- Test 3: Duplikat email
PRINT N'Test 3: Duplikat email';
BEGIN TRY
    EXEC impl.DodajKorisnika
        @ime = N'Test', @prezime = N'Korisnik',
        @email = N'test.korisnik@test.com',
        @uloga = N'klijent',
        @korisnicko_ime = N'testkorisnik3', @lozinka = N'lozinka123';
END TRY
BEGIN CATCH
    PRINT N'  Greška (' + CAST(ERROR_NUMBER() AS NVARCHAR) + N'): ' + ERROR_MESSAGE();
END CATCH;
GO

-- Provera loga
SELECT TOP 3 LogId, ErrorNumber, ErrorMessage, ProcedureName, LogDate
FROM impl.tblErrorLog ORDER BY LogId DESC;
GO

PRINT '------------------------------------------------------------------';
PRINT N' impl.DodajKorisnika i impl.PromeniKorisnika (osnovna verzija)';
PRINT N' su kreirane - ' + FORMAT(GETDATE(), '', 'sr-Latn-RS');
PRINT '------------------------------------------------------------------';
GO


-- =====================================================
-- impl.ObrisiKorisnika  [Restrict]
--    Procedura za brisanje trenera.
--    SPI v.1. Restrict TRENING:
--    Ne moze se obrisati trener ako postoje
--    treninzi vezani za njega.
-- =====================================================
CREATE OR ALTER PROCEDURE impl.ObrisiKorisnika
    @id INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Provera da korisnik postoji
    IF NOT EXISTS (SELECT 1 FROM impl.korisnik WHERE id = @id)
    BEGIN
        RAISERROR(N'Korisnik sa datim ID ne postoji.', 16, 1);
        RETURN;
    END;

    -- v.1. Restrict TRENING (samo za trenera)
    IF EXISTS (SELECT 1 FROM impl.trening WHERE trener = @id)
    BEGIN
        RAISERROR(N'Nije moguce obrisati trenera. Postoje treninzi vezani za ovog korisnika.', 16, 1);
        RETURN;
    END;

    DELETE FROM impl.korisnik WHERE id = @id;
END;
GO

-- =====================================================
-- impl.ObrisiKorisnikaCascade  [Cascade]
--    Procedura za brisanje klijenta sa pracenjima.
--    Brise pracenja klijenta pa brise korisnika.
--    Koristi se za klijente — trener ne moze
--    cascade jer ima treninge.
-- =====================================================
CREATE OR ALTER PROCEDURE impl.ObrisiKorisnikaCascade
    @id INT
AS
BEGIN
    SET XACT_ABORT ON;
    SET NOCOUNT ON;

    -- Provera da korisnik postoji
    IF NOT EXISTS (SELECT 1 FROM impl.korisnik WHERE id = @id)
    BEGIN
        RAISERROR(N'Korisnik sa datim ID ne postoji.', 16, 1);
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

            -- Cascade korak 1: brisi pracenja klijenta
            DELETE FROM impl.pracenje WHERE id_klijent = @id;

            -- Cascade korak 2: brisi korisnika
            DELETE FROM impl.korisnik WHERE id = @id;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        DECLARE @ErrNumber  INT           = ERROR_NUMBER();
        DECLARE @ErrMessage NVARCHAR(400) = ERROR_MESSAGE();
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        INSERT INTO impl.tblErrorLog (ErrorNumber, ErrorMessage, ProcedureName)
        VALUES (@ErrNumber, @ErrMessage, OBJECT_NAME(@@PROCID));
        THROW;
    END CATCH
END;
GO

-- =====================================================
-- TESTOVI
-- =====================================================

-- Test 1: Restrict — trener ima treninge, treba da baci gresku
PRINT N'Test 1: Restrict — trener ima treninge';
BEGIN TRY
    EXEC impl.ObrisiKorisnika @id = 1;
END TRY
BEGIN CATCH
    PRINT N'  Greska (' + CAST(ERROR_NUMBER() AS NVARCHAR) + N'): ' + ERROR_MESSAGE();
END CATCH;
GO

-- Test 2: Korisnik ne postoji
PRINT N'Test 2: Korisnik ne postoji';
BEGIN TRY
    EXEC impl.ObrisiKorisnika @id = 9999;
END TRY
BEGIN CATCH
    PRINT N'  Greska (' + CAST(ERROR_NUMBER() AS NVARCHAR) + N'): ' + ERROR_MESSAGE();
END CATCH;
GO

-- Test 3: Cascade — brisi klijenta sa pracenjima
PRINT N'Test 3: Cascade — brisi klijenta sa pracenjima';
EXEC impl.ObrisiKorisnikaCascade @id = 15;
PRINT N'  Test 3 prosao';
GO

-- Provera
PRINT N'Provera:';
SELECT COUNT(*) AS BrojPracenja FROM impl.pracenje WHERE id_klijent = 2;
SELECT COUNT(*) AS BrojKorisnika FROM impl.korisnik WHERE id = 2;
GO