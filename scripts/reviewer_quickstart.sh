#!/usr/bin/env bash
set -euo pipefail

echo "Reviewer quickstart"
echo "==================="necho "This script checks packaging hygiene and runs the deterministic toy workflow."
echo

bash scripts/check_artifact.sh
bash scripts/reproduce_toy_results.sh

echo
echo "Lean/Lake check"
if command -v lake >/dev/null 2>&1; then
  lake build
else
  echo "Lake/Lean is not installed in this environment. Install Lean via elan or use the Dockerfile, then run: lake build"
fi

echo
echo "Reviewer quickstart completed."
