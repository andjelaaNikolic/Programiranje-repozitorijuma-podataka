/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   05a_ImplTriggeri.sql
**  OPIS:       Kreiranje AFTER triggera za audit logovanje.
**              Svaka promena (INS/UPD/DEL) na aplikacionim
**              tabelama se automatski biljezi u odgovarajucu
**              log tabelu.
**              Triggeri koriste pseudo-tabele INSERTED i DELETED:
**                - INSERT: samo INSERTED ima podatke
**                - DELETE: samo DELETED ima podatke
**                - UPDATE: oba INSERTED (novi) i DELETED (stari)
**  AUTOR:      Andjela (DbDeveloper)
**  NAPOMENA:   Pokrenuti nakon 05_ImplProcedure.sql
*/

USE [treninzi];
GO

-- =====================================================
-- 1. Trigger za impl.korisnik
-- =====================================================

-- trg: impl.trg_korisnik_AID
-- Opis: AFTER INSERT, UPDATE, DELETE na impl.korisnik
--       Biljezi promene u impl.tblKorisnikLog
CREATE TRIGGER impl.trg_korisnik_AID
ON impl.korisnik
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- INSERT
    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.tblKorisnikLog
            (ActionType, New_Id, New_Ime, New_Prezime, New_Email, New_Uloga, New_KorisnickoIme)
        SELECT
            'INS', i.id, i.ime, i.prezime, i.email, i.uloga, i.korisnicko_ime
        FROM inserted i;
        RETURN;
    END;

    -- DELETE
    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO impl.tblKorisnikLog
            (ActionType, Old_Id, Old_Ime, Old_Prezime, Old_Email, Old_Uloga, Old_KorisnickoIme)
        SELECT
            'DEL', d.id, d.ime, d.prezime, d.email, d.uloga, d.korisnicko_ime
        FROM deleted d;
        RETURN;
    END;

    -- UPDATE
    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.tblKorisnikLog
            (ActionType,
             Old_Id, New_Id,
             Old_Ime, New_Ime,
             Old_Prezime, New_Prezime,
             Old_Email, New_Email,
             Old_Uloga, New_Uloga,
             Old_KorisnickoIme, New_KorisnickoIme)
        SELECT
            'UPD',
            d.id, i.id,
            d.ime, i.ime,
            d.prezime, i.prezime,
            d.email, i.email,
            d.uloga, i.uloga,
            d.korisnicko_ime, i.korisnicko_ime
        FROM inserted i
        JOIN deleted  d ON i.id = d.id;
        RETURN;
    END;
END;
GO

-- =====================================================
-- 2. Trigger za impl.vezba
-- =====================================================

-- trg: impl.trg_vezba_AID
-- Opis: AFTER INSERT, UPDATE, DELETE na impl.vezba
CREATE TRIGGER impl.trg_vezba_AID
ON impl.vezba
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.tblVezbaLog
            (ActionType, New_Id, New_Naziv, New_MisicnaGrupa)
        SELECT 'INS', i.id, i.naziv, i.misicna_grupa
        FROM inserted i;
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO impl.tblVezbaLog
            (ActionType, Old_Id, Old_Naziv, Old_MisicnaGrupa)
        SELECT 'DEL', d.id, d.naziv, d.misicna_grupa
        FROM deleted d;
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.tblVezbaLog
            (ActionType,
             Old_Id, New_Id,
             Old_Naziv, New_Naziv,
             Old_MisicnaGrupa, New_MisicnaGrupa)
        SELECT
            'UPD',
            d.id, i.id,
            d.naziv, i.naziv,
            d.misicna_grupa, i.misicna_grupa
        FROM inserted i
        JOIN deleted  d ON i.id = d.id;
        RETURN;
    END;
END;
GO

-- =====================================================
-- 3. Trigger za impl.trening
-- =====================================================

-- trg: impl.trg_trening_AID
-- Opis: AFTER INSERT, UPDATE, DELETE na impl.trening
CREATE TRIGGER impl.trg_trening_AID
ON impl.trening
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.tblTreningLog
            (ActionType, New_Id, New_Naziv, New_Cilj, New_BrojTreningaNedeljno, New_Trener)
        SELECT 'INS', i.id, i.naziv, i.cilj, i.broj_treninga_nedeljno, i.trener
        FROM inserted i;
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO impl.tblTreningLog
            (ActionType, Old_Id, Old_Naziv, Old_Cilj, Old_BrojTreningaNedeljno, Old_Trener)
        SELECT 'DEL', d.id, d.naziv, d.cilj, d.broj_treninga_nedeljno, d.trener
        FROM deleted d;
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.tblTreningLog
            (ActionType,
             Old_Id, New_Id,
             Old_Naziv, New_Naziv,
             Old_Cilj, New_Cilj,
             Old_BrojTreningaNedeljno, New_BrojTreningaNedeljno,
             Old_Trener, New_Trener)
        SELECT
            'UPD',
            d.id, i.id,
            d.naziv, i.naziv,
            d.cilj, i.cilj,
            d.broj_treninga_nedeljno, i.broj_treninga_nedeljno,
            d.trener, i.trener
        FROM inserted i
        JOIN deleted  d ON i.id = d.id;
        RETURN;
    END;
END;
GO

-- =====================================================
-- 4. Trigger za impl.stavka_treninga
-- =====================================================

-- trg: impl.trg_stavka_treninga_AID
-- Opis: AFTER INSERT, UPDATE, DELETE na impl.stavka_treninga
CREATE TRIGGER impl.trg_stavka_treninga_AID
ON impl.stavka_treninga
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.tblStavkaTreningaLog
            (ActionType, New_Rb, New_IdTrening, New_BrojPonavljanja,
             New_BrojSerija, New_Trajanje, New_IdVezba)
        SELECT 'INS', i.rb, i.id_trening, i.broj_ponavljanja,
               i.broj_serija, i.trajanje, i.id_vezba
        FROM inserted i;
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO impl.tblStavkaTreningaLog
            (ActionType, Old_Rb, Old_IdTrening, Old_BrojPonavljanja,
             Old_BrojSerija, Old_Trajanje, Old_IdVezba)
        SELECT 'DEL', d.rb, d.id_trening, d.broj_ponavljanja,
               d.broj_serija, d.trajanje, d.id_vezba
        FROM deleted d;
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.tblStavkaTreningaLog
            (ActionType,
             Old_Rb, New_Rb,
             Old_IdTrening, New_IdTrening,
             Old_BrojPonavljanja, New_BrojPonavljanja,
             Old_BrojSerija, New_BrojSerija,
             Old_Trajanje, New_Trajanje,
             Old_IdVezba, New_IdVezba)
        SELECT
            'UPD',
            d.rb, i.rb,
            d.id_trening, i.id_trening,
            d.broj_ponavljanja, i.broj_ponavljanja,
            d.broj_serija, i.broj_serija,
            d.trajanje, i.trajanje,
            d.id_vezba, i.id_vezba
        FROM inserted i
        JOIN deleted  d ON i.rb = d.rb AND i.id_trening = d.id_trening;
        RETURN;
    END;
END;
GO

-- =====================================================
-- 5. Trigger za impl.pracenje
-- =====================================================

-- trg: impl.trg_pracenje_AID
-- Opis: AFTER INSERT, UPDATE, DELETE na impl.pracenje
CREATE TRIGGER impl.trg_pracenje_AID
ON impl.pracenje
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.tblPracenjeLog
            (ActionType, New_IdKlijent, New_IdTrening,
             New_DatumPocetka, New_CiljBrojTreninga)
        SELECT 'INS', i.id_klijent, i.id_trening,
               i.datum_pocetka, i.cilj_broj_treninga
        FROM inserted i;
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO impl.tblPracenjeLog
            (ActionType, Old_IdKlijent, Old_IdTrening,
             Old_DatumPocetka, Old_CiljBrojTreninga)
        SELECT 'DEL', d.id_klijent, d.id_trening,
               d.datum_pocetka, d.cilj_broj_treninga
        FROM deleted d;
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO impl.tblPracenjeLog
            (ActionType,
             Old_IdKlijent, New_IdKlijent,
             Old_IdTrening, New_IdTrening,
             Old_DatumPocetka, New_DatumPocetka,
             Old_CiljBrojTreninga, New_CiljBrojTreninga)
        SELECT
            'UPD',
            d.id_klijent, i.id_klijent,
            d.id_trening, i.id_trening,
            d.datum_pocetka, i.datum_pocetka,
            d.cilj_broj_treninga, i.cilj_broj_treninga
        FROM inserted i
        JOIN deleted  d ON i.id_klijent = d.id_klijent
                       AND i.id_trening = d.id_trening;
        RETURN;
    END;
END;
GO

PRINT '------------------------------------------------------------------';
PRINT N' impl triggeri (trg) su kreirani';
PRINT '------------------------------------------------------------------';
GO
