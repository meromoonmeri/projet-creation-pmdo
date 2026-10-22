#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Extraction exhaustive des maps & textures de Kloa - Child of the Forest.

Pipeline qualitatif calqué sur l'adaptation No Name Village (GameMaker /
UndertaleModLib) — ici le jeu est Unity, l'outil d'autorité est UnityPy.

Provenance verrouillée :
  - source : meromoonmeri/BIBLIOTHEQUE@bibliotheque,
    « Kloa - Child of the Forest Demo/ » (Unity, LFS) ;
  - transport : archive codeload de la branche (contenu LFS réel inclus),
    chaque fichier vérifié contre le SHA-256 de son pointeur LFS ;
  - extraction : UnityPy (version consignée dans le manifest).

Sorties (git-ignoré, .runtime-cache/kloa/extracted/) :
  textures/<container>/<name>.png     Texture2D décodées (pixel-perfect,
                                      pas de resampling)
  sprites/<container>/<name>.png      Sprites découpés selon leur rect
  animations/<name>.json              AnimationClips : courbes sprite
                                      (PPtrKeyframes) + durées de frame
  inventory.json                      inventaire complet déterministe
  manifest.json                       provenance + hash de chaque sortie

Inventaires versionnés dans le dépôt :
  dev/docs/kloa/KLOA_ASSET_INVENTORY.json (déterministe, sans binaires)
"""
from __future__ import annotations

import hashlib
import json
import os
import sys
from collections import Counter
from pathlib import Path

import UnityPy

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / ".runtime-cache" / "kloa" / "source"
OUT = ROOT / ".runtime-cache" / "kloa" / "extracted"
DOC = ROOT / "dev" / "docs" / "kloa"


def safe_name(s: str) -> str:
    return "".join(c if c.isalnum() or c in "._-" else "_" for c in (s or "unnamed"))


def main() -> int:
    OUT.mkdir(parents=True, exist_ok=True)
    DOC.mkdir(parents=True, exist_ok=True)
    files = sorted(f for f in os.listdir(SRC)
                   if (f.startswith("sharedassets") and f.endswith(".assets"))
                   or f == "resources.assets" or f.startswith("level"))
    inventory: dict = {"schema": "new-era.kloa-asset-inventory.v1",
                       "unitypy": UnityPy.__version__,
                       "files": {}}
    manifest: dict = {}
    n_tex = n_spr = n_anim = 0
    for f in files:
        try:
            env = UnityPy.load(str(SRC / f))
        except Exception as e:
            inventory["files"][f] = {"error": str(e)[:120]}
            continue
        entry = {"textures": [], "sprites": [], "animations": []}
        for obj in env.objects:
            tname = obj.type.name
            if tname == "Texture2D":
                try:
                    d = obj.read()
                    name = safe_name(d.m_Name)
                    img = d.image
                    if img is None or img.width == 0:
                        continue
                    dest_dir = OUT / "textures" / f
                    dest_dir.mkdir(parents=True, exist_ok=True)
                    dest = dest_dir / f"{name}_{obj.path_id}.png"
                    img.save(dest)
                    h = hashlib.sha256(dest.read_bytes()).hexdigest()
                    entry["textures"].append({
                        "name": d.m_Name, "path_id": obj.path_id,
                        "width": img.width, "height": img.height,
                        "format": str(d.m_TextureFormat), "sha256": h})
                    manifest[str(dest.relative_to(OUT))] = h
                    n_tex += 1
                except Exception as e:
                    entry["textures"].append({"path_id": obj.path_id,
                                              "error": str(e)[:100]})
            elif tname == "Sprite":
                try:
                    d = obj.read()
                    name = safe_name(d.m_Name)
                    img = d.image
                    if img is None or img.width == 0:
                        continue
                    dest_dir = OUT / "sprites" / f
                    dest_dir.mkdir(parents=True, exist_ok=True)
                    dest = dest_dir / f"{name}_{obj.path_id}.png"
                    img.save(dest)
                    h = hashlib.sha256(dest.read_bytes()).hexdigest()
                    rect = d.m_Rect
                    entry["sprites"].append({
                        "name": d.m_Name, "path_id": obj.path_id,
                        "rect": [rect.x, rect.y, rect.width, rect.height],
                        "pixels_per_unit": float(d.m_PixelsToUnits),
                        "sha256": h})
                    manifest[str(dest.relative_to(OUT))] = h
                    n_spr += 1
                except Exception as e:
                    entry["sprites"].append({"path_id": obj.path_id,
                                             "error": str(e)[:100]})
            elif tname == "AnimationClip":
                try:
                    d = obj.read()
                    tree = obj.read_typetree()
                    name = safe_name(d.m_Name)
                    # Courbes PPtr (sprite frames) : la vérité des animations 2D
                    pptr = tree.get("m_PPtrCurves", [])
                    clip = {
                        "name": d.m_Name, "path_id": obj.path_id,
                        "sample_rate": tree.get("m_SampleRate"),
                        "wrap_mode": (tree.get("m_AnimationClipSettings") or {}).get("m_LoopTime"),
                        "pptr_curves": [
                            {"path": c.get("path"),
                             "attribute": c.get("attribute"),
                             "frames": [{"time": k.get("time"),
                                         "sprite_file_id": (k.get("value") or {}).get("m_PathID")}
                                        for k in c.get("curve", [])]}
                            for c in pptr],
                    }
                    dest_dir = OUT / "animations" / f
                    dest_dir.mkdir(parents=True, exist_ok=True)
                    dest = dest_dir / f"{name}_{obj.path_id}.json"
                    dest.write_text(json.dumps(clip, indent=1))
                    entry["animations"].append({
                        "name": d.m_Name, "path_id": obj.path_id,
                        "sample_rate": tree.get("m_SampleRate"),
                        "pptr_curve_count": len(pptr),
                        "frame_count": sum(len(c.get("curve", [])) for c in pptr)})
                    n_anim += 1
                except Exception as e:
                    entry["animations"].append({"path_id": obj.path_id,
                                                "error": str(e)[:100]})
        if any(entry.values()):
            inventory["files"][f] = {k: v for k, v in entry.items() if v}
        print(f"{f}: tex={len(entry['textures'])} spr={len(entry['sprites'])} "
              f"anim={len(entry['animations'])}")
    inventory["totals"] = {"textures": n_tex, "sprites": n_spr,
                           "animations": n_anim}
    (OUT / "inventory.json").write_text(json.dumps(inventory, indent=1))
    (OUT / "manifest.json").write_text(json.dumps(manifest, indent=1, sort_keys=True))
    # inventaire léger versionné (sans hash de sortie, stable)
    light = {"schema": inventory["schema"], "unitypy": inventory["unitypy"],
             "totals": inventory["totals"],
             "files": {f: {k: len(v) for k, v in e.items() if isinstance(v, list)}
                       for f, e in inventory["files"].items()}}
    (DOC / "KLOA_ASSET_INVENTORY.json").write_text(json.dumps(light, indent=1))
    print(f"\nTOTAL: {n_tex} textures, {n_spr} sprites, {n_anim} animations")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
