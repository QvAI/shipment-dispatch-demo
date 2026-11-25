## Hivatkozott hibajegy és intent

- Hibajegy: `docs/ticket.md` (SHIP-101)
- Jóváhagyott specifikáció: `intent.md`

## Hatókör és módosított réteg

- [ ] Adatbázis egyediségi kényszer / index (`db/migrations/`)
- [ ] Közös PL/SQL feladási út (`db/shipment_api.pkb`)
- [ ] Publikus package-aláírás és Java retry szerződés változatlan (`db/shipment_api.pks`, `java/`)

## Futási bizonyítékok

- **SQL-ellenőrzés (piros → zöld):**
  - Parancs: `python tools/probe.py` és `python -m unittest discover -s tests`
  - Eredmény (azonos kulcs, új kulcs, eltérő célállomás):
- **Java-ellenőrzés:**
  - Parancs: `python tools/check_java.py`
  - Eredmény:

## Nyitott kockázatok és további ellenőrzés

- [ ] Valódi Oracle-tesztséma ellenőrzése (`@oracle/setup.sql`, `@oracle/verify.sql` vagy Docker Oracle Free profil)
- [ ] Párhuzamos tranzakciók zárolási és `DUP_VAL_ON_INDEX` viselkedése
- [ ] Meglévő duplikált `request_key` sorok tisztítása az egyedi index éles telepítése előtt
