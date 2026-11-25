CREATE OR REPLACE PACKAGE Shipment_Api AS
   PROCEDURE Submit (
      request_key_ IN VARCHAR2,
      destination_ IN VARCHAR2,
      shipment_id_ OUT NUMBER
   );
END Shipment_Api;
/
