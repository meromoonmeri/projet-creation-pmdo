#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Compacte les frames de rendu en APNG sans perte (pixel-perfect).

Pour chaque ground rendu :
  * frame_000.png conservé (référence statique) ;
  * si animé : animation.apng = TOUTES les frames rendues (période minimale
    réelle si <= cap, sinon cap + animation_frames.png déjà exhaustive par
    tuile) — APNG est sans perte, chaque frame reste exacte ;
  * les frame_001..N.png sont supprimés après vérification que l'APNG
    contient exactement le même nombre de frames.

Met à jour render_report.json (packed=true, apng_frames=N).
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[2]


def pack_campaign(camp: str) -> None:
    rdir = ROOT / "dev" / "CAMPAIGNS" / camp / "Renders"
    report_p = rdir / "render_report.json"
    report = json.loads(report_p.read_text())
    changed = 0
    for r in report["renders"]:
        if "error" in r:
            continue
        gdir = rdir / r["ground"]
        frames = sorted(gdir.glob("frame_*.png"))
        if len(frames) <= 1:
            continue
        imgs = [Image.open(f) for f in frames]
        apng = gdir / "animation.apng"
        # 166 ms ~ 10 ticks à 60fps (durée d'affichage indicative pour
        # l'inspection ; le timing runtime réel reste FrameLength du ground)
        imgs[0].save(apng, save_all=True, append_images=imgs[1:],
                     duration=166, loop=0)
        # Vérification: PIL fusionne les frames identiques consécutives en
        # une frame à durée cumulée (sans perte visuelle ni temporelle).
        # L'APNG doit contenir exactement le nombre de frames VISUELLEMENT
        # distinctes consécutives de la séquence rendue.
        import hashlib
        hashes = [hashlib.md5(f.read_bytes()).hexdigest() for f in frames]
        expected = 1 + sum(1 for i in range(1, len(hashes))
                           if hashes[i] != hashes[i - 1])
        check = Image.open(apng)
        n = getattr(check, "n_frames", 1)
        if n != expected:
            raise RuntimeError(
                f"{r['ground']}: APNG {n} frames != {expected} distinctes "
                f"consécutives ({len(frames)} rendues)")
        for f in frames[1:]:
            f.unlink()
        r["packed_apng"] = True
        r["apng_frames"] = n
        r["apng_rendered_frames"] = len(frames)
        changed += 1
    report_p.write_text(json.dumps(report, indent=1))
    print(f"{camp}: {changed} grounds compactés en APNG")


def main() -> int:
    for camp in ("PMD_RED_RESCUE_TEAM", "PMD_SKY_EXPLORERS"):
        pack_campaign(camp)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
