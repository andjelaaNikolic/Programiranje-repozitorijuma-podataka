/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ApiKlijentPracenje.sql
**  AUTOR:      Danilo (DbApiDeveloper)
**  NAPOMENA:   Pokrenuti nakon SpecVwPracenje.sql
*/
USE [treninzi];
GO
CREATE OR ALTER VIEW api_klijent.PRACENJE
WITH ENCRYPTION
AS
    SELECT [Pracenja_JsonDoc] = (
        SELECT ime, prezime, email, naziv, cilj,
               datum_pocetka, cilj_broj_treninga
        FROM spec.vw_PRACENJE
        ORDER BY ime, naziv
        FOR JSON PATH, ROOT(N'Pracenja')
    );
GO
SELECT * FROM api_klijent.PRACENJE;
GO
PRINT N' api_klijent.PRACENJE je kreiran'; 
GO