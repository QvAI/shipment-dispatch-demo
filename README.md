# Shipment Dispatch

A Java-kliens küldeményt ad fel. A szintetikus adatbázisban egy sor egy feladást jelent. A [hibajegy](docs/ticket.md) egy sikeres adatbázis-művelet után elveszett válasszal kezdődik. A kliens újraküldi ugyanazt a kérést, és egy második küldemény jelenik meg.

Helyi ellenőrzések Python 3.11+ és JDK 17+ mellett:

~~~text
python tools/check_java.py
python -m unittest discover -s tests
~~~

**Csak Dockerrel (helyi Python / JDK 17 nélkül, Windows / macOS / Linux):**

~~~text
# macOS / Linux / Git Bash / WSL:
./lab.sh test          # unittest + Java 17 fordítás és futtatás
./lab.sh sql           # csak Python unittest
./lab.sh java          # csak Java 17 szerződés-ellenőrzés
./lab.sh probe         # SQLite smoke probe
./lab.sh oracle        # teljes Oracle 23ai ellenőrzés
./lab.sh python --version

# Windows (PowerShell és CMD — működik korlátozott ExecutionPolicy mellett is):
.\lab.cmd test
.\lab.cmd sql
.\lab.cmd java
.\lab.cmd probe
.\lab.cmd oracle
.\lab.cmd python --version
~~~

A Java-próba helyettesített gatewayjel vizsgálja a kliens újrapróbálkozását. A `tests/test_baseline.py` a package megjelölt utasításait és a repó sémafájljait SQLite-on futtatja (`tools.probe.repository`). A kezdő állapotban csak az egyszeri feladás smoke tesztje van meg (zöld) — az idempotencia- és kulcsütközés-teszteket TDD-vel, piros futással kezdve adjuk hozzá a `tests/` mappához.

Az Oracle-ellenőrzéshez használhatod az önálló Docker Compose környezetet (`gvenzl/oracle-free:23-slim`), vagy a `python tools/run_oracle.py` szkriptet (SQLcl / SQL*Plus kézi használatakor az `oracle/` munkakönyvtárban futtasd a `@setup.sql` és `@verify.sql` fájlokat). A repó `.gitlab/merge_request_templates/Default.md` fájlja tartalmazza az ellenőrzött MR-sablont.

~~~text
docker compose up --build
docker compose --profile oracle up --build
~~~
