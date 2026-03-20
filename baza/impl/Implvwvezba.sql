/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ImplVwVezba.sql
**  OPIS:       Bazni pogled impl.vwVezba.
**              Kolone su imenovane tako da odgovaraju
**              onome sto Broker ocekuje u reader-u,
**              pa funkcije mogu koristiti SELECT *.
**  AUTOR:      Andjela (DbDeveloper)
**  NAPOMENA:   Pokrenuti nakon 02_KreiranjeTabela.sql
*/

USE [treninzi];
GO

CREATE OR ALTER VIEW impl.vwVezba
AS
    SELECT
         v.id               AS id
        ,v.naziv            AS naziv
        ,v.misicna_grupa    AS misicna_grupa
        ,CASE
            WHEN k.id IS NOT NULL THEN N'kardio'
            WHEN s.id IS NOT NULL THEN N'snaga'
            ELSE NULL
         END                AS tip_vezbe
        ,k.intervalni       AS intervalni
        ,k.intenzitet       AS intenzitet
        ,k.prostor          AS prostor
        ,s.tip_opterecenja  AS tip_opterecenja
        ,s.oprema           AS oprema
    FROM impl.vezba AS v
    LEFT JOIN impl.kardio AS k ON k.id = v.id
    LEFT JOIN impl.snaga  AS s ON s.id = v.id;
GO

-- Test
SELECT * FROM impl.vwVezba ORDER BY tip_vezbe, naziv;
GO

PRINT '------------------------------------------------------------------';
PRINT N' impl.vwVezba je kreiran - ' + FORMAT(GETDATE(), '', 'sr-Latn-RS');
PRINT '------------------------------------------------------------------';
GO