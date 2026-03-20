/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ApiTrenerPracenje.sql
**  AUTOR:      Andrijana (DbApiDeveloper)
**  NAPOMENA:   Pokrenuti nakon SpecVwPracenje.sql
*/
USE [treninzi];
GO
CREATE OR ALTER VIEW api_trener.PRACENJE
WITH ENCRYPTION
AS
    SELECT * FROM spec.vw_PRACENJE;
GO
SELECT * FROM api_trener.PRACENJE ORDER BY id_klijent;
GO
PRINT N' api_trener.PRACENJE je kreiran'; 
GO