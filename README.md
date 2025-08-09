# VeriBound Process Architecture

A mathematically verified boundary classification system for critical applications in healthcare, finance, environmental monitoring, and nuclear safety.

## What is VeriBound?
VeriBound classifies numeric values into predefined categories with mathematical certainty. The system takes a domain and a numeric value, then returns which boundary category contains that value.

**Example: Classify an HbA1c reading**
dune exec -- bin/main.exe inspect diabetes 6.0

Returns: Prediabetes
pgsql
Copy
Edit

Why this matters: In critical systems, incorrect classifications can be catastrophic. Traditional boundary logic uses ad-hoc if/else statements with no formal guarantees. VeriBound centralises this logic into a mathematically verified framework where the classification algorithms are backed by formal proofs.

**Mathematical verification means:** The core classification logic is proven correct using the Coq theorem prover (with Flocq for floating-point reasoning). This guarantees that edge cases, boundary overlaps, and classification algorithms behave exactly as specified.

---

## How Boundaries Work

**Diabetes Classification (HbA1c %):**
[0.0──5.7]──[5.7──6.5]──[6.5──14.0]
Normal Prediabetes Diabetes
↑
Your value: 6.0 → Prediabetes

yaml
Copy
Edit
The system mathematically verifies that every value maps to exactly one category.

---

## Quick Start

Build the system:
git clone https://github.com/dhwcmoore/VeriBound_process_design.git
cd VeriBound_process_design
dune build

css
Copy
Edit

Try a classification:
dune exec -- bin/main.exe inspect diabetes 6.0

css
Copy
Edit

Test all domains:
dune exec -- bin/main.exe test-pipeline --all-domains

yaml
Copy
Edit

---

## Example Classifications

**Diabetes (HbA1c %)**
dune exec -- bin/main.exe inspect diabetes 5.0 # Normal
dune exec -- bin/main.exe inspect diabetes 6.0 # Prediabetes
dune exec -- bin/main.exe inspect diabetes 7.0 # Diabetes

java
Copy
Edit

**Blood Pressure (systolic mmHg)**
dune exec -- bin/main.exe inspect blood_pressure 90.0 # Normal
dune exec -- bin/main.exe inspect blood_pressure 140.0 # High

markdown
Copy
Edit

**Air Quality Index**
dune exec -- bin/main.exe inspect aqi 50.0 # Moderate
dune exec -- bin/main.exe inspect aqi 150.0 # Unhealthy

java
Copy
Edit

**Financial Risk (Basel III capital ratios)**
dune exec -- bin/main.exe inspect basel_iii_capital_adequacy 8.0 # Adequate
dune exec -- bin/main.exe inspect basel_iii_capital_adequacy 6.0 # Undercapitalized

yaml
Copy
Edit

---

## Commands

**Inspect**
dune exec -- bin/main.exe inspect DOMAIN VALUE

markdown
Copy
Edit

**Verify**
dune exec -- bin/main.exe verify DOMAIN

e.g.
dune exec -- bin/main.exe verify diabetes

markdown
Copy
Edit

**Test Pipeline**
dune exec -- bin/main.exe test-pipeline --all-domains

markdown
Copy
Edit

Add `--show-process` to any command to see detailed steps.

---

## Supported Domains

**Healthcare & Medical (4)**  
- `diabetes`: HbA1c classification (Normal/Prediabetes/Diabetes)  
- `blood_pressure`: Hypertension staging  
- `medical`: General medical thresholds  
- `clinical_trial_safety`: Clinical trial safety boundaries

**Financial Risk & Compliance (8)**  
- `basel_iii_capital_adequacy`  
- `aml_cash`  
- `ccar_capital_ratios`  
- `ccar_loss_rates`  
- `frtb_market_risk`  
- `liquidity_risk_lcr_nsfr`  
- `mifid2_best_execution`  
- `basel_corporate`

**Environmental Monitoring (2)**  
- `aqi`  
- `aqi_fixed`

**Nuclear Safety (3)**  
- `nuclear_emergency_action_levels`  
- `nuclear_radiation_limits`  
- `nuclear_reactor_protection`

**Pharmaceutical (2)**  
- `pharma_dose_safety`  
- `medical_device_performance`

---

## System Architecture

**Engine Interface** (`mathematical_extraction/engine_interface/`)  
- Domain Manager (YAML loader)  
- Boundary Classifier  
- Type-safe OCaml interfaces with formal verification

**Runtime Classifier** (`classification_runtime/boundary_engine/`)  
- High-performance runtime  
- Confidence scoring and engine identification

**Mathematical Verification** (`mathematical_extraction/flocq_proofs/`)  
- Coq proofs + Flocq for floating-point  
- Verified boundary helpers

**CLI** (`bin/`)  
- Tools for inspect / verify / pipeline

**Classification Process**  
1. Parse command  
2. Load domain YAML from `boundary_logic/domain_definitions/`  
3. Validate input  
4. Classify via verified logic  
5. Return structured result with confidence + engine id

---

## Domain Definition Format (HbA1c example, unit = “%”)
```yaml
name: "Diabetes (HbA1c)"
unit: "%"
description: "Hemoglobin A1c (percent)"
global_bounds: [0.0, 14.0]
boundaries:
  - range: [0.0, 5.7]
    category: "Normal"
    color: "green"
  - range: [5.7, 6.5]
    category: "Prediabetes"
    color: "yellow"
  - range: [6.5, 14.0]
    category: "Diabetes"
    color: "red"
Classification Results (type)
ocaml
Copy
Edit
type classification_result = {
  input_value: string;  (* Input value as string *)
  category: string;     (* Classification category *)
  confidence: string;   (* Confidence level *)
  engine: string;       (* Engine used *)
}
Example output

yaml
Copy
Edit
Classification Result for diabetes = 6.00:
  Category: Prediabetes
  Confidence: Runtime_Fast
Dependencies
OCaml (>= 4.14)

Dune (>= 3.0)

Coq (for mathematical verification)

Yojson

Installation
bash
Copy
Edit
git clone https://github.com/dhwcmoore/VeriBound_process_design.git
cd VeriBound_process_design
dune build
Test installation:

python
Copy
Edit
dune exec -- bin/main.exe test-pipeline --all-domains
Contributing
Add a domain

Create YAML in boundary_logic/domain_definitions/

Follow the format above

dune exec -- bin/main.exe verify <domain>

dune build @all

Guidelines

Boundaries must be non-overlapping and complete

Global bounds cover all valid inputs

Categories meaningful, with units/descriptions

Testing

python
Copy
Edit
dune exec -- bin/main.exe verify diabetes
dune exec -- bin/main.exe test-pipeline --all-domains
dune build @all
Current Status
Version: 2.0 – Fully operational

Build: compiles

Tests: passing

CLI: inspect / verify / test-pipeline

Coq: integrated (VerifiedBoundaryHelpers.vo)

Multi-domain: 21 domains operational

Pipeline (recent): all domains loaded successfully.

License
Apache-2.0. © 2025 Duston Moore

Architecture Diagram
If present, see images/veribound_architecture_graph.svg.

Validation Check
Always run ./test_all_domains.sh before committing. Add --show-process for detailed traces.

