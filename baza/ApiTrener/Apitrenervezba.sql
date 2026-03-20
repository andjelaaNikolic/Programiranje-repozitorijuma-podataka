/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ApiTrenerPracenje.sql
**  AUTOR:      Andrijana (DbApiDeveloper)
**  NAPOMENA:   Pokrenuti nakon SpecVwPracenje.sql
*/
USE [treninzi];
GO
CREATE OR ALTER VIEW api_trener.VEZBA
WITH ENCRYPTION
AS
    SELECT * FROM spec.vw_VEZBA;
GO

SELECT * FROM api_trener.VEZBA ORDER BY tip_vezbe, naziv;
GO

PRINT N' api_trener.VEZBA je kreiran';
GO