/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ImplProcedureImprovementTrening.sql
**  OPIS:       Produkciona verzija procedura za entitet TRENING
**              sa svim unapredjenjima u odnosu na refaktorisanu
**              verziju (ImplProcedureRefactoringTrening.sql).
**
**              Unapredjenja u odnosu na prethodnu verziju:
**                (1) tblErrorCatalog — poruke se citaju iz kataloga
**                (2) Lokalna @Msg eliminise dupliranje teksta poruke
**                (3) SET XACT_ABORT ON
**                (4) UPDLOCK hint — zastita od race condition
**                (5) @@ROWCOUNT provera posle INSERT-a treninga
**                (6) UprCheckTreningConstraints se poziva UNUTAR
**                    transakcije (UPDLOCK mora biti aktivan)
**  AUTOR:      Andjela (DbDeveloper)
**  NAPOMENA:   Pokrenuti nakon ImplProcedureRefactoringTrening.sql
*/

USE [treninzi];
GO

-- =====================================================
-- 1. impl.UprValidateTreningValues  [AZURIRANA VERZIJA]
--    Poruke se citaju iz impl.tblErrorCatalog.
-- =====================================================
CREATE OR ALTER PROCEDURE impl.UprValidateTreningValues
    @naziv                  NVARCHAR(50),
    @broj_treninga_nedeljno INT,
    @CallerName             NVARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Msg          NVARCHAR(400);
    DECLARE @ErrCode      INT;
    DECLARE @SqlThrowCode INT;

    IF @naziv IS NULL OR @naziv = ''
    BEGIN
        SELECT @ErrCode = ErrorCode, @SqlThrowCode = SqlThrowCode, @Msg = ErrorMessage
        FROM impl.tblErrorCatalog WHERE ErrorCode = 3001;
        EXEC impl.UprLogError @ErrCode, @Msg, @CallerName;
        THROW @SqlThrowCode, @Msg, 1;
    END;

    IF @broj_treninga_nedeljno < 1 OR @broj_treninga_nedeljno > 7
    BEGIN
        SELECT @ErrCode = ErrorCode, @SqlThrowCode = SqlThrowCode, @Msg = ErrorMessage
        FROM impl.tblErrorCatalog WHERE ErrorCode = 3003;
        EXEC impl.UprLogError @ErrCode, @Msg, @CallerName;
        THROW @SqlThrowCode, @Msg, 1;
    END;
END;
GO

-- =====================================================
-- 2. impl.UprCheckTreningConstraints  [AZURIRANA VERZIJA]
--    UPDLOCK hint: zastita od race condition.
--    Poziva se UNUTAR transakcije.
-- =====================================================
CREATE OR ALTER PROCEDURE impl.UprCheckTreningConstraints
    @naziv      NVARCHAR(50),
    @trener     INT,
    @stavke     NVARCHAR(MAX) = NULL,
    @CallerName NVARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Msg          NVARCHAR(400);
    DECLARE @ErrCode      INT;
    DECLARE @SqlThrowCode INT;

    -- UPDLOCK: sprecava race condition pri istovremenom kreiranju
    IF EXISTS (
        SELECT 1 FROM impl.trening WITH (UPDLOCK)
        WHERE naziv = @naziv
    )
    BEGIN
        SELECT @ErrCode = ErrorCode, @SqlThrowCode = SqlThrowCode, @Msg = ErrorMessage
        FROM impl.tblErrorCatalog WHERE ErrorCode = 3002;
        EXEC impl.UprLogError @ErrCode, @Msg, @CallerName;
        THROW @SqlThrowCode, @Msg, 1;
    END;

    -- UPDLOCK: sprecava race condition pri brisanju trenera
    IF NOT EXISTS (
        SELECT 1 FROM impl.korisnik WITH (UPDLOCK)
        WHERE id = @trener
    )
    BEGIN
        SELECT @ErrCode = ErrorCode, @SqlThrowCode = SqlThrowCode, @Msg = ErrorMessage
        FROM impl.tblErrorCatalog WHERE ErrorCode = 4001;
        EXEC impl.UprLogError @ErrCode, @Msg, @CallerName;
        THROW @SqlThrowCode, @Msg, 1;
    END;
END;
GO

-- =====================================================
-- 3. impl.DodajTreningSaStavkama  [PRODUKCIONA VERZIJA]
--    Uloga: iskljucivo orkestracija:
--      (a) SET XACT_ABORT ON
--      (b) odredjuje @ProcName za log
--      (c) vrednosna ogranicenja VAN transakcije
--      (d) provera duplikata VAN transakcije
--      (e) otvara transakciju
--      (f) UprCheckTreningConstraints UNUTAR trans. (UPDLOCK)
--      (g) INSERT treninga + @@ROWCOUNT provera
--      (h) INSERT stavki
--      (i) u slucaju greske loguje i prosledjuje THROW
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

    -- (c) Vrednosna ogranicenja VAN transakcije
    EXEC impl.UprValidateTreningValues
        @naziv, @broj_treninga_nedeljno, @ProcName;

    -- (d) Provera duplikata VAN transakcije
    IF EXISTS (SELECT id_vezba FROM @stavke GROUP BY id_vezba HAVING COUNT(*) > 1)
    BEGIN
        SELECT @ErrCode = ErrorCode, @SqlThrowCode = SqlThrowCode, @Msg = ErrorMessage
        FROM impl.tblErrorCatalog WHERE ErrorCode = 3004;
        EXEC impl.UprLogError @ErrCode, @Msg, @ProcName;
        THROW @SqlThrowCode, @Msg, 1;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

            -- (f) Strukturna ogranicenja UNUTAR transakcije (UPDLOCK)
            EXEC impl.UprCheckTreningConstraints
                @naziv, @trener, NULL, @ProcName;

            -- (g) Unos treninga
            INSERT INTO impl.trening (naziv, cilj, broj_treninga_nedeljno, trener)
            VALUES (@naziv, @cilj, @broj_treninga_nedeljno, @trener);

            -- @@ROWCOUNT provera
            IF @@ROWCOUNT <> 1
            BEGIN
                DECLARE @SysMsg          NVARCHAR(400);
                DECLARE @SysSqlThrowCode INT;
                SELECT @SysSqlThrowCode = SqlThrowCode, @SysMsg = ErrorMessage
                FROM impl.tblErrorCatalog WHERE ErrorCode = 9001;
                THROW @SysSqlThrowCode, @SysMsg, 1;
            END;

            DECLARE @noviId INT = SCOPE_IDENTITY();

            -- (h) Unos stavki
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
-- 4. impl.PromeniTreningSaStavkama  [PRODUKCIONA VERZIJA]
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

    IF NOT EXISTS (SELECT 1 FROM impl.korisnik WITH (UPDLOCK) WHERE id = @trener)
    BEGIN
        SELECT @ErrCode = ErrorCode, @SqlThrowCode = SqlThrowCode, @Msg = ErrorMessage
        FROM impl.tblErrorCatalog WHERE ErrorCode = 4001;
        EXEC impl.UprLogError @ErrCode, @Msg, @ProcName;
        THROW @SqlThrowCode, @Msg, 1;
    END;

    IF impl.PostojiTreningSaNazivom(@id, @naziv) = 1
    BEGIN
        SELECT @ErrCode = ErrorCode, @SqlThrowCode = SqlThrowCode, @Msg = ErrorMessage
        FROM impl.tblErrorCatalog WHERE ErrorCode = 3002;
        EXEC impl.UprLogError @ErrCode, @Msg, @ProcName;
        THROW @SqlThrowCode, @Msg, 1;
    END;

    IF EXISTS (SELECT id_vezba FROM @stavke GROUP BY id_vezba HAVING COUNT(*) > 1)
    BEGIN
        SELECT @ErrCode = ErrorCode, @SqlThrowCode = SqlThrowCode, @Msg = ErrorMessage
        FROM impl.tblErrorCatalog WHERE ErrorCode = 3004;
        EXEC impl.UprLogError @ErrCode, @Msg, @ProcName;
        THROW @SqlThrowCode, @Msg, 1;
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
-- 5. impl.ObrisiTrening  [PRODUKCIONA VERZIJA]
-- =====================================================
CREATE OR ALTER PROCEDURE impl.ObrisiTrening
    @id_tr INT
AS
BEGIN
    SET XACT_ABORT ON;
    SET NOCOUNT ON;

    DECLARE @ProcName NVARCHAR(256) =
        QUOTENAME(OBJECT_SCHEMA_NAME(@@PROCID)) + N'.' + QUOTENAME(OBJECT_NAME(@@PROCID));

    DECLARE @Msg          NVARCHAR(400);
    DECLARE @ErrCode      INT;
    DECLARE @SqlThrowCode INT;

    IF EXISTS (SELECT 1 FROM impl.pracenje WHERE id_trening = @id_tr)
    BEGIN
        SELECT @ErrCode = ErrorCode, @SqlThrowCode = SqlThrowCode, @Msg = ErrorMessage
        FROM impl.tblErrorCatalog WHERE ErrorCode = 4002;
        EXEC impl.UprLogError @ErrCode, @Msg, @ProcName;
        THROW @SqlThrowCode, @Msg, 1;
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
SELECT TOP 5 LogId, ErrorNumber, ErrorMessage, ProcedureName, LogDate
FROM impl.tblErrorLog ORDER BY LogId DESC;
GO

PRINT '------------------------------------------------------------------';
PRINT N' impl.UprValidateTreningValues, impl.UprCheckTreningConstraints,';
PRINT N' impl.DodajTreningSaStavkama, impl.PromeniTreningSaStavkama,';
PRINT N' impl.ObrisiTrening (produkciona verzija)';
PRINT N' su kreirane - ' + FORMAT(GETDATE(), '', 'sr-Latn-RS');
PRINT '------------------------------------------------------------------';
GO