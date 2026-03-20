/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ImplProcedureImprovementVezba.sql
**  OPIS:       Produkciona verzija procedura za entitet VEZBA
**              sa svim unapredjenjima u odnosu na refaktorisanu
**              verziju (ImplProcedureRefactoringVezba.sql).
**
**              Unapredjenja u odnosu na prethodnu verziju:
**                (1) tblErrorCatalog — poruke se citaju iz kataloga
**                (2) Lokalna @Msg eliminise dupliranje teksta poruke
**                (3) SET XACT_ABORT ON
**                (4) @@ROWCOUNT provera posle INSERT-a
**  AUTOR:      Andjela (DbDeveloper)
**  NAPOMENA:   Pokrenuti nakon ImplProcedureRefactoringVezba.sql
*/

USE [treninzi];
GO

-- =====================================================
-- 1. impl.UprValidateVezbaValues  [AZURIRANA VERZIJA]
--    Poruke i SqlThrowCode se ucitavaju iz
--    impl.tblErrorCatalog — nema hardkodovanih poruka.
--    Lokalna @Msg eliminise dupliranje.
-- =====================================================
CREATE OR ALTER PROCEDURE impl.UprValidateVezbaValues
    @naziv           NVARCHAR(20),
    @misicna_grupa   NVARCHAR(50),
    @intervalni      BIT,
    @tip_opterecenja NVARCHAR(20),
    @CallerName      NVARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Msg          NVARCHAR(400);
    DECLARE @ErrCode      INT;
    DECLARE @SqlThrowCode INT;

    IF @naziv IS NULL OR @naziv = ''
    BEGIN
        SELECT @ErrCode = ErrorCode, @SqlThrowCode = SqlThrowCode, @Msg = ErrorMessage
        FROM impl.tblErrorCatalog WHERE ErrorCode = 2001;
        EXEC impl.UprLogError @ErrCode, @Msg, @CallerName;
        THROW @SqlThrowCode, @Msg, 1;
    END;

    IF @misicna_grupa IS NULL OR @misicna_grupa = ''
    BEGIN
        SELECT @ErrCode = ErrorCode, @SqlThrowCode = SqlThrowCode, @Msg = ErrorMessage
        FROM impl.tblErrorCatalog WHERE ErrorCode = 2002;
        EXEC impl.UprLogError @ErrCode, @Msg, @CallerName;
        THROW @SqlThrowCode, @Msg, 1;
    END;

    IF impl.PostojiVezba(@naziv) = 1
    BEGIN
        SELECT @ErrCode = ErrorCode, @SqlThrowCode = SqlThrowCode, @Msg = ErrorMessage
        FROM impl.tblErrorCatalog WHERE ErrorCode = 2003;
        EXEC impl.UprLogError @ErrCode, @Msg, @CallerName;
        THROW @SqlThrowCode, @Msg, 1;
    END;

    IF @intervalni IS NOT NULL AND @tip_opterecenja IS NOT NULL
    BEGIN
        SELECT @ErrCode = ErrorCode, @SqlThrowCode = SqlThrowCode, @Msg = ErrorMessage
        FROM impl.tblErrorCatalog WHERE ErrorCode = 2004;
        EXEC impl.UprLogError @ErrCode, @Msg, @CallerName;
        THROW @SqlThrowCode, @Msg, 1;
    END;

    IF @intervalni IS NULL AND @tip_opterecenja IS NULL
    BEGIN
        SELECT @ErrCode = ErrorCode, @SqlThrowCode = SqlThrowCode, @Msg = ErrorMessage
        FROM impl.tblErrorCatalog WHERE ErrorCode = 2005;
        EXEC impl.UprLogError @ErrCode, @Msg, @CallerName;
        THROW @SqlThrowCode, @Msg, 1;
    END;
END;
GO

-- =====================================================
-- 2. impl.KreirajVezbu  [PRODUKCIONA VERZIJA]
--    Uloga: iskljucivo orkestracija:
--      (a) SET XACT_ABORT ON
--      (b) odredjuje @ProcName za log
--      (c) poziva UprValidateVezbaValues VAN transakcije
--      (d) otvara transakciju
--      (e) izvrsava INSERT u vezba
--      (f) proverava @@ROWCOUNT
--      (g) ubacuje u kardio ili snaga
--      (h) vraca novi id pozivaocu
--      (i) u slucaju greske loguje i prosledjuje THROW
-- =====================================================
CREATE OR ALTER PROCEDURE impl.KreirajVezbu
    @naziv           NVARCHAR(20),
    @misicna_grupa   NVARCHAR(50),
    @intervalni      BIT           = NULL,
    @intenzitet      NVARCHAR(20)  = NULL,
    @prostor         NVARCHAR(20)  = NULL,
    @tip_opterecenja NVARCHAR(20)  = NULL,
    @oprema          BIT           = NULL
AS
BEGIN
    SET XACT_ABORT ON;
    SET NOCOUNT ON;

    DECLARE @ProcName NVARCHAR(256) =
        QUOTENAME(OBJECT_SCHEMA_NAME(@@PROCID)) + N'.' + QUOTENAME(OBJECT_NAME(@@PROCID));

    -- (c) Vrednosna i strukturna ogranicenja VAN transakcije
    EXEC impl.UprValidateVezbaValues
        @naziv, @misicna_grupa, @intervalni, @tip_opterecenja, @ProcName;

    BEGIN TRY
        BEGIN TRANSACTION;

            -- (e) Unos u natklasu vezba
            INSERT INTO impl.vezba (naziv, misicna_grupa)
            VALUES (@naziv, @misicna_grupa);

            -- (f) @@ROWCOUNT provera
            IF @@ROWCOUNT <> 1
            BEGIN
                DECLARE @SysMsg          NVARCHAR(400);
                DECLARE @SysSqlThrowCode INT;
                SELECT @SysSqlThrowCode = SqlThrowCode, @SysMsg = ErrorMessage
                FROM impl.tblErrorCatalog WHERE ErrorCode = 9001;
                THROW @SysSqlThrowCode, @SysMsg, 1;
            END;

            DECLARE @idVezba INT = SCOPE_IDENTITY();

            -- (g) Unos u potklasu kardio ili snaga
            IF @intervalni IS NOT NULL
                INSERT INTO impl.kardio (id, intervalni, intenzitet, prostor)
                VALUES (@idVezba, @intervalni, @intenzitet, @prostor);

            IF @tip_opterecenja IS NOT NULL
                INSERT INTO impl.snaga (id, tip_opterecenja, oprema)
                VALUES (@idVezba, @tip_opterecenja, @oprema);

        COMMIT TRANSACTION;

        -- (h) Vraca novi id pozivaocu
        SELECT @idVezba AS IdVezba;

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
DELETE FROM impl.snaga  WHERE id IN (SELECT id FROM impl.vezba WHERE naziv = N'TestKardio');
DELETE FROM impl.kardio WHERE id IN (SELECT id FROM impl.vezba WHERE naziv = N'TestKardio');
DELETE FROM impl.vezba  WHERE naziv = N'TestKardio';
GO

-- Test 1: Ispravan unos kardio vezbe
PRINT N'Test 1: Ispravan unos kardio vezbe';
EXEC impl.KreirajVezbu
    @naziv = N'TestKardio', @misicna_grupa = N'noge',
    @intervalni = 1, @intenzitet = N'visok', @prostor = N'otvoren';
PRINT N'  Test 1 prosao';
GO

-- Test 2: Prazan naziv — treba da baci gresku
PRINT N'Test 2: Prazan naziv vezbe';
BEGIN TRY
    EXEC impl.KreirajVezbu
        @naziv = N'', @misicna_grupa = N'noge', @intervalni = 1;
END TRY
BEGIN CATCH
    PRINT N'  Greska (' + CAST(ERROR_NUMBER() AS NVARCHAR) + N'): ' + ERROR_MESSAGE();
END CATCH;
GO

-- Test 3: Naziv vec postoji — treba da baci gresku
PRINT N'Test 3: Vezba sa tim nazivom vec postoji';
BEGIN TRY
    EXEC impl.KreirajVezbu
        @naziv = N'TestKardio', @misicna_grupa = N'noge', @intervalni = 1;
END TRY
BEGIN CATCH
    PRINT N'  Greska (' + CAST(ERROR_NUMBER() AS NVARCHAR) + N'): ' + ERROR_MESSAGE();
END CATCH;
GO

-- Test 4: I kardio i snaga — treba da baci gresku
PRINT N'Test 4: Vezba ne moze biti i kardio i snaga';
BEGIN TRY
    EXEC impl.KreirajVezbu
        @naziv = N'TestVezba2', @misicna_grupa = N'noge',
        @intervalni = 1, @tip_opterecenja = N'tegovi';
END TRY
BEGIN CATCH
    PRINT N'  Greska (' + CAST(ERROR_NUMBER() AS NVARCHAR) + N'): ' + ERROR_MESSAGE();
END CATCH;
GO

-- Test 5: Ni kardio ni snaga — treba da baci gresku
PRINT N'Test 5: Vezba mora biti ili kardio ili snaga';
BEGIN TRY
    EXEC impl.KreirajVezbu
        @naziv = N'TestVezba3', @misicna_grupa = N'noge';
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
PRINT N' impl.UprValidateVezbaValues, impl.KreirajVezbu';
PRINT N' (produkciona verzija)';
PRINT N' su kreirane - ' + FORMAT(GETDATE(), '', 'sr-Latn-RS');
PRINT '------------------------------------------------------------------';
GO