# ADR 0001 · Közös adatbázisoldali feladási út

**Állapot** Elfogadva

A feladást végző üzleti művelet a `Shipment_Api.Submit` package-eljáráson keresztül érhető el. Java-hívók és PL/SQL-folyamatok használhatják ugyanazt a publikus felületet. Az idempotencia és a tartós adatinvariánsok a közös írási úton érvényesülnek. A hívó a logikai feladáshoz kapott kulcsot a teljes újrapróbálkozás során továbbadja.

A tranzakció lezárása a hívó feladata. Publikus aláírást és hibaszerződést jóváhagyott követelmény alapján módosítunk. Az érintett fogyasztókat változtatás előtt azonosítjuk.
