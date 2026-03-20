/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ApiTrenerStavkaTreninga.sql
**  AUTOR:      Andrijana (DbApiDeveloper)
**  NAPOMENA:   Pokrenuti nakon SpecVwStavkaTreninga.sql
*/
USE [treninzi];
GO
CREATE OR ALTER VIEW api_trener.STAVKA_TRENINGA
WITH ENCRYPTION
AS
    SELECT * FROM spec.vw_STAVKA_TRENINGA;
GO
SELECT * FROM api_trener.STAVKA_TRENINGA ORDER BY id_trening, rb;
GO
PRINT N' api_trener.STAVKA_TRENINGA je kreiran'; 
GO