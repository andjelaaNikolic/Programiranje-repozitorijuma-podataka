/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ImplVwPracenje.sql
**  OPIS:       Bazni pogled impl.vwPracenje.
**              Kolone su imenovane tako da odgovaraju
**              onome sto Broker ocekuje u reader-u,
**              pa funkcije mogu koristiti SELECT *.
**  AUTOR:      Andjela (DbDeveloper)
**  NAPOMENA:   Pokrenuti nakon 02_KreiranjeTabela.sql
*/

USE [treninzi];
GO

CREATE OR ALTER VIEW impl.vwPracenje
AS
    SELECT
         p.id_klijent               AS id_klijent
        ,k.id                       AS KorisnikId
        ,k.ime                      AS ime
        ,k.prezime                  AS prezime
        ,k.email                    AS email
        ,p.id_trening               AS id_trening
        ,t.id                       AS TreningId
        ,t.naziv                    AS naziv
        ,t.cilj                     AS cilj
        ,t.broj_treninga_nedeljno   AS broj_treninga_nedeljno
        ,t.trener                   AS trener
        ,p.datum_pocetka            AS datum_pocetka
        ,p.cilj_broj_treninga       AS cilj_broj_treninga
    FROM impl.pracenje AS p
    JOIN impl.korisnik AS k ON k.id = p.id_klijent
    JOIN impl.trening  AS t ON t.id = p.id_trening;
GO

-- Test
SELECT * FROM impl.vwPracenje ORDER BY id_klijent, id_trening;
GO

PRINT '------------------------------------------------------------------';
PRINT N' impl.vwPracenje je kreiran - ' + FORMAT(GETDATE(), '', 'sr-Latn-RS');
PRINT '------------------------------------------------------------------';
GO