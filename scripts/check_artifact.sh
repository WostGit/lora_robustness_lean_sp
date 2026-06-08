#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "== Artifact structural check =="
echo "This checks repository hygiene and the toy workflow."
echo "It does not prove scientific claims or reproduce BERT/GLUE."
echo

required_files=(
  README.md
  README_BEGINNER.md
  WHAT_LEAN_CHECKS.md
  PROOF_STATUS_TABLE.md
  CLAIMS_LEDGER.md
  FORMULA_WALKTHROUGH.md
  REPRODUCIBILITY_SCORECARD.md
  LoRARobustness.lean
  LoRARobustness/FormulaBook.lean
  LoRARobustness/PrivacyInteractions.lean
  LoRARobustness/ToyExample.lean
  reproducibility/toy_lora_privacy_sim.py
  scripts/reproduce_toy_results.sh
  lakefile.lean
  lean-toolchain
)

missing=0
for f in "${required_files[@]}"; do
  if [[ -f "$f" ]]; then
    echo "OK   $f"
  else
    echo "MISS $f"
    missing=1
  fi
done

if [[ "$missing" -ne 0 ]]; then
  echo "One or more required files are missing." >&2
  exit 1
fi

echo
echo "== Axiom and opaque visibility check =="
axiom_count=$(grep -R "^axiom " -n LoRARobustness 2>/dev/null | wc -l | tr -d ' ')
opaque_count=$(grep -R "^opaque " -n LoRARobustness 2>/dev/null | wc -l | tr -d ' ')
echo "Axiom declarations found: $axiom_count"
echo "Opaque declarations found: $opaque_count"
echo "These must remain visible because the repository labels itself as a specification, not a completed proof."

echo
echo "Structural artifact check completed."
