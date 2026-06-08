#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

python3 reproducibility/toy_lora_privacy_sim.py --seed 20260608 --out logs/toy_lora_privacy_results.csv

python3 - <<'PY'
import csv
from collections import defaultdict
path = 'logs/toy_lora_privacy_results.csv'
with open(path, newline='', encoding='utf-8') as f:
    rows = list(csv.DictReader(f))
print(f'read {len(rows)} rows from {path}')
summary = defaultdict(list)
for r in rows:
    if r['attack'] == 'backdoor':
        summary[(r['mechanism'], r['rank'])].append(float(r['backdoor_asr']))
print('mean toy backdoor_asr by mechanism/rank:')
for key in sorted(summary):
    vals = summary[key]
    print(key, round(sum(vals) / len(vals), 4))
PY
