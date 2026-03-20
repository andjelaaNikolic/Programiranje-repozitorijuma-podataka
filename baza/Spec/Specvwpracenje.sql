/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   SpecVwPracenje.sql
**  AUTOR:      Andjela (DbDeveloper)
**  NAPOMENA:   Pokrenuti nakon ImplVwPracenje.sql
*/
USE [treninzi];
GO
CREATE OR ALTER VIEW spec.vw_PRACENJE
WITH ENCRYPTION
AS
    SELECT id_klijent, KorisnikId, ime, prezime, email,
           id_trening, TreningId, naziv, cilj,
           broj_treninga_nedeljno, trener,
           datum_pocetka, cilj_broj_treninga
    FROM impl.vwPracenje;
GO
SELECT * FROM spec.vw_PRACENJE ORDER BY id_klijent;
GO
PRINT N' spec.vw_PRACENJE je kreiran'; 
GO