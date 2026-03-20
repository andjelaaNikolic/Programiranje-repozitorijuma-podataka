# Praćenje treninga 

Projekat iz predmeta **Programiranje repozitorijuma podataka (PRP)** na Fakultetu organizacionih nauka.

Sistem za praćenje planova treninga — trener kreira treninge i vežbe, klijent ih prati.

---

## Tehnologije

- **SQL Server** (LocalDB) — baza podataka
- **C# / .NET 8** — Windows Forms aplikacija
- **SSMS** — razvoj i testiranje baze

---

## Arhitektura baze podataka

Baza je organizovana u **troslojna arhitektura** po obrascu DB ADT (Abstract Data Type):

```
api_trener  ──┐
              ├──► spec ──► impl (tabele, trigeri, funkcije)
api_klijent ──┘
```

| Sloj | Opis |
|------|------|
| `impl` | Privatna implementacija — tabele, trigeri, audit log, procedure (3 verzije po entitetu) |
| `spec` | Javna specifikacija — sinonimi i pogledi sa WITH ENCRYPTION |
| `api_trener` | API za trener aplikaciju — procedure, funkcije i pogledi |
| `api_klijent` | API za klijent aplikaciju — procedure, funkcije i pogledi (JSON format) |

---

## Šta je implementirano

### Tabele (impl sloj)
- `korisnik` — trener ili klijent
- `vezba` — natklasa (IS-A veza sa `kardio` i `snaga`)
- `kardio`, `snaga` — potklase vežbe
- `trening` — plan treninga
- `stavka_treninga` — slab objekat (stavke plana)
- `pracenje` — klijent prati trening

### Stored procedure — 3 verzije po entitetu
Svaki entitet ima tri razvojne verzije procedura:
- **Osnovna** — direktna validacija, `RAISERROR`
- **Refactoring** — SRP (UprValidate, UprCheck, UprLogError), `THROW`, `@CallerName`
- **Improvement (produkciona)** — poruke iz `tblErrorCatalog`, `UPDLOCK`, `@@ROWCOUNT`, `SET XACT_ABORT ON`

### Funkcije
- Skalarne: PostojiEmail, PostojiKorisnickoIme, PostojiVezba, PostojiTrening...
- Table-value: LoginKorisnik, VratiSveVezbe, VratiKardioVezbe, VratiTreningeZaTrenera, MojaPracenja...

### Trigeri
5 AFTER trigera (INS/UPD/DEL) za automatski audit log na svim aplikacionim tabelama.

### Pogledi
Svaki entitet ima pogled u svakom sloju: `impl.vw*` → `spec.vw_*` → `api_trener.*` / `api_klijent.*`

### Bezbednost
- `DbTrenerApp` i `DbKlijentApp` aplikacione uloge
- `EXECUTE AS` i `GRANT EXECUTE` na API procedurama
- `WITH ENCRYPTION` na svim spec i api objektima

---

## Kako pokrenuti

### Preduslovi
- SQL Server LocalDB ili SQL Server Express
- SSMS (SQL Server Management Studio)

### Koraci

1. **Kloniraj repozitorijum**
   ```
   git clone https://github.com/andrijanaopacic/TreninziProjekatPRP.git
   ```

2. **Otvori `DB/00_Master.sql` u SSMS**

3. **Promeni putanju** — `Ctrl+H`, zameni `Andrijana` sa tvojim Windows korisničkim imenom

4. **Uključi SQLCMD Mode** — `Query → SQLCMD Mode`

5. **Pokreni** — `F5`

   Na kraju treba da se ispiše:
   ```
   TreninziProjekat — svi objekti su kreirani uspesno!
   ```

6. **Pokreni aplikaciju** — otvori `App/AndjelaAndrijanaTreninzi.sln` u Visual Studio i pokreni

---


## Demo podaci

Demo podaci se automatski unose pri pokretanju master skripte:
- 4 trenera, 3 klijenta
- 18 vežbi (kardio i snaga)
- 7 planova treninga sa stavkama
- Praćenja klijenata

---

## Autori

- **Anđela Nikolić**
- **Andrijana Opačić**
