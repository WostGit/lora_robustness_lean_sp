# Artifact CI summary

UTC timestamp: 2026-06-08T15:19:59Z

## Commands run

```bash
bash scripts/reviewer_quickstart.sh
lake build
```

## Generated outputs

- logs/toy_lora_privacy_results.csv: 181 lines including header

First five lines:
```csv
rank,init_scale,attack,mechanism,utility,backdoor_asr,mia_advantage,note
4,0.001,clean,none,0.8834,0.0,0.198,toy: clean setting
4,0.001,clean,dp_noise,0.881,0.0,0.096,toy: clean setting
4,0.001,clean,paczero_sign,0.8779,0.0,0.0795,toy: clean setting
4,0.001,backdoor,none,0.8584,0.2813,0.1991,toy: low rank/init plus DP/PAC sign reduces backdoor ASR
```

- logs/lean_build_status.md generated
