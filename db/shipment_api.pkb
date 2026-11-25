CREATE OR REPLACE PACKAGE BODY Shipment_Api AS
   PROCEDURE Submit (
      request_key_ IN VARCHAR2,
      destination_ IN VARCHAR2,
      shipment_id_ OUT NUMBER
   )
   IS
   BEGIN
      -- COURSE INSERT BEGIN
      INSERT INTO shipments (request_key, destination)
      VALUES (request_key_, destination_)
      RETURNING shipment_id INTO shipment_id_;
      -- COURSE INSERT END
      -- Helyi SQLite-próbához a DUP_VAL_ON_INDEX ág visszakereső SELECT utasítását
      -- csomagold -- COURSE REPLAY BEGIN és -- COURSE REPLAY END jelölők közé.
   END Submit;
END Shipment_Api;
/
