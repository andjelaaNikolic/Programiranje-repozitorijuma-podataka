/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ImplVwTrening.sql
**  OPIS:       Bazni pogled impl.vwTrening.
**              Kolone su imenovane tako da odgovaraju
**              onome sto Broker ocekuje u reader-u,
**              pa funkcije mogu koristiti SELECT *.
**  AUTOR:      Andjela (DbDeveloper)
**  NAPOMENA:   Pokrenuti nakon 02_KreiranjeTabela.sql
*/

USE [treninzi];
GO

CREATE OR ALTER VIEW impl.vwTrening
AS
    SELECT
         t.id                       AS id_trening
        ,t.naziv                    AS naziv_trening
        ,t.cilj                     AS cilj
        ,t.broj_treninga_nedeljno   AS broj_treninga_nedeljno
        ,t.trener                   AS id_trener
        ,k.ime                      AS trener_ime
        ,k.prezime                  AS trener_prezime
        ,k.email                    AS trener_email
        ,s.rb                       AS rb_stavke
        ,s.broj_ponavljanja         AS broj_ponavljanja
        ,s.broj_serija              AS broj_serija
        ,s.trajanje                 AS trajanje
        ,v.id                       AS id_vezba
        ,v.naziv                    AS naziv_vezba
        ,v.misicna_grupa            AS misicna_grupa
    FROM impl.trening AS t
    JOIN impl.korisnik AS k
        ON k.id = t.trener
    LEFT JOIN impl.stavka_treninga AS s
        ON s.id_trening = t.id
    LEFT JOIN impl.vezba AS v
        ON v.id = s.id_vezba;
GO

-- Test
SELECT * FROM impl.vwTrening ORDER BY id_trening, rb_stavke;
GO

PRINT '------------------------------------------------------------------';
PRINT N' impl.vwTrening je kreiran - ' + FORMAT(GETDATE(), '', 'sr-Latn-RS');
PRINT '------------------------------------------------------------------';
GO