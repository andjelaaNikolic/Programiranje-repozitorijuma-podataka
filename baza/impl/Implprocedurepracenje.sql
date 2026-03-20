/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ImplProcedurePracenje.sql
**  OPIS:       Kreiranje stored procedura za entitet PRACENJE.
**              Osnovna verzija — bez pomocnih procedura (SRP).
**              Greske se prijavljuju pomocu RAISERROR i
**              upisuju direktno u tblErrorLog.
**                в.1. impl.PromeniPracenja
**  AUTOR:      Andjela (DbDeveloper)
**  NAPOMENA:   Pokrenuti nakon 02_KreiranjeTabela.sql
*/

USE [treninzi];
GO

-- =====================================================
-- в.1. impl.PromeniPracenja
--    Procedura za sinhronizaciju pracenja klijenta.
--    Koristi MERGE — jednom operacijom:
--      INSERT nova pracenja, UPDATE postojeca,
--      DELETE uklonjena pracenja.
--    Osnovna verzija bez pomocnih procedura.
-- =====================================================
CREATE OR ALTER PROCEDURE impl.PromeniPracenja
    @id_klijent INT,
    @NoviPodaci impl.PracenjeTip READONLY
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

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

-- Priprema: reset pracenja za klijenta id=2
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

-- Provera
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

-- Provera posle Test 2
PRINT N'Provera posle Test 2 — treba 0 redova:';
SELECT COUNT(*) AS BrojPracenja FROM impl.pracenje WHERE id_klijent = 2;
GO

-- Vrati originalna pracenja
INSERT INTO impl.pracenje (id_klijent, id_trening, datum_pocetka, cilj_broj_treninga)
VALUES
    (2, 12, CAST(N'2026-05-05' AS DATE), 5),
    (2, 13, CAST(N'2026-03-18' AS DATE), 2);
GO

PRINT '------------------------------------------------------------------';
PRINT N' impl.PromeniPracenja (osnovna verzija)';
PRINT N' je kreirana - ' + FORMAT(GETDATE(), '', 'sr-Latn-RS');
PRINT '------------------------------------------------------------------';
GO