/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ApiKlijentTrening.sql
**  AUTOR:      Danilo (DbApiDeveloper)
**  NAPOMENA:   Pokrenuti nakon SpecVwTrening.sql
*/
USE [treninzi];
GO
CREATE OR ALTER VIEW api_klijent.TRENING
WITH ENCRYPTION
AS
    SELECT [Treninzi_JsonDoc] = (
        SELECT
             t.id_trening, t.naziv_trening, t.cilj
            ,t.broj_treninga_nedeljno, t.trener_ime, t.trener_prezime
            ,[Stavke] = (
                SELECT s.rb_stavke, s.broj_ponavljanja, s.broj_serija,
                       s.trajanje, s.naziv_vezba, s.misicna_grupa
                FROM spec.vw_TRENING AS s
                WHERE s.id_trening = t.id_trening
                  AND s.rb_stavke IS NOT NULL
                ORDER BY s.rb_stavke
                FOR JSON PATH
            )
        FROM (
            SELECT DISTINCT id_trening, naziv_trening, cilj,
                   broj_treninga_nedeljno, id_trener,
                   trener_ime, trener_prezime
            FROM spec.vw_TRENING
        ) AS t
        ORDER BY t.id_trening
        FOR JSON PATH, ROOT(N'Treninzi')
    );
GO
SELECT * FROM api_klijent.TRENING;
GO
PRINT N' api_klijent.TRENING je kreiran'; 
GO