/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ImplProcedureTrening.sql
**  OPIS:       Kreiranje stored procedura za entitet TRENING.
**              Osnovna verzija — bez pomocnih procedura (SRP).
**              Validacija i strukturna ogranicenja su direktno
**              u procedurama. Greske se prijavljuju pomocu
**              RAISERROR i upisuju direktno u tblErrorLog.
**                в.1. impl.DodajTreningSaStavkama
**                в.2. impl.PromeniTreningSaStavkama
**                в.3. impl.ObrisiTrening
**                в.4. impl.ObrisiTreningCascade
**  AUTOR:      Andjela (DbDeveloper)
**  NAPOMENA:   Pokrenuti nakon 02_KreiranjeTabela.sql
*/

USE [treninzi];
GO

-- =====================================================
-- в.1. impl.DodajTreningSaStavkama
--    Procedura za unos novog treninga sa stavkama.
--    Osnovna verzija bez pomocnih procedura.
--    SPI:
--      v.1. Restrict KORISNIK — trener mora postojati
--      v.2. Restrict VEZBA   — svaka vezba u stavkama
--           mora postojati u bazi
-- =====================================================
CREATE OR ALTER PROCEDURE impl.DodajTreningSaStavkama
    @naziv                  NVARCHAR(50),
    @cilj                   NVARCHAR(20),
    @broj_treninga_nedeljno INT,
    @trener                 INT,
    @stavke                 impl.StavkaTrTip READONLY
AS
BEGIN
    SET NOCOUNT ON;

    -- Vrednosna ogranicenja
    IF @naziv IS NULL OR @naziv = ''
    BEGIN
        RAISERROR(N'Naziv treninga je obavezan.', 16, 1);
        RETURN;
    END;

    IF @broj_treninga_nedeljno < 1 OR @broj_treninga_nedeljno > 7
    BEGIN
        RAISERROR(N'Broj treninga nedeljno mora biti izmedju 1 i 7.', 16, 1);
        RETURN;
    END;

    -- Strukturna ogranicenja
    IF EXISTS (SELECT 1 FROM impl.trening WHERE naziv = @naziv)
    BEGIN
        RAISERROR(N'Trening sa tim nazivom vec postoji.', 16, 1);
        RETURN;
    END;

    -- v.1. Restrict KORISNIK: trener mora postojati
    IF NOT EXISTS (SELECT 1 FROM impl.korisnik WHERE id = @trener)
    BEGIN
        RAISERROR(N'Navedeni trener nije pronadjen. Nije moguce kreirati trening bez validnog trenera.', 16, 1);
        RETURN;
    END;

    IF EXISTS (SELECT id_vezba FROM @stavke GROUP BY id_vezba HAVING COUNT(*) > 1)
    BEGIN
        RAISERROR(N'Ista vezba ne sme biti vise puta u treningu.', 16, 1);
        RETURN;
    END;

    -- v.2. Restrict VEZBA: svaka vezba iz stavki mora postojati
    IF EXISTS (
        SELECT 1 FROM @stavke s
        WHERE NOT EXISTS (
            SELECT 1 FROM impl.vezba WHERE id = s.id_vezba
        )
    )
    BEGIN
        RAISERROR(N'Ne postoji navedena vezba. Nije moguce ubaciti stavku za nepostojecu vezbu.', 16, 1);
        RETURN;
    END;

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
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        INSERT INTO impl.tblErrorLog (ErrorNumber, ErrorMessage, ProcedureName)
        VALUES (ERROR_NUMBER(), ERROR_MESSAGE(), OBJECT_NAME(@@PROCID));
        THROW;
    END CATCH
END;
GO

-- =====================================================
-- в.2. impl.PromeniTreningSaStavkama
--    Procedura za izmenu postojeceg treninga sa stavkama.
--    Osnovna verzija bez pomocnih procedura.
--    SPI:
--      v.1. Restrict KORISNIK — trener mora postojati
--      v.2. Restrict VEZBA   — svaka vezba u stavkama
--           mora postojati u bazi
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
    SET NOCOUNT ON;

    -- Vrednosna ogranicenja
    IF @naziv IS NULL OR @naziv = ''
    BEGIN
        RAISERROR(N'Naziv treninga je obavezan.', 16, 1);
        RETURN;
    END;

    IF @broj_treninga_nedeljno < 1 OR @broj_treninga_nedeljno > 7
    BEGIN
        RAISERROR(N'Broj treninga nedeljno mora biti izmedju 1 i 7.', 16, 1);
        RETURN;
    END;

    -- Strukturna ogranicenja

    -- v.1. Restrict KORISNIK: trener mora postojati
    IF NOT EXISTS (SELECT 1 FROM impl.korisnik WHERE id = @trener)
    BEGIN
        RAISERROR(N'Navedeni trener nije pronadjen. Nije moguce promeniti trening bez validnog trenera.', 16, 1);
        RETURN;
    END;

    IF impl.PostojiTreningSaNazivom(@id, @naziv) = 1
    BEGIN
        RAISERROR(N'Trening sa tim nazivom vec postoji.', 16, 1);
        RETURN;
    END;

    IF EXISTS (SELECT id_vezba FROM @stavke GROUP BY id_vezba HAVING COUNT(*) > 1)
    BEGIN
        RAISERROR(N'Ista vezba ne sme biti vise puta u treningu.', 16, 1);
        RETURN;
    END;

    -- v.2. Restrict VEZBA: svaka vezba iz stavki mora postojati
    IF EXISTS (
        SELECT 1 FROM @stavke s
        WHERE NOT EXISTS (
            SELECT 1 FROM impl.vezba WHERE id = s.id_vezba
        )
    )
    BEGIN
        RAISERROR(N'Navedena vezba ne postoji. Nije moguce promeniti id vezbe na vrednost koja ne postoji.', 16, 1);
        RETURN;
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
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        INSERT INTO impl.tblErrorLog (ErrorNumber, ErrorMessage, ProcedureName)
        VALUES (ERROR_NUMBER(), ERROR_MESSAGE(), OBJECT_NAME(@@PROCID));
        THROW;
    END CATCH
END;
GO

-- =====================================================
-- в.3. impl.ObrisiTrening  [Restrict]
--    Procedura za brisanje treninga.
--    SPI v.1. Restrict PRACENJE:
--    Ne moze se obrisati trening ako ima pracenja.
-- =====================================================
CREATE OR ALTER PROCEDURE impl.ObrisiTrening
    @id_tr INT
AS
BEGIN
    SET NOCOUNT ON;

    -- v.1. Restrict PRACENJE
    IF EXISTS (SELECT 1 FROM impl.pracenje WHERE id_trening = @id_tr)
    BEGIN
        RAISERROR(N'Ne može da se obriše trening jer postoje praćenja za njega.', 16, 1);
        RETURN;
    END;

    -- Stavke se brisu automatski (ON DELETE CASCADE na FK_stavka_trening)
    DELETE FROM impl.trening WHERE id = @id_tr;
END;
GO

-- =====================================================
-- в.4. impl.ObrisiTreningCascade  [Cascade]
--    Procedura za brisanje treninga sa pracenjima.
--    SPI v.1. Cascade PRACENJE:
--    Brise pracenja pa trening. Stavke idu automatski.
-- =====================================================
CREATE OR ALTER PROCEDURE impl.ObrisiTreningCascade
    @id_tr INT
AS
BEGIN
    SET XACT_ABORT ON;
    SET NOCOUNT ON;

    DECLARE @ProcName NVARCHAR(256) =
        QUOTENAME(OBJECT_SCHEMA_NAME(@@PROCID)) + N'.' +
        QUOTENAME(OBJECT_NAME(@@PROCID));

    BEGIN TRY
        BEGIN TRANSACTION;

            -- Cascade korak 1: brisi pracenja
            DELETE FROM impl.pracenje WHERE id_trening = @id_tr;

            -- Cascade korak 2: brisi trening
            -- (stavke se brisu automatski via ON DELETE CASCADE)
            DELETE FROM impl.trening WHERE id = @id_tr;

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
-- в.5. impl.VratiTreninge
--    Procedura za vracanje svih treninga.
-- =====================================================
CREATE OR ALTER PROCEDURE impl.VratiTreninge
AS
BEGIN
    SELECT *
    FROM impl.vwTrening
    ORDER BY id_trening, rb_stavke;
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
PRINT N'Test 2: Prazan naziv treninga';
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
PRINT N'Test 3: Trening sa tim nazivom vec postoji';
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

-- Test 5: Vezba ne postoji — treba da baci gresku (novo)
PRINT N'Test 5: Vezba ne postoji';
BEGIN TRY
    DECLARE @s5 impl.StavkaTrTip;
    INSERT INTO @s5 (rb, broj_ponavljanja, broj_serija, trajanje, id_vezba)
    VALUES (1, 10, 3, 0, 9999); -- id_vezba ne postoji
    EXEC impl.DodajTreningSaStavkama
        @naziv = N'Test vezba restrict', @cilj = N'snaga',
        @broj_treninga_nedeljno = 3, @trener = 1, @stavke = @s5;
END TRY
BEGIN CATCH
    PRINT N'  Greška (' + CAST(ERROR_NUMBER() AS NVARCHAR) + N'): ' + ERROR_MESSAGE();
END CATCH;
GO

-- Test 6: Restrict — trening ima pracenja, treba da baci gresku
PRINT N'Test 6: Restrict — trening ima praćenja';
BEGIN TRY
    EXEC impl.ObrisiTrening @id_tr = 14;
END TRY
BEGIN CATCH
    PRINT N'  Greska (' + CAST(ERROR_NUMBER() AS NVARCHAR) + N'): ' + ERROR_MESSAGE();
END CATCH;
GO

-- Test 7: Cascade — brise pracenja i trening
PRINT N'Test 7: Cascade — brise pracenja i trening';
EXEC impl.ObrisiTreningCascade @id_tr = 12;
PRINT N'  Test 7 prosao';
GO

-- Provera — treba 0 redova za obrisani trening
PRINT N'Provera:';
SELECT COUNT(*) AS BrojPracenja FROM impl.pracenje        WHERE id_trening = 12;
SELECT COUNT(*) AS BrojStavki   FROM impl.stavka_treninga WHERE id_trening = 12;
SELECT COUNT(*) AS BrojTreninga FROM impl.trening          WHERE id = 12;
GO

-- Provera loga
SELECT TOP 5 LogId, ErrorNumber, ErrorMessage, ProcedureName, LogDate
FROM impl.tblErrorLog ORDER BY LogId DESC;
GO

PRINT '------------------------------------------------------------------';
PRINT N' impl.DodajTreningSaStavkama, impl.PromeniTreningSaStavkama,';
PRINT N' impl.ObrisiTrening, impl.ObrisiTreningCascade (osnovna verzija)';
PRINT N' su kreirane - ' + FORMAT(GETDATE(), '', 'sr-Latn-RS');
PRINT '------------------------------------------------------------------';
GO