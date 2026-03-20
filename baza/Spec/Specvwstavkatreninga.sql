/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   SpecVwStavkaTreninga.sql
**  AUTOR:      Andjela (DbDeveloper)
**  NAPOMENA:   Pokrenuti nakon ImplVwStavkaTreninga.sql
*/
USE [treninzi];
GO
CREATE OR ALTER VIEW spec.vw_STAVKA_TRENINGA
WITH ENCRYPTION
AS
    SELECT rb, id_trening, naziv_trening, id_vezba,
           naziv, misicna_grupa,
           broj_ponavljanja, broj_serija, trajanje
    FROM impl.vwStavkaTreninga;
GO
SELECT * FROM spec.vw_STAVKA_TRENINGA ORDER BY id_trening, rb;
GO
PRINT N' spec.vw_STAVKA_TRENINGA je kreiran'; 
GO