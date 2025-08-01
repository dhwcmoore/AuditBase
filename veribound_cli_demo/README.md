# VeriBound 2.0 – Developer CLI Demonstration

This demonstration illustrates the core capabilities of VeriBound 2.0:

- Symbolic boundary classification using formally verified logic
- Mathematical rigour via OCaml and Flocq-based computation
- Secure audit trail, including seal and irrational signature
- Multi-domain readiness (financial, environmental, medical, nuclear)

## Prerequisites

- Executable binary: `veribound.exe`
- Domain definitions: `boundary_logic/domain_definitions/*.yaml`

## 1. Inspect Classification

```bash
./veribound.exe inspect basel_iii_capital_adequacy 9.2 --show-process
```

Expected: Classification as "Meets Requirement" with process details.

## 2. Verify Domain Structure

```bash
./veribound.exe verify aml_cash --show-boundaries
```

Expected: Structural details and all defined boundary intervals.

## 3. Audit Domain for Gaps

```bash
./veribound.exe audit-domain boundary_logic/domain_definitions/aqi.yaml --coverage-analysis
```

Expected: Gap-free boundary validation with global bounds shown.

## 4. Test All Domains

```bash
./veribound.exe test-pipeline --all-domains --sample-values
```

Expected: Each domain loads and classifies a mid-boundary value successfully.

---

The seal and irrational number are visible markers of the system’s symbolic computation — not decoration, but verification artifacts.

VeriBound 2.0 demonstrates the precision, consistency, and transparency expected by modern regulatory systems.
