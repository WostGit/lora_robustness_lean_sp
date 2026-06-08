# Artifact manifest

## Core files

- `LoRARobustness.lean`: root Lean module.
- `LoRARobustness/FormulaBook.lean`: symbolic formula specification for formulas (1)-(18).
- `LoRARobustness/PrivacyInteractions.lean`: qualitative DP/sign-privacy interaction specification.
- `LoRARobustness/ToyExample.lean`: concrete toy Lean example with checked toy proofs.

## Reviewer files

- `README.md`: overview.
- `README_BEGINNER.md`: non-proof-reader guide.
- `WHAT_LEAN_CHECKS.md`: what Lean verifies and does not verify.
- `PROOF_STATUS_TABLE.md`: proof and assumption dashboard.
- `CLAIMS_LEDGER.md`: claim-to-evidence mapping.
- `FORMULA_WALKTHROUGH.md`: formula-by-formula map.
- `REPRODUCIBILITY_SCORECARD.md`: reproducibility layers and gaps.

## Executable files

- `scripts/reviewer_quickstart.sh`: primary reviewer command.
- `scripts/check_artifact.sh`: structural hygiene check.
- `scripts/reproduce_toy_results.sh`: deterministic toy result generator.
- `reproducibility/toy_lora_privacy_sim.py`: toy simulation.
- `Makefile`: local convenience targets.
- `Dockerfile`: containerized reproducibility path.
- `.github/workflows/artifact-ci.yml`: CI, Lean build, and generated-log commit workflow.

## Generated files

- `logs/toy_lora_privacy_results.csv`: generated toy results.
- `logs/lean_build_status.md`: generated Lean build status from CI.
- `logs/ci_summary.md`: generated CI summary.
