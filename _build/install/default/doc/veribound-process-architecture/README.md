# VeriBound 2.0 – Developer CLI Demonstration

This developer-facing CLI walkthrough demonstrates VeriBound’s core capabilities in symbolic verification, mathematical integrity, and audit readiness.

## Overview

VeriBound 2.0 is a boundary-classification system rooted in symbolic logic and implemented in OCaml for maximum reliability. This CLI demo is intended for technical reviewers, developers, and audit partners. It showcases:

- Formal classification using domain-specific YAML schemas
- Flocq-based verified arithmetic for precision-critical domains
- Structural validation of regulatory boundaries (gaps, overlaps)
- Cryptographic sealing via hash and irrational marker

---

## CLI Commands

All commands assume you're in the project root:

```bash
cd ~/Downloads/veribound-process-architecture/
```

### 1. Inspect a Classification

```bash
./veribound.exe inspect basel_iii_capital_adequacy 9.2 --show-process
```

Expected:
- Returns the category and classification confidence
- Optional detail includes classification engine, file source, and boundary count

### 2. Verify Domain Structure

```bash
./veribound.exe verify aml_cash --show-boundaries
```

Expected:
- Confirms YAML domain schema
- Shows each symbolic range, category, and color binding

### 3. Audit Domain Coverage

```bash
./veribound.exe audit-domain boundary_logic/domain_definitions/aqi.yaml --coverage-analysis
```

Expected:
- Validates that all boundaries are covered
- Detects gaps, overlaps, and out-of-bounds issues

### 4. Test the Full Domain Pipeline

```bash
./veribound.exe test-pipeline --all-domains --sample-values
```

Expected:
- Attempts to load and test classification on all 20+ domain files
- Reports coverage, boundary count, and classification outcome

---

## Integrity and Seal

Each verification trace concludes in an audit trail:
- A computed **cryptographic seal** (signed hash)
- An **irrational marker** derived from symbolic structure
- Optional GPG signature for third-party validation

These are not decorative—they are symbolic expressions of verification work done.

---

## Verification

To verify this CLI demo bundle:

```bash
sha256sum -c veribound_cli_demo.sha256
gpg --verify veribound_cli_demo.sha256.asc
```

Use the provided `veribound_pubkey.asc` for signature verification.

