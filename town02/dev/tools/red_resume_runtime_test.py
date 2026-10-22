#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""red_resume_runtime_test.py — preuve automatisée de la persistance Red.

Séquence (deux PROCESSUS PMDO distincts, comme un vrai quit/relaunch) :
  1. redresume:save : NEW GAME → progression réelle jusqu'à l'état 7.0
     (CH6, Mt Thunder débloqué, Sky Tower PAS débloqué) → EnterZone vers un
     ground Red canonique (t01p02b Whiscash Pond open) → GAME:GroundSave().
  2. redresume:load : nouveau processus → LoadProgress() (sauvegarde
     DISQUE) → relecture SV.RedScenario/SV.RedUnlocked → vérifications :
     état == 7.0, mt_thunder débloqué, sky_tower NON débloqué → reprise
     réelle (set 8.0 → great_canyon débloqué).

Verdict RED_RESUME_RUNTIME_PASS émis PAR LE MOTEUR (jsonl), jamais déduit.
Sortie : dev/docs/canonical/red/resume_runtime_proof.jsonl
"""
import importlib.util
import json
import os
import pathlib
import subprocess
import sys
import time

ROOT = pathlib.Path(__file__).resolve().parents[2]
OUT = '/tmp/ground_gameplay_validator.jsonl'
PROOF = ROOT / 'dev' / 'docs' / 'canonical' / 'red' / \
    'resume_runtime_proof.jsonl'

spec = importlib.util.spec_from_file_location(
    'cd', ROOT / 'dev' / 'tools' / 'canonical_dungeon.py')
cd = importlib.util.module_from_spec(spec)
spec.loader.exec_module(cd)
env = cd.pmdo_env()
app = cd.ensure_quest_appdata()
BUNDLE = ROOT / '.runtime-cache' / 'pmdo-headless-bundle'
DUMP = str(ROOT / '.runtime-cache' / 'DumpAsset')


def run(mode, timeout=150):
    open(OUT, 'w').close()
    e = dict(env)
    e['PMDO_GROUND_VALIDATOR'] = mode
    p = subprocess.Popen(
        [str(BUNDLE / 'PMDO'), '-asset', DUMP + '/', '-appdata',
         str(app) + '/', '-quest', 'New-Era'],
        env=e, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    t0 = time.time()
    done = False
    while time.time() - t0 < timeout:
        time.sleep(2)
        txt = open(OUT).read()
        if '"event":"end"' in txt:
            done = True
            break
        if p.poll() is not None:
            break
    p.kill()
    time.sleep(1)
    return done, open(OUT).read()


lines = []
d1, t1 = run('redresume:save')
print('phase 1 (save):', 'done' if d1 else 'TIMEOUT')
print(t1)
lines += [x for x in t1.strip().splitlines() if x]
if not (d1 and 'red_resume_save_done' in t1):
    print('FAIL: sauvegarde non effectuée')
    sys.exit(1)

d2, t2 = run('redresume:load')
print('phase 2 (load, processus séparé):', 'done' if d2 else 'TIMEOUT')
print(t2)
lines += [x for x in t2.strip().splitlines() if x]
if not (d2 and 'RED_RESUME_RUNTIME_PASS' in t2
        and 'red_resume_continued' in t2):
    print('FAIL: reprise non prouvée')
    sys.exit(1)

PROOF.parent.mkdir(parents=True, exist_ok=True)
with open(PROOF, 'w') as f:
    f.write('\n'.join(lines) + '\n')
print(f'OK — preuve écrite: {PROOF}')
