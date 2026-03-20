/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   02_KreiranjeTabela.sql
**  OPIS:       Kreiranje svih tabela u semi impl, TVP tipova,
**              log tabele i tabele kataloga gresaka.
**  AUTOR:      Andjela (DbDeveloper)
**  NAPOMENA:   Pokrenuti nakon 01_KreiranjeBaze.sql
*/

USE [treninzi];
GO

-- =====================================================
-- 1. Aplikacione tabele
-- =====================================================

-- tbl: impl.korisnik
CREATE TABLE impl.korisnik (
    id               INT           IDENTITY(1,1) NOT NULL,
    ime              NVARCHAR(30)  NOT NULL,
    prezime          NVARCHAR(30)  NOT NULL,
    email            NVARCHAR(50)  NOT NULL,
    uloga            NVARCHAR(10)  NOT NULL,
    korisnicko_ime   NVARCHAR(20)  NOT NULL,
    lozinka          NVARCHAR(15)  NOT NULL,
    CONSTRAINT PK_korisnik         PRIMARY KEY CLUSTERED (id ASC),
    CONSTRAINT UQ_korisnik_email   UNIQUE (email),
    CONSTRAINT UQ_korisnik_ime     UNIQUE (korisnicko_ime),
    CONSTRAINT CK_korisnik_uloga   CHECK (uloga IN ('trener', 'klijent')),
    CONSTRAINT CK_korisnik_lozinka CHECK (LEN(lozinka) BETWEEN 8 AND 15)
);
GO

-- tbl: impl.vezba
CREATE TABLE impl.vezba (
    id            INT           IDENTITY(1,1) NOT NULL,
    naziv         NVARCHAR(20)  NOT NULL,
    misicna_grupa NVARCHAR(50)  NOT NULL,
    CONSTRAINT PK_vezba       PRIMARY KEY CLUSTERED (id ASC),
    CONSTRAINT UQ_vezba_naziv UNIQUE (naziv)
);
GO

-- tbl: impl.kardio (IS-A veza sa impl.vezba)
CREATE TABLE impl.kardio (
    id         INT           NOT NULL,
    intervalni BIT           NOT NULL,
    intenzitet NVARCHAR(20)  NOT NULL,
    prostor    NVARCHAR(20)  NOT NULL,
    CONSTRAINT PK_kardio         PRIMARY KEY CLUSTERED (id ASC),
    CONSTRAINT FK_kardio_vezba   FOREIGN KEY (id) REFERENCES impl.vezba (id)
                                 ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT CK_kardio_intenz  CHECK (intenzitet IN ('nizak','srednji','visok','HIIT')),
    CONSTRAINT CK_kardio_prostor CHECK (prostor IN ('otvoren','zatvoren'))
);
GO

-- tbl: impl.snaga (IS-A veza sa impl.vezba)
CREATE TABLE impl.snaga (
    id              INT           NOT NULL,
    tip_opterecenja NVARCHAR(20)  NOT NULL,
    oprema          BIT           NOT NULL,
    CONSTRAINT PK_snaga       PRIMARY KEY CLUSTERED (id ASC),
    CONSTRAINT FK_snaga_vezba FOREIGN KEY (id) REFERENCES impl.vezba (id)
                              ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT CK_snaga_tip   CHECK (tip_opterecenja IN ('tegovi','masina','sopstvenaTezina'))
);
GO

-- tbl: impl.trening
CREATE TABLE impl.trening (
    id                     INT           IDENTITY(1,1) NOT NULL,
    naziv                  NVARCHAR(50)  NOT NULL,
    cilj                   NVARCHAR(20)  NOT NULL,
    broj_treninga_nedeljno INT           NOT NULL,
    trener                 INT           NOT NULL,
    CONSTRAINT PK_trening          PRIMARY KEY CLUSTERED (id ASC),
    CONSTRAINT UQ_trening_naziv    UNIQUE (naziv),
    CONSTRAINT FK_trening_korisnik FOREIGN KEY (trener)
                                   REFERENCES impl.korisnik (id) ON UPDATE CASCADE,                                 
    CONSTRAINT CK_trening_cilj     CHECK (cilj IN ('kondicija','snaga','mrsavljenje')),
    CONSTRAINT CK_trening_br_ned   CHECK (broj_treninga_nedeljno BETWEEN 1 AND 7)
);
GO



-- tbl: impl.stavka_treninga (slab objekat)
CREATE TABLE impl.stavka_treninga (
    rb               INT  NOT NULL,
    id_trening       INT  NOT NULL,
    broj_ponavljanja INT  NULL,
    broj_serija      INT  NULL,
    trajanje         INT  NULL,
    id_vezba         INT  NOT NULL,
    CONSTRAINT PK_stavka_treninga PRIMARY KEY CLUSTERED (rb ASC, id_trening ASC),
    CONSTRAINT FK_stavka_trening  FOREIGN KEY (id_trening)
                                  REFERENCES impl.trening (id) ON DELETE CASCADE,
    CONSTRAINT FK_stavka_vezba    FOREIGN KEY (id_vezba)
                                  REFERENCES impl.vezba (id) ON UPDATE CASCADE,
    CONSTRAINT CK_stavka_id_vezba CHECK (id_vezba > 0)
);
GO

-- tbl: impl.pracenje
CREATE TABLE impl.pracenje (
    id_klijent         INT   NOT NULL,
    id_trening         INT   NOT NULL,
    datum_pocetka      DATE  NOT NULL,
    cilj_broj_treninga INT   NULL,
    CONSTRAINT PK_pracenje         PRIMARY KEY CLUSTERED (id_klijent ASC, id_trening ASC),
    CONSTRAINT FK_pracenje_klijent FOREIGN KEY (id_klijent)
                                   REFERENCES impl.korisnik (id) ON UPDATE CASCADE,
    CONSTRAINT FK_pracenje_trening FOREIGN KEY (id_trening)
                                   REFERENCES impl.trening (id),
    CONSTRAINT CK_pracenje_cilj    CHECK (cilj_broj_treninga > 0)
);
GO

PRINT '------------------------------------------------------------------';
PRINT N' impl aplikacione tabele su kreirane';
PRINT '------------------------------------------------------------------';
GO

-- =====================================================
-- 2. Log tabele
-- =====================================================

-- tbl: impl.tblErrorLog
-- Opis: Upisuju se sve greške koje nastanu u procedurama
CREATE TABLE impl.tblErrorLog (
    LogId         INT           IDENTITY(1,1) NOT NULL
                  CONSTRAINT PK_tblErrorLog PRIMARY KEY,
    ErrorNumber   INT           NULL,
    ErrorMessage  NVARCHAR(400) NULL,
    ProcedureName NVARCHAR(256) NULL,
    LogDate       DATETIME2     DEFAULT SYSUTCDATETIME()
);
GO

PRINT '------------------------------------------------------------------';
PRINT N' impl log tabele su kreirane';
PRINT '------------------------------------------------------------------';
GO

-- =====================================================
-- 3. Katalog gresaka
-- =====================================================

-- tbl: impl.tblErrorCatalog
-- Opis: Centralizovani katalog svih gresaka
--       Nema magicnih brojeva ni hardkodovanih poruka u procedurama
--
-- Sema internih kodova (ErrorCode):
--   10xx - vrednosna ogranicenja KORISNIKA
--   20xx - vrednosna ogranicenja VEZBE
--   30xx - vrednosna ogranicenja TRENINGA
--   40xx - strukturna ogranicenja TRENINGA
--   50xx - vrednosna ogranicenja PRACENJA
--   90xx - sistemske greske
CREATE TABLE impl.tblErrorCatalog (
    ErrorCode    INT           NOT NULL
                 CONSTRAINT PK_tblErrorCatalog PRIMARY KEY,
    SqlThrowCode INT           NOT NULL
                 CONSTRAINT CHK_tblErrorCatalog_SqlThrowCode
                 CHECK (SqlThrowCode >= 50000),
    Severity     CHAR(5)       NOT NULL
                 CONSTRAINT CHK_tblErrorCatalog_Severity
                 CHECK (Severity IN ('Warn', 'Info', 'Error')),
    ErrorMessage NVARCHAR(400) NOT NULL
);
GO

-- Unos poruka u katalog
INSERT INTO impl.tblErrorCatalog (ErrorCode, SqlThrowCode, Severity, ErrorMessage)
VALUES
-- 10xx: Vrednosna ogranicenja KORISNIKA
 (1001, 51001, 'Warn',  N'Ime je obavezno.')
,(1002, 51002, 'Warn',  N'Prezime je obavezno.')
,(1003, 51003, 'Warn',  N'Korisnicko ime je obavezno.')
,(1004, 51004, 'Warn',  N'Email je obavezan.')
,(1005, 51005, 'Warn',  N'Lozinka mora imati izmedju 8 i 15 karaktera.')
,(1006, 51006, 'Info',  N'Korisnik sa datim ID ne postoji.')
,(1007, 51007, 'Warn',  N'Korisnicko ime vec postoji.')
,(1008, 51008, 'Warn',  N'Email vec postoji.')
,(1009, 51009, 'Error', N'Nije moguce azurirati korisnika.')

-- 20xx: Vrednosna ogranicenja VEZBE
,(2001, 52001, 'Warn', N'Naziv vezbe je obavezan.')
,(2002, 52002, 'Warn', N'Naziv misicne grupe je obavezan.')
,(2003, 52003, 'Info', N'Vezba sa tim nazivom vec postoji.')
,(2004, 52004, 'Warn', N'Vezba ne moze biti istovremeno kardio i snaga.')
,(2005, 52005, 'Warn', N'Vezba mora biti ili kardio ili snaga.')

-- 30xx: Vrednosna ogranicenja TRENINGA
,(3001, 53001, 'Warn', N'Naziv treninga je obavezan.')
,(3002, 53002, 'Info', N'Trening sa tim nazivom ve? postoji.')
,(3003, 53003, 'Warn', N'Broj treninga nedeljno mora biti izme?u 1 i 7.')
,(3004, 53004, 'Warn', N'Ista vežba ne sme biti više puta u treningu.')
,(3005, 53005, 'Warn', N'Redni broj stavke mora biti jedinstven.')

-- 40xx: Strukturna ogranicenja TRENINGA
,(4001, 54001, 'Info', N'Trener ne postoji.')
,(4002, 54002, 'Info', N'Ne može da se obriše trening jer postoje pra?enja za njega.')

-- 90xx: Sistemske greske
,(9001, 59001, 'Error', N'Unos nije uspeo - nijedan red nije ubacen.');
GO

PRINT '------------------------------------------------------------------';
PRINT N' impl katalog grešaka je kreiran';
PRINT '------------------------------------------------------------------';
GO

-- =====================================================
-- 4. Log tabele 
-- =====================================================

-- tbl: impl.tblKorisnikLog
-- Opis: Audit log - beleži INS/UPD/DEL promene nad impl.korisnik
CREATE TABLE impl.tblKorisnikLog (
    LogId              INT           IDENTITY(1,1) NOT NULL
                       CONSTRAINT PK_tblKorisnikLog PRIMARY KEY,
    ActionType         CHAR(3)       NOT NULL, -- 'INS', 'UPD', 'DEL'
    Old_Id             INT           NULL,
    New_Id             INT           NULL,
    Old_Ime            NVARCHAR(30)  NULL,
    New_Ime            NVARCHAR(30)  NULL,
    Old_Prezime        NVARCHAR(30)  NULL,
    New_Prezime        NVARCHAR(30)  NULL,
    Old_Email          NVARCHAR(50)  NULL,
    New_Email          NVARCHAR(50)  NULL,
    Old_Uloga          NVARCHAR(10)  NULL,
    New_Uloga          NVARCHAR(10)  NULL,
    Old_KorisnickoIme  NVARCHAR(20)  NULL,
    New_KorisnickoIme  NVARCHAR(20)  NULL,
    ChangedAt          DATETIME2     DEFAULT SYSUTCDATETIME(),
    ChangedBy          NVARCHAR(128) DEFAULT SUSER_SNAME()
);
GO

-- tbl: impl.tblVezbaLog
-- Opis: Audit log - beleži INS/UPD/DEL promene nad impl.vezba
CREATE TABLE impl.tblVezbaLog (
    LogId           INT           IDENTITY(1,1) NOT NULL
                    CONSTRAINT PK_tblVezbaLog PRIMARY KEY,
    ActionType      CHAR(3)       NOT NULL, -- 'INS', 'UPD', 'DEL'
    Old_Id          INT           NULL,
    New_Id          INT           NULL,
    Old_Naziv       NVARCHAR(20)  NULL,
    New_Naziv       NVARCHAR(20)  NULL,
    Old_MisicnaGrupa NVARCHAR(50) NULL,
    New_MisicnaGrupa NVARCHAR(50) NULL,
    ChangedAt       DATETIME2     DEFAULT SYSUTCDATETIME(),
    ChangedBy       NVARCHAR(128) DEFAULT SUSER_SNAME()
);
GO

-- tbl: impl.tblTreningLog
-- Opis: Audit log - beleži INS/UPD/DEL promene nad impl.trening
CREATE TABLE impl.tblTreningLog (
    LogId                    INT           IDENTITY(1,1) NOT NULL
                             CONSTRAINT PK_tblTreningLog PRIMARY KEY,
    ActionType               CHAR(3)       NOT NULL, -- 'INS', 'UPD', 'DEL'
    Old_Id                   INT           NULL,
    New_Id                   INT           NULL,
    Old_Naziv                NVARCHAR(50)  NULL,
    New_Naziv                NVARCHAR(50)  NULL,
    Old_Cilj                 NVARCHAR(20)  NULL,
    New_Cilj                 NVARCHAR(20)  NULL,
    Old_BrojTreningaNedeljno INT           NULL,
    New_BrojTreningaNedeljno INT           NULL,
    Old_Trener               INT           NULL,
    New_Trener               INT           NULL,
    ChangedAt                DATETIME2     DEFAULT SYSUTCDATETIME(),
    ChangedBy                NVARCHAR(128) DEFAULT SUSER_SNAME()
);
GO

-- tbl: impl.tblStavkaTreningaLog
-- Opis: Audit log - beleži INS/UPD/DEL promene nad impl.stavka_treninga
CREATE TABLE impl.tblStavkaTreningaLog (
    LogId                INT           IDENTITY(1,1) NOT NULL
                         CONSTRAINT PK_tblStavkaTreningaLog PRIMARY KEY,
    ActionType           CHAR(3)       NOT NULL, -- 'INS', 'UPD', 'DEL'
    Old_Rb               INT           NULL,
    New_Rb               INT           NULL,
    Old_IdTrening        INT           NULL,
    New_IdTrening        INT           NULL,
    Old_BrojPonavljanja  INT           NULL,
    New_BrojPonavljanja  INT           NULL,
    Old_BrojSerija       INT           NULL,
    New_BrojSerija       INT           NULL,
    Old_Trajanje         INT           NULL,
    New_Trajanje         INT           NULL,
    Old_IdVezba          INT           NULL,
    New_IdVezba          INT           NULL,
    ChangedAt            DATETIME2     DEFAULT SYSUTCDATETIME(),
    ChangedBy            NVARCHAR(128) DEFAULT SUSER_SNAME()
);
GO

-- tbl: impl.tblPracenjeLog
-- Opis: Audit log - biljezi INS/UPD/DEL promene nad impl.pracenje
CREATE TABLE impl.tblPracenjeLog (
    LogId                  INT           IDENTITY(1,1) NOT NULL
                           CONSTRAINT PK_tblPracenjeLog PRIMARY KEY,
    ActionType             CHAR(3)       NOT NULL, -- 'INS', 'UPD', 'DEL'
    Old_IdKlijent          INT           NULL,
    New_IdKlijent          INT           NULL,
    Old_IdTrening          INT           NULL,
    New_IdTrening          INT           NULL,
    Old_DatumPocetka       DATE          NULL,
    New_DatumPocetka       DATE          NULL,
    Old_CiljBrojTreninga   INT           NULL,
    New_CiljBrojTreninga   INT           NULL,
    ChangedAt              DATETIME2     DEFAULT SYSUTCDATETIME(),
    ChangedBy              NVARCHAR(128) DEFAULT SUSER_SNAME()
);
GO

PRINT '------------------------------------------------------------------';
PRINT N' impl audit log tabele su kreirane';
PRINT '------------------------------------------------------------------';
GO

-- =====================================================
-- 5. TVP tipovi
-- =====================================================

CREATE TYPE impl.StavkaTrTip AS TABLE (
    rb               INT  NULL,
    broj_ponavljanja INT  NULL,
    broj_serija      INT  NULL,
    trajanje         INT  NULL,
    id_vezba         INT  NULL
);
GO

CREATE TYPE impl.PracenjeTip AS TABLE (
    id_trening         INT      NULL,
    datum_pocetka      DATETIME NULL,
    cilj_broj_treninga INT      NULL
);
GO

PRINT '------------------------------------------------------------------';
PRINT N' impl TVP tipovi su kreirani';
PRINT '------------------------------------------------------------------';
GO
