/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ImplProcedureVezba.sql
**  OPIS:       Kreiranje stored procedura za entitet VEZBA.
**              Osnovna verzija — bez pomocnih procedura (SRP).
**              Validacija i strukturna ogranicenja su direktno
**              u procedurama. Greske se prijavljuju pomocu
**              RAISERROR i upisuju direktno u tblErrorLog.
**                в.1. impl.KreirajVezbu
**  AUTOR:      Andjela (DbDeveloper)
**  NAPOMENA:   Pokrenuti nakon 02_KreiranjeTabela.sql
*/

USE [treninzi];
GO

-- =====================================================
-- в.1. impl.KreirajVezbu
--    Procedura za unos nove vezbe (kardio ili snaga).
--    Vezba mora biti ili kardio ili snaga (IS-A veza).
--    Proverava vrednosna i strukturna ogranicenja
--    direktno u proceduri (bez pomocnih procedura).
--    Greske se upisuju u impl.tblErrorLog.
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
    SET NOCOUNT ON;

    -- Vrednosna ogranicenja
    IF @naziv IS NULL OR @naziv = ''
    BEGIN
        RAISERROR(N'Naziv vezbe je obavezan.', 16, 1);
        RETURN;
    END;

    IF @misicna_grupa IS NULL OR @misicna_grupa = ''
    BEGIN
        RAISERROR(N'Naziv mišićne grupe je obavezan.', 16, 1);
        RETURN;
    END;

    -- Strukturna ogranicenja
    IF EXISTS (SELECT 1 FROM impl.vezba WHERE naziv = @naziv)
    BEGIN
        RAISERROR(N'Vežba sa tim nazivom već postoji.', 16, 1);
        RETURN;
    END;

    IF @intervalni IS NOT NULL AND @tip_opterecenja IS NOT NULL
    BEGIN
        RAISERROR(N'Vežba ne moze biti istovremeno kardio i snaga.', 16, 1);
        RETURN;
    END;

    IF @intervalni IS NULL AND @tip_opterecenja IS NULL
    BEGIN
        RAISERROR(N'Vežba mora biti ili kardio ili snaga.', 16, 1);
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

            INSERT INTO impl.vezba (naziv, misicna_grupa)
            VALUES (@naziv, @misicna_grupa);

            DECLARE @idVezba INT = SCOPE_IDENTITY();

            IF @intervalni IS NOT NULL
                INSERT INTO impl.kardio (id, intervalni, intenzitet, prostor)
                VALUES (@idVezba, @intervalni, @intenzitet, @prostor);

            IF @tip_opterecenja IS NOT NULL
                INSERT INTO impl.snaga (id, tip_opterecenja, oprema)
                VALUES (@idVezba, @tip_opterecenja, @oprema);

        COMMIT TRANSACTION;
        SELECT @idVezba AS IdVezba;
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
        @naziv = N'', @misicna_grupa = N'noge',
        @intervalni = 1;
END TRY
BEGIN CATCH
    PRINT N'  Greška (' + CAST(ERROR_NUMBER() AS NVARCHAR) + N'): ' + ERROR_MESSAGE();
END CATCH;
GO

-- Test 3: Naziv vec postoji — treba da baci gresku
PRINT N'Test 3: Vežba sa tim nazivom vec postoji';
BEGIN TRY
    EXEC impl.KreirajVezbu
        @naziv = N'TestKardio', @misicna_grupa = N'noge',
        @intervalni = 1;
END TRY
BEGIN CATCH
    PRINT N'  Greška (' + CAST(ERROR_NUMBER() AS NVARCHAR) + N'): ' + ERROR_MESSAGE();
END CATCH;
GO

-- Test 4: I kardio i snaga — treba da baci gresku
PRINT N'Test 4: Vezba ne moze biti i kardio i snaga';
BEGIN TRY
    EXEC impl.KreirajVezbu
        @naziv = N'TestVezba3', @misicna_grupa = N'noge',
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
PRINT N' impl.KreirajVezbu (osnovna verzija)';
PRINT N' je kreirana - ' + FORMAT(GETDATE(), '', 'sr-Latn-RS');
PRINT '------------------------------------------------------------------';
GO



-- =====================================================
-- v.1. impl.ObrisiVezbu  [Restrict]
--    Procedura za brisanje vezbe.
--    SPI v.1. Restrict STAVKA:
--    Ne moze se obrisati vezba ako se koristi
--    u stavkama treninga.
--    Kardio/Snaga se brisu automatski
--    (ON DELETE CASCADE na FK_kardio_vezba i FK_snaga_vezba).
-- =====================================================
CREATE OR ALTER PROCEDURE impl.ObrisiVezbu
    @id_vezba INT
AS
BEGIN
    SET NOCOUNT ON;
 
    -- v.1. Restrict STAVKA
    IF EXISTS (SELECT 1 FROM impl.stavka_treninga WHERE id_vezba = @id_vezba)
    BEGIN
        RAISERROR(N'Navedena vezba se koristi u stavkama treninga. Nije moguce obrisati vezbu.', 16, 1);
        RETURN;
    END;
 
    -- Kardio/Snaga se brisu automatski (ON DELETE CASCADE)
    DELETE FROM impl.vezba WHERE id = @id_vezba;
END;
GO
 
-- =====================================================
-- v.2. impl.ObrisiVezbuCascade  [Cascade]
--    Procedura za brisanje vezbe sa stavkama.
--    SPI v.2. Cascade KARDIO/SNAGA + STAVKA:
--    Brise stavke treninga koje koriste ovu vezbu,
--    pa brise vezbu (kardio/snaga idu automatski).
-- =====================================================
CREATE OR ALTER PROCEDURE impl.ObrisiVezbuCascade
    @id_vezba INT
AS
BEGIN
    SET XACT_ABORT ON;
    SET NOCOUNT ON;
 
    DECLARE @ProcName NVARCHAR(256) =
        QUOTENAME(OBJECT_SCHEMA_NAME(@@PROCID)) + N'.' +
        QUOTENAME(OBJECT_NAME(@@PROCID));
 
    BEGIN TRY
        BEGIN TRANSACTION;
 
            -- Cascade korak 1: brisi stavke koje koriste ovu vezbu
            DELETE FROM impl.stavka_treninga WHERE id_vezba = @id_vezba;
 
            -- Cascade korak 2: brisi vezbu
            -- (kardio/snaga se brisu automatski ON DELETE CASCADE)
            DELETE FROM impl.vezba WHERE id = @id_vezba;
 
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        DECLARE @ErrNumber  INT           = ERROR_NUMBER();
        DECLARE @ErrMessage NVARCHAR(400) = ERROR_MESSAGE();
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        INSERT INTO impl.tblErrorLog (ErrorNumber, ErrorMessage, ProcedureName)
        VALUES (@ErrNumber, @ErrMessage, @ProcName);
        THROW;
    END CATCH
END;
GO
 
-- =====================================================
-- TESTOVI
-- =====================================================
 
-- Priprema: proveri koje vezbe se koriste u stavkama
SELECT v.id, v.naziv, COUNT(s.id_vezba) AS BrojStavki
FROM impl.vezba v
LEFT JOIN impl.stavka_treninga s ON s.id_vezba = v.id
GROUP BY v.id, v.naziv
ORDER BY BrojStavki DESC;
GO
 
-- Test 1: Restrict — vezba se koristi u stavkama, treba da baci gresku
PRINT N'Test 1: Restrict — vežba se koristi u stavkama';
BEGIN TRY
    EXEC impl.ObrisiVezbu @id_vezba = 7;
END TRY
BEGIN CATCH
    PRINT N'  Greška (' + CAST(ERROR_NUMBER() AS NVARCHAR) + N'): ' + ERROR_MESSAGE();
END CATCH;
GO
 
-- Test 2: Cascade — brise stavke i vezbu
PRINT N'Test 2: Cascade — briše stavke i vežbu';
EXEC impl.ObrisiVezbuCascade @id_vezba = 1;
PRINT N'  Test 2 je prošao';
GO
 
-- Provera — treba 0 redova za obrisanu vezbu
PRINT N'Provera:';
SELECT COUNT(*) AS BrojStavki FROM impl.stavka_treninga WHERE id_vezba = 1;
SELECT COUNT(*) AS BrojVezbi  FROM impl.vezba            WHERE id = 1;
SELECT COUNT(*) AS BrojKardio FROM impl.kardio            WHERE id = 1;
SELECT COUNT(*) AS BrojSnaga  FROM impl.snaga             WHERE id = 1;
GO
 
PRINT '------------------------------------------------------------------';
PRINT N' impl.ObrisiVezbu (restrict), impl.ObrisiVezbuCascade (cascade)';
PRINT N' su kreirane - ' + FORMAT(GETDATE(), '', 'sr-Latn-RS');
PRINT '------------------------------------------------------------------';
GO