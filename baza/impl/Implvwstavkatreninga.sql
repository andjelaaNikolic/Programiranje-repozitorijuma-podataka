/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ImplVwStavkaTreninga.sql
**  OPIS:       Bazni pogled impl.vwStavkaTreninga.
**              Kolone su imenovane tako da odgovaraju
**              onome sto Broker ocekuje u reader-u,
**              pa funkcije mogu koristiti SELECT *.
**  AUTOR:      Andjela (DbDeveloper)
**  NAPOMENA:   Pokrenuti nakon 02_KreiranjeTabela.sql
*/

USE [treninzi];
GO

CREATE OR ALTER VIEW impl.vwStavkaTreninga
AS
    SELECT
         s.rb                   AS rb
        ,s.id_trening           AS id_trening
        ,t.naziv                AS naziv_trening
        ,s.id_vezba             AS id_vezba
        ,v.naziv                AS naziv
        ,v.misicna_grupa        AS misicna_grupa
        ,s.broj_ponavljanja     AS broj_ponavljanja
        ,s.broj_serija          AS broj_serija
        ,s.trajanje             AS trajanje
    FROM impl.stavka_treninga AS s
    JOIN impl.trening AS t ON t.id = s.id_trening
    JOIN impl.vezba   AS v ON v.id = s.id_vezba;
GO

-- Test
SELECT * FROM impl.vwStavkaTreninga ORDER BY id_trening, rb;
GO

PRINT '------------------------------------------------------------------';
PRINT N' impl.vwStavkaTreninga je kreiran - ' + FORMAT(GETDATE(), '', 'sr-Latn-RS');
PRINT '------------------------------------------------------------------';
GO