/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ImplProcedureRefactoringVezba.sql
**  OPIS:       Refaktorisane stored procedure za entitet VEZBA.
**              Primenjeni principi u odnosu na prethodnu verziju
**              (ImplProcedureVezba.sql):
**                (а) SRP: svaka procedura radi iskljucivo jednu stvar
**                (б) THROW umesto RAISERROR
**                (в) @CallerName parametar — u log se upisuje naziv
**                    orkestratorske procedure, a ne pomocne
**                (г) @ProcName dinamicki naziv procedure
**              Kreirane procedure:
**                (1) impl.UprValidateVezbaValues  → vrednosna ogr.
**                (2) impl.KreirajVezbu            → orkestracija
**  AUTOR:      Andjela (DbDeveloper)
**  NAPOMENA:   Pokrenuti nakon ImplProcedureVezba.sql
*/

USE [treninzi];
GO

-- =====================================================
-- 1. impl.UprValidateVezbaValues
--    Privatna pomocna procedura za proveru vrednosnih
--    ogranicenja atributa entiteta VEZBA.
--    Pokriva VPI:
--      - naziv je obavezan
--      - misicna grupa je obavezna
--      - vezba sa tim nazivom vec postoji
--      - vezba ne moze biti i kardio i snaga
--      - vezba mora biti ili kardio ili snaga
--    @CallerName: naziv orkestratorske procedure za log.
--    Privatna procedura: impl sloj.
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

    IF @naziv IS NULL OR @naziv = ''
    BEGIN
        EXEC impl.UprLogError 2001, N'Naziv vezbe je obavezan.', @CallerName;
        THROW 52001, N'Naziv vezbe je obavezan.', 1;
    END;

    IF @misicna_grupa IS NULL OR @misicna_grupa = ''
    BEGIN
        EXEC impl.UprLogError 2002, N'Naziv misicne grupe je obavezan.', @CallerName;
        THROW 52002, N'Naziv misicne grupe je obavezan.', 1;
    END;

    IF EXISTS (SELECT 1 FROM impl.vezba WHERE naziv = @naziv)
    BEGIN
        EXEC impl.UprLogError 2003, N'Vezba sa tim nazivom vec postoji.', @CallerName;
        THROW 52003, N'Vezba sa tim nazivom vec postoji.', 1;
    END;

    IF @intervalni IS NOT NULL AND @tip_opterecenja IS NOT NULL
    BEGIN
        EXEC impl.UprLogError 2004, N'Vezba ne moze biti istovremeno kardio i snaga.', @CallerName;
        THROW 52004, N'Vezba ne moze biti istovremeno kardio i snaga.', 1;
    END;

    IF @intervalni IS NULL AND @tip_opterecenja IS NULL
    BEGIN
        EXEC impl.UprLogError 2005, N'Vezba mora biti ili kardio ili snaga.', @CallerName;
        THROW 52005, N'Vezba mora biti ili kardio ili snaga.', 1;
    END;
END;
GO

-- =====================================================
-- 2. impl.KreirajVezbu  [REFAKTORISANA VERZIJA]
--    Uloga: iskljucivo orkestracija:
--      (a) odredjuje @ProcName za log
--      (b) poziva UprValidateVezbaValues VAN transakcije
--      (c) izvrsava INSERT u transakciji
--      (d) vraca novi id pozivaocu
--      (e) u slucaju greske loguje i prosledjuje THROW
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

    -- (a) Dinamicki naziv procedure za log
    DECLARE @ProcName NVARCHAR(256) =
        QUOTENAME(OBJECT_SCHEMA_NAME(@@PROCID)) + N'.' + QUOTENAME(OBJECT_NAME(@@PROCID));

    -- (b) Vrednosna i strukturna ogranicenja VAN transakcije
    EXEC impl.UprValidateVezbaValues
        @naziv, @misicna_grupa, @intervalni, @tip_opterecenja, @ProcName;

    BEGIN TRY
        BEGIN TRANSACTION;

            -- (c) Unos u natklasu vezba
            INSERT INTO impl.vezba (naziv, misicna_grupa)
            VALUES (@naziv, @misicna_grupa);

            IF @@ROWCOUNT <> 1
                THROW 59001, N'Unos vezbe nije uspeo.', 1;

            DECLARE @idVezba INT = SCOPE_IDENTITY();

            -- Unos u potklasu kardio ili snaga
            IF @intervalni IS NOT NULL
                INSERT INTO impl.kardio (id, intervalni, intenzitet, prostor)
                VALUES (@idVezba, @intervalni, @intenzitet, @prostor);

            IF @tip_opterecenja IS NOT NULL
                INSERT INTO impl.snaga (id, tip_opterecenja, oprema)
                VALUES (@idVezba, @tip_opterecenja, @oprema);

        COMMIT TRANSACTION;

        -- (d) Vraca novi id pozivaocu
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

-- Provera loga
SELECT TOP 3 LogId, ErrorNumber, ErrorMessage, ProcedureName, LogDate
FROM impl.tblErrorLog ORDER BY LogId DESC;
GO

PRINT '------------------------------------------------------------------';
PRINT N' impl.UprValidateVezbaValues, impl.KreirajVezbu';
PRINT N' (refactoring verzija)';
PRINT N' su kreirane - ' + FORMAT(GETDATE(), '', 'sr-Latn-RS');
PRINT '------------------------------------------------------------------';
GO