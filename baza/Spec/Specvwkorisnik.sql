USE [treninzi];
GO

CREATE OR ALTER VIEW spec.vw_KORISNIK
WITH ENCRYPTION
AS
    SELECT id, ime, prezime, email, uloga, korisnicko_ime
    FROM impl.vwKorisnik;
GO

SELECT * FROM spec.vw_KORISNIK ORDER BY id;
GO

PRINT N' spec.vw_KORISNIK je kreiran';
GO