/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   SpecVwTrening.sql
**  AUTOR:      Andjela (DbDeveloper)
**  NAPOMENA:   Pokrenuti nakon ImplVwTrening.sql
*/
USE [treninzi];
GO
CREATE OR ALTER VIEW spec.vw_TRENING
WITH ENCRYPTION
AS
    SELECT id_trening, naziv_trening, cilj, broj_treninga_nedeljno,
           id_trener, trener_ime, trener_prezime, trener_email,
           rb_stavke, broj_ponavljanja, broj_serija, trajanje,
           id_vezba, naziv_vezba, misicna_grupa
    FROM impl.vwTrening;
GO
SELECT * FROM spec.vw_TRENING ORDER BY id_trening, rb_stavke;
GO
PRINT N' spec.vw_TRENING je kreiran'; 
GO