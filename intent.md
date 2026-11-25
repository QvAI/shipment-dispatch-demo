# Intent: SHIP-101 · Idempotens küldeményfeladás újrapróbálkozáskor
Szerző: Product Manager (Raktári üzemeltetés). Státusz: fejlesztői specifikációra kész.
Forrás: [SHIP-101](docs/ticket.md)

## Probléma
Amikor a raktári kliens küldeményfeladást indít (pl. Debrecenbe a `REQ-101` kérésazonosítóval), és az adatbázis-beszúrás sikeres, de a hálózati válasz elvész, a kliens pontosan ugyanazt a kérést küldi újra. Ma a rendszer nem ismeri fel az ismétlést, és létrehoz egy második, duplikált küldeményt.

## Elvárt eredmény
- Azonos kérésazonosítóval és azonos adatokkal megismételt kérésnél a rendszer az eredeti küldeményazonosítót adja vissza, és egyetlen sor marad tárolva.
- Új kérésazonosítóval minden esetben új, önálló küldemény jön létre — akkor is, ha a célállomás ugyanaz.

## Érintett felhasználók és rendszerek
Raktári operátorok, a Java feladási kliens (`ShipmentClient`), a JDBC-adapter, valamint a közös Oracle PL/SQL feladási csomag (`Shipment_Api.Submit`, amelyet közvetlen PL/SQL-hívók is használnak).

## Megkötések
- A javításnak a közös feladási út **minden** hívóját védenie kell (a Java-klienst és a közvetlen PL/SQL-hívókat is).
- A meglévő publikus hívási szignatúráknak visszamenőlegesen kompatibilisnek kell maradniuk.
- A hívó által kezelt tranzakcióhatárok nem sérülhetnek (nem kerülhet rejtett `COMMIT` a package-be).

## Nyitott kérdések
- Mi történjen akkor, ha egy hívó ugyanazt a kérésazonosítót **eltérő** célállomással (vagy eltérő adatokkal) küldi be újra? Hibával utasítsuk el az eredeti sor megőrzése mellett, vagy írjuk felül az eredeti küldeményt? *(Implementáció előtt Product Owner döntés szükséges.)*
