/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ImplProcedureImprovementKorisnik.sql
**  OPIS:       Produkciona verzija procedura za entitet KORISNIK
**              sa svim unapredjenjima u odnosu na refaktorisanu
**              verziju (ImplProcedureRefactoringKorisnik.sql).
**
**              Unapredjenja u odnosu na prethodnu verziju:
**                (1) impl.tblErrorCatalog — centralizovani katalog
**                    gresaka; poruke se citaju iz kataloga;
**                    nema hardkodovanih poruka ni brojeva
**                (2) Lokalna @Msg promenljiva eliminise
**                    dupliranje teksta poruke
**                (3) SET XACT_ABORT ON — automatski ROLLBACK
**                    kod kriticnih gresaka koje TRY-CATCH
**                    ne hvata
**                (4) UPDLOCK hint unutar transakcije —
**                    zastita od race condition pri istovremenom
**                    unosu korisnika sa istim emailom ili
**                    korisnickim imenom
**                (5) @@ROWCOUNT provera posle INSERT-a u
**                    DodajKorisnika
**                (6) UprCheckKorisnikConstraints se poziva
**                    UNUTAR transakcije (UPDLOCK mora biti
**                    aktivan tokom celog INSERT-a)
**  AUTOR:      Andjela (DbDeveloper)
**  NAPOMENA:   Pokrenuti nakon ImplProcedureRefactoringKorisnik.sql
*/

USE [treninzi];
GO

-- =====================================================
-- 1. impl.UprLogError  [AZURIRANA VERZIJA]
--    Privatna pomocna procedura za upis greske u
--    log tabelu impl.tblErrorLog.
--    Izdvojena u posebnu proceduru — princip DRY.
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
-- 2. impl.UprValidateKorisnikValues  [AZURIRANA VERZIJA]
--    Privatna pomocna procedura za proveru vrednosnih
--    ogranicenja atributa entiteta KORISNIK.
--    Pokriva VPI:
--      ErrorCode 1001: ime je obavezno
--      ErrorCode 1002: prezime je obavezno
--      ErrorCode 1003: korisnicko ime je obavezno
--      ErrorCode 1004: email je obavezan
--    Poruka i SqlThrowCode se ucitavaju iz
--    impl.tblErrorCatalog — nema hardkodovanih poruka
--    ni brojeva. Lokalna @Msg eliminise dupliranje.
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

    DECLARE @Msg          NVARCHAR(400);
    DECLARE @ErrCode      INT;
    DECLARE @SqlThrowCode INT;

    IF @ime IS NULL OR @ime = ''
    BEGIN
        SELECT @ErrCode = ErrorCode, @SqlThrowCode = SqlThrowCode, @Msg = ErrorMessage
        FROM impl.tblErrorCatalog WHERE ErrorCode = 1001;
        EXEC impl.UprLogError @ErrCode, @Msg, @CallerName;
        THROW @SqlThrowCode, @Msg, 1;
    END;

    IF @prezime IS NULL OR @prezime = ''
    BEGIN
        SELECT @ErrCode = ErrorCode, @SqlThrowCode = SqlThrowCode, @Msg = ErrorMessage
        FROM impl.tblErrorCatalog WHERE ErrorCode = 1002;
        EXEC impl.UprLogError @ErrCode, @Msg, @CallerName;
        THROW @SqlThrowCode, @Msg, 1;
    END;

    IF @korisnicko_ime IS NULL OR @korisnicko_ime = ''
    BEGIN
        SELECT @ErrCode = ErrorCode, @SqlThrowCode = SqlThrowCode, @Msg = ErrorMessage
        FROM impl.tblErrorCatalog WHERE ErrorCode = 1003;
        EXEC impl.UprLogError @ErrCode, @Msg, @CallerName;
        THROW @SqlThrowCode, @Msg, 1;
    END;

    IF @email IS NULL OR @email = ''
    BEGIN
        SELECT @ErrCode = ErrorCode, @SqlThrowCode = SqlThrowCode, @Msg = ErrorMessage
        FROM impl.tblErrorCatalog WHERE ErrorCode = 1004;
        EXEC impl.UprLogError @ErrCode, @Msg, @CallerName;
        THROW @SqlThrowCode, @Msg, 1;
    END;
END;
GO

-- =====================================================
-- 3. impl.UprCheckKorisnikConstraints  [AZURIRANA VERZIJA]
--    Privatna pomocna procedura za proveru strukturnih
--    ogranicenja entiteta KORISNIK.
--    Pokriva SPI:
--      ErrorCode 1008: jedinstvenost emaila
--      ErrorCode 1007: jedinstvenost korisnickog imena
--    UPDLOCK hint: zakljucavamo red tokom provere da
--    bi se sprecio race condition u slucaju da druga
--    sesija istovremeno unosi korisnika sa istim
--    emailom ili korisnickim imenom.
--    @id = 0 za INSERT, stvarni id za UPDATE.
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

    DECLARE @Msg          NVARCHAR(400);
    DECLARE @ErrCode      INT;
    DECLARE @SqlThrowCode INT;

    IF EXISTS (
        SELECT 1 FROM impl.korisnik WITH (UPDLOCK)
        WHERE email = @email AND id <> @id
    )
    BEGIN
        SELECT @ErrCode = ErrorCode, @SqlThrowCode = SqlThrowCode, @Msg = ErrorMessage
        FROM impl.tblErrorCatalog WHERE ErrorCode = 1008;
        EXEC impl.UprLogError @ErrCode, @Msg, @CallerName;
        THROW @SqlThrowCode, @Msg, 1;
    END;

    IF EXISTS (
        SELECT 1 FROM impl.korisnik WITH (UPDLOCK)
        WHERE korisnicko_ime = @korisnicko_ime AND id <> @id
    )
    BEGIN
        SELECT @ErrCode = ErrorCode, @SqlThrowCode = SqlThrowCode, @Msg = ErrorMessage
        FROM impl.tblErrorCatalog WHERE ErrorCode = 1007;
        EXEC impl.UprLogError @ErrCode, @Msg, @CallerName;
        THROW @SqlThrowCode, @Msg, 1;
    END;
END;
GO

-- =====================================================
-- 4. impl.DodajKorisnika  [PRODUKCIONA VERZIJA]
--    Uloga: iskljucivo orkestracija:
--      (a) SET XACT_ABORT ON — automatski ROLLBACK
--          kod kriticnih gresaka koje TRY-CATCH
--          ne hvata
--      (b) odredjuje @ProcName za log
--      (c) poziva UprValidateKorisnikValues VAN
--          transakcije — samo ulazni parametri
--      (d) otvara transakciju
--      (e) poziva UprCheckKorisnikConstraints UNUTAR
--          transakcije (UPDLOCK zastita)
--      (f) izvrsava INSERT
--      (g) proverava @@ROWCOUNT
--      (h) u slucaju greske loguje i prosledjuje THROW
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

    DECLARE @ProcName NVARCHAR(256) =
        QUOTENAME(OBJECT_SCHEMA_NAME(@@PROCID)) + N'.' + QUOTENAME(OBJECT_NAME(@@PROCID));

    -- (c) Vrednosna ogranicenja VAN transakcije
    EXEC impl.UprValidateKorisnikValues
        @ime, @prezime, @email, @korisnicko_ime, @ProcName;

    BEGIN TRY
        BEGIN TRANSACTION;

            -- (e) Strukturna ogranicenja UNUTAR transakcije
            EXEC impl.UprCheckKorisnikConstraints
                @email, @korisnicko_ime, 0, @ProcName;

            -- (f) Unos korisnika
            INSERT INTO impl.korisnik
                (ime, prezime, email, uloga, korisnicko_ime, lozinka)
            VALUES
                (@ime, @prezime, @email, @uloga, @korisnicko_ime, @lozinka);

            -- (g) @@ROWCOUNT provera
            IF @@ROWCOUNT <> 1
            BEGIN
                DECLARE @SysMsg          NVARCHAR(400);
                DECLARE @SysSqlThrowCode INT;
                SELECT @SysSqlThrowCode = SqlThrowCode, @SysMsg = ErrorMessage
                FROM impl.tblErrorCatalog WHERE ErrorCode = 9001;
                THROW @SysSqlThrowCode, @SysMsg, 1;
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
-- 5. impl.PromeniKorisnika  [PRODUKCIONA VERZIJA]
--    Uloga: iskljucivo orkestracija:
--      (a) SET XACT_ABORT ON
--      (b) odredjuje @ProcName za log
--      (c) proverava da korisnik postoji
--      (d) poziva UprValidateKorisnikValues VAN
--          transakcije
--      (e) otvara transakciju
--      (f) poziva UprCheckKorisnikConstraints UNUTAR
--          transakcije sa stvarnim @id
--      (g) izvrsava UPDATE
--      (h) proverava @@ROWCOUNT
--      (i) u slucaju greske loguje i prosledjuje THROW
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
    -- (a) SET XACT_ABORT ON
    SET XACT_ABORT ON;
    SET NOCOUNT ON;

    -- (b) Dinamicki naziv procedure za log
    DECLARE @ProcName NVARCHAR(256) =
        QUOTENAME(OBJECT_SCHEMA_NAME(@@PROCID)) + N'.' + QUOTENAME(OBJECT_NAME(@@PROCID));

    DECLARE @Msg          NVARCHAR(400);
    DECLARE @ErrCode      INT;
    DECLARE @SqlThrowCode INT;

    -- (c) Provera da korisnik postoji
    IF NOT EXISTS (SELECT 1 FROM impl.korisnik WHERE id = @id)
    BEGIN
        SELECT @ErrCode = ErrorCode, @SqlThrowCode = SqlThrowCode, @Msg = ErrorMessage
        FROM impl.tblErrorCatalog WHERE ErrorCode = 1006;
        EXEC impl.UprLogError @ErrCode, @Msg, @ProcName;
        THROW @SqlThrowCode, @Msg, 1;
    END;

    -- (d) Vrednosna ogranicenja VAN transakcije
    EXEC impl.UprValidateKorisnikValues
        @ime, @prezime, @email, @korisnicko_ime, @ProcName;

    BEGIN TRY
        BEGIN TRANSACTION;

            -- (f) Strukturna ogranicenja UNUTAR transakcije (UPDLOCK)
            EXEC impl.UprCheckKorisnikConstraints
                @email, @korisnicko_ime, @id, @ProcName;

            -- (g) Izmena korisnika
            UPDATE impl.korisnik
            SET ime = @ime, prezime = @prezime, email = @email,
                lozinka = @lozinka, korisnicko_ime = @korisnicko_ime, uloga = @uloga
            WHERE id = @id;

            -- (h) @@ROWCOUNT provera
            IF @@ROWCOUNT = 0
            BEGIN
                SELECT @ErrCode = ErrorCode, @SqlThrowCode = SqlThrowCode, @Msg = ErrorMessage
                FROM impl.tblErrorCatalog WHERE ErrorCode = 1009;
                THROW @SqlThrowCode, @Msg, 1;
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
    PRINT N'  Greška (' + CAST(ERROR_NUMBER() AS NVARCHAR) + N'): ' + ERROR_MESSAGE();
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

-- Provera loga —
-- ErrorNumber treba da pokazuje interni kod iz tblErrorCatalog
-- ProcedureName treba da pokazuje [impl].[DodajKorisnika] za sve greske
SELECT TOP 5
     LogId, ErrorNumber, ErrorMessage, ProcedureName, LogDate
FROM impl.tblErrorLog
ORDER BY LogId DESC;
GO

PRINT '------------------------------------------------------------------';
PRINT N' impl.UprLogError, impl.UprValidateKorisnikValues,';
PRINT N' impl.UprCheckKorisnikConstraints, impl.DodajKorisnika,';
PRINT N' impl.PromeniKorisnika (produkciona verzija)';
PRINT N' su kreirane - ' + FORMAT(GETDATE(), '', 'sr-Latn-RS');
PRINT '------------------------------------------------------------------';
GO