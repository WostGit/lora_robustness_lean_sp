# Reproducibility scorecard

This repository separates three layers.

1. Script-verified layer: the reviewer quickstart and toy simulation regenerate deterministic logs.
2. Lean-specification layer: formulas and claims are represented as Lean definitions, theorem interfaces, and explicit assumptions.
3. Paper-reproduction layer: full BERT/GLUE, DP-SGD, sign-quantized privacy, and attack experiments are obligations, not completed claims.

## GitHub Actions result commits

The workflow `.github/workflows/artifact-ci.yml` runs the reviewer quickstart. On pushes to `main`, it commits generated logs under `logs/` back to the repository with this commit message:

`ci: update generated artifact results [skip ci]`

The `[skip ci]` marker prevents an infinite workflow loop.

## Still required for a literal top artifact

A literal full-paper reproducibility artifact would need successful Lean build logs, proofs or justified minimal assumptions, real BERT/GLUE attack experiments, DP experiments, sign-quantized privacy experiments, raw logs, seeds, and regenerated figures.
