# Claims ledger

This ledger prevents overclaiming.

| Claim | Evidence in repo | Status |
|---|---|---|
| LoRA update has shape Delta W = B A | Lean definition and toy example | encoded and toy-checked |
| Training-time robustness metric can be written as expected update difference | Lean definition | specification |
| NTK/Fisher bridge explains robustness geometry | axiom plus notes | assumed |
| LoRA may improve backdoor robustness | paper-derived claim, not reproduced here | external/theoretical |
| LoRA may worsen untargeted poisoning robustness | paper-derived claim, not reproduced here | external/theoretical |
| DP plus LoRA may help against backdoors | qualitative interaction record | hypothesis |
| Sign-quantized privacy plus LoRA may affect poisoning and MIA | qualitative interaction record | hypothesis |
| Toy workflow is reproducible | GitHub Actions and local scripts | executable toy evidence |
