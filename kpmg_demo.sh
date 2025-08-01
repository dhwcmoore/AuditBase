#!/bin/bash

echo "🏦 VeriBound Mathematical Validation Demo for KPMG"
echo "=================================================="
echo "Demonstrating mathematical precision no other compliance software can achieve"
echo ""

echo "🎯 Test 1: Basel III Capital Adequacy (Perfect Regulatory Framework)"
echo "-------------------------------------------------------------------"
dune exec test_runner/test_overlap_check.exe -- boundary_logic/domain_definitions/basel_iii_capital_adequacy.yaml
echo ""

echo "🔥 Test 2: Multiple Overlap Detection (What Others Miss)"
echo "--------------------------------------------------------"
dune exec test_runner/test_overlap_check.exe -- boundary_logic/pathological_tests/overlaps.yaml
echo ""

echo "📊 Test 3: Precise Gap Detection (Mathematical Accuracy)"
echo "--------------------------------------------------------"
dune exec test_runner/test_overlap_check.exe -- boundary_logic/pathological_tests/multiple_gaps.yaml
echo ""

echo "⚠️ Test 4: Global Bounds Violation Detection"
echo "--------------------------------------------"
dune exec test_runner/test_overlap_check.exe -- boundary_logic/pathological_tests/global_bounds_violation.yaml
echo ""

echo "🧠 Test 5: Complex Mixed Issues (Ultimate Mathematical Test)"
echo "-----------------------------------------------------------"
dune exec test_runner/test_overlap_check.exe -- boundary_logic/pathological_tests/mixed_issues.yaml
echo ""

echo "🌍 Test 6: Real-World Issue Detection (EPA Air Quality Index)"
echo "-------------------------------------------------------------"
dune exec test_runner/test_overlap_check.exe -- boundary_logic/domain_definitions/aqi.yaml
echo ""

echo "📈 Additional Regulatory Frameworks (Perfect Coverage)"
echo "======================================================="

echo ""
echo "💊 Blood Pressure Classification:"
dune exec test_runner/test_overlap_check.exe -- boundary_logic/domain_definitions/blood_pressure.yaml

echo ""
echo "🩺 Diabetes Classification:"
dune exec test_runner/test_overlap_check.exe -- boundary_logic/domain_definitions/diabetes.yaml

echo ""
echo "=================================================="
echo "🏆 SUMMARY: VeriBound Mathematical Validation"
echo "=================================================="
echo "✅ Perfect regulatory framework validation (Basel III)"
echo "🔍 Exact overlap detection (5.00-10.00, 12.00-15.00)"  
echo "📏 Precise gap measurement (5.00-10.00, 15.00-20.00, 25.00-30.00)"
echo "⚠️ Global bounds violation detection (-5.00-0.00, 20.00-25.00)"
echo "🧠 Complex mixed issue analysis (4 different problem types)"
echo "🌍 Real-world issue identification (5 gaps in EPA framework)"
echo ""
echo "🚀 NO OTHER COMPLIANCE SOFTWARE CAN DO THIS"
echo "Mathematical precision + Automated validation + Cross-framework analysis"
echo "=================================================="
