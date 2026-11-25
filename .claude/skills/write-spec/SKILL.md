---
name: write-spec
description: Deterministically explore the codebase from intent.md, stop to ask any unanswered Open questions, and produce spec.md with Requirements, Design, constraint mapping, and Areas of concern.
---

# Write Technical Specification (`/write-spec`)

Translate `intent.md` into a concrete, testable technical specification (`spec.md`) grounded in the actual codebase and ADRs. **NEVER edit application source files (`db/`, `java/`, `oracle/`, `tests/`, `tools/`) while running this skill.**

## Mandatory Step-by-Step Protocol

### Step 1 · Read Required Files (Read-Only)
Read these files in order before forming any conclusion:
1. `intent.md`
2. `AGENTS.md` (if present)
3. **Strict `docs/` rule:** **NEVER read, glob, or search any file under `docs/` (including `docs/adr/`, `docs/architecture.md`, `docs/ticket.md`) unless `AGENTS.md` explicitly points to it.** If `AGENTS.md` is missing or does not reference a `docs/` path, ignore `docs/` completely.
4. `.gitlab-ci.yml` (to extract the exact authoritative verification commands)
5. Relevant source files across layers: `java/`, `db/`, `oracle/`, `tools/`

### Step 2 · Mandatory Stop-and-Ask Gate (Open Questions)
Inspect `## Open questions` / `## Nyitott kérdések` in `intent.md`.
- If **any** open question is still unanswered (for example: what should happen when an existing `request_key` is retried with a **different** `destination` / payload):
  - **STOP before finalizing `spec.md`.**
  - Report in 3–5 concise bullets what you found in the codebase (exact file paths + line numbers for the call chain from Java client → JDBC adapter → PL/SQL package).
  - Ask the user (acting as Product Owner) **one clear, concrete decision question** for each unanswered item in `## Open questions`, offering the concrete options (e.g. reject with a dedicated Oracle application error keeping the original row untouched vs. overwrite).
  - **Wait for the user's answer** before writing `spec.md`.

### Step 3 · Write `spec.md` (Only After Open Questions Are Resolved)
Once the Product Owner answers, write `spec.md` in the repository root using this **exact** structure:

```markdown
# Spec: <ticket-id> · <short title>
From: intent.md. Status: ready for review.
Skills applied: write-spec (+ list ADRs/rules applied).

## Requirements
- R1. <First call creates a shipment and returns its ID.>
- R2. <Retry with the same request key and same payload returns the original ID; only 1 row stored.>
- R3. <New request key creates a new shipment, even for the same destination.>
- R4. <Exact PO decision for same request key + different destination (e.g. ORA-20031, original row unchanged).>

## Design
- **Call path verified:** <Exact file paths and line numbers across the codebase.>
- **Proposed change & layer choice:** <Concrete technical change grounded strictly in the files read above and any ADRs/rules referenced by `AGENTS.md`.>
- **Unchanged boundaries:** <Public interfaces and contracts that must stay backwards-compatible.>
- **Authoritative verification commands:** List the exact CLI commands from `.gitlab-ci.yml` / `AGENTS.md` (`python -m unittest discover -s tests`, `python tools/check_java.py`, and optional `python tools/run_oracle.py`).

## How each constraint in the intent is met
| Constraint | Met by |
| :--- | :--- |
| <Every constraint from intent.md> | <Specific requirement or design element> |

## Open questions from the intent
- <Each question from intent.md + the exact PO decision recorded.>

## Areas of concern
1. <Concurrency / race condition if implemented without DB unique constraint.> Owner: db-team.
2. <Existing duplicate rows in production before adding the unique index.> Owner: ops / db-team.
3. <SQLite local probe vs. real Oracle 23ai verification boundary.> Owner: qa / backend.
```

### Step 4 · Stop for Review
Summarize the written `spec.md` in 5 lines and stop. Do **not** modify any production code or tests until the user approves `spec.md` or switches to Plan mode.
