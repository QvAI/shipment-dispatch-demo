# SHIP-101 · Újrapróbálkozáskor duplázódik a küldemény

A raktári kliens feladást indít Debrecenbe a `REQ-101` kérésazonosítóval. Az adatbázis létrehozza a küldeményt, de a válasz elvész. A kliens ugyanazt a kérést küldi újra. Most két küldemény jön létre.

Azonos kérésazonosítóval és azonos adatokkal ugyanazt a küldeményazonosítót kell visszakapni, egyetlen tárolt feladással. Új kérésazonosító önálló feladást indíthat ugyanarra a címre is. Tisztázandó, hogyan jelezzük, ha ugyanazt a kulcsot más célállomással küldik be.
