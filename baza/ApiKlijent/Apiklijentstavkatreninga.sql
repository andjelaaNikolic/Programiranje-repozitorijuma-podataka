/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ApiKlijentStavkaTreninga.sql
**  AUTOR:      Danilo (DbApiDeveloper)
**  NAPOMENA:   Pokrenuti nakon SpecVwStavkaTreninga.sql
*/
USE [treninzi];
GO
CREATE OR ALTER VIEW api_klijent.STAVKA_TRENINGA
WITH ENCRYPTION
AS
    SELECT [StavkeTreninga_JsonDoc] = (
        SELECT
             t.naziv_trening
            ,[Stavke] = (
                SELECT s.rb, s.naziv, s.misicna_grupa,
                       s.broj_ponavljanja, s.broj_serija, s.trajanje
                FROM spec.vw_STAVKA_TRENINGA AS s
                WHERE s.naziv_trening = t.naziv_trening
                ORDER BY s.rb
                FOR JSON PATH
            )
        FROM (
            SELECT DISTINCT naziv_trening
            FROM spec.vw_STAVKA_TRENINGA
        ) AS t
        ORDER BY t.naziv_trening
        FOR JSON PATH, ROOT(N'StavkeTreninga')
    );
GO
SELECT * FROM api_klijent.STAVKA_TRENINGA;
GO
PRINT N' api_klijent.STAVKA_TRENINGA je kreiran'; 
GO