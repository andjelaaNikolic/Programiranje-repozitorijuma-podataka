/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ApiKlijentExecuteAs.sql
**  OPIS:       Unapredjenje api_klijent procedura sa
**              EXECUTE AS i GRANT EXECUTE.
**
**              Arhitekturni kontekst:
**                SOFTWARE
**                └── Application Klijent (User::Danilo)
**                    └── DB Solution [treninzi]
**                        ├── DB API
**                        │   └── api_klijent.*  ← ove procedure
**                        └── DB ADT
**                            └── spec.*  ← pozivaju
**
**              Bezbednost:
**                - WITH ENCRYPTION: skriva implementaciju
**                - EXECUTE AS 'Andjela': izvrsava se u
**                  kontekstu vlasnika impl/spec sloja;
**                  Danilo (pozivalac) ne mora direktno
**                  da pristupa nizim slojevima —
**                  princip minimalnih privilegija
**                - GRANT EXECUTE na DbKlijentApp roli
**  AUTOR:      Danilo (DbApiDeveloper)
**  NAPOMENA:   Pokrenuti nakon 08_ApiKlijent.sql
*/

USE [treninzi];
GO

-- =====================================================
-- 1. api_klijent.PrijavaKorisnika  [UNAPREDJENA]
-- =====================================================
CREATE OR ALTER PROCEDURE api_klijent.PrijavaKorisnika
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
-- 2. api_klijent.RegistrujKorisnika  [UNAPREDJENA]
-- =====================================================
CREATE OR ALTER PROCEDURE api_klijent.RegistrujKorisnika
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
-- 3. api_klijent.VratiSveTreninge  [UNAPREDJENA]
-- =====================================================
CREATE OR ALTER PROCEDURE api_klijent.VratiSveTreninge
WITH ENCRYPTION,
     EXECUTE AS 'Andjela'
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.VratiTreninge;
END;
GO

-- =====================================================
-- 4. api_klijent.AzurirajPracenja  [UNAPREDJENA]
-- =====================================================
CREATE OR ALTER PROCEDURE api_klijent.AzurirajPracenja
    @id_klijent INT,
    @NoviPodaci impl.PracenjeTip READONLY
WITH ENCRYPTION,
     EXECUTE AS 'Andjela'
AS
BEGIN
    SET NOCOUNT ON;
    EXEC spec.PromeniPracenja @id_klijent, @NoviPodaci;
END;
GO

-- =====================================================
-- GRANT EXECUTE
-- Daje pravo DbKlijentApp roli da poziva api_klijent
-- procedure bez direktnog pristupa nizim slojevima.
-- =====================================================
GRANT EXECUTE ON api_klijent.PrijavaKorisnika   TO DbKlijentApp;
GRANT EXECUTE ON api_klijent.RegistrujKorisnika TO DbKlijentApp;
GRANT EXECUTE ON api_klijent.VratiSveTreninge   TO DbKlijentApp;
GRANT EXECUTE ON api_klijent.AzurirajPracenja   TO DbKlijentApp;
GO

GRANT SELECT ON api_klijent.KORISNIK        TO DbKlijentApp;
GRANT SELECT ON api_klijent.TRENING         TO DbKlijentApp;
GRANT SELECT ON api_klijent.PRACENJE        TO DbKlijentApp;
GRANT SELECT ON api_klijent.STAVKA_TRENINGA TO DbKlijentApp;
GRANT SELECT ON api_klijent.VEZBA           TO DbKlijentApp;
GO
-- =====================================================
-- TESTOVI
-- =====================================================

-- Test 1: Provera da procedure postoje sa EXECUTE AS
PRINT N'Test 1: Provera EXECUTE AS na api_klijent procedurama';
SELECT
     p.name                  AS naziv_procedure
    ,m.execute_as_principal_id
    ,dp.name                 AS execute_as_korisnik
FROM sys.procedures p
JOIN sys.sql_modules m ON m.object_id = p.object_id
LEFT JOIN sys.database_principals dp
    ON dp.principal_id = m.execute_as_principal_id
WHERE SCHEMA_NAME(p.schema_id) = 'api_klijent'
ORDER BY p.name;
GO

-- Test 2: Provera GRANT EXECUTE na DbKlijentApp
PRINT N'Test 2: Provera prava DbKlijentApp role';
SELECT
     dp.name    AS objekat
    ,rp.name    AS rola
    ,pe.permission_name AS pravo
FROM sys.database_permissions pe
JOIN sys.objects dp ON dp.object_id = pe.major_id
JOIN sys.database_principals rp ON rp.principal_id = pe.grantee_principal_id
WHERE rp.name = 'DbKlijentApp'
  AND SCHEMA_NAME(dp.schema_id) = 'api_klijent'
ORDER BY dp.name;
GO

PRINT '------------------------------------------------------------------';
PRINT N' api_klijent EXECUTE AS i GRANT EXECUTE su postavljeni - ' + FORMAT(GETDATE(), '', 'sr-Latn-RS');
PRINT '------------------------------------------------------------------';
GO