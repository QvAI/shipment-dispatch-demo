WHENEVER OSERROR EXIT FAILURE ROLLBACK
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
SET SERVEROUTPUT ON
DECLARE
   key_ VARCHAR2(80) := RAWTOHEX(SYS_GUID());
   next_key_ VARCHAR2(80) := RAWTOHEX(SYS_GUID());
   first_id_ NUMBER;
   replay_id_ NUMBER;
   next_id_ NUMBER;
   rows_ NUMBER;
   saved_dest_ VARCHAR2(80);
BEGIN
   Shipment_Api.Submit(key_, 'DEB', first_id_);
   COMMIT; -- The original request was committed before its reply was lost.
   IF first_id_ IS NULL THEN
      RAISE_APPLICATION_ERROR(-20000, 'First submission must return a non-null shipment ID');
   END IF;
   Shipment_Api.Submit(key_, 'DEB', replay_id_);
   SELECT COUNT(*), MAX(destination) INTO rows_, saved_dest_ FROM shipments WHERE request_key = key_;
   IF replay_id_ IS NULL OR replay_id_ <> first_id_ OR rows_ <> 1 OR saved_dest_ <> 'DEB' THEN
      RAISE_APPLICATION_ERROR(-20001, 'Replay must return the original ID and keep one row with DEB');
   END IF;

   Shipment_Api.Submit(next_key_, 'DEB', next_id_);
   IF next_id_ IS NULL OR next_id_ = first_id_ THEN
      RAISE_APPLICATION_ERROR(-20002, 'A new key must create a different shipment');
   END IF;

   BEGIN
      Shipment_Api.Submit(key_, 'BUD', replay_id_);
      RAISE_APPLICATION_ERROR(-20003, 'Different payload was accepted for the same key');
   EXCEPTION
      WHEN OTHERS THEN
         IF SQLCODE <> -20031 THEN
            RAISE;
         END IF;
   END;
   SELECT COUNT(*), MAX(destination) INTO rows_, saved_dest_ FROM shipments WHERE request_key = key_;
   IF rows_ <> 1 OR saved_dest_ <> 'DEB' THEN
      RAISE_APPLICATION_ERROR(-20004, 'Original row destination must remain DEB after payload conflict');
   END IF;
   SELECT COUNT(*) INTO rows_ FROM shipments WHERE request_key IN (key_, next_key_);
   IF rows_ <> 2 THEN
      RAISE_APPLICATION_ERROR(-20004, 'Expected two rows for two keys');
   END IF;
   DBMS_OUTPUT.PUT_LINE('ORACLE / original ID, new key and payload conflict verified');
END;
/
EXIT SUCCESS ROLLBACK
