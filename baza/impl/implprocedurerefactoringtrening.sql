/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ImplProcedureRefactoringTrening.sql
**  OPIS:       Refaktorisane stored procedure za entitet TRENING.
**              Primenjeni principi u odnosu na prethodnu verziju:
**                (а) SRP: svaka procedura radi iskljucivo jednu stvar
**                (б) THROW umesto RAISERROR
**                (в) @CallerName parametar
**                (г) @ProcName dinamicki naziv procedure
**              Kreirane procedure:
**                (1) impl.UprValidateTreningValues   → vrednosna ogr.
**                (2) impl.UprCheckTreningConstraints → strukturna ogr.
**                (3) impl.DodajTreningSaStavkama     → orkestracija
**                (4) impl.PromeniTreningSaStavkama   → orkestracija
**                (5) impl.ObrisiTrening              → orkestracija
**  AUTOR:      Andjela (DbDeveloper)
**  NAPOMENA:   Pokrenuti nakon ImplProcedureTrening.sql
*/

USE [treninzi];
GO

-- =====================================================
-- 1. impl.UprValidateTreningValues
--    Privatna pomocna procedura za proveru vrednosnih
--    ogranicenja atributa entiteta TRENING.
--    Pokriva VPI:
--      - naziv je obavezan
--      - broj treninga nedeljno mora biti 1-7
--    Privatna procedura: impl sloj.
-- =====================================================
CREATE OR ALTER PROCEDURE impl.UprValidateTreningValues
    @naziv                  NVARCHAR(50),
    @broj_treninga_nedeljno INT,
    @CallerName             NVARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;

    IF @naziv IS NULL OR @naziv = ''
    BEGIN
        EXEC impl.UprLogError 3001, N'Naziv treninga je obavezan.', @CallerName;
        THROW 53001, N'Naziv treninga je obavezan.', 1;
    END;

    IF @broj_treninga_nedeljno < 1 OR @broj_treninga_nedeljno > 7
    BEGIN
        EXEC impl.UprLogError 3003, N'Broj treninga nedeljno mora biti izmedju 1 i 7.', @CallerName;
        THROW 53003, N'Broj treninga nedeljno mora biti izmedju 1 i 7.', 1;
    END;
END;
GO

-- =====================================================
-- 2. impl.UprCheckTreningConstraints
--    Privatna pomocna procedura za proveru strukturnih
--    ogranicenja entiteta TRENING.
--    Pokriva SPI:
--      - naziv mora biti jedinstven
--      - trener mora postojati
--    Privatna procedura: impl sloj.
-- =====================================================
CREATE OR ALTER PROCEDURE impl.UprCheckTreningConstraints
    @naziv      NVARCHAR(50),
    @trener     INT,
    @stavke     NVARCHAR(MAX) = NULL,
    @CallerName NVARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM impl.trening WHERE naziv = @naziv)
    BEGIN
        EXEC impl.UprLogError 3002, N'Trening sa tim nazivom vec postoji.', @CallerName;
        THROW 53002, N'Trening sa tim nazivom vec postoji.', 1;
    END;

    IF NOT EXISTS (SELECT 1 FROM impl.korisnik WHERE id = @trener)
    BEGIN
        EXEC impl.UprLogError 4001, N'Trener ne postoji.', @CallerName;
        THROW 54001, N'Trener ne postoji.', 1;
    END;
END;
GO

-- =====================================================
-- 3. impl.DodajTreningSaStavkama  [REFAKTORISANA VERZIJA]
-- =====================================================
CREATE OR ALTER PROCEDURE impl.DodajTreningSaStavkama
    @naziv                  NVARCHAR(50),
    @cilj                   NVARCHAR(20),
    @broj_treninga_nedeljno INT,
    @trener                 INT,
    @stavke                 impl.StavkaTrTip READONLY
AS
BEGIN
    SET XACT_ABORT ON;
    SET NOCOUNT ON;

    DECLARE @ProcName NVARCHAR(256) =
        QUOTENAME(OBJECT_SCHEMA_NAME(@@PROCID)) + N'.' + QUOTENAME(OBJECT_NAME(@@PROCID));

    DECLARE @Msg          NVARCHAR(400);
    DECLARE @ErrCode      INT;
    DECLARE @SqlThrowCode INT;

    -- Vrednosna ogranicenja VAN transakcije
    EXEC impl.UprValidateTreningValues
        @naziv, @broj_treninga_nedeljno, @ProcName;

    -- Provera duplikata vezbi VAN transakcije
    IF EXISTS (SELECT id_vezba FROM @stavke GROUP BY id_vezba HAVING COUNT(*) > 1)
    BEGIN
        EXEC impl.UprLogError 3004, N'Ista vezba ne sme biti vise puta u treningu.', @ProcName;
        THROW 53004, N'Ista vezba ne sme biti vise puta u treningu.', 1;
    END;

    -- Strukturna ogranicenja
    EXEC impl.UprCheckTreningConstraints @naziv, @trener, NULL, @ProcName;

    BEGIN TRY
        BEGIN TRANSACTION;

            INSERT INTO impl.trening (naziv, cilj, broj_treninga_nedeljno, trener)
            VALUES (@naziv, @cilj, @broj_treninga_nedeljno, @trener);

            DECLARE @noviId INT = SCOPE_IDENTITY();

            INSERT INTO impl.stavka_treninga
                (rb, id_trening, broj_ponavljanja, broj_serija, trajanje, id_vezba)
            SELECT rb, @noviId, broj_ponavljanja, broj_serija, trajanje, id_vezba
            FROM @stavke;

        COMMIT TRANSACTION;
        SELECT @noviId AS NoviId;
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
-- 4. impl.PromeniTreningSaStavkama  [REFAKTORISANA VERZIJA]
-- =====================================================
CREATE OR ALTER PROCEDURE impl.PromeniTreningSaStavkama
    @id                     INT,
    @naziv                  NVARCHAR(50),
    @cilj                   NVARCHAR(20),
    @broj_treninga_nedeljno INT,
    @trener                 INT,
    @stavke                 impl.StavkaTrTip READONLY
AS
BEGIN
    SET XACT_ABORT ON;
    SET NOCOUNT ON;

    DECLARE @ProcName NVARCHAR(256) =
        QUOTENAME(OBJECT_SCHEMA_NAME(@@PROCID)) + N'.' + QUOTENAME(OBJECT_NAME(@@PROCID));

    DECLARE @Msg          NVARCHAR(400);
    DECLARE @ErrCode      INT;
    DECLARE @SqlThrowCode INT;

    EXEC impl.UprValidateTreningValues
        @naziv, @broj_treninga_nedeljno, @ProcName;

    IF NOT EXISTS (SELECT 1 FROM impl.korisnik WHERE id = @trener)
    BEGIN
        EXEC impl.UprLogError 4001, N'Trener ne postoji.', @ProcName;
        THROW 54001, N'Trener ne postoji.', 1;
    END;

    IF impl.PostojiTreningSaNazivom(@id, @naziv) = 1
    BEGIN
        EXEC impl.UprLogError 3002, N'Trening sa tim nazivom vec postoji.', @ProcName;
        THROW 53002, N'Trening sa tim nazivom vec postoji.', 1;
    END;

    IF EXISTS (SELECT id_vezba FROM @stavke GROUP BY id_vezba HAVING COUNT(*) > 1)
    BEGIN
        EXEC impl.UprLogError 3004, N'Ista vezba ne sme biti vise puta u treningu.', @ProcName;
        THROW 53004, N'Ista vezba ne sme biti vise puta u treningu.', 1;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

            UPDATE impl.trening
            SET naziv = @naziv, cilj = @cilj,
                broj_treninga_nedeljno = @broj_treninga_nedeljno, trener = @trener
            WHERE id = @id;

            DELETE FROM impl.stavka_treninga
            WHERE id_trening = @id AND rb NOT IN (SELECT rb FROM @stavke);

            MERGE impl.stavka_treninga AS target
            USING @stavke AS source
            ON (target.id_trening = @id AND target.rb = source.rb)
            WHEN MATCHED THEN
                UPDATE SET broj_ponavljanja = source.broj_ponavljanja,
                           broj_serija = source.broj_serija,
                           trajanje = source.trajanje,
                           id_vezba = source.id_vezba
            WHEN NOT MATCHED BY TARGET THEN
                INSERT (id_trening, rb, broj_ponavljanja, broj_serija, trajanje, id_vezba)
                VALUES (@id, source.rb, source.broj_ponavljanja, source.broj_serija,
                        source.trajanje, source.id_vezba);

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
-- 5. impl.ObrisiTrening  [REFAKTORISANA VERZIJA]
-- =====================================================
CREATE OR ALTER PROCEDURE impl.ObrisiTrening
    @id_tr INT
AS
BEGIN
    SET XACT_ABORT ON;
    SET NOCOUNT ON;

    DECLARE @ProcName NVARCHAR(256) =
        QUOTENAME(OBJECT_SCHEMA_NAME(@@PROCID)) + N'.' + QUOTENAME(OBJECT_NAME(@@PROCID));

    IF EXISTS (SELECT 1 FROM impl.pracenje WHERE id_trening = @id_tr)
    BEGIN
        EXEC impl.UprLogError 4002,
            N'Ne moze da se obrise trening jer postoje pracenja za njega.',
            @ProcName;
        THROW 54002, N'Ne moze da se obrise trening jer postoje pracenja za njega.', 1;
    END;

    DELETE FROM impl.trening WHERE id = @id_tr;
END;
GO

-- =====================================================
-- TESTOVI
-- =====================================================

-- Priprema
DELETE FROM impl.trening WHERE naziv = N'Test trening osnovna';
GO

-- Test 1: Ispravan unos treninga
PRINT N'Test 1: Ispravan unos treninga';
DECLARE @stavke impl.StavkaTrTip;
INSERT INTO @stavke (rb, broj_ponavljanja, broj_serija, trajanje, id_vezba)
VALUES (1, 10, 3, 0, 1), (2, 0, 3, 40, 7);
EXEC impl.DodajTreningSaStavkama
    @naziv = N'Test trening osnovna', @cilj = N'snaga',
    @broj_treninga_nedeljno = 3, @trener = 1, @stavke = @stavke;
PRINT N'  Test 1 prosao';
GO

-- Test 2: Prazan naziv — treba da baci gresku
PRINT N'Test 2: Prazan naziv';
BEGIN TRY
    DECLARE @s2 impl.StavkaTrTip;
    EXEC impl.DodajTreningSaStavkama
        @naziv = N'', @cilj = N'snaga',
        @broj_treninga_nedeljno = 3, @trener = 1, @stavke = @s2;
END TRY
BEGIN CATCH
    PRINT N'  Greska (' + CAST(ERROR_NUMBER() AS NVARCHAR) + N'): ' + ERROR_MESSAGE();
END CATCH;
GO

-- Test 3: Naziv vec postoji — treba da baci gresku
PRINT N'Test 3: Naziv vec postoji';
BEGIN TRY
    DECLARE @s3 impl.StavkaTrTip;
    EXEC impl.DodajTreningSaStavkama
        @naziv = N'Test trening osnovna', @cilj = N'snaga',
        @broj_treninga_nedeljno = 3, @trener = 1, @stavke = @s3;
END TRY
BEGIN CATCH
    PRINT N'  Greska (' + CAST(ERROR_NUMBER() AS NVARCHAR) + N'): ' + ERROR_MESSAGE();
END CATCH;
GO

-- Test 4: Trener ne postoji — treba da baci gresku
PRINT N'Test 4: Trener ne postoji';
BEGIN TRY
    DECLARE @s4 impl.StavkaTrTip;
    EXEC impl.DodajTreningSaStavkama
        @naziv = N'Novi test trening', @cilj = N'snaga',
        @broj_treninga_nedeljno = 3, @trener = 9999, @stavke = @s4;
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
PRINT N' impl.UprValidateTreningValues, impl.UprCheckTreningConstraints,';
PRINT N' impl.DodajTreningSaStavkama, impl.PromeniTreningSaStavkama,';
PRINT N' impl.ObrisiTrening (refactoring verzija)';
PRINT N' su kreirane - ' + FORMAT(GETDATE(), '', 'sr-Latn-RS');
PRINT '------------------------------------------------------------------';
GO