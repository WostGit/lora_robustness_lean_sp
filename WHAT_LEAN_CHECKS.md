# What Lean checks

Lean checks syntax and types. When a file says `def`, Lean checks that the definition is well formed. When a theorem has a proof such as `rfl`, Lean checks that proof.

Lean does not automatically prove scientific claims just because they are written in a Lean file.

## Important words

| Word | Meaning |
|---|---|
| `def` | A named definition. |
| `opaque` | A placeholder with no internal definition here. |
| `axiom` | An assumption accepted without proof. |
| theorem with `rfl` | A small proof by computation/unfolding. |

## Current status

This repository is a specification plus toy-reproducibility artifact. It is not a completed mechanized proof of the LoRA robustness paper.
