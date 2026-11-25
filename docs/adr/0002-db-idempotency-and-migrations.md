# ADR 0002 · Idempotencia-minta, sémamigrációk és hibakódok

**Állapot** Elfogadva

## Döntés

1. **Versenyhelyzet-mentes idempotencia (`DUP_VAL_ON_INDEX`):**
   Minden Oracle idempotens írási műveletet adatbázis-szintű egyediséggel (`UNIQUE INDEX` vagy `UNIQUE CONSTRAINT`) és `INSERT ... EXCEPTION WHEN DUP_VAL_ON_INDEX THEN SELECT ...` mintával valósítunk meg. A `SELECT`-előtte-`INSERT` minta és a `MERGE` használata **tilos** a párhuzamos versenyhelyzetek és a visszatérési azonosító kiszámíthatósága miatt.

2. **Kiadott alapséma védelme (`db/migrations/`):**
   A `db/001_shipments.sql` fájl az élesben már kiadott alapsémát írja le — **utólag tilos módosítani**. Minden új index, megszorítás vagy oszlop új, sorszámozott migrációs fájlba kerül a `db/migrations/` mappába (pl. `db/migrations/002_shipments_unique_request_key.sql`).

3. **Alkalmazás-hibakód tartomány (`Shipment_Api`):**
   A `Shipment_Api` package üzleti hibái a `-20030`..`-20039` tartományba esnek (`RAISE_APPLICATION_ERROR`). A hívó által kezelt tranzakciót a package nem zárhatja le (`COMMIT`/`ROLLBACK` tilos).
