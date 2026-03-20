/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pra?enje treninga
**  DATOTEKA:   06_Spec.sql
**  OPIS:       Kreiranje spec sheme - javni interfejs DB ADT.
**              Synonymi koji pokazuju na impl objekte.
**              DbApiDeveloper-i vide SAMO spec, ne impl direktno.
**  AUTOR:      Andjela (DbDeveloper)
**  NAPOMENA:   Pokrenuti nakon 05_ImplProcedure.sql
*/

USE [treninzi];
GO

-- =====================================================
-- Synonymi: spec -> impl (skalarne funkcije)
-- =====================================================
CREATE SYNONYM spec.PostojiEmail                FOR impl.PostojiEmail;
CREATE SYNONYM spec.PostojiEmail_ID             FOR impl.PostojiEmail_ID;
CREATE SYNONYM spec.PostojiKorisnickoIme        FOR impl.PostojiKorisnickoIme;
CREATE SYNONYM spec.PostojiKorisnickoIme_ID     FOR impl.PostojiKorisnickoIme_ID;
CREATE SYNONYM spec.PostojiTrening              FOR impl.PostojiTrening;
CREATE SYNONYM spec.PostojiTreningSaNazivom     FOR impl.PostojiTreningSaNazivom;
CREATE SYNONYM spec.PostojiVezba                FOR impl.PostojiVezba;
GO

-- =====================================================
-- Synonymi: spec -> impl (table-value funkcije)
-- =====================================================
CREATE SYNONYM spec.LoginKorisnik                   FOR impl.LoginKorisnik;
CREATE SYNONYM spec.VratiStavkeTreningaFnt          FOR impl.VratiStavkeTreningaFnt;
CREATE SYNONYM spec.VratiSveVezbe                   FOR impl.VratiSveVezbe;
CREATE SYNONYM spec.VratiKardioVezbe                FOR impl.VratiKardioVezbe;
CREATE SYNONYM spec.VratiVezbeSnage                 FOR impl.VratiVezbeSnage;
CREATE SYNONYM spec.VratiPracenjaZaKorisnika        FOR impl.VratiPracenjaZaKorisnika;
CREATE SYNONYM spec.ListaPracenjaTrening            FOR impl.ListaPracenjaTrening;
CREATE SYNONYM spec.ListaPracenjaTreningKlijent     FOR impl.ListaPracenjaTreningKlijent;
CREATE SYNONYM spec.VratiTreningeZaTrenera          FOR impl.VratiTreningeZaTrenera;
GO

-- =====================================================
-- Synonymi: spec -> impl (procedure)
-- =====================================================
CREATE SYNONYM spec.DodajKorisnika                  FOR impl.DodajKorisnika;
CREATE SYNONYM spec.PromeniKorisnika                FOR impl.PromeniKorisnika;
CREATE SYNONYM spec.KreirajVezbu                    FOR impl.KreirajVezbu;
CREATE SYNONYM spec.DodajTreningSaStavkama          FOR impl.DodajTreningSaStavkama;
CREATE SYNONYM spec.PromeniTreningSaStavkama        FOR impl.PromeniTreningSaStavkama;
CREATE SYNONYM spec.ObrisiTrening                   FOR impl.ObrisiTrening;
CREATE SYNONYM spec.PromeniPracenja                 FOR impl.PromeniPracenja;
CREATE SYNONYM spec.VratiStavkeTreninga             FOR impl.VratiStavkeTreninga;
CREATE SYNONYM spec.VratiTreninge                   FOR impl.VratiTreninge;
CREATE SYNONYM spec.DodajIliPromeniStavkuTreninga   FOR impl.DodajIliPromeniStavkuTreninga;
GO

-- =====================================================
-- fnt: spec.SviTrenizi
-- Opis: Svi planovi treninga - zajednicki za trenera i klijenta
-- =====================================================
ALTER FUNCTION spec.SviTreninzi ()
RETURNS TABLE AS RETURN
(
    SELECT DISTINCT
        id_trening          AS id,
        naziv_trening       AS naziv,
        cilj,
        broj_treninga_nedeljno,
        trener_ime,
        trener_prezime
    FROM impl.vwTrening
);

CREATE OR ALTER FUNCTION spec.VratiLozinku(@id INT)
RETURNS NVARCHAR(15)
AS
BEGIN
    DECLARE @lozinka NVARCHAR(15);
    SELECT @lozinka = lozinka 
    FROM impl.korisnik 
    WHERE id = @id;
    RETURN @lozinka;
END;
GO

PRINT '------------------------------------------------------------------';
PRINT N' spec shema (javni interfejs DB ADT) je kreirana';
PRINT '------------------------------------------------------------------';
GO
