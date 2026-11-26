param(
    [Parameter(Position = 0)]
    [string]$Command = "test",

    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Rest
)

$ErrorActionPreference = "Continue"
$Root = $PSScriptRoot
$ComposeFile = Join-Path $Root "docker-compose.yml"
$Image = "shipment-dispatch-lab:local"

function Ensure-Image {
    docker image inspect $Image *> $null
    if ($LASTEXITCODE -ne 0) {
        docker compose -f $ComposeFile build lab
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    }
}

function Invoke-Lab {
    param([string[]]$LabArgs)
    Ensure-Image
    docker compose -f $ComposeFile run --rm --no-deps lab @LabArgs
    exit $LASTEXITCODE
}

switch ($Command.ToLowerInvariant()) {
    "build" {
        docker compose -f $ComposeFile build lab
        exit $LASTEXITCODE
    }
    { $_ -in @("test", "all") } {
        Invoke-Lab @("sh", "-c", "python -m unittest discover -s tests && python tools/check_java.py")
    }
    "sql" {
        Invoke-Lab (@("python", "-m", "unittest", "discover", "-s", "tests") + $Rest)
    }
    "java" {
        Invoke-Lab (@("python", "tools/check_java.py") + $Rest)
    }
    "probe" {
        Invoke-Lab (@("python", "tools/probe.py") + $Rest)
    }
    "oracle" {
        docker compose -f $ComposeFile --profile oracle up --build --abort-on-container-exit --exit-code-from oracle-verify
        exit $LASTEXITCODE
    }
    "shell" {
        Invoke-Lab (@("bash") + $Rest)
    }
    { $_ -in @("help", "-h", "--help") } {
        @"
Usage: .\lab.ps1 <command> [args...]

Commands (Docker-only, no local Python/JDK required):
  test | all     Run SQLite unittest suite + Java 17 contract check
  sql            Run Python unittest suite (db/ SQLite tests)
  java           Compile & run Java 17 retry contract
  probe          Run SQLite smoke probe
  oracle         Run full Oracle 23ai Docker verification
  build          Rebuild the lab Docker image
  shell          Open an interactive bash shell inside the lab container
  <cmd> [args]   Run any command inside the lab container (e.g. python ..., javac ...)
"@
        exit 0
    }
    default {
        Invoke-Lab (@($Command) + $Rest)
    }
}
