WHENEVER OSERROR EXIT FAILURE
WHENEVER SQLERROR EXIT SQL.SQLCODE
DECLARE
   current_user_ VARCHAR2(128);
BEGIN
   SELECT USER INTO current_user_ FROM dual;
   IF current_user_ <> 'APP_USER' THEN
      RAISE_APPLICATION_ERROR(-20099, 'Safety guard: refusing to run destructive DDL outside disposable APP_USER training schema (current=' || current_user_ || ')');
   END IF;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP PACKAGE Shipment_Api';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE shipments PURGE';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/
@@../db/001_shipments.sql
@@../db/shipment_api.pks
@@../db/shipment_api.pkb
SHOW ERRORS PACKAGE Shipment_Api
SHOW ERRORS PACKAGE BODY Shipment_Api
DECLARE
   error_count_ NUMBER;
BEGIN
   SELECT COUNT(*) INTO error_count_
     FROM USER_ERRORS
    WHERE name = 'SHIPMENT_API' AND attribute = 'ERROR';
   IF error_count_ <> 0 THEN
      RAISE_APPLICATION_ERROR(-20005, 'SHIPMENT_API has compilation errors');
   END IF;
END;
/
EXIT SUCCESS
