# Shipment Dispatch

A Java-kliens küldeményt ad fel. A szintetikus adatbázisban egy sor egy feladást jelent. A [hibajegy](docs/ticket.md) egy sikeres adatbázis-művelet után elveszett válasszal kezdődik. A kliens újraküldi ugyanazt a kérést, és egy második küldemény jelenik meg.

Helyi ellenőrzések Python 3.11+ és JDK 17+ mellett.

~~~text
python tools/check_java.py
python -m unittest discover -s tests
~~~

A Java-próba helyettesített gatewayjel vizsgálja a kliens újrapróbálkozását. A `tests/test_baseline.py` a package megjelölt utasításait és a repó sémafájljait SQLite-on futtatja (`tools.probe.repository`). A kezdő állapotban csak az egyszeri feladás smoke tesztje van meg (zöld) — az idempotencia- és kulcsütközés-teszteket (`tests/test_idempotency.py`) TDD-vel, piros futással kezdve adjuk hozzá a `SHIP-101` javításhoz.

Az Oracle-ellenőrzéshez használhatod az önálló Docker Compose környezetet (`gvenzl/oracle-free:23-slim`), vagy a `python tools/run_oracle.py` szkriptet (SQLcl / SQL*Plus kézi használatakor az `oracle/` munkakönyvtárban futtasd a `@setup.sql` és `@verify.sql` fájlokat). A javítás indexmigrációját a package frissítése előtt kell alkalmazni. A repó `.gitlab/merge_request_templates/Default.md` fájlja tartalmazza az ellenőrzött MR-sablont.

~~~text
docker compose up --build
docker compose --profile oracle up --build
~~~
