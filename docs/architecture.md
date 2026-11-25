# Küldeményfeladás

`ShipmentClient → ShipmentGateway ← OracleShipmentGateway → Shipment_Api.Submit`

A `java/ShipmentClient.java` időtúllépéskor ugyanazzal a kulccsal és célállomással próbálkozik újra. A `java/OracleShipmentGateway.java` bind paramétereken adja át a kérést és kezeli a tranzakciót. A Java-próba helyettesített gatewayjel állítja elő az elveszett választ.

A publikus Oracle-szerződés a `db/shipment_api.pks` fájlban van. A feladási írás útja a `db/shipment_api.pkb`. A tábla alapsémája a `db/001_shipments.sql` fájl. A külön Oracle-próba közvetlenül hívja a package-et, a Java-kliens nélkül.

A repóban a Java- és SQL-parancsokat a CI külön jobokban futtatja. Az SQLite-próba a megjelölt SQL-t futtatja, a PL/SQL kivételkezelés és a közvetlen Oracle-hívás az Oracle-próba része.
