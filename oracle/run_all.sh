#!/usr/bin/env bash
set -euo pipefail

DSN="${ORACLE_DSN:-app_user/app_pass@//oracle-db:1521/FREEPDB1}"
cd /workspace/oracle

{
  echo "WHENEVER OSERROR EXIT FAILURE"
  echo "WHENEVER SQLERROR EXIT SQL.SQLCODE"
  echo "SET SERVEROUTPUT ON"
  echo "BEGIN IF USER <> 'APP_USER' THEN RAISE_APPLICATION_ERROR(-20099, 'Safety guard: disposable APP_USER schema required'); END IF; END;"
  echo "/"
  echo "BEGIN EXECUTE IMMEDIATE 'DROP PACKAGE Shipment_Api'; EXCEPTION WHEN OTHERS THEN NULL; END;"
  echo "/"
  echo "BEGIN EXECUTE IMMEDIATE 'DROP TABLE shipments PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;"
  echo "/"
  echo "@@../db/001_shipments.sql"
  if [ -d ../db/migrations ]; then
    for mig in $(find ../db/migrations -maxdepth 1 -name '*.sql' | sort); do
      echo "@@$mig"
    done
  fi
  echo "@@../db/shipment_api.pks"
  echo "@@../db/shipment_api.pkb"
  echo "SHOW ERRORS PACKAGE Shipment_Api"
  echo "SHOW ERRORS PACKAGE BODY Shipment_Api"
  echo "@@verify.sql"
} | sqlplus -S "$DSN"
