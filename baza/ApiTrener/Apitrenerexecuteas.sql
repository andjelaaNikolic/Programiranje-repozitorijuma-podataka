/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ApiTrenerExecuteAs.sql
**  OPIS:       Unapredjenje api_trener procedura sa
**              EXECUTE AS i GRANT EXECUTE.
**
**              Arhitekturni kontekst:
**                SOFTWARE
**                └── Application Trener (User::Andrijana)
**                    └── DB Solution [treninzi]
**                        ├── DB API
**                        │   └── api_trener.*  ← ove procedure
**                        └── DB ADT
**                            └── spec.*  ← pozivaju
**
**              Bezbednost:
**                - WITH ENCRYPTION: skriva implementaciju
**                - EXECUTE AS 'Andjela': izvrsava se u
**                  kontekstu vlasnika impl/spec sloja;
**                  Andrijana (pozivalac) ne mora direktno
**                  da pristupa nizim slojevima —
**                  princip minimalnih privilegija
**                - GRANT EXECUTE na DbTrenerApp roli
**  AUTOR:      Andrijana (DbApiDeveloper)
**  NAPOMENA:   Pokrenuti nakon 07_ApiTrener.sql
*/

USE [treninzi];
GO

-- =====================================================
-- 1. api_trener.KreirajVezbu  [UNAPREDJENA]
-- =====================================================
CREATE OR ALTER PROCEDURE api_trener.KreirajVezbu
    @naziv           NVARCHAR(20),
    @misicna_grupa   NVARCHAR(50),
    @intervalni      BIT           = NULL,
    @intenzitet      NVARCHAR(20)  = NULL,
    @prostor         NVARCHAR(20)  = NULL,
    @tip_opterecenja NVARCHAR(20)  = NULL,
    @oprema          BIT           = NULL
WITH ENCRYPTION,
     EXECUTE AS 'Andjela'
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.KreirajVezbu
        @naziv, @misicna_grupa,
        @intervalni, @intenzitet, @prostor,
        @tip_opterecenja, @oprema;
END;
GO

-- =====================================================
-- 2. api_trener.KreirajTrening  [UNAPREDJENA]
-- =====================================================
CREATE OR ALTER PROCEDURE api_trener.KreirajTrening
    @naziv                  NVARCHAR(50),
    @cilj                   NVARCHAR(20),
    @broj_treninga_nedeljno INT,
    @trener                 INT,
    @stavke                 impl.StavkaTrTip READONLY
WITH ENCRYPTION,
     EXECUTE AS 'Andjela'
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.DodajTreningSaStavkama
        @naziv, @cilj, @broj_treninga_nedeljno, @trener, @stavke;
END;
GO

-- =====================================================
-- 3. api_trener.IzmeniTrening  [UNAPREDJENA]
-- =====================================================
CREATE OR ALTER PROCEDURE api_trener.IzmeniTrening
    @id                     INT,
    @naziv                  NVARCHAR(50),
    @cilj                   NVARCHAR(20),
    @broj_treninga_nedeljno INT,
    @trener                 INT,
    @stavke                 impl.StavkaTrTip READONLY
WITH ENCRYPTION,
     EXECUTE AS 'Andjela'
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.PromeniTreningSaStavkama
        @id, @naziv, @cilj, @broj_treninga_nedeljno, @trener, @stavke;
END;
GO

-- =====================================================
-- 4. api_trener.ObrisiTrening  [UNAPREDJENA]
-- =====================================================
CREATE OR ALTER PROCEDURE api_trener.ObrisiTrening
    @id_tr INT
WITH ENCRYPTION,
     EXECUTE AS 'Andjela'
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.ObrisiTrening @id_tr;
END;
GO

-- =====================================================
-- 5. api_trener.RegistrujKorisnika  [UNAPREDJENA]
-- =====================================================
CREATE OR ALTER PROCEDURE api_trener.RegistrujKorisnika
    @ime            NVARCHAR(30),
    @prezime        NVARCHAR(30),
    @email          NVARCHAR(50),
    @uloga          NVARCHAR(10),
    @korisnicko_ime NVARCHAR(20),
    @lozinka        NVARCHAR(15)
WITH ENCRYPTION,
     EXECUTE AS 'Andjela'
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.DodajKorisnika
        @ime, @prezime, @email, @uloga, @korisnicko_ime, @lozinka;
END;
GO

-- =====================================================
-- 6. api_trener.PrijavaKorisnika  [UNAPREDJENA]
-- =====================================================
CREATE OR ALTER PROCEDURE api_trener.PrijavaKorisnika
    @korisnickoIme NVARCHAR(20),
    @lozinka       NVARCHAR(15)
WITH ENCRYPTION,
     EXECUTE AS 'Andjela'
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM spec.LoginKorisnik(@korisnickoIme, @lozinka);
END;
GO

-- =====================================================
-- GRANT EXECUTE
-- Daje pravo DbTrenerApp roli da poziva api_trener
-- procedure bez direktnog pristupa nizim slojevima.
-- =====================================================
GRANT EXECUTE ON api_trener.KreirajVezbu       TO DbTrenerApp;
GRANT EXECUTE ON api_trener.KreirajTrening     TO DbTrenerApp;
GRANT EXECUTE ON api_trener.IzmeniTrening      TO DbTrenerApp;
GRANT EXECUTE ON api_trener.ObrisiTrening      TO DbTrenerApp;
GRANT EXECUTE ON api_trener.RegistrujKorisnika TO DbTrenerApp;
GRANT EXECUTE ON api_trener.PrijavaKorisnika   TO DbTrenerApp;
GO

GRANT SELECT ON api_trener.KORISNIK         TO DbTrenerApp;
GRANT SELECT ON api_trener.TRENING          TO DbTrenerApp;
GRANT SELECT ON api_trener.PRACENJE         TO DbTrenerApp;
GRANT SELECT ON api_trener.STAVKA_TRENINGA  TO DbTrenerApp;
GRANT SELECT ON api_trener.VEZBA            TO DbTrenerApp;
GO

-- =====================================================
-- TESTOVI
-- =====================================================

-- Test 1: Provera da procedure postoje sa EXECUTE AS
PRINT N'Test 1: Provera EXECUTE AS na api_trener procedurama';
SELECT
     p.name                  AS naziv_procedure
    ,m.execute_as_principal_id
    ,dp.name                 AS execute_as_korisnik
FROM sys.procedures p
JOIN sys.sql_modules m ON m.object_id = p.object_id
LEFT JOIN sys.database_principals dp
    ON dp.principal_id = m.execute_as_principal_id
WHERE SCHEMA_NAME(p.schema_id) = 'api_trener'
ORDER BY p.name;
GO

-- Test 2: Provera GRANT EXECUTE na DbTrenerApp
PRINT N'Test 2: Provera prava DbTrenerApp role';
SELECT
     dp.name    AS objekat
    ,rp.name    AS rola
    ,pe.permission_name AS pravo
FROM sys.database_permissions pe
JOIN sys.objects dp ON dp.object_id = pe.major_id
JOIN sys.database_principals rp ON rp.principal_id = pe.grantee_principal_id
WHERE rp.name = 'DbTrenerApp'
  AND SCHEMA_NAME(dp.schema_id) = 'api_trener'
ORDER BY dp.name;
GO

PRINT '------------------------------------------------------------------';
PRINT N' api_trener EXECUTE AS i GRANT EXECUTE su postavljeni - ' + FORMAT(GETDATE(), '', 'sr-Latn-RS');
PRINT '------------------------------------------------------------------';
GO