import subprocess
from pathlib import Path
from tempfile import TemporaryDirectory


ROOT = Path(__file__).resolve().parents[1]


if __name__ == "__main__":
    sources = sorted((ROOT / "java").glob("*.java"))
    with TemporaryDirectory(prefix="shipment-classes-") as classes:
        subprocess.run(["javac", "--release", "17", "-d", classes, *sources], check=True)
        subprocess.run(["java", "-cp", classes, "ShipmentRetryContract"], check=True)
