# Intent: SHIP-101 · Idempotent shipment dispatch on retry
Author: Product Manager (Warehouse Operations). Status: ready for engineering spec.
Source: [SHIP-101](docs/ticket.md)

## Problem
When the warehouse client submits a shipment (e.g. to Debrecen with request key `REQ-101`) and the network response is lost after the database insert succeeds, the client retries the exact same request. Today, the system creates a second duplicate shipment instead of recognizing the retry.

## Proposed outcome
- Retrying a request with the same request key and same shipment data returns the original shipment ID, with only a single shipment stored.
- A new request key creates a new, independent shipment — even if the destination is the same.

## Affected users and systems
Warehouse operators, Java dispatch client (`ShipmentClient`), JDBC gateway, and the shared Oracle PL/SQL dispatch package (`Shipment_Api.Submit`, also called by direct PL/SQL consumers).

## Constraints
- The fix must protect **all** callers of the shared dispatch path (both Java and direct PL/SQL callers).
- Existing public call signatures must remain backwards-compatible.
- Transaction boundaries owned by the caller must not be broken (no hidden commits inside the package).

## Open questions
- What should happen if a caller reuses an existing request key with a **different** destination (or mismatched payload)? Should it be rejected with an error, or overwrite the original shipment? *(Needs Product Owner decision before implementation.)*
