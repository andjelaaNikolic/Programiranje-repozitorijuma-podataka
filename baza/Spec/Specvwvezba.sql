/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   SpecVwVezba.sql
**  AUTOR:      Andjela (DbDeveloper)
**  NAPOMENA:   Pokrenuti nakon ImplVwVezba.sql
*/
USE [treninzi];
GO
CREATE OR ALTER VIEW spec.vw_VEZBA
WITH ENCRYPTION
AS
    SELECT id, naziv, misicna_grupa, tip_vezbe,
           intervalni, intenzitet, prostor,
           tip_opterecenja, oprema
    FROM impl.vwVezba;
GO
SELECT * FROM spec.vw_VEZBA ORDER BY tip_vezbe, naziv;
GO
PRINT N' spec.vw_VEZBA je kreiran'; 
GO