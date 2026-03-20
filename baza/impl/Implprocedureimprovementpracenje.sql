/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ImplProcedureImprovementPracenje.sql
**  OPIS:       Produkciona verzija procedura za entitet PRACENJE
**              sa svim unapredjenjima u odnosu na refaktorisanu
**              verziju (ImplProcedureRefactoringPracenje.sql).
**
**              Unapredjenja u odnosu na prethodnu verziju:
**                (1) tblErrorCatalog — sistemske greske se citaju
**                    iz kataloga (ErrorCode 9001)
**                (2) SET XACT_ABORT ON
**  AUTOR:      Andjela (DbDeveloper)
**  NAPOMENA:   Pokrenuti nakon ImplProcedureRefactoringPracenje.sql
*/

USE [treninzi];
GO

-- =====================================================
-- 1. impl.PromeniPracenja  [PRODUKCIONA VERZIJA]
--    Procedura za sinhronizaciju pracenja klijenta.
--    Uloga: iskljucivo orkestracija:
--      (a) SET XACT_ABORT ON — automatski ROLLBACK
--          kod kriticnih gresaka koje TRY-CATCH
--          ne hvata
--      (b) odredjuje @ProcName za log
--      (c) izvrsava MERGE u transakciji
--      (d) u slucaju greske loguje i prosledjuje THROW
-- =====================================================
CREATE OR ALTER PROCEDURE impl.PromeniPracenja
    @id_klijent INT,
    @NoviPodaci impl.PracenjeTip READONLY
AS
BEGIN
    -- (a) SET XACT_ABORT ON
    SET XACT_ABORT ON;
    SET NOCOUNT ON;

    -- (b) Dinamicki naziv procedure za log
    DECLARE @ProcName NVARCHAR(256) =
        QUOTENAME(OBJECT_SCHEMA_NAME(@@PROCID)) + N'.' + QUOTENAME(OBJECT_NAME(@@PROCID));

    BEGIN TRY
        BEGIN TRANSACTION;

            -- (c) Sinhronizacija pracenja pomocu MERGE
            MERGE impl.pracenje AS target
            USING @NoviPodaci AS source
            ON (target.id_klijent = @id_klijent AND target.id_trening = source.id_trening)
            WHEN MATCHED THEN
                UPDATE SET
                     datum_pocetka      = source.datum_pocetka
                    ,cilj_broj_treninga = source.cilj_broj_treninga
            WHEN NOT MATCHED BY TARGET THEN
                INSERT (id_klijent, id_trening, datum_pocetka, cilj_broj_treninga)
                VALUES (@id_klijent, source.id_trening, source.datum_pocetka, source.cilj_broj_treninga)
            WHEN NOT MATCHED BY SOURCE AND target.id_klijent = @id_klijent THEN
                DELETE;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        DECLARE @ErrNumber  INT           = ERROR_NUMBER();
        DECLARE @ErrMessage NVARCHAR(400) = ERROR_MESSAGE();
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        -- (d) Logovanje greske
        EXEC impl.UprLogError @ErrNumber, @ErrMessage, @ProcName;
        THROW;
    END CATCH
END;
GO

-- =====================================================
-- TESTOVI
-- =====================================================

-- Priprema
DELETE FROM impl.pracenje WHERE id_klijent = 2;
INSERT INTO impl.pracenje (id_klijent, id_trening, datum_pocetka, cilj_broj_treninga)
VALUES
    (2, 12, CAST(N'2026-05-05' AS DATE), 5),
    (2, 13, CAST(N'2026-03-18' AS DATE), 2);
GO

-- Test 1: Sinhronizacija — dodaj i izmeni
PRINT N'Test 1: Sinhronizacija pracenja';
DECLARE @podaci impl.PracenjeTip;
INSERT INTO @podaci (id_trening, datum_pocetka, cilj_broj_treninga)
VALUES
    (12, CAST(N'2026-06-01' AS DATE), 8),
    (14, CAST(N'2026-06-15' AS DATE), 3);
EXEC impl.PromeniPracenja @id_klijent = 2, @NoviPodaci = @podaci;
PRINT N'  Test 1 prosao';
GO

-- Provera posle Test 1
PRINT N'Provera posle Test 1:';
SELECT p.id_klijent, t.naziv, p.datum_pocetka, p.cilj_broj_treninga
FROM impl.pracenje p
JOIN impl.trening t ON t.id = p.id_trening
WHERE p.id_klijent = 2
ORDER BY p.id_trening;
GO

-- Test 2: Ukloni sva pracenja
PRINT N'Test 2: Ukloni sva pracenja';
DECLARE @prazno impl.PracenjeTip;
EXEC impl.PromeniPracenja @id_klijent = 2, @NoviPodaci = @prazno;
PRINT N'  Test 2 prosao';
GO

PRINT N'Provera posle Test 2 — treba 0 redova:';
SELECT COUNT(*) AS BrojPracenja FROM impl.pracenje WHERE id_klijent = 2;
GO

-- Vrati originalna pracenja
INSERT INTO impl.pracenje (id_klijent, id_trening, datum_pocetka, cilj_broj_treninga)
VALUES
    (2, 12, CAST(N'2026-05-05' AS DATE), 5),
    (2, 13, CAST(N'2026-03-18' AS DATE), 2);
GO

-- Provera loga
SELECT TOP 3 LogId, ErrorNumber, ErrorMessage, ProcedureName, LogDate
FROM impl.tblErrorLog ORDER BY LogId DESC;
GO

PRINT '------------------------------------------------------------------';
PRINT N' impl.PromeniPracenja (produkciona verzija)';
PRINT N' je kreirana - ' + FORMAT(GETDATE(), '', 'sr-Latn-RS');
PRINT '------------------------------------------------------------------';
GO