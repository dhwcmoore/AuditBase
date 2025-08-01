#!/bin/bash
echo "🔍 VeriBound Priority 4A: Testing All Domains"
echo "=============================================="

domains=(boundary_logic/domain_definitions/*.yaml)
total_domains=${#domains[@]}
issues_found=0

for domain in "${domains[@]}"; do
    echo ""
    echo "Testing: $(basename "$domain" .yaml)"
    echo "----------------------------------------"
    result=$(dune exec test_runner/test_overlap_check.exe -- "$domain" 2>/dev/null)
    
    if echo "$result" | grep -q "⚠️ Found"; then
        echo "$result" | grep -E "(✓ Domain loaded|⚠️ Found|Gap|Overlap)"
        ((issues_found++))
    else
        echo "$result" | grep -E "(✓ Domain loaded|✅ No boundary)"
    fi
done

echo ""
echo "=============================================="
echo "�� SUMMARY: $issues_found domains with issues out of $total_domains tested"
