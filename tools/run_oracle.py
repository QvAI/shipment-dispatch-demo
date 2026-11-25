import os
import shutil
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ORACLE_DIR = ROOT / "oracle"
DB_DIR = ROOT / "db"


def find_sqlplus():
    for candidate in ("sqlplus", "sql"):
        found = shutil.which(candidate)
        if found:
            return found
    return None


def main():
    client = find_sqlplus()
    if client:
        dsn = os.environ.get("ORACLE_DSN", "app_user/app_pass@//localhost:1521/FREEPDB1")
        migrations = sorted((DB_DIR / "migrations").glob("*.sql"))

        script_lines = [
            "WHENEVER OSERROR EXIT FAILURE",
            "WHENEVER SQLERROR EXIT SQL.SQLCODE",
            "SET SERVEROUTPUT ON",
            "BEGIN IF USER <> 'APP_USER' THEN RAISE_APPLICATION_ERROR(-20099, 'Safety guard: disposable APP_USER schema required'); END IF; END;",
            "/",
            "BEGIN EXECUTE IMMEDIATE 'DROP PACKAGE Shipment_Api'; EXCEPTION WHEN OTHERS THEN NULL; END;",
            "/",
            "BEGIN EXECUTE IMMEDIATE 'DROP TABLE shipments PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;",
            "/",
            f'@"{DB_DIR / "001_shipments.sql"}"',
        ]
        for migration in migrations:
            script_lines.append(f'@"{migration}"')
        script_lines.extend([
            f'@"{DB_DIR / "shipment_api.pks"}"',
            f'@"{DB_DIR / "shipment_api.pkb"}"',
            f'@"{ORACLE_DIR / "verify.sql"}"',
        ])

        payload = "\n".join(script_lines) + "\n"
        completed = subprocess.run(
            [client, "-S", dsn],
            input=payload,
            text=True,
            cwd=ORACLE_DIR,
        )
        raise SystemExit(completed.returncode)

    if shutil.which("docker"):
        dsn = os.environ.get("ORACLE_DSN", "app_user/app_pass@//host.docker.internal:1521/FREEPDB1")
        completed = subprocess.run([
            "docker", "run", "--rm",
            "-e", f"ORACLE_DSN={dsn}",
            "-v", f"{ROOT}:/workspace",
            "-w", "/workspace/oracle",
            "--entrypoint", "bash",
            "gvenzl/oracle-free:23-slim",
            "/workspace/oracle/run_all.sh",
        ])
        raise SystemExit(completed.returncode)

    raise SystemExit(
        "Nincs elérhető sqlplus, sql (SQLcl) vagy docker a PATH-on. "
        "Használd a 'docker compose --profile oracle up --build' parancsot."
    )


if __name__ == "__main__":
    main()
