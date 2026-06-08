# Beginner guide

This repository uses Lean files, shell scripts, and a tiny Python simulation.

Read this before trusting any formal-looking statement.

## What the artifact proves

Only the tiny examples in `LoRARobustness/ToyExample.lean` are real toy proofs.

## What the artifact specifies

`LoRARobustness/FormulaBook.lean` records the shape of the formulas from the LoRA robustness framework. Many objects are placeholders named with `opaque`, and some central statements are assumptions named with `axiom`.

## What the scripts reproduce

The scripts reproduce a deterministic toy table under `logs/toy_lora_privacy_results.csv`. This is not a BERT/GLUE reproduction.

## First command

```bash
bash scripts/reviewer_quickstart.sh
```
