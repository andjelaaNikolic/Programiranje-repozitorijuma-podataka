/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ApiTrenerKorisnik.sql
**  AUTOR:      Andrijana (DbApiDeveloper)
**  NAPOMENA:   Pokrenuti nakon SpecVwKorisnik.sql
*/
USE [treninzi];
GO
CREATE OR ALTER VIEW api_trener.KORISNIK
WITH ENCRYPTION
AS
    SELECT * FROM spec.vw_KORISNIK;
GO
SELECT * FROM api_trener.KORISNIK ORDER BY id;
GO
PRINT N' api_trener.KORISNIK je kreiran'; 
GO