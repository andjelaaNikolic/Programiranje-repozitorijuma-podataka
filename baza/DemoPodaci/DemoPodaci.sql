/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   03_DemoPodaci.sql
**  OPIS:       Unos inicijalnih (demo) podataka u tabele.
**  AUTOR:      Andjela (DbDeveloper)
**  NAPOMENA:   Pokrenuti nakon 02_KreiranjeTabela.sql
*/

USE [treninzi];
GO

-- =====================================================
-- 1. Korisnici
-- =====================================================
SET IDENTITY_INSERT impl.korisnik ON;
INSERT INTO impl.korisnik (id, ime, prezime, email, uloga, korisnicko_ime, lozinka) VALUES
    (1,  N'Andjela',   N'Nikolic',       N'andjelanikolic@gmail.com',  N'trener',  N'andjelanikolic', N'andjelanikolic'),
    (2,  N'Andrijana', N'Opacic',        N'andrijanaopacic@gmail.com', N'klijent', N'andrijanaopacic', N'andrijanaopacic'),
    (15, N'Danilo',    N'Nikolic',       N'danilo@gmail.com',          N'trener',  N'danilo123',       N'danilo123'),
    (16, N'Mara',      N'Maric',         N'maram@gmail.com',           N'klijent', N'maramaric',       N'maramaric'),
    (17, N'Tijana',    N'Milosavljevic', N'ticam@gmail.com',           N'klijent', N'tijana',          N'tijanamilos'),
    (18, N'Lana',      N'Spasic',        N'lanas@gmail.com',           N'trener',  N'lanas',           N'lanaspasic'),
    (19, N'Sasa',      N'Lazarevic',     N'slazar@fon.rs',             N'trener',  N'lepi_sale',       N'fon123456');
SET IDENTITY_INSERT impl.korisnik OFF;
GO

-- =====================================================
-- 2. Vezbe (natklasa)
-- =====================================================
SET IDENTITY_INSERT impl.vezba ON;
INSERT INTO impl.vezba (id, naziv, misicna_grupa) VALUES
    (1,  N'Deadlift',            N'le?a'),
    (2,  N'Veslanje',            N'le?a'),
    (3,  N'Sklek',               N'triceps'),
    (5,  N'Crunches',            N'trbušnjaci'),
    (7,  N'Tr?anje',             N'kvadricepsi'),
    (8,  N'Biciklizam',          N'kvadricepsi'),
    (9,  N'Cucanj',              N'noge'),
    (13, N'Iskorak unazad',      N'noge'),
    (14, N'Plank',               N'celo telo'),
    (15, N'Burpees',             N'celo telo'),
    (17, N'Jumping jacks',       N'celo telo'),
    (20, N'Zgib',                N'torzo'),
    (25, N'Le?njaci',           N'le?a'),
    (26, N'Hodanje',             N'celo telo'),
    (27, N'Mountain climbers',   N'celo telo'),
    (28, N'Benc pres',           N'torzo'),
    (29, N'Plivanje',            N'celo telo'),
    (30, N'Preskakanje vija?e',  N'celo telo');
SET IDENTITY_INSERT impl.vezba OFF;
GO

-- =====================================================
-- 3. Vezbe snage (potklasa)
-- =====================================================
INSERT INTO impl.snaga (id, tip_opterecenja, oprema) VALUES
    (1,  N'tegovi',          0),
    (2,  N'masina',          1),
    (3,  N'sopstvenaTezina', 0),
    (5,  N'sopstvenaTezina', 0),
    (9,  N'sopstvenaTezina', 0),
    (13, N'tegovi',          1),
    (14, N'sopstvenaTezina', 0),
    (20, N'sopstvenaTezina', 1),
    (25, N'sopstvenaTezina', 0),
    (28, N'tegovi',          1);
GO

-- =====================================================
-- 4. Kardio vezbe (potklasa)
-- =====================================================
INSERT INTO impl.kardio (id, intervalni, intenzitet, prostor) VALUES
    (7,  1, N'visok',   N'otvoren'),
    (8,  0, N'srednji', N'otvoren'),
    (15, 0, N'visok',   N'zatvoren'),
    (17, 1, N'nizak',   N'otvoren'),
    (26, 1, N'nizak',   N'otvoren'),
    (27, 0, N'visok',   N'zatvoren'),
    (29, 0, N'visok',   N'zatvoren'),
    (30, 0, N'srednji', N'otvoren');
GO

-- =====================================================
-- 5. Treninzi
-- =====================================================
SET IDENTITY_INSERT impl.trening ON;
INSERT INTO impl.trening (id, naziv, cilj, broj_treninga_nedeljno, trener) VALUES
    (12, N'Trening za kondiciju',     N'kondicija',   3, 1),
    (13, N'Trening za mrsavljenje',   N'mrsavljenje', 4, 1),
    (14, N'Mrsavljenje za pocetnike', N'mrsavljenje', 3, 1),
    (18, N'Trening za ruke i ledja',  N'snaga',       2, 1),
    (19, N'Prp',                      N'snaga',       2, 19),
    (23, N'Trening proba',            N'kondicija',   2, 1),
    (24, N'Trening kondicije',        N'kondicija',   2, 1);
SET IDENTITY_INSERT impl.trening OFF;
GO

-- =====================================================
-- 6. Stavke treninga
-- =====================================================
INSERT INTO impl.stavka_treninga (rb, id_trening, broj_ponavljanja, broj_serija, trajanje, id_vezba) VALUES
    (1, 13, 8,  4, 0,  5),  (1, 14, 0,  0, 20, 7),
    (1, 18, 10, 4, 0,  20), (1, 19, 0,  3, 1,  14),
    (1, 23, 0,  2, 60, 29), (1, 24, 0,  3, 10, 7),
    (2, 12, 0,  4, 40, 8),  (2, 13, 8,  3, 0,  9),
    (2, 14, 10, 3, 0,  15), (2, 18, 0,  3, 1,  14),
    (2, 19, 15, 3, 0,  3),  (2, 24, 0,  3, 1,  14),
    (3, 12, 8,  3, 0,  5),  (3, 13, 10, 4, 0,  3),
    (3, 14, 10, 3, 0,  25), (3, 18, 10, 3, 0,  25),
    (3, 24, 0,  3, 1,  17), (4, 12, 8,  3, 0,  13),
    (4, 14, 10, 3, 0,  5),  (4, 18, 5,  3, 0,  28),
    (4, 24, 5,  3, 0,  15);
GO

-- =====================================================
-- 7. Pracenja
-- =====================================================
INSERT INTO impl.pracenje (id_klijent, id_trening, datum_pocetka, cilj_broj_treninga) VALUES
    (2, 12, CAST(N'2026-05-05' AS DATE), 5),
    (2, 13, CAST(N'2026-03-18' AS DATE), 2);
GO

PRINT '------------------------------------------------------------------';
PRINT N' Demo podaci su uneseni';
PRINT '------------------------------------------------------------------';
GO
