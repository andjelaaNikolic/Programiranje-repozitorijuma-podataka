/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ApiTrenerTrening.sql
**  AUTOR:      Andrijana (DbApiDeveloper)
**  NAPOMENA:   Pokrenuti nakon SpecVwTrening.sql
*/
USE [treninzi];
GO
CREATE OR ALTER VIEW api_trener.TRENING
WITH ENCRYPTION
AS
    SELECT * FROM spec.vw_TRENING;
GO
SELECT * FROM api_trener.TRENING ORDER BY id_trening, rb_stavke;
GO
PRINT N' api_trener.TRENING je kreiran'; 
GO