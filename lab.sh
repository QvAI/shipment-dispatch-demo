#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMAGE="shipment-dispatch-lab:local"

ensure_image() {
  if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
    docker compose -f "$ROOT/docker-compose.yml" build lab
  fi
}

run_lab() {
  ensure_image
  docker compose -f "$ROOT/docker-compose.yml" run --rm --no-deps lab "$@"
}

cmd="${1:-test}"
if [ $# -gt 0 ]; then
  shift
fi

case "$cmd" in
  build)
    docker compose -f "$ROOT/docker-compose.yml" build lab
    ;;
  test|all)
    run_lab sh -c "python -m unittest discover -s tests && python tools/check_java.py"
    ;;
  sql)
    run_lab python -m unittest discover -s tests "$@"
    ;;
  java)
    run_lab python tools/check_java.py "$@"
    ;;
  probe)
    run_lab python tools/probe.py "$@"
    ;;
  oracle)
    docker compose -f "$ROOT/docker-compose.yml" --profile oracle up --build --abort-on-container-exit --exit-code-from oracle-verify
    ;;
  shell)
    run_lab bash "$@"
    ;;
  help|-h|--help)
    cat <<'EOF'
Usage: ./lab.sh <command> [args...]

Commands (Docker-only, no local Python/JDK required):
  test | all     Run SQLite unittest suite + Java 17 contract check
  sql            Run Python unittest suite (db/ SQLite tests)
  java           Compile & run Java 17 retry contract
  probe          Run SQLite smoke probe
  oracle         Run full Oracle 23ai Docker verification
  build          Rebuild the lab Docker image
  shell          Open an interactive bash shell inside the lab container
  <cmd> [args]   Run any command inside the lab container (e.g. python ..., javac ...)
EOF
    ;;
  *)
    run_lab "$cmd" "$@"
    ;;
esac
