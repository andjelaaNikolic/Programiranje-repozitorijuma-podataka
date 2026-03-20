/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ImplProcedureRefactoringKorisnik.sql
**  OPIS:       Refaktorisane stored procedure za entitet KORISNIK.
**              Primenjeni principi u odnosu na prethodnu verziju
**              (ImplProcedureKorisnik.sql):
**                (а) SRP: svaka procedura radi iskljucivo jednu stvar
**                (б) THROW umesto RAISERROR u svim procedurama
**                (в) ERROR_NUMBER/MESSAGE se hvataju odmah u CATCH
**                    bloku pozivalaca i prosledjuju kao parametri
**                    u UprLogError
**                    (ERROR_*() funkcije ne prenose se u pozvane!)
**                (г) @ProcName = QUOTENAME(OBJECT_SCHEMA_NAME(@@PROCID))
**                    + '.' + QUOTENAME(OBJECT_NAME(@@PROCID)) —
**                    dinamicki naziv procedure bez hardkodovanja
**                (д) @CallerName parametar u pomocnim procedurama —
**                    u log se upisuje naziv orkestratorske procedure,
**                    a ne pomocne; tako log tacno pokazuje odakle je
**                    greska potekla sa stanovista pozivaoca
**              Kreirane procedure:
**                (1) impl.UprLogError              → upis greske u log
**                (2) impl.UprValidateKorisnikValues → vrednosna ogr.
**                (3) impl.UprCheckKorisnikConstraints → strukturna ogr.
**                (4) impl.DodajKorisnika            → orkestracija
**                (5) impl.PromeniKorisnika          → orkestracija
**  AUTOR:      Andjela (DbDeveloper)
**  NAPOMENA:   Pokrenuti nakon ImplProcedureKorisnik.sql
*/

USE [treninzi];
GO

-- =====================================================
-- 1. impl.UprLogError
--    Privatna pomocna procedura za upis greske u
--    log tabelu impl.tblErrorLog.
--    Izdvojena u posebnu proceduru jer ce se pozivati
--    iz svih procedura koje rukuju greskama — DRY.
--    VAZNO: ERROR_NUMBER() i ERROR_MESSAGE() vaze
--    samo unutar CATCH bloka u kom su nastale i ne
--    prenose se u pozvane procedure. Zato ih
--    pozivalac hvata u lokalne promenljive odmah
--    na pocetku CATCH bloka i prosledjuje ih ovde
--    kao parametre.
--    Privatna procedura: impl sloj.
-- =====================================================
CREATE OR ALTER PROCEDURE impl.UprLogError
    @ErrorNumber   INT,
    @ErrorMessage  NVARCHAR(400),
    @ProcedureName NVARCHAR(256) 
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO impl.tblErrorLog (
         ErrorNumber
        ,ErrorMessage
        ,ProcedureName
    )
    VALUES (
         @ErrorNumber
        ,@ErrorMessage
        ,@ProcedureName
    );
END;
GO

-- =====================================================
-- 2. impl.UprValidateKorisnikValues
--    Privatna pomocna procedura za proveru vrednosnih
--    ogranicenja atributa entiteta KORISNIK.
--    Pokriva VPI:
--      - ime je obavezno
--      - prezime je obavezno
--      - korisnicko ime je obavezno
--      - email je obavezan
--    Ako provera ne prodje → greska se loguje preko
--    impl.UprLogError, zatim se baca THROW.
--    @CallerName: naziv orkestratorske procedure za log.
--    Privatna procedura: impl sloj.
-- =====================================================
CREATE OR ALTER PROCEDURE impl.UprValidateKorisnikValues
    @ime            NVARCHAR(30),
    @prezime        NVARCHAR(30),
    @email          NVARCHAR(50),
    @korisnicko_ime NVARCHAR(20),
    @CallerName     NVARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;

    IF @ime IS NULL OR @ime = ''
    BEGIN
        EXEC impl.UprLogError 1001, N'Ime je obavezno.', @CallerName;
        THROW 51001, N'Ime je obavezno.', 1;
    END;

    IF @prezime IS NULL OR @prezime = ''
    BEGIN
        EXEC impl.UprLogError 1002, N'Prezime je obavezno.', @CallerName;
        THROW 51002, N'Prezime je obavezno.', 1;
    END;

    IF @korisnicko_ime IS NULL OR @korisnicko_ime = ''
    BEGIN
        EXEC impl.UprLogError 1003, N'Korisnicko ime je obavezno.', @CallerName;
        THROW 51003, N'Korisnicko ime je obavezno.', 1;
    END;

    IF @email IS NULL OR @email = ''
    BEGIN
        EXEC impl.UprLogError 1004, N'Email je obavezan.', @CallerName;
        THROW 51004, N'Email je obavezan.', 1;
    END;
END;
GO

-- =====================================================
-- 3. impl.UprCheckKorisnikConstraints
--    Privatna pomocna procedura za proveru strukturnih
--    ogranicenja entiteta KORISNIK.
--    Pokriva SPI:
--      - jedinstvenost emaila
--      - jedinstvenost korisnickog imena
--    @id = 0 za INSERT, stvarni id za UPDATE
--    @CallerName: naziv orkestratorske procedure za log.
--    Privatna procedura: impl sloj.
-- =====================================================
CREATE OR ALTER PROCEDURE impl.UprCheckKorisnikConstraints
    @email          NVARCHAR(50),
    @korisnicko_ime NVARCHAR(20),
    @id             INT,
    @CallerName     NVARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM impl.korisnik WHERE email = @email AND id <> @id)
    BEGIN
        EXEC impl.UprLogError 1008, N'Email već postoji.', @CallerName;
        THROW 51008, N'Email već postoji.', 1;
    END;

    IF EXISTS (SELECT 1 FROM impl.korisnik WHERE korisnicko_ime = @korisnicko_ime AND id <> @id)
    BEGIN
        EXEC impl.UprLogError 1007, N'Korisnicko ime vec postoji.', @CallerName;
        THROW 51007, N'Korisničko ime već postoji.', 1;
    END;
END;
GO

-- =====================================================
-- 4. impl.DodajKorisnika  [REFAKTORISANA VERZIJA]
--    Uloga: iskljucivo orkestracija:
--      (a) odredjuje @ProcName za log
--      (b) poziva UprValidateKorisnikValues VAN
--          transakcije — samo ulazni parametri
--      (c) poziva UprCheckKorisnikConstraints
--      (d) izvrsava INSERT u transakciji
--      (e) u slucaju greske loguje i prosledjuje THROW
--    Javna procedura: impl sloj.
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
    SET XACT_ABORT ON;
    SET NOCOUNT ON;

    -- (a) Dinamicki naziv procedure za log
    DECLARE @ProcName NVARCHAR(256) =
        QUOTENAME(OBJECT_SCHEMA_NAME(@@PROCID)) + N'.' + QUOTENAME(OBJECT_NAME(@@PROCID));

    -- (b) Vrednosna ogranicenja VAN transakcije
    EXEC impl.UprValidateKorisnikValues
        @ime, @prezime, @email, @korisnicko_ime, @ProcName;

    -- (c) Strukturna ogranicenja
    EXEC impl.UprCheckKorisnikConstraints
        @email, @korisnicko_ime, 0, @ProcName;

    BEGIN TRY
        BEGIN TRANSACTION;

            -- (d) Unos korisnika
            INSERT INTO impl.korisnik
                (ime, prezime, email, uloga, korisnicko_ime, lozinka)
            VALUES
                (@ime, @prezime, @email, @uloga, @korisnicko_ime, @lozinka);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        DECLARE @ErrNumber  INT           = ERROR_NUMBER();
        DECLARE @ErrMessage NVARCHAR(400) = ERROR_MESSAGE();
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        EXEC impl.UprLogError @ErrNumber, @ErrMessage, @ProcName;
        THROW;
    END CATCH
END;
GO

-- =====================================================
-- 5. impl.PromeniKorisnika  [REFAKTORISANA VERZIJA]
--    Uloga: iskljucivo orkestracija:
--      (a) odredjuje @ProcName za log
--      (b) proverava da korisnik postoji
--      (c) poziva UprValidateKorisnikValues VAN
--          transakcije
--      (d) poziva UprCheckKorisnikConstraints sa
--          stvarnim @id — iskljucuje trenutnog
--          korisnika iz provere jedinstvenosti
--      (e) izvrsava UPDATE u transakciji
--      (f) proverava @@ROWCOUNT
--      (g) u slucaju greske loguje i prosledjuje THROW
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
    SET XACT_ABORT ON;
    SET NOCOUNT ON;

    -- (a) Dinamicki naziv procedure za log
    DECLARE @ProcName NVARCHAR(256) =
        QUOTENAME(OBJECT_SCHEMA_NAME(@@PROCID)) + N'.' + QUOTENAME(OBJECT_NAME(@@PROCID));

    -- (b) Provera da korisnik postoji
    IF NOT EXISTS (SELECT 1 FROM impl.korisnik WHERE id = @id)
    BEGIN
        EXEC impl.UprLogError 1006, N'Korisnik sa datim ID ne postoji.', @ProcName;
        THROW 51006, N'Korisnik sa datim ID ne postoji.', 1;
    END;

    -- (c) Vrednosna ogranicenja VAN transakcije
    EXEC impl.UprValidateKorisnikValues
        @ime, @prezime, @email, @korisnicko_ime, @ProcName;

    -- (d) Strukturna ogranicenja
    EXEC impl.UprCheckKorisnikConstraints
        @email, @korisnicko_ime, @id, @ProcName;

    BEGIN TRY
        BEGIN TRANSACTION;

            -- (e) Izmena korisnika
            UPDATE impl.korisnik
            SET ime = @ime, prezime = @prezime, email = @email,
                lozinka = @lozinka, korisnicko_ime = @korisnicko_ime, uloga = @uloga
            WHERE id = @id;

            -- (f) @@ROWCOUNT provera
            IF @@ROWCOUNT = 0
            BEGIN
                EXEC impl.UprLogError 1009, N'Azuriranje nije uspelo.', @ProcName;
                THROW 51009, N'Azuriranje nije uspelo.', 1;
            END;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        DECLARE @ErrNumber  INT           = ERROR_NUMBER();
        DECLARE @ErrMessage NVARCHAR(400) = ERROR_MESSAGE();
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        EXEC impl.UprLogError @ErrNumber, @ErrMessage, @ProcName;
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

-- Test 2: Prazno ime — treba da baci gresku
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

-- Test 3: Duplikat email — treba da baci gresku
PRINT N'Test 3: Duplikat email';
BEGIN TRY
    EXEC impl.DodajKorisnika
        @ime = N'Test', @prezime = N'Korisnik',
        @email = N'test.korisnik@test.com',
        @uloga = N'klijent',
        @korisnicko_ime = N'testkorisnik3', @lozinka = N'lozinka123';
END TRY
BEGIN CATCH
    PRINT N'  Greska (' + CAST(ERROR_NUMBER() AS NVARCHAR) + N'): ' + ERROR_MESSAGE();
END CATCH;
GO

-- Test 4: Korisnik ne postoji — treba da baci gresku
PRINT N'Test 4: Korisnik ne postoji';
BEGIN TRY
    EXEC impl.PromeniKorisnika
        @id = 9999, @ime = N'Test', @prezime = N'Korisnik',
        @email = N'test@test.com', @lozinka = N'loz',
        @korisnicko_ime = N'test', @uloga = N'klijent';
END TRY
BEGIN CATCH
    PRINT N'  Greska (' + CAST(ERROR_NUMBER() AS NVARCHAR) + N'): ' + ERROR_MESSAGE();
END CATCH;
GO

-- Provera loga
SELECT TOP 5 LogId, ErrorNumber, ErrorMessage, ProcedureName, LogDate
FROM impl.tblErrorLog ORDER BY LogId DESC;
GO

PRINT '------------------------------------------------------------------';
PRINT N' impl.UprLogError, impl.UprValidateKorisnikValues,';
PRINT N' impl.UprCheckKorisnikConstraints, impl.DodajKorisnika,';
PRINT N' impl.PromeniKorisnika (refactoring verzija)';
PRINT N' su kreirane - ' + FORMAT(GETDATE(), '', 'sr-Latn-RS');
PRINT '------------------------------------------------------------------';
GO