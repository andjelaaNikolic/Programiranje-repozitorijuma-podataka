/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   ApiKlijentKorisnik.sql
**  AUTOR:      Danilo (DbApiDeveloper)
**  NAPOMENA:   Pokrenuti nakon SpecVwKorisnik.sql
*/
USE [treninzi];
GO
CREATE OR ALTER VIEW api_klijent.KORISNIK
WITH ENCRYPTION
AS
    SELECT [Treneri_JsonDoc] = (
        SELECT id, ime, prezime, email, korisnicko_ime
        FROM spec.vw_KORISNIK
        WHERE uloga = N'trener'
        ORDER BY prezime
        FOR JSON PATH, ROOT(N'Treneri')
    );
GO
SELECT * FROM api_klijent.KORISNIK;
GO
PRINT N' api_klijent.KORISNIK je kreiran'; 
GO