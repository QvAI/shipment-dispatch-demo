WHENEVER OSERROR EXIT FAILURE ROLLBACK
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
SET SERVEROUTPUT ON
DECLARE
   key_ VARCHAR2(80) := RAWTOHEX(SYS_GUID());
   first_id_ NUMBER;
   rows_ NUMBER;
BEGIN
   Shipment_Api.Submit(key_, 'DEB', first_id_);
   COMMIT;
   SELECT COUNT(*) INTO rows_ FROM shipments WHERE request_key = key_;
   IF first_id_ IS NULL OR rows_ <> 1 THEN
      RAISE_APPLICATION_ERROR(-20000, 'First submission must return a non-null shipment ID and store one row');
   END IF;
   DBMS_OUTPUT.PUT_LINE('ORACLE SMOKE / first submission verified (id=' || first_id_ || ')');
END;
/
EXIT SUCCESS ROLLBACK
