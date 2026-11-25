FROM eclipse-temurin:17-jdk-noble

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python-is-python3 \
    git \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
COPY . /workspace

CMD ["sh", "-c", "python tools/check_java.py && python -m unittest discover -s tests && python tools/probe.py"]
