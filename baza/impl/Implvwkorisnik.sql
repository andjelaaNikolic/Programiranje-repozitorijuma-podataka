/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ImplVwKorisnik.sql
**  OPIS:       Bazni pogled impl.vwKorisnik.
**              Privatni sloj (impl): sadrzi sve fizicke
**              kolone ukljucujuci i lozinku.
**              Lozinka je vidljiva samo u impl sloju.
**  AUTOR:      Andjela (DbDeveloper)
**  NAPOMENA:   Pokrenuti nakon 02_KreiranjeTabela.sql
*/

USE [treninzi];
GO

CREATE OR ALTER VIEW impl.vwKorisnik
AS
    SELECT
         k.id               AS id
        ,k.ime              AS ime
        ,k.prezime          AS prezime
        ,k.email            AS email
        ,k.uloga            AS uloga
        ,k.korisnicko_ime   AS korisnicko_ime
        ,k.lozinka          AS lozinka
    FROM impl.korisnik AS k;
GO

-- Test
SELECT * FROM impl.vwKorisnik ORDER BY id;
GO

PRINT '------------------------------------------------------------------';
PRINT N' impl.vwKorisnik je kreiran - ' + FORMAT(GETDATE(), '', 'sr-Latn-RS');
PRINT '------------------------------------------------------------------';
GO