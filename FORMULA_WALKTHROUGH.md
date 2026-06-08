# Formula walkthrough

This file gives a beginner-level map from the paper formulas to Lean names.

| Formula | Lean name | Meaning | What Lean checks |
|---|---|---|---|
| (1) | `empiricalRisk` | Sum of losses over training samples. | Symbolic shape. |
| (2) | `layerPreactivation`, `layerActivation` | Linear layer plus activation. | Symbolic shape. |
| (3) | `loraDeltaW` | Low-rank update `B A`. | Dimensions in the abstract matrix type. |
| (4) | `loraIntermediate` | Intermediate adapter state `A x`. | Dimensions. |
| (5) | `trainingTimeRobustnessMetric` | Expected norm of clean-vs-perturbed update difference. | Symbolic nesting of expectations. |
| (6) | `ntkFormula` | Neural tangent kernel placeholder. | Name and type. |
| (7) | `simplifiedTTRProxy` | NTK-based proxy for training-time robustness. | Symbolic shape. |
| (8) | `fisherFromParameterGradients` and axiom | Fisher/NTK bridge. | The bridge is assumed. |
| (9) | `informationBitsLogDet` | Information bits by pseudo-determinant. | Symbolic shape. |
| (10) | `renyiEntropy` | Renyi entropy shape. | Symbolic shape. |
| (11)-(14) | covariance and NTK definitions | GP/full/LoRA NTK placeholders. | Names and types. |
| (15) | `deltaResidualScalar`, `oold_ntk_relationship` | LoRA NTK as full NTK plus residual. | Relationship is assumed. |
| (16) | `backdoorGradientObjective` | Backdoor gradient alignment objective. | Symbolic shape. |
| (17) | `untargetedPoisoningGradientObjective` | Untargeted poisoning gradient objective. | Symbolic shape. |
| (18) | `approximateRenyiFromLoRAGram` | Entropy proxy from `A^T A`. | Symbolic shape. |
