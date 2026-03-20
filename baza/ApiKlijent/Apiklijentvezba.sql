/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ApiKlijentVezba.sql
**  AUTOR:      Danilo (DbApiDeveloper)
**  NAPOMENA:   Pokrenuti nakon SpecVwVezba.sql
*/
USE [treninzi];
GO
CREATE OR ALTER VIEW api_klijent.VEZBA
WITH ENCRYPTION
AS
    SELECT [Vezbe_JsonDoc] = (
        SELECT id, naziv, misicna_grupa, tip_vezbe, intenzitet, prostor
        FROM spec.vw_VEZBA
        ORDER BY tip_vezbe, naziv
        FOR JSON PATH, ROOT(N'Vezbe')
    );
GO
SELECT * FROM api_klijent.VEZBA;
GO
PRINT N' api_klijent.VEZBA je kreiran'; 
GO