/*
**  PROJEKAT:   PRP - Programiranje repozitorijuma podataka
**              Pracenje treninga
**  DATOTEKA:   00_Master.sql
**  OPIS:       Master skript za pokretanje celog projekta.
*/

-- =====================================================
-- 1. Kreiranje baze i korisnika
-- =====================================================
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\KreiranjeBaze\KreiranjeBaze.sql"

-- =====================================================
-- 2. Kreiranje tabela
-- =====================================================
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\impl\KreiranjeTabela.sql"

-- =====================================================
-- 3. Demo podaci
-- =====================================================
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\DemoPodaci\DemoPodaci.sql"

-- =====================================================
-- 4. impl — pogledi
-- =====================================================
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\impl\Implvwkorisnik.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\impl\Implvwvezba.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\impl\Implvwtrening.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\impl\Implvwpracenje.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\impl\Implvwstavkatreninga.sql"

-- =====================================================
-- 5. impl — funkcije
-- =====================================================
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\impl\ImplFunkcije.sql"

-- =====================================================
-- 6. impl — trigeri
-- =====================================================
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\impl\ImplTrigeri.sql"

-- =====================================================
-- 7. impl — procedure KORISNIK
-- =====================================================
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\impl\ImplProcedureKorisnik.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\impl\ImplProcedureRefactoringKorisnik.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\impl\ImplProcedureImprovementKorisnik.sql"

-- =====================================================
-- 8. impl — procedure VEZBA
-- =====================================================
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\impl\ImplProcedureVezba.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\impl\ImplProcedureRefactoringVezba.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\impl\ImplProcedureImprovementVezba.sql"

-- =====================================================
-- 9. impl — procedure TRENING
-- =====================================================
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\impl\ImplProcedureTrening.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\impl\ImplProcedureRefactoringTrening.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\impl\ImplProcedureImprovementTrening.sql"

-- =====================================================
-- 10. impl — procedure PRACENJE
-- =====================================================
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\impl\ImplProcedurePracenje.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\impl\ImplProcedureRefactoringPracenje.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\impl\ImplProcedureImprovementPracenje.sql"

-- =====================================================
-- 11. spec — sinonimi i pogledi
-- =====================================================
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\Spec\Spec.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\Spec\Specvwkorisnik.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\Spec\Specvwvezba.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\Spec\Specvwtrening.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\Spec\Specvwpracenje.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\Spec\Specvwstavkatreninga.sql"

-- =====================================================
-- 12. api_trener
-- =====================================================
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\ApiTrener\ApiTrener.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\ApiTrener\ApiTrenerKorisnik.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\ApiTrener\Apitrenervezba.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\ApiTrener\Apitrenertrening.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\ApiTrener\Apitrenerpracenje.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\ApiTrener\Apitrenerstavkatreninga.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\ApiTrener\Apitrenerexecuteas.sql"

-- =====================================================
-- 13. api_klijent
-- =====================================================
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\ApiKlijent\ApiKlijent.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\ApiKlijent\Apiklijentkorisnik.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\ApiKlijent\Apiklijentvezba.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\ApiKlijent\Apiklijenttrening.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\ApiKlijent\Apiklijentpracenje.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\ApiKlijent\Apiklijentstavkatreninga.sql"
:r "C:\Users\Ljilja\OneDrive\Desktop\TreninziProjekat\ApiKlijent\Apiklijentexecuteas.sql"

PRINT '================================================================';
PRINT N' TreninziProjekat — svi objekti su kreirani uspesno!';
PRINT '================================================================';
GO
