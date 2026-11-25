# Intent: SHIP-101 · Idempotens küldeményfeladás újrapróbálkozáskor
Szerző: Product Manager (Raktári üzemeltetés). Státusz: fejlesztői specifikációra kész.
Forrás: [SHIP-101](docs/ticket.md)

## Probléma
Amikor a raktári kliens küldeményfeladást indít (pl. Debrecenbe a `REQ-101` kérésazonosítóval), és az adatbázis-beszúrás sikeres, de a hálózati válasz elvész, a kliens pontosan ugyanazt a kérést küldi újra. Ma a rendszer nem ismeri fel az ismétlést, és létrehoz egy második, duplikált küldeményt.

## Elvárt eredmény
- Azonos kérésazonosítóval és azonos adatokkal megismételt kérésnél a rendszer az eredeti küldeményazonosítót adja vissza, és egyetlen sor marad tárolva.
- Új kérésazonosítóval minden esetben új, önálló küldemény jön létre — akkor is, ha a célállomás ugyanaz.

## Érintett felhasználók és rendszerek
Raktári operátorok és a küldeményfeladási folyamat (raktári kliens és háttérrendszer).

## Megkötések
- A meglévő hívóknak módosítás nélkül továbbra is működniük kell (visszamenőleges kompatibilitás).
- A meglévő, már rögzített küldemények adatai nem sérülhetnek.

## Nyitott kérdések
- Mi történjen akkor, ha egy hívó ugyanazt a kérésazonosítót **eltérő** célállomással (vagy eltérő adatokkal) küldi be újra? Hibával utasítsuk el az eredeti sor megőrzése mellett, vagy írjuk felül az eredeti küldeményt? *(Implementáció előtt Product Owner döntés szükséges.)*
