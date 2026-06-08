#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import math
import os
import random
from dataclasses import dataclass
from typing import Iterable

@dataclass(frozen=True)
class Row:
    rank: int
    init_scale: float
    attack: str
    mechanism: str
    utility: float
    backdoor_asr: float
    mia_advantage: float
    note: str

def clamp(x: float, lo: float = 0.0, hi: float = 1.0) -> float:
    return max(lo, min(hi, x))

def toy_metrics(rank: int, init_scale: float, attack: str, mechanism: str, rng: random.Random) -> Row:
    capacity = math.log2(rank + 1.0) / math.log2(513.0)
    smoothness = clamp(1.0 - 0.70 * capacity - 0.20 * init_scale)
    dp = 1.0 if mechanism == 'dp_noise' else 0.0
    pac = 1.0 if mechanism == 'paczero_sign' else 0.0
    utility = 0.86 + 0.08 * capacity - 0.03 * init_scale
    backdoor_asr = 0.0
    if attack == 'backdoor':
        backdoor_asr = 0.65 - 0.45 * smoothness - 0.10 * dp - 0.08 * pac
        utility -= 0.02
        note = 'toy: low rank/init plus DP/PAC sign reduces backdoor ASR'
    elif attack == 'untargeted_poisoning':
        utility -= 0.18 * smoothness + 0.06 * dp + 0.03 * pac
        note = 'toy: smoother low-rank bottleneck is more brittle to UPA'
    else:
        note = 'toy: clean setting'
    mia_advantage = 0.18 + 0.07 * capacity + 0.03 * init_scale - 0.10 * dp - 0.12 * pac
    utility += rng.uniform(-0.003, 0.003)
    backdoor_asr += rng.uniform(-0.003, 0.003)
    mia_advantage += rng.uniform(-0.003, 0.003)
    return Row(rank, init_scale, attack, mechanism, round(clamp(utility), 4), round(clamp(backdoor_asr), 4), round(clamp(mia_advantage), 4), note)

def generate(seed: int) -> list[Row]:
    rng = random.Random(seed)
    rows: list[Row] = []
    for rank in [4, 8, 16, 64, 512]:
        for init_scale in [0.001, 0.333, 1.0, 2.0]:
            for attack in ['clean', 'backdoor', 'untargeted_poisoning']:
                for mechanism in ['none', 'dp_noise', 'paczero_sign']:
                    rows.append(toy_metrics(rank, init_scale, attack, mechanism, rng))
    return rows

def write_csv(rows: Iterable[Row], out_path: str) -> None:
    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    with open(out_path, 'w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=list(Row.__dataclass_fields__.keys()))
        writer.writeheader()
        for row in rows:
            writer.writerow(row.__dict__)

def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument('--seed', type=int, default=20260608)
    parser.add_argument('--out', default='logs/toy_lora_privacy_results.csv')
    args = parser.parse_args()
    rows = generate(args.seed)
    write_csv(rows, args.out)
    print(f'wrote {len(rows)} rows to {args.out}')
    print('IMPORTANT: this is a toy executable workflow, not BERT/GLUE reproduction.')

if __name__ == '__main__':
    main()
