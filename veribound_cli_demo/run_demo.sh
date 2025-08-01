#!/bin/bash

echo "Inspecting Basel III Capital Adequacy at 9.2%"
./veribound.exe inspect basel_iii_capital_adequacy 9.2 --show-process
echo

echo "Verifying AML Cash Domain Structure"
./veribound.exe verify aml_cash --show-boundaries
echo

echo "Auditing EPA Air Quality Index for Gaps"
./veribound.exe audit-domain boundary_logic/domain_definitions/aqi.yaml --coverage-analysis
echo

echo "Running Multi-Domain Classification Pipeline"
./veribound.exe test-pipeline --all-domains --sample-values
echo

echo "CLI demonstration complete."
